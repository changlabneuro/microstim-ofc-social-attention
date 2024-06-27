function [stim_ts, stim_labs] = extract_valid_stim_times(stim_file, t)

[stim_ts, stim_labs] = concat_stim_ts( stim_file );
[stim_ts, ind] = apply_stim_crit( stim_ts, t );
stim_labs = stim_labs(ind);

end

function [ts, labs] = concat_stim_ts(stim_file)

stim_ts = stim_file.stimulation_times(:);
sham_ts = stim_file.sham_times(:);

labs = [ repmat({'stim'}, numel(stim_ts), 1); repmat({'sham'}, numel(sham_ts), 1) ];
ts = [ stim_ts; sham_ts ];
[ts, ord] = sort( ts );
labs = labs(ord);

end

function [stim_ts, ind] = apply_stim_crit(stim_ts, sesh_t)

keep_t = stim_ts >= min( sesh_t ) & stim_ts < max( sesh_t ) - 5;
ind = find( keep_t );
ind = ind(2:end);
stim_ts = stim_ts(ind);

end