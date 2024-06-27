% src_p = 'C:\data\bfw-stim-task\raw';
src_p = '/media/chang/T41/data/bfw/stim-task-siqi/raw';
dst_p = fullfile( fileparts(src_p), 'intermediates/lfp' );
shared_utils.io.require_dir( dst_p );

% session_dirs = { '07182022', '07252022' };
session_dirs = shared_utils.io.find( src_p, 'folders' );
session_dirs = shared_utils.io.filenames( session_dirs );

session_ps = fullfile( src_p, session_dirs );
session_ps = cellfun( @(x) fullfile(x, 'plex'), session_ps, 'un', 0 );

for i = 1:numel(session_ps)
  shared_utils.general.progress( i, numel(session_ps) );
  
  pl2s = shared_utils.io.find( session_ps{i}, '.pl2' );
  
  if ( numel(pl2s) == 1 )
    pl2 = pl2s{1};
    
    dst_filename = sprintf( '%s_%s.mat', session_dirs{i}, shared_utils.io.filenames(pl2) );
    dst_file_p = fullfile( dst_p, dst_filename );
    if ( exist(dst_file_p) > 0 )
      fprintf( '\n\t Skipping, already exists.' );
      continue;
    end
    
    chans = [1, 9];
    chans = chans(is_wb_channel(pl2, chans));
    lfp_tbls = load_lfp_channels( pl2, chans );
    save( dst_file_p, 'lfp_tbls', '-v7.3' );
    
  elseif ( numel(pl2s) ~= 0 )
    warning( 'More than 1 pl2 file in %s.', session_ps{i} );
  end
end