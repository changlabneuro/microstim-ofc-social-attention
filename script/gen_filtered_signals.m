int_p = '/media/chang/T41/data/bfw/stim-task-siqi/intermediates';
dst_p = fullfile( int_p, 'mua_prctile' );
shared_utils.io.require_dir( dst_p );

pl2_mat_p = fullfile( int_p, 'pl2_mat' );
pl2_mats = shared_utils.io.findmat( pl2_mat_p );

for i = 1:numel(pl2_mats)

fprintf( '\n %d of %d', i, numel(pl2_mats) );

fprintf( '\n\t Loading ... ' );
pl2_ad = shared_utils.io.fload( pl2_mats{i} );
pl2_fname = shared_utils.io.filenames( pl2_mats{i} );
fprintf( 'Done.' );

fprintf( '\n\t Filtering ... ' );
filt = mua_filter( double(pl2_ad.Values), pl2_ad.ADFreq );
res = struct( 'Values', single(filt), 'ADFreq', pl2_ad.ADFreq );
fprintf( 'Done.' );

if ( 1 )
  fprintf( '\n\t Saving ... ' );
  shared_utils.io.psave( fullfile(dst_p, sprintf('%s.mat', pl2_fname)), res );
  fprintf( 'Done.' );
end
  
end