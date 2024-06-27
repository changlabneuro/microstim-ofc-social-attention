data_root = '/Volumes/external3/data/changlab/siqi/stim';

int_p = fullfile( data_root, 'intermediates' );

% psth_ps = { 'mua_psth/5_ms', 'dot_mua_psth/5_ms' };
% psth_types = { 'eyes', 'dot' };

% psth_ps = { 'mua_psth/5_ms_eye_events/all_rois', 'mua_psth/5_ms_dot_events/all_rois' };
psth_ps = { 'mua_psth/25_ms_eye_events/all_rois', 'mua_psth/25_ms_dot_events/all_rois' };
psth_types = { 'eyes', 'dot' };

if ( 0 )
  psth_ps = psth_ps(1);
  psth_types = psth_types(1);
end

tot_tbl = table();

for idx = 1:numel(psth_ps)

mua_psth_p = fullfile( int_p, psth_ps{idx} );
mua_fs = shared_utils.io.findmat( mua_psth_p );

tmp_tbl = cell( numel(mua_fs), 1 );
for i = 1:numel(mua_fs)
  fprintf( '\n %d of %d', i, numel(mua_fs) );
  mua_tbl = shared_utils.io.fload( mua_fs{i} );
  mua_tbl.psth_type = repmat( string(psth_types(idx)), rows(mua_tbl), 1 );
  tmp_tbl{i} = mua_tbl;
end

tot_tbl = [ tot_tbl; vertcat(tmp_tbl{:}) ];

end

%%

days_tbl = get_day_labels();

tot_monks = cell( rows(tot_tbl), 1 );
for i = 1:size(days_tbl, 1)
  sesh_ind = tot_tbl.session == days_tbl.session{i};
  tot_monks(sesh_ind) = days_tbl.monkey(i);
end

tot_tbl.monkey = string( tot_monks );

outlier_sesh = shared_utils.io.fload(...
  fullfile(int_p, 'mua_outlier_sessions', 'outlier_sessions.mat') );

tot_tbl.is_outlier_session = false( rows(tot_tbl), 1 );
[I, C] = findeach( tot_tbl, 'session' );
for i = 1:numel(I)
  outlier_ind = outlier_sesh.session == C.session(i);
  assert( nnz(outlier_ind) == 1 );
  tot_tbl.is_outlier_session(I{i}) = outlier_sesh.is_outlier(outlier_ind);
end

%%

neg_sign = tot_tbl.hemifield_distance < 0;
pos_sign = tot_tbl.hemifield_distance > 0;

is_tar = tot_tbl.monkey == 'tarantino';
is_lynch = tot_tbl.monkey == 'lynch';

contra_ipsi = strings( numel(neg_sign), 1 );
contra_ipsi(is_tar & neg_sign) = 'contra';
contra_ipsi(is_tar & pos_sign) = 'ipsi';

contra_ipsi(is_lynch & neg_sign) = 'contra';
contra_ipsi(is_lynch & pos_sign) = 'ipsi';

tot_tbl.hemifield_label = contra_ipsi;

%{

mean activity in 1st or 2nd bin after 0.2 (after end of stim) to 0.4
  correlate to distance (m1_average_distance_to_eyes)
maybe look at recovery time compared to baseline or pre-stim, then
  correlate with distance (?)

stim - sham dot activity
stim - sham eye activity (either fixations or just whole period)

%}

%%

model_each = { 'session', 'roi', 'stim_type', 'region', 'monkey' };
mask = ~tot_tbl.is_outlier_session;
mask = mask & tot_tbl.roi == 'eyes_nf';
mask = mask & (tot_tbl.event_time - tot_tbl.stim_time < 1.5);

[auc_I, auc_C] = findeach( tot_tbl, model_each, mask );
aucs = nan( numel(auc_I), size(tot_tbl.psth, 2) );
t_ps = nan( size(aucs) );

for i = 1:numel(auc_I)
  fprintf( '\n %d of %d', i, numel(auc_I) );
  
  mi = auc_I{i};
  eye_ind = intersect( mi, find(tot_tbl.psth_type == 'eyes') );
  dot_ind = intersect( mi, find(tot_tbl.psth_type == 'dot') );
  
  rois = [ zeros(numel(eye_ind), 1); ones(numel(dot_ind), 1) ];
  tmp_aucs = nan( 1, size(tot_tbl.psth, 2) );
  tmp_t_ps = nan( size(tmp_aucs) );
  
  if ( numel(unique(rois)) > 1 )
    for j = 1:size(tmp_aucs, 2)    
      x = [ tot_tbl.psth(eye_ind, j); tot_tbl.psth(dot_ind, j) ];
      [~, ~, ~, tmp_aucs(j)] = perfcurve( rois, x, 1 );
      
      xt = x(rois == 0);
      yt = x(rois == 1);
      tmp_t_ps(j) = ranksum( xt, yt );
    end
  end
  
  aucs(i, :) = tmp_aucs;
  t_ps(i, :) = tmp_t_ps;
end

%%  p value heatmap

[I, id, C] = rowsets( 1, auc_C, {'region', 'stim_type', 'roi'}, 'to_string', true );


figure(1); clf;
axs = plots.panels( numel(I) );
for i = 1:numel(I)
  ind = I{i};
  t_set = t_ps(I{i}, :);
  t_set(isnan(t_set)) = 1;
  [~, peak_t] = min( t_set, [], 2 );
  [~, ord] = sort( peak_t );
  t_set = t_set(ord, :);
  
  [sig_seti, sig_setj] = find( t_set < 0.05 );
  xs = nan( numel(sig_setj), 2 );
  for j = 1:numel(sig_setj)
    xs(j, 1) = tot_tbl.psth_t{1}(sig_setj(j));
    xs(j, 2) = sig_seti(j);
  end
  
  plt_auc = imgaussfilt( t_set, 2 );
  imagesc( axs(i), tot_tbl.psth_t{1}, 1:size(t_set, 1), plt_auc );
  title( axs(i), strrep(C{i}, '_', ' ') );
  colorbar( axs(i) );
  hold( axs(i), 'on' );
  
  scatter( axs(i), xs(:, 1), xs(:, 2), 1, 'r' );
end
shared_utils.plot.match_clims( axs );

%%  auc heatmap

[I, id, C] = rowsets( 1, auc_C, {'region', 'stim_type', 'roi'}, 'to_string', true );
axs = plots.panels( numel(I) );
for i = 1:numel(I)
  ind = I{i};
  auc_set = aucs(I{i}, :);
  auc_set(isnan(auc_set)) = 0.5;
  [~, peak_t] = max( abs(auc_set - 0.5), [], 2 );
  [~, ord] = sort( peak_t );
  auc_set = abs( auc_set(ord, :) - 0.5 );
  plt_auc = imgaussfilt( auc_set, 2 );
  imagesc( axs(i), tot_tbl.psth_t{1}, 1:size(auc_set, 1), plt_auc );
  title( axs(i), strrep(C{i}, '_', ' ') );
  colorbar( axs(i) );
end
shared_utils.plot.match_clims( axs );

%%

psth_t = tot_tbl.psth_t{1};

[I, C] = findeach( auc_C, {'region', 'roi', 'session', 'monkey'} );
aucs_half = abs( aucs - 0.5 );

if ( 1 )
  C = auc_C;
  stim_minus_sham = aucs_half;
  
else
  stim_minus_sham = nan( numel(I), size(aucs, 2) );

  for i = 1:numel(I)
    stim_ind = intersect( I{i}, find(auc_C.stim_type == 'stim') );
    sham_ind = intersect( I{i}, find(auc_C.stim_type == 'sham') );
    stim_auc = nanmean( aucs_half(stim_ind, :), 1 );
    sham_auc = nanmean( aucs_half(sham_ind, :), 1 );
    stim_minus_sham(i, :) = stim_auc - sham_auc;
  end
  C.stim_type = repmat( "stim_minus_sham", rows(C), 1 );
end

reg_I = findeach( C, 'region' );
mean_diff = nanmean( stim_minus_sham(:, psth_t >= 0 & psth_t <= 0.25), 2 );
sr_ps = rowifun( @signrank, reg_I, mean_diff );

%  auc lines

bin_t = uniquetol( diff(tot_tbl.psth_t{1}) );
% [I, id, C] = rowsets( 2, auc_C, {'region', 'roi'}, {'stim_type'}, 'to_string', true );

% plt_auc = abs( aucs - 0.5 );
plt_auc = stim_minus_sham;

[I, id, C] = rowsets( 2, C, {'region', 'roi', 'monkey'}, {'stim_type'}, 'to_string', true );
[PI, PL] = plots.nest2( id, I, strrep(C, '_', ' ') );
err_func = @plotlabeled.nansem;
% err_func = @(x) nan(1, size(x,2));

figure(1); clf;
axs = plots.simplest_linesets( tot_tbl.psth_t{1}, plt_auc, PI, PL ...
  , 'summary_func', @nanmean ...
  , 'error_func', err_func ...
  , 'smooth_func', @(x) smoothdata(x, 2, 'movmean', round(200e-3 / bin_t)) ...
);
hold( axs, 'on' );
shared_utils.plot.match_ylims( axs );
shared_utils.plot.add_vertical_lines( axs, 0 );

%%  regress mua fr vs. eye distance

if ( 1 )
  psth_t_win = tot_tbl.event_spk_fr;
else
  psth_t = tot_tbl.psth_t{1};
  psth_fr = tot_tbl.psth ./ 1 / uniquetol(diff(psth_t));
  psth_t_win = nanmean( psth_fr(:, psth_t >= 0 & psth_t <= 1.5), 2 );
end

event_t = tot_tbl.event_time - tot_tbl.stim_time;

mask = ~tot_tbl.is_outlier_session;
mask = mask & event_t < 1.5;

per_hf_label = true;
model_each = { 'session', 'psth_type', 'stim_type', 'region', 'monkey' };

if ( per_hf_label )
  mask = mask & tot_tbl.hemifield_label == 'ipsi';
  model_each{end+1} = 'hemifield_label';
end

[model_I, model_C] = findeach( tot_tbl, model_each, mask );

lms = cell( size(model_I) );
terms = nan( rows(lms), 1 );
term_ps = nan( size(terms) );
perm_term_ps = nan( size(terms) );

% X = psth_t_win;
% y = tot_tbl.eye_distance;

% X = [ tot_tbl.eye_distance, tot_tbl.other_distance ];
X = [ tot_tbl.eye_distance ];
y = psth_t_win;
reps = 100;
num_folds = 10;

parfor i = 1:numel(model_I)
  fprintf( '\n %d of %d', i, numel(model_I) );
  
  mi = model_I{i};
  mdl_func = @(X, y, d) fitglm( X, y, 'link', 'log' ...
    , 'distribution', 'poisson', 'offset', log(d) );
  
%   real_term_ps = nan( num_folds, 1 );
%   for k = 1:num_folds
%     part = cvpartition( numel(mi), 'holdout', 0.90 );
% %     si = mi(part.training(k));
%     si = mi(part.training);
%     real_mdl = mdl_func( X(si, :), y(si), tot_tbl.event_duration(si) );
%     real_term_ps(k) = real_mdl.Coefficients.pValue(2);
%   end
%   
  real_mdl = mdl_func( X(mi, :), y(mi), tot_tbl.event_duration(mi) );
  real_term_p = real_mdl.Coefficients.pValue(2);
  
  terms(i) = real_mdl.Coefficients.Estimate(2);
  term_ps(i) = real_term_p;
  lms{i} = real_mdl;
  
  n_lt = 0;
  for k = 1:reps
    si = mi(randperm(numel(mi)));
    null_mdl = mdl_func( X(si, :), y(mi), tot_tbl.event_duration(mi) );
    
    term = null_mdl.Coefficients.Estimate(2);
    null_term_p = null_mdl.Coefficients.pValue(2);    
    n_lt = n_lt + double( null_term_p <= real_term_p );
%     n_lt = n_lt + double( real_mdl.Rsquared.AdjGeneralized < null_mdl.Rsquared.AdjGeneralized );
  end
  
  perm_term_ps(i) = n_lt / reps;
end

%%  p sig

panels = {'psth_type'};

if ( per_hf_label )
  panels{end+1} = 'hemifield_label';
end

% is_sig = perm_term_ps < 0.05 & term_ps < 0.05;
is_sig = perm_term_ps < 0.05;
[I, id, C] = rowsets( 3, model_C, panels, 'stim_type', 'region', 'to_string', true );

figure(1); clf;
axs = plots.simplest_barsets( double(is_sig), I, id, C ...
  , 'error_func', @(x) nan ...
);
shared_utils.plot.match_ylims( axs );
ylabel( axs(1), '% significant sites (days)' );
ylim( axs, [0,1 ] );

%%  stim sham terms paired within session

[I, pair_C] = findeach( model_C, setdiff(model_each, {'monkey', 'stim_type'}) );

r2s = cellfun( @(x) x.Rsquared.Adjusted, lms );
pair_test = r2s;
% pair_test = terms;

stims = nan( numel(I), 1 );
shams = nan( numel(I), 1 );
for i = 1:numel(I)
  stim_ind = findrows( model_C, 'stim', I{i} );
  sham_ind = findrows( model_C, 'sham', I{i} );
  stims(i) = pair_test(stim_ind);
  shams(i) = pair_test(sham_ind);
end

[reg_I, reg_C] = findeach( pair_C, {'region', 'psth_type'} );
reg_C.pair_p = nan( rows(reg_I), 1 );
reg_C.stats = cell( rows(reg_I), 1 );
reg_C.z = nan( size(reg_C.pair_p) );
for i = 1:numel(reg_I)
  ri = reg_I{i};
  [reg_C.pair_p(i), ~, reg_C.stats{i}] = signrank( stims(ri), shams(ri) );
  reg_C.z(i) = reg_C.stats{i}.zval;
end

%%

[I, id, C] = rowsets( 4, model_C, {'psth_type', 'region'}, {'stim_type'}, {}, 'session', 'to_string', true );
term_vs = terms;

figure(1); clf;
axs = plots.simplest_barsets( term_vs, I, id, C, 'error_func', @plotlabeled.nansem ...
  , 'add_points', true ...
);
shared_utils.plot.match_ylims( axs );

%%  stim-sham abs term relationships

[abs_I, abs_C] = findeach( model_C, setdiff(model_each, 'stim_type') );
term_vs = nan( numel(abs_I), 1 );

for i = 1:numel(abs_I)
  ai = abs_I{i};
  stim_ind = findrows( model_C, 'stim', ai );
  sham_ind = findrows( model_C, 'sham', ai );
  assert( numel(stim_ind) == 0 || numel(stim_ind) == 1 );
  assert( numel(sham_ind) == 0 || numel(sham_ind) == 1 );
  term_vs(i) = abs(terms(stim_ind)) - abs(terms(sham_ind));
end

[I, id, C] = rowsets( 3, abs_C, {'psth_type'}, {}, 'region', 'to_string', true );

figure(1); clf;
axs = plots.simplest_barsets( term_vs, I, id, C, 'error_func', @plotlabeled.nansem );
shared_utils.plot.match_ylims( axs );

%%

int_p = fullfile( data_root, 'intermediates' );

ps = bfw.matched_files( ...
    shared_utils.io.findmat(fullfile(int_p, 'aligned_raw_samples/position')) ...
  , fullfile(int_p, 'rois') ...
  , fullfile(int_p, 'raw_events') ...
);

fnames = shared_utils.io.filenames( ps(:, 1) );
ps = ps(~contains(fnames, 'dot_'), :);
fs = cellfun( @shared_utils.io.fload, ps, 'un', 0 );

%%

min_t = 0.2;
max_t = 5;
psth_t = tot_tbl.psth_t{1};
psth_fr = tot_tbl.psth ./ 1 / uniquetol(diff(psth_t));

dist_to_first_eyes = nan( rows(tot_tbl), 1 );
muas_to_first_eyes = nan( size(dist_to_first_eyes) );

keep_fs = find( ~contains(fnames, 'dot_') );

for i = 1:numel(keep_fs)
  fprintf( '\n %d of %d', i, size(fs, 1) );
  
  ind = keep_fs(i);
  pos_file = fs{ind, 1};
  roi_file = fs{ind, 2};
  evts_file = fs{ind, 3};
  is_dot = contains( fnames{ind}, '_dot_' );
  
  if ( is_dot )  
    search_psth_type = 'dot';
    assert( false );
  else
    search_psth_type = 'eyes';
  end
  
  eyes_roi = shared_utils.rect.center( roi_file.m1.rects('eyes_nf') );
  
  start_ts = bfw.event_column( evts_file, 'start_time' );
  stop_ts = bfw.event_column( evts_file, 'stop_time' );
  start_inds = bfw.event_column( evts_file, 'start_index' );
  stop_inds = bfw.event_column( evts_file, 'stop_index' );
  
  evt_mask = strcmp( evts_file.labels(:, strcmp(evts_file.categories, 'roi')), 'eyes_nf' ) & ...
    strcmp( evts_file.labels(:, strcmp(evts_file.categories, 'looks_by')), 'm1' );
  
  start_ts = start_ts(evt_mask);
  stop_ts = stop_ts(evt_mask);
  start_inds = start_inds(evt_mask);
  stop_inds = stop_inds(evt_mask);
  
  [sesh, run_num] = parse_unified_filename( pos_file.unified_filename );
  
  sesh_ind = tot_tbl.session == sesh;
  run_ind = tot_tbl.run == sprintf( 'run_%d', run_num );
  type_ind = tot_tbl.psth_type == search_psth_type;
  curr_ind = find( sesh_ind & run_ind & type_ind );
  
  stim_ts = tot_tbl.stim_time(curr_ind);
  
  dists = nan( numel(stim_ts), 1 );  
  for j = 1:numel(stim_ts)
    first_t_ind = find( start_ts >= stim_ts(j) + min_t & start_ts < stim_ts(j) + max_t, 1 );
    if ( isempty(first_t_ind) )
      continue;
    end
    
    [~, psth_t0] = min( abs(psth_t - start_ts(first_t_ind)) );
    [~, psth_t1] = min( abs(psth_t - stop_ts(first_t_ind)) );
    muas_to_first_eyes(curr_ind(j)) = mean( psth_fr(curr_ind(j), psth_t0:psth_t1) );

    m1_p = nanmean( pos_file.m1(:, start_inds(first_t_ind):stop_inds(first_t_ind)), 2 );
    dists(j) = nanmean( vecnorm(m1_p - eyes_roi(:), 2, 1) );
  end
  
  dist_to_first_eyes(curr_ind) = dists;
end

tot_tbl.dist_to_first_eyes = dist_to_first_eyes;
tot_tbl.muas_to_first_eyes = muas_to_first_eyes;

%%

int_p = fullfile( data_root, 'intermediates' );

ps = bfw.matched_files( ...
    shared_utils.io.findmat(fullfile(int_p, 'aligned_raw_samples/position')) ...
  , fullfile(int_p, 'aligned_raw_samples/time') ...
  , fullfile(int_p, 'rois') ...
  , fullfile(int_p, 'raw_events') ...
);

fnames = shared_utils.io.filenames( ps(:, 1) );
ps = ps(~contains(fnames, 'dot_'), :);

ss = 50e-3;
ws = 100e-3;

use_fixed_distance_twin = true;

psth_t = tot_tbl.psth_t{1};
tseries = psth_t(1):ss:psth_t(end);
bin_t0 = tseries - ws * 0.5;
bin_t1 = bin_t0 + ws;

tot_dist_tcourse = nan( rows(tot_tbl), numel(bin_t0) );
tot_psth_tcourse = nan( size(tot_dist_tcourse) );

for i = 1:size(ps, 1)
  fprintf( '\n %d of %d', i, size(ps, 1) );
  
  pos_file = shared_utils.io.fload( ps{i, 1} );
  time_file = shared_utils.io.fload( ps{i, 2} );
  roi_file = shared_utils.io.fload( ps{i, 3} );
  evts_file = shared_utils.io.fload( ps{i, 4} );
  
  start_ts = bfw.event_column( evts_file, 'start_time' );
  evt_mask = strcmp( evts_file.labels(:, strcmp(evts_file.categories, 'roi')), 'eyes_nf' ) & ...
    strcmp( evts_file.labels(:, strcmp(evts_file.categories, 'looks_by')), 'm1' );
  
  eyes_roi = shared_utils.rect.center( roi_file.m1.rects('eyes_nf') );
  
  sesh = pos_file.unified_filename(1:8);
  run_beg = 9 + numel('position_1');
  run_end = max( strfind(pos_file.unified_filename, '.') );
  run_num = str2double( pos_file.unified_filename(run_beg:run_end) );
  
  sesh_ind = tot_tbl.session == sesh;
  run_ind = tot_tbl.run == sprintf( 'run_%d', run_num );
  curr_ind = sesh_ind & run_ind;  
  
  stim_ts = tot_tbl.stim_time(curr_ind);
  curr_psth = tot_tbl.psth(curr_ind, :);
  fixed_dist = tot_tbl.m1_average_distance_to_eyes(curr_ind);
  
  dist_tcourse = nan( numel(stim_ts), numel(bin_t0) );
  psth_tcourse = nan( size(dist_tcourse) );
  
  for j = 1:numel(stim_ts)
    
    stim_rel0 = bin_t0 + stim_ts(j);
    stim_rel1 = bin_t1 + stim_ts(j);
    
    for k = 1:numel(stim_rel0)
      [~, psth_t0] = min( abs(psth_t - bin_t0(k)) );
      [~, psth_t1] = min( abs(psth_t - bin_t1(k)) );
      assert( psth_t1 >= psth_t0 );
      mu_fr = nanmean( curr_psth(j, psth_t0:psth_t1) );
      psth_tcourse(j, k) = mu_fr;
      
      if ( use_fixed_distance_twin )
        to_eye_dist = fixed_dist(j);
        
      else
        [~, ind0] = min( abs(time_file.t - stim_rel0(k)) );
        [~, ind1] = min( abs(time_file.t - stim_rel1(k)) );

        m1_p = pos_file.m1(:, ind0:ind1);
        to_eye_dist = nanmean( vecnorm(m1_p - eyes_roi(:), 2, 1) );
      end
      
      dist_tcourse(j, k) = to_eye_dist;
    end
  end
  
  tot_dist_tcourse(curr_ind, :) = dist_tcourse;
  tot_psth_tcourse(curr_ind, :) = psth_tcourse;
end

%%

bad_days = { '04192022', '03052022', '05032022', '05122022', '01212022', '03182022', '11052021' ...
  , '05262022', '01312020', '02212022', '03242022', '05272022' ...
  , '01242022', '05142022', '02032022', '02092022', '03172022' };

%%

num_devs = 1;

[sesh_I, sesh_C] = findeach( tot_tbl, {'session', 'region', 'psth_type'} );
sesh_means = cellfun( @(x) nanmean(tot_tbl.pre_stim_fr(x)), sesh_I );

I = findeach( sesh_C, {'region', 'psth_type'} );

is_outlier = false( numel(sesh_I), 1 );
for i = 1:numel(I)
  sm = log( sesh_means(I{i}) );
  mu = mean( sm );
  std_sm = std( sm );
  is_outlier(I{i}) = sm < mu - std_sm * num_devs | sm > mu + std_sm * num_devs;
end

tot_tbl.is_outlier_session = false( rows(tot_tbl), 1 );
for i = 1:numel(sesh_I)
  tot_tbl.is_outlier_session(sesh_I{i}) = is_outlier(i);
end

%%  day level recovery

min_t = 0.205;
max_t = 5;

psth_t = tot_tbl.psth_t{1};
[~, earliest_allowed_t_ind] = min( abs(psth_t - min_t) );
[~, latest_allowed_t_ind] = min( abs(psth_t - max_t) );

eval_psth = tot_tbl.psth;

mask = ~tot_tbl.is_outlier_session;
sham_sesh_I = findeach( tot_tbl, 'session', mask & tot_tbl.stim_type == 'sham' );
stim_sesh_I = findeach( tot_tbl, 'session', mask & tot_tbl.stim_type == 'stim' );
tot_sesh_I = findeach( tot_tbl, 'session', mask );

sham_stds = median( cate1(eachcell(@(x) std(eval_psth(x, :), [], 1), sham_sesh_I)), 2 );
sham_means = median( cate1(eachcell(@(x) mean(eval_psth(x, :), 1), sham_sesh_I)), 2 );
stim_means = cate1( eachcell(@(x) mean(eval_psth(x, :), 1), stim_sesh_I) );

for i = 1:size(stim_means, 1)
  if ( 1 )
    tf = psth + sham_stds(i) * 1 > sham_means(i);
    [isles, durs] = shared_utils.logical.find_islands( tf );
  end

  isles(isles < earliest_allowed_t_ind | isles > latest_allowed_t_ind) = [];
  
  if ( ~isempty(isles) )
    tot_recovery_ts(i) = psth_t(isles(1)) - min_t;
  end
end

% for 

%%  recovery

min_t = 0.205;
max_t = 5;

psth_t = tot_tbl.psth_t{1};
[~, earliest_allowed_t_ind] = min( abs(psth_t - min_t) );
[~, latest_allowed_t_ind] = min( abs(psth_t - max_t) );

eval_psth = tot_tbl.psth;
eval_psth = smoothdata( eval_psth, 2, 'movmean', max(1, floor(100e-3 / uniquetol(diff(psth_t)))) );

mask = ~tot_tbl.is_outlier_session;
sham_sesh_I = findeach( tot_tbl, 'session', mask & tot_tbl.stim_type == 'sham' );
stim_sesh_I = findeach( tot_tbl, 'session', mask & tot_tbl.stim_type == 'stim' );
tot_sesh_I = findeach( tot_tbl, 'session', mask );

sham_stds = median( cate1(eachcell(@(x) std(eval_psth(x, :), [], 1), sham_sesh_I)), 2 );
stim_stds = median( cate1(eachcell(@(x) std(eval_psth(x, :), [], 1), stim_sesh_I)), 2 );
sham_means = median( cate1(eachcell(@(x) mean(eval_psth(x, :), 1), sham_sesh_I)), 2 );

tot_sham_stds = rowdistribute( rownan(rows(tot_tbl)), tot_sesh_I, sham_stds );
tot_stim_stds = rowdistribute( rownan(rows(tot_tbl)), tot_sesh_I, stim_stds );
tot_sham_means = rowdistribute( rownan(rows(tot_tbl)), tot_sesh_I, sham_means );
tot_recovery_ts = rownan( rows(tot_tbl) );

for i = 1:size(tot_tbl, 1)
  psth = eval_psth(i, :);
  
  if ( 1 )
    tf = psth + tot_stim_stds(i) * 1 > tot_sham_means(i);
%     tf = psth > tot_sham_means(i) + tot_sham_stds(i) * 1;
%     tf = psth + tot_sham_stds(i) * 1 > tot_sham_means(i);
    if ( 0 )
      isles = find( tf );
    else
      [isles, durs] = shared_utils.logical.find_islands( tf );
    end
  else
    [~, isles] = max( psth );
  end

  isles(isles < earliest_allowed_t_ind | isles > latest_allowed_t_ind) = [];
  
  if ( ~isempty(isles) )
    tot_recovery_ts(i) = psth_t(isles(1)) - min_t;
  end
end

%%  variation

corr_I = findeach( tot_tbl, {'session', 'region', 'stim_type'} ...
  , mask & tot_tbl.stim_type == 'stim' );

%%

mask = ~tot_tbl.is_outlier_session;

[corr_I, corr_C] = findeach( tot_tbl, {'session', 'region', 'stim_type'}, mask );
med_first_dist = cellfun( @(x) nanmean(tot_tbl.dist_to_first_eyes(x)), corr_I );

[I, id, C] = rowsets( 4, corr_C, 'region', 'stim_type', {}, 'session', 'to_string', true );
% [PI, PL] = plots.nest3( id, I, C );
plots.simplest_barsets( med_first_dist, I, id, C ...
  , 'summary_func', @nanmedian ...
  , 'error_func', @plotlabeled.nansem ...
  , 'add_points', true ...
);

%%  corrs

mask = ~tot_tbl.is_outlier_session;
% mask = ~rowzeros(rows(tot_tbl));
mask = mask & tot_tbl.stim_type == 'stim';
% mask = mask & tot_tbl.monkey == 'tarantino';
% mask = mask & string(tot_tbl.region) == 'dmpfc';

[corr_I, corr_C] = findeach( tot_tbl, {'session', 'region', 'stim_type', 'monkey'}, mask );
med_recovery = cellfun( @(x) nanmedian(tot_recovery_ts(x)), corr_I );
% med_mua = cellfun( @(x) nanmedian(nanmean(tot_tbl.psth(x, psth_t > 0.2 & psth_t < 0.4), 2)), corr_I );
med_mua = cellfun( @(x) nanmedian(sum(tot_tbl.psth(x, psth_t > 0.21 & psth_t < 1.5), 2)), corr_I );
med_mua_to_first_eyes = cellfun( @(x) nanmean(tot_tbl.muas_to_first_eyes(x)), corr_I );
med_dist = cellfun( @(x) nanmedian(tot_tbl.m1_average_distance_to_eyes(x)), corr_I );
med_first_dist = cellfun( @(x) nanmean(tot_tbl.dist_to_first_eyes(x)), corr_I );

monk_I = findeach( corr_C, 'monkey' );
for i = 1:numel(monk_I)
  mi = monk_I{i};
  mx = max( med_dist(mi) );
  
%   med_dist(mi) = med_dist(mi) ./ mx;
  med_dist(mi) = zscore( med_dist(mi) );
  med_mua(mi) = zscore( med_mua(mi) );
end

[I, C] = findeach( corr_C, {'region', 'stim_type'} );
[C.r, C.p] = deal( zeros(rows(C), 1) );

figure(1); clf;
axs = plots.panels( numel(I) );
for i = 1:numel(I)
  ind = I{i};
  
  monk_i = findeach( corr_C, 'monkey', ind );
  
  colors = hsv( numel(monk_i) );
  for j = 1:numel(monk_i)
    x1 = med_mua(monk_i{j});
    x2 = med_dist(monk_i{j});
  %   x1 = med_recovery(ind);
  %   x1 = med_mua_to_first_eyes(ind);
  %   x2 = med_first_dist(ind);
  %   
  %   x1 = med_mua(ind);
  %   x2 = med_recovery(ind);

    scatter( axs(i), x1, x2, 32, colors(j, :) );
    title( axs(i), plots.cellstr_join(C(i, :)) );
    [C.r(i), C.p(i)] = corr( x1, x2, 'rows', 'complete' );

    hold( axs(i), 'on' );
    ps = polyfit( x1(~isnan(x1) & ~isnan(x2)), x2(~isnan(x1) & ~isnan(x2)), 1 );
    xs = get( axs(i), 'xtick' );
    y = polyval( ps, xs );
    h = plot( axs(i), xs, y );
    set( h, 'color', colors(j, :) );
    
    text( axs(i), mean(get(axs(i), 'xlim')), mean(get(axs(i), 'ylim')) ...
    , sprintf('r = %0.3f, p = %0.3f', C.r(i), C.p(i)) );
  end
  
  ylabel( axs(i), 'dist (px)' ); 
  xlabel( axs(i), 'mua (mean spike count)' );
end

%%

[corr_I, corr_C] = findeach( tot_tbl, {'session', 'region'}, mask & tot_tbl.stim_type == 'stim' );
[corr_C.r, corr_C.p] = deal( rownan(rows(corr_C)) );
for i = 1:numel(corr_I)
  ci = corr_I{i};
  x1 = tot_recovery_ts(ci);
  x2 = nanmean(tot_tbl.psth(ci, psth_t > 0.21 & psth_t < 0.4), 2);
%   x2 = tot_tbl.m1_average_distance_to_eyes(ci);
  [corr_C.r(i), corr_C.p(i)] = corr( x1, x2, 'rows', 'complete' );
end

[I, C] = findeach( corr_C, 'region' );
C.p_sig = zeros( rows(C), 1 );
for i = 1:numel(I)
  is_sig = corr_C.p(I{i}) < 0.05;
  C.p_sig(i) = pnz( is_sig );
  C.n_pos(i) = sum( corr_C.r(I{i}) > 0 & is_sig );
  C.n_neg(i) = sum( corr_C.r(I{i}) < 0 & is_sig );
end

%%

[plt_I, plt_C] = findeach( tot_tbl, 'region', mask & tot_tbl.stim_type == 'stim' );
figure(1); clf;
axs = plots.panels( numel(plt_I) );

fn = @nanmean;

for i = 1:numel(plt_I)
  x = tot_recovery_ts(plt_I{i});
  hist( axs(i), x, 1e3 );
  hold( axs(i), 'on' );
%   shared_utils.plot.add_vertical_lines( axs(i), fn(x) );
  text( axs(i), fn(x), max(get(axs(i), 'ylim')) - diff(get(axs(i), 'ylim')) * 0.1, sprintf('%0.3f', fn(x)) );
  title( axs(i), plots.cellstr_join(plt_C(i, :)) );
end

%%

[corr_I, corr_C] = findeach( tot_tbl, {'region', 'session', 'stim_type'} ...
  , tot_tbl.stim_type == 'stim' & ~tot_tbl.is_outlier_session ...
);

corr_C.r = nan( rows(corr_C), size(tot_psth_tcourse, 2) );
corr_C.p = nan( rows(corr_C), size(tot_psth_tcourse, 2) );

for i = 1:numel(corr_I)
  ci = corr_I{i};
  for j = 1:size(tot_psth_tcourse, 2)
    x1 = tot_psth_tcourse(ci, j);
    x2 = tot_dist_tcourse(ci, j);
    [corr_C.r(i, j), corr_C.p(i, j)] = corr( x1, x2, 'rows', 'complete' );
  end
end

[I, C] = findeach( corr_C, {'region', 'stim_type'} );
clf;
axs = plots.panels( numel(I) );
hold( axs, 'on' );

if ( 0 )
  for i = 1:numel(I)
    rs = abs( corr_C.r(I{i}, :) );    
    ps = abs( corr_C.p(I{i}, :) );
    
    nans = isnan( rs );
    rs(nans) = 0;
    ps(nans) = 1;
    
    [~, peaki] = max( rs, [], 2 );
    [~, ord] = sort( peaki );
    [rs, c, ps] = rowref_many( ord, rs, corr_C, ps );
    [sig_i, sig_j] = find( ps < 0.05 );
    y = 1:size( rs, 1 );
    rs = imgaussfilt( rs, 1.5 );
    imagesc( axs(i), tseries, y, rs );  
    scatter( axs(i), tseries(sig_j), y(sig_i), 1, 'k*' );
    title( axs(i), plots.cellstr_join(C(i, :)) );
  end
else
  for i = 1:numel(I)
    plot( axs(i), tseries, nanmean(abs(corr_C.r(I{i}, :)), 1) );
    title( axs(i), plots.cellstr_join(C(i, :)) );
  end
  ylabel( axs(1), 'r value' );
  shared_utils.plot.match_ylims( axs );
end

%%

% t0 = -0.1;
% t1 = 0;

% t0 = 0;
% t1 = 1.5;

t0 = 0.21;
t1 = 0.4;

t0 = 0.2;
t1 = 0.21;

psth_t = tot_tbl.psth_t{1};
[~, t0_ind] = min( abs(psth_t - t0) );
% t0_ind = t0_ind + 1;  % next bin after t0

[~, t1_ind] = min( abs(psth_t - t1) );
mean_psth = nansum( tot_tbl.psth(:, t0_ind:t1_ind), 2 );

[corr_I, corr_C] = findeach( tot_tbl, {'region', 'session'} ...
  , tot_tbl.stim_type == 'stim' & ~tot_tbl.is_outlier_session ...
);

x2 = tot_tbl.m1_average_distance_to_eyes;
x1 = mean_psth;
% x1(x1 == 0) = nan;

corr_C.r = nan( rows(corr_C), 1 );
corr_C.p = nan( rows(corr_C), 1 );

for i = 1:numel(corr_I)
  ci = corr_I{i};
  [corr_C.r(i), corr_C.p(i)] = corr( x1(ci), x2(ci), 'rows', 'complete' );
%   scatter( axs(i), x1(ci), x2(ci) );
end

sig_days = find( corr_C.p < 0.05 );
clf;
axs = plots.panels( numel(sig_days) );
for i = 1:numel(axs)
  ci = corr_I{sig_days(i)};
  ci = intersect( intersect(ci, find(~isnan(x1))), find(~isnan(x2)) );
  
  scatter( axs(i), x1(ci), x2(ci) );
  ps = polyfit( x1(ci), x2(ci), 1 );
  xs = get( axs(i), 'xtick' );
  y = polyval( ps, xs );
  hold( axs(i), 'on' );
  plot( axs(i), xs, y ); 
  title( axs(i), char(plots.cellstr_join(corr_C(sig_days(i), :))) );
end

% clf;
% axs = plots.panels( numel(corr_I), true );

[reg_I, reg_C] = findeach( corr_C, 'region' );
reg_C.n_sig = cellfun( @(x) sum(corr_C.p(x) < 0.05), reg_I );

%%

[sesh_I, sesh_C] = findeach( tot_tbl, {'session', 'region'} );
sesh_means = cellfun( @(x) nanmean(tot_tbl.pre_stim_fr(x)), sesh_I );

do_log = true;
num_devs = 1;
[I, C] = findeach( sesh_C, {'region'} );

figure(1); clf;
axs = plots.panels( numel(I) );

num_outliers = 0;

for i = 1:numel(I)
  ax = axs(i);
  sm = sesh_means(I{i});
  if ( do_log )
    sm = log( sm );
  end
  
%   bar( ax, sm, ones(size(sm)), 'BarWidth', 128 );
  histogram( ax, sm, numel(sm)+1 );
  hold( ax, 'on' );
  
  ind = ismember( sesh_C.session(I{i}), bad_days );
  ylims = get( ax, 'ylim' );
  diff_lim = diff( ylims );
  scatter( ax, sm(ind), diff_lim * 0.5 + ylims(1), 'r*' );
  
  mu = mean( sm );
  med = median( sm );
  std_sm = std( sm );
  num_lt = sm < mu - std_sm * num_devs;
  num_gt = sm > mu + std_sm * num_devs;
  p_lt = pnz( num_lt );
  p_gt = pnz( num_gt );
  
  shared_utils.plot.add_vertical_lines( ax, med, 'k--' );
  shared_utils.plot.add_vertical_lines( ax, mu, 'g--' );
  
  lb = mu - std_sm * num_devs;
  ub = mu + std_sm * num_devs;
  shared_utils.plot.add_vertical_lines( ax, [lb, ub], 'r--' );
  
  base_str = plots.cellstr_join(C(i, :));
  title_str = sprintf( ...
    '%s | Std = %0.2f, Mu = %0.2f, Med = %0.2f, [%0.2f%% lt, %0.2f%% gt] %d sds' ...
    , char(base_str), std_sm, mu, med, p_lt*100, p_gt*100, num_devs );
  title( ax, title_str );
  
  num_outliers = num_outliers + sum( num_lt ) + sum( num_gt );
end

shared_utils.plot.match_xlims( axs );
shared_utils.plot.match_ylims( axs );

xlab = 'mean firing rate before stim or sham';
if ( do_log )
  xlab = sprintf( '(log) %s', xlab );
end
xlabel( axs, xlab );

%%

time_to_stim = tot_tbl.event_time - tot_tbl.stim_time;
psth_t = tot_tbl.psth_t{1};
bin_t = uniquetol( diff(psth_t) );

mask = ~tot_tbl.is_outlier_session;
% mask = true( rows(tot_tbl), 1 );
mask = mask & time_to_stim <= 1.5;
mask = mask & time_to_stim > 0.2;

each = { 'session', 'region', 'stim_type', 'monkey', 'psth_type' };
[sesh_I, sesh_C] = findeach( tot_tbl, each, mask );
sesh_means = cate1( cellfun(@(x) nanmean(tot_tbl.psth(x, :), 1), sesh_I, 'un', 0) );

if ( 0 )
  stim_sub_sham = sesh_means;
  stim_C = sesh_C;  
else
  [stim_I, stim_C] = findeach( sesh_C, setdiff(each, 'stim_type') );
  stim_sub_sham = nan( numel(stim_I), size(sesh_means, 2) );
  is_sig = false( size(stim_sub_sham) );

  for i = 1:numel(stim_I)
    si = stim_I{i};
    stim_ind = findrows( sesh_C.stim_type, 'stim', si );
    sham_ind = findrows( sesh_C.stim_type, 'sham', si );

    if ( isempty(stim_ind) || isempty(sham_ind) )
      continue
    end

    stim_means = sesh_means(stim_ind, :);
    sham_means = sesh_means(sham_ind, :);
    
    assert( numel(stim_ind) == 1 && numel(sham_ind) == 1 );
    stim_sub_sham(i, :) = stim_means - sham_means;    
    
    for j = 1:size(stim_means, 2)
      is_sig(i, j) = ranksum( stim_means(:, j), sham_means(:, j) ) < 0.05;
    end
  end
end

%{ 5:42 %}

[reg_I, id, C] = rowsets( 1, stim_C, {'region', 'psth_type', 'monkey'} ...
  , 'to_string', true );
[PI, PL] = plots.nest1( id, reg_I, C );

means = nanmean( stim_sub_sham(:, psth_t >= 0 & psth_t <= 0.4), 2 );

figure(2); clf;
axs = plots.panels( numel(reg_I) );

for i = 1:numel(axs)
  mus = means(reg_I{i});
  hist( axs(i), mus, 100 );
  title( axs(i), PL{i, 1} );
  hold( axs(i), 'on' );
  shared_utils.plot.add_vertical_lines( axs(i), nanmedian(mus) );
end

shared_utils.plot.match_xlims( axs );
shared_utils.plot.match_ylims( axs );
hold( axs, 'on' );
xlim( axs, [-2.5, 2.5] )

%%

time_to_stim = tot_tbl.event_time - tot_tbl.stim_time;
psth_t = tot_tbl.psth_t{1};

mask = ~tot_tbl.is_outlier_session;
% mask = true( rows(tot_tbl), 1 );
mask = mask & time_to_stim <= 1.5;
mask = mask & time_to_stim > 0.2;

mask = find( mask );

% each = { 'session', 'region', 'stim_type', 'monkey', 'psth_type' };
each = { 'session', 'region', 'psth_type', 'monkey' };
[sesh_I, sesh_C] = findeach( tot_tbl, each, mask );

psth_t_mask = psth_t >= 0 & psth_t <= 0.25;
mean_psth = nanmean( tot_tbl.psth(:, psth_t_mask), 2 );

is_sig = zeros( numel(sesh_I), 1 );
signs = zeros( numel(sesh_I), 1 );
for i = 1:numel(sesh_I)
  si = sesh_I{i};
  stim_ind = findrows( tot_tbl.stim_type, 'stim', si );
  sham_ind = findrows( tot_tbl.stim_type, 'sham', si );
  stim_set = mean_psth(stim_ind);
  sham_set = mean_psth(sham_ind);
  if ( ~isempty(stim_set) && ~isempty(sham_set) )
    is_sig(i) = ranksum( stim_set, sham_set ) < 0.05;
    signs(i) = sign( nanmean(stim_set) - nanmean(sham_set) );
  end
end

sesh_C.sign = string( signs );
[I, id, L] = rowsets( 3, sesh_C, 'region', 'psth_type', {'monkey'} ...
  , 'to_string', true ...
  , 'mask', sesh_C.sign ~= '0' ...
);

figure(1); clf;
% plt_dat = stim_sub_sham;
plt_dat = double( is_sig );
[axs, hs] = plots.simplest_barsets( plt_dat, I, id, L ...
  , 'error_func', @(x) nan ...
);

shared_utils.plot.match_ylims( axs );

%%  percent significant stim vs sham, over time

time_to_stim = tot_tbl.event_time - tot_tbl.stim_time;
psth_t = tot_tbl.psth_t{1};
bin_t = uniquetol( diff(psth_t) );

mask = ~tot_tbl.is_outlier_session;
% mask = true( rows(tot_tbl), 1 );
mask = mask & time_to_stim <= 1.5;
mask = mask & time_to_stim > 0.2;

mask = find( mask );

% each = { 'session', 'region', 'stim_type', 'monkey', 'psth_type' };
each = { 'session', 'region', 'monkey', 'psth_type' };
[sesh_I, sesh_C] = findeach( tot_tbl, each, mask );
sesh_means = cate1( cellfun(@(x) nanmean(tot_tbl.psth(x, :), 1), sesh_I, 'un', 0) );

is_sig = nan( numel(sesh_I), size(sesh_means, 2) );
for i = 1:numel(sesh_I)
  si = sesh_I{i};
  stim_ind = findrows( tot_tbl.stim_type, 'stim', si );
  sham_ind = findrows( tot_tbl.stim_type, 'sham', si );
  
  for j = 1:size(is_sig, 2)
    stim_set = tot_tbl.psth(stim_ind, j);
    sham_set = tot_tbl.psth(sham_ind, j);
    if ( isempty(stim_set) || isempty(sham_set) )
      continue
    end    
    is_sig(i, j) = ranksum( stim_set, sham_set ) < 0.05;
  end
end

stim_C = sesh_C;

[reg_I, id, C] = rowsets( 2, stim_C, {'region', 'psth_type'}, {} ...
  , 'to_string', true );
[PI, PL] = plots.nest2( id, reg_I, C );

err_func = @(x) nan(1, size(x, 2));
% err_func = @plotlabeled.nansem;

smooth_func = @(x) smoothdata(x, 2, 'movmean', round(200e-3/bin_t));
% smooth_func = @(x) x;

figure(1); clf;
% plt_dat = stim_sub_sham;
plt_dat = double( is_sig );
[axs, hs] = plots.simplest_linesets( psth_t, plt_dat, PI, PL ...
  , 'error_func', err_func ...
  , 'smooth_func', smooth_func ...
  , 'summary_func', @(x) nanmean(x, 1) ...
);

xlim( axs, [0, 1] );
shared_utils.plot.match_ylims( axs );
shared_utils.plot.hold( axs, 'on' );
% shared_utils.plot.add_vertical_lines( axs, [0] );

%%  mean percent significant stim vs sham, in time window

time_to_stim = tot_tbl.event_time - tot_tbl.stim_time;
psth_t = tot_tbl.psth_t{1};

mask = ~tot_tbl.is_outlier_session;
mask = mask & time_to_stim <= 1.5;
mask = mask & time_to_stim > 0.2;

mask = find( mask );

each = { 'session', 'region', 'monkey', 'psth_type' };
[sesh_I, sesh_C] = findeach( tot_tbl, each, mask );

is_sig = nan( numel(sesh_I), 1 );
t_win = psth_t >= 0.0 & psth_t < 0.25;

for i = 1:numel(sesh_I)
  si = sesh_I{i};
  stim_ind = findrows( tot_tbl.stim_type, 'stim', si );
  sham_ind = findrows( tot_tbl.stim_type, 'sham', si );
  
%   stim_set = nanmean( tot_tbl.psth(stim_ind, t_win), 2 );
%   sham_set = nanmean( tot_tbl.psth(sham_ind, t_win), 2 );
  
  stim_set = tot_tbl.event_spk_fr(stim_ind);
  sham_set = tot_tbl.event_spk_fr(sham_ind);
  
  if ( isempty(stim_set) || isempty(sham_set) )
    continue
  end    
  
  is_sig(i) = ranksum( stim_set, sham_set ) < 0.05;
end

stim_C = sesh_C;

[reg_I, id, C] = rowsets( 3, stim_C, {'region'}, {}, {'psth_type'} ...
  , 'to_string', true );

figure(1); clf;
plt_dat = double( is_sig );
[axs, hs] = plots.simplest_barsets( plt_dat, reg_I, id, C ...
  , 'error_func', @(x) nan ...
);

shared_utils.plot.match_ylims( axs );
shared_utils.plot.set_ylims( axs, [0, 1] );

sig_days = stim_C(is_sig, {'session', 'region', 'monkey'});

%%

twin = psth_t >= 0.21 & psth_t < 1.5;
twin_means = nanmean( tot_tbl.psth(:, twin), 2 );

each = { 'session', 'region', 'stim_type', 'monkey', 'psth_type' };
[sesh_I, sesh_C] = findeach( tot_tbl, each, mask );
sesh_means = rowifun( @nanmean, sesh_I, twin_means );

[stim_I, stim_C] = findeach( sesh_C, setdiff(each, 'stim_type') );
stim_sub_sham = nan( numel(stim_I), size(sesh_means, 2) );

for i = 1:numel(stim_I)
  si = stim_I{i};
  stim_ind = findrows( sesh_C.stim_type, 'stim', si );
  sham_ind = findrows( sesh_C.stim_type, 'sham', si );
  assert( numel(stim_ind) == 1 && numel(sham_ind) == 1 );
  stim_sub_sham(i, :) = sesh_means(stim_ind, :) - sesh_means(sham_ind, :);
end

[reg_I, id, C] = rowsets( 2, stim_C, {'region'}, {'psth_type'} ...
  , 'to_string', true );
[PI, PL] = plots.nest2( id, reg_I, C );

figure(1); clf;
axs = plots.panels( numel(PI) );
[hs, xs] = plots.simple_boxsets( axs, stim_sub_sham, PI, PL );

% xlim( axs, [0, 1] );
shared_utils.plot.match_ylims( axs );

%%

per_session = false;
exclude_bad_days = true;
session_level_mean = false;
add_errs = true;
bin_t = uniquetol( diff(tot_tbl.psth_t{1}) );

if ( exclude_bad_days )
  mask = find( ~tot_tbl.is_outlier_session );
else
  mask = rowmask( tot_tbl );
end

% mask = intersect( mask, find(tot_tbl.stim_type == 'stim') );

if ( per_session )
  [day_I, day_C] = findeach( tot_tbl, 'session', mask );
  day_I = day_I(3);
else
  [day_I, day_C] = findeach( tot_tbl, {}, mask );
end

for i = 1:numel(day_I)

di = day_I{i};

if ( per_session )
  pcats = {'region', 'session'};
else
  pcats = {'region', 'psth_type'};
end

plt_tbl = tot_tbl;

if ( session_level_mean )
  [day_I, day_C] = findeach( plt_tbl, [pcats, {'session', 'stim_type', 'psth_type', 'monkey'}], di );
  means = cate1( cellfun(@(x) nanmean(tot_tbl.psth(x, :), 1), day_I, 'un', 0) );
  day_C.psth_t = repmat( plt_tbl.psth_t(1), rows(means), 1 );
  day_C.psth = means;
  plt_tbl = day_C;
  di = rowmask( plt_tbl );
end

[I, id, C] = rowsets( 2, plt_tbl, pcats, 'stim_type' ...
  , 'to_string', true, 'mask', di );

[PI, PL] = plots.nest2( id, I, C );

plt_t = plt_tbl.psth_t{1};
plt_fr = plt_tbl.psth ./ 1 / bin_t;

if ( 0 )
  plt_fr = smoothdata( plt_fr, 2, 'movmean', round(25e-3/uniquetol(diff(psth_t))) );
end

if ( ~add_errs )
  err_func = @(x) nan(1, size(x, 2));
else
  err_func = @plotlabeled.nansem;
end

figure(1); clf();
bin_t = uniquetol( diff(plt_tbl.psth_t{1}) );
axs = plots.simplest_linesets( plt_t, plt_fr, PI, PL ...
  , 'error_func', err_func ...
  , 'summary_func', @nanmean ...
);
shared_utils.plot.match_ylims( axs );

if ( 0 )
for j = 1:numel(PI)
  ia = PI{j}{1};
  ib = PI{j}{2};
  ps = ranksum_matrix( plt_fr, {ia}, {ib} );
  [sigi, sigd] = shared_utils.logical.find_islands( ps < 0.05 );
  for k = 1:numel(sigi)
    y = max( get(axs(j), 'ylim') ) - diff(get(axs(j), 'ylim')) * 0.1;
    p0 = [ plt_t(sigi(k)), y ];
    p1 = [ plt_t(sigi(k) + sigd(k) - 1), y ];
    plot( axs(j), [p0(1), p1(1)], [p0(2), p1(2)], 'k', 'linewidth', 2 );
  end  
end
end

end

% shared_utils.plot.add_vertical_lines( axs, [0.2] );
xlim( axs, [0, 1] );
ylabel( axs(1), 'Hz' );

%%

function [sesh, run_num] = parse_unified_filename(fname)

sesh = fname(1:8);

if ( contains(fname, 'position') )
  run_beg = 9 + numel('position_1');
else
  run_beg = 9 + numel('dot_1');
end

run_end = max( strfind(fname, '.') );
run_num = str2double( fname(run_beg:run_end) );

end