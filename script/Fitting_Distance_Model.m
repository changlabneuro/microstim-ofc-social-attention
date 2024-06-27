%%  load in data

% data_dir = '/Volumes/Brains/BRAINS Recording to Stim';
data_dir = '/Volumes/external3/data/changlab/siqi/distance_model/Data/reformatted';

trial_table = shared_utils.io.fload( fullfile(data_dir, 'trial_table.mat') );
spike_file = shared_utils.io.fload( fullfile(data_dir, 'relabeled_cells.mat') );

bfw.add_monk_labels( spike_file.labels );
spike_labels = fcat.totable( spike_file.labels );

%%  compute psth for all cells

sessions = trial_table.sessions;

% mdl_prefix = 'all_contra_ipsi'; % everything
% mdl_prefix = 'ipsi';
% mdl_prefix = 'contra';
% mdl_prefix = 'subsampled_ipsi';
mdl_prefix = 'n_match_ipsi';
% mdl_prefix = 'n_match_contra';
% mdl_prefix = 'resampled_contra_ipsi';
mdl_prefix = 'resampled_contra_ipsi_fit_contra';
% mdl_prefix = 'resampled_contra_ipsi_fit_ipsi';

shuffle_prefix = '';

num_resample = 20;

for resample_index = 1:num_resample

if ( contains(mdl_prefix, 'resampled_contra_ipsi') )
  [contra_ipsi_inds, is_contra] = make_resampled_contra_ipsi_indices( ...
    trial_table.m1_hemifield_origin_delta_pos, trial_table.sessions, 1 );
  contra_ipsi_mask = true( rows(trial_table), 1 );
else
  % as before
  contra_ipsi_mask = make_real_contra_ipsi_mask( ...
    trial_table.m1_hemifield_origin_delta_pos, sessions, mdl_prefix );
end

%%  compute psth using some subset of trials given by contra_ipsi_mask

include_psth_timecourse = false;

[allpsth, psth_ts, all_spike_counts_in_fixation_interval, index_of_fixations] = ...
    compute_contra_ipsi_psth( spike_file, sessions ...
    , contra_ipsi_mask, trial_table.fixation_start_ts, trial_table.fixation_stop_ts, include_psth_timecourse );

assert( numel(allpsth) == numel(spike_file.spike_times));

%%  create dataset to fit

model_table = trial_table;
model_table.contra_ipsi_mask = contra_ipsi_mask;

fit_spike_cts = all_spike_counts_in_fixation_interval;
if ( contains(mdl_prefix, 'resampled_contra_ipsi') )
  % in this case, permute the spike counts to align with the resampled
  % indices of fixations we generated earlier.
  if ( endsWith(mdl_prefix, 'contra') )
    fprintf( '\n Fitting to contra \n' );
    fit_subset = contra_ipsi_inds(is_contra);
  else
    fprintf( '\n Fitting to ipsi \n' );
    fit_subset = contra_ipsi_inds(~is_contra);
  end
  
  model_table = model_table(fit_subset, :);
  fit_spike_cts = apply_index_to_spike_counts( ...
    fit_spike_cts, index_of_fixations, fit_subset );
end

%% run distance model for all cells

use_discretized = false;

discretized_prefix = '';
if ( use_discretized )
  discretized_prefix = 'disc-';
end

[mdls, cell_labels, fit_function_name] = run_distance_model( ...
  spike_file, model_table, fit_spike_cts, use_discretized );

if ( 1 )
  file_name = sprintf( '%s%s%s-model.mat', discretized_prefix, mdl_prefix, shuffle_prefix );
  save_p = fullfile( data_dir, 'distance_model', dsp3.datedir, file_name );
  
  if ( num_resample > 1 )
    save_p = fullfile( save_p, sprintf('resample_%d', resample_index) );
  end
  
  shared_utils.io.require_dir( fileparts(save_p) );
  save( save_p, "mdls", "cell_labels", "spike_labels", "fit_function_name" );
end

end

%%  

function [indices, is_contra] = make_resampled_contra_ipsi_indices(...
  m1_hemifield_origin_delta_pos, sessions, iters)

is_contra = m1_hemifield_origin_delta_pos(:, 1) > 0;
contra_inds = find( is_contra );
ipsi_inds = find( ~is_contra );

I = findeach( sessions, 1 );

indices = [];

for i = 1:numel(I)
  contra_subset = intersect( I{i}, contra_inds );
  ipsi_subset = intersect( I{i}, ipsi_inds );
  
  nc = numel( contra_subset );
  ni = numel( ipsi_subset );
  
  if ( ni > nc )
    % more ipsi than contra, resample ipsi `iters` times
    for j = 1:iters
      resamp = randsample( ni, nc, true );
      indices = [ indices; ipsi_subset(resamp) ];
    end
    indices = [ indices; contra_subset ];
  elseif ( nc > ni )
    % more contra than ipsi, resample contra `iters` times
    for j = 1:iters
      resamp = randsample( nc, ni, true );
      indices = [ indices; contra_subset(resamp) ];
    end
    indices = [ indices; ipsi_subset ];
  else
    % equal frequencies, no need to res ample
    indices = [ indices; contra_subset; ipsi_subset ];
  end
end

is_contra = is_contra(indices);

end

function dst_spike_counts = apply_index_to_spike_counts(...
  all_cts, index_of_fixations, contra_ipsi_inds)

dst_spike_counts = cell( size(all_cts) );

for i = 1:numel(all_cts)
  cts = all_cts{i};
  inds = index_of_fixations{i};
  curr_inds = contra_ipsi_inds(ismember(contra_ipsi_inds, inds));
  
  [~, loc] = ismember( curr_inds, inds );
  dst_cts = cts(loc);
  dst_spike_counts{i} = dst_cts;
end

end

function contra_ipsi_mask = make_real_contra_ipsi_mask(m1_hemifield_origin_delta_pos, sessions, mdl_prefix)

assert( numel(sessions) == size(m1_hemifield_origin_delta_pos, 1) );

contra_ipsi_mask = false( size(m1_hemifield_origin_delta_pos, 1), 1 );
    
%   If not commented out, then ignore contra vs ipsi and just look at all
%   fixations.
% contra_ipsi_mask(:) = true;

switch ( mdl_prefix )
    case {'contra', 'n_match_contra'}
        contra_ipsi_mask = m1_hemifield_origin_delta_pos(:, 1) > 0; 
    case {'ipsi', 'n_match_ipsi'}
       contra_ipsi_mask = m1_hemifield_origin_delta_pos(:, 1) < 0;
       case 'all_contra_ipsi'
%         contra_ipsi_mask = m1_hemifield_origin_delta_pos(:, 1);
        contra_ipsi_mask(:) = true;
    case 'subsampled_ipsi'
    otherwise
        error( 'Unrecognized mdl prefix: "%s".', mdl_prefix );
end    

if ( strcmp(mdl_prefix, 'subsampled_ipsi') || ...
    strcmp(mdl_prefix, 'n_match_contra') || ...
    strcmp(mdl_prefix, 'n_match_ispi') )

    is_n_match = contains( string(mdl_prefix), 'n_match' );

    I = findeach( sessions, 1 );

    if ( is_n_match )
        for i = 1:numel(I)
            is_target = contra_ipsi_mask(I{i});
            num_trials = min( sum(is_target), sum(~is_target) );
            target_inds = find( is_target );
            contra_ipsi_mask(I{i}) = false;
            keep_target = randsample( target_inds, num_trials );
                contra_ipsi_mask(I{i}(keep_target)) = true;
        end
    else
        for i = 1:numel(I)
            is_ipsi = m1_hemifield_origin_delta_pos(I{i}, 1) < 0;
            num_contra = sum( m1_hemifield_origin_delta_pos(I{i}, 1) > 0 );
            num_ipsi = sum( is_ipsi );
    
            ipsi_indices = I{i}(is_ipsi);
            if num_contra > num_ipsi
                keep_ipsi_indicies = ipsi_indices;
            else 
                keep_ipsi_indicies = randsample(ipsi_indices,num_contra);
            end 
            contra_ipsi_mask(keep_ipsi_indicies) = true;
        
            %   hint: `help randsample`
            %   define the `kept_ipsi_indices` by sub-selecting from `ipsi_indices`
            %   contra_ipsi_mask(kept_ipsi_indices) = true;
        end
    end
end

end