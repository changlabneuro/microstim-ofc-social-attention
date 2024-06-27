data_root = '/Volumes/external3/data/changlab/siqi/stim';
samps_dir = 'intermediates/aligned_raw_samples';
fix_dir = fullfile( data_root, samps_dir, 'raw_eye_mmv_fixations' );
pup_dir = fullfile( data_root, samps_dir, 'pupil_size' );
time_dir = fullfile( data_root, samps_dir, 'time' );
pos_dir = fullfile( data_root, samps_dir, 'position' );
roi_dir = fullfile( data_root, 'intermediates', 'rois' );

%%

int_tbl = shared_utils.io.fload( fullfile(data_root, 'intermediates/combined_tables/int_tbl.mat') );

%%

eyes_tbl = shared_utils.io.fload( fullfile(data_root, 'intermediates/gaze_data_tables/eyes_updated.mat') );
keep_sesh = ismember( eyes_tbl.session, ["05142022", "05172022", "05192022", "05242022"] );
keep_sesh(:) = true;
eyes_tbl = eyes_tbl(keep_sesh, :);

%%

fix_ps = shared_utils.io.findmat( fix_dir );
fix_fnames = shared_utils.io.filenames( fix_ps, true );

ps = match_files( fix_ps, time_dir, pup_dir, pos_dir, roi_dir );
[time_ps, pup_ps, pos_ps, roi_ps] = deal( ps(:, 2), ps(:, 3), ps(:, 4), ps(:, 5) );

f1 = shared_utils.io.filenames( pup_ps );
f2 = shared_utils.io.filenames( roi_ps );
assert( isequal(f1, f2) );

runs = double( strrep(eyes_tbl.run, 'run_', '') );
assert( ~any(isnan(runs)) )
un_fnames = compose( "%s_position_%d.mat", eyes_tbl.session, runs );
[~, match_eye_tbl_to_fix_ps] = ismember( un_fnames, fix_fnames );

tables = cell( numel(fix_ps), 1 );
for i = 1:numel(fix_ps)
  fprintf( '\n %d of %d', i, numel(fix_ps) );
  fix = shared_utils.io.fload( fix_ps{i} );
  time = shared_utils.io.fload( time_ps{i} );
  pup = shared_utils.io.fload( pup_ps{i} );
  pos = shared_utils.io.fload( pos_ps{i} );
  rois = shared_utils.io.fload( roi_ps{i} );
  
  last_underscore = max( strfind(fix_fnames{i}, '_') );
  last_period = max( strfind(fix_fnames{i}, '.') );
  run_num = str2double( fix_fnames{i}(last_underscore+1:last_period-1) );
  assert( ~isnan(run_num) );
  
  m1_rois = rois.m1;
  
  sesh = string( fix_fnames{i}(1:8) );
  tbl = table( ...
      {single(fix.m1)}, {single(time.t)}, {single(pup.m1)}, {single(pos.m1)}, {m1_rois} ...
      , string(fix_fnames(i)), sesh, run_num ...
    , 'va', {'is_fixation', 'time', 'pupil', 'position', 'm1_rois' ...
              , 'unified_filename', 'session', 'run'} );
  tables{i} = tbl;
end

int_tbl = vertcat( tables{:} );

non_nan_ts = cellfun( @(x) find(~isnan(x)), int_tbl.time, 'un', 0 );

%%

stim_ts = eyes_tbl.stim_time;
lb = 0; % look back
la = 0.7; % look ahead

% time_axis = lb:1e-3:la;
time_axis = lb:1e-2:la;

fix_traces = nan( rows(eyes_tbl), numel(time_axis) );
pup_traces = nan( size(fix_traces) );
pos_traces = nan( rows(eyes_tbl), 2, numel(time_axis) );
face_rois = nan( rows(eyes_tbl), 4 );

matched = match_eye_tbl_to_fix_ps > 0;
keep_vars = { 'unified_filename', 'session', 'run' };
dummy = int_tbl(1, keep_vars);
for i = 1:size(dummy, 2), dummy{1, i} = missing; end
rest_fields = repmat( dummy, rows(eyes_tbl), 1 );
rest_fields(matched, :) = int_tbl(match_eye_tbl_to_fix_ps(matched), keep_vars);

% @NOTE: Don't make this parfor; locks up matlab for some reason
for i = 1:size(eyes_tbl, 1)
  fprintf( '\n %d of %d', i, rows(eyes_tbl) );
  
  mi = match_eye_tbl_to_fix_ps(i);
  if ( mi == 0 ), continue; end
  
  curr_t = double( int_tbl.time{mi} );
  non_nan = non_nan_ts{mi};
  
  ta = time_axis + stim_ts(i);
  inds = non_nan(bfw.find_nearest(curr_t(non_nan), ta));
  fix_traces(i, :) = int_tbl.is_fixation{mi}(inds);
  pup_traces(i, :) = int_tbl.pupil{mi}(inds);
  pos_traces(i, :, :) = int_tbl.position{mi}(:, inds);
  face_rois(i, :) = int_tbl.m1_rois{mi}.rects('face');
  
  pup_traces(i, :) = fillmissing( pup_traces(i, :), 'linear' );
  fix_traces(i, :) = fillmissing( fix_traces(i, :), 'linear' );
  
  for j = 1:2
    pos_traces(i, j, :) = fillmissing( pos_traces(i, j, :), 'linear' );
  end
end

fix_traces = fix_traces > 0;

%%

t_subset = time_axis <= 0.7;
accept_within_face = false( size(fix_traces, 1), 1 );

for i = 1:size(fix_traces, 1)
  x = pos_traces(i, 1, :);
  y = pos_traces(i, 2, :);
  ib = shared_utils.rect.inside( face_rois(i, :), x, y );
  accept_within_face(i) = all( ib(t_subset) );
end

%%

max_dur_s = 0.1;
max_dur_samps = round( max_dur_s / uniquetol(diff(time_axis)) );
max_dist_deg = 2;

filled_fix_traces = fix_traces;
p_filled = zeros( rows(filled_fix_traces), 1 );

for i = 1:size(filled_fix_traces, 1)  
  fix_trace = filled_fix_traces(i, :);
  
  [isles, durs] = shared_utils.logical.find_islands( fix_trace );
  check_fill = isles(durs >= max_dur_samps);
  check_durs = durs(durs >= max_dur_samps);
  
  for j = 1:numel(check_fill)
    cf = check_fill(j);
    cd = check_durs(j);
    i0 = max( 1, cf - 1 );
    i1 = min( numel(fix_trace), cf + 1 );
    p0 = pos_traces(i, :, i0);
    p1 = pos_traces(i, :, i1);
    px_dist = bfw.px2deg( vecnorm(p1 - p0) );
    if ( px_dist <= max_dist_deg )
      filled_fix_traces(cf:cf+cd-1) = true;
      p_filled(i) = p_filled(i) + 1;
    end
  end
  
  p_filled(i) = max( 0, p_filled(i)/numel(check_durs) );
end

%%

use_fix_traces = filled_fix_traces;
use_pup_traces = pup_traces;
use_labels = eyes_tbl;

t_subset = time_axis <= 0.7;

ok_traces = all( use_fix_traces(:, t_subset), 2 );
ok_traces = accept_within_face;
% for i = 1:size(fix_traces, 1)
%   ok_traces(i) = pnz( fix_traces(i, t_subset) ) > 0.98;
% end

use_mask = ok_traces;

if ( 1 )
  [I, C] = findeach( eyes_tbl, {'region', 'session', 'stim_type'}, ok_traces );
  mus = cate1( rowifun(@mean, I, pup_traces, 'un', 0) );
  use_pup_traces = mus;
  use_mask = rowmask( mus );
  use_labels = C;
end

[I, day_comparison] = findeach( use_labels, {'session', 'region'} );
day_comparison.stim = nan( numel(I), size(use_pup_traces, 2) );
day_comparison.sham = nan( numel(I), size(use_pup_traces, 2) );

for i = 1:numel(I)
  stim = intersect( I{i}, find(use_labels.stim_type == 'stim') );
  sham = intersect( I{i}, find(use_labels.stim_type == 'sham') );
  day_comparison.stim(i, :) = use_pup_traces(stim, :);
  day_comparison.sham(i, :) = use_pup_traces(sham, :);
end

[I, stats] = findeach( day_comparison, 'region' );
stats.ps = nan( numel(I), size(day_comparison.stim, 2) );
for i = 1:numel(I)
  ind = I{i};
  stats.ps(i, :) = arrayfun( @(x) signrank(...
        day_comparison.stim(ind, x) ...
      , day_comparison.sham(ind, x)) ...
    , 1:size(day_comparison.stim, 2) );
end

[I, id, C] = rowsets( 2, use_labels, {'region'}, 'stim_type' ...
  , 'mask', use_mask, 'to_string', 1 );
[PI, PL] = plots.nest2( id, I, C );

[axs, hs] = plots.simplest_linesets( ...
    time_axis(t_subset), use_pup_traces(:, t_subset), PI, PL ...
  , 'error_func', @plotlabeled.nansem );

shared_utils.plot.match_ylims( axs );
ylabel( axs(1), 'Pupil size' );
