function tbl = parse_siqi_xls(raw)

dates = raw(:, 1);
not_char = ~cellfun( @ischar, dates );
dates(not_char) = {''};
is_date = cellfun( @(x) sum(isstrprop(x, 'digit')) == numel('02242022'), dates );

days = dates(is_date);
monks = raw(is_date, 2);
regs = raw(is_date, 3);
chans = raw(is_date, 4);
ratings = raw(is_date, 6);

assert( all(cellfun('isclass', ratings, 'double')) );
assert( all(cellfun('isclass', chans, 'double')) );
assert( isequal(unique(cellfun(@numel, chans)), 1) );
assert( isequal(unique(cellfun(@numel, ratings)), 1) );

ls = { 'acc', 'ofc', 'dmpfc' };
for i = 1:numel(ls)
  regs(contains(regs, ls{i}, 'IgnoreCase', true)) = ls(i);
end

tbl = table( days(:), monks(:), regs(:), vertcat(chans{:}), vertcat(ratings{:}) ...
  , 'va', {'session', 'id_m1', 'region', 'channel', 'rating'} );

end