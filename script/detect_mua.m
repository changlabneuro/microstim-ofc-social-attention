function [tf, sd] = detect_mua(signal, fs, target_intervals, ignore_intervals, num_devs)

keep_signal = true( size(signal) );
for i = 1:size(target_intervals, 1)
  start_t = target_intervals(i, 1);
  stop_t = target_intervals(i, 2);
  
  start_ind = max( 1, min(floor(start_t * fs), numel(signal)) );
  stop_ind = max( 1, min(floor(stop_t * fs), numel(signal)) );
  keep_signal(start_ind:stop_ind) = false;
end

if ( ~ignore_intervals )
  keep_signal = ~keep_signal;
end

sd = std( signal(keep_signal) );
tf = signal > sd * num_devs;

end