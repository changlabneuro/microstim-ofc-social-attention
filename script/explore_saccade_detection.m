int_p = '/Volumes/external3/data/changlab/siqi/stim/intermediates';
fname = '01222020_position_9.mat';
pos_file = shared_utils.io.fload( fullfile(int_p, 'aligned_raw_samples/position', fname) );
t_file = shared_utils.io.fload( fullfile(int_p, 'aligned_raw_samples/time', fname) );

first_non_nan = find( ~isnan(t_file.t), 1 );

m1_p = pos_file.m1(:, first_non_nan:end);
t = reshape( t_file.t(first_non_nan:end), [], 1 )';
is_fix = is_fixation( m1_p, t, 20, 10, 0.03 );
is_fix = logical( is_fix(1:numel(t)) );

%%  microsaccade method 1

% eq (1) (page 3)
% 

fs1 = 1e3;
pos_deg1 = bfw.px2deg( m1_p );

if ( 0 )
  [pos_deg1, fs1] = do_downsample( pos_deg1, fs1, 16 );
end

microsaccades1 = detect_microsaccades( pos_deg1, fs1, tempdir );

%%  microsaccade method 2

fs2 = 1e3;
pos_deg2 = bfw.px2deg( m1_p );

if ( 1 )
  [pos_deg2, fs2] = do_downsample( pos_deg2, fs2, 16 );
end

% m1_p_deg = m1_p;
first_row_zeros = zeros( 1, size(pos_deg2, 2) );
microsaccades2 = micsaccdeg( [first_row_zeros', pos_deg2'], fs2 );

%%  saccade method 3

fs3 = 1e3;
pos_deg3 = bfw.px2deg( m1_p );
vel_thresh = 20;
min_samples = 50;
smooth_func = @(x) smoothdata( x, 'movmean', 25 );
start_stop = hwwa.find_saccades( ...
  pos_deg3(1, :), pos_deg3(2, :), fs3, vel_thresh, min_samples, smooth_func );

%%  

[fix_starts, fix_durs] = shared_utils.logical.find_islands( is_fix );
fix_stops = fix_starts + fix_durs - 1;

isect_sample_threshold = 50;
sacc_labels1 = label_saccades( ...
  [fix_starts(:), fix_stops(:)], microsaccades1, isect_sample_threshold );

%%

methods = { microsaccades1, microsaccades2 };
sacc_label_sets = { sacc_labels1, [] };
fss = { fs1, fs2 };
poss = { pos_deg1, pos_deg2 };
method_names = { 'Otero-Millan et al.', 'Riaz' };

figure(1); clf;
axs = plots.panels( numel(methods) );

t0 = 116;
t1 = t0 + 10;

for i = 1:numel(axs)
  
microsaccades = methods{i};
fs = fss{i};
pos_deg = poss{i};
sl = sacc_label_sets{i};

i0 = floor( t0 * fs ) + 1;
i1 = floor( t1 * fs ) + 1;
t = linspace( t0, t1, i1 - i0 + 1 );

x = pos_deg(1, i0:i1);
y = pos_deg(2, i0:i1);

plot( axs(i), t, x ); 
hold( axs(i), 'on'); 
plot( axs(i), t, y );

ms_start = microsaccades(:, 1);

if ( isempty(sl) )
  sl = strings( numel(ms_start), 1 );
end

[ms_I, sacc_type] = findeachv( sl );
colors = hsv( numel(ms_I) );
leg_hs = [];
for j = 1:numel(ms_I)
  msi = ms_I{j};
  ms_use = ms_start(msi);
  ib_ms = ms_use >= i0 & ms_use <= i1;
  hs = shared_utils.plot.add_vertical_lines( axs(i), ms_use(ib_ms)/fs );
  set( hs(1), 'displayname', sacc_type(j) );
  set( hs, 'linewidth', 0.1 );
  set( hs, 'color', colors(j, :) );
  leg_hs(end+1, 1) = hs(1);
end

legend( leg_hs );
title( axs(i), method_names{i} );

end

%%

n_show = 10;
t_prev = 1;
t_after = 1;
show_inds = randperm( rows(microsaccades), n_show );

figure(1); clf;
axs = plots.panels( n_show );

for i = 1:numel(show_inds)
  ax = axs(i);
  
  s = microsaccades(show_inds(i), :);
  
  i0 = s(1) - t_prev * fs1;
  i1 = s(2) + t_prev * fs1;
  
  x = m1_p_deg(1, i0:i1);
  y = m1_p_deg(2, i0:i1);
  plot( ax, x ); 
  hold( ax,'on' ); 
  plot( ax, y );
  shared_utils.plot.add_vertical_lines( ax, t_prev * fs1 );
end

%%

% Function for detecting microsaccades from a time series of eye movements.
%
% Inputs:
%    EyeDeg   - Time series of eye movements
%    SAMPLING - The sampling rate of the time series of eye movements.

%
% Outputs:
%    microsaccades - Column one: Time of onset of microsaccades
%                    Column two: Time at which the microsaccdes terminate
%                    Column three: Peak velocity of microsaccades
%                    Column four: Peak amplitude of microsaccades

%
% Outputs:
%    microsaccades - Column one: Time of onset of microsaccades
%                    Column two: Time at which the microsaccdes terminate
%                    Column three: Peak velocity of microsaccades
%                    Column four: Peak amplitude of microsaccades
%                    
% Haider Riaz - haider.riaz@mail.mcgill.ca
% McIntyre Medical Building Room 1225
% Department of Physiology, McGill University
%
% Created by Haider Riaz Khan 2013.

function [p, fs] = do_downsample(p, fs, n)

x = downsample( p(1, :), n );
y = downsample( p(2, :), n );
fs = fs / n;
p = [ x; y ];

end


function microsaccades = micsaccdeg(EyeDeg, SAMPLING)

N = length(EyeDeg);
v = zeros(N,3);

for k=1:N
    
    v(k,1)= EyeDeg(k,1);
    
end

for k=2:N-1
    
    
    if k>=3 & k<=N-2
      try
        v(k,2:3) = SAMPLING/6*[EyeDeg(k+2,2)+EyeDeg(k+1,2)-EyeDeg(k-1,2)-EyeDeg(k-2,2) EyeDeg(k+2,3)+EyeDeg(k+1,3)-EyeDeg(k-1,3)-EyeDeg(k-2,3)];
      catch err
        rethrow( err );
      end
    end
end

vel = sqrt(v(:,2).^2 + v(:,3).^2);

i=1;
onset = [];
finish = [];
vpeak = [];
ampl = [];
while(i<=N)
    j=1;
    
    
    if vel(i) >=8
        
        while(vel(i+j) >= 8)
            
            j = j + 1;
            
        end
        j = j-1;
        
        if j>=5 && j<=150
            onset = vertcat(onset,i);
            finish = vertcat(finish , (j+i));
            vpeak = vertcat(vpeak, max(vel(i: (j+i))));% peak velocity
            ampl = vertcat(ampl,sqrt( (EyeDeg(i,2)-EyeDeg(i+j,2))^2 + (EyeDeg(i,3)-EyeDeg(j+i,3))^2 ));  % amplitude
            i = i + j + 10;
        else
            
            i = i + j + 1;
            
        end
    else
        i = i + 1;
    end
    
    
end


microsaccades = [onset , finish , vpeak , ampl];

end


