int_p = '/Volumes/external3/data/changlab/siqi/stim/intermediates';
dst_p = fullfile( int_p, 'microsaccades' );
shared_utils.io.require_dir( dst_p );

time_p = fullfile( int_p, 'aligned_raw_samples/time' );
pos_mats = shared_utils.io.findmat( fullfile(int_p, 'aligned_raw_samples/position') );
pos_fnames = shared_utils.io.filenames( pos_mats, true );

% can't parfor because `detect_microsaccades` uses a library that
% reads/writes to disk
for i = 1:numel(pos_mats)
  
fprintf( '\n %d of %d', i, numel(pos_mats) );
  
pos_file = shared_utils.io.fload( pos_mats{i} );
t_file = shared_utils.io.fload( fullfile(time_p, pos_fnames{i}) );

first_non_nan = find( ~isnan(t_file.t), 1 );
m1_p = pos_file.m1(:, first_non_nan:end);
t = reshape( t_file.t(first_non_nan:end), [], 1 )';
fixi = do_fix_detect( m1_p, t );

fs = 1e3;
pos_deg = bfw.px2deg( m1_p );
microsaccades = detect_microsaccades( pos_deg, fs, tempdir );

isect_sample_threshold = 50;
saccade_labels = label_saccades( fixi, microsaccades, isect_sample_threshold );
save( fullfile(dst_p, pos_fnames{i}), 'microsaccades', 'saccade_labels' );

end

%%

function fixi = do_fix_detect(p, t)

% repositories/eyelink
is_fix = is_fixation( p, t, 20, 10, 0.03 );
is_fix = logical( is_fix(1:numel(t)) );

[fix_starts, fix_durs] = shared_utils.logical.find_islands( is_fix );
fix_stops = fix_starts + fix_durs - 1;
fixi = [ fix_starts(:), fix_stops(:) ];

end