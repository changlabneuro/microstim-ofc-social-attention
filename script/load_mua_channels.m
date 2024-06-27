function tbls = load_mua_channels(pl2_file, channels, varargin)

defaults.target_intervals = [];
defaults.ignore_intervals = true;

params = shared_utils.general.parsestruct( defaults, varargin );

tbls = {};

for i = 1:numel(channels)
  chan_str = wb_channel_str( channels(i) );
  ad = PL2Ad( pl2_file, chan_str );
  [mua, sd] = signal_to_mua( ad.Values, ad.ADFreq ...
    , 'target_intervals', params.target_intervals ...
    , 'ignore_intervals', params.ignore_intervals ...
  );

  tbls{end+1, 1} = to_mua_tbl( mua, sd, channels(i), chan_str, pl2_file );
end

end