%% Upload Dot_Data_Combined.mat

%% Specify time window

% look_back is negative and look_ahead is positive

% DotMatrices = basic_gaze_matrices( DotData, 0, 1.5 );
DotMatrices = basic_gaze_matrices( DotData, 0, 1.5);

% DotMatrices_bin1 = basic_gaze_matrices( DotData, 0, 1 );
% DotMatrices_bin2 = basic_gaze_matrices( DotData, 0.5, 1.5 );
% DotMatrices_bin3 = basic_gaze_matrices( DotData, 1, 2 );
% DotMatrices_bin4 = basic_gaze_matrices( DotData, 1.5, 2.5 );
% DotMatrices_bin5 = basic_gaze_matrices( DotData, 2, 3 );
% DotMatrices_bin6 = basic_gaze_matrices( DotData, 2.5, 3.5 );
% DotMatrices_bin7 = basic_gaze_matrices( DotData, 3, 4 );
% DotMatrices_bin8 = basic_gaze_matrices( DotData, 3.5, 4.5 );
% DotMatrices_bin9 = basic_gaze_matrices( DotData, 4, 5 );

%save('Dot_Matrices_Combined_0_15.mat','DotMatrices','-v7.3')
save('Dot_Matrices_Combined_0_15.mat','DotMatrices','-v7.3')

% save('Dot_Matrices_bin1_Lynch.mat','DotMatrices_bin1','-v7.3')
% save('Dot_Matrices_bin2_Lynch.mat','DotMatrices_bin2','-v7.3')
% save('Dot_Matrices_bin3_Lynch.mat','DotMatrices_bin3','-v7.3')
% save('Dot_Matrices_bin4_Lynch.mat','DotMatrices_bin4','-v7.3')
% save('Dot_Matrices_bin5_Lynch.mat','DotMatrices_bin5','-v7.3')
% save('Dot_Matrices_bin6_Lynch.mat','DotMatrices_bin6','-v7.3')
% save('Dot_Matrices_bin7_Lynch.mat','DotMatrices_bin7','-v7.3')
% save('Dot_Matrices_bin8_Lynch.mat','DotMatrices_bin8','-v7.3')
% save('Dot_Matrices_bin9_Lynch.mat','DotMatrices_bin9','-v7.3')

%% Calculate the basic gaze metrices within [look_back, look_ahead] aligned to each stim/sham (exclude stim/sham that happens within 5sec from the end of a run)

% total number, average duration, and total duration of different events 
% pupil size and average distance during different events

function DotMatrices = basic_gaze_matrices(DotData, look_back, look_ahead) 

fieldname=fieldnames(DotData);

    for k=1:size(fieldname,1)
        field_id=char(fieldname(k));    
        field_run=fieldnames(DotData.(field_id));
        
        for l=1:size(field_run,1)
            run_id=char(field_run(l));
            
            % get ROI info
            DotMatrices.(field_id).(run_id).roi_m1_eyes=DotData.(field_id).(run_id).roi_m1_eyes;
            DotMatrices.(field_id).(run_id).roi_m2_eyes=DotData.(field_id).(run_id).roi_m2_eyes;
            DotMatrices.(field_id).(run_id).roi_m1_face=DotData.(field_id).(run_id).roi_m1_face;
            DotMatrices.(field_id).(run_id).roi_m2_face=DotData.(field_id).(run_id).roi_m2_face;
            DotMatrices.(field_id).(run_id).roi_m1_mouth=DotData.(field_id).(run_id).roi_m1_mouth;
            DotMatrices.(field_id).(run_id).roi_m2_mouth=DotData.(field_id).(run_id).roi_m2_mouth;
    
            DotMatrices.(field_id).(run_id).center_roi_m1_eyes=DotData.(field_id).(run_id).center_roi_m1_eyes;
            DotMatrices.(field_id).(run_id).center_roi_m2_eyes=DotData.(field_id).(run_id).center_roi_m2_eyes;
            DotMatrices.(field_id).(run_id).center_roi_m1_face=DotData.(field_id).(run_id).center_roi_m1_face;
            DotMatrices.(field_id).(run_id).center_roi_m2_face=DotData.(field_id).(run_id).center_roi_m2_face;
            DotMatrices.(field_id).(run_id).center_roi_m1_mouth=DotData.(field_id).(run_id).center_roi_m1_mouth;
            DotMatrices.(field_id).(run_id).center_roi_m2_mouth=DotData.(field_id).(run_id).center_roi_m2_mouth;
    
            DotMatrices.(field_id).(run_id).current_label=[];
            DotMatrices.(field_id).(run_id).stim_time=[];
            stim_ts=DotData.(field_id).(run_id).stim_ts;
            
            for nstim=1:length(stim_ts)        
                stim_id=char(strcat('stim_',num2str(nstim)));
    
                if DotData.(field_id).(run_id).stim_ts(nstim) >= min(DotData.(field_id).(run_id).t) && DotData.(field_id).(run_id).stim_ts(nstim) < max(DotData.(field_id).(run_id).t)-5
                
                % column 7 is m1 start index; column 8 is m1 end index
                % column 9 is m2 start index; column 10 is m2 end index
                % column 11 is m1 start time; column 12 is m1 end time
                % column 13 is m2 start time; column 14 is m2 end time

                DotMatrices.(field_id).(run_id).current_label=vertcat(DotMatrices.(field_id).(run_id).current_label, DotData.(field_id).(run_id).all_stim_labels{nstim,1});
                DotMatrices.(field_id).(run_id).stim_time=vertcat(DotMatrices.(field_id).(run_id).stim_time, DotData.(field_id).(run_id).stim_ts(nstim,1));
                               
                % exclusive m1 eyes within 5s
                
                fixation_m1_eye_idx=find(DotData.(field_id).(run_id).m1_eye.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_eye.Var1(:,11)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m1_eye_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_pupilsize=NaN;                    
                else
                    fixation_m1_eye_duration=DotData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_idx,12)-DotData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_number=length(fixation_m1_eye_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_number_NaN=length(fixation_m1_eye_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_duration=fixation_m1_eye_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_duration_NaN=fixation_m1_eye_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_totalduration=sum(fixation_m1_eye_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_totalduration_NaN=sum(fixation_m1_eye_duration)';
    
                    for n_m1_eye=1:length(fixation_m1_eye_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_pupilsize(1,n_m1_eye)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_idx(n_m1_eye),7): DotData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_idx(n_m1_eye),8)),'omitnan');
                    end
    
                    clear n_m1_eye
    
                end

                fixation_m1_eye_ipsi_idx=find(DotData.(field_id).(run_id).m1_eye.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_eye.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_eye.Var2=='ipsi');
                
                if isempty(fixation_m1_eye_ipsi_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_pupilsize=NaN;                    
                else
                    fixation_m1_eye_ipsi_duration=DotData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_ipsi_idx,12)-DotData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_ipsi_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_number=length(fixation_m1_eye_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_number_NaN=length(fixation_m1_eye_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_duration=fixation_m1_eye_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_duration_NaN=fixation_m1_eye_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_totalduration=sum(fixation_m1_eye_ipsi_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_totalduration_NaN=sum(fixation_m1_eye_ipsi_duration)';
    
                    for n_m1_eye=1:length(fixation_m1_eye_ipsi_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_ipsi_pupilsize(1,n_m1_eye)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_ipsi_idx(n_m1_eye),7): DotData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_ipsi_idx(n_m1_eye),8)),'omitnan');
                    end
    
                    clear n_m1_eye
    
                end

                fixation_m1_eye_contra_idx=find(DotData.(field_id).(run_id).m1_eye.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_eye.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_eye.Var2=='contra');
                
                if isempty(fixation_m1_eye_contra_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_pupilsize=NaN;                    
                else
                    fixation_m1_eye_contra_duration=DotData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_contra_idx,12)-DotData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_contra_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_number=length(fixation_m1_eye_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_number_NaN=length(fixation_m1_eye_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_duration=fixation_m1_eye_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_duration_NaN=fixation_m1_eye_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_totalduration=sum(fixation_m1_eye_contra_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_totalduration_NaN=sum(fixation_m1_eye_contra_duration)';
    
                    for n_m1_eye=1:length(fixation_m1_eye_contra_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_eye_contra_pupilsize(1,n_m1_eye)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_contra_idx(n_m1_eye),7): DotData.(field_id).(run_id).m1_eye.Var1(fixation_m1_eye_contra_idx(n_m1_eye),8)),'omitnan');
                    end
    
                    clear n_m1_eye
    
                end
    
                % exclusive m1 mouth within 5s
                
                fixation_m1_mouth_idx=find(DotData.(field_id).(run_id).m1_mouth.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_mouth.Var1(:,11)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m1_mouth_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_pupilsize=NaN;                    
                else
                    fixation_m1_mouth_duration=DotData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_idx,12)-DotData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_number=length(fixation_m1_mouth_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_number_NaN=length(fixation_m1_mouth_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_duration=fixation_m1_mouth_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_duration_NaN=fixation_m1_mouth_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_totalduration=sum(fixation_m1_mouth_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_totalduration_NaN=sum(fixation_m1_mouth_duration)';
    
                    for n_m1_mouth=1:length(fixation_m1_mouth_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_pupilsize(1,n_m1_mouth)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_idx(n_m1_mouth),7): DotData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_idx(n_m1_mouth),8)),'omitnan');
                    end
    
                    clear n_m1_mouth
    
                end

                fixation_m1_mouth_ipsi_idx=find(DotData.(field_id).(run_id).m1_mouth.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_mouth.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_mouth.Var2=='ipsi');
                
                if isempty(fixation_m1_mouth_ipsi_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_pupilsize=NaN;                    
                else
                    fixation_m1_mouth_ipsi_duration=DotData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_ipsi_idx,12)-DotData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_ipsi_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_number=length(fixation_m1_mouth_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_number_NaN=length(fixation_m1_mouth_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_duration=fixation_m1_mouth_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_duration_NaN=fixation_m1_mouth_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_totalduration=sum(fixation_m1_mouth_ipsi_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_totalduration_NaN=sum(fixation_m1_mouth_ipsi_duration)';
    
                    for n_m1_mouth=1:length(fixation_m1_mouth_ipsi_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_ipsi_pupilsize(1,n_m1_mouth)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_ipsi_idx(n_m1_mouth),7): DotData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_ipsi_idx(n_m1_mouth),8)),'omitnan');
                    end
    
                    clear n_m1_mouth
    
                end

                fixation_m1_mouth_contra_idx=find(DotData.(field_id).(run_id).m1_mouth.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_mouth.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_mouth.Var2=='contra');
                
                if isempty(fixation_m1_mouth_contra_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_pupilsize=NaN;                    
                else
                    fixation_m1_mouth_contra_duration=DotData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_contra_idx,12)-DotData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_contra_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_number=length(fixation_m1_mouth_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_number_NaN=length(fixation_m1_mouth_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_duration=fixation_m1_mouth_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_duration_NaN=fixation_m1_mouth_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_totalduration=sum(fixation_m1_mouth_contra_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_totalduration_NaN=sum(fixation_m1_mouth_contra_duration)';
    
                    for n_m1_mouth=1:length(fixation_m1_mouth_contra_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_mouth_contra_pupilsize(1,n_m1_mouth)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_contra_idx(n_m1_mouth),7): DotData.(field_id).(run_id).m1_mouth.Var1(fixation_m1_mouth_contra_idx(n_m1_mouth),8)),'omitnan');
                    end
    
                    clear n_m1_mouth
    
                end
    
                % exclusive m1 non-eye, non-mouth face within 5s
                
                fixation_m1_nenmface_idx=find(DotData.(field_id).(run_id).m1_nenmface.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_nenmface.Var1(:,11)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m1_nenmface_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_pupilsize=NaN;                    
                else
                    fixation_m1_nenmface_duration=DotData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_idx,12)-DotData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_number=length(fixation_m1_nenmface_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_number_NaN=length(fixation_m1_nenmface_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_duration=fixation_m1_nenmface_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_duration_NaN=fixation_m1_nenmface_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_totalduration=sum(fixation_m1_nenmface_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_totalduration_NaN=sum(fixation_m1_nenmface_duration)';
    
                    for n_m1_nenmface=1:length(fixation_m1_nenmface_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_pupilsize(1,n_m1_nenmface)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_idx(n_m1_nenmface),7): DotData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_idx(n_m1_nenmface),8)),'omitnan');
                    end
    
                    clear n_m1_nenmface
    
                end

                fixation_m1_nenmface_ipsi_idx=find(DotData.(field_id).(run_id).m1_nenmface.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_nenmface.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_nenmface.Var2=='ipsi');
                
                if isempty(fixation_m1_nenmface_ipsi_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_pupilsize=NaN;                    
                else
                    fixation_m1_nenmface_ipsi_duration=DotData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_ipsi_idx,12)-DotData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_ipsi_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_number=length(fixation_m1_nenmface_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_number_NaN=length(fixation_m1_nenmface_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_duration=fixation_m1_nenmface_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_duration_NaN=fixation_m1_nenmface_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_totalduration=sum(fixation_m1_nenmface_ipsi_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_totalduration_NaN=sum(fixation_m1_nenmface_ipsi_duration)';
    
                    for n_m1_nenmface=1:length(fixation_m1_nenmface_ipsi_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_ipsi_pupilsize(1,n_m1_nenmface)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_ipsi_idx(n_m1_nenmface),7): DotData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_ipsi_idx(n_m1_nenmface),8)),'omitnan');
                    end
    
                    clear n_m1_nenmface
    
                end

                fixation_m1_nenmface_contra_idx=find(DotData.(field_id).(run_id).m1_nenmface.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_nenmface.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_nenmface.Var2=='contra');
                
                if isempty(fixation_m1_nenmface_contra_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_pupilsize=NaN;                    
                else
                    fixation_m1_nenmface_contra_duration=DotData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_contra_idx,12)-DotData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_contra_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_number=length(fixation_m1_nenmface_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_number_NaN=length(fixation_m1_nenmface_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_duration=fixation_m1_nenmface_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_duration_NaN=fixation_m1_nenmface_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_totalduration=sum(fixation_m1_nenmface_contra_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_totalduration_NaN=sum(fixation_m1_nenmface_contra_duration)';
    
                    for n_m1_nenmface=1:length(fixation_m1_nenmface_contra_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_nenmface_contra_pupilsize(1,n_m1_nenmface)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_contra_idx(n_m1_nenmface),7): DotData.(field_id).(run_id).m1_nenmface.Var1(fixation_m1_nenmface_contra_idx(n_m1_nenmface),8)),'omitnan');
                    end
    
                    clear n_m1_nenmface
    
                end
    
                % exclusive m1 everywhere within 5s
                
                fixation_m1_everywhere_idx=find(DotData.(field_id).(run_id).m1_everywhere.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_everywhere.Var1(:,11)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m1_everywhere_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_pupilsize=NaN;                    
                else
                    fixation_m1_everywhere_duration=DotData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_idx,12)-DotData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_number=length(fixation_m1_everywhere_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_number_NaN=length(fixation_m1_everywhere_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_duration=fixation_m1_everywhere_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_duration_NaN=fixation_m1_everywhere_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_totalduration=sum(fixation_m1_everywhere_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_totalduration_NaN=sum(fixation_m1_everywhere_duration)';
    
                    for n_m1_everywhere=1:length(fixation_m1_everywhere_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_pupilsize(1,n_m1_everywhere)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_idx(n_m1_everywhere),7): DotData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_idx(n_m1_everywhere),8)),'omitnan');
                    end
    
                    clear n_m1_everywhere
    
                end

                fixation_m1_everywhere_ipsi_idx=find(DotData.(field_id).(run_id).m1_everywhere.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_everywhere.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_everywhere.Var2=='ipsi');
                
                if isempty(fixation_m1_everywhere_ipsi_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_pupilsize=NaN;                    
                else
                    fixation_m1_everywhere_ipsi_duration=DotData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_ipsi_idx,12)-DotData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_ipsi_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_number=length(fixation_m1_everywhere_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_number_NaN=length(fixation_m1_everywhere_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_duration=fixation_m1_everywhere_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_duration_NaN=fixation_m1_everywhere_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_totalduration=sum(fixation_m1_everywhere_ipsi_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_totalduration_NaN=sum(fixation_m1_everywhere_ipsi_duration)';
    
                    for n_m1_everywhere=1:length(fixation_m1_everywhere_ipsi_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_ipsi_pupilsize(1,n_m1_everywhere)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_ipsi_idx(n_m1_everywhere),7): DotData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_ipsi_idx(n_m1_everywhere),8)),'omitnan');
                    end
    
                    clear n_m1_everywhere
    
                end

                fixation_m1_everywhere_contra_idx=find(DotData.(field_id).(run_id).m1_everywhere.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_everywhere.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_everywhere.Var2=='contra');
                
                if isempty(fixation_m1_everywhere_contra_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_pupilsize=NaN;                    
                else
                    fixation_m1_everywhere_contra_duration=DotData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_contra_idx,12)-DotData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_contra_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_number=length(fixation_m1_everywhere_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_number_NaN=length(fixation_m1_everywhere_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_duration=fixation_m1_everywhere_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_duration_NaN=fixation_m1_everywhere_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_totalduration=sum(fixation_m1_everywhere_contra_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_totalduration_NaN=sum(fixation_m1_everywhere_contra_duration)';
    
                    for n_m1_everywhere=1:length(fixation_m1_everywhere_contra_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_everywhere_contra_pupilsize(1,n_m1_everywhere)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_contra_idx(n_m1_everywhere),7): DotData.(field_id).(run_id).m1_everywhere.Var1(fixation_m1_everywhere_contra_idx(n_m1_everywhere),8)),'omitnan');
                    end
    
                    clear n_m1_everywhere
    
                end
    
                 % exclusive m1 non-eye face within 5s (mouth + face)
                
                fixation_m1_neface_idx=find(DotData.(field_id).(run_id).m1_neface.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_neface.Var1(:,11)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m1_neface_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_pupilsize=NaN;                    
                else
                    fixation_m1_neface_duration=DotData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_idx,12)-DotData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_number=length(fixation_m1_neface_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_number_NaN=length(fixation_m1_neface_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_duration=fixation_m1_neface_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_duration_NaN=fixation_m1_neface_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_totalduration=sum(fixation_m1_neface_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_totalduration_NaN=sum(fixation_m1_neface_duration)';
    
                    for n_m1_neface=1:length(fixation_m1_neface_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_pupilsize(1,n_m1_neface)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_idx(n_m1_neface),7): DotData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_idx(n_m1_neface),8)),'omitnan');
                    end
    
                    clear n_m1_neface
    
                end

                fixation_m1_neface_ipsi_idx=find(DotData.(field_id).(run_id).m1_neface.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_neface.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_neface.Var2=='ipsi');
                
                if isempty(fixation_m1_neface_ipsi_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_pupilsize=NaN;                    
                else
                    fixation_m1_neface_ipsi_duration=DotData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_ipsi_idx,12)-DotData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_ipsi_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_number=length(fixation_m1_neface_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_number_NaN=length(fixation_m1_neface_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_duration=fixation_m1_neface_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_duration_NaN=fixation_m1_neface_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_totalduration=sum(fixation_m1_neface_ipsi_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_totalduration_NaN=sum(fixation_m1_neface_ipsi_duration)';
    
                    for n_m1_neface=1:length(fixation_m1_neface_ipsi_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_ipsi_pupilsize(1,n_m1_neface)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_ipsi_idx(n_m1_neface),7): DotData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_ipsi_idx(n_m1_neface),8)),'omitnan');
                    end
    
                    clear n_m1_neface
    
                end

                fixation_m1_neface_contra_idx=find(DotData.(field_id).(run_id).m1_neface.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_neface.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_neface.Var2=='contra');
                
                if isempty(fixation_m1_neface_contra_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_pupilsize=NaN;                    
                else
                    fixation_m1_neface_contra_duration=DotData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_contra_idx,12)-DotData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_contra_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_number=length(fixation_m1_neface_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_number_NaN=length(fixation_m1_neface_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_duration=fixation_m1_neface_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_duration_NaN=fixation_m1_neface_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_totalduration=sum(fixation_m1_neface_contra_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_totalduration_NaN=sum(fixation_m1_neface_contra_duration)';
    
                    for n_m1_neface=1:length(fixation_m1_neface_contra_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_neface_contra_pupilsize(1,n_m1_neface)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_contra_idx(n_m1_neface),7): DotData.(field_id).(run_id).m1_neface.Var1(fixation_m1_neface_contra_idx(n_m1_neface),8)),'omitnan');
                    end
    
                    clear n_m1_neface
    
                end
    
                % exclusive m1 whole face within 5s (eye + mouth + face)
                
                fixation_m1_wholeface_idx=find(DotData.(field_id).(run_id).m1_wholeface.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_wholeface.Var1(:,11)<stim_ts(nstim)+look_ahead);
                
                if isempty(fixation_m1_wholeface_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_pupilsize=NaN;                    
                else
                    fixation_m1_wholeface_duration=DotData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_idx,12)-DotData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_number=length(fixation_m1_wholeface_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_number_NaN=length(fixation_m1_wholeface_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_duration=fixation_m1_wholeface_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_duration_NaN=fixation_m1_wholeface_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_totalduration=sum(fixation_m1_wholeface_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_totalduration_NaN=sum(fixation_m1_wholeface_duration)';
    
                    for n_m1_wholeface=1:length(fixation_m1_wholeface_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_pupilsize(1,n_m1_wholeface)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_idx(n_m1_wholeface),7): DotData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_idx(n_m1_wholeface),8)),'omitnan');
                    end
    
                    clear n_m1_wholeface
    
                end

                fixation_m1_wholeface_ipsi_idx=find(DotData.(field_id).(run_id).m1_wholeface.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_wholeface.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_wholeface.Var2=='ipsi');
                
                if isempty(fixation_m1_wholeface_ipsi_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_pupilsize=NaN;                    
                else
                    fixation_m1_wholeface_ipsi_duration=DotData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_ipsi_idx,12)-DotData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_ipsi_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_number=length(fixation_m1_wholeface_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_number_NaN=length(fixation_m1_wholeface_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_duration=fixation_m1_wholeface_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_duration_NaN=fixation_m1_wholeface_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_totalduration=sum(fixation_m1_wholeface_ipsi_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_totalduration_NaN=sum(fixation_m1_wholeface_ipsi_duration)';
    
                    for n_m1_wholeface=1:length(fixation_m1_wholeface_ipsi_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_ipsi_pupilsize(1,n_m1_wholeface)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_ipsi_idx(n_m1_wholeface),7): DotData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_ipsi_idx(n_m1_wholeface),8)),'omitnan');
                    end
    
                    clear n_m1_wholeface
    
                end

                fixation_m1_wholeface_contra_idx=find(DotData.(field_id).(run_id).m1_wholeface.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_wholeface.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_wholeface.Var2=='contra');
                
                if isempty(fixation_m1_wholeface_contra_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_totalduration_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_pupilsize=NaN;                    
                else
                    fixation_m1_wholeface_contra_duration=DotData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_contra_idx,12)-DotData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_contra_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_number=length(fixation_m1_wholeface_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_number_NaN=length(fixation_m1_wholeface_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_duration=fixation_m1_wholeface_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_duration_NaN=fixation_m1_wholeface_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_totalduration=sum(fixation_m1_wholeface_contra_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_totalduration_NaN=sum(fixation_m1_wholeface_contra_duration)';
    
                    for n_m1_wholeface=1:length(fixation_m1_wholeface_contra_idx)
                        DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_wholeface_contra_pupilsize(1,n_m1_wholeface)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_contra_idx(n_m1_wholeface),7): DotData.(field_id).(run_id).m1_wholeface.Var1(fixation_m1_wholeface_contra_idx(n_m1_wholeface),8)),'omitnan');
                    end
    
                    clear n_m1_wholeface
    
                end
    
                % exclusive m1 all within 5s (eye + mouth + face + everywhere)
                
                fixation_m1_all_idx=find(DotData.(field_id).(run_id).m1_all.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_all.Var1(:,11)<stim_ts(nstim)+look_ahead);

                if isempty(fixation_m1_all_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_totalduration_NaN=NaN;
                    
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_pupilsize=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_mouth=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_face=NaN;  
                else
                    fixation_m1_all_duration=DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx,12)-DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_number=length(fixation_m1_all_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_number_NaN=length(fixation_m1_all_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_duration=fixation_m1_all_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_duration_NaN=fixation_m1_all_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_totalduration=sum(fixation_m1_all_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_totalduration_NaN=sum(fixation_m1_all_duration)';
               
                    for n_m1_all=1:length(fixation_m1_all_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_pupilsize(1,n_m1_all)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx(n_m1_all),7): DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx(n_m1_all),8)),'omitnan');
                    DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1(1,n_m1_all)=mean(DotData.(field_id).(run_id).x_m1(DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx(n_m1_all),7): DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx(n_m1_all),8)),'omitnan');
                    DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1(1,n_m1_all)=mean(DotData.(field_id).(run_id).y_m1(DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx(n_m1_all),7): DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_idx(n_m1_all),8)),'omitnan');
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes(1,n_m1_all)=sqrt((DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_eyes(1)).^2+(DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_eyes(2)).^2);
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_mouth(1,n_m1_all)=sqrt((DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_mouth(1)).^2+(DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_mouth(2)).^2);
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_face(1,n_m1_all)=sqrt((DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_face(1)).^2+(DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_face(2)).^2);
                   
                    end
    
                    clear n_m1_all
    
                end

                fixation_m1_all_ipsi_idx=find(DotData.(field_id).(run_id).m1_all.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_all.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_all.Var2=='ipsi');
                
                if isempty(fixation_m1_all_ipsi_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_totalduration_NaN=NaN;
                    
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_pupilsize=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1_ipsi=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1_ipsi=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes_ipsi=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_mouth_ipsi=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_face_ipsi=NaN;  
                else
                    fixation_m1_all_ipsi_duration=DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx,12)-DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_number=length(fixation_m1_all_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_number_NaN=length(fixation_m1_all_ipsi_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_duration=fixation_m1_all_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_duration_NaN=fixation_m1_all_ipsi_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_totalduration=sum(fixation_m1_all_ipsi_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_totalduration_NaN=sum(fixation_m1_all_ipsi_duration)';
               
                    for n_m1_all=1:length(fixation_m1_all_ipsi_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_ipsi_pupilsize(1,n_m1_all)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx(n_m1_all),7): DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx(n_m1_all),8)),'omitnan');
                    DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1_ipsi(1,n_m1_all)=mean(DotData.(field_id).(run_id).x_m1(DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx(n_m1_all),7): DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx(n_m1_all),8)),'omitnan');
                    DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1_ipsi(1,n_m1_all)=mean(DotData.(field_id).(run_id).y_m1(DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx(n_m1_all),7): DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_ipsi_idx(n_m1_all),8)),'omitnan');
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes_ipsi(1,n_m1_all)=sqrt((DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1_ipsi(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_eyes(1)).^2+(DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1_ipsi(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_eyes(2)).^2);
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_mouth_ipsi(1,n_m1_all)=sqrt((DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1_ipsi(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_mouth(1)).^2+(DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1_ipsi(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_mouth(2)).^2);
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_face_ipsi(1,n_m1_all)=sqrt((DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1_ipsi(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_face(1)).^2+(DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1_ipsi(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_face(2)).^2);
                   
                    end
    
                    clear n_m1_all
    
                end

                fixation_m1_all_contra_idx=find(DotData.(field_id).(run_id).m1_all.Var1(:,11)>=stim_ts(nstim)+look_back & DotData.(field_id).(run_id).m1_all.Var1(:,11)<stim_ts(nstim)+look_ahead & DotData.(field_id).(run_id).m1_all.Var2=='contra');
                
                if isempty(fixation_m1_all_contra_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_number=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_number_NaN=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_duration(1,:)=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_duration_NaN(1,:)=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_totalduration=0;
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_totalduration_NaN=NaN;
                    
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_pupilsize=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1_contra=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1_contra=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes_contra=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_mouth_contra=NaN;
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_face_contra=NaN;  
                else
                    fixation_m1_all_contra_duration=DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx,12)-DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx,11);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_number=length(fixation_m1_all_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_number_NaN=length(fixation_m1_all_contra_duration);
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_duration=fixation_m1_all_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_duration_NaN=fixation_m1_all_contra_duration';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_totalduration=sum(fixation_m1_all_contra_duration)';
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_totalduration_NaN=sum(fixation_m1_all_contra_duration)';
               
                    for n_m1_all=1:length(fixation_m1_all_contra_idx)
                    DotMatrices.(field_id).(run_id).(stim_id).fixation_m1_all_contra_pupilsize(1,n_m1_all)=mean(DotData.(field_id).(run_id).pupil_m1(DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx(n_m1_all),7): DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx(n_m1_all),8)),'omitnan');
                    DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1_contra(1,n_m1_all)=mean(DotData.(field_id).(run_id).x_m1(DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx(n_m1_all),7): DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx(n_m1_all),8)),'omitnan');
                    DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1_contra(1,n_m1_all)=mean(DotData.(field_id).(run_id).y_m1(DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx(n_m1_all),7): DotData.(field_id).(run_id).m1_all.Var1(fixation_m1_all_contra_idx(n_m1_all),8)),'omitnan');
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes_contra(1,n_m1_all)=sqrt((DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1_contra(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_eyes(1)).^2+(DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1_contra(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_eyes(2)).^2);
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_mouth_contra(1,n_m1_all)=sqrt((DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1_contra(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_mouth(1)).^2+(DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1_contra(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_mouth(2)).^2);
                    DotMatrices.(field_id).(run_id).(stim_id).m1_distance_to_face_contra(1,n_m1_all)=sqrt((DotMatrices.(field_id).(run_id).(stim_id).mean_x_m1_contra(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_face(1)).^2+(DotMatrices.(field_id).(run_id).(stim_id).mean_y_m1_contra(1,n_m1_all)-DotMatrices.(field_id).(run_id).center_roi_m1_face(2)).^2);
                   
                    end
    
                    clear n_m1_all
    
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
                       
            end
            
                clear run_id nstim stim_ts

        end
        
        clear l field_id field_run
        
    end

end