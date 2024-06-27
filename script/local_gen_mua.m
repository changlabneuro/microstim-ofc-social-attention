int_p = '/Volumes/external3/data/changlab/siqi/stim/intermediates';
dst_p = fullfile( int_p, 'mua_prctile' );
shared_utils.io.require_dir( dst_p );

pl2_mat_p = fullfile( int_p, 'pl2_mat' );
pl2_mats = shared_utils.io.findmat( pl2_mat_p );

% pl2_mats = pl2_mats(contains(pl2_mats, '03172022')); 

days = { '03172022', '02032022' };
has_day = cellfun( @(x) contains(pl2_mats, x), days, 'un', 0 );
has_day = or_many( has_day{:} );
pl2_mats = pl2_mats(has_day);

% load stim/sham times
gaze_tbl = shared_utils.io.fload( fullfile(int_p, 'gaze_data_tables/eyes.mat') );

for i = 1:numel(pl2_mats)

fprintf( '\n %d of %d', i, numel(pl2_mats) );
  
pl2_ad = shared_utils.io.fload( pl2_mats{i} );
pl2_fname = shared_utils.io.filenames( pl2_mats{i} );
pl2_session = pl2_fname(1:8);

match_day = string( gaze_tbl.session ) == pl2_session;
assert( sum(match_day) > 0 );

sham_ts = gaze_tbl{match_day & gaze_tbl.stim_type == 'sham', 'stim_time'};
target_intervals = [ sham_ts(:)+2, sham_ts(:)+4 ];

filt = mua_filter( double(pl2_ad.Values), pl2_ad.ADFreq );
% [mua, sd] = detect_mua( filt, pl2_ad.ADFreq, target_intervals, false, 3 );
[mua, sd] = detect_mua_prctile( filt, pl2_ad.ADFreq, target_intervals, 99 );
mua_tbl = to_mua_tbl( mua, sd, 9, 'WB09', pl2_mats{i} );

if ( 1 )
  save( fullfile(dst_p, sprintf('%s.mat', pl2_fname)), 'mua_tbl' );
end
  
end