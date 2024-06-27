function x = lfp_preprocess(x)

x = x - mean( x );
x = dsp3.zpfilter( x(:)', 2.5, 250, 1e3, 2 );

end