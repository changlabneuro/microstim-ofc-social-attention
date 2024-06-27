function sacc_type = label_saccades(...
  fix_start_stop, sacc_start_stop, isect_sample_threshold)

make_interval = @(s) arrayfun(@(i) s(i, 1):s(i, 2), 1:size(s, 1), 'un', 0 );
sacc_intervals = make_interval( sacc_start_stop );
fix_intervals = make_interval( fix_start_stop );

sacc_type = strings( numel(sacc_intervals), 1 );
for i = 1:numel(sacc_intervals)
  sacci = sacc_intervals{i};
  
  if ( 1 )
    % label a microsaccade based on whether it is contained within a
    % fixation; it should be at least isect_sample_threshold away from
    % the start of the fixation, and at least isect_sample_threshold away
    % from the end of the fixation.
    s_start = sacci(1);
    
    is_ms = false;
    for j = 1:numel(fix_intervals)
      [f_start, f_stop] = deal( fix_intervals{j}(1), fix_intervals{j}(end) );      
      gt_start = s_start - f_start >= isect_sample_threshold;
      lt_stop = f_stop - s_start >= isect_sample_threshold;
      is_ms = is_ms || (gt_start && lt_stop);
    end
  else
    isect_crit = @(x, y) numel(intersect(x, y)) > isect_sample_threshold;
    sacc_within_fix = cellfun( @(x) isect_crit(sacci, x), fix_intervals );
    is_ms = any( sacc_within_fix );
  end
  
  if ( is_ms )
    sacc_type(i) = "microsaccade";
  else
    sacc_type(i) = "macrosaccade";
  end
end

end