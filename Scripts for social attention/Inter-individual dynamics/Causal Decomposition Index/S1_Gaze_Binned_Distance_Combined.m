%% Load Gaze_Data_Combined.mat 

look_back = 0;
look_ahead = 5;

fieldname=fieldnames(GazeData);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
    field_run=fieldnames(GazeData.(field_id));
    
    for l=1:size(field_run,1)
        run_id=char(field_run(l));
        distance.(field_id).(run_id).stim_ts=[];
        distance.(field_id).(run_id).all_stim_labels=[];
       
        for nstim=1:length(GazeData.(field_id).(run_id).stim_ts)        
            stim_id=char(strcat('stim_',num2str(nstim)));

            if GazeData.(field_id).(run_id).stim_ts(nstim) >= min(GazeData.(field_id).(run_id).t) && GazeData.(field_id).(run_id).stim_ts(nstim) < max(GazeData.(field_id).(run_id).t)-5
            
            distance.(field_id).(run_id).stim_ts=[distance.(field_id).(run_id).stim_ts GazeData.(field_id).(run_id).stim_ts(nstim)];
            distance.(field_id).(run_id).all_stim_labels=[distance.(field_id).(run_id).all_stim_labels GazeData.(field_id).(run_id).all_stim_labels(nstim)];

            stim_idx=find(GazeData.(field_id).(run_id).t<=GazeData.(field_id).(run_id).stim_ts(nstim),1,'last');
            sample_range_start=stim_idx+look_back*1000;
            sample_range_end=stim_idx+look_ahead*1000-1; 

            distance.(field_id).(run_id).(stim_id).x_m1 = GazeData.(field_id).(run_id).x_m1(sample_range_start:sample_range_end);
            distance.(field_id).(run_id).(stim_id).y_m1 = GazeData.(field_id).(run_id).y_m1(sample_range_start:sample_range_end);
            distance.(field_id).(run_id).(stim_id).x_m2 = GazeData.(field_id).(run_id).x_m2(sample_range_start:sample_range_end);
            distance.(field_id).(run_id).(stim_id).y_m2 = GazeData.(field_id).(run_id).y_m2(sample_range_start:sample_range_end);
             
            bin_indices = shared_utils.vector.slidebin( 1:5000, 10, 10 ); % windows of size 10, step by 10

            for nbin=1:length(bin_indices)

                bin_idx=bin_indices{nbin};
                
                if isempty(distance.(field_id).(run_id).(stim_id).x_m1)
                    distance.(field_id).(run_id).(stim_id).x_m1_binned(1,nbin)=NaN;    
                else        
                    distance.(field_id).(run_id).(stim_id).x_m1_binned(1,nbin)=mean(distance.(field_id).(run_id).(stim_id).x_m1(bin_idx),'omitnan');
                end

                if isempty(distance.(field_id).(run_id).(stim_id).y_m1)
                    distance.(field_id).(run_id).(stim_id).y_m1_binned(1,nbin)=NaN;    
                else
                    distance.(field_id).(run_id).(stim_id).y_m1_binned(1,nbin)=mean(distance.(field_id).(run_id).(stim_id).y_m1(bin_idx),'omitnan');
                end

                if isempty(distance.(field_id).(run_id).(stim_id).x_m2)
                    distance.(field_id).(run_id).(stim_id).x_m2_binned(1,nbin)=NaN;    
                else        
                    distance.(field_id).(run_id).(stim_id).x_m2_binned(1,nbin)=mean(distance.(field_id).(run_id).(stim_id).x_m2(bin_idx),'omitnan');
                end

                if isempty(distance.(field_id).(run_id).(stim_id).y_m2)
                    distance.(field_id).(run_id).(stim_id).y_m2_binned(1,nbin)=NaN;    
                else
                    distance.(field_id).(run_id).(stim_id).y_m2_binned(1,nbin)=mean(distance.(field_id).(run_id).(stim_id).y_m2(bin_idx),'omitnan');
                end

                clear bin_idx

            end
      
            distance.(field_id).(run_id).(stim_id).m1_distance_to_eyes=sqrt((distance.(field_id).(run_id).(stim_id).x_m1_binned-GazeData.(field_id).(run_id).center_roi_m1_eyes(1)).^2+(distance.(field_id).(run_id).(stim_id).y_m1_binned-GazeData.(field_id).(run_id).center_roi_m1_eyes(2)).^2);         
            distance.(field_id).(run_id).(stim_id).m1_distance_to_mouth=sqrt((distance.(field_id).(run_id).(stim_id).x_m1_binned-GazeData.(field_id).(run_id).center_roi_m1_mouth(1)).^2+(distance.(field_id).(run_id).(stim_id).y_m1_binned-GazeData.(field_id).(run_id).center_roi_m1_mouth(2)).^2);
            distance.(field_id).(run_id).(stim_id).m1_distance_to_face=sqrt((distance.(field_id).(run_id).(stim_id).x_m1_binned-GazeData.(field_id).(run_id).center_roi_m1_face(1)).^2+(distance.(field_id).(run_id).(stim_id).y_m1_binned-GazeData.(field_id).(run_id).center_roi_m1_face(2)).^2);
            
            distance.(field_id).(run_id).(stim_id).m2_distance_to_eyes=sqrt((distance.(field_id).(run_id).(stim_id).x_m2_binned-GazeData.(field_id).(run_id).center_roi_m2_eyes(1)).^2+(distance.(field_id).(run_id).(stim_id).y_m2_binned-GazeData.(field_id).(run_id).center_roi_m2_eyes(2)).^2);         
            distance.(field_id).(run_id).(stim_id).m2_distance_to_mouth=sqrt((distance.(field_id).(run_id).(stim_id).x_m2_binned-GazeData.(field_id).(run_id).center_roi_m2_mouth(1)).^2+(distance.(field_id).(run_id).(stim_id).y_m2_binned-GazeData.(field_id).(run_id).center_roi_m2_mouth(2)).^2);
            distance.(field_id).(run_id).(stim_id).m2_distance_to_face=sqrt((distance.(field_id).(run_id).(stim_id).x_m2_binned-GazeData.(field_id).(run_id).center_roi_m2_face(1)).^2+(distance.(field_id).(run_id).(stim_id).y_m2_binned-GazeData.(field_id).(run_id).center_roi_m2_face(2)).^2);       
            
            clear bin_indices nbin  
            clear stim_idx sample_range_start sample_range_end
            
            end

            clear stim_id

        end

        clear nstim run_id

    end

    clear l field_id field_run

end

save('Dynamics_Distance_Binned_Combined.mat','distance','-v7.3')
