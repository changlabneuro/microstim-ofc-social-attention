data_root = '/Volumes/external3/data/changlab/siqi/stim';

int_p = fullfile( data_root, 'intermediates' );
spike_p = fullfile( int_p, 'spike_ts' );
pos_p = fullfile( int_p, 'aligned_raw_samples/position' );

% load stim/sham times
is_eyes = false;
want_rois = { 'eyes_nf', 'face' };
want_rois = [];

% bin_w = 5e-3;
% bin_w = 10e-3;
bin_w = 25e-3;

if ( is_eyes )
  tbl_name = 'eyes.mat';
  mua_psth_p = fullfile( int_p, sprintf('mua_psth/%d_ms_eye_events', round(bin_w*1e3)) );
else
  tbl_name = 'dot.mat';
  mua_psth_p = fullfile( int_p, sprintf('mua_psth/%d_ms_dot_events', round(bin_w*1e3)) );
end

if ( isempty(want_rois) )
  mua_psth_p = fullfile( mua_psth_p, 'all_rois' );
end

gaze_tbl = shared_utils.io.fload( fullfile(int_p, 'gaze_data_tables', tbl_name) );
unsorted_fs = shared_utils.io.findmat( fullfile(int_p, 'unsorted_peak_voltage') );

shared_utils.io.require_dir( mua_psth_p );

% psth_lb = -0.1;
psth_lb = -1;
psth_la = 5;
use_fix_events = true;

%%

if ( use_fix_events )
  ps = bfw.matched_files( ...
    shared_utils.io.findmat( fullfile(int_p, 'raw_events') ) ...
    , fullfile(int_p, 'aligned_raw_samples/position') ...
    , fullfile(int_p, 'aligned_raw_samples/time') ...
    , fullfile(int_p, 'rois') ...
    , fullfile(int_p, 'single_origin_offsets') ...
  );
  
  evt_ps = ps(:, 1);
  evt_files = cellfun( @shared_utils.io.fload, evt_ps );
  evt_sesh = cellfun( @(x) x(1:8), shared_utils.io.filenames(evt_ps), 'un', 0 );
end

%%

allow_overwrite = true;

for i = 1:numel(unsorted_fs)
  %%
  
  fprintf( '\n %d of %d', i, numel(unsorted_fs) );
  pl2_fname = shared_utils.io.filenames( unsorted_fs{i} );
  
  %%
  
  base_dst_p = fullfile( mua_psth_p, sprintf('%s.mat', pl2_fname) );
  if ( exist(base_dst_p, 'file') && ~allow_overwrite )
    continue
  end
  
  %%
  
  spike_ts = load( fullfile(spike_p, sprintf('%s.mat', pl2_fname)) );
  peak_v_file = load( unsorted_fs{i} );
  
  %%
  
  sesh = spike_ts.unsorted_tbl.session{1};
  match_stim_sesh = gaze_tbl.session == sesh;
  assert( nnz(match_stim_sesh) > 0 );
  
  ts = extract_times( spike_ts );
  evt_start_ts = gaze_tbl.stim_time(match_stim_sesh);
  
  stim_t0s = gaze_tbl.stim_time(match_stim_sesh);
  ib_stim = is_ib_stim_time( ts, stim_t0s, stim_t0s + 5 );
  
  prc = 80;
  prc_thresh = prctile( peak_v_file.peak_vs(~ib_stim), prc );
  ib_thresh = peak_v_file.peak_vs < prc_thresh;
  
  %%
  
  evt_subset_I = { rowmask(evt_start_ts) };
  stim_ind = rowmask( stim_t0s );
  
  if ( use_fix_events )
    evt_ind = find( strcmp(evt_sesh, sesh) );
    
    p_files = cell( numel(evt_ind), 1 );
    t_files = cell( size(p_files) );
    eye_centers = nan( numel(evt_ind), 2 );
    hemifield_origin = nan( size(eye_centers) );
    
    for j = 1:numel(evt_ind)      
      %%
      
      p_files{j} = shared_utils.io.fload( ps{evt_ind(j), 2} );
      t_files{j} = shared_utils.io.fload( ps{evt_ind(j), 3} );
      roi_file = shared_utils.io.fload( ps{evt_ind(j), 4} );
      offsets_file = shared_utils.io.fload( ps{evt_ind(j), 5} );
      
      eye_centers(j, :) = shared_utils.rect.center( roi_file.m1.rects('eyes_nf') );
      
      %%
  
      if ( isfield(roi_file, 'm2') )
        m2_eyes_roi = roi_file.m2.rects('eyes_nf');

        %   get center point delineating m1's hemifields
        hemifield_origin(j, :) = get_hemifield_zero_point( offsets_file, m2_eyes_roi );
      end
      
    end
    
    assert( ~isempty(evt_ind) );
    [event_ts, event_stop_ts, event_starts, event_stops, event_labs, event_ind] = ...
      event_files_to_events( evt_files(evt_ind), evt_ind, sesh );
    stim_ind = match_to_stim( event_ts, stim_t0s, stim_t0s + 5 );
    
    keep_evts = event_labs.looks_by == 'm1';
    if ( ~isempty(want_rois) )
      keep_evts = keep_evts & ismember( event_labs.roi, want_rois );
    end
    keep_evts = keep_evts & stim_ind > 0;
    
    event_ts = event_ts(keep_evts);
    event_stop_ts = event_stop_ts(keep_evts);
    event_starts = event_starts(keep_evts);
    event_stops = event_stops(keep_evts);
    event_labs = event_labs(keep_evts, :);
    stim_ind = stim_ind(keep_evts);
    event_ind = event_ind(keep_evts);
    
    evt_subset_I = findeach( event_labs, 'unified_filename' );
    evt_start_ts = event_ts;
    
    eye_dists = cate1( arrayfun(@(x, s, e) ...
      bfw.px2deg(norm(nanmean(p_files{x}.m1(:, s:e), 2)' - eye_centers(x, :))) ...
      , event_ind, event_starts, event_stops, 'un', 0) );
    other_dists = nan( size(eye_dists) );
    hemifield_dist = nan( size(eye_dists) );
    
    for j = 1:numel(event_ind)
      p_file = p_files{event_ind(j)};
      if ( ~isfield(p_file, 'm2') ), continue; end
      self_p = nanmean( p_file.m1(:, event_starts(j):event_stops(j)), 2 );
      other_p = nanmean( p_file.m2(:, event_starts(j):event_stops(j)), 2 );
      % self origin is middle monitor, so offset by 1024 to account for
      % left monitor
      self_p(1) = self_p(1) + 1024;
      other_p(1) = other_p(1) + 1024;
      
      % flip other side. three monitors, 1024 px wide
      other_p(1) = 1024 * 3 - other_p(1);
      other_dists(j) = bfw.px2deg( norm(self_p - other_p) );
      hemifield_dist(j) = (self_p(1) - 1024) - hemifield_origin(event_ind(j), 1);
    end
  end
  
  %%
  
  keep_ts = ib_thresh;
  spk_I = { 1 };  
  
  for idx = 1:numel(evt_subset_I)
    %%
    fprintf( '\n\t %d of %d', idx, numel(evt_subset_I) );

    dst_p = base_dst_p;
    
    if ( numel(evt_subset_I) > 1 )
      fname = sprintf( '%s-%d.mat', shared_utils.io.filenames(dst_p), idx );
      dst_p = fullfile( fileparts(dst_p), fname );
    end

    if ( exist(dst_p, 'file') && ~allow_overwrite )
      continue
    end
    
    ei = evt_subset_I{idx};
    evts = evt_start_ts(ei);
    evt_stops = event_stop_ts(ei);
    curr_eye_dists = eye_dists(ei);
    curr_other_dists = other_dists(ei);
    curr_hemi_dists = hemifield_dist(ei);
    evt_dur = evt_stops - evts;
    
    kept_ts = ts(keep_ts);
    
    evt_I = { rowmask(evts) };
  %   [psth, psth_t] = bfw.event_psth( evts, {kept_ts}, evt_I, spk_I, -0.1, 5, 0.1 );
    [psth, psth_t] = bfw.event_psth( evts, {kept_ts}, evt_I, spk_I, psth_lb, psth_la, bin_w );
    
    spk_counts = arrayfun( @(s, e) sum(kept_ts >= s & kept_ts < e), evts, evt_stops );
    spk_fr = spk_counts ./ 1 ./ reshape(evt_stops - evts, [], 1);

    %%

    if ( ~use_fix_events )
      pre_stim_fr = psth_fr( ts(keep_ts), stim_t0s - 0.5, stim_t0s - 0.1 );
    end

    %%
    
    if ( use_fix_events )
      base_tbl = event_labs(ei, :);
      base_tbl.event_time = evts;
      base_tbl.event_duration = evt_dur;
      base_tbl.eye_distance = curr_eye_dists;
      base_tbl.other_distance = curr_other_dists;
      base_tbl.hemifield_distance = curr_hemi_dists;
      base_tbl.event_spk_fr = spk_fr;
      base_tbl.psth = psth{1};
      base_tbl.psth_t = repmat( psth_t, size(psth{1}, 1), 1 );      
      
      curr_stim_sesh = find( match_stim_sesh );
      curr_stim_sesh = curr_stim_sesh(stim_ind(ei), :);
      curr_stim_table = gaze_tbl(curr_stim_sesh, :);
      
      rm_vars = ismember( ...
        curr_stim_table.Properties.VariableNames ...
        , base_tbl.Properties.VariableNames );
      base_tbl = [ base_tbl, curr_stim_table(:, ~rm_vars) ];
      
    else
      base_tbl = gaze_tbl(match_stim_sesh, :);
      base_tbl.psth = psth{1};
      base_tbl.psth_t = repmat( psth_t, size(psth{1}, 1), 1 );
      base_tbl.prc_thresh = repmat( prc, size(psth{1}, 1), 1 );
      base_tbl.pre_stim_fr = pre_stim_fr(:);
    end

    %%

    save( dst_p, 'base_tbl' );
  
  end
  
end

%%

function base_ts = extract_times(spike_t_file)

base_ts = spike_t_file.unsorted_tbl.time{1};

end

function ib_stim_t = is_ib_stim_time(base_ts, stim_t0s, stim_t1s)

ib_stim_t = false( numel(base_ts), 1 );
for j = 1:numel(base_ts)
  t = base_ts(j);
  if ( any(t >= stim_t0s & t <= stim_t1s) )
    ib_stim_t(j) = true;
  end
end

end

function s = psth_fr(spike_ts, t0s, t1s)

assert( numel(t0s) == numel(t1s) );
s = nan( numel(t0s), 1 );
for i = 1:numel(t0s)
  s(i) = sum( spike_ts >= t0s(i) & spike_ts < t1s(i) );
end

dur = t1s - t0s;
s = s ./ 1 ./ dur;

end

function [event_ts, event_stop_ts, event_starts, event_stops, event_labs, idx] = ...
  event_files_to_events(evt_files, evt_ind, session)

assert( numel(evt_files) == numel(evt_ind) );

events = vertcat( evt_files.events );
event_ts = events(:, evt_files(1).event_key('start_time'));
event_stop_ts = events(:, evt_files(1).event_key('stop_time'));
event_starts = events(:, evt_files(1).event_key('start_index'));
event_stops = events(:, evt_files(1).event_key('stop_index'));

idx = cate1( arrayfun(@(i) repmat(i, rows(evt_files(i).events), 1), 1:numel(evt_files), 'un', 0) );
un_fnames = arrayfun( @(x) string(x.unified_filename), evt_files );
un_fnames = un_fnames(idx);

evt_labs = array2table( vertcat(evt_files.labels), 'variablenames', evt_files(1).categories );
str_labs = varfun( @string, evt_labs );
str_labs.Properties.VariableNames = evt_labs.Properties.VariableNames;
evt_labs = str_labs;
evt_labs.unified_filename = un_fnames(:);
evt_labs.session = repmat( string(session), rows(evt_labs), 1 );
event_labs = evt_labs;

end

function stim_ind = match_to_stim(event_ts, stim_t0s, stim_t1s)

stim_ind = zeros( numel(event_ts), 1 );
for i = 1:numel(event_ts)
  ind = event_ts(i) >= stim_t0s & event_ts(i) < stim_t1s;
  if ( nnz(ind) == 1 )
    stim_ind(i) = find( ind );
  else
    assert( nnz(ind) == 0 );
  end
end

end