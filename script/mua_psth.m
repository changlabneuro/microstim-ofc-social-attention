function [psth, ts] = mua_psth(mua, evt_ts, lb, la, win, fs)

trace_t0 = floor( (evt_ts(:) + lb) * fs ) + 1;
trace_t1 = trace_t0 + floor( (la - lb) * fs );

curr_mua_traces = cate1( arrayfun(@(x, y) mua(x:y) .* fs, trace_t0, trace_t1-1, 'un', 0) );

bi = shared_utils.vector.slidebin( 1:size(curr_mua_traces, 2), win*fs );
ts = lb:win:la;
ts = ts(1:end-1);

psth = cate( 2, cellfun( @(x) nanmean(curr_mua_traces(:, x), 2), bi, 'un', 0) );

end