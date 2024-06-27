data_root = '/Volumes/external3/data/changlab/siqi/stim';
gaze_tbl = shared_utils.io.fload( fullfile(data_root, 'intermediates/gaze_data_tables/eyes.mat') );

ps = bfw.matched_files( ...
    shared_utils.io.findmat(fullfile(data_root, 'intermediates/aligned_raw_samples/position')) ...
  , fullfile(data_root, 'intermediates/aligned_raw_samples/time') );

names = shared_utils.io.filenames(ps(:, 1));

%%

[day_I, days] = findeach( gaze_tbl, 'session' );
% day_I = day_I(1);

lb = -0.25;

tot_mean_pos = nan( rows(gaze_tbl), 2 );

for i = 1:numel(day_I)
  shared_utils.general.progress( i, numel(day_I) );
  
  match_ps = ps(contains(names, days.session(i)), :);
  pos_files = cellfun( @shared_utils.io.fload, match_ps(:, 1), 'un', 0 );
  m1_pos = cellfun( @(x) x.m1, pos_files, 'un', 0 );
  time_files = cellfun( @shared_utils.io.fload, match_ps(:, 2) );
  stim_ts = gaze_tbl.stim_time(day_I{i});
  
  [min_ts, max_ts] = arrayfun( @(x) deal(min(x.t), max(x.t)), time_files );
  
  mean_pos = nan( numel(stim_ts), 2 );
  for j = 1:numel(stim_ts)
    has_stim_t = arrayfun( @(x, y) stim_ts(j) >= x & stim_ts(j) <= y, min_ts, max_ts );
    if ( sum(has_stim_t) == 1 )
      [~, t1_ind] = min( abs(time_files(has_stim_t).t - stim_ts(j)) );
      [~, t0_ind] = min( abs(time_files(has_stim_t).t - (stim_ts(j) + lb)) );
      mean_pos(j, :) = nanmean( m1_pos{has_stim_t}(:, t0_ind:t1_ind), 2 );
    else
      error( 'No time file matched.' );
    end
  end
  
  tot_mean_pos(day_I{i}, :) = mean_pos;
end

%%

if ( 1 )
  save( fullfile(data_root, 'intermediates/mean_position_before_stim/mean_pos.mat') ...
    , 'tot_mean_pos' );
end