%%  define pl2 file

raw_dir = '/media/chang/T41/data/bfw/stim-task-siqi/raw';
sesh_dir = '07282022';

pl2_dir = fullfile( raw_dir, sesh_dir );
pl2_f = char( shared_utils.io.find(pl2_dir, '.pl2', true) );

%%  get spike times

sorted_tbl = get_spike_ts( pl2_f, sesh_dir );

%%  load pl2

[~, file_table] = findeach( sorted_tbl, {'file', 'channel'} );
file_table.ad = cell( size(file_table, 1), 1 );
for i = 1:size(file_table, 1)
% for i = 1
  spk_chan = strrep( file_table.channel{i}, 'SPK', 'WB' );
  file_table.ad{i} = PL2Ad( file_table.file{i}, spk_chan );
end

%%  plot waveforms

num_wfs = 100;

lb_s = -1e-3;
la_s = 1e-3;

[chan_I, chan_C] = findeach( sorted_tbl, {'file', 'channel', 'session', 'unit'} );

figure(1); clf;
axs = plots.panels( numel(chan_I) );

for i = 1:numel(chan_I)
  ad_ind = strcmp( file_table.file, chan_C.file{i} ) & ...
           strcmp( file_table.channel, chan_C.channel{i} );
  ad = file_table.ad{ad_ind};
  
  ax = axs(i);
  hold( ax, 'on' );
  ci = chan_I{i};
  title( ax, sprintf('%s | %s | unit %d' ...
      , chan_C.session{i}, chan_C.channel{i}, chan_C.unit(i)) );
  
  colors = hsv( numel(ci) );
  for j = 1:numel(ci)
    ts = sorted_tbl.time{ci(j)};
    wf_ts = randsample( ts, min(numel(ts), num_wfs) );
    wfs = extract_wf( wf_ts, ad.ADFreq, ad.Values, lb_s, la_s );
    t = linspace( lb_s, la_s, size(wfs, 2) );    
    h = plot( ax, t, wfs );
    set( h, 'color', colors(j, :) );
    
    mu_wf = mean_wf( ts, ad.ADFreq, ad.Values, lb_s, la_s );
    h = plot( ax, t, mu_wf );
    set( h, 'color', [0, 0, 0], 'linewidth', 4 );
  end
end

%%

function wf = mean_wf(ts, fs, values, lb_s, la_s)

if ( isempty(ts) )
  wf = [];
  return
end

ts = floor( ts * fs ) + 1;
t0 = floor( ts + lb_s * fs );
t1 = floor( ts + la_s * fs );

wf = nan( 1, t1(1) - t0(1) + 1 );
for i = 1:numel(wf)
  wf(i) = mean( values(t0 + (i - 1)) );
end

end

function wfs = extract_wf(ts, fs, values, lb_s, la_s)

ts = floor( ts * fs ) + 1;
t0 = floor( ts + lb_s * fs );
t1 = floor( ts + la_s * fs );
wfs = cate1( arrayfun(@(x) values(t0(x):t1(x))', 1:numel(t0), 'un', 0) );

end