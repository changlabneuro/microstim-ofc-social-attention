% src_p = 'C:\data\bfw-stim-task\raw';
src_p = '/media/chang/T41/data/bfw/stim-task-siqi/raw';
dst_p = fullfile( fileparts(src_p), 'intermediates/mua-revisit' );
dst_pl2_mat_p = fullfile( fileparts(src_p), 'intermediates/pl2_mat' );
shared_utils.io.require_dir( dst_p );
shared_utils.io.require_dir( dst_pl2_mat_p );

% session_dirs = { '07182022', '07252022' };
session_dirs = shared_utils.io.find( src_p, 'folders' );
session_dirs = shared_utils.io.filenames( session_dirs );

% session_dirs = { '04262022' };

session_ps = fullfile( src_p, session_dirs );
session_ps = cellfun( @(x) fullfile(x, 'plex'), session_ps, 'un', 0 );

if ( ~exist('allow_overwrite', 'var') )
  allow_overwrite = false;
end

% stim_file_paths = shared_utils.io.findmat( fullfile(src_p, '../intermediates/stim') );

for i = 1:numel(session_ps)
  shared_utils.general.progress( i, numel(session_ps) );
  
  pl2s = shared_utils.io.find( session_ps{i}, '.pl2' );
  
  if ( numel(pl2s) == 1 )
    pl2 = pl2s{1};
    
    pl2_fname = shared_utils.io.filenames( pl2 );
    dst_filename = sprintf( '%s_%s.mat', session_dirs{i}, pl2_fname );
    dst_file_p = fullfile( dst_p, dst_filename );
    if ( exist(dst_file_p) > 0 && ~allow_overwrite )
      fprintf( '\n\t Skipping, already exists.' );
      continue;
    end
    
    % load stim/sham times
    gaze_tbl = shared_utils.io.fload( '~/Downloads/gaze_data_tables/eyes.mat' );
    match_day = string( gaze_tbl.session ) == session_dirs{i};
    if ( sum(match_day) == 0 )
      fprintf( '\n\t Skipping, no stim/sham times.' );
      continue;
    end
    
    sham_ts = gaze_tbl{match_day & gaze_tbl.stim_type == 'sham', 'stim_time'};

    % determine desired mua channel
    [~, ~, raw] = xlsread( '~/Downloads/Microstimulation neural data.xlsx' );
    pl2_meta_tbl = parse_siqi_xls( raw );
    pl2_chan = pl2_meta_tbl.channel(string(pl2_meta_tbl.session) == session_dirs{i});
    
    target_intervals = [ sham_ts(:) + 1, sham_ts(:) + 4 ];
    
    try
      chans = pl2_chan;
      chans = chans(is_wb_channel(pl2, chans));
      
      if ( 1 )
        for j = 1:numel(chans)
          chan_str = wb_channel_str(chans(j));
          pl2_mat_filename = sprintf( '%s_%s_%s.mat', session_dirs{i}, pl2_fname, chan_str );
          pl2_mat_filepath = fullfile( dst_pl2_mat_p, pl2_mat_filename );
          if ( exist(pl2_mat_filepath) > 0 )
            fprintf( '\n\t Skipping, already exists.' );
            continue;
          end
          
          ad = PL2Ad( pl2, chan_str );
          ad.Values = single( ad.Values );
          save( pl2_mat_filepath, 'ad' );
        end
        continue;
      end
      
      mua_tbls = load_mua_channels( pl2, chans ...
        , 'target_intervals', target_intervals ...
        , 'ignore_intervals', false ...
      );

      fprintf( '\nSaving pl2: %s in %s', pl2s{1}, dst_file_p );
      save( dst_file_p, 'mua_tbls' );
    catch err
      warning( err.message );
    end
    
  elseif ( numel(pl2s) ~= 0 )
    warning( 'More than 1 pl2 file in %s.', session_ps{i} );
  end
end