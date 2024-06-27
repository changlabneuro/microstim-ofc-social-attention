gaze_data = load( '/Users/nick/Downloads/Gaze_Eyes_Data.mat' );
data_root = '/Volumes/external3/data/changlab/siqi/stim';

%%

gaze_tbl = shared_utils.io.fload( fullfile(data_root, 'intermediates/gaze_data_tables/eyes.mat') );

mean_pos_before_stim = shared_utils.io.fload( fullfile(data_root, 'intermediates/mean_position_before_stim/mean_pos.mat') );
assert( size(mean_pos_before_stim, 1) == size(gaze_tbl, 1) );

%%

[~, ~, raw] = xlsread( '~/Downloads/Microstimulation neural data.xlsx' );
pl2_meta_tbl = parse_siqi_xls( raw );

%%

mua_mats = shared_utils.io.findmat( fullfile(data_root, 'intermediates/mua-revisit') );
% mua_mats = mua_mats(1:8);

lb = -0.5;
la = -0.1;
trace_lb = -0.5;
trace_la = 1;
trace_win = 10e-3;
trace_t = trace_lb:trace_win:trace_la;
trace_t = trace_t(1:end-1);

fs = 40e3;

mua_means = cell( numel(mua_mats), 1 );
mua_inds = cell( size(mua_means) );
mua_traces = cell( size(mua_means) );
pl2_meta_inds = cell( size(mua_means) );

mua_mean = nan( rows(gaze_tbl), 1 );
all_mua_traces = nan( rows(gaze_tbl), numel(trace_t) );
mua_devs = cell( numel(mua_mats), 1 );
all_mua_devs = nan( rows(gaze_tbl), 1 );

parfor i = 1:numel(mua_mats)
  shared_utils.general.progress( i, numel(mua_mats) );

  mua = shared_utils.io.fload( mua_mats{i} );
  mua = vertcat( mua{:} );
  mua.session = cellfun( @parse_day, mua.pl2_file, 'un', 0 );
  
  is_meta_session = strcmp( pl2_meta_tbl.session, mua.session{1} );
  if ( sum(is_meta_session) == 0 )
    warning( 'No pl2 meta data for "%s".', mua.session{1} );
    continue
  end
  
  assert( sum(is_meta_session) == 1 );
  meta_chan = pl2_meta_tbl.channel(is_meta_session);

  chans = mua.channel;
  chans = vertcat( chans{:} );
  use_chan = find( chans == meta_chan );  
  assert( ~isempty(use_chan) );

  mua_trace = mua.mua{use_chan};
  mua_dev = mua.std{use_chan};

  match_day = gaze_tbl.session == mua.session{1};
  if ( nnz(match_day) == 0 )
    warning( 'No day matched "%s".', mua.session{1} );
    continue
  end
  
  assert( any(match_day) );
  stim_t = gaze_tbl.stim_time(match_day);

  t0 = floor( (stim_t + lb) * fs ) + 1;
  t1 = floor( (stim_t + la) * fs ) + 1;
  assert( all(t1 >= t0) );
  
  % spk_sample * samples_s -> spk/s  
  mua_sps = arrayfun( @(x, y) nanmean(mua_trace(x:y) .* fs), t0, t1 );
  [curr_mua_traces, ~] = mua_psth( mua_trace, stim_t, trace_lb, trace_la, trace_win, fs );
  
  mua_inds{i} = match_day;
  mua_means{i} = mua_sps;
  mua_traces{i} = curr_mua_traces;
  mua_devs{i} = mua_dev;
  pl2_meta_inds{i} = repmat( find(is_meta_session), size(mua_sps) );
end

for i = 1:numel(mua_inds)
  mua_mean(mua_inds{i}) = mua_means{i};
  all_mua_traces(mua_inds{i}, :) = mua_traces{i};
  all_mua_devs(mua_inds{i}) = mua_devs{i};
end

gaze_tbl.pl2_rating = nan( size(mua_mean) );
for i = 1:numel(mua_inds)
  assert( all(isnan(gaze_tbl.pl2_rating(mua_inds{i}))) );
  gaze_tbl.pl2_rating(mua_inds{i}) = pl2_meta_tbl.rating(pl2_meta_inds{i});
end

%%  

[I, C] = findeach( gaze_tbl, 'session' );

%%

[I, id, C] = rowsets( 2, gaze_tbl, {'stim_type', 'pl2_rating'}, {'region'}, 'to_string', true );
[PI, PL] = plots.nest2( id, I, C );

figure(1); clf;
axs = plots.panels( numel(PI) );
for i = 1:numel(PI)
  [g, v] = ungroupi( PI{i} );
  h = gscatter( axs(i), log(mua_mean(v)), all_mua_devs(v), g );
  arrayfun( @(x, y) set(x, 'displayname', char(y)), h, PL{i, 2} );
  title( axs(i), PL{i, 1} );
end

%%

y = struct2table( load('patients') );
y.AgeRounded = round( y.Age, -1 );
[I, id, L] = rowsets( 3, y, {'AgeRounded'}, {'Smoker', 'Gender'}, 'SelfAssessedHealthStatus', 'to_string', true, 'preserve', 2 );
[PI, PL] = plots.nest3( id, I, L );

ms = nested_rowifun( @mean, PI, y.Diastolic );
errs = nested_rowifun( @std, PI, y.Diastolic );
figure(1); clf; axs = plots.panels( numel(PI), true );
plots.simple_barsets( axs, ms, errs, PL );
set( axs, 'xticklabelrotation', 15 );

%%

hl_days = { '01072020', '01172020', '08022019', '08232019', '09282019' ...
  , '02062020', '12162019', '02032022', '03172022', '07312019' };

%%

[I, C] = findeach( gaze_tbl, {'region', 'session', 'pl2_rating'} );
mean_devs = rowifun( @mean, I, all_mua_devs );
mean_mua = rowifun( @mean, I, mua_mean );

suspect = mean_mua < prctile( mean_mua, 5 );
suspect_sesh = unique( C.session(suspect) );
suspect(:) = true;

[I, id, C] = rowsets( 3, C, {'region'}, {'pl2_rating'}, {'session', 'region'}, 'mask', suspect );
[PI, PL] = plots.nest2( id, I, plots.cellstr_join(C) );
seshs = vertcat( C{:, end} );

figure(1); clf;
axs = plots.panels( numel(PI) );
for i = 1:numel(PI)
  [g, v] = ungroupi( PI{i} );
  gscatter( axs(i), mean_mua(v), mean_devs(v), PL{i, 2}(g) );
  title( axs(i), PL{i, 1} );
end

reg_I = findeach( id, 1 );
regs = vertcat( C{:, 1} );
for idx = 1:numel(reg_I)
  for i = 1:numel(hl_days)
    ind = seshs.session == hl_days{i} & strcmp(regs.region, PL{idx, 1});
    if ( sum(ind) )
      hold( axs(idx), 'on' );
      v = I{ind};
      h = scatter( axs(idx), mean_mua(v), mean_devs(v), 'o' );
      set( h, 'SizeData', 128, 'markeredgecolor', 'k' );
      text( axs(idx), mean_mua(v), mean_devs(v), hl_days{i} );
    end
  end
end

ylabel( 'Mua std threshold' );
xlabel( 'Mean mua before time 0' );
ylim( axs, [0, 0.1] );
shared_utils.plot.match_xlims( axs );
% xlim( axs, [0, 400] );

%%

reg_I = findeach( gaze_tbl, 'session' );

for idx = 1:numel(reg_I)

[I, id, C] = rowsets( 1, gaze_tbl, {'region', 'session', 'pl2_rating'}, 'mask', reg_I{idx} );
mean_mua = mua_mean;

mean_mua(mean_mua == 0) = nan;
bins = linspace( 0, 1e3, 200 );

std_thresh = unique( all_mua_devs(reg_I{idx}) );
assert( numel(std_thresh) == 1 );

% mean_devs = rowifun( @mean, I, all_mua_devs );
% mean_mua = rowifun( @mean, I, mua_mean );

% [I, id, C] = rowsets( 1, gaze_tbl, {'region'} );
[PI, PL] = plots.nest1( id, I, plots.cellstr_join(C) );

clf;
axs = plots.panels( numel(PI) );
for i = 1:numel(PI)
  [g, v] = ungroupi( PI{i} );  
  bi = discretize( mean_mua(v), bins );
  cts = zeros( 1, numel(bins) );
  for j = 1:numel(bi)
    if ( ~isnan(bi(j)) )
      cts(bi(j)) = cts(bi(j)) + 1;
    end
  end
  
  if ( 1 )
    abs_b = find( v );
    ib = find( isnan(bi) );
    v(abs_b(ib)) = false;
  end
  
  bar( axs(i), bins, cts );
  med = nanmedian( mean_mua(v) );
  mu = nanmean( mean_mua(v) );
  hold( axs(i), 'on' );
  mx = max( get(axs(i), 'ylim') );
  
  text( axs(i), med, mx, sprintf('Med = %0.3f', med) );
  text( axs(i), mu, mx - diff(get(axs(i), 'ylim')) * 0.1, sprintf('Mu = %0.3f', mu) );
  
  shared_utils.plot.add_vertical_lines( axs(i), [med, mu] );
  title( axs(i), sprintf('%s | std thresh: %0.3f', PL{i, 1}, std_thresh) );
end

xlim( [-250, 1e3] );
xlabel( 'Mean mua before time 0' );

if ( 1 )
  save_lab = sprintf( '%s.mat', char(plots.cellstr_join(C)) );
  save_p = fullfile( data_root, 'plots', 'mua_hist', dsp3.datedir );
  shared_utils.io.require_dir( save_p );
  shared_utils.plot.save_fig( gcf, fullfile(save_p, save_lab), {'png', 'fig'}, true );
end

end

%%  plot mua psths

edges = [0, 5, 10, 15, 20];
dist = bfw.px2deg( gaze_tbl.m1_average_distance_to_eyes );
dist_bi = discretize( dist, edges );

mua_tbl = gaze_tbl;
mua_tbl.distance_bin = dist_bi;

site_I = findeach( mua_tbl, 'session', ~isnan(dist_bi) );
% site_I = site_I(1);

figure(1); clf;

smooth_func = @identity;
smooth_subdir = '';
if ( 1 )  
  smooth_func = @(x) smoothdata(x, 2, 'movmean', 5);
  smooth_subdir = 'smoother';
end

err_func = @(x) std(x, [], 1);
err_subdir = '';
if ( 1 )
  err_func = @(x) nan(1, size(x, 2));
  err_subdir = 'no_sem';
end

for i = 1:numel(site_I)
  
fprintf( '\n %d of %d', i, numel(site_I) );

si = site_I{i};
[I, id, C] = rowsets( 2, mua_tbl ...
  , {'region', 'stim_type', 'session', 'pl2_rating'}, {'distance_bin'} ...
  , 'mask', si ...
);

L = plots.cellstr_join( C );
[~, ord] = sortrows( L );
[I, id, L] = rowref_many( ord, I, id, L );
[PI, PL] = plots.nest2( id, I, L );
axs = plots.simplest_linesets( trace_t, all_mua_traces, PI, PL ...
  , 'smooth_func', smooth_func ...
  , 'error_func', err_func ...
);

sham_panels = find( cellfun(@(x) contains(x, 'sham'), PL(:, 1)) );
rest_panels = setdiff( 1:size(PL, 1), sham_panels );
sham_lims = arrayfun( @(x) get(axs(x), 'ylim'), sham_panels, 'un', 0 );
min_lim = min( cellfun(@(x) x(1), sham_lims) );
max_lim = max( cellfun(@(x) x(2), sham_lims) );

for j = 1:numel(axs)
  ylim( axs(j), [min_lim, max_lim] );
end

save_lab = char( plots.cellstr_join(C{1, 1}(:, {'region', 'session', 'pl2_rating'})) );  
if ( 1 )
  save_p = fullfile( data_root, 'plots', 'mua_traces', dsp3.datedir ...
    , sprintf('%s%s', err_subdir, smooth_subdir) );
  shared_utils.io.require_dir( save_p );
  shared_utils.plot.save_fig( gcf, fullfile(save_p, save_lab), {'png', 'fig'}, true );
end

[~, i0_t] = ismembertol( lb, trace_t );
[~, i1_t] = ismembertol( la, trace_t );
mua_means = nanmean( all_mua_traces(:, i0_t:i1_t), 2 );
[I, id, C] = rowsets( 3, mua_tbl, {'region', 'session', 'pl2_rating'}, {'stim_type'}, {'distance_bin'} ...
  , 'mask', si, 'to_string', true );
axs = plots.simplest_barsets( mua_means, I, id, C, 'error_func', @(x) plotlabeled.nansem(x) );

if ( 1 )
  save_p = fullfile( data_root, 'plots', 'mua_bars', dsp3.datedir );
  shared_utils.io.require_dir( save_p );
  shared_utils.plot.save_fig( gcf, fullfile(save_p, save_lab), {'png', 'fig'}, true );
end

end

%%

gaze_tbl.mua_mean = mua_mean;

include_pos_terms = true;
fit_each_day = true;
include_scatters = false;
include_bars = false;

x_var = 'mua_mean';
% y_var = 'mean_eye_dist';
% y_var = 'mean_interactive_latency';
% y_var = 'causal_m1m2_eyes';
% y_var = 'interlooking_interval';
% y_var = 'contra_eye_dist';
% y_var = 'ipsi_eye_dist';

log_xs = [ true, false ];
day_rating_sets = { [3, 2, 1], [3, 2], 3 };
% day_rating_sets = { [3, 2, 1] };
% y_vars = { 'm1_average_distance_to_eyes', 'interlooking_interval', 'average_interactive_latency', 'causal_m1m2_eyes' };
y_vars = { 'm1_average_distance_to_eyes' };

cs = dsp3.numel_combvec( log_xs, day_rating_sets, y_vars );

for idx = 1:size(cs, 2)
  
fprintf( '\n %d of %d', idx, size(cs, 2) );
  
c = cs(:, idx);
log_x = log_xs(c(1));
day_ratings = day_rating_sets{c(2)};
y_var = y_vars{c(3)};

X = gaze_tbl.(x_var);

if ( log_x )
  X = log( X );
  X(~isfinite(X)) = nan;
end

if ( include_pos_terms )
  X = [ X, mean_pos_before_stim ];
end

y = gaze_tbl.(y_var);
has_nan = any( isnan([X, y]), 2 );

mask = ~has_nan;
mask = true( rows(gaze_tbl), 1 );
mask = mask & ismember( gaze_tbl.pl2_rating, day_ratings );
% mask = mask & X(:, 1) < 1e3 & X(:, 1) > 0;

if ( fit_each_day )
  [I, mdl_C] = findeach( gaze_tbl, {'stim_type', 'region', 'session', 'pl2_rating'}, mask );
else
  [I, mdl_C] = findeach( gaze_tbl, {'stim_type', 'region'}, mask );
end

lms = cell( size(I) );
store_I = I;
for i = 1:numel(I)
  if ( include_pos_terms )
    lms{i} = fitglm( X(I{i}, :), y(I{i}), 'y ~ x1+x2+x3' );
  else
    lms{i} = fitlm( X(I{i}), y(I{i}) ); 
  end
end

%%

str_day_ratings = strjoin( string(day_ratings), ' | ' );

%%

if ( fit_each_day )
  model_var_sets = { 'r2', 'beta' };
  do_stim_minus_sham_sets = [true, false];
  set_combs = dsp3.numel_combvec( model_var_sets, do_stim_minus_sham_sets );
  
  for si = 1:size(set_combs, 2)  
    sc = set_combs(:, si);

    model_var = model_var_sets{sc(1)};
    do_stim_minus_sham = do_stim_minus_sham_sets(sc(2));

    switch ( model_var )
      case 'beta'
        model_stat = main_model_betas( lms );
      case 'r2'
        model_stat = model_r2( lms );
      otherwise
        error( 'Unrecognized model var' );
    end
    
    min_stat = min( model_stat );
    max_stat = max( model_stat );
    bins = linspace( min_stat, max_stat+eps(max_stat), 50 );

    if ( do_stim_minus_sham )
      [stim_delta, sub_C] = stim_minus_sham_difference( model_stat, mdl_C );
    else
      stim_delta = model_stat;
      sub_C = mdl_C;
    end
    [I, C] = findeach( sub_C, {'region', 'stim_type'} );
    clf;
    axs = plots.panels( numel(I) );
    meds = nan( size(axs) );
    ps = nan( size(meds) );
    for i = 1:numel(axs)
      hist_dat = stim_delta(I{i});
      hcs = histc( hist_dat, bins );
      assert( ~any(isnan(hcs)) );
%       hist( axs(i), stim_delta(I{i}), 20 );
      bar( axs(i), bins, hcs );
      title( axs(i), sprintf('%s, %s', model_var, char(plots.cellstr_join(C(i, :)))) );
      meds(i) = nanmedian( hist_dat );
      ps(i) = signrank( hist_dat );
    end
    shared_utils.plot.match_xlims( axs );
    shared_utils.plot.match_ylims( axs );
    for i = 1:numel(axs)
      hold( axs(i), 'on' );
      shared_utils.plot.add_vertical_lines( axs(i), meds(i), 'r--' );
      lims = get( axs(i), 'ylim' );
      text( axs(i), meds(i), max(lims) - diff(lims) * 0.1, sprintf('M = %0.3f, p = %0.3f', meds(i), ps(i)) );
    end

    if ( 1 )
      set_str = sprintf( '%s_%s', model_var, ternary(do_stim_minus_sham, 'stim_minus_sham', 'stim_and_sham') );
      time_str = sprintf( '%d_%d', lb*1e3, la*1e3 );
      sig_str = '';
      save_p = fullfile( data_root, 'plots', dsp3.datedir, sprintf('hist_per_day_model_%s', time_str), y_var, set_str );
      fname = sprintf( '%sdays_%s_x_%s_y_%s_log_x_%d', sig_str, str_day_ratings, x_var, y_var, log_x );
      shared_utils.io.require_dir( save_p );
      shared_utils.plot.save_fig( gcf, fullfile(save_p, fname), {'png', 'fig'}, true );
    end  
  end
end

%%

if ( fit_each_day )
  betas = cellfun( @(x) x.Coefficients.Estimate(2:end), lms, 'un', 0 );
  ps = cellfun( @(x) x.Coefficients.pValue(2:end), lms, 'un', 0 );
  
  if ( include_scatters )
    [I, C] = findeach( mdl_C, {'session', 'region', 'pl2_rating'} );
    for i = 1:numel(I)
      any_sig = scatter_model_output( lms, mdl_C, store_I, I{i} );
      
      if ( 1 )
        time_str = sprintf( '%d_%d', lb*1e3, la*1e3 );
        sig_str = ternary( false, '(s)', '' );
        save_p = fullfile( data_root, 'plots', dsp3.datedir, sprintf('per_day_model_scatter_%s', time_str), y_var );
        fname = sprintf( '%s_x_%s_y_%s_log_x_%d', sig_str, x_var, y_var, log_x );
        fname = sprintf( '%s_%s', fname, strjoin(C{i, :}, '_') );
        shared_utils.io.require_dir( save_p );
        shared_utils.plot.save_fig( gcf, fullfile(save_p, fname), {'png', 'fig'}, true );
      end
    end
  end
  
  if ( include_bars )
    is_sig = cellfun( @(x) x < 0.05, ps, 'un', 0 );
    sig_target = cellfun( @(x) x(1), is_sig );
    sig_rest = cellfun( @(x) any(x(2:end)), is_sig );

    [I, C] = findeach( mdl_C, {'stim_type', 'region'} );
    freqs_target = rowifun( @(x) sum(x) / numel(x), I, double(sig_target) );
    freqs_rest = rowifun( @(x) sum(x) / numel(x), I, double(sig_rest) );

    f = fcat.from( cellstr(C{:, :}), C.Properties.VariableNames );
    f = repset( addcat(f, 'term'), 'term', {x_var, 'position'} );

    pl = plotlabeled.make_common();
    axs = pl.bar( [freqs_target; freqs_rest]*100, f, 'stim_type', 'region', {'term'} );
    ylabel( axs(1), sprintf('%% significant cells using %s', y_var) );

    if ( 1 )
      time_str = sprintf( '%d_%d', lb*1e3, la*1e3 );
      sig_str = ternary( false, '(s)', '' );
      save_p = fullfile( data_root, 'plots', dsp3.datedir, sprintf('per_day_model_%s', time_str), y_var );
      fname = sprintf( '%sdays_%s_x_%s_y_%s_log_x_%d', sig_str, str_day_ratings, x_var, y_var, log_x );
      shared_utils.io.require_dir( save_p );
      shared_utils.plot.save_fig( gcf, fullfile(save_p, fname), {'png', 'fig'}, true );
    end
  end
else
  clf;
  axs = plots.panels( numel(I), true );
  any_sig = false;
  for i = 1:numel(I)
    mdl = lms{i};
    x0 = mdl.Coefficients.Estimate(1);
    x1 = mdl.Coefficients.Estimate(2);

    lab = strjoin( mdl_C{i, :}, ' | ' );
    p_term = mdl.Coefficients.pValue(2);
    if ( p_term < 0.05 )
      sig_str = '(*)';
      any_sig = true;
    else
      sig_str = '';
    end

    sig_pos_str = '';
    if ( include_pos_terms && any(mdl.Coefficients.pValue(3:end) < 0.05) )
      sig_pos_str = ' (x or y pos sig)';
    end

    scatter( axs(i), X(I{i}), y(I{i}) );
    hold( axs(i), 'on' );
    lx = get( axs(i), 'xlim' );
    ly = polyval( [x1, x0], lx );
    plot( axs(i), lx, ly );
    title_lab = sprintf( '%s%s (day ratings %s)%s', lab, sig_str, str_day_ratings, sig_pos_str );
    title( axs(i), title_lab );
  end

  shared_utils.plot.match_ylims( axs );
  shared_utils.plot.match_xlims( axs );
  xlabel( axs(1), strrep(x_var, '_', ' ') );
  ylabel( axs(1), strrep(y_var, '_' ,' ') );

  if ( 1 )
    time_str = sprintf( '%d_%d', lb*1e3, la*1e3 );
    sig_str = ternary( any_sig, '(s)', '' );
    save_p = fullfile( data_root, 'plots', dsp3.datedir, sprintf('model_%s', time_str), y_var );
    fname = sprintf( '%sdays_%s_x_%s_y_%s_log_x_%d', sig_str, str_day_ratings, x_var, y_var, log_x );
    shared_utils.io.require_dir( save_p );
    shared_utils.plot.save_fig( gcf, fullfile(save_p, fname), {'png', 'fig'}, true );
  end
end

end

%%

function betas = main_model_betas(mdls)
betas = cellfun( @(x) x.Coefficients.Estimate(2), mdls );
end

function r2 = model_r2(mdls)
r2 = cellfun( @(x) x.Rsquared.AdjGeneralized, mdls );
end

function [stim_delta, sub_C] = stim_minus_sham_difference(x, mdl_C)
assert( numel(x) == size(mdl_C, 1) );

[I, sub_C] = findeach( mdl_C, setdiff(mdl_C.Properties.VariableNames, 'stim_type') );
sub_C.stim_type = repmat( "stim-minus-sham", rows(sub_C), 1 );

stim_delta = nan( numel(I), 1 );

for i = 1:numel(I)
  stim_ind = intersect( find(mdl_C.stim_type == 'stim'), I{i} );
  sham_ind = intersect( find(mdl_C.stim_type == 'sham'), I{i} );
  assert( numel(stim_ind) == 1 && numel(sham_ind) == 1 );
  stim_delta(i) = x(stim_ind) - x(sham_ind);
end

end

function any_sig = scatter_model_output(lms, mdl_C, I, mask)

[is, panel_c] = findeach( mdl_C, {'session', 'region', 'pl2_rating', 'stim_type'}, mask );
clf;
axs = plots.panels( numel(is) );
for j = 1:numel(is)
  mdl = lms{is{j}};
  xi = I{is{j}};
  scatter( axs(j), X(xi, 1), y(xi) );
  hold( axs(j), 'on' );
  lx = get( axs(j), 'xlim' );
  x0 = mdl.Coefficients.Estimate(1);
  x1 = mdl.Coefficients.Estimate(2);
  ly = polyval( [x1, x0], lx );
  plot( axs(j), lx, ly );

  p_term = mdl.Coefficients.pValue(2);
  if ( p_term < 0.05 )
    sig_str = '(*)';
    any_sig = true;
  else
    sig_str = '';
  end

  sig_pos_str = '';
  if ( include_pos_terms && any(mdl.Coefficients.pValue(3:end) < 0.05) )
    sig_pos_str = ' (x or y pos sig)';
  end

  lab = strjoin( panel_c{j, :}, ' | ' );
  title_lab = sprintf( '%s%s%s', lab, sig_str, sig_pos_str );
  title( axs(j), title_lab );
  xlabel( axs(j), x_var );
  ylabel( axs(j), y_var );
end

end

function s = parse_day(fname)

f = strrep( fname, '.pl2', '' );
tf = isstrprop( f, 'digit' );
s = f(tf);

end