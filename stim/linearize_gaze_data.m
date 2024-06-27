% gaze_data = load( '/Users/nick/Downloads/Gaze_Eyes_Data.mat' );
gaze_data = load( '/Users/nick/Downloads/Dot_Eyes_Data.mat' );
data_root = '/Volumes/external3/data/changlab/siqi/stim';

%%

gaze_f = char( fieldnames(gaze_data) );
days = fieldnames( gaze_data.(gaze_f) );
all_days = get_day_labels();

all_stim_ts = [];
all_stim_ls = {};
all_measures = [];

day_ls = {};
run_ls = {};
regions = [];

fnames = { ...
    'm1_distance_to_eyes', 'm1_average_distance_to_eyes' ...
  , 'm1_average_distance_to_eyes_contra' ...
  , 'm1_average_distance_to_eyes_ipsi', 'average_interactive_latency' ...
  , 'causal_m1m2_eyes', 'interlooking_interval' ...
};

for i = 1:numel(days)
  runs = fieldnames( gaze_data.(gaze_f).(days{i}) );
  
  n = 0;
  for j = 1:numel(runs)
    stim_set = gaze_data.(gaze_f).(days{i}).(runs{j});
    stim_ts = stim_set.stim_time;
    stim_ls = stim_set.current_label;
    stim_fs = setdiff( fieldnames(stim_set), {'stim_time', 'current_label'} );
    stim_ns = fcat.parse( stim_fs', 'stim_' );
    [~, ord] = sort( stim_ns );
    
    measures = nan( numel(ord), numel(fnames) );
    for k = 1:numel(ord)
      stim_d = stim_set.(stim_fs{ord(k)});
      
      for h = 1:numel(fnames)
        if ( isfield(stim_d, fnames{h}) )
          measures(k, h) = stim_d.(fnames{h})(1);
        end
      end
%       
%       measures = cellfun( @(x) columnize(...
%         cellfun(@(y) stim_set.(y).(x)(1), stim_fs(ord))), fnames, 'un', 0 );
%       measures = horzcat( measures{:} );
    end
    
    all_stim_ls = [ all_stim_ls; stim_ls(:) ];
    all_stim_ts = [ all_stim_ts; stim_ts(:) ];
    all_measures = [ all_measures; measures ];
    run_ls = [ run_ls; repmat(runs(j), numel(stim_ls), 1) ];
    
    n = n + numel( stim_ls );
  end
  
  day_lab = strrep( days(i), 'data_', '' );
  day_ls = [ day_ls; repmat(day_lab, n, 1) ];
  match_day = strcmp( all_days.session, day_lab );
  assert( sum(match_day) == 1 );
  regions = [ regions; repmat(all_days.region(match_day), n, 1) ];
end

vars = arrayfun( @(x) all_measures(:, x), 1:size(all_measures, 2), 'un', 0 );
gaze_tbl = table( all_stim_ts, string(all_stim_ls), string(day_ls), string(run_ls), regions, vars{:} ...
  , 'va', [{'stim_time', 'stim_type', 'session', 'run', 'region'}, fnames] );

if ( 1 )
  save( fullfile(data_root, 'intermediates/gaze_data_tables', 'dot.mat'), 'gaze_tbl' );
end