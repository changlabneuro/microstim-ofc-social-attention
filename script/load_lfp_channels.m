function tbls = load_lfp_channels(pl2_file, channels)

tbls = {};

for i = 1:numel(channels)
  chan_str = fp_channel_str( channels(i) );
  ad = PL2Ad( pl2_file, chan_str );

  t = {ad.Values(:), ad.ADFreq, channels(i), chan_str, shared_utils.io.filenames(pl2_file, true)};
  vars = {'lfp', 'fs', 'channel', 'channel_str', 'pl2_file'};
  tbls{end+1, 1} = array2table( t, 'VariableNames', vars );
end

end