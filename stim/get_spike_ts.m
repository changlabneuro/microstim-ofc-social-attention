function [sorted_tbl, unsorted_tbl] = get_spike_ts(pl2_f, session)

pl2_info = PL2GetFileIndex( pl2_f );
is_enabled = logical( cellfun(@(x) x.Enabled, pl2_info.SpikeChannels) );

enabled_ind = find( is_enabled );

sorted_tbl = table();
unsorted_tbl = table();

for i = 1:numel(enabled_ind)
  spk_chan = pl2_info.SpikeChannels{enabled_ind(i)};
  num_units = spk_chan.NumberOfUnits;
  unsorted = PL2Ts( pl2_f, spk_chan.Name, 0 );
  unsorted_tbl(end+1, :) = table( ...
    {pl2_f}, {unsorted(:)}, {spk_chan.Name}, 0, cellstr(session), 'VariableNames' ...
      , {'file', 'time', 'channel', 'unit', 'session'} );
  
  sorted = cell( num_units, 1 );
  for j = 1:num_units
    sorted_ts = PL2Ts( pl2_f, spk_chan.Name, j );
    sorted_tbl(end+1, :) = table( ...
      {pl2_f}, {sorted_ts(:)}, {spk_chan.Name}, j, cellstr(session), 'VariableNames' ...
      , {'file', 'time', 'channel', 'unit', 'session'} );
  end
end

end