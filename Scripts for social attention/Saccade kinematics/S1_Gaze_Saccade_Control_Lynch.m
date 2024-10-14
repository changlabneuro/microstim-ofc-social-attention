%% Microstimulation controls (number of macrosaccades, microsaccades, and time in bounds).

% Upload Gaze_Data_Lynch.mat and Saccade_Lynch.mat

% Specify time window

look_back=0;
look_ahead=1.5;

fieldname=fieldnames(GazeData);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
    field_run=fieldnames(GazeData.(field_id));
    
    for l=1:size(field_run,1)
        run_id=char(field_run(l));
        
        % get ROI info
        GazeSaccade.(field_id).(run_id).roi_m1_eyes=GazeData.(field_id).(run_id).roi_m1_eyes;
        GazeSaccade.(field_id).(run_id).roi_m2_eyes=GazeData.(field_id).(run_id).roi_m2_eyes;
        GazeSaccade.(field_id).(run_id).roi_m1_face=GazeData.(field_id).(run_id).roi_m1_face;
        GazeSaccade.(field_id).(run_id).roi_m2_face=GazeData.(field_id).(run_id).roi_m2_face;
        GazeSaccade.(field_id).(run_id).roi_m1_mouth=GazeData.(field_id).(run_id).roi_m1_mouth;
        GazeSaccade.(field_id).(run_id).roi_m2_mouth=GazeData.(field_id).(run_id).roi_m2_mouth;

        GazeSaccade.(field_id).(run_id).center_roi_m1_eyes=GazeData.(field_id).(run_id).center_roi_m1_eyes;
        GazeSaccade.(field_id).(run_id).center_roi_m2_eyes=GazeData.(field_id).(run_id).center_roi_m2_eyes;
        GazeSaccade.(field_id).(run_id).center_roi_m1_face=GazeData.(field_id).(run_id).center_roi_m1_face;
        GazeSaccade.(field_id).(run_id).center_roi_m2_face=GazeData.(field_id).(run_id).center_roi_m2_face;
        GazeSaccade.(field_id).(run_id).center_roi_m1_mouth=GazeData.(field_id).(run_id).center_roi_m1_mouth;
        GazeSaccade.(field_id).(run_id).center_roi_m2_mouth=GazeData.(field_id).(run_id).center_roi_m2_mouth;

        GazeSaccade.(field_id).(run_id).current_label=[];
        GazeSaccade.(field_id).(run_id).stim_time=[];
        stim_ts=GazeData.(field_id).(run_id).stim_ts;

        GazeSaccade.(field_id).(run_id).saccade_starttime=GazeData.(field_id).(run_id).t(Gaze.(field_id).(run_id).saccades_time(:,1));
        GazeSaccade.(field_id).(run_id).saccade_endtime=GazeData.(field_id).(run_id).t(Gaze.(field_id).(run_id).saccades_time(:,2));
        
        for nstim=1:length(stim_ts)        
            stim_id=char(strcat('stim_',num2str(nstim)));

            if GazeData.(field_id).(run_id).stim_ts(nstim) >= min(GazeData.(field_id).(run_id).t) && GazeData.(field_id).(run_id).stim_ts(nstim) < max(GazeData.(field_id).(run_id).t)-5
            
                % column 7 is m1 start index; column 8 is m1 end index
                % column 9 is m2 start index; column 10 is m2 end index
                % column 11 is m1 start time; column 12 is m1 end time
                % column 13 is m2 start time; column 14 is m2 end time
    
                GazeSaccade.(field_id).(run_id).current_label=vertcat(GazeSaccade.(field_id).(run_id).current_label, GazeData.(field_id).(run_id).all_stim_labels{nstim,1});
                GazeSaccade.(field_id).(run_id).stim_time=vertcat(GazeSaccade.(field_id).(run_id).stim_time, GazeData.(field_id).(run_id).stim_ts(nstim,1));
                               
                % microsaccade
                
                microsaccade_idx=find(GazeSaccade.(field_id).(run_id).saccade_starttime(:,1)>=stim_ts(nstim)+look_back & GazeSaccade.(field_id).(run_id).saccade_starttime(:,1)<stim_ts(nstim)+look_ahead & Gaze.(field_id).(run_id).saccades_label=='microsaccade');
                
                if isempty(microsaccade_idx)
                    GazeSaccade.(field_id).(run_id).(stim_id).microsaccade_number=0;
                    GazeSaccade.(field_id).(run_id).(stim_id).microsaccade_number_NaN=NaN;                        
                else
                    GazeSaccade.(field_id).(run_id).(stim_id).microsaccade_number=length(microsaccade_idx);
                    GazeSaccade.(field_id).(run_id).(stim_id).microsaccade_number_NaN=length(microsaccade_idx);   
                end

                clear microsaccade_idx
    
                % macrosaccade
                
                macrosaccade_idx=find(GazeSaccade.(field_id).(run_id).saccade_starttime(:,1)>=stim_ts(nstim)+look_back & GazeSaccade.(field_id).(run_id).saccade_starttime(:,1)<stim_ts(nstim)+look_ahead & Gaze.(field_id).(run_id).saccades_label=='macrosaccade');
                
                if isempty(macrosaccade_idx)
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_number=0;
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_number_NaN=NaN;      
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_amp=NaN;
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_vel=NaN;
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_before=NaN;
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_after=NaN;
                else
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_number=length(macrosaccade_idx);
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_number_NaN=length(macrosaccade_idx);  
                    [GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_amp,GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_vel] = get_amp_peak_vel(GazeData.(field_id).(run_id).t, vertcat(GazeData.(field_id).(run_id).x_m1, GazeData.(field_id).(run_id).y_m1), Gaze.(field_id).(run_id).saccades_time(macrosaccade_idx(1),1):Gaze.(field_id).(run_id).saccades_time(macrosaccade_idx(1),2));
                    
                    % Label contra- or ipsi- lateral for each event (Lynch's chamber is on the left side of the head)
                    if GazeData.(field_id).(run_id).x_m1(1,Gaze.(field_id).(run_id).saccades_time(macrosaccade_idx(1),1)-1) < GazeData.(field_id).(run_id).center_roi_m2_face(1)
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_before=string('ipsi');
                    elseif GazeData.(field_id).(run_id).x_m1(1,Gaze.(field_id).(run_id).saccades_time(macrosaccade_idx(1),1)-1) > GazeData.(field_id).(run_id).center_roi_m2_face(1)
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_before=string('contra');
                    else
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_before=string('notavailable');
                    end

                    if GazeData.(field_id).(run_id).x_m1(1,Gaze.(field_id).(run_id).saccades_time(macrosaccade_idx(1),2)+1) < GazeData.(field_id).(run_id).center_roi_m2_face(1)
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_after=string('ipsi');
                    elseif GazeData.(field_id).(run_id).x_m1(1,Gaze.(field_id).(run_id).saccades_time(macrosaccade_idx(1),2)+1) > GazeData.(field_id).(run_id).center_roi_m2_face(1)
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_after=string('contra');
                    else
                    GazeSaccade.(field_id).(run_id).(stim_id).macrosaccade_after=string('notavailable');
                    end
                end

                clear macrosaccade_idx

                % in-bounds

                stim_idx=find(GazeData.(field_id).(run_id).t<=GazeData.(field_id).(run_id).stim_ts(nstim),1,'last');
                in_bounds_eyes=GazeData.(field_id).(run_id).bounds_m1_eyes(1,stim_idx:stim_idx+look_ahead*1000-1);
                [bounds_eyes_start, bounds_eyes_durs]=shared_utils.logical.find_islands(in_bounds_eyes);
                in_bounds_stim_eyes=GazeData.(field_id).(run_id).bounds_m1_stim_eyes(1,stim_idx:stim_idx+look_ahead*1000-1);
                [bounds_stim_eyes_start, bounds_stim_eyes_durs]=shared_utils.logical.find_islands(in_bounds_stim_eyes);

                if isempty(bounds_eyes_start) || ~isequal(bounds_eyes_start(1),1) 
                    GazeSaccade.(field_id).(run_id).(stim_id).bounds_eyes_duration=NaN;
                else
                    GazeSaccade.(field_id).(run_id).(stim_id).bounds_eyes_duration=bounds_eyes_durs(1);
                end

                if isempty (bounds_stim_eyes_start) || ~isequal(bounds_stim_eyes_start(1),1) 
                    GazeSaccade.(field_id).(run_id).(stim_id).bounds_stim_eyes_duration=NaN;
                else
                    GazeSaccade.(field_id).(run_id).(stim_id).bounds_stim_eyes_duration=bounds_stim_eyes_durs(1);
                end

                clear stim_idx in_bounds_eyes bounds_eyes_start bounds_eyes_durs in_bounds_stim_eyes bounds_stim_eyes_start bounds_stim_eyes_durs

            end
            
            clear stim_id

        end

        clear stim_ts nstim

    end

end

save('SaccadeGaze_Data_Lynch.mat','GazeSaccade','-v7.3');  

