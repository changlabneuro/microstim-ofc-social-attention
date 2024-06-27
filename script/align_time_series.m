function [start, stop] = align_time_series(t, events, look_back, look_ahead)

start = nan( numel(events), 1 );
stop = nan( numel(events), 1 );

for i = 1:numel(events)
  e = events(i);
  if ( isnan(e) )
    continue;
  end
  
  [~, ind] = min( abs(t - e) );
  ind = ind - 1;
  i0 = ind + look_back;
  i1 = ind + look_ahead;
  
  start(i) = i0 + 1;
  stop(i) = i1 + 2;
end

end