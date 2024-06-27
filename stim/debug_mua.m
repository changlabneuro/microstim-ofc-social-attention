data_root = '/Volumes/external3/data/changlab/siqi/stim';

curr_sesh = '04262022';
ad = shared_utils.io.fload( fullfile(data_root, 'raw', curr_sesh, 'plex/eg_pl2.mat') );

%%

% load stim/sham times
gaze_tbl = shared_utils.io.fload( fullfile(data_root, 'intermediates/gaze_data_tables/eyes.mat') );
match_day = string( gaze_tbl.session ) == curr_sesh;
sham_ts = gaze_tbl{match_day & gaze_tbl.stim_type == 'sham', 'stim_time'};

% determine desired mua channel
[~, ~, raw] = xlsread( '~/Downloads/Microstimulation neural data.xlsx' );
pl2_meta_tbl = parse_siqi_xls( raw );
pl2_chan = pl2_meta_tbl.channel(string(pl2_meta_tbl.session) == curr_sesh);

% load mua and select desired channel
mua_p = fullfile( data_root, 'intermediates/mua' );
mua_mats = shared_utils.io.find( mua_p, '.mat' );
mua_f = mua_mats{contains(mua_mats, curr_sesh, 'ignorecase', 1)};

src_mua = load( mua_f ); 
src_mua = vertcat( src_mua.mua_tbls{:} );
src_mua = src_mua.mua{vertcat(src_mua.channel{:}) == pl2_chan};

%%

target_intervals = [sham_ts + 1, sham_ts + 4];

[mua, sd] = signal_to_mua( ad.Values, ad.ADFreq ...
  , 'target_intervals', target_intervals ...
  , 'ignore_intervals', false ...
);

%%

[psth_src, t] = mua_psth( src_mua, sham_ts(:), -1, 1, 0.01, ad.ADFreq );
psth_new = mua_psth( mua, sham_ts(:), -1, 1, 0.01, ad.ADFreq );

clf;
subplot( 1, 2, 1 );
plot( t, mean(psth_src) );
title( sprintf('%s | SD thresh based on [sham+0, sham+5] | sham', curr_sesh ) );

subplot( 1, 2, 2 );
plot( t, mean(psth_new) ); 
title( sprintf('%s | SD thresh based on [sham+1, sham+4] | sham', curr_sesh ) );