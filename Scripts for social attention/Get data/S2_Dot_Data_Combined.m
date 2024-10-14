%% upload Dot_Data.mat and combine two monkeys

fieldname_Lynch=fieldnames(Lynch);
fieldname_Tarantino=fieldnames(Tarantino);

for nday_Lynch=1:size(fieldname_Lynch,1)

    field_id_Lynch=char(fieldname_Lynch(nday_Lynch));
    
    DotData.(field_id_Lynch)=Lynch.(field_id_Lynch);

end

for nday_Tarantino= 1:size(fieldname_Tarantino,1)

    field_id_Tarantino=char(fieldname_Tarantino(nday_Tarantino));
    
    DotData.(field_id_Tarantino)=Tarantino.(field_id_Tarantino);

end

%% Flip ipsi and contra for ACCg because we always recorded from the opposite hemisphere relative to the chamber.

DotData_updated=DotData;

ACCg_day.All={'07222019'  '08022019'  '08072019'  '08232019'  '09172019' ...
    '09242019'  '09282019'  '10102019'  '12092019'  '12132019' ...
    '01072020'  '01172020'  '01272020'  '01312020'  '02072020'...
    '11042021'  '12292021'  '01202022'  '01312022'  '02212022'...
    '03242022'  '04192022'  '04262022'  '05172022'  '05242022'...
    '05272022'  '05302022'};  

for k=1:size(ACCg_day.All,2)
    field_id=['data_' char(ACCg_day.All(k))];
    field_run=fieldnames(DotData.(field_id));
    
    for l=1:size(field_run,1)
        run_id=char(field_run(l));
        
        original_ipsi=find(DotData.(field_id).(run_id).event_info_m1.Var2(:)=='ipsi');
        original_contra=find(DotData.(field_id).(run_id).event_info_m1.Var2(:)=='contra');
        DotData_updated.(field_id).(run_id).event_info_m1.Var2(original_ipsi,:)=string('contra');
        DotData_updated.(field_id).(run_id).event_info_m1.Var2(original_contra,:)=string('ipsi');

    end

end

clear DotData

DotData=DotData_updated;
save('Dot_Data_Combined_Updated.mat','DotData','-v7.3')
