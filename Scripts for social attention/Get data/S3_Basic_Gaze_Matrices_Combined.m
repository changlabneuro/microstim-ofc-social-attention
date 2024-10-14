%% Upload Gaze_Data_Combined_Updated.mat

%% Specify time window

% look_back is negative and look_ahead is positive

 GazeMatrices = basic_gaze_matrices( GazeData, 0, 1.5 );
 % GazeMatrices = basic_gaze_matrices( GazeData, 0, 3 );

save('Gaze_Matrices_Combined_0_15_updated.mat','GazeMatrices','-v7.3')
%save('Gaze_Matrices_Combined_0_3.mat','GazeMatrices','-v7.3')

%% Calculate the basic gaze metrices within [look_back, look_ahead] aligned to each stim/sham (exclude stim/sham that happens within 5sec from the end of a run)

% total number, average duration, and total duration of different events 
% pupil size and average distance during different events

function GazeMatrices = basic_gaze_matrices(GazeData, look_back, look_ahead) 

fieldname=fieldnames(GazeData);

    for k=1:size(fieldname,1)
        field_id=char(fieldname(k));    
        field_run=fieldnames(GazeData.(field_id));
        
        for l=1:size(field_run,1)
            run_id=char(field_run(l));
            
            % get ROI info
            GazeMatrices.(field_id).(run_id).roi_m1_eyes=GazeData.(field_id).(run_id).roi_m1_eyes;
            GazeMatrices.(field_id).(run_id).roi_m2_eyes=GazeData.(field_id).(run_id).roi_m2_eyes;
            GazeMatrices.(field_id).(run_id).roi_m1_face=GazeData.(field_id).(run_id).roi_m1_face;
            GazeMatrices.(field_id).(run_id).roi_m2_face=GazeData.(field_id).(run_id).roi_m2_face;
            GazeMatrices.(field_id).(run_id).roi_m1_mouth=GazeData.(field_id).(run_id).roi_m1_mouth;
            GazeMatrices.(field_id).(run_id).roi_m2_mouth=GazeData.(field_id).(run_id).roi_m2_mouth;
    
            GazeMatrices.(field_id).(run_id).center_roi_m1_eyes=GazeData.(field_id).(run_id).center_roi_m1_eyes;
            GazeMatrices.(field_id).(run_id).center_roi_m2_eyes=GazeData.(field_id).(run_id).center_roi_m2_eyes;
            GazeMatrices.(field_id).(run_id).center_roi_m1_face=GazeData.(field_id).(run_id).center_roi_m1_face;
            GazeMatrices.(field_id).(run_id).center_roi_m2_face=GazeData.(field_id).(run_id).center_roi_m2_face;
            GazeMatrices.(field_id).(run_id).center_roi_m1_mouth=GazeData.(field_id).(run_id).center_roi_m1_mouth;
            GazeMatrices.(field_id).(run_id).center_roi_m2_mouth=GazeData.(field_id).(run_id).center_roi_m2_mouth;
    
            GazeMatrices.(field_id).(run_id).current_label=[];
            GazeMatrices.(field_id).(run_id).stim_time=[];
            stim_ts=GazeData.(field_id).(run_id).stim_ts;
            
            for nstim=1:length(stim_ts)        
                stim_id=char(strcat('stim_',num2str(nstim)));
    
                if GazeData.(field_id).(run_id).stim_ts(nstim) >= min(GazeData.(field_id).(run_id).t) && GazeData.(field_id).(run_id).stim_ts(nstim) < max(GazeData.(field_id).(run_id).t)-5
                
                % column 7 is m1 start index; column 8 is m1 end index
                % column 9 is m2 start index; column 10 is m2 end index
                % column 11 is m1 start time; column 12 is m1 end time
                % column 13 is m2 start time; column 14 is m2 end time

                GazeMatrices.(field_id).(run_id).current_label=vertcat(GazeMatrices.(field_id).(run_id).current_label, GazeData.(field_id).(run_id).all_stim_labels{nstim,1});
                GazeMatrices.(field_id).(run_id).stim_time=vertcat(GazeMatrices.(field_id).(run_id).stim_time, GazeData.(field_id).(run_id).stim_ts(nstim,1));
                               
                % exclusive m1 eyes within 5s
                
                fixation_m1_eye_idx=find(GazeData.(field_id).(run_id).m1_eye.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_eye.Var1(:,11)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m1_eye_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_pupilsize=NaN;                    
                else
                    fixation_m1_eye_duration=GazeData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_idx,12)-GazeData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_number=length(fixation_m1_eye_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_number_NaN=length(fixation_m1_eye_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_duration=fixation_m1_eye_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_duration_NaN=fixation_m1_eye_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_totalduration=sum(fixation_m1_eye_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_totalduration_NaN=sum(fixation_m1_eye_duration)';
    
                    for n_m1_eye=1:length(fixation_m1_eye_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_pupilsize(1,n_m1_eye)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_idx(n_m1_eye),7): GazeData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_idx(n_m1_eye),8)),'omitnan');
                    end
    
                    clear n_m1_eye
    
                end

                fixation_m1_eye_ipsi_idx=find(GazeData.(field_id).(run_id).m1_eye.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_eye.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_eye.Var2=='ipsi');
                
                if isempty(fixation_m1_eye_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_pupilsize=NaN;                    
                else
                    fixation_m1_eye_ipsi_duration=GazeData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_ipsi_idx,12)-GazeData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_ipsi_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_number=length(fixation_m1_eye_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_number_NaN=length(fixation_m1_eye_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_duration=fixation_m1_eye_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_duration_NaN=fixation_m1_eye_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_totalduration=sum(fixation_m1_eye_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_totalduration_NaN=sum(fixation_m1_eye_ipsi_duration)';
    
                    for n_m1_eye=1:length(fixation_m1_eye_ipsi_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_pupilsize(1,n_m1_eye)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_ipsi_idx(n_m1_eye),7): GazeData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_ipsi_idx(n_m1_eye),8)),'omitnan');
                    end
    
                    clear n_m1_eye
    
                end

                fixation_m1_eye_contra_idx=find(GazeData.(field_id).(run_id).m1_eye.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_eye.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_eye.Var2=='contra');
                
                if isempty(fixation_m1_eye_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_pupilsize=NaN;                    
                else
                    fixation_m1_eye_contra_duration=GazeData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_contra_idx,12)-GazeData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_contra_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_number=length(fixation_m1_eye_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_number_NaN=length(fixation_m1_eye_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_duration=fixation_m1_eye_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_duration_NaN=fixation_m1_eye_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_totalduration=sum(fixation_m1_eye_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_totalduration_NaN=sum(fixation_m1_eye_contra_duration)';
    
                    for n_m1_eye=1:length(fixation_m1_eye_contra_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_pupilsize(1,n_m1_eye)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_contra_idx(n_m1_eye),7): GazeData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_contra_idx(n_m1_eye),8)),'omitnan');
                    end
    
                    clear n_m1_eye
    
                end
    
                % exclusive m1 mouth within 5s
                
                fixation_m1_mouth_idx=find(GazeData.(field_id).(run_id).m1_mouth.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_mouth.Var1(:,11)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m1_mouth_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_pupilsize=NaN;                    
                else
                    fixation_m1_mouth_duration=GazeData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_idx,12)-GazeData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_number=length(fixation_m1_mouth_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_number_NaN=length(fixation_m1_mouth_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_duration=fixation_m1_mouth_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_duration_NaN=fixation_m1_mouth_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_totalduration=sum(fixation_m1_mouth_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_totalduration_NaN=sum(fixation_m1_mouth_duration)';
    
                    for n_m1_mouth=1:length(fixation_m1_mouth_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_pupilsize(1,n_m1_mouth)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_idx(n_m1_mouth),7): GazeData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_idx(n_m1_mouth),8)),'omitnan');
                    end
    
                    clear n_m1_mouth
    
                end

                fixation_m1_mouth_ipsi_idx=find(GazeData.(field_id).(run_id).m1_mouth.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_mouth.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_mouth.Var2=='ipsi');
                
                if isempty(fixation_m1_mouth_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_pupilsize=NaN;                    
                else
                    fixation_m1_mouth_ipsi_duration=GazeData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_ipsi_idx,12)-GazeData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_ipsi_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_number=length(fixation_m1_mouth_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_number_NaN=length(fixation_m1_mouth_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_duration=fixation_m1_mouth_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_duration_NaN=fixation_m1_mouth_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_totalduration=sum(fixation_m1_mouth_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_totalduration_NaN=sum(fixation_m1_mouth_ipsi_duration)';
    
                    for n_m1_mouth=1:length(fixation_m1_mouth_ipsi_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_pupilsize(1,n_m1_mouth)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_ipsi_idx(n_m1_mouth),7): GazeData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_ipsi_idx(n_m1_mouth),8)),'omitnan');
                    end
    
                    clear n_m1_mouth
    
                end

                fixation_m1_mouth_contra_idx=find(GazeData.(field_id).(run_id).m1_mouth.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_mouth.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_mouth.Var2=='contra');
                
                if isempty(fixation_m1_mouth_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_pupilsize=NaN;                    
                else
                    fixation_m1_mouth_contra_duration=GazeData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_contra_idx,12)-GazeData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_contra_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_number=length(fixation_m1_mouth_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_number_NaN=length(fixation_m1_mouth_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_duration=fixation_m1_mouth_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_duration_NaN=fixation_m1_mouth_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_totalduration=sum(fixation_m1_mouth_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_totalduration_NaN=sum(fixation_m1_mouth_contra_duration)';
    
                    for n_m1_mouth=1:length(fixation_m1_mouth_contra_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_pupilsize(1,n_m1_mouth)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_contra_idx(n_m1_mouth),7): GazeData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_contra_idx(n_m1_mouth),8)),'omitnan');
                    end
    
                    clear n_m1_mouth
    
                end
    
                % exclusive m1 non-eye, non-mouth face within 5s
                
                fixation_m1_nenmface_idx=find(GazeData.(field_id).(run_id).m1_nenmface.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_nenmface.Var1(:,11)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m1_nenmface_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_pupilsize=NaN;                    
                else
                    fixation_m1_nenmface_duration=GazeData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_idx,12)-GazeData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_number=length(fixation_m1_nenmface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_number_NaN=length(fixation_m1_nenmface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_duration=fixation_m1_nenmface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_duration_NaN=fixation_m1_nenmface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_totalduration=sum(fixation_m1_nenmface_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_totalduration_NaN=sum(fixation_m1_nenmface_duration)';
    
                    for n_m1_nenmface=1:length(fixation_m1_nenmface_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_pupilsize(1,n_m1_nenmface)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_idx(n_m1_nenmface),7): GazeData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_idx(n_m1_nenmface),8)),'omitnan');
                    end
    
                    clear n_m1_nenmface
    
                end

                fixation_m1_nenmface_ipsi_idx=find(GazeData.(field_id).(run_id).m1_nenmface.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_nenmface.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_nenmface.Var2=='ipsi');
                
                if isempty(fixation_m1_nenmface_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_pupilsize=NaN;                    
                else
                    fixation_m1_nenmface_ipsi_duration=GazeData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_ipsi_idx,12)-GazeData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_ipsi_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_number=length(fixation_m1_nenmface_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_number_NaN=length(fixation_m1_nenmface_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_duration=fixation_m1_nenmface_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_duration_NaN=fixation_m1_nenmface_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_totalduration=sum(fixation_m1_nenmface_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_totalduration_NaN=sum(fixation_m1_nenmface_ipsi_duration)';
    
                    for n_m1_nenmface=1:length(fixation_m1_nenmface_ipsi_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_pupilsize(1,n_m1_nenmface)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_ipsi_idx(n_m1_nenmface),7): GazeData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_ipsi_idx(n_m1_nenmface),8)),'omitnan');
                    end
    
                    clear n_m1_nenmface
    
                end

                fixation_m1_nenmface_contra_idx=find(GazeData.(field_id).(run_id).m1_nenmface.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_nenmface.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_nenmface.Var2=='contra');
                
                if isempty(fixation_m1_nenmface_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_pupilsize=NaN;                    
                else
                    fixation_m1_nenmface_contra_duration=GazeData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_contra_idx,12)-GazeData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_contra_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_number=length(fixation_m1_nenmface_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_number_NaN=length(fixation_m1_nenmface_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_duration=fixation_m1_nenmface_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_duration_NaN=fixation_m1_nenmface_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_totalduration=sum(fixation_m1_nenmface_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_totalduration_NaN=sum(fixation_m1_nenmface_contra_duration)';
    
                    for n_m1_nenmface=1:length(fixation_m1_nenmface_contra_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_pupilsize(1,n_m1_nenmface)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_contra_idx(n_m1_nenmface),7): GazeData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_contra_idx(n_m1_nenmface),8)),'omitnan');
                    end
    
                    clear n_m1_nenmface
    
                end
    
                % exclusive m1 everywhere within 5s
                
                fixation_m1_everywhere_idx=find(GazeData.(field_id).(run_id).m1_everywhere.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_everywhere.Var1(:,11)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m1_everywhere_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_pupilsize=NaN;                    
                else
                    fixation_m1_everywhere_duration=GazeData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_idx,12)-GazeData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_number=length(fixation_m1_everywhere_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_number_NaN=length(fixation_m1_everywhere_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_duration=fixation_m1_everywhere_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_duration_NaN=fixation_m1_everywhere_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_totalduration=sum(fixation_m1_everywhere_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_totalduration_NaN=sum(fixation_m1_everywhere_duration)';
    
                    for n_m1_everywhere=1:length(fixation_m1_everywhere_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_pupilsize(1,n_m1_everywhere)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_idx(n_m1_everywhere),7): GazeData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_idx(n_m1_everywhere),8)),'omitnan');
                    end
    
                    clear n_m1_everywhere
    
                end

                fixation_m1_everywhere_ipsi_idx=find(GazeData.(field_id).(run_id).m1_everywhere.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_everywhere.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_everywhere.Var2=='ipsi');
                
                if isempty(fixation_m1_everywhere_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_pupilsize=NaN;                    
                else
                    fixation_m1_everywhere_ipsi_duration=GazeData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_ipsi_idx,12)-GazeData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_ipsi_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_number=length(fixation_m1_everywhere_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_number_NaN=length(fixation_m1_everywhere_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_duration=fixation_m1_everywhere_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_duration_NaN=fixation_m1_everywhere_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_totalduration=sum(fixation_m1_everywhere_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_totalduration_NaN=sum(fixation_m1_everywhere_ipsi_duration)';
    
                    for n_m1_everywhere=1:length(fixation_m1_everywhere_ipsi_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_pupilsize(1,n_m1_everywhere)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_ipsi_idx(n_m1_everywhere),7): GazeData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_ipsi_idx(n_m1_everywhere),8)),'omitnan');
                    end
    
                    clear n_m1_everywhere
    
                end

                fixation_m1_everywhere_contra_idx=find(GazeData.(field_id).(run_id).m1_everywhere.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_everywhere.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_everywhere.Var2=='contra');
                
                if isempty(fixation_m1_everywhere_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_pupilsize=NaN;                    
                else
                    fixation_m1_everywhere_contra_duration=GazeData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_contra_idx,12)-GazeData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_contra_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_number=length(fixation_m1_everywhere_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_number_NaN=length(fixation_m1_everywhere_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_duration=fixation_m1_everywhere_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_duration_NaN=fixation_m1_everywhere_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_totalduration=sum(fixation_m1_everywhere_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_totalduration_NaN=sum(fixation_m1_everywhere_contra_duration)';
    
                    for n_m1_everywhere=1:length(fixation_m1_everywhere_contra_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_pupilsize(1,n_m1_everywhere)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_contra_idx(n_m1_everywhere),7): GazeData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_contra_idx(n_m1_everywhere),8)),'omitnan');
                    end
    
                    clear n_m1_everywhere
    
                end
    
                 % exclusive m1 non-eye face within 5s (mouth + face)
                
                fixation_m1_neface_idx=find(GazeData.(field_id).(run_id).m1_neface.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_neface.Var1(:,11)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m1_neface_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_pupilsize=NaN;                    
                else
                    fixation_m1_neface_duration=GazeData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_idx,12)-GazeData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_number=length(fixation_m1_neface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_number_NaN=length(fixation_m1_neface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_duration=fixation_m1_neface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_duration_NaN=fixation_m1_neface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_totalduration=sum(fixation_m1_neface_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_totalduration_NaN=sum(fixation_m1_neface_duration)';
    
                    for n_m1_neface=1:length(fixation_m1_neface_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_pupilsize(1,n_m1_neface)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_idx(n_m1_neface),7): GazeData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_idx(n_m1_neface),8)),'omitnan');
                    end
    
                    clear n_m1_neface
    
                end

                fixation_m1_neface_ipsi_idx=find(GazeData.(field_id).(run_id).m1_neface.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_neface.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_neface.Var2=='ipsi');
                
                if isempty(fixation_m1_neface_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_pupilsize=NaN;                    
                else
                    fixation_m1_neface_ipsi_duration=GazeData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_ipsi_idx,12)-GazeData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_ipsi_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_number=length(fixation_m1_neface_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_number_NaN=length(fixation_m1_neface_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_duration=fixation_m1_neface_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_duration_NaN=fixation_m1_neface_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_totalduration=sum(fixation_m1_neface_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_totalduration_NaN=sum(fixation_m1_neface_ipsi_duration)';
    
                    for n_m1_neface=1:length(fixation_m1_neface_ipsi_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_pupilsize(1,n_m1_neface)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_ipsi_idx(n_m1_neface),7): GazeData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_ipsi_idx(n_m1_neface),8)),'omitnan');
                    end
    
                    clear n_m1_neface
    
                end

                fixation_m1_neface_contra_idx=find(GazeData.(field_id).(run_id).m1_neface.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_neface.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_neface.Var2=='contra');
                
                if isempty(fixation_m1_neface_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_pupilsize=NaN;                    
                else
                    fixation_m1_neface_contra_duration=GazeData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_contra_idx,12)-GazeData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_contra_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_number=length(fixation_m1_neface_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_number_NaN=length(fixation_m1_neface_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_duration=fixation_m1_neface_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_duration_NaN=fixation_m1_neface_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_totalduration=sum(fixation_m1_neface_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_totalduration_NaN=sum(fixation_m1_neface_contra_duration)';
    
                    for n_m1_neface=1:length(fixation_m1_neface_contra_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_pupilsize(1,n_m1_neface)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_contra_idx(n_m1_neface),7): GazeData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_contra_idx(n_m1_neface),8)),'omitnan');
                    end
    
                    clear n_m1_neface
    
                end
    
                % exclusive m1 whole face within 5s (eye + mouth + face)
                
                fixation_m1_wholeface_idx=find(GazeData.(field_id).(run_id).m1_wholeface.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_wholeface.Var1(:,11)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m1_wholeface_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_pupilsize=NaN;                    
                else
                    fixation_m1_wholeface_duration=GazeData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_idx,12)-GazeData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_number=length(fixation_m1_wholeface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_number_NaN=length(fixation_m1_wholeface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_duration=fixation_m1_wholeface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_duration_NaN=fixation_m1_wholeface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_totalduration=sum(fixation_m1_wholeface_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_totalduration_NaN=sum(fixation_m1_wholeface_duration)';
    
                    for n_m1_wholeface=1:length(fixation_m1_wholeface_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_pupilsize(1,n_m1_wholeface)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_idx(n_m1_wholeface),7): GazeData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_idx(n_m1_wholeface),8)),'omitnan');
                    end
    
                    clear n_m1_wholeface
    
                end

                fixation_m1_wholeface_ipsi_idx=find(GazeData.(field_id).(run_id).m1_wholeface.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_wholeface.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_wholeface.Var2=='ipsi');
                
                if isempty(fixation_m1_wholeface_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_pupilsize=NaN;                    
                else
                    fixation_m1_wholeface_ipsi_duration=GazeData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_ipsi_idx,12)-GazeData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_ipsi_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_number=length(fixation_m1_wholeface_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_number_NaN=length(fixation_m1_wholeface_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_duration=fixation_m1_wholeface_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_duration_NaN=fixation_m1_wholeface_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_totalduration=sum(fixation_m1_wholeface_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_totalduration_NaN=sum(fixation_m1_wholeface_ipsi_duration)';
    
                    for n_m1_wholeface=1:length(fixation_m1_wholeface_ipsi_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_pupilsize(1,n_m1_wholeface)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_ipsi_idx(n_m1_wholeface),7): GazeData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_ipsi_idx(n_m1_wholeface),8)),'omitnan');
                    end
    
                    clear n_m1_wholeface
    
                end

                fixation_m1_wholeface_contra_idx=find(GazeData.(field_id).(run_id).m1_wholeface.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_wholeface.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_wholeface.Var2=='contra');
                
                if isempty(fixation_m1_wholeface_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_pupilsize=NaN;                    
                else
                    fixation_m1_wholeface_contra_duration=GazeData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_contra_idx,12)-GazeData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_contra_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_number=length(fixation_m1_wholeface_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_number_NaN=length(fixation_m1_wholeface_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_duration=fixation_m1_wholeface_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_duration_NaN=fixation_m1_wholeface_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_totalduration=sum(fixation_m1_wholeface_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_totalduration_NaN=sum(fixation_m1_wholeface_contra_duration)';
    
                    for n_m1_wholeface=1:length(fixation_m1_wholeface_contra_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_pupilsize(1,n_m1_wholeface)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_contra_idx(n_m1_wholeface),7): GazeData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_contra_idx(n_m1_wholeface),8)),'omitnan');
                    end
    
                    clear n_m1_wholeface
    
                end
    
                % exclusive m1 all within 5s (eye + mouth + face + everywhere)
                
                fixation_m1_all_idx=find(GazeData.(field_id).(run_id).m1_all.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_all.Var1(:,11)<stim_ts(nstim)+look_ahead);

                if isempty(fixation_m1_all_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_totalduration_NaN=NaN;
                    
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_pupilsize=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_mouth=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_face=NaN;  
                else
                    fixation_m1_all_duration=GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx,12)-GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_number=length(fixation_m1_all_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_number_NaN=length(fixation_m1_all_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_duration=fixation_m1_all_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_duration_NaN=fixation_m1_all_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_totalduration=sum(fixation_m1_all_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_totalduration_NaN=sum(fixation_m1_all_duration)';
               
                    for n_m1_all=1:length(fixation_m1_all_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_pupilsize(1,n_m1_all)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx(n_m1_all),7): GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx(n_m1_all),8)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1(1,n_m1_all)=mean(GazeData.(field_id).(run_id).x_m1(GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx(n_m1_all),7): GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx(n_m1_all),8)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1(1,n_m1_all)=mean(GazeData.(field_id).(run_id).y_m1(GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx(n_m1_all),7): GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx(n_m1_all),8)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes(1,n_m1_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_eyes(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_eyes(2)).^2);
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_mouth(1,n_m1_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_mouth(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_mouth(2)).^2);
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_face(1,n_m1_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_face(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_face(2)).^2);
                   
                    end
    
                    clear n_m1_all
    
                end

                fixation_m1_all_ipsi_idx=find(GazeData.(field_id).(run_id).m1_all.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_all.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_all.Var2=='ipsi');
                
                if isempty(fixation_m1_all_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_totalduration_NaN=NaN;
                    
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_pupilsize=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1_ipsi=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1_ipsi=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes_ipsi=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_mouth_ipsi=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_face_ipsi=NaN;  
                else
                    fixation_m1_all_ipsi_duration=GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx,12)-GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_number=length(fixation_m1_all_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_number_NaN=length(fixation_m1_all_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_duration=fixation_m1_all_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_duration_NaN=fixation_m1_all_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_totalduration=sum(fixation_m1_all_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_totalduration_NaN=sum(fixation_m1_all_ipsi_duration)';
               
                    for n_m1_all=1:length(fixation_m1_all_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_pupilsize(1,n_m1_all)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx(n_m1_all),7): GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx(n_m1_all),8)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1_ipsi(1,n_m1_all)=mean(GazeData.(field_id).(run_id).x_m1(GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx(n_m1_all),7): GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx(n_m1_all),8)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1_ipsi(1,n_m1_all)=mean(GazeData.(field_id).(run_id).y_m1(GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx(n_m1_all),7): GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx(n_m1_all),8)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes_ipsi(1,n_m1_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1_ipsi(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_eyes(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1_ipsi(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_eyes(2)).^2);
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_mouth_ipsi(1,n_m1_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1_ipsi(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_mouth(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1_ipsi(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_mouth(2)).^2);
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_face_ipsi(1,n_m1_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1_ipsi(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_face(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1_ipsi(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_face(2)).^2);
                   
                    end
    
                    clear n_m1_all
    
                end

                fixation_m1_all_contra_idx=find(GazeData.(field_id).(run_id).m1_all.Var1(:,11)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m1_all.Var1(:,11)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m1_all.Var2=='contra');
                
                if isempty(fixation_m1_all_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_totalduration_NaN=NaN;
                    
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_pupilsize=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1_contra=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1_contra=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes_contra=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_mouth_contra=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_face_contra=NaN;  
                else
                    fixation_m1_all_contra_duration=GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx,12)-GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx,11);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_number=length(fixation_m1_all_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_number_NaN=length(fixation_m1_all_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_duration=fixation_m1_all_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_duration_NaN=fixation_m1_all_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_totalduration=sum(fixation_m1_all_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_totalduration_NaN=sum(fixation_m1_all_contra_duration)';
               
                    for n_m1_all=1:length(fixation_m1_all_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_pupilsize(1,n_m1_all)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx(n_m1_all),7): GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx(n_m1_all),8)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1_contra(1,n_m1_all)=mean(GazeData.(field_id).(run_id).x_m1(GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx(n_m1_all),7): GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx(n_m1_all),8)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1_contra(1,n_m1_all)=mean(GazeData.(field_id).(run_id).y_m1(GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx(n_m1_all),7): GazeData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx(n_m1_all),8)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes_contra(1,n_m1_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1_contra(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_eyes(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1_contra(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_eyes(2)).^2);
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_mouth_contra(1,n_m1_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1_contra(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_mouth(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1_contra(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_mouth(2)).^2);
                    GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_face_contra(1,n_m1_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m1_contra(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_face(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m1_contra(1,n_m1_all)-GazeMatrices.(field_id).(run_id).center_roi_m1_face(2)).^2);
                   
                    end
    
                    clear n_m1_all
    
                end
                
                
                % SAME THING FOR M2
                
                % exclusive m2 eyes within 5s
                
                 fixation_m2_eye_idx=find(GazeData.(field_id).(run_id).m2_eye.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_eye.Var1(:,13)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m2_eye_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_pupilsize=NaN;                    
                else
                    fixation_m2_eye_duration=GazeData.(field_id).(run_id).m2_eye.Var1(fixation_m2_eye_idx,14)-GazeData.(field_id).(run_id).m2_eye.Var1(fixation_m2_eye_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_number=length(fixation_m2_eye_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_number_NaN=length(fixation_m2_eye_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_duration=fixation_m2_eye_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_duration_NaN=fixation_m2_eye_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_totalduration=sum(fixation_m2_eye_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_totalduration_NaN=sum(fixation_m2_eye_duration)';
    
                    for n_m2_eye=1:length(fixation_m2_eye_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_pupilsize(1,n_m2_eye)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_eye.Var1(fixation_m2_eye_idx(n_m2_eye),9): GazeData.(field_id).(run_id).m2_eye.Var1(fixation_m2_eye_idx(n_m2_eye),10)),'omitnan');
                    end
    
                    clear n_m2_eye
    
                end

                fixation_m2_eye_ipsi_idx=find(GazeData.(field_id).(run_id).m2_eye.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_eye.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_eye.Var2=='ipsi');
                
                if isempty(fixation_m2_eye_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_pupilsize=NaN;                    
                else
                    fixation_m2_eye_ipsi_duration=GazeData.(field_id).(run_id).m2_eye.Var1(fixation_m2_eye_ipsi_idx,14)-GazeData.(field_id).(run_id).m2_eye.Var1(fixation_m2_eye_ipsi_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_number=length(fixation_m2_eye_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_number_NaN=length(fixation_m2_eye_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_duration=fixation_m2_eye_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_duration_NaN=fixation_m2_eye_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_totalduration=sum(fixation_m2_eye_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_totalduration_NaN=sum(fixation_m2_eye_ipsi_duration)';
    
                    for n_m2_eye=1:length(fixation_m2_eye_ipsi_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_ipsi_pupilsize(1,n_m2_eye)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_eye.Var1(fixation_m2_eye_ipsi_idx(n_m2_eye),9): GazeData.(field_id).(run_id).m2_eye.Var1(fixation_m2_eye_ipsi_idx(n_m2_eye),10)),'omitnan');
                    end
    
                    clear n_m2_eye
    
                end

                fixation_m2_eye_contra_idx=find(GazeData.(field_id).(run_id).m2_eye.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_eye.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_eye.Var2=='contra');
                
                if isempty(fixation_m2_eye_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_pupilsize=NaN;                    
                else
                    fixation_m2_eye_contra_duration=GazeData.(field_id).(run_id).m2_eye.Var1(fixation_m2_eye_contra_idx,14)-GazeData.(field_id).(run_id).m2_eye.Var1(fixation_m2_eye_contra_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_number=length(fixation_m2_eye_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_number_NaN=length(fixation_m2_eye_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_duration=fixation_m2_eye_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_duration_NaN=fixation_m2_eye_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_totalduration=sum(fixation_m2_eye_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_totalduration_NaN=sum(fixation_m2_eye_contra_duration)';
    
                    for n_m2_eye=1:length(fixation_m2_eye_contra_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_eye_contra_pupilsize(1,n_m2_eye)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_eye.Var1(fixation_m2_eye_contra_idx(n_m2_eye),9): GazeData.(field_id).(run_id).m2_eye.Var1(fixation_m2_eye_contra_idx(n_m2_eye),10)),'omitnan');
                    end
    
                    clear n_m2_eye
    
                end
    
                % exclusive m2 mouth within 5s
                
                fixation_m2_mouth_idx=find(GazeData.(field_id).(run_id).m2_mouth.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_mouth.Var1(:,13)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m2_mouth_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_pupilsize=NaN;                    
                else
                    fixation_m2_mouth_duration=GazeData.(field_id).(run_id).m2_mouth.Var1(fixation_m2_mouth_idx,14)-GazeData.(field_id).(run_id).m2_mouth.Var1(fixation_m2_mouth_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_number=length(fixation_m2_mouth_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_number_NaN=length(fixation_m2_mouth_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_duration=fixation_m2_mouth_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_duration_NaN=fixation_m2_mouth_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_totalduration=sum(fixation_m2_mouth_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_totalduration_NaN=sum(fixation_m2_mouth_duration)';
    
                    for n_m2_mouth=1:length(fixation_m2_mouth_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_pupilsize(1,n_m2_mouth)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_mouth.Var1(fixation_m2_mouth_idx(n_m2_mouth),9): GazeData.(field_id).(run_id).m2_mouth.Var1(fixation_m2_mouth_idx(n_m2_mouth),10)),'omitnan');
                    end
    
                    clear n_m2_mouth
    
                end

                fixation_m2_mouth_ipsi_idx=find(GazeData.(field_id).(run_id).m2_mouth.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_mouth.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_mouth.Var2=='ipsi');
                
                if isempty(fixation_m2_mouth_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_pupilsize=NaN;                    
                else
                    fixation_m2_mouth_ipsi_duration=GazeData.(field_id).(run_id).m2_mouth.Var1(fixation_m2_mouth_ipsi_idx,14)-GazeData.(field_id).(run_id).m2_mouth.Var1(fixation_m2_mouth_ipsi_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_number=length(fixation_m2_mouth_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_number_NaN=length(fixation_m2_mouth_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_duration=fixation_m2_mouth_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_duration_NaN=fixation_m2_mouth_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_totalduration=sum(fixation_m2_mouth_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_totalduration_NaN=sum(fixation_m2_mouth_ipsi_duration)';
    
                    for n_m2_mouth=1:length(fixation_m2_mouth_ipsi_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_ipsi_pupilsize(1,n_m2_mouth)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_mouth.Var1(fixation_m2_mouth_ipsi_idx(n_m2_mouth),9): GazeData.(field_id).(run_id).m2_mouth.Var1(fixation_m2_mouth_ipsi_idx(n_m2_mouth),10)),'omitnan');
                    end
    
                    clear n_m2_mouth
    
                end

                fixation_m2_mouth_contra_idx=find(GazeData.(field_id).(run_id).m2_mouth.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_mouth.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_mouth.Var2=='contra');
                
                if isempty(fixation_m2_mouth_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_pupilsize=NaN;                    
                else
                    fixation_m2_mouth_contra_duration=GazeData.(field_id).(run_id).m2_mouth.Var1(fixation_m2_mouth_contra_idx,14)-GazeData.(field_id).(run_id).m2_mouth.Var1(fixation_m2_mouth_contra_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_number=length(fixation_m2_mouth_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_number_NaN=length(fixation_m2_mouth_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_duration=fixation_m2_mouth_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_duration_NaN=fixation_m2_mouth_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_totalduration=sum(fixation_m2_mouth_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_totalduration_NaN=sum(fixation_m2_mouth_contra_duration)';
    
                    for n_m2_mouth=1:length(fixation_m2_mouth_contra_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_mouth_contra_pupilsize(1,n_m2_mouth)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_mouth.Var1(fixation_m2_mouth_contra_idx(n_m2_mouth),9): GazeData.(field_id).(run_id).m2_mouth.Var1(fixation_m2_mouth_contra_idx(n_m2_mouth),10)),'omitnan');
                    end
    
                    clear n_m2_mouth
    
                end
    
                % exclusive m2 non-eye, non-mouth face within 5s
                
                fixation_m2_nenmface_idx=find(GazeData.(field_id).(run_id).m2_nenmface.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_nenmface.Var1(:,13)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m2_nenmface_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_pupilsize=NaN;                    
                else
                    fixation_m2_nenmface_duration=GazeData.(field_id).(run_id).m2_nenmface.Var1(fixation_m2_nenmface_idx,14)-GazeData.(field_id).(run_id).m2_nenmface.Var1(fixation_m2_nenmface_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_number=length(fixation_m2_nenmface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_number_NaN=length(fixation_m2_nenmface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_duration=fixation_m2_nenmface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_duration_NaN=fixation_m2_nenmface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_totalduration=sum(fixation_m2_nenmface_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_totalduration_NaN=sum(fixation_m2_nenmface_duration)';
    
                    for n_m2_nenmface=1:length(fixation_m2_nenmface_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_pupilsize(1,n_m2_nenmface)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_nenmface.Var1(fixation_m2_nenmface_idx(n_m2_nenmface),9): GazeData.(field_id).(run_id).m2_nenmface.Var1(fixation_m2_nenmface_idx(n_m2_nenmface),10)),'omitnan');
                    end
    
                    clear n_m2_nenmface
    
                end

                fixation_m2_nenmface_ipsi_idx=find(GazeData.(field_id).(run_id).m2_nenmface.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_nenmface.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_nenmface.Var2=='ipsi');
                
                if isempty(fixation_m2_nenmface_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_pupilsize=NaN;                    
                else
                    fixation_m2_nenmface_ipsi_duration=GazeData.(field_id).(run_id).m2_nenmface.Var1(fixation_m2_nenmface_ipsi_idx,14)-GazeData.(field_id).(run_id).m2_nenmface.Var1(fixation_m2_nenmface_ipsi_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_number=length(fixation_m2_nenmface_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_number_NaN=length(fixation_m2_nenmface_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_duration=fixation_m2_nenmface_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_duration_NaN=fixation_m2_nenmface_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_totalduration=sum(fixation_m2_nenmface_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_totalduration_NaN=sum(fixation_m2_nenmface_ipsi_duration)';
    
                    for n_m2_nenmface=1:length(fixation_m2_nenmface_ipsi_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_ipsi_pupilsize(1,n_m2_nenmface)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_nenmface.Var1(fixation_m2_nenmface_ipsi_idx(n_m2_nenmface),9): GazeData.(field_id).(run_id).m2_nenmface.Var1(fixation_m2_nenmface_ipsi_idx(n_m2_nenmface),10)),'omitnan');
                    end
    
                    clear n_m2_nenmface
    
                end

                fixation_m2_nenmface_contra_idx=find(GazeData.(field_id).(run_id).m2_nenmface.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_nenmface.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_nenmface.Var2=='contra');
                
                if isempty(fixation_m2_nenmface_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_pupilsize=NaN;                    
                else
                    fixation_m2_nenmface_contra_duration=GazeData.(field_id).(run_id).m2_nenmface.Var1(fixation_m2_nenmface_contra_idx,14)-GazeData.(field_id).(run_id).m2_nenmface.Var1(fixation_m2_nenmface_contra_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_number=length(fixation_m2_nenmface_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_number_NaN=length(fixation_m2_nenmface_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_duration=fixation_m2_nenmface_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_duration_NaN=fixation_m2_nenmface_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_totalduration=sum(fixation_m2_nenmface_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_totalduration_NaN=sum(fixation_m2_nenmface_contra_duration)';
    
                    for n_m2_nenmface=1:length(fixation_m2_nenmface_contra_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_nenmface_contra_pupilsize(1,n_m2_nenmface)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_nenmface.Var1(fixation_m2_nenmface_contra_idx(n_m2_nenmface),9): GazeData.(field_id).(run_id).m2_nenmface.Var1(fixation_m2_nenmface_contra_idx(n_m2_nenmface),10)),'omitnan');
                    end
    
                    clear n_m2_nenmface
    
                end
    
                % exclusive m2 everywhere within 5s
                
                fixation_m2_everywhere_idx=find(GazeData.(field_id).(run_id).m2_everywhere.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_everywhere.Var1(:,13)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m2_everywhere_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_pupilsize=NaN;                    
                else
                    fixation_m2_everywhere_duration=GazeData.(field_id).(run_id).m2_everywhere.Var1(fixation_m2_everywhere_idx,14)-GazeData.(field_id).(run_id).m2_everywhere.Var1(fixation_m2_everywhere_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_number=length(fixation_m2_everywhere_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_number_NaN=length(fixation_m2_everywhere_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_duration=fixation_m2_everywhere_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_duration_NaN=fixation_m2_everywhere_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_totalduration=sum(fixation_m2_everywhere_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_totalduration_NaN=sum(fixation_m2_everywhere_duration)';
    
                    for n_m2_everywhere=1:length(fixation_m2_everywhere_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_pupilsize(1,n_m2_everywhere)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_everywhere.Var1(fixation_m2_everywhere_idx(n_m2_everywhere),9): GazeData.(field_id).(run_id).m2_everywhere.Var1(fixation_m2_everywhere_idx(n_m2_everywhere),10)),'omitnan');
                    end
    
                    clear n_m2_everywhere
    
                end

                fixation_m2_everywhere_ipsi_idx=find(GazeData.(field_id).(run_id).m2_everywhere.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_everywhere.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_everywhere.Var2=='ipsi');
                
                if isempty(fixation_m2_everywhere_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_pupilsize=NaN;                    
                else
                    fixation_m2_everywhere_ipsi_duration=GazeData.(field_id).(run_id).m2_everywhere.Var1(fixation_m2_everywhere_ipsi_idx,14)-GazeData.(field_id).(run_id).m2_everywhere.Var1(fixation_m2_everywhere_ipsi_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_number=length(fixation_m2_everywhere_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_number_NaN=length(fixation_m2_everywhere_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_duration=fixation_m2_everywhere_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_duration_NaN=fixation_m2_everywhere_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_totalduration=sum(fixation_m2_everywhere_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_totalduration_NaN=sum(fixation_m2_everywhere_ipsi_duration)';
    
                    for n_m2_everywhere=1:length(fixation_m2_everywhere_ipsi_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_ipsi_pupilsize(1,n_m2_everywhere)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_everywhere.Var1(fixation_m2_everywhere_ipsi_idx(n_m2_everywhere),9): GazeData.(field_id).(run_id).m2_everywhere.Var1(fixation_m2_everywhere_ipsi_idx(n_m2_everywhere),10)),'omitnan');
                    end
    
                    clear n_m2_everywhere
    
                end

                fixation_m2_everywhere_contra_idx=find(GazeData.(field_id).(run_id).m2_everywhere.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_everywhere.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_everywhere.Var2=='contra');
                
                if isempty(fixation_m2_everywhere_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_pupilsize=NaN;                    
                else
                    fixation_m2_everywhere_contra_duration=GazeData.(field_id).(run_id).m2_everywhere.Var1(fixation_m2_everywhere_contra_idx,14)-GazeData.(field_id).(run_id).m2_everywhere.Var1(fixation_m2_everywhere_contra_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_number=length(fixation_m2_everywhere_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_number_NaN=length(fixation_m2_everywhere_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_duration=fixation_m2_everywhere_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_duration_NaN=fixation_m2_everywhere_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_totalduration=sum(fixation_m2_everywhere_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_totalduration_NaN=sum(fixation_m2_everywhere_contra_duration)';
    
                    for n_m2_everywhere=1:length(fixation_m2_everywhere_contra_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_everywhere_contra_pupilsize(1,n_m2_everywhere)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_everywhere.Var1(fixation_m2_everywhere_contra_idx(n_m2_everywhere),9): GazeData.(field_id).(run_id).m2_everywhere.Var1(fixation_m2_everywhere_contra_idx(n_m2_everywhere),10)),'omitnan');
                    end
    
                    clear n_m2_everywhere
    
                end
    
                 % exclusive m2 non-eye face within 5s (mouth + face)
                
                fixation_m2_neface_idx=find(GazeData.(field_id).(run_id).m2_neface.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_neface.Var1(:,13)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m2_neface_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_pupilsize=NaN;                    
                else
                    fixation_m2_neface_duration=GazeData.(field_id).(run_id).m2_neface.Var1(fixation_m2_neface_idx,14)-GazeData.(field_id).(run_id).m2_neface.Var1(fixation_m2_neface_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_number=length(fixation_m2_neface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_number_NaN=length(fixation_m2_neface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_duration=fixation_m2_neface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_duration_NaN=fixation_m2_neface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_totalduration=sum(fixation_m2_neface_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_totalduration_NaN=sum(fixation_m2_neface_duration)';
    
                    for n_m2_neface=1:length(fixation_m2_neface_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_pupilsize(1,n_m2_neface)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_neface.Var1(fixation_m2_neface_idx(n_m2_neface),9): GazeData.(field_id).(run_id).m2_neface.Var1(fixation_m2_neface_idx(n_m2_neface),10)),'omitnan');
                    end
    
                    clear n_m2_neface
    
                end

                fixation_m2_neface_ipsi_idx=find(GazeData.(field_id).(run_id).m2_neface.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_neface.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_neface.Var2=='ipsi');
                
                if isempty(fixation_m2_neface_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_pupilsize=NaN;                    
                else
                    fixation_m2_neface_ipsi_duration=GazeData.(field_id).(run_id).m2_neface.Var1(fixation_m2_neface_ipsi_idx,14)-GazeData.(field_id).(run_id).m2_neface.Var1(fixation_m2_neface_ipsi_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_number=length(fixation_m2_neface_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_number_NaN=length(fixation_m2_neface_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_duration=fixation_m2_neface_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_duration_NaN=fixation_m2_neface_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_totalduration=sum(fixation_m2_neface_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_totalduration_NaN=sum(fixation_m2_neface_ipsi_duration)';
    
                    for n_m2_neface=1:length(fixation_m2_neface_ipsi_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_ipsi_pupilsize(1,n_m2_neface)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_neface.Var1(fixation_m2_neface_ipsi_idx(n_m2_neface),9): GazeData.(field_id).(run_id).m2_neface.Var1(fixation_m2_neface_ipsi_idx(n_m2_neface),10)),'omitnan');
                    end
    
                    clear n_m2_neface
    
                end

                fixation_m2_neface_contra_idx=find(GazeData.(field_id).(run_id).m2_neface.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_neface.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_neface.Var2=='contra');
                
                if isempty(fixation_m2_neface_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_pupilsize=NaN;                    
                else
                    fixation_m2_neface_contra_duration=GazeData.(field_id).(run_id).m2_neface.Var1(fixation_m2_neface_contra_idx,14)-GazeData.(field_id).(run_id).m2_neface.Var1(fixation_m2_neface_contra_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_number=length(fixation_m2_neface_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_number_NaN=length(fixation_m2_neface_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_duration=fixation_m2_neface_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_duration_NaN=fixation_m2_neface_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_totalduration=sum(fixation_m2_neface_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_totalduration_NaN=sum(fixation_m2_neface_contra_duration)';
    
                    for n_m2_neface=1:length(fixation_m2_neface_contra_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_neface_contra_pupilsize(1,n_m2_neface)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_neface.Var1(fixation_m2_neface_contra_idx(n_m2_neface),9): GazeData.(field_id).(run_id).m2_neface.Var1(fixation_m2_neface_contra_idx(n_m2_neface),10)),'omitnan');
                    end
    
                    clear n_m2_neface
    
                end
    
                % exclusive m2 whole face within 5s (eye + mouth + face)
                
                fixation_m2_wholeface_idx=find(GazeData.(field_id).(run_id).m2_wholeface.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_wholeface.Var1(:,13)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m2_wholeface_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_pupilsize=NaN;                    
                else
                    fixation_m2_wholeface_duration=GazeData.(field_id).(run_id).m2_wholeface.Var1(fixation_m2_wholeface_idx,14)-GazeData.(field_id).(run_id).m2_wholeface.Var1(fixation_m2_wholeface_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_number=length(fixation_m2_wholeface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_number_NaN=length(fixation_m2_wholeface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_duration=fixation_m2_wholeface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_duration_NaN=fixation_m2_wholeface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_totalduration=sum(fixation_m2_wholeface_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_totalduration_NaN=sum(fixation_m2_wholeface_duration)';
    
                    for n_m2_wholeface=1:length(fixation_m2_wholeface_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_pupilsize(1,n_m2_wholeface)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_wholeface.Var1(fixation_m2_wholeface_idx(n_m2_wholeface),9): GazeData.(field_id).(run_id).m2_wholeface.Var1(fixation_m2_wholeface_idx(n_m2_wholeface),10)),'omitnan');
                    end
    
                    clear n_m2_wholeface
    
                end

                fixation_m2_wholeface_ipsi_idx=find(GazeData.(field_id).(run_id).m2_wholeface.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_wholeface.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_wholeface.Var2=='ipsi');
                
                if isempty(fixation_m2_wholeface_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_pupilsize=NaN;                    
                else
                    fixation_m2_wholeface_ipsi_duration=GazeData.(field_id).(run_id).m2_wholeface.Var1(fixation_m2_wholeface_ipsi_idx,14)-GazeData.(field_id).(run_id).m2_wholeface.Var1(fixation_m2_wholeface_ipsi_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_number=length(fixation_m2_wholeface_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_number_NaN=length(fixation_m2_wholeface_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_duration=fixation_m2_wholeface_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_duration_NaN=fixation_m2_wholeface_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_totalduration=sum(fixation_m2_wholeface_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_totalduration_NaN=sum(fixation_m2_wholeface_ipsi_duration)';
    
                    for n_m2_wholeface=1:length(fixation_m2_wholeface_ipsi_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_ipsi_pupilsize(1,n_m2_wholeface)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_wholeface.Var1(fixation_m2_wholeface_ipsi_idx(n_m2_wholeface),9): GazeData.(field_id).(run_id).m2_wholeface.Var1(fixation_m2_wholeface_ipsi_idx(n_m2_wholeface),10)),'omitnan');
                    end
    
                    clear n_m2_wholeface
    
                end

                fixation_m2_wholeface_contra_idx=find(GazeData.(field_id).(run_id).m2_wholeface.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_wholeface.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_wholeface.Var2=='contra');
                
                if isempty(fixation_m2_wholeface_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_pupilsize=NaN;                    
                else
                    fixation_m2_wholeface_contra_duration=GazeData.(field_id).(run_id).m2_wholeface.Var1(fixation_m2_wholeface_contra_idx,14)-GazeData.(field_id).(run_id).m2_wholeface.Var1(fixation_m2_wholeface_contra_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_number=length(fixation_m2_wholeface_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_number_NaN=length(fixation_m2_wholeface_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_duration=fixation_m2_wholeface_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_duration_NaN=fixation_m2_wholeface_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_totalduration=sum(fixation_m2_wholeface_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_totalduration_NaN=sum(fixation_m2_wholeface_contra_duration)';
    
                    for n_m2_wholeface=1:length(fixation_m2_wholeface_contra_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_wholeface_contra_pupilsize(1,n_m2_wholeface)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_wholeface.Var1(fixation_m2_wholeface_contra_idx(n_m2_wholeface),9): GazeData.(field_id).(run_id).m2_wholeface.Var1(fixation_m2_wholeface_contra_idx(n_m2_wholeface),10)),'omitnan');
                    end
    
                    clear n_m2_wholeface
    
                end
    
                % exclusive m2 all within 5s (eye + mouth + face + everywhere)
                
                fixation_m2_all_idx=find(GazeData.(field_id).(run_id).m2_all.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_all.Var1(:,13)<stim_ts(nstim)+look_ahead);

                if isempty(fixation_m2_all_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_totalduration_NaN=NaN;
                    
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_pupilsize=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_eyes=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_mouth=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_face=NaN;  
                else
                    fixation_m2_all_duration=GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_idx,14)-GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_number=length(fixation_m2_all_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_number_NaN=length(fixation_m2_all_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_duration=fixation_m2_all_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_duration_NaN=fixation_m2_all_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_totalduration=sum(fixation_m2_all_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_totalduration_NaN=sum(fixation_m2_all_duration)';
               
                    for n_m2_all=1:length(fixation_m2_all_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_pupilsize(1,n_m2_all)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_idx(n_m2_all),9): GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_idx(n_m2_all),10)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2(1,n_m2_all)=mean(GazeData.(field_id).(run_id).x_m2(GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_idx(n_m2_all),9): GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_idx(n_m2_all),10)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2(1,n_m2_all)=mean(GazeData.(field_id).(run_id).y_m2(GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_idx(n_m2_all),9): GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_idx(n_m2_all),10)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_eyes(1,n_m2_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_eyes(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_eyes(2)).^2);
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_mouth(1,n_m2_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_mouth(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_mouth(2)).^2);
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_face(1,n_m2_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_face(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_face(2)).^2);
                   
                    end
    
                    clear n_m2_all
    
                end

                fixation_m2_all_ipsi_idx=find(GazeData.(field_id).(run_id).m2_all.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_all.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_all.Var2=='ipsi');
                
                if isempty(fixation_m2_all_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_totalduration_NaN=NaN;
                    
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_pupilsize=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2_ipsi=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2_ipsi=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_eyes_ipsi=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_mouth_ipsi=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_face_ipsi=NaN;  
                else
                    fixation_m2_all_ipsi_duration=GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_ipsi_idx,14)-GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_ipsi_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_number=length(fixation_m2_all_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_number_NaN=length(fixation_m2_all_ipsi_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_duration=fixation_m2_all_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_duration_NaN=fixation_m2_all_ipsi_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_totalduration=sum(fixation_m2_all_ipsi_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_totalduration_NaN=sum(fixation_m2_all_ipsi_duration)';
               
                    for n_m2_all=1:length(fixation_m2_all_ipsi_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_ipsi_pupilsize(1,n_m2_all)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_ipsi_idx(n_m2_all),9): GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_ipsi_idx(n_m2_all),10)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2_ipsi(1,n_m2_all)=mean(GazeData.(field_id).(run_id).x_m2(GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_ipsi_idx(n_m2_all),9): GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_ipsi_idx(n_m2_all),10)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2_ipsi(1,n_m2_all)=mean(GazeData.(field_id).(run_id).y_m2(GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_ipsi_idx(n_m2_all),9): GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_ipsi_idx(n_m2_all),10)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_eyes_ipsi(1,n_m2_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2_ipsi(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_eyes(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2_ipsi(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_eyes(2)).^2);
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_mouth_ipsi(1,n_m2_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2_ipsi(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_mouth(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2_ipsi(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_mouth(2)).^2);
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_face_ipsi(1,n_m2_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2_ipsi(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_face(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2_ipsi(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_face(2)).^2);
                   
                    end
    
                    clear n_m2_all
    
                end

                fixation_m2_all_contra_idx=find(GazeData.(field_id).(run_id).m2_all.Var1(:,13)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).m2_all.Var1(:,13)<stim_ts(nstim)+look_ahead & GazeData.(field_id).(run_id).m2_all.Var2=='contra');
                
                if isempty(fixation_m2_all_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_totalduration_NaN=NaN;
                    
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_pupilsize=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2_contra=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2_contra=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_eyes_contra=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_mouth_contra=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_face_contra=NaN;  
                else
                    fixation_m2_all_contra_duration=GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_contra_idx,14)-GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_contra_idx,13);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_number=length(fixation_m2_all_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_number_NaN=length(fixation_m2_all_contra_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_duration=fixation_m2_all_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_duration_NaN=fixation_m2_all_contra_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_totalduration=sum(fixation_m2_all_contra_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_totalduration_NaN=sum(fixation_m2_all_contra_duration)';
               
                    for n_m2_all=1:length(fixation_m2_all_contra_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_m2_all_contra_pupilsize(1,n_m2_all)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_contra_idx(n_m2_all),9): GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_contra_idx(n_m2_all),10)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2_contra(1,n_m2_all)=mean(GazeData.(field_id).(run_id).x_m2(GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_contra_idx(n_m2_all),9): GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_contra_idx(n_m2_all),10)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2_contra(1,n_m2_all)=mean(GazeData.(field_id).(run_id).y_m2(GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_contra_idx(n_m2_all),9): GazeData.(field_id).(run_id).m2_all.Var1(fixation_m2_all_contra_idx(n_m2_all),10)),'omitnan');
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_eyes_contra(1,n_m2_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2_contra(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_eyes(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2_contra(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_eyes(2)).^2);
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_mouth_contra(1,n_m2_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2_contra(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_mouth(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2_contra(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_mouth(2)).^2);
                    GazeMatrices.(field_id).(run_id).(stim_id).m2_distance_to_face_contra(1,n_m2_all)=sqrt((GazeMatrices.(field_id).(run_id).(stim_id).mean_x_m2_contra(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_face(1)).^2+(GazeMatrices.(field_id).(run_id).(stim_id).mean_y_m2_contra(1,n_m2_all)-GazeMatrices.(field_id).(run_id).center_roi_m2_face(2)).^2);
                   
                    end
    
                    clear n_m2_all
    
                end
    
                % SAME THING FOR MUTUAL
    
                % mutual eyes within 5s
                
                fixation_mutual_eye_idx=find(GazeData.(field_id).(run_id).mutual_eye.Var1(:,4)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).mutual_eye.Var1(:,4)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_mutual_eye_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_m1_pupilsize=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_m2_pupilsize=NaN;
                else
                    fixation_mutual_eye_duration=GazeData.(field_id).(run_id).mutual_eye.Var1(fixation_mutual_eye_idx,5)-GazeData.(field_id).(run_id).mutual_eye.Var1(fixation_mutual_eye_idx,4);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_number=length(fixation_mutual_eye_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_number_NaN=length(fixation_mutual_eye_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_duration=fixation_mutual_eye_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_duration_NaN=fixation_mutual_eye_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_totalduration=sum(fixation_mutual_eye_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_totalduration_NaN=sum(fixation_mutual_eye_duration)';
    
                    for n_mutual_eye=1:length(fixation_mutual_eye_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_m1_pupilsize(1,n_mutual_eye)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).mutual_eye.Var1(fixation_mutual_eye_idx(n_mutual_eye),1): GazeData.(field_id).(run_id).mutual_eye.Var1(fixation_mutual_eye_idx(n_mutual_eye),2)),'omitnan');
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_eye_m2_pupilsize(1,n_mutual_eye)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).mutual_eye.Var1(fixation_mutual_eye_idx(n_mutual_eye),1): GazeData.(field_id).(run_id).mutual_eye.Var1(fixation_mutual_eye_idx(n_mutual_eye),2)),'omitnan');
                    end
    
                    clear n_mutual_eye
    
                end               
    
                % mutual mouth within 5s
                
                fixation_mutual_mouth_idx=find(GazeData.(field_id).(run_id).mutual_mouth.Var1(:,4)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).mutual_mouth.Var1(:,4)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_mutual_mouth_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_m1_pupilsize=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_m2_pupilsize=NaN;
                else
                    fixation_mutual_mouth_duration=GazeData.(field_id).(run_id).mutual_mouth.Var1(fixation_mutual_mouth_idx,5)-GazeData.(field_id).(run_id).mutual_mouth.Var1(fixation_mutual_mouth_idx,4);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_number=length(fixation_mutual_mouth_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_number_NaN=length(fixation_mutual_mouth_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_duration=fixation_mutual_mouth_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_duration_NaN=fixation_mutual_mouth_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_totalduration=sum(fixation_mutual_mouth_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_totalduration_NaN=sum(fixation_mutual_mouth_duration)';
    
                    for n_mutual_mouth=1:length(fixation_mutual_mouth_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_m1_pupilsize(1,n_mutual_mouth)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).mutual_mouth.Var1(fixation_mutual_mouth_idx(n_mutual_mouth),1): GazeData.(field_id).(run_id).mutual_mouth.Var1(fixation_mutual_mouth_idx(n_mutual_mouth),2)),'omitnan');
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_mouth_m2_pupilsize(1,n_mutual_mouth)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).mutual_mouth.Var1(fixation_mutual_mouth_idx(n_mutual_mouth),1): GazeData.(field_id).(run_id).mutual_mouth.Var1(fixation_mutual_mouth_idx(n_mutual_mouth),2)),'omitnan');
                    end
    
                    clear n_mutual_mouth
    
                end
    
                % mutual face within 5s
                
                fixation_mutual_face_idx=find(GazeData.(field_id).(run_id).mutual_face.Var1(:,4)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).mutual_face.Var1(:,4)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_mutual_face_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_m1_pupilsize=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_m2_pupilsize=NaN;
                else
                    fixation_mutual_face_duration=GazeData.(field_id).(run_id).mutual_face.Var1(fixation_mutual_face_idx,5)-GazeData.(field_id).(run_id).mutual_face.Var1(fixation_mutual_face_idx,4);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_number=length(fixation_mutual_face_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_number_NaN=length(fixation_mutual_face_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_duration=fixation_mutual_face_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_duration_NaN=fixation_mutual_face_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_totalduration=sum(fixation_mutual_face_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_totalduration_NaN=sum(fixation_mutual_face_duration)';
    
                    for n_mutual_face=1:length(fixation_mutual_face_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_m1_pupilsize(1,n_mutual_face)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).mutual_face.Var1(fixation_mutual_face_idx(n_mutual_face),1): GazeData.(field_id).(run_id).mutual_face.Var1(fixation_mutual_face_idx(n_mutual_face),2)),'omitnan');
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_face_m2_pupilsize(1,n_mutual_face)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).mutual_face.Var1(fixation_mutual_face_idx(n_mutual_face),1): GazeData.(field_id).(run_id).mutual_face.Var1(fixation_mutual_face_idx(n_mutual_face),2)),'omitnan');
                    end
    
                    clear n_mutual_face
    
                end
    
                % mutual wholeface within 5s
                
                fixation_mutual_wholeface_idx=find(GazeData.(field_id).(run_id).mutual_wholeface.Var1(:,4)>=stim_ts(nstim)+look_back & GazeData.(field_id).(run_id).mutual_wholeface.Var1(:,4)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_mutual_wholeface_idx)
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_number=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_number_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_duration(1,:)=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_duration_NaN(1,:)=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_totalduration=0;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_totalduration_NaN=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_m1_pupilsize=NaN;
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_m2_pupilsize=NaN;
                else
                    fixation_mutual_wholeface_duration=GazeData.(field_id).(run_id).mutual_wholeface.Var1(fixation_mutual_wholeface_idx,5)-GazeData.(field_id).(run_id).mutual_wholeface.Var1(fixation_mutual_wholeface_idx,4);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_number=length(fixation_mutual_wholeface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_number_NaN=length(fixation_mutual_wholeface_duration);
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_duration=fixation_mutual_wholeface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_duration_NaN=fixation_mutual_wholeface_duration';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_totalduration=sum(fixation_mutual_wholeface_duration)';
                    GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_totalduration_NaN=sum(fixation_mutual_wholeface_duration)';
    
                    for n_mutual_wholeface=1:length(fixation_mutual_wholeface_idx)
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_m1_pupilsize(1,n_mutual_wholeface)=mean(GazeData.(field_id).(run_id).pupil_m1(GazeData.(field_id).(run_id).mutual_wholeface.Var1(fixation_mutual_wholeface_idx(n_mutual_wholeface),1): GazeData.(field_id).(run_id).mutual_wholeface.Var1(fixation_mutual_wholeface_idx(n_mutual_wholeface),2)),'omitnan');
                        GazeMatrices.(field_id).(run_id).(stim_id).fixation_mutual_wholeface_m2_pupilsize(1,n_mutual_wholeface)=mean(GazeData.(field_id).(run_id).pupil_m2(GazeData.(field_id).(run_id).mutual_wholeface.Var1(fixation_mutual_wholeface_idx(n_mutual_wholeface),1): GazeData.(field_id).(run_id).mutual_wholeface.Var1(fixation_mutual_wholeface_idx(n_mutual_wholeface),2)),'omitnan');
                    end
    
                    clear n_mutual_wholeface
    
                end
    
                end
    
                clear stim_id  
                clear fixation_m1_eye_idx fixation_m1_eye_duration fixation_m1_mouth_idx fixation_m1_mouth_duration 
                clear fixation_m1_eye_ipsi_idx fixation_m1_eye_ipsi_duration fixation_m1_mouth_ipsi_idx fixation_m1_mouth_ipsi_duration 
                clear fixation_m1_eye_contra_idx fixation_m1_eye_contra_duration fixation_m1_mouth_contra_idx fixation_m1_mouth_contra_duration 

                clear fixation_m1_nenmface_idx fixation_m1_nenmface_duration fixation_m1_everywhere_idx fixation_m1_everwhere_duration 
                clear fixation_m1_nenmface_ipsi_idx fixation_m1_nenmface_ipsi_duration fixation_m1_everywhere_ipsi_idx fixation_m1_everwhere_ipsi_duration 
                clear fixation_m1_nenmface_contra_idx fixation_m1_nenmface_contra_duration fixation_m1_everywhere_contra_idx fixation_m1_everwhere_contra_duration 

                clear fixation_m1_neface_idx fixation_m1_neface_duration  fixation_m1_wholeface_idx fixation_m1_wholeface_duration fixation_m1_all_idx fixation_m1_all_duration
                clear fixation_m1_neface_ipsi_idx fixation_m1_neface_ipsi_duration  fixation_m1_wholeface_ipsi_idx fixation_m1_wholeface_ipsi_duration fixation_m1_all_ipsi_idx fixation_m1_all_ipsi_duration
                clear fixation_m1_neface_contra_idx fixation_m1_neface_contra_duration  fixation_m1_wholeface_contra_idx fixation_m1_wholeface_contra_duration fixation_m1_all_contra_idx fixation_m1_all_contra_duration
                
                clear fixation_m2_eye_idx fixation_m2_eye_duration fixation_m2_mouth_idx fixation_m2_mouth_duration 
                clear fixation_m2_eye_ipsi_idx fixation_m2_eye_ipsi_duration fixation_m2_mouth_ipsi_idx fixation_m2_mouth_ipsi_duration 
                clear fixation_m2_eye_contra_idx fixation_m2_eye_contra_duration fixation_m2_mouth_contra_idx fixation_m2_mouth_contra_duration 
                
                clear fixation_m2_nenmface_idx fixation_m2_nenmface_duration fixation_m2_everywhere_idx fixation_m2_everwhere_duration 
                clear fixation_m2_nenmface_ipsi_idx fixation_m2_nenmface_ipsi_duration fixation_m2_everywhere_ipsi_idx fixation_m2_everwhere_ipsi_duration 
                clear fixation_m2_nenmface_contra_idx fixation_m2_nenmface_contra_duration fixation_m2_everywhere_contra_idx fixation_m2_everwhere_contra_duration 
                
                clear fixation_m2_neface_idx fixation_m2_neface_duration  fixation_m2_wholeface_idx fixation_m2_wholeface_duration fixation_m2_all_idx fixation_m2_all_duration
                clear fixation_m2_neface_ipsi_idx fixation_m2_neface_ipsi_duration  fixation_m2_wholeface_ipsi_idx fixation_m2_wholeface_ipsi_duration fixation_m2_all_ipsi_idx fixation_m2_all_ipsi_duration
                clear fixation_m2_neface_contra_idx fixation_m2_neface_contra_duration  fixation_m2_wholeface_contra_idx fixation_m2_wholeface_contra_duration fixation_m2_all_contra_idx fixation_m2_all_contra_duration
                
                clear fixation_mutual_eye_idx fixation_mutual_eye_duration fixation_mutual_mouth_idx fixation_mutual_mouth_duration 
                clear fixation_mutual_face_idx fixation_mutual_face_duration fixation_mutual_wholeface_idx fixation_mutual_wholeface_duration 
                
            end
            
                clear run_id nstim stim_ts

        end
        
        clear l field_id field_run
        
    end

end