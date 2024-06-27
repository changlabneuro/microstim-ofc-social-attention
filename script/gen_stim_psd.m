data_root = '/Volumes/external3/data/changlab/siqi';

event_p = fullfile( data_root, 'stim/Events' );
search_ps = { 'raw_events_Lynch_dot', 'raw_events_Lynch_gaze', 'raw_events_Tarantino_dot_eyes', 'raw_events_Tarantino_gaze_eyes' };
event_ps = shared_utils.io.fullfiles( event_p, search_ps );
sesh_names = unique( shared_utils.io.filenames(shared_utils.io.findmat(event_ps)) );

%%

int_p = fullfile( data_root, 'stim/intermediates' );
lfp_p = fullfile( int_p, 'lfp' );
stim_p = fullfile( int_p, 'stim' );
time_p = fullfile( int_p, 'aligned_raw_samples/time' );
dst_p = fullfile( int_p, 'stim_psd' );
shared_utils.io.require_dir( dst_p );

lfp_mats = shared_utils.io.findmat( lfp_p );
lfp_sesh = cellfun( @(x) x(1:8), shared_utils.io.filenames(lfp_mats), 'un', 0 );

time_mats = shared_utils.io.findmat( time_p );
ps = bfw.matched_files( time_mats, stim_p );

stim_names = shared_utils.io.filenames( ps(:, 1) );
stim_sesh = cellfun( @(x) x(1:8), stim_names, 'un', 0 );
[stim_names, ia] = intersect( stim_names, sesh_names );
stim_sesh = stim_sesh(ia);
ps = ps(ia, :);

t0 = -1e3;
t1 = 5e3 + 150;

for i = 1:numel(lfp_sesh)  
  fprintf( '\n %d of %d', i, numel(lfp_sesh) );
  
  matchi = find( strcmp(stim_sesh, lfp_sesh{i}) );
  if ( isempty(matchi) )
    fprintf( '\n Skipping "%s".', lfp_sesh{i} );
    continue;
  end
  
  tot_stim_ts = [];
  tot_stim_labs = {};
  for j = 1:numel(matchi)
    mi = matchi(j);
    time_file = shared_utils.io.fload( ps{mi, 1} );
    stim_file = shared_utils.io.fload( ps{mi, 2} );
    [stim_ts, stim_labs] = extract_valid_stim_times( stim_file, time_file.t );
    
    stim_labs(:, end+1) = lfp_sesh(i);
    stim_labs(:, end+1) = stim_names(mi);
    tot_stim_ts = [ tot_stim_ts; stim_ts ];
    tot_stim_labs = [ tot_stim_labs; stim_labs ];
  end
  
  lfp_file = shared_utils.io.fload( lfp_mats{i} );
  lfp_tbl = vertcat( lfp_file{:} );
  
  %%  do lfp calc
  
  lfp_ts = (0:numel(lfp_tbl.lfp{1})-1) / lfp_tbl.fs{1};
  [istart, istop] = align_time_series( lfp_ts, tot_stim_ts, t0, t1 );
  
  [psd, psd_labs, psd_f, psd_ti, labi] = do_psd( lfp_tbl, istart, istop );
  psd_t = t0:t1;
  psd_t = arrayfun( @(x) psd_t(x), psd_ti{1} );
  psd_labs = [ psd_labs, tot_stim_labs(labi, :) ];
  psd_cats = { 'channel', 'pl2_filename', 'stim_type', 'session', 'unified_filename' };
  assert( numel(psd_cats) == size(psd_labs, 2) );
  
  %%
  
  keep_f = psd_f < 100;
  psd_f = psd_f(keep_f);
  psd = psd(:, keep_f, :);
  assert( numel(psd_f) == size(psd, 2) && numel(psd_t) == size(psd, 3) );
  assert( size(psd_labs, 1) == size(psd, 1) );
  
  save_p = fullfile( dst_p, shared_utils.io.filenames(lfp_mats{i}, true) );
  fprintf( '\n Saving "%s".', dst_p );
  do_save( save_p, psd, psd_labs, psd_cats, psd_f, psd_t );
  fprintf( ' Done.' );
  
end

function [tot_psd, tot_psd_labs, f, ti, labeli] = do_psd(lfp_tbl, istart, istop)

tot_psd = [];
tot_psd_labs = {};
labeli = [];
ti = {};

for c = 1:numel(size(lfp_tbl, 1))
  lfp = lfp_preprocess( lfp_tbl.lfp{c} );
  
  for j = 1:numel(istart)
    inds = shared_utils.vector.slidebin( istart(j):istop(j), 150, 50, true );
    lfp_sub = cellfun( @(x) lfp(x), inds, 'un', 0 );
    [psd, f] = cellfun( @(x) chronux_psd(x), lfp_sub, 'un', 0 );
    psd = permute( cat(2, psd{:}), [1, 2] );
    f = f{1};
    
    tot_psd = [ tot_psd; reshape(psd, [1, size(psd)]) ];
    ti{j, 1} = cellfun( @(x) x(1) - istart(j) + 1, inds );
  end
  
  lfp_row = lfp_tbl(c, :);
  lfp_labs = repmat( [lfp_row.channel_str, lfp_row.pl2_file], numel(istart), 1 );
  tot_psd_labs = [ tot_psd_labs; lfp_labs ];
  labeli = [ labeli; (1:numel(istart))' ];
end

end

function do_save(save_p, psd, psd_labs, psd_cats, psd_f, psd_t)

save( save_p, 'psd', 'psd_labs', 'psd_cats', 'psd_f', 'psd_t', '-v7.3' );

end