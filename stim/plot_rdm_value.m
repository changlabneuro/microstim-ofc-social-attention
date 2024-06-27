%%

dr = '/Volumes/external3/data/changlab/siqi/stim';

int_tbl = shared_utils.io.fload(...
  fullfile(dr, 'intermediates/combined_tables/int_tbl.mat') );

eyes_tbl = shared_utils.io.fload(...
  fullfile(dr, 'intermediates/gaze_data_tables/eyes_updated.mat') );

dot_tbl = shared_utils.io.fload(...
  fullfile(dr, 'intermediates/gaze_data_tables/dot_updated.mat') );

%%

look_dur = nan( rows(int_tbl), 1 );
stim_infos = table();

desired_tbl = dot_tbl;
% desired_tbl = eyes_tbl;

for i = 1:size(int_tbl, 1)
  fprintf( '\n %d of %d', i, size(int_tbl, 1) );
  
  eye_roi = int_tbl.m1_rois{i}.rects('eyes_nf');
  eye_p = shared_utils.rect.center( eye_roi );
  
  pos = int_tbl.position{i};
  fix = int_tbl.is_fixation{i};
  t = int_tbl.time{i};
  
  ok_ints = [];
  
  stim_ind = find( desired_tbl.session == int_tbl.session(i) );
  stims_this_run = desired_tbl.stim_time(stim_ind);
  
  for j = 1:size(stims_this_run, 1)
    st = stims_this_run(j);
    if ( st < min(t) || st > max(t) ), continue; end
    [~, t0] = min( abs(t - st) );
    [~, t1] = min( abs(t - (st + 1.5)) );
    ok_ints(end+1, :) = [t0, t1, stim_ind(j)];
  end
  
  [fix_i, fix_d] = shared_utils.logical.find_islands( fix );
  accept_fix = fix_d >= 10;
  [fix_i, fix_d] = deal( fix_i(accept_fix), fix_d(accept_fix) );
  
  adj_fix_i = [];
  
  for j = 1:numel(fix_i)
    f_t0 = fix_i(j);
    f_t1 = f_t0 + fix_d(j) - 1;

    for k = 1:size(ok_ints, 1)
      if ( f_t0 >= ok_ints(k, 1) && f_t0 < ok_ints(k, 2) )
        adj_fix_i(end+1, :) = [ f_t0, min(f_t1, ok_ints(k, 2)), ok_ints(k, 3) ]; 
        break
      end
    end
  end
  
  ld = zeros( rows(adj_fix_i), 1 );
  fix_p = zeros( rows(ld), 2 );
  fix_d = zeros( rows(ld), 1 );
  
  for j = 1:size(adj_fix_i, 1)
    [t0, t1] = deal( adj_fix_i(j, 1), adj_fix_i(j, 2) );
    px = pos(1, t0:t1);
    py = pos(2, t0:t1);
    
    ld(j) = sum( shared_utils.rect.inside(eye_roi, px, py) );
    fix_p(j, :) = [ nanmean(px), nanmean(py) ];
    fix_d(j) = bfw.px2deg( vecnorm(fix_p(j, :) - eye_p) );
  end
  
  look_dur(i) = sum( ld );
  
  if ( ~isempty(adj_fix_i) )
    stim_info = desired_tbl(adj_fix_i(:, 3), :);
    stim_info.fix_dur = adj_fix_i(:, 2) - adj_fix_i(:, 1);    
    stim_info.fix_ps = fix_p;
    stim_info.fix_ds = fix_d;
    stim_infos = [ stim_infos; stim_info ];
  end
end

%%

all_days_tbl = get_day_labels();
[~, loc] = ismember( stim_infos.session, all_days_tbl.session );
stim_infos.m1 = string( all_days_tbl.monkey(loc) );

%%  

% sum looking duration within run or day

sum_func = @sum;
% sum_func = @numel;

[I, dur_within_run] = findeach( stim_infos, {'session', 'region', 'run'} );
dur_within_run.tot_t = cellfun( @(x) sum_func(stim_infos.fix_dur(x)), I );
dur_within_run.tile = prctile_index( dur_within_run.tot_t );
dur_within_run.tile = prctile_name( dur_within_run.tile );

[I, dur_within_day] = findeach( stim_infos, {'session', 'region'} );
dur_within_day.tot_t = cellfun( @(x) sum_func(stim_infos.fix_dur(x)), I );
dur_within_day.tile = prctile_index( dur_within_day.tot_t );
dur_within_day.tile = prctile_name( dur_within_day.tile );

%%

[~, within_run_mi] = ismember( ...
    stim_infos(:, {'session', 'region', 'run'}) ...
  , dur_within_run(:, {'session', 'region', 'run'}) );

[~, within_day_mi] = ismember( ...
    stim_infos(:, {'session', 'region'}) ...
  , dur_within_day(:, {'session', 'region'}) );

stim_infos.within_run_tile = dur_within_run.tile(within_run_mi);
stim_infos.within_day_tile = dur_within_day.tile(within_day_mi);

%%

I = findeach( stim_infos, {'session', 'region'} );
stim_infos.per_day_tile = strings( rows(stim_infos), 1 );

for i = 1:numel(I)
  fprintf( '\n %d of %d', i, numel(I) );
  
  si = findeach( stim_infos, 'stim_time', I{i} );
  fix_durs = cellfun( @(x) sum(stim_infos.fix_dur(x)), si );
  fix_tile = prctile_index( fix_durs );
  fix_tile = prctile_name( fix_tile );
  
  assign_to = vertcat( si{:} );
  num_reps = cellfun( @numel, si );
  rep_tile = repelem( fix_tile, num_reps );
  
  stim_infos.per_day_tile(assign_to) = rep_tile;
  
%   for j = 1:numel(si)
%     stim_infos.per_day_tile(si{j}) = fix_tile(j);
%   end
end

%%

% tile_name = 'within_run_tile';
% tile_name = 'within_day_tile';
tile_name = 'per_day_tile';
dist_var = 'm1_distance_to_eyes';
% dist_var = 'fix_ds';

base = {'m1'};
% base = {};

[mu_stim, ~, ic] = unique( ...
  stim_infos(:, {base{:}, 'session', 'region', 'run', 'stim_time', 'stim_type', tile_name}) );
I = groupi( ic );
mu_stim.dist = cellfun( @(x) nanmean(stim_infos.(dist_var)(x)), I );

[C, ~, ic] = unique( mu_stim(:, {base{:}, 'session', 'region', 'stim_type', tile_name}) );
I = groupi( ic );
C.dist = cellfun( @(x) nanmean(mu_stim.dist(x)), I );
mu_stim = C;

%%

[I, C] = findeach( mu_stim, {'region', tile_name, base{:}} );
dur_t = table();

for i = 1:numel(I)
  sesh_I = findeach( mu_stim, {'session', tile_name}, I{i} );
  durs = nan( numel(sesh_I), 2 );
  
  for j = 1:numel(sesh_I)
    si = sesh_I{j};
    sham_ind = intersect( si, find(mu_stim.stim_type == 'sham') );
    stim_ind = intersect( si, find(mu_stim.stim_type == 'stim') );
    durs(j, :) = [ mu_stim.dist(sham_ind), mu_stim.dist(stim_ind) ];
  end
  
  si = cellfun( @(x) x(1), sesh_I );
  dur_t = [ dur_t; [mu_stim(si, varnames(C)), table(durs, 'va', {'duration'})] ];
end

%%

[I, C] = findeach( dur_t, {'region', tile_name, base{:}} );
C.p(:) = nan;

for i = 1:numel(I)
  C.p(i) = signrank( dur_t.duration(I{i}, 1), dur_t.duration(I{i}, 2) );
end

%%

mask = mu_stim.(tile_name) ~= "invalid";
[I, mu_stim_diff] = findeach( mu_stim, setdiff(varnames(mu_stim), {'stim_type', 'dist'}), mask );

stim_diff = nan( numel(I), 1 );
for i = 1:numel(I)
  set_a = intersect( find(mu_stim.stim_type == 'stim'), I{i} );
  set_b = intersect( find(mu_stim.stim_type == 'sham'), I{i} );
  stim_diff(i) = mu_stim.dist(set_a) - mu_stim.dist(set_b);
end

mu_stim_diff.dist = stim_diff;

%%

plt_tbl = mu_stim;
plt_tbl = mu_stim_diff;

mask = plt_tbl.(tile_name) ~= "invalid";

[I, id, L] = rowsets( 4, plt_tbl ...
  , {'region'}, {tile_name}, {base{:}}, 'session' ...
  , 'to_string', true, 'mask', mask ...
);

[axs, hs, xs, ip] = plots.simplest_barsets( plt_tbl.dist, I, id, L ...
  , 'error_func', @plotlabeled.nansem ...
  , 'add_points', true ...
);

if ( 0 )
  for i = 1:numel(axs)
    h = findobj( axs(i), 'type', 'scatter' );
    xs = arrayfun( @(x) get(x, 'xdata'), h, 'un', 0 );
    ys = arrayfun( @(x) get(x, 'ydata'), h, 'un', 0 );
    accept = find( cellfun(@numel, xs ) == 2 );
    for j = 1:numel(accept)
      x = xs{accept(j)};
      y = ys{accept(j)};
      hold( axs(i), 'on' );
      h = line( axs(i), x, y );
      set( h, 'color', 'k' );
    end
  end
end

shared_utils.plot.match_ylims( axs );
ylabel( axs(1), 'Distance to "eyes"' );

%%

function tile = prctile_name(t)

tile = strings( size(t) );
tile(isnan(t)) = "invalid";
tile(t == 0) = "low";
tile(t == 1) = "high";

end

function tile = prctile_index(t)

tile = nan( numel(t), 1 );
tiles = prctile( t, [25, 75] );

tile(t <= tiles(1)) = 0;
tile(t >= tiles(2)) = 1;
  
end
