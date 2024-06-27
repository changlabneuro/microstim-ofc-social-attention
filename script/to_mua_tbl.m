function tbl = to_mua_tbl(mua, sd, channel, chan_str, pl2_file)

t = {mua, sd, channel, chan_str, shared_utils.io.filenames(pl2_file, true)};
vars = {'mua', 'std', 'channel', 'channel_str', 'pl2_file'};
tbl = array2table( t, 'VariableNames', vars );

end