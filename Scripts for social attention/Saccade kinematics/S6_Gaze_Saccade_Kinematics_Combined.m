%% Fit a linear regression for stims and shams per day and get stim-sham slope (and compared to null distribution)

% Upload Saccade_Day_Combined.mat

fieldname=fieldnames(Saccade_Day);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k)); 

    stim_real=fitlm(Saccade_Day.(field_id).current_stim.macrosaccade_amp,Saccade_Day.(field_id).current_stim.macrosaccade_vel);
    sham_real=fitlm(Saccade_Day.(field_id).current_sham.macrosaccade_amp,Saccade_Day.(field_id).current_sham.macrosaccade_vel);
    mdl.(field_id).stim_real_slope=stim_real.Coefficients.Estimate(2);
    mdl.(field_id).sham_real_slope=sham_real.Coefficients.Estimate(2);

    nstim=length(Saccade_Day.(field_id).current_stim.macrosaccade_amp);
    nsham=length(Saccade_Day.(field_id).current_sham.macrosaccade_amp);
    ntotal=nstim+nsham;
    all_amps=[Saccade_Day.(field_id).current_stim.macrosaccade_amp Saccade_Day.(field_id).current_sham.macrosaccade_amp];
    all_vels=[Saccade_Day.(field_id).current_stim.macrosaccade_vel Saccade_Day.(field_id).current_sham.macrosaccade_vel];
    
    for rep=1:1000
    
        n_stim_idx(rep,:)=randperm(ntotal,nstim);
        n_sham_idx(rep,:)=setdiff(1:1:ntotal,n_stim_idx(rep,:));
        stim_amps_shuffled(rep,:)=all_amps(n_stim_idx(rep,:));
        stim_vels_shuffled(rep,:)=all_vels(n_stim_idx(rep,:));
        sham_amps_shuffled(rep,:)=all_amps(n_sham_idx(rep,:));
        sham_vels_shuffled(rep,:)=all_vels(n_sham_idx(rep,:));
        
        stim_shuffled{rep,1}=fitlm(stim_amps_shuffled(rep,:),stim_vels_shuffled(rep,:));
        sham_shuffled{rep,1}=fitlm(sham_amps_shuffled(rep,:),sham_vels_shuffled(rep,:));

        mdl.(field_id).stim_shuffled_slope(rep,1)=stim_shuffled{rep,1}.Coefficients.Estimate(2);
        mdl.(field_id).sham_shuffled_slope(rep,1)=sham_shuffled{rep,1}.Coefficients.Estimate(2);
        
    end  

    clear nstim nsham n_total all_amps all_vels
    clear n_stim_idx n_sham_idx stim_amps_shuffled stim_vels_shuffled sham_amps_shuffled sham_vels_shuffled stim_shuffled sham_shuffled

end

save('Saccade_Kinematics_Linear_Regression_Combined.mat','mdl','-v7.3');        

%% Calculate how many days have significant stim-sham slope compared to null

fieldname=fieldnames(mdl);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k)); 

    Saccade_Kinematics(1,k)=mdl.(field_id).stim_real_slope-mdl.(field_id).sham_real_slope;
    Saccade_Kinematics(2:1001,k)=mdl.(field_id).stim_shuffled_slope-mdl.(field_id).sham_shuffled_slope;
    
    if Saccade_Kinematics(1,k)>0
        Saccade_Kinematics_p(1,k)=sum(Saccade_Kinematics(1,k)<Saccade_Kinematics(2:end,k))/1000;
    else
        Saccade_Kinematics_p(1,k)=sum(Saccade_Kinematics(1,k)>Saccade_Kinematics(2:end,k))/1000;
    end

end

% Significant days are:
% 08052019 (Lynch OFC), 09032019 (Lynch dmPFC), 09222019 (Lynch dmPFC), 11052019 (Lynch OFC)
% 03182022 (Tarantino dmPFC), 05272022 (Tarantino ACCg)

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

%% Collapse data for each region (slope)

monkey_names={'All', 'Lynch', 'Tarantino'};

for nmonkey=1:3
    monkey_id=char(monkey_names(nmonkey));
   
    % OFC
    
    OFC.(monkey_id).stim.slope=[];
    OFC.(monkey_id).sham.slope=[];
    OFC.(monkey_id).stim.slope_shuffled=[];
    OFC.(monkey_id).sham.slope_shuffled=[];
    
    for nOFC=1:length(OFC_day.(monkey_id))
    
        field_id=char(strcat('data_',OFC_day.(monkey_id)(nOFC)));
    
        OFC.(monkey_id).stim.slope=[OFC.(monkey_id).stim.slope mdl.(field_id).stim_real_slope];
        OFC.(monkey_id).sham.slope=[OFC.(monkey_id).sham.slope mdl.(field_id).sham_real_slope];
        OFC.(monkey_id).stim.slope_shuffled=horzcat(OFC.(monkey_id).stim.slope_shuffled, mdl.(field_id).stim_shuffled_slope);
        OFC.(monkey_id).sham.slope_shuffled=horzcat(OFC.(monkey_id).sham.slope_shuffled, mdl.(field_id).sham_shuffled_slope);
    
    end
    
    [Stats.p.(monkey_id).OFC.slope, Stats.h.(monkey_id).OFC.slope] = signrank(OFC.(monkey_id).stim.slope, OFC.(monkey_id).sham.slope);

    % dmPFC
    
    dmPFC.(monkey_id).stim.slope=[];
    dmPFC.(monkey_id).sham.slope=[];
    dmPFC.(monkey_id).stim.slope_shuffled=[];
    dmPFC.(monkey_id).sham.slope_shuffled=[];
    
    for ndmPFC=1:length(dmPFC_day.(monkey_id))
    
        field_id=char(strcat('data_',dmPFC_day.(monkey_id)(ndmPFC)));
    
        dmPFC.(monkey_id).stim.slope=[dmPFC.(monkey_id).stim.slope mdl.(field_id).stim_real_slope];
        dmPFC.(monkey_id).sham.slope=[dmPFC.(monkey_id).sham.slope mdl.(field_id).sham_real_slope];
        dmPFC.(monkey_id).stim.slope_shuffled=horzcat(dmPFC.(monkey_id).stim.slope_shuffled, mdl.(field_id).stim_shuffled_slope);
        dmPFC.(monkey_id).sham.slope_shuffled=horzcat(dmPFC.(monkey_id).sham.slope_shuffled, mdl.(field_id).sham_shuffled_slope);
    
    end
    
    [Stats.p.(monkey_id).dmPFC.slope, Stats.h.(monkey_id).dmPFC.slope] = signrank(dmPFC.(monkey_id).stim.slope, dmPFC.(monkey_id).sham.slope);

    % ACCg
    
    ACCg.(monkey_id).stim.slope=[];
    ACCg.(monkey_id).sham.slope=[];
    ACCg.(monkey_id).stim.slope_shuffled=[];
    ACCg.(monkey_id).sham.slope_shuffled=[];
    
    for nACCg=1:length(ACCg_day.(monkey_id))
    
        field_id=char(strcat('data_',ACCg_day.(monkey_id)(nACCg)));
    
        ACCg.(monkey_id).stim.slope=[ACCg.(monkey_id).stim.slope mdl.(field_id).stim_real_slope];
        ACCg.(monkey_id).sham.slope=[ACCg.(monkey_id).sham.slope mdl.(field_id).sham_real_slope];
        ACCg.(monkey_id).stim.slope_shuffled=horzcat(ACCg.(monkey_id).stim.slope_shuffled, mdl.(field_id).stim_shuffled_slope);
        ACCg.(monkey_id).sham.slope_shuffled=horzcat(ACCg.(monkey_id).sham.slope_shuffled, mdl.(field_id).sham_shuffled_slope);
    
    end
    
    [Stats.p.(monkey_id).ACCg.slope, Stats.h.(monkey_id).ACCg.slope] = signrank(ACCg.(monkey_id).stim.slope, ACCg.(monkey_id).sham.slope);

end

Kinematics.OFC=OFC;
Kinematics.dmPFC=dmPFC;
Kinematics.ACCg=ACCg;
save('Saccade_Kinematics_Stats_Combined.mat','Stats','-v7.3');
save('Kinematics_Combined.mat','Kinematics','-v7.3');

%% Plotting a dot for each day (slope) and plot true median against shuffled medians

slope_range=-15:0.5:15;

monkey_names={'All', 'Lynch', 'Tarantino'};
    
for nmonkey=1:3
    monkey_id=char(monkey_names(nmonkey));

    % Correlation (peak velocity over amplitude) for sham and stim
        
    figure('Renderer', 'painters', 'Position', [100 1200 1200 700])

    % OFC
     
    subplot(2,3,1)
    
    X=categorical({'Sham','Stim'});
    X=reordercats(X,{'Sham','Stim'});
    Y=[median(Kinematics.OFC.(monkey_id).sham.slope,'omitnan'),median(Kinematics.OFC.(monkey_id).stim.slope,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(OFC_day.(monkey_id)));
    line_hs = cell( length(OFC_day.(monkey_id)), 1 );
    line_labels = cell( size(line_hs) );
    
    for m=1:length(OFC_day.(monkey_id))
        
        scatter(X(1),Kinematics.OFC.(monkey_id).sham.slope(m),30,colorInd(m,:),'filled'); hold on           
        scatter(X(2),Kinematics.OFC.(monkey_id).stim.slope(m),30,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[Kinematics.OFC.(monkey_id).sham.slope(m) Kinematics.OFC.(monkey_id).stim.slope(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = OFC_day.(monkey_id){m};
    
    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
    title('OFC')
    ylim([0 90]);
    yticks([0 30 60 90]);
    ax1=gca; 
    axis(ax1,'square')
    clear X Y m colorInd line_hs line_labels
    
    subplot(2,3,4)
    histogram(median(Kinematics.OFC.(monkey_id).stim.slope_shuffled-Kinematics.OFC.(monkey_id).sham.slope_shuffled,2,'omitnan'),slope_range); hold on
    line([median(Kinematics.OFC.(monkey_id).stim.slope-Kinematics.OFC.(monkey_id).sham.slope,'omitnan') median(Kinematics.OFC.(monkey_id).stim.slope-Kinematics.OFC.(monkey_id).sham.slope,'omitnan')], [0 25],'Color','r');
    title('OFC shuffled')
    xlim([-15 15]);
    xticks([-15 -10 -5 0 5 10 15]);
    ax4=gca; 
    axis(ax4,'square')

    % dmPFC
     
    subplot(2,3,2)
    
    X=categorical({'Sham','Stim'});
    X=reordercats(X,{'Sham','Stim'});
    Y=[median(Kinematics.dmPFC.(monkey_id).sham.slope,'omitnan'),median(Kinematics.dmPFC.(monkey_id).stim.slope,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(dmPFC_day.(monkey_id)));
    line_hs = cell( length(dmPFC_day.(monkey_id)), 1 );
    line_labels = cell( size(line_hs) );
    
    for m=1:length(dmPFC_day.(monkey_id))
        
        scatter(X(1),Kinematics.dmPFC.(monkey_id).sham.slope(m),30,colorInd(m,:),'filled'); hold on           
        scatter(X(2),Kinematics.dmPFC.(monkey_id).stim.slope(m),30,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[Kinematics.dmPFC.(monkey_id).sham.slope(m) Kinematics.dmPFC.(monkey_id).stim.slope(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = dmPFC_day.(monkey_id){m};
    
    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
    title('dmPFC')
    ylim([0 90]);
    yticks([0 30 60 90]);
    ax2=gca; 
    axis(ax2,'square')
    clear X Y m colorInd line_hs line_labels
    
    subplot(2,3,5)
    histogram(median(Kinematics.dmPFC.(monkey_id).stim.slope_shuffled-Kinematics.dmPFC.(monkey_id).sham.slope_shuffled,2,'omitnan'),slope_range); hold on
    line([median(Kinematics.dmPFC.(monkey_id).stim.slope-Kinematics.dmPFC.(monkey_id).sham.slope,'omitnan') median(Kinematics.dmPFC.(monkey_id).stim.slope-Kinematics.dmPFC.(monkey_id).sham.slope,'omitnan')], [0 25],'Color','r');
    title('dmPFC shuffled')
    xlim([-15 15]);
    xticks([-15 -10 -5 0 5 10 15]);
    ax5=gca; 
    axis(ax5,'square')

    % ACCg
     
    subplot(2,3,3)
    
    X=categorical({'Sham','Stim'});
    X=reordercats(X,{'Sham','Stim'});
    Y=[median(Kinematics.ACCg.(monkey_id).sham.slope,'omitnan'),median(Kinematics.ACCg.(monkey_id).stim.slope,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(ACCg_day.(monkey_id)));
    line_hs = cell( length(ACCg_day.(monkey_id)), 1 );
    line_labels = cell( size(line_hs) );
    
    for m=1:length(ACCg_day.(monkey_id))
        
        scatter(X(1),Kinematics.ACCg.(monkey_id).sham.slope(m),30,colorInd(m,:),'filled'); hold on           
        scatter(X(2),Kinematics.ACCg.(monkey_id).stim.slope(m),30,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[Kinematics.ACCg.(monkey_id).sham.slope(m) Kinematics.ACCg.(monkey_id).stim.slope(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = ACCg_day.(monkey_id){m};
    
    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
    title('ACCg')
    ylim([0 90]);
    yticks([0 30 60 90]);
    ax3=gca; 
    axis(ax3,'square')
    clear X Y m colorInd line_hs line_labels
    
    subplot(2,3,6)
    histogram(median(Kinematics.ACCg.(monkey_id).stim.slope_shuffled-Kinematics.ACCg.(monkey_id).sham.slope_shuffled,2,'omitnan'),slope_range); hold on
    line([median(Kinematics.ACCg.(monkey_id).stim.slope-Kinematics.ACCg.(monkey_id).sham.slope,'omitnan') median(Kinematics.ACCg.(monkey_id).stim.slope-Kinematics.ACCg.(monkey_id).sham.slope,'omitnan')], [0 25],'Color','r');
    title('ACCg shuffled')
    xlim([-15 15]);
    xticks([-15 -10 -5 0 5 10 15]);
    ax6=gca; 
    axis(ax6,'square')
   
    linkaxes([ax1,ax2,ax3],'y');
    linkaxes([ax4,ax5,ax6],'y');

    sgtitle(sprintf(['kinematics_' monkey_id]),'Interpreter', 'none')   
    set(gcf, 'Renderer', 'painters');
    saveas(gcf,sprintf(['kinematics_',monkey_id]))
    saveas(gcf,sprintf(['kinematics_',monkey_id,'.jpg']))
    saveas(gcf,sprintf(['kinematics_',monkey_id,'.epsc']))

clf

end
    

%% Stats 

% shuffled test (OFC median is negative, dmPFC and ACCg medians are
% positive)

monkey_names={'All', 'Lynch', 'Tarantino'};
    
for nmonkey=1:3
    monkey_id=char(monkey_names(nmonkey));
    
    OFC_effect=Kinematics.OFC.(monkey_id).stim.slope-Kinematics.OFC.(monkey_id).sham.slope;
    if median(OFC_effect)>0
        percent.OFC.(monkey_id)=sum(median(Kinematics.OFC.(monkey_id).stim.slope_shuffled-Kinematics.OFC.(monkey_id).sham.slope_shuffled,2,'omitnan') > median(OFC_effect))/1000; 
    else
        percent.OFC.(monkey_id)=sum(median(Kinematics.OFC.(monkey_id).stim.slope_shuffled-Kinematics.OFC.(monkey_id).sham.slope_shuffled,2,'omitnan') < median(OFC_effect))/1000; 
    end

    dmPFC_effect=Kinematics.dmPFC.(monkey_id).stim.slope-Kinematics.dmPFC.(monkey_id).sham.slope;
    if median(dmPFC_effect)>0
        percent.dmPFC.(monkey_id)=sum(median(Kinematics.dmPFC.(monkey_id).stim.slope_shuffled-Kinematics.dmPFC.(monkey_id).sham.slope_shuffled,2,'omitnan') > median(dmPFC_effect))/1000; 
    else
        percent.dmPFC.(monkey_id)=sum(median(Kinematics.dmPFC.(monkey_id).stim.slope_shuffled-Kinematics.dmPFC.(monkey_id).sham.slope_shuffled,2,'omitnan') < median(dmPFC_effect))/1000; 
    end

    ACCg_effect=Kinematics.ACCg.(monkey_id).stim.slope-Kinematics.ACCg.(monkey_id).sham.slope;
    if median(ACCg_effect)>0
        percent.ACCg.(monkey_id)=sum(median(Kinematics.ACCg.(monkey_id).stim.slope_shuffled-Kinematics.ACCg.(monkey_id).sham.slope_shuffled,2,'omitnan') > median(ACCg_effect))/1000; 
    else
        percent.ACCg.(monkey_id)=sum(median(Kinematics.ACCg.(monkey_id).stim.slope_shuffled-Kinematics.ACCg.(monkey_id).sham.slope_shuffled,2,'omitnan') < median(ACCg_effect))/1000; 
    end

end

