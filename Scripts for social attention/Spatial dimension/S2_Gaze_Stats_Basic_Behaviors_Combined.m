%% Variables and day information 

% All days
OFC_day.All={'07202019'  '07312019'  '08052019'  '08122019'  '08292019' ...
    '09052019'  '09192019'  '10012019'  '11052019'   '12122019' ...  
    '12182019'  '01032020'  '01102020'  '01242020'  '02022020'...
    '11082021'  '12222021'  '01032022'  '01212022'  '01282022'...
    '02032022'  '02092022'  '02152022'  '02192022'  '02242022'...
    '02282022'  '03172022'}; 

ACCg_day.All={'07222019'  '08022019'  '08072019'  '08232019'  '09172019' ...
    '09242019'  '09282019'  '10102019'  '12092019'  '12132019' ...
    '01072020'  '01172020'  '01272020'  '01312020'  '02072020'...
    '11042021'  '12292021'  '01202022'  '01312022'  '02212022'...
    '03242022'  '04192022'  '04262022'  '05172022'  '05242022'...
    '05272022'  '05302022'};  

dmPFC_day.All={'07182019','07262019'  '08092019'  '08142019'  '08212019' ...
    '09032019'  '09222019'  '10042019'  '12052019'  '12102019' ...
    '12162019'  '01022020'  '01132020'  '01222020'  '02062020'...
    '11052021'  '12172021'  '01242022'  '02122022'  '03052022'...
    '03182022'  '04012022'  '05032022'  '05122022'  '05142022'...
    '05192022'  '05262022'};  

% Lynch days
OFC_day.Lynch={'07202019'  '07312019'  '08052019'  '08122019'  '08292019' ...
    '09052019'  '09192019'  '10012019'  '11052019'   '12122019' ...  
    '12182019'  '01032020'  '01102020'  '01242020'  '02022020'};  
ACCg_day.Lynch={'07222019'  '08022019'  '08072019'  '08232019'  '09172019' ...
    '09242019'  '09282019'  '10102019'  '12092019'  '12132019' ...
    '01072020'  '01172020'  '01272020'  '01312020'  '02072020'};  
dmPFC_day.Lynch={'07182019','07262019'  '08092019'  '08142019'  '08212019' ...
    '09032019'  '09222019'  '10042019'  '12052019'  '12102019' ...
    '12162019'  '01022020'  '01132020'  '01222020'  '02062020'};            

% Tarantino days
OFC_day.Tarantino={'11082021'  '12222021'  '01032022'  '01212022'  '01282022'...
    '02032022'  '02092022'  '02152022'  '02192022'  '02242022'...
    '02282022'  '03172022'}; 
ACCg_day.Tarantino={'11042021'  '12292021'  '01202022'  '01312022'  '02212022'...
    '03242022'  '04192022'  '04262022'  '05172022'  '05242022'...
    '05272022'  '05302022'};  
dmPFC_day.Tarantino={'11052021'  '12172021'  '01242022'  '02122022'  '03052022'...
    '03182022'  '04012022'  '05032022'  '05122022'  '05142022'...
    '05192022'  '05262022'};  

Gaze_variables=fieldnames(Gaze_Day.data_01022020.current_sham);

%% Get Stats

for ngaze=1:length(Gaze_variables)

    gaze_variables=char(Gaze_variables(ngaze));
    monkey_names={'All', 'Lynch', 'Tarantino'};
    
    for nmonkey=1:3
        monkey_id=char(monkey_names(nmonkey));
        
        Sham_Sham.OFC.(gaze_variables).(monkey_id).mean=[];
        Sham_Stim.OFC.(gaze_variables).(monkey_id).mean=[];
        Stim_Sham.OFC.(gaze_variables).(monkey_id).mean=[];
        Stim_Stim.OFC.(gaze_variables).(monkey_id).mean=[];
        Current_Sham.OFC.(gaze_variables).(monkey_id).mean=[];
        Current_Stim.OFC.(gaze_variables).(monkey_id).mean=[];
    
        Sham_Sham.OFC.(gaze_variables).(monkey_id).median=[];
        Sham_Stim.OFC.(gaze_variables).(monkey_id).median=[];
        Stim_Sham.OFC.(gaze_variables).(monkey_id).median=[];
        Stim_Stim.OFC.(gaze_variables).(monkey_id).median=[];
        Current_Sham.OFC.(gaze_variables).(monkey_id).median=[];
        Current_Stim.OFC.(gaze_variables).(monkey_id).median=[];
    
        for nOFC=1:length(OFC_day.(monkey_id))
    
            field_id=char(strcat('data_',OFC_day.(monkey_id)(nOFC)));
    
            Sham_Sham.OFC.(gaze_variables).(monkey_id).mean=[Sham_Sham.OFC.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).sham_sham.(gaze_variables),'omitnan')];
            Sham_Stim.OFC.(gaze_variables).(monkey_id).mean=[Sham_Stim.OFC.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).sham_stim.(gaze_variables),'omitnan')];
            Stim_Sham.OFC.(gaze_variables).(monkey_id).mean=[Stim_Sham.OFC.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).stim_sham.(gaze_variables),'omitnan')];
            Stim_Stim.OFC.(gaze_variables).(monkey_id).mean=[Stim_Stim.OFC.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).stim_stim.(gaze_variables),'omitnan')];
    
            Current_Sham.OFC.(gaze_variables).(monkey_id).mean=[Current_Sham.OFC.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).current_sham.(gaze_variables),'omitnan')];
            Current_Stim.OFC.(gaze_variables).(monkey_id).mean=[Current_Stim.OFC.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).current_stim.(gaze_variables),'omitnan')];
             
            Sham_Sham.OFC.(gaze_variables).(monkey_id).median=[Sham_Sham.OFC.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).sham_sham.(gaze_variables),'omitnan')];
            Sham_Stim.OFC.(gaze_variables).(monkey_id).median=[Sham_Stim.OFC.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).sham_stim.(gaze_variables),'omitnan')];
            Stim_Sham.OFC.(gaze_variables).(monkey_id).median=[Stim_Sham.OFC.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).stim_sham.(gaze_variables),'omitnan')];
            Stim_Stim.OFC.(gaze_variables).(monkey_id).median=[Stim_Stim.OFC.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).stim_stim.(gaze_variables),'omitnan')];
    
            Current_Sham.OFC.(gaze_variables).(monkey_id).median=[Current_Sham.OFC.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).current_sham.(gaze_variables),'omitnan')];
            Current_Stim.OFC.(gaze_variables).(monkey_id).median=[Current_Stim.OFC.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).current_stim.(gaze_variables),'omitnan')];
                
        end
        
        Sham_Sham.ACCg.(gaze_variables).(monkey_id).mean=[];
        Sham_Stim.ACCg.(gaze_variables).(monkey_id).mean=[];
        Stim_Sham.ACCg.(gaze_variables).(monkey_id).mean=[];
        Stim_Stim.ACCg.(gaze_variables).(monkey_id).mean=[];
        Current_Sham.ACCg.(gaze_variables).(monkey_id).mean=[];
        Current_Stim.ACCg.(gaze_variables).(monkey_id).mean=[];
    
        Sham_Sham.ACCg.(gaze_variables).(monkey_id).median=[];
        Sham_Stim.ACCg.(gaze_variables).(monkey_id).median=[];
        Stim_Sham.ACCg.(gaze_variables).(monkey_id).median=[];
        Stim_Stim.ACCg.(gaze_variables).(monkey_id).median=[];
        Current_Sham.ACCg.(gaze_variables).(monkey_id).median=[];
        Current_Stim.ACCg.(gaze_variables).(monkey_id).median=[];
        
        for nACCg=1:length(ACCg_day.(monkey_id))
    
            field_id=char(strcat('data_',ACCg_day.(monkey_id)(nACCg)));
    
            Sham_Sham.ACCg.(gaze_variables).(monkey_id).mean=[Sham_Sham.ACCg.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).sham_sham.(gaze_variables),'omitnan')];
            Sham_Stim.ACCg.(gaze_variables).(monkey_id).mean=[Sham_Stim.ACCg.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).sham_stim.(gaze_variables),'omitnan')];
            Stim_Sham.ACCg.(gaze_variables).(monkey_id).mean=[Stim_Sham.ACCg.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).stim_sham.(gaze_variables),'omitnan')];
            Stim_Stim.ACCg.(gaze_variables).(monkey_id).mean=[Stim_Stim.ACCg.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).stim_stim.(gaze_variables),'omitnan')];
    
            Current_Sham.ACCg.(gaze_variables).(monkey_id).mean=[Current_Sham.ACCg.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).current_sham.(gaze_variables),'omitnan')];
            Current_Stim.ACCg.(gaze_variables).(monkey_id).mean=[Current_Stim.ACCg.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).current_stim.(gaze_variables),'omitnan')];
             
            Sham_Sham.ACCg.(gaze_variables).(monkey_id).median=[Sham_Sham.ACCg.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).sham_sham.(gaze_variables),'omitnan')];
            Sham_Stim.ACCg.(gaze_variables).(monkey_id).median=[Sham_Stim.ACCg.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).sham_stim.(gaze_variables),'omitnan')];
            Stim_Sham.ACCg.(gaze_variables).(monkey_id).median=[Stim_Sham.ACCg.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).stim_sham.(gaze_variables),'omitnan')];
            Stim_Stim.ACCg.(gaze_variables).(monkey_id).median=[Stim_Stim.ACCg.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).stim_stim.(gaze_variables),'omitnan')];
    
            Current_Sham.ACCg.(gaze_variables).(monkey_id).median=[Current_Sham.ACCg.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).current_sham.(gaze_variables),'omitnan')];
            Current_Stim.ACCg.(gaze_variables).(monkey_id).median=[Current_Stim.ACCg.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).current_stim.(gaze_variables),'omitnan')];
                    
        end
        
        Sham_Sham.dmPFC.(gaze_variables).(monkey_id).mean=[];
        Sham_Stim.dmPFC.(gaze_variables).(monkey_id).mean=[];
        Stim_Sham.dmPFC.(gaze_variables).(monkey_id).mean=[];
        Stim_Stim.dmPFC.(gaze_variables).(monkey_id).mean=[];
        Current_Sham.dmPFC.(gaze_variables).(monkey_id).mean=[];
        Current_Stim.dmPFC.(gaze_variables).(monkey_id).mean=[];
    
        Sham_Sham.dmPFC.(gaze_variables).(monkey_id).median=[];
        Sham_Stim.dmPFC.(gaze_variables).(monkey_id).median=[];
        Stim_Sham.dmPFC.(gaze_variables).(monkey_id).median=[];
        Stim_Stim.dmPFC.(gaze_variables).(monkey_id).median=[];
        Current_Sham.dmPFC.(gaze_variables).(monkey_id).median=[];
        Current_Stim.dmPFC.(gaze_variables).(monkey_id).median=[];
        
    
        for ndmPFC=1:length(dmPFC_day.(monkey_id))
    
            field_id=char(strcat('data_',dmPFC_day.(monkey_id)(ndmPFC)));
    
            Sham_Sham.dmPFC.(gaze_variables).(monkey_id).mean=[Sham_Sham.dmPFC.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).sham_sham.(gaze_variables),'omitnan')];
            Sham_Stim.dmPFC.(gaze_variables).(monkey_id).mean=[Sham_Stim.dmPFC.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).sham_stim.(gaze_variables),'omitnan')];
            Stim_Sham.dmPFC.(gaze_variables).(monkey_id).mean=[Stim_Sham.dmPFC.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).stim_sham.(gaze_variables),'omitnan')];
            Stim_Stim.dmPFC.(gaze_variables).(monkey_id).mean=[Stim_Stim.dmPFC.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).stim_stim.(gaze_variables),'omitnan')];
    
            Current_Sham.dmPFC.(gaze_variables).(monkey_id).mean=[Current_Sham.dmPFC.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).current_sham.(gaze_variables),'omitnan')];
            Current_Stim.dmPFC.(gaze_variables).(monkey_id).mean=[Current_Stim.dmPFC.(gaze_variables).(monkey_id).mean mean(Gaze_Day.(field_id).current_stim.(gaze_variables),'omitnan')];
             
            Sham_Sham.dmPFC.(gaze_variables).(monkey_id).median=[Sham_Sham.dmPFC.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).sham_sham.(gaze_variables),'omitnan')];
            Sham_Stim.dmPFC.(gaze_variables).(monkey_id).median=[Sham_Stim.dmPFC.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).sham_stim.(gaze_variables),'omitnan')];
            Stim_Sham.dmPFC.(gaze_variables).(monkey_id).median=[Stim_Sham.dmPFC.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).stim_sham.(gaze_variables),'omitnan')];
            Stim_Stim.dmPFC.(gaze_variables).(monkey_id).median=[Stim_Stim.dmPFC.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).stim_stim.(gaze_variables),'omitnan')];
    
            Current_Sham.dmPFC.(gaze_variables).(monkey_id).median=[Current_Sham.dmPFC.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).current_sham.(gaze_variables),'omitnan')];
            Current_Stim.dmPFC.(gaze_variables).(monkey_id).median=[Current_Stim.dmPFC.(gaze_variables).(monkey_id).median median(Gaze_Day.(field_id).current_stim.(gaze_variables),'omitnan')];
                  
        end

        stats_type={'mean','median'};
        %stats_type={'mean'};
    
        for n_type=1:length(stats_type)
            
            type_id=char(stats_type(n_type));
    
            % OFC
            if isequal(sum(~isnan(Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.OFC.current.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.OFC.current.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.OFC.current.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.OFC.current.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.OFC.current.(gaze_variables).(monkey_id).(type_id), Stats_median.h.OFC.current.(gaze_variables).(monkey_id).(type_id)] = signrank(Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id), Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.OFC.current.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.OFC.current.(gaze_variables).(monkey_id).(type_id)] = ttest(Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id), Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id));
            end
            
            % ACCg
            if isequal(sum(~isnan(Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.ACCg.current.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.ACCg.current.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.ACCg.current.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.ACCg.current.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.ACCg.current.(gaze_variables).(monkey_id).(type_id), Stats_median.h.ACCg.current.(gaze_variables).(monkey_id).(type_id)] = signrank(Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id), Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.ACCg.current.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.ACCg.current.(gaze_variables).(monkey_id).(type_id)] = ttest(Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id), Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id));
            end
            
            % dmPFC
            if isequal(sum(~isnan(Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.dmPFC.current.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.dmPFC.current.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.dmPFC.current.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.dmPFC.current.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.dmPFC.current.(gaze_variables).(monkey_id).(type_id), Stats_median.h.dmPFC.current.(gaze_variables).(monkey_id).(type_id)] = signrank(Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id), Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.dmPFC.current.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.dmPFC.current.(gaze_variables).(monkey_id).(type_id)] = ttest(Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id), Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id));
            end

            % OFC 
            if isequal(sum(~isnan(Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.OFC.current_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.OFC.current_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.OFC.current_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.OFC.current_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.OFC.current_sham.(gaze_variables).(monkey_id).(type_id), Stats_median.h.OFC.current_sham.(gaze_variables).(monkey_id).(type_id)] = signrank(Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id), Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.OFC.current_sham.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.OFC.current_sham.(gaze_variables).(monkey_id).(type_id)] = ttest(Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id), Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id));
            end
        
            if isequal(sum(~isnan(Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.OFC.current_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.OFC.current_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.OFC.current_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.OFC.current_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.OFC.current_stim.(gaze_variables).(monkey_id).(type_id), Stats_median.h.OFC.current_stim.(gaze_variables).(monkey_id).(type_id)] = signrank(Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id), Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.OFC.current_stim.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.OFC.current_stim.(gaze_variables).(monkey_id).(type_id)] = ttest(Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id), Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id));
            end
        
            if isequal(sum(~isnan(Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.OFC.previous_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.OFC.previous_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.OFC.previous_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.OFC.previous_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.OFC.previous_sham.(gaze_variables).(monkey_id).(type_id), Stats_median.h.OFC.previous_sham.(gaze_variables).(monkey_id).(type_id)] = signrank(Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id), Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.OFC.previous_sham.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.OFC.previous_sham.(gaze_variables).(monkey_id).(type_id)] = ttest(Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id), Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id));
            end
        
            if isequal(sum(~isnan(Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.OFC.previous_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.OFC.previous_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.OFC.previous_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.OFC.previous_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.OFC.previous_stim.(gaze_variables).(monkey_id).(type_id), Stats_median.h.OFC.previous_stim.(gaze_variables).(monkey_id).(type_id)] = signrank(Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id), Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.OFC.previous_stim.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.OFC.previous_stim.(gaze_variables).(monkey_id).(type_id)] = ttest(Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id), Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id));
            end

            % ACCg 
            if isequal(sum(~isnan(Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.ACCg.current_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.ACCg.current_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.ACCg.current_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.ACCg.current_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.ACCg.current_sham.(gaze_variables).(monkey_id).(type_id), Stats_median.h.ACCg.current_sham.(gaze_variables).(monkey_id).(type_id)] = signrank(Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id), Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.ACCg.current_sham.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.ACCg.current_sham.(gaze_variables).(monkey_id).(type_id)] = ttest(Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id), Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id));
            end
        
            if isequal(sum(~isnan(Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.ACCg.current_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.ACCg.current_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.ACCg.current_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.ACCg.current_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.ACCg.current_stim.(gaze_variables).(monkey_id).(type_id), Stats_median.h.ACCg.current_stim.(gaze_variables).(monkey_id).(type_id)] = signrank(Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id), Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.ACCg.current_stim.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.ACCg.current_stim.(gaze_variables).(monkey_id).(type_id)] = ttest(Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id), Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id));
            end
        
            if isequal(sum(~isnan(Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.ACCg.previous_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.ACCg.previous_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.ACCg.previous_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.ACCg.previous_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.ACCg.previous_sham.(gaze_variables).(monkey_id).(type_id), Stats_median.h.ACCg.previous_sham.(gaze_variables).(monkey_id).(type_id)] = signrank(Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id), Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.ACCg.previous_sham.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.ACCg.previous_sham.(gaze_variables).(monkey_id).(type_id)] = ttest(Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id), Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id));
            end
        
            if isequal(sum(~isnan(Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.ACCg.previous_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.ACCg.previous_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.ACCg.previous_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.ACCg.previous_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.ACCg.previous_stim.(gaze_variables).(monkey_id).(type_id), Stats_median.h.ACCg.previous_stim.(gaze_variables).(monkey_id).(type_id)] = signrank(Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id), Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.ACCg.previous_stim.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.ACCg.previous_stim.(gaze_variables).(monkey_id).(type_id)] = ttest(Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id), Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id));
            end

            % dmPFC 
            if isequal(sum(~isnan(Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.dmPFC.current_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.dmPFC.current_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.dmPFC.current_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.dmPFC.current_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.dmPFC.current_sham.(gaze_variables).(monkey_id).(type_id), Stats_median.h.dmPFC.current_sham.(gaze_variables).(monkey_id).(type_id)] = signrank(Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id), Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.dmPFC.current_sham.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.dmPFC.current_sham.(gaze_variables).(monkey_id).(type_id)] = ttest(Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id), Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id));
            end
        
            if isequal(sum(~isnan(Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.dmPFC.current_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.dmPFC.current_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.dmPFC.current_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.dmPFC.current_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.dmPFC.current_stim.(gaze_variables).(monkey_id).(type_id), Stats_median.h.dmPFC.current_stim.(gaze_variables).(monkey_id).(type_id)] = signrank(Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id), Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.dmPFC.current_stim.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.dmPFC.current_stim.(gaze_variables).(monkey_id).(type_id)] = ttest(Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id), Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id));
            end
        
            if isequal(sum(~isnan(Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.dmPFC.previous_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.dmPFC.previous_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.dmPFC.previous_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.dmPFC.previous_sham.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.dmPFC.previous_sham.(gaze_variables).(monkey_id).(type_id), Stats_median.h.dmPFC.previous_sham.(gaze_variables).(monkey_id).(type_id)] = signrank(Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id), Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.dmPFC.previous_sham.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.dmPFC.previous_sham.(gaze_variables).(monkey_id).(type_id)] = ttest(Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id), Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id));
            end
        
            if isequal(sum(~isnan(Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)) & ~isnan(Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id))),0)
            Stats_median.p.dmPFC.previous_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_median.h.dmPFC.previous_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.p.dmPFC.previous_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            Stats_mean.h.dmPFC.previous_stim.(gaze_variables).(monkey_id).(type_id) = NaN;
            else
            [Stats_median.p.dmPFC.previous_stim.(gaze_variables).(monkey_id).(type_id), Stats_median.h.dmPFC.previous_stim.(gaze_variables).(monkey_id).(type_id)] = signrank(Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id), Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id));
            [Stats_mean.h.dmPFC.previous_stim.(gaze_variables).(monkey_id).(type_id), Stats_mean.p.dmPFC.previous_stim.(gaze_variables).(monkey_id).(type_id)] = ttest(Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id), Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id));
            end

        end

    end

end

%% Save stats and create "Gaze" variable for plotting

% Stats.mean and median is mean and median across days (final step)
% Stats...(monkey_id).mean and median is mean and median within each day
% (first step)

Gaze.Sham_Sham=Sham_Sham;
Gaze.Sham_Stim=Sham_Stim;
Gaze.Stim_Sham=Stim_Sham;
Gaze.Stim_Stim=Stim_Stim;
Gaze.Current_Sham=Current_Sham;
Gaze.Current_Stim=Current_Stim;

Stats.mean.h=Stats_mean.h;
Stats.median.h=Stats_median.h;
Stats.mean.p=Stats_mean.p;
Stats.median.p=Stats_median.p;

save('Gaze_Basic_Behavior_Combined.mat','Gaze','-v7.3')
save('Stats_Basic_Behavior_Combined.mat','Stats','-v7.3')
    
%% Get info into a table

region_list={'OFC','ACCg','dmPFC'};
type_list={'current','current_sham','current_stim','previous_sham','previous_stim'};

for nregion=1:3
    region_id=char(region_list(nregion));

    for ntype=1:5
        type_id=char(type_list(ntype));
        variable_list=fieldnames(Stats_mean.p.(region_id).(type_id));
        
        for nvariable=1:length(variable_list)
            variable_id=char(variable_list(nvariable));
            Table_mean_of_mean.(region_id).(type_id){nvariable,1}=variable_id;
            Table_mean_of_mean.(region_id).(type_id){nvariable,2}=Stats_mean.p.(region_id).(type_id).(variable_id).All.mean;
            Table_mean_of_mean.(region_id).(type_id){nvariable,3}=Stats_mean.p.(region_id).(type_id).(variable_id).Lynch.mean;
            Table_mean_of_mean.(region_id).(type_id){nvariable,4}=Stats_mean.p.(region_id).(type_id).(variable_id).Tarantino.mean;

            Table_mean_of_median.(region_id).(type_id){nvariable,1}=variable_id;
            Table_mean_of_median.(region_id).(type_id){nvariable,2}=Stats_mean.p.(region_id).(type_id).(variable_id).All.median;
            Table_mean_of_median.(region_id).(type_id){nvariable,3}=Stats_mean.p.(region_id).(type_id).(variable_id).Lynch.median;
            Table_mean_of_median.(region_id).(type_id){nvariable,4}=Stats_mean.p.(region_id).(type_id).(variable_id).Tarantino.median;

            Table_median_of_mean.(region_id).(type_id){nvariable,1}=variable_id;
            Table_median_of_mean.(region_id).(type_id){nvariable,2}=Stats_median.p.(region_id).(type_id).(variable_id).All.mean;
            Table_median_of_mean.(region_id).(type_id){nvariable,3}=Stats_median.p.(region_id).(type_id).(variable_id).Lynch.mean;
            Table_median_of_mean.(region_id).(type_id){nvariable,4}=Stats_median.p.(region_id).(type_id).(variable_id).Tarantino.mean;

            Table_median_of_median.(region_id).(type_id){nvariable,1}=variable_id;
            Table_median_of_median.(region_id).(type_id){nvariable,2}=Stats_median.p.(region_id).(type_id).(variable_id).All.median;
            Table_median_of_median.(region_id).(type_id){nvariable,3}=Stats_median.p.(region_id).(type_id).(variable_id).Lynch.median;
            Table_median_of_median.(region_id).(type_id){nvariable,4}=Stats_median.p.(region_id).(type_id).(variable_id).Tarantino.median;

            clear variable_id

        end

        clear nvariable type_id variable_list

    end

    clear ntype region_id

end

Table.Table_mean_of_mean=Table_mean_of_mean;
Table.Table_mean_of_median=Table_mean_of_median;
Table.Table_median_of_mean=Table_median_of_mean;
Table.Table_median_of_median=Table_median_of_median;

save('Table_Stats_Basic_Behavior_Combined.mat','Table','-v7.3')

%% Comparing stim effect across contra and ipsi (paired)

[p_OFC, h_OFC] = signrank(Gaze.Current_Stim.OFC.m1_distance_to_eyes_ipsi.All.mean-Gaze.Current_Sham.OFC.m1_distance_to_eyes_ipsi.All.mean, Gaze.Current_Stim.OFC.m1_distance_to_eyes_contra.All.mean-Gaze.Current_Sham.OFC.m1_distance_to_eyes_contra.All.mean);
[p_dmPFC, h_dmPFC] = signrank(Gaze.Current_Stim.dmPFC.m1_distance_to_eyes_ipsi.All.mean-Gaze.Current_Sham.dmPFC.m1_distance_to_eyes_ipsi.All.mean, Gaze.Current_Stim.dmPFC.m1_distance_to_eyes_contra.All.mean-Gaze.Current_Sham.dmPFC.m1_distance_to_eyes_contra.All.mean);
[p_ACCg, h_ACCg] = signrank(Gaze.Current_Stim.ACCg.m1_distance_to_eyes_ipsi.All.mean-Gaze.Current_Sham.ACCg.m1_distance_to_eyes_ipsi.All.mean, Gaze.Current_Stim.ACCg.m1_distance_to_eyes_contra.All.mean-Gaze.Current_Sham.ACCg.m1_distance_to_eyes_contra.All.mean);

[p_OFC_Lynch, h_OFC_Lynch] = signrank(Gaze.Current_Stim.OFC.m1_distance_to_eyes_ipsi.Lynch.mean-Gaze.Current_Sham.OFC.m1_distance_to_eyes_ipsi.Lynch.mean, Gaze.Current_Stim.OFC.m1_distance_to_eyes_contra.Lynch.mean-Gaze.Current_Sham.OFC.m1_distance_to_eyes_contra.Lynch.mean);
[p_dmPFC_Lynch, h_dmPFC_Lynch] = signrank(Gaze.Current_Stim.dmPFC.m1_distance_to_eyes_ipsi.Lynch.mean-Gaze.Current_Sham.dmPFC.m1_distance_to_eyes_ipsi.Lynch.mean, Gaze.Current_Stim.dmPFC.m1_distance_to_eyes_contra.Lynch.mean-Gaze.Current_Sham.dmPFC.m1_distance_to_eyes_contra.Lynch.mean);
[p_ACCg_Lynch, h_ACCg_Lynch] = signrank(Gaze.Current_Stim.ACCg.m1_distance_to_eyes_ipsi.Lynch.mean-Gaze.Current_Sham.ACCg.m1_distance_to_eyes_ipsi.Lynch.mean, Gaze.Current_Stim.ACCg.m1_distance_to_eyes_contra.Lynch.mean-Gaze.Current_Sham.ACCg.m1_distance_to_eyes_contra.Lynch.mean);

[p_OFC_Tarantino, h_OFC_Tarantino] = signrank(Gaze.Current_Stim.OFC.m1_distance_to_eyes_ipsi.Tarantino.mean-Gaze.Current_Sham.OFC.m1_distance_to_eyes_ipsi.Tarantino.mean, Gaze.Current_Stim.OFC.m1_distance_to_eyes_contra.Tarantino.mean-Gaze.Current_Sham.OFC.m1_distance_to_eyes_contra.Tarantino.mean);
[p_dmPFC_Tarantino, h_dmPFC_Tarantino] = signrank(Gaze.Current_Stim.dmPFC.m1_distance_to_eyes_ipsi.Tarantino.mean-Gaze.Current_Sham.dmPFC.m1_distance_to_eyes_ipsi.Tarantino.mean, Gaze.Current_Stim.dmPFC.m1_distance_to_eyes_contra.Tarantino.mean-Gaze.Current_Sham.dmPFC.m1_distance_to_eyes_contra.Tarantino.mean);
[p_ACCg_Tarantino, h_ACCg_Tarantino] = signrank(Gaze.Current_Stim.ACCg.m1_distance_to_eyes_ipsi.Tarantino.mean-Gaze.Current_Sham.ACCg.m1_distance_to_eyes_ipsi.Tarantino.mean, Gaze.Current_Stim.ACCg.m1_distance_to_eyes_contra.Tarantino.mean-Gaze.Current_Sham.ACCg.m1_distance_to_eyes_contra.Tarantino.mean);

