kin_table = load( '/Users/nick/Downloads/Saccade_Kinematics_Table_Combined.mat' );
kin_table = kin_table.saccade_table;

%%

subset_label = 'OFC';
subset = kin_table.(subset_label);

num_edges = 50;
im_res = [256, 256];

if ( 0 )
  [~, e] = histcounts( ...
    [subset.shuffled_slope(:); subset.real_slope(:)], num_edges );
else
  e = linspace( -80, 80, num_edges );
  e = -80:10:80;
end

[im, y] = gen_hist_image( subset.shuffled_slope, e, im_res );

figure(1); clf;
ax = gca;
imshow_hist_im( ax, e, y, im, 'summer' );
title( ax, subset_label );

hold( ax, 'on' );
histogram( ax, subset.real_slope );
set( ax, 'ydir', 'normal' );

%%

function imshow_hist_im(ax, e, y, im, cmap_name)

nb = 255;
disc = max( 1, floor(im * nb) );
cmap = feval( cmap_name, nb );
im_color = zeros( [size(im), 3] );

for i = 1:size(im, 1)
  for j = 1:size(im, 2)
    mask = double( im(i, j) ~= 0 );
%     mask = 1;
    im_color(i, j, :) = cmap(disc(i, j), :) .* mask;
  end
end

imagesc( ax, e, y, im_color );
colormap( cmap_name );
colorbar( ax );

end

function [im, y] = gen_hist_image(data, e, im_res)

if ( 1 )
  num_sets = size( data, 1 );
  num_edges = numel( e ) - 1;

  % days x edges
  bar_sets = nan( num_sets, num_edges );
  for i = 1:num_sets
    bar_sets(i, :) = histcounts( data(i, :), e );
  end  
else
  num_sets = size( data, 2 );
  num_edges = numel( e ) - 1;

  % days x edges
  bar_sets = nan( num_sets, num_edges );
  for i = 1:num_sets
    bar_sets(i, :) = histcounts( data(:, i), e );
  end
end

max_v = 1;  % can truncate 
max_vs = max( bar_sets, [], 1 );
max_tot = max( max_vs );

im = zeros( im_res );
for i = 0:im_res(1)-1
  for j = 0:im_res(2)-1
    fx = j / im_res(2);
    fy = i / im_res(1);
    
    % fx indexes edges
    curr_edge = floor( fx * size(bar_sets, 2) ) + 1;
    
    num_ib = 0;
    curr_target = floor( fy .* max_tot );
    for k = 1:num_sets
      num_ib = num_ib + double( bar_sets(k, curr_edge) > curr_target );
    end
    
    frac_v = (num_ib / num_sets) * max_v + (1 - max_v);    
    bar_h_mask = fy <= max_vs( curr_edge );
    im(im_res(1) - i, j + 1) = frac_v * double( bar_h_mask );
  end
end

y = linspace( max_tot, 0, im_res(1) );

end