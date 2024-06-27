%% Put information together for each trial (four categories: sham_sham, sham_stim, stim_sham, and stim_stim; plus two general categories: current_sham and current_stim)

fieldname=fieldnames(GazeMatrices);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    field_run=fieldnames(GazeMatrices.(field_id));
    
    for l=1:size(field_run,1)
        run_id=char(field_run(l));
        field_stim=fieldnames(GazeMatrices.(field_id).(run_id));
        
        GazeHeat.(field_id).(run_id).roi_m1_eyes=GazeMatrices.(field_id).(run_id).roi_m1_eyes;
        GazeHeat.(field_id).(run_id).roi_m2_eyes=GazeMatrices.(field_id).(run_id).roi_m2_eyes;
        GazeHeat.(field_id).(run_id).roi_m1_mouth=GazeMatrices.(field_id).(run_id).roi_m1_mouth;
        GazeHeat.(field_id).(run_id).roi_m2_mouth=GazeMatrices.(field_id).(run_id).roi_m2_mouth;
        GazeHeat.(field_id).(run_id).roi_m1_face=GazeMatrices.(field_id).(run_id).roi_m1_face;
        GazeHeat.(field_id).(run_id).roi_m2_face=GazeMatrices.(field_id).(run_id).roi_m2_face;
        
        GazeHeat.(field_id).(run_id).center_roi_m1_eyes=GazeMatrices.(field_id).(run_id).center_roi_m1_eyes;
        GazeHeat.(field_id).(run_id).center_roi_m2_eyes=GazeMatrices.(field_id).(run_id).center_roi_m2_eyes;
        GazeHeat.(field_id).(run_id).center_roi_m1_mouth=GazeMatrices.(field_id).(run_id).center_roi_m1_mouth;
        GazeHeat.(field_id).(run_id).center_roi_m2_mouth=GazeMatrices.(field_id).(run_id).center_roi_m2_mouth;
        GazeHeat.(field_id).(run_id).center_roi_m1_face=GazeMatrices.(field_id).(run_id).center_roi_m1_face;
        GazeHeat.(field_id).(run_id).center_roi_m2_face=GazeMatrices.(field_id).(run_id).center_roi_m2_face;
        
        stim_label={char('sham_sham') char('sham_stim') char('stim_sham') char('stim_stim') char('current_sham') char('current_stim')};
        
        % n_not_stim is the number of other variables that are not stim
        
        n_not_stim = 14;
        
        for i=1:6
                  
            nstim=fieldnames(GazeMatrices.(field_id).(run_id));
            stim_id=char(nstim(n_not_stim+1));
            variables_list={'mean_x_m1','mean_y_m1'};

            for nvar=1:length(variables_list)

                varname=char(variables_list(nvar));        
                GazeHeat.(field_id).(run_id).(stim_label{i}).(varname)=[];

            end

        end     
        
        for nstim=2:length(field_stim)-n_not_stim 
            stim_id=char(field_stim(nstim+n_not_stim));

            if isequal(GazeMatrices.(field_id).(run_id).current_label(nstim,:),'sham') && isequal(GazeMatrices.(field_id).(run_id).current_label(nstim-1,:),'sham')                    
                label_list={stim_label{1} stim_label{5}};   
            elseif isequal(GazeMatrices.(field_id).(run_id).current_label(nstim,:),'stim') && isequal(GazeMatrices.(field_id).(run_id).current_label(nstim-1,:),'sham')     
                label_list={stim_label{2} stim_label{6}};                
            elseif isequal(GazeMatrices.(field_id).(run_id).current_label(nstim,:),'sham') && isequal(GazeMatrices.(field_id).(run_id).current_label(nstim-1,:),'stim')      
                label_list={stim_label{3} stim_label{5}};            
            elseif isequal(GazeMatrices.(field_id).(run_id).current_label(nstim,:),'stim') && isequal(GazeMatrices.(field_id).(run_id).current_label(nstim-1,:),'stim')   
                label_list={stim_label{4} stim_label{6}};
            end

            for label_id=1:numel(label_list)
            
                label=label_list{1,label_id};
                variable_list_position={'mean_x_m1','mean_y_m1'};

                 for n=1:length(variable_list_position)
                    variable_name=variable_list_position{1,n};
                    GazeHeat.(field_id).(run_id).(label).(variable_name)=[GazeHeat.(field_id).(run_id).(label).(variable_name) GazeMatrices.(field_id).(run_id).(stim_id).(variable_name)];
                    clear variable_name
                end
                
                clear n
                clear label

            end

            clear stim_id label_id

        end
            
        clear nstim run_id field_stim
        
    end

    clear l  field_id field_run

end
    
save('Gaze_Heat_Map_Run_Combined.mat','GazeHeat','-v7.3')

%% Get info for heatmap

fieldname = fieldnames( GazeHeat );
mats = cell( numel(fieldname), 1 );
ROI.eyes = [];
ROI.mouth = [];
ROI.face = [];
h = 27; % monitor height in cm
d = 50; % subject to monitor in cm
r=768; % monitor height in pixel
deg_per_px = rad2deg(atan2(.5*h, d)) / (.5*r); 

for k = 1:size(fieldname,1)
    field_id=char(fieldname(k));
    field_run = fieldnames( GazeHeat.(field_id) );

    for l = 1:size(field_run,1)

        run_id=char(field_run(l));
        current_sham = GazeHeat.(field_id).(run_id).current_sham;
        current_stim = GazeHeat.(field_id).(run_id).current_stim;

%         roi_eyes(l,:)=GazeHeat.(field_id).(run_id).roi_m1_eyes;
%         roi_mouth(l,:)=GazeHeat.(field_id).(run_id).roi_m1_mouth;
%         roi_face(l,:)=GazeHeat.(field_id).(run_id).roi_m1_face;
        
        pos_sham = [ current_sham.mean_x_m1(:)'; current_sham.mean_y_m1(:)' ];
        pos_stim = [ current_stim.mean_x_m1(:)'; current_stim.mean_y_m1(:)' ];
        roi = GazeHeat.(field_id).(run_id).roi_m1_eyes;
        center = [ mean(roi([1, 3])), mean(roi([2, 4])) ];
        
        pos_sham = align_to_roi( pos_sham, roi );
        pos_sham = convert_to_degrees( pos_sham );
        pos_stim = align_to_roi( pos_stim, roi );
        pos_stim = convert_to_degrees( pos_stim );

        roi_eyes(l,:) = [GazeHeat.(field_id).(run_id).roi_m1_eyes(1)-center(1) GazeHeat.(field_id).(run_id).roi_m1_eyes(2)-center(2) GazeHeat.(field_id).(run_id).roi_m1_eyes(3)-center(1) GazeHeat.(field_id).(run_id).roi_m1_eyes(4)-center(2)];
        roi_eyes(l,:) = deg_per_px*roi_eyes(l,:);
        roi_mouth(l,:) = [GazeHeat.(field_id).(run_id).roi_m1_mouth(1)-center(1) GazeHeat.(field_id).(run_id).roi_m1_mouth(2)-center(2) GazeHeat.(field_id).(run_id).roi_m1_mouth(3)-center(1) GazeHeat.(field_id).(run_id).roi_m1_mouth(4)-center(2)];
        roi_mouth(l,:) = deg_per_px*roi_mouth(l,:);
        roi_face(l,:) = [GazeHeat.(field_id).(run_id).roi_m1_face(1)-center(1) GazeHeat.(field_id).(run_id).roi_m1_face(2)-center(2) GazeHeat.(field_id).(run_id).roi_m1_face(3)-center(1) GazeHeat.(field_id).(run_id).roi_m1_face(4)-center(2)];
        roi_face(l,:) = deg_per_px*roi_face(l,:);

%         roi_mouth(l,:) = align_to_roi (GazeHeat.(field_id).(run_id).roi_m1_eyes,roi);
%         roi_mouth(l,:) = convert_to_degrees (roi_mouth(l,:));
%         roi_face(l,:) = align_to_roi (GazeHeat.(field_id).(run_id).roi_m1_eyes,roi);
%         roi_facel(l,:) = convert_to_degrees (roi_facel(l,:));

        heatmap_sham = histogram_heatmap( pos_sham, -20:20, -20:20 );
        heatmap_stim = histogram_heatmap( pos_stim, -20:20, -20:20 );

        if ( l == 1 )
            mats_sham{k} = heatmap_sham;
            mats_stim{k} = heatmap_stim;
        else
            mats_sham{k} = mats_sham{k} + heatmap_sham;
            mats_stim{k} = mats_stim{k} + heatmap_stim;
        end

    end

    ROI.eyes(k,:)=mean(roi_eyes,1,'omitnan');
    ROI.mouth(k,:)=mean(roi_mouth,1,'omitnan');
    ROI.face(k,:)=mean(roi_face,1,'omitnan');

    mats{k} = (mats_stim{k}-mats_sham{k}) / sum( mats_sham{k}(:) + mats_stim{k}(:) );

end

Gaze_mats=mats;
Gaze_ROI=ROI;

save('Gaze_Heat_Map_ROI_Combined.mat','Gaze_ROI','-v7.3')
save('Final_Gaze_Heat_Map_Combined.mat','Gaze_mats','-v7.3')


%%

function pos = convert_to_degrees(pos)

    h = 27; % monitor height in cm
    d = 50; % subject to monitor in cm
    r=768; % monitor height in pixel
    
    deg_per_px = rad2deg(atan2(.5*h, d)) / (.5*r); 
    pos(1, :) = pos(1, :) * deg_per_px;
    pos(2, :) = pos(2, :) * deg_per_px;

end

function pos = align_to_roi(pos, roi)

    center = [ mean(roi([1, 3])), mean(roi([2, 4])) ];
    pos = pos - center(:);

end

function mat = histogram_heatmap(pos, x_edges, y_edges)

    mat = zeros( numel(x_edges), numel(y_edges) );

    for i = 1:size(pos, 2)
    
        coord = pos(:, i);
        
        x_bin = logical( histc(coord(1), x_edges) );
        y_bin = logical( histc(coord(2), y_edges) );
        
        mat(y_bin, x_bin) = mat(y_bin, x_bin) + 1;
    
    end

end