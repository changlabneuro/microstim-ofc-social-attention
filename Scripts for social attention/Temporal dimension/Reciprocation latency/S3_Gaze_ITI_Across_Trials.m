%% Combine all days to increase n

% upload ITI_Day_Combined.mat

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

Gaze_variables={'average_frequency','average_duration','average_iti'};

%% Combine across days

ROI_id=char('all_face');
for ngaze=1:length(Gaze_variables)

     gaze_variables=char(Gaze_variables(ngaze));
     monkey_names={'All', 'Lynch', 'Tarantino'};
        
    for nmonkey=1:3
        monkey_id=char(monkey_names(nmonkey));
    
        Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean=[];
        Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean=[];
       
        for nOFC=1:length(OFC_day.(monkey_id))
        
            field_id=char(strcat('data_',OFC_day.(monkey_id)(nOFC)));
        
            Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean=[Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean ITI_Day.(ROI_id).(field_id).current_sham.(gaze_variables)];
            Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean=[Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean ITI_Day.(ROI_id).(field_id).current_stim.(gaze_variables)];

        end

        Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean=[];
        Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean=[];
       
        for nACCg=1:length(ACCg_day.(monkey_id))
        
            field_id=char(strcat('data_',ACCg_day.(monkey_id)(nACCg)));
        
            Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean=[Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean ITI_Day.(ROI_id).(field_id).current_sham.(gaze_variables)];
            Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean=[Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean ITI_Day.(ROI_id).(field_id).current_stim.(gaze_variables)];

        end

        Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean=[];
        Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean=[];
       
        for ndmPFC=1:length(dmPFC_day.(monkey_id))
        
            field_id=char(strcat('data_',dmPFC_day.(monkey_id)(ndmPFC)));
        
            Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean=[Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean ITI_Day.(ROI_id).(field_id).current_sham.(gaze_variables)];
            Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean=[Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean ITI_Day.(ROI_id).(field_id).current_stim.(gaze_variables)];

        end

        [Stats_mean.(ROI_id).p.OFC.current.(gaze_variables).(monkey_id).mean, Stats_mean.(ROI_id).h.OFC.current.(gaze_variables).(monkey_id).mean] = ranksum(Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean, Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean);
        [Stats_mean.(ROI_id).p.ACCg.current.(gaze_variables).(monkey_id).mean, Stats_mean.(ROI_id).h.ACCg.current.(gaze_variables).(monkey_id).mean] = ranksum(Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean, Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean);
        [Stats_mean.(ROI_id).p.dmPFC.current.(gaze_variables).(monkey_id).mean, Stats_mean.(ROI_id).h.dmPFC.current.(gaze_variables).(monkey_id).mean] = ranksum(Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean, Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean);
        
    end

end


%% Save stats and create "Gaze" variable for plotting

ITI.Current_Sham=Current_Sham;
ITI.Current_Stim=Current_Stim;

Stats=Stats_mean;

save('ITI_Results_Combined.mat','ITI','-v7.3')
save('Stats_ITI_Combined.mat','Stats','-v7.3')
    
%% Plotting each trial as a dot for Gaze

%Gaze_variables={'average_frequency','average_duration','average_iti'};
Gaze_variables={'average_iti'};
ROI_id=char('all_face');

for ngaze=1:length(Gaze_variables)
    
    gaze_variables=char(Gaze_variables(ngaze));
    monkey_names={'All', 'Lynch', 'Tarantino'};
    
    for nmonkey=1:3
        monkey_id=char(monkey_names(nmonkey));

        % Current Sham vs. Current Stim
            
        subplot(2,3,1)
    
        X=categorical({'Gaze Current Sham','Gaze Current Stim'});
        X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim'});
        Y=[median(ITI.Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean,'omitnan'),median(ITI.Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean,'omitnan')];
        bar(X,Y); hold on
        
        scatter(repmat(X(1),1,length(ITI.Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean)),ITI.Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean,30,'k','filled'); hold on           
        scatter(repmat(X(2),1,length(ITI.Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean)),ITI.Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean,30,'k','filled'); hold on   
        
        title('OFC')
        ylim([0 5000]);
        yticks([0 1000 2000 3000 4000 5000]);
        ax1=gca; 
        axis(ax1,'square');
        set(ax1,'PositionConstraint','innerposition');
        set(ax1,'plotboxaspectratio',[1 1 1]);
        clear X Y m colorInd line_hs line_labels

        subplot(2,3,2)
    
        X=categorical({'Gaze Current Sham','Gaze Current Stim'});
        X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim'});
        Y=[median(ITI.Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean,'omitnan'),median(ITI.Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean,'omitnan')];
        bar(X,Y); hold on
        
        scatter(repmat(X(1),1,length(ITI.Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean)),ITI.Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean,30,'k','filled'); hold on           
        scatter(repmat(X(2),1,length(ITI.Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean)),ITI.Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean,30,'k','filled'); hold on   
        
        title('ACCg')
        ylim([0 5000]);
        yticks([0 1000 2000 3000 4000 5000]);
        ax2=gca; 
        axis(ax2,'square');
        set(ax2,'PositionConstraint','innerposition');
        set(ax2,'plotboxaspectratio',[1 1 1]);
        clear X Y m colorInd line_hs line_labels
            
        subplot(2,3,3)
    
        X=categorical({'Gaze Current Sham','Gaze Current Stim'});
        X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim'});
        Y=[median(ITI.Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean,'omitnan'),median(ITI.Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean,'omitnan')];
        bar(X,Y); hold on
        
        scatter(repmat(X(1),1,length(ITI.Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean)),ITI.Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean,30,'k','filled'); hold on           
        scatter(repmat(X(2),1,length(ITI.Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean)),ITI.Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean,30,'k','filled'); hold on   
        
        title('dmPFC')
        ylim([0 5000]);
        yticks([0 1000 2000 3000 4000 5000]);
        ax3=gca; 
        axis(ax3,'square');
        set(ax3,'PositionConstraint','innerposition');
        set(ax3,'plotboxaspectratio',[1 1 1]);
        clear X Y m colorInd line_hs line_labels
            
        % Boxplots with jittered violin
        
        subplot(2,3,4)
    
        xsham = ITI.Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean';
        xstim = ITI.Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean';
        gsham = repmat({'Gaze Current Sham'},length(ITI.Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean),1);
        gstim = repmat({'Gaze Current Stim'},length(ITI.Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean),1);
        x_label_sham = repmat(1,length(ITI.Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean),1);
        x_label_stim = repmat(2,length(ITI.Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean),1);

        x = [xsham; xstim];
        g = [gsham; gstim];
        x_label = [x_label_sham; x_label_stim];

        boxplot(x,g); hold on
        s = swarmchart(x_label,x,6,'k','filled','MarkerFaceAlpha','1');
        s.XJitter = 'density';
        s. XJitterWidth = 0.4;

        title('OFC')
        ylim([0 5000]);
        yticks([0 1000 2000 3000 4000 5000]);
        ax4=gca; 
        axis(ax4,'square');
        set(ax4,'PositionConstraint','innerposition');
        set(ax4,'plotboxaspectratio',[1 1 1]);
        clear xsham xstim gsham gstim x_label_sham x_label_stim x g x_label s
       
        subplot(2,3,5)
   
        xsham = ITI.Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean';
        xstim = ITI.Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean';
        gsham = repmat({'Gaze Current Sham'},length(ITI.Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean),1);
        gstim = repmat({'Gaze Current Stim'},length(ITI.Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean),1);
        x_label_sham = repmat(1,length(ITI.Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean),1);
        x_label_stim = repmat(2,length(ITI.Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean),1);

        x = [xsham; xstim];
        g = [gsham; gstim];
        x_label = [x_label_sham; x_label_stim];

        boxplot(x,g); hold on
        s = swarmchart(x_label,x,6,'k','filled','MarkerFaceAlpha','1');
        s.XJitter = 'density';
        s. XJitterWidth = 0.4;

        title('ACCg')
        ylim([0 5000]);
        yticks([0 1000 2000 3000 4000 5000]);
        ax5=gca; 
        axis(ax5,'square');
        set(ax5,'PositionConstraint','innerposition');
        set(ax5,'plotboxaspectratio',[1 1 1]);
        clear xsham xstim gsham gstim x_label_sham x_label_stim x g x_label s
       
        subplot(2,3,6)
    
        xsham = ITI.Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean';
        xstim = ITI.Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean';
        gsham = repmat({'Gaze Current Sham'},length(ITI.Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean),1);
        gstim = repmat({'Gaze Current Stim'},length(ITI.Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean),1);
        x_label_sham = repmat(1,length(ITI.Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean),1);
        x_label_stim = repmat(2,length(ITI.Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean),1);

        x = [xsham; xstim];
        g = [gsham; gstim];
        x_label = [x_label_sham; x_label_stim];

        boxplot(x,g); hold on
        s = swarmchart(x_label,x,6,'k','filled','MarkerFaceAlpha','1');
        s.XJitter = 'density';
        s. XJitterWidth = 0.4;

        title('dmPFC')
        ylim([0 5000]);
        yticks([0 1000 2000 3000 4000 5000]);
        ax6=gca; 
        axis(ax6,'square');
        set(ax6,'PositionConstraint','innerposition');
        set(ax6,'plotboxaspectratio',[1 1 1]);
        clear xsham xstim gsham gstim x_label_sham x_label_stim x g x_label s
              
        linkaxes([ax1,ax2,ax3,ax4,ax5,ax6],'y');

        sgtitle(sprintf([ROI_id '_' gaze_variables '_' monkey_id]),'Interpreter', 'none')   
        set(gcf, 'Renderer', 'painters');
        saveas(gcf,sprintf([ROI_id '_' gaze_variables,'_',monkey_id]))
        saveas(gcf,sprintf([ROI_id '_' gaze_variables,'_',monkey_id,'.jpg']))
        saveas(gcf,sprintf([ROI_id '_' gaze_variables,'_',monkey_id,'.epsc']))
    
        clf

    end

end
