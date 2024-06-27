function chan_str = fp_channel_str(c)
chan_str = ternary( c < 10, sprintf('FP0%d', c), sprintf('FP%d', c) );
end