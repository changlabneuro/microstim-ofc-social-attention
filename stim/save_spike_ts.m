raw_dir = '/media/chang/T41/data/bfw/stim-task-siqi/raw';
dst_p = fullfile( fileparts(raw_dir), 'intermediates/spike_ts' );
shared_utils.io.require_dir( dst_p );

[~, ~, raw] = xlsread( '~/Downloads/Microstimulation neural data.xlsx' );
pl2_meta_tbl = parse_siqi_xls( raw );

for i = 1:size(pl2_meta_tbl, 1)
  fprintf( '\n %d of %d', i, size(pl2_meta_tbl, 1) );
  sesh_dir = pl2_meta_tbl.session{i};
  pl2_dir = fullfile( raw_dir, sesh_dir );
  pl2_f = char( shared_utils.io.find(pl2_dir, '.pl2', true) );
  [sorted_tbl, unsorted_tbl] = get_spike_ts( pl2_f, sesh_dir );
  
  pl2_fname = shared_utils.io.filenames( pl2_f );
  save( fullfile(dst_p, sprintf('%s.mat', pl2_fname)), 'sorted_tbl', 'unsorted_tbl' );
end