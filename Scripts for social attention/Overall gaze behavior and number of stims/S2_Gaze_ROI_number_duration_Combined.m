%% Calculate the number of events/average duration of events

% Upload Gaze_Data_Combined.mat
ROI_list={'m1_eye','m1_neface','m1_mouth','m1_nenmface','m2_eye','m2_neface','m2_mouth','m2_nenmface', 'mutual_eye','mutual_mouth','mutual_wholeface'};
fieldname=fieldnames(GazeData);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
    field_run=fieldnames(GazeData.(field_id));
    
    % column 7 is m1 start index; column 8 is m1 end index
    % column 9 is m2 start index; column 10 is m2 end index
    % column 11 is m1 start time; column 12 is m1 end time
    % column 13 is m2 start time; column 14 is m2 end time

    for l=1:size(field_run,1)
        run_id=char(field_run(l));

        for nROI=1:4
            ROI_id=char(ROI_list(nROI));
            Gaze.(field_id).(run_id).(ROI_id).number=size(GazeData.(field_id).(run_id).(ROI_id),1);
            Gaze.(field_id).(run_id).(ROI_id).duration=GazeData.(field_id).(run_id).(ROI_id).Var1(:,12)-GazeData.(field_id).(run_id).(ROI_id).Var1(:,11);
        end

        for nROI=5:8
            ROI_id=char(ROI_list(nROI));
            Gaze.(field_id).(run_id).(ROI_id).number=size(GazeData.(field_id).(run_id).(ROI_id),1);
            Gaze.(field_id).(run_id).(ROI_id).duration=GazeData.(field_id).(run_id).(ROI_id).Var1(:,14)-GazeData.(field_id).(run_id).(ROI_id).Var1(:,13);
        end

        for nROI=9:11
            ROI_id=char(ROI_list(nROI));
            Gaze.(field_id).(run_id).(ROI_id).number=size(GazeData.(field_id).(run_id).(ROI_id),1);
            Gaze.(field_id).(run_id).(ROI_id).duration=GazeData.(field_id).(run_id).(ROI_id).Var1(:,5)-GazeData.(field_id).(run_id).(ROI_id).Var1(:,4);
        end

    end

end

save('Gaze_ROI_Run_Combined.mat','Gaze','-v7.3')

%% Put information together for each day 

ROI_list={'m1_eye','m1_neface','m1_mouth','m1_nenmface','m2_eye','m2_neface','m2_mouth','m2_nenmface', 'mutual_eye','mutual_mouth','mutual_wholeface'};
fieldname=fieldnames(Gaze);

for k=1:size(fieldname,1)
    
    field_id=char(fieldname(k));
    field_run=fieldnames(Gaze.(field_id));

    for nROI=1:length(ROI_list)

    ROI_id=char(ROI_list(nROI));
    Gaze_ROI.(field_id).(ROI_id).total_number=[];
    Gaze_ROI.(field_id).(ROI_id).average_duration=[];
   
        for l=1:size(field_run,1)
        
            run_id=char(field_run(l));
            Gaze_ROI.(field_id).(ROI_id).total_number=[Gaze_ROI.(field_id).(ROI_id).total_number Gaze.(field_id).(run_id).(ROI_id).number];
            Gaze_ROI.(field_id).(ROI_id).average_duration=[Gaze_ROI.(field_id).(ROI_id).average_duration mean(Gaze.(field_id).(run_id).(ROI_id).duration,'omitnan')];
    
        end

    end

end

save('Gaze_ROI_Day_Combined.mat','Gaze_ROI','-v7.3')

%% Calculate the total number and average fixation for each type of gaze events

ROI_list={'m1_eye','m1_neface','m1_mouth','m1_nenmface','m2_eye','m2_neface','m2_mouth','m2_nenmface', 'mutual_eye','mutual_mouth','mutual_wholeface'};
fieldname=fieldnames(Gaze_ROI);

for k=1:size(fieldname,1)
    
    field_id=char(fieldname(k));

    for nROI=1:length(ROI_list)

        ROI_id=char(ROI_list(nROI));
        Gaze_table.(field_id).(ROI_id).total_number=mean(Gaze_ROI.(field_id).(ROI_id).total_number,'omitnan');
        Gaze_table.(field_id).(ROI_id).average_duration=mean(Gaze_ROI.(field_id).(ROI_id).average_duration,'omitnan');

    end

end

save('Gaze_ROI_Table_Combined.mat','Gaze_table','-v7.3')

