function tf = is_wb_channel(pl2_file, n)

tf = false( size(n) );
ind = PL2GetFileIndex( pl2_file );
ind = ind.AnalogChannels;
for i = 1:numel(n)
  n_str = wb_channel_str( n(i) );
  match_str = find( cellfun(@(x) strcmp(x.Name, n_str), ind) );
  if ( numel(match_str) == 1 )
    tf(i) = ind{match_str}.NumValues > 0;
  end
end

end