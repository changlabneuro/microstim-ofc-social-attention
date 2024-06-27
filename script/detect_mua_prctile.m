function [tf, thresh] = detect_mua_prctile(signal, fs, target_intervals, prc)

keep_signal = false( size(signal) );
for i = 1:size(target_intervals, 1)
  start_t = target_intervals(i, 1);
  stop_t = target_intervals(i, 2);
  
  start_ind = max( 1, min(floor(start_t * fs), numel(signal)) );
  stop_ind = max( 1, min(floor(stop_t * fs), numel(signal)) );
  keep_signal(start_ind:stop_ind) = true;
end

thresh = prctile( abs(signal(keep_signal)), prc );
tf = signal > thresh;

end