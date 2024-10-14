%% Calculate the number of events/average duration of events

% Upload Dot_Data_Combined.mat and 
ROI_list={'m1_eye','m1_neface','m1_mouth','m1_nenmface'};
fieldname=fieldnames(DotData);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
    field_run=fieldnames(DotData.(field_id));
    
    % column 7 is m1 start index; column 8 is m1 end index
    % column 9 is m2 start index; column 10 is m2 end index
    % column 11 is m1 start time; column 12 is m1 end time
    % column 13 is m2 start time; column 14 is m2 end time

    for l=1:size(field_run,1)
        run_id=char(field_run(l));

        for nROI=1:4
            ROI_id=char(ROI_list(nROI));
            Dot.(field_id).(run_id).(ROI_id).number=size(DotData.(field_id).(run_id).(ROI_id),1);
            Dot.(field_id).(run_id).(ROI_id).duration=DotData.(field_id).(run_id).(ROI_id).Var1(:,12)-DotData.(field_id).(run_id).(ROI_id).Var1(:,11);
        end

    end

end

save('Dot_ROI_Run_Combined.mat','Dot','-v7.3')

%% Put information together for each day 

ROI_list={'m1_eye','m1_neface','m1_mouth','m1_nenmface'};
fieldname=fieldnames(Dot);

for k=1:size(fieldname,1)
    
    field_id=char(fieldname(k));
    field_run=fieldnames(Dot.(field_id));

    for nROI=1:length(ROI_list)

    ROI_id=char(ROI_list(nROI));
    Dot_ROI.(field_id).(ROI_id).total_number=[];
    Dot_ROI.(field_id).(ROI_id).average_duration=[];
   
        for l=1:size(field_run,1)
        
            run_id=char(field_run(l));
            Dot_ROI.(field_id).(ROI_id).total_number=[Dot_ROI.(field_id).(ROI_id).total_number Dot.(field_id).(run_id).(ROI_id).number];
            Dot_ROI.(field_id).(ROI_id).average_duration=[Dot_ROI.(field_id).(ROI_id).average_duration mean(Dot.(field_id).(run_id).(ROI_id).duration,'omitnan')];
    
        end

    end

end

save('Dot_ROI_Day_Combined.mat','Dot_ROI','-v7.3')

%% Calculate the total number and average fixation for each type of gaze events

ROI_list={'m1_eye','m1_neface','m1_mouth','m1_nenmface'};
fieldname=fieldnames(Dot_ROI);

for k=1:size(fieldname,1)
    
    field_id=char(fieldname(k));

    for nROI=1:length(ROI_list)

        ROI_id=char(ROI_list(nROI));
        Dot_table.(field_id).(ROI_id).total_number=mean(Dot_ROI.(field_id).(ROI_id).total_number,'omitnan');
        Dot_table.(field_id).(ROI_id).average_duration=mean(Dot_ROI.(field_id).(ROI_id).average_duration,'omitnan');

    end

end

save('Dot_ROI_Table_Combined.mat','Dot_table','-v7.3')

