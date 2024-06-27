data_root = '/Volumes/external3/data/changlab/siqi/stim';
int_p = fullfile( data_root, 'intermediates' );

psth_ps = { 'mua_psth/5_ms' };

tot_tbl = table();
for idx = 1:numel(psth_ps)

mua_psth_p = fullfile( int_p, psth_ps{idx} );
mua_fs = shared_utils.io.findmat( mua_psth_p );

tmp_tbl = cell( numel(mua_fs), 1 );
for i = 1:numel(mua_fs)
  mua_tbl = shared_utils.io.fload( mua_fs{i} );
  tmp_tbl{i} = mua_tbl;
end

tot_tbl = [ tot_tbl; vertcat(tmp_tbl{:}) ];

end

num_devs = 1;

[sesh_I, sesh_C] = findeach( tot_tbl, {'session', 'region'} );
sesh_means = cellfun( @(x) nanmean(tot_tbl.pre_stim_fr(x)), sesh_I );

I = findeach( sesh_C, {'region'} );

is_outlier = false( numel(sesh_I), 1 );
for i = 1:numel(I)
  sm = log( sesh_means(I{i}) );
  mu = mean( sm );
  std_sm = std( sm );
  is_outlier(I{i}) = sm < mu - std_sm * num_devs | sm > mu + std_sm * num_devs;
end

sesh_C.is_outlier = is_outlier;

if ( 1 )
  dst_p = fullfile(int_p, 'mua_outlier_sessions', 'outlier_sessions.mat' );
  save( dst_p, 'sesh_C' );
end

%%