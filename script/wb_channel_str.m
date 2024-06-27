function chan_str = wb_channel_str(c)
chan_str = ternary( c < 10, sprintf('WB0%d', c), sprintf('WB%d', c) );
end