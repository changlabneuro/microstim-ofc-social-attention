function y = mua_filter(signal, fs, varargin)

defaults.remove_60hz = true;
defaults.filter_60hz_order = 2;
defaults.filter_60hz_type = 'designfilt';
defaults.filter_f0 = 600;
defaults.filter_f1 = 3000;
defaults.filter_order = 3;

params = shared_utils.general.parsestruct( defaults, varargin );

y = do_filter( signal, fs, params );

end

function signal = do_filter(signal, fs, params)

assert( isvector(signal) );
signal = bfw.zpfilter( signal(:)' ...
  , params.filter_f0, params.filter_f1, fs, params.filter_order );

if ( params.remove_60hz )
  filt_type = validatestring( params.filter_60hz_type ...
    , {'designfilt', 'iirnotch'}, mfilename, 'filter_60hz_type' );
  
  switch ( filt_type )
    case 'designfilt'
      signal = remove_60hz_design_filt( signal, fs, params.filter_60hz_order );
    case 'iirnotch'
      signal = remove_60hz_iir_notch( signal, fs, params );
    otherwise
      error( 'Unhandled filt_type "%s".', filt_type );
  end
end

end

function res = remove_60hz_iir_notch(signal, fs, params)

wo = 60/(fs/2);  
bw = wo/35;
[b,a] = iirnotch(wo,bw);
res = filtfilt( b, a, signal );

end

function res = remove_60hz_design_filt(signal, fs, filt_order)

% https://www.mathworks.com/help/signal/ug/remove-the-60-hz-hum-from-a-signal.html

assert( isvector(signal) );

d = designfilt('bandstopiir','FilterOrder', filt_order, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',fs);
             
res = filtfilt( d, signal );

end