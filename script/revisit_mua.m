pl2_p = '/Users/nick/Downloads/diagnose_mua';

% session_dir = '07312019';
% pl2 = fullfile( pl2_p, 'Lynch_OFC_07312019.pl2' );

% session_dir = '02022020';
% pl2 = fullfile( pl2_p, 'Lynch_OFC_02022020.pl2' );

% session_dir = '05192022';
% pl2 = fullfile( pl2_p, 'Lynch_OFC_02022020.pl2' );

session_dir = '02192022';
% pl2 = fullfile( pl2_p, 'Lynch_OFC_02022020.pl2' );

stim_file_paths = shared_utils.io.findmat( '/Users/nick/Downloads/stim/stim' );

match_stim_file_paths = stim_file_paths(contains(stim_file_paths, session_dir));
stim_files = cellfun( @shared_utils.io.fload, match_stim_file_paths );

sham_ts = horzcat( stim_files.sham_times );
target_intervals = [ sham_ts(:), sham_ts(:) + 5 ];
    
chans = [1, 9];
chans = chans(is_wb_channel(pl2, chans));

%%

chans = 1:16;
chans = chans(is_wb_channel(pl2, chans));

for i = 11:numel(chans)
  
fprintf( '\n %d of %d', i, numel(chans) );

pl2_file = pl2;

chan_str = wb_channel_str( chans(i) );
ad = PL2Ad( pl2_file, chan_str );
t = (0:numel(ad.Values)-1) / ad.ADFreq;

[mua{i}, sd] = signal_to_mua( ad.Values, ad.ADFreq ...
  , 'target_intervals', target_intervals ...
  , 'ignore_intervals', false ...
  , 'num_std_devs', 3 ...
);

end

%%

nsd = 2;

[mua2, sd] = signal_to_mua( ad.Values, ad.ADFreq ...
  , 'target_intervals', target_intervals ...
  , 'ignore_intervals', false ...
  , 'num_std_devs', nsd ...
  , 'filter_60hz_order', 2 ...
  , 'filter_60hz_type', 'iirnotch' ...
);

%

spike_ts = PL2Ts( pl2_p, 'SPK01', 0 );
pl2_mua = ismember( t, spike_ts );

%%

save( '~/Downloads/mua_02192022.mat','pl2_mua', 'mua2', 't' );

%%

mua_f = load( '~/Downloads/diagnose_mua/Downloads_mua_05192022.mat' );
mua = mua_f.mua1;
mua2 = mua_f.mua2;
t = (0:371448359-1) / 40e3;

%%

mua_test_f = load( '~/Downloads/diagnose_mua/mua_test.mat' );

%%

mua_05272022 = load( '~/Downloads/diagnose_mua/mua_05272022.mat' );
t = (0:321047797-1) / 40e3;

%%

mua_02192022 = load( '~/Downloads/diagnose_mua/mua_02192022.mat' );
t = (0:387714474-1) / 40e3;

%%

non_dot_ps = ~contains(match_stim_file_paths, 'dot_');

lb = -0.5;
la = 5;
bw = 0.05;

num_sham = numel( horzcat(stim_files(non_dot_ps).sham_times) );
num_stim = numel( horzcat(stim_files(non_dot_ps).stimulation_times) );
align_ts = [ horzcat(stim_files(non_dot_ps).sham_times) ...
  , horzcat(stim_files(non_dot_ps).stimulation_times) ];

% mua1_t = t(mua);
% mua1_t = t(mua2);
% mua2_t = t(mua_test_f.mua_test);

mua1_t = t(mua_02192022.pl2_mua);
mua2_t = t(mua_02192022.mua2);

% [mua1_psth, psth_t] = bfw.trial_psth( mua1_t(:), align_ts(:), lb, la, bw );
[mua1_psth, psth_t] = psth2( mua1_t(:), align_ts(:), lb, la, bw );

% mua2_psth = bfw.trial_psth( mua2_t(:), align_ts(:), lb, la, bw );
mua2_psth = psth2( mua2_t(:), align_ts(:), lb, la, bw );

type_ls = [ repmat({'sd-2'}, numel(align_ts), 1) ...
    ; repmat({'plex-sd'}, numel(align_ts), 1) ];
stim_ls = repmat( [repmat({'sham'}, num_sham, 1); repmat({'stim'}, num_stim, 1)], 2, 1 );
  
labs = fcat.create( 'type', type_ls, 'stim', stim_ls );

%%

mua_dat = [ mua1_psth; mua2_psth ];

pl = plotlabeled.make_common();
pl.add_errors = true;
pl.x = psth_t;
pl.match_y_lims = false;
axs = pl.lines( mua_dat ./ 1 ./ bw, labs, 'stim', 'type' );

figure( 1 );

%%

function [r, t] = psth2(ts, events, lb, la, bw)

t = lb:bw:la;

r = nan( numel(events), numel(t) );
for i = 1:numel(events)
  t_series = events(i) + t;
  r(i, :) = histc( ts, t_series );
end

r = r(:, 1:end-1);
t = t(1:end-1);

end