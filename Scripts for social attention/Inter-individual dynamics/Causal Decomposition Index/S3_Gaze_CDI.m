%% Compare index across stim and sham on the day level

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

 Gaze_variables={'causal_m1m2_eyes'};

%% Calculate causal decomposition index for stim and sham

% Upload Decomp_Results_Day_Combined.mat

for ngaze=1:length(Gaze_variables)

    gaze_variables=char(Gaze_variables(ngaze));
    monkey_names={'All', 'Lynch', 'Tarantino'};
    
    for nmonkey=1:3
        monkey_id=char(monkey_names(nmonkey));
        
        Current_Sham.OFC.(gaze_variables).(monkey_id).mean=[];
        Current_Stim.OFC.(gaze_variables).(monkey_id).mean=[];
    
        for nOFC=1:length(OFC_day.(monkey_id))
    
            field_id=char(strcat('data_',OFC_day.(monkey_id)(nOFC)));
    
            Current_Sham.OFC.(gaze_variables).(monkey_id).mean=[Current_Sham.OFC.(gaze_variables).(monkey_id).mean mean(Decomp_Results_day.(field_id).current_sham.(gaze_variables).true_index,'omitnan')];
            Current_Stim.OFC.(gaze_variables).(monkey_id).mean=[Current_Stim.OFC.(gaze_variables).(monkey_id).mean mean(Decomp_Results_day.(field_id).current_stim.(gaze_variables).true_index,'omitnan')];
            
        end

        Current_Sham.ACCg.(gaze_variables).(monkey_id).mean=[];
        Current_Stim.ACCg.(gaze_variables).(monkey_id).mean=[];
    
        for nACCg=1:length(ACCg_day.(monkey_id))
    
            field_id=char(strcat('data_',ACCg_day.(monkey_id)(nACCg)));
    
            Current_Sham.ACCg.(gaze_variables).(monkey_id).mean=[Current_Sham.ACCg.(gaze_variables).(monkey_id).mean mean(Decomp_Results_day.(field_id).current_sham.(gaze_variables).true_index,'omitnan')];
            Current_Stim.ACCg.(gaze_variables).(monkey_id).mean=[Current_Stim.ACCg.(gaze_variables).(monkey_id).mean mean(Decomp_Results_day.(field_id).current_stim.(gaze_variables).true_index,'omitnan')];
            
        end

        Current_Sham.dmPFC.(gaze_variables).(monkey_id).mean=[];
        Current_Stim.dmPFC.(gaze_variables).(monkey_id).mean=[];
    
        for ndmPFC=1:length(dmPFC_day.(monkey_id))
    
            field_id=char(strcat('data_',dmPFC_day.(monkey_id)(ndmPFC)));
    
            Current_Sham.dmPFC.(gaze_variables).(monkey_id).mean=[Current_Sham.dmPFC.(gaze_variables).(monkey_id).mean mean(Decomp_Results_day.(field_id).current_sham.(gaze_variables).true_index,'omitnan')];
            Current_Stim.dmPFC.(gaze_variables).(monkey_id).mean=[Current_Stim.dmPFC.(gaze_variables).(monkey_id).mean mean(Decomp_Results_day.(field_id).current_stim.(gaze_variables).true_index,'omitnan')];
            
        end

        % OFC
        if isequal(sum(~isnan(Current_Sham.OFC.(gaze_variables).(monkey_id).mean) & ~isnan(Current_Stim.OFC.(gaze_variables).(monkey_id).mean)),0)
        Stats_mean.p.OFC.current.(gaze_variables).(monkey_id).mean= NaN;
        Stats_mean.h.OFC.current.(gaze_variables).(monkey_id).mean = NaN;
        else
        [Stats_mean.p.OFC.current.(gaze_variables).(monkey_id).mean,Stats_mean.h.OFC.current.(gaze_variables).(monkey_id).mean] = signrank(Current_Sham.OFC.(gaze_variables).(monkey_id).mean, Current_Stim.OFC.(gaze_variables).(monkey_id).mean);
        end

        % ACCg
        if isequal(sum(~isnan(Current_Sham.ACCg.(gaze_variables).(monkey_id).mean) & ~isnan(Current_Stim.ACCg.(gaze_variables).(monkey_id).mean)),0)
        Stats_mean.p.ACCg.current.(gaze_variables).(monkey_id).mean= NaN;
        Stats_mean.h.ACCg.current.(gaze_variables).(monkey_id).mean = NaN;
        else
        [Stats_mean.p.ACCg.current.(gaze_variables).(monkey_id).mean,Stats_mean.h.ACCg.current.(gaze_variables).(monkey_id).mean] = signrank(Current_Sham.ACCg.(gaze_variables).(monkey_id).mean, Current_Stim.ACCg.(gaze_variables).(monkey_id).mean);
        end

        % dmPFC
        if isequal(sum(~isnan(Current_Sham.dmPFC.(gaze_variables).(monkey_id).mean) & ~isnan(Current_Stim.dmPFC.(gaze_variables).(monkey_id).mean)),0)
        Stats_mean.p.dmPFC.current.(gaze_variables).(monkey_id).mean= NaN;
        Stats_mean.h.dmPFC.current.(gaze_variables).(monkey_id).mean = NaN;
        else
        [Stats_mean.p.dmPFC.current.(gaze_variables).(monkey_id).mean,Stats_mean.h.dmPFC.current.(gaze_variables).(monkey_id).mean] = signrank(Current_Sham.dmPFC.(gaze_variables).(monkey_id).mean, Current_Stim.dmPFC.(gaze_variables).(monkey_id).mean);
        end

   end

end

%% Save stats

Causal_Decomposition.Current_Sham=Current_Sham;
Causal_Decomposition.Current_Stim=Current_Stim;

Stats=Stats_mean;

save('Index_Results_Combined.mat','Causal_Decomposition','-v7.3')
save('Index_Stats_Causal_Decomposition_Combined.mat','Stats','-v7.3')

%% Plotting each day as a dot 

Gaze_variables={'causal_m1m2_eyes'};

for ngaze=1:length(Gaze_variables)

    gaze_variables=char(Gaze_variables(ngaze));
    monkey_names={'All', 'Lynch', 'Tarantino'};
    
    for nmonkey=1:3
        monkey_id=char(monkey_names(nmonkey));

        % Current Sham vs. Current Stim
            
        subplot(3,3,1)
    
        X=categorical({'Gaze Current Sham','Gaze Current Stim'});
        X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim'});
        Y=[median(Causal_Decomposition.Current_Sham.OFC.(gaze_variables).(monkey_id).mean,'omitnan'),median(Causal_Decomposition.Current_Stim.OFC.(gaze_variables).(monkey_id).mean,'omitnan')];
        bar(X,Y); hold on
        
        colorInd=jet(length(OFC_day.(monkey_id)));
        line_hs = cell( length(OFC_day.(monkey_id)), 1 );
        line_labels = cell( size(line_hs) );

        for m=1:length(OFC_day.(monkey_id))
            
            scatter(X(1),Causal_Decomposition.Current_Sham.OFC.(gaze_variables).(monkey_id).mean(m),30,colorInd(m,:),'filled'); hold on           
            scatter(X(2),Causal_Decomposition.Current_Stim.OFC.(gaze_variables).(monkey_id).mean(m),30,colorInd(m,:),'filled'); hold on
            line_hs{m} = line([X(1) X(2)],[Causal_Decomposition.Current_Sham.OFC.(gaze_variables).(monkey_id).mean(m) Causal_Decomposition.Current_Stim.OFC.(gaze_variables).(monkey_id).mean(m)], 'Color',colorInd(m,:)); hold on
            line_labels{m} = OFC_day.(monkey_id){m};
        
        end
        legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
        title('OFC')
        ax1=gca; 
        axis(ax1,'square');
        ylim([0.4 0.6]);
        clear X Y m colorInd line_hs line_labels

        subplot(3,3,2)
    
        X=categorical({'Gaze Current Sham','Gaze Current Stim'});
        X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim'});
        Y=[median(Causal_Decomposition.Current_Sham.ACCg.(gaze_variables).(monkey_id).mean,'omitnan'),median(Causal_Decomposition.Current_Stim.ACCg.(gaze_variables).(monkey_id).mean,'omitnan')];
        bar(X,Y); hold on
        
        colorInd=jet(length(ACCg_day.(monkey_id)));
        line_hs = cell( length(ACCg_day.(monkey_id)), 1 );
        line_labels = cell( size(line_hs) );

        for m=1:length(ACCg_day.(monkey_id))
            
            scatter(X(1),Causal_Decomposition.Current_Sham.ACCg.(gaze_variables).(monkey_id).mean(m),30,colorInd(m,:),'filled'); hold on           
            scatter(X(2),Causal_Decomposition.Current_Stim.ACCg.(gaze_variables).(monkey_id).mean(m),30,colorInd(m,:),'filled'); hold on
            line_hs{m} = line([X(1) X(2)],[Causal_Decomposition.Current_Sham.ACCg.(gaze_variables).(monkey_id).mean(m) Causal_Decomposition.Current_Stim.ACCg.(gaze_variables).(monkey_id).mean(m)], 'Color',colorInd(m,:)); hold on
            line_labels{m} = ACCg_day.(monkey_id){m};
        
        end
        legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
        title('ACCg')
        ax2=gca; 
        axis(ax2,'square');
        ylim([0.4 0.6]);
        clear X Y m colorInd line_hs line_labels
            
        subplot(3,3,3)
    
        X=categorical({'Gaze Current Sham','Gaze Current Stim'});
        X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim'});
        Y=[median(Causal_Decomposition.Current_Sham.dmPFC.(gaze_variables).(monkey_id).mean,'omitnan'),median(Causal_Decomposition.Current_Stim.dmPFC.(gaze_variables).(monkey_id).mean,'omitnan')];
        bar(X,Y); hold on
        
        colorInd=jet(length(dmPFC_day.(monkey_id)));
        line_hs = cell( length(dmPFC_day.(monkey_id)), 1 );
        line_labels = cell( size(line_hs) );

        for m=1:length(dmPFC_day.(monkey_id))
            
            scatter(X(1),Causal_Decomposition.Current_Sham.dmPFC.(gaze_variables).(monkey_id).mean(m),30,colorInd(m,:),'filled'); hold on           
            scatter(X(2),Causal_Decomposition.Current_Stim.dmPFC.(gaze_variables).(monkey_id).mean(m),30,colorInd(m,:),'filled'); hold on
            line_hs{m} = line([X(1) X(2)],[Causal_Decomposition.Current_Sham.dmPFC.(gaze_variables).(monkey_id).mean(m) Causal_Decomposition.Current_Stim.dmPFC.(gaze_variables).(monkey_id).mean(m)], 'Color',colorInd(m,:)); hold on
            line_labels{m} = dmPFC_day.(monkey_id){m};
        
        end
        legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
        title('dmPFC')
        ax3=gca; 
        axis(ax3,'square');
        ylim([0.4 0.6]);
        clear X Y m colorInd line_hs line_labels
             
        linkaxes([ax1,ax2,ax3],'y');
    
        sgtitle(sprintf([gaze_variables '_' monkey_id]),'Interpreter', 'none')   
        set(gcf, 'Renderer', 'painters');
        saveas(gcf,sprintf([gaze_variables,'_',monkey_id]))
        saveas(gcf,sprintf([gaze_variables,'_',monkey_id,'.jpg']))
        saveas(gcf,sprintf([gaze_variables,'_',monkey_id,'.epsc']))
    
        clf

    end

end

