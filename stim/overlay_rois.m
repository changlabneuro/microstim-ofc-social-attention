% edges = linspace( -20, 20,

int_p = '/Volumes/external3/data/changlab/siqi/stim/intermediates';
rois = shared_utils.io.findmat( fullfile(int_p, 'rois') );

%%

eye_rois = nan( numel(rois), 4 );
face_rois = nan( size(eye_rois) );

for i = 1:numel(rois)
  fprintf( '\n %d of %d', i, numel(rois) );
  roi_f = shared_utils.io.fload( rois{i} );
  eye_rois(i, :) = roi_f.m1.rects('eyes_nf');
  face_rois(i, :) = roi_f.m1.rects('face');
end

%%

eye_p0s = nan( size(eye_rois, 1), 2 );
eye_sizes = nan( size(eye_p0s) );

face_p0s = nan( size(eye_p0s) );
face_sizes = nan( size(eye_sizes) );

screen_p0s = nan( size(eye_p0s) );
actual_eye_p0s = nan( size(eye_p0s) );

for i = 1:size(eye_rois, 1)
  eye_cent = [ mean(eye_rois(i, [1, 3])), mean(eye_rois(i, [2, 4])) ];
  actual_eye_p0s(i, :) = eye_rois(i, [1, 2]);
  screen_p0s(i, :) = [-1024, 0] - eye_cent;
  
%   disp( actual_eye_p0 )
  
  eye_p0s(i, :) = eye_rois(i, [1, 2]) - eye_cent;
  face_p0s(i, :) = face_rois(i, [1, 2]) - eye_cent;
  eye_sizes(i, :) = [ diff(eye_rois(i, [1, 3])), diff(eye_rois(i, [2, 4])) ];
  face_sizes(i, :) = [ diff(face_rois(i, [1, 3])), diff(face_rois(i, [2, 4])) ];
%   screen_p0s(i, :) = eye
end

%%

mean_eye_rect = [ mean(eye_p0s, 1), mean(eye_p0s, 1) + mean(eye_sizes, 1) ];
mean_face_rect = [ mean(face_p0s, 1), mean(face_p0s, 1) + mean(face_sizes, 1) ];
mean_screen_rect = [ mean(screen_p0s, 1), mean(screen_p0s, 1) + [1024*3, 768] ];

%%

eye_rect_deg = bfw.px2deg( mean_eye_rect );
face_rect_deg = bfw.px2deg( mean_face_rect );
screen_rect_deg = bfw.px2deg( mean_screen_rect );

middle_screen_deg = [...
    screen_rect_deg(1) + bfw.px2deg(1024) ...
  , screen_rect_deg(2) ...
  , screen_rect_deg(1) + bfw.px2deg(1024*2) ...
  , screen_rect_deg(4)];

right_screen_deg = middle_screen_deg;
right_screen_deg([1, 3]) = right_screen_deg([1, 3]) + bfw.px2deg(1024);

left_screen_deg = middle_screen_deg;
left_screen_deg([1, 3]) = left_screen_deg([1, 3]) - bfw.px2deg(1024);

draw_rect = @(ax, r) rectangle(...
  ax, 'Position', [r(1), r(2), diff(r([1, 3])), diff(r([2, 4]))]);

figure(1); clf;
ax = gca;
hold( ax, 'on' );
draw_rect( ax, eye_rect_deg );
draw_rect( ax, face_rect_deg );
% draw_rect( ax, middle_screen_deg );
draw_rect( ax, screen_rect_deg );
draw_rect( ax, left_screen_deg );
draw_rect( ax, right_screen_deg );

if ( 0 )
axis( ax, 'square' );
xlim( ax, [-20, 20] );
ylim( ax, [-20, 20] );
end


