function [s, f] = chronux_psd(x)

[s, f] = mtspectrumc( x(:), struct('Fs', 1e3, 'tapers', [1.5, 2]) );

end