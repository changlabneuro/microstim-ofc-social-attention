data_root = '/Volumes/external3/data/changlab/siqi/stim';
int_p = fullfile( data_root, 'intermediates' );
plot_p = fullfile( data_root, 'plots/debug_unsorted_mua', dsp3.datedir );

% load stim/sham times
gaze_tbl = shared_utils.io.fload( fullfile(int_p, 'gaze_data_tables/eyes.mat') );

spike_fs = shared_utils.io.findmat( fullfile(int_p, 'spike_ts') );
pl2_fs = shared_utils.io.findmat( fullfile(int_p, 'pl2_mat') );
unsorted_v_p = fullfile( int_p, 'unsorted_peak_voltage' );

[~, ~, raw] = xlsread( '~/Downloads/Microstimulation neural data.xlsx' );
pl2_meta_tbl = parse_siqi_xls( raw );

sesh = '05272022';
sesh = '02032022';
% sesh = '03172022';
% sesh = '08212019';
% spike_fs = spike_fs(contains(spike_fs, sesh));

do_plot = false;

%%

for i = 1:numel(spike_fs)
  %%
  fprintf( '\n %d of %d', i, numel(spike_fs) );
  
  %%  
  
  pl2_fname = shared_utils.io.filenames( spike_fs{i} );
  match_pl2 = contains( pl2_fs, pl2_fname );
  if ( nnz(match_pl2) == 0 )
    continue;
  end
  
  assert( sum(match_pl2) == 1 );
  
  pl2_ad = shared_utils.io.fload( pl2_fs{match_pl2} );
  spike_ts = load( spike_fs{i} );
  
  sesh = spike_ts.unsorted_tbl.session{1};
  match_stim_sesh = gaze_tbl.session == sesh;
  assert( nnz(match_stim_sesh) > 0 );
  
  match_pl2_sesh = strcmp( pl2_meta_tbl.session, sesh );
  assert( nnz(match_pl2_sesh) == 1 );
  curr_pl2_rating = pl2_meta_tbl.rating(match_pl2_sesh);
  curr_region = pl2_meta_tbl.region{match_pl2_sesh};
  
  %%
  
  base_ts = spike_ts.unsorted_tbl.time{1};
%   base_ts = cate1( spike_ts.sorted_tbl.time );
  
  stim_t0s = gaze_tbl.stim_time(match_stim_sesh);
  stim_t1s = stim_t0s + 5;
  
  fr_t0s = stim_t0s - 0.5;
  fr_t1s = stim_t0s - 0.1;
  
  ib_stim_t = false( numel(base_ts), 1 );
  for j = 1:numel(base_ts)
    t = base_ts(j);
    if ( any(t >= stim_t0s & t <= stim_t1s) )
      ib_stim_t(j) = true;
    end
  end
  
  %%
  
  lb_s = -1.5e-3;
  la_s = 1.5e-3;
  allow_in_stim = true;
  
  %%
  
  peak_vs = extract_wf_peak_amplitude( ...
    base_ts, pl2_ad.ADFreq, pl2_ad.Values, lb_s, la_s, true );
  
  %%
  
  if ( 1 )
    save( fullfile(unsorted_v_p, sprintf('%s.mat', pl2_fname)) ...
      , 'peak_vs' );
  end
  
  if ( ~do_plot )
    continue
  end
  
  prc_threshs = [ 70, 80, 90, 95, 98 ];
  clf;
  axs = plots.panels( numel(prc_threshs) );
  
  for j = 1:numel(prc_threshs)  
    prc_thresh = prc_threshs(j);
    peak_thresh = prctile( peak_vs(~ib_stim_t), prc_thresh );

    if ( allow_in_stim )
      kept_ts = base_ts(peak_vs < peak_thresh);
    else
      kept_ts = base_ts(peak_vs < peak_thresh & ~ib_stim_t);
    end

    eg_spike_ts = sort( randsample(kept_ts, 100) );    
    wfs = extract_wf( eg_spike_ts, pl2_ad.ADFreq, pl2_ad.Values, lb_s, la_s, true );

    % plot
    plt_t = linspace( lb_s, la_s, size(wfs, 2) );    
    h = plot( axs(j), plt_t, wfs );

%     if ( 1 ), ylim( axs(j), [-0.15, 0.15] ); end
    shared_utils.plot.match_ylims( axs );

    % fr
    spike_fr = to_firing_rate( count_spikes(kept_ts, fr_t0s, fr_t1s), fr_t0s, fr_t1s );
    mu_fr = mean( spike_fr );

    sesh_str = unique( gaze_tbl.session(match_stim_sesh) );
    title_str = sprintf( '%s (%d) | keep %0.2f%% | mean %0.3f sp/s' ...
      , sesh_str, curr_pl2_rating, 100*pnz(keep_peak), mu_fr );

    hold( axs(j), 'on' );
    shared_utils.plot.add_horizontal_lines( axs(j), [peak_thresh, -peak_thresh], 'r--' );
    title( axs(j), title_str );
  end
  
  if ( 1 )
    save_fname = sprintf( 'rating_%d_%s_%s.png', curr_pl2_rating, curr_region, sesh );
    save_p = fullfile( plot_p, 'traces' );
    shared_utils.io.require_dir( save_p );
    save_p = fullfile( save_p, save_fname );
    saveas( gcf, save_p, 'png' );
  end
end

%%

function s = to_firing_rate(s, t0s, t1s)

dur = t1s - t0s;
s = s ./ 1 ./ dur;

end

function s = count_spikes(spike_ts, t0s, t1s)

assert( numel(t0s) == numel(t1s) );
s = nan( numel(t0s), 1 );
for i = 1:numel(t0s)
  s(i) = sum( spike_ts >= t0s(i) & spike_ts < t1s(i) );
end

end

function v = extract_wf_peak_amplitude(ts, fs, values, lb_s, la_s, detrend)

ts = floor( ts * fs ) + 1;
t0 = max( 1, floor(ts + lb_s * fs) );
t1 = min( numel(values), floor(ts + la_s * fs) );

v = nan( numel(t0), 1 );
for i = 1:numel(t0)
  vs = values(t0(i):t1(i));
  if ( detrend )
    vs = vs - mean( vs );
  end
  v(i) = max( abs(vs) );
end

end

function wfs = extract_wf(ts, fs, values, lb_s, la_s, detrend)

ts = floor( ts * fs ) + 1;
t0 = floor( ts + lb_s * fs );
t1 = floor( ts + la_s * fs );
wfs = cate1( arrayfun(@(x) values(t0(x):t1(x))', 1:numel(t0), 'un', 0) );

if ( detrend )
  wfs = wfs - mean( wfs, 2 );
end

end