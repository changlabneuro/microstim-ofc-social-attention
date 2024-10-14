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
% Gaze_variables={'total_frequency','total_duration','total_iti'};

%% Get Stats

ROI={'whole_face','all_face'};

for nROI=1:2
    ROI_id=char(ROI(nROI));

    for ngaze=1:length(Gaze_variables)
    
        gaze_variables=char(Gaze_variables(ngaze));
        monkey_names={'All', 'Lynch', 'Tarantino'};
        
        for nmonkey=1:3
            monkey_id=char(monkey_names(nmonkey));
            
            Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean=[];
            Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean=[];
            Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).percentage=[];
            Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).percentage=[];
    
            for nOFC=1:length(OFC_day.(monkey_id))
        
                field_id=char(strcat('data_',OFC_day.(monkey_id)(nOFC)));
        
                Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean=[Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean mean(ITI_Day.(ROI_id).(field_id).current_sham.(gaze_variables),'omitnan')];
                Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean=[Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean mean(ITI_Day.(ROI_id).(field_id).current_stim.(gaze_variables),'omitnan')];
                 
                Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).percentage=[Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).percentage sum(~isnan(ITI_Day.(ROI_id).(field_id).current_sham.(gaze_variables)))/length(ITI_Day.(ROI_id).(field_id).current_sham.(gaze_variables))];
                Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).percentage=[Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).percentage sum(~isnan(ITI_Day.(ROI_id).(field_id).current_stim.(gaze_variables)))/length(ITI_Day.(ROI_id).(field_id).current_stim.(gaze_variables))];
    
            end
    
            Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean=[];
            Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean=[];
            Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).percentage=[];
            Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).percentage=[];
    
            for nACCg=1:length(ACCg_day.(monkey_id))
        
                field_id=char(strcat('data_',ACCg_day.(monkey_id)(nACCg)));
        
                Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean=[Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean mean(ITI_Day.(ROI_id).(field_id).current_sham.(gaze_variables),'omitnan')];
                Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean=[Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean mean(ITI_Day.(ROI_id).(field_id).current_stim.(gaze_variables),'omitnan')];
                 
                Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).percentage=[Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).percentage sum(~isnan(ITI_Day.(ROI_id).(field_id).current_sham.(gaze_variables)))/length(ITI_Day.(ROI_id).(field_id).current_sham.(gaze_variables))];
                Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).percentage=[Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).percentage sum(~isnan(ITI_Day.(ROI_id).(field_id).current_stim.(gaze_variables)))/length(ITI_Day.(ROI_id).(field_id).current_stim.(gaze_variables))];
    
            end

            Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean=[];
            Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean=[];
            Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).percentage=[];
            Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).percentage=[];
    
            for ndmPFC=1:length(dmPFC_day.(monkey_id))
        
                field_id=char(strcat('data_',dmPFC_day.(monkey_id)(ndmPFC)));
        
                Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean=[Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean mean(ITI_Day.(ROI_id).(field_id).current_sham.(gaze_variables),'omitnan')];
                Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean=[Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean mean(ITI_Day.(ROI_id).(field_id).current_stim.(gaze_variables),'omitnan')];
                 
                Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).percentage=[Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).percentage sum(~isnan(ITI_Day.(ROI_id).(field_id).current_sham.(gaze_variables)))/length(ITI_Day.(ROI_id).(field_id).current_sham.(gaze_variables))];
                Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).percentage=[Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).percentage sum(~isnan(ITI_Day.(ROI_id).(field_id).current_stim.(gaze_variables)))/length(ITI_Day.(ROI_id).(field_id).current_stim.(gaze_variables))];
    
            end
    
            % OFC
            if isequal(sum(~isnan(Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean) & ~isnan(Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean)),0)
            Stats_mean.(ROI_id).p.OFC.current.(gaze_variables).(monkey_id).mean= NaN;
            Stats_mean.(ROI_id).h.OFC.current.(gaze_variables).(monkey_id).mean = NaN;
            else
            [Stats_mean.(ROI_id).p.OFC.current.(gaze_variables).(monkey_id).mean,Stats_mean.(ROI_id).h.OFC.current.(gaze_variables).(monkey_id).mean] = signrank(Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean, Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean);
            end
    
            % ACCg
            if isequal(sum(~isnan(Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean) & ~isnan(Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean)),0)
            Stats_mean.(ROI_id).p.ACCg.current.(gaze_variables).(monkey_id).mean= NaN;
            Stats_mean.(ROI_id).h.ACCg.current.(gaze_variables).(monkey_id).mean = NaN;
            else
            [Stats_mean.(ROI_id).p.ACCg.current.(gaze_variables).(monkey_id).mean,Stats_mean.(ROI_id).h.ACCg.current.(gaze_variables).(monkey_id).mean] = signrank(Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean, Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean);
            end

            % dmPFC
            if isequal(sum(~isnan(Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean) & ~isnan(Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean)),0)
            Stats_mean.(ROI_id).p.dmPFC.current.(gaze_variables).(monkey_id).mean= NaN;
            Stats_mean.(ROI_id).h.dmPFC.current.(gaze_variables).(monkey_id).mean = NaN;
            else
            [Stats_mean.(ROI_id).p.dmPFC.current.(gaze_variables).(monkey_id).mean,Stats_mean.(ROI_id).h.dmPFC.current.(gaze_variables).(monkey_id).mean] = signrank(Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean, Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean);
            end
    
        end
    
    end

end


%% Save stats and create "Gaze" variable for plotting

ITI.Current_Sham=Current_Sham;
ITI.Current_Stim=Current_Stim;

Stats=Stats_mean;

save('ITI_Results_Combined.mat','ITI','-v7.3')
save('Stats_ITI_Combined.mat','Stats','-v7.3')
    
%% Plotting each day as a dot for Gaze

Gaze_variables={'average_frequency','average_duration','average_iti'};
% Gaze_variables={'total_frequency','total_duration','total_iti'};

ROI={'whole_face','all_face'};

for nROI=1:2
    ROI_id=char(ROI(nROI));
    
    for ngaze=1:length(Gaze_variables)
    
        gaze_variables=char(Gaze_variables(ngaze));
        monkey_names={'All', 'Lynch', 'Tarantino'};
        
        for nmonkey=1:3
            monkey_id=char(monkey_names(nmonkey));
    
            % Current Sham vs. Current Stim
                
            subplot(1,3,1)
        
            X=categorical({'Gaze Current Sham','Gaze Current Stim'});
            X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim'});
            Y=[median(ITI.Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean,'omitnan'),median(ITI.Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean,'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(OFC_day.(monkey_id)));
            line_hs = cell( length(OFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );
    
            for m=1:length(OFC_day.(monkey_id))
                
                scatter(X(1),ITI.Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),ITI.Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean(m),30,colorInd(m,:),'filled'); hold on
                line_hs{m} = line([X(1) X(2)],[ITI.Current_Sham.(ROI_id).OFC.(gaze_variables).(monkey_id).mean(m) ITI.Current_Stim.(ROI_id).OFC.(gaze_variables).(monkey_id).mean(m)], 'Color',colorInd(m,:)); hold on
                line_labels{m} = OFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('OFC')
            ax1=gca; 
            axis(ax1,'square');
            clear X Y m colorInd line_hs line_labels
    
            subplot(1,3,2)
        
            X=categorical({'Gaze Current Sham','Gaze Current Stim'});
            X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim'});
            Y=[median(ITI.Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean,'omitnan'),median(ITI.Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean,'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(ACCg_day.(monkey_id)));
            line_hs = cell( length(ACCg_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );
    
            for m=1:length(ACCg_day.(monkey_id))
                
                scatter(X(1),ITI.Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),ITI.Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean(m),30,colorInd(m,:),'filled'); hold on
                line_hs{m} = line([X(1) X(2)],[ITI.Current_Sham.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean(m) ITI.Current_Stim.(ROI_id).ACCg.(gaze_variables).(monkey_id).mean(m)], 'Color',colorInd(m,:)); hold on
                line_labels{m} = ACCg_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('ACCg')
            ax2=gca; 
            axis(ax2,'square');
            clear X Y m colorInd line_hs line_labels
                
            subplot(1,3,3)
        
            X=categorical({'Gaze Current Sham','Gaze Current Stim'});
            X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim'});
            Y=[median(ITI.Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean,'omitnan'),median(ITI.Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean,'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(dmPFC_day.(monkey_id)));
            line_hs = cell( length(dmPFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );
    
            for m=1:length(dmPFC_day.(monkey_id))
                
                scatter(X(1),ITI.Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),ITI.Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean(m),30,colorInd(m,:),'filled'); hold on
                line_hs{m} = line([X(1) X(2)],[ITI.Current_Sham.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean(m) ITI.Current_Stim.(ROI_id).dmPFC.(gaze_variables).(monkey_id).mean(m)], 'Color',colorInd(m,:)); hold on
                line_labels{m} = dmPFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('dmPFC')
            ax3=gca; 
            axis(ax3,'square');
            clear X Y m colorInd line_hs line_labels
                 
            linkaxes([ax1,ax2,ax3],'y');
        
            sgtitle(sprintf([ROI_id '_' gaze_variables '_' monkey_id]),'Interpreter', 'none')   
            set(gcf, 'Renderer', 'painters');
            saveas(gcf,sprintf([ROI_id '_' gaze_variables,'_',monkey_id]))
            saveas(gcf,sprintf([ROI_id '_' gaze_variables,'_',monkey_id,'.jpg']))
            saveas(gcf,sprintf([ROI_id '_' gaze_variables,'_',monkey_id,'.epsc']))
        
            clf
    
        end
    
    end

end

%% Calculate number and percentage of trials with such sequence for each day

% Upload ITI_Day_Combined.mat
 
fieldname=fieldnames(ITI_Day.all_face);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
    
    number_stim_total(1,k)=length(ITI_Day.all_face.(field_id).current_stim.average_iti);
    number_stim_nonNaN(1,k)=sum(~isnan(ITI_Day.all_face.(field_id).current_stim.average_iti));

    number_sham_total(1,k)=length(ITI_Day.all_face.(field_id).current_sham.average_iti);
    number_sham_nonNaN(1,k)=sum(~isnan(ITI_Day.all_face.(field_id).current_sham.average_iti));

    number_total(1,k)=number_stim_total(1,k)+number_sham_total(1,k);
    number_nonNaN(1,k)=number_stim_nonNaN(1,k)+number_sham_nonNaN(1,k);

end
    
%% Calculate how many sequences of m2-m1 after a stim/sham

fieldname=fieldnames(iti.all_face);
n_iti=[];

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
    field_run=fieldnames(iti.all_face.(field_id));

     for l=1:size(field_run,1)
        run_id=char(field_run(l));
        field_stim=fieldnames(iti.all_face.(field_id).(run_id));
        n_not_stim=2;
        
        % include all trials
        for nstim = 1:length(field_stim)-n_not_stim
            stim_id=char(field_stim(nstim+n_not_stim));
            
            n_iti=[n_iti length(iti.all_face.(field_id).(run_id).(stim_id).iti)];
        end
     end
end


