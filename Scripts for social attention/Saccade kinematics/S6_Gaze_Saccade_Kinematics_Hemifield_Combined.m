%% Divide macrosaccades into four categories (ipsi to ipsi, ipsi to contra, contra to ipsi, contra to contra)

fieldname=fieldnames(Saccade_Day);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
   
    % stim

    if ~isstring(Saccade_Day.(field_id).current_stim.macrosaccade_before)|| ~isstring(Saccade_Day.(field_id).current_stim.macrosaccade_after)
         continue
    else

    % ipsi to ipsi
    ipsi_ipsi_idx = (Saccade_Day.(field_id).current_stim.macrosaccade_before=='ipsi') & (Saccade_Day.(field_id).current_stim.macrosaccade_after=='ipsi'); 
    Saccade_hemifield.(field_id).ipsi_ipsi.stim_amp=Saccade_Day.(field_id).current_stim.macrosaccade_amp(ipsi_ipsi_idx);
    Saccade_hemifield.(field_id).ipsi_ipsi.stim_vel=Saccade_Day.(field_id).current_stim.macrosaccade_vel(ipsi_ipsi_idx);

    % ipsi to contra
    ipsi_contra_idx = (Saccade_Day.(field_id).current_stim.macrosaccade_before=='ipsi') & (Saccade_Day.(field_id).current_stim.macrosaccade_after=='contra'); 
    Saccade_hemifield.(field_id).ipsi_contra.stim_amp=Saccade_Day.(field_id).current_stim.macrosaccade_amp(ipsi_contra_idx);
    Saccade_hemifield.(field_id).ipsi_contra.stim_vel=Saccade_Day.(field_id).current_stim.macrosaccade_vel(ipsi_contra_idx);

    % contra to ipsi
    contra_ipsi_idx = (Saccade_Day.(field_id).current_stim.macrosaccade_before=='contra') & (Saccade_Day.(field_id).current_stim.macrosaccade_after=='ipsi'); 
    Saccade_hemifield.(field_id).contra_ipsi.stim_amp=Saccade_Day.(field_id).current_stim.macrosaccade_amp(contra_ipsi_idx);
    Saccade_hemifield.(field_id).contra_ipsi.stim_vel=Saccade_Day.(field_id).current_stim.macrosaccade_vel(contra_ipsi_idx);

    % contra to contra
    contra_contra_idx = (Saccade_Day.(field_id).current_stim.macrosaccade_before=='contra') & (Saccade_Day.(field_id).current_stim.macrosaccade_after=='contra'); 
    Saccade_hemifield.(field_id).contra_contra.stim_amp=Saccade_Day.(field_id).current_stim.macrosaccade_amp(contra_contra_idx);
    Saccade_hemifield.(field_id).contra_contra.stim_vel=Saccade_Day.(field_id).current_stim.macrosaccade_vel(contra_contra_idx);

    end


    % sham

    if ~isstring(Saccade_Day.(field_id).current_sham.macrosaccade_before)|| ~isstring(Saccade_Day.(field_id).current_sham.macrosaccade_after)
         continue
    else

    % ipsi to ipsi
    ipsi_ipsi_idx = (Saccade_Day.(field_id).current_sham.macrosaccade_before=='ipsi') & (Saccade_Day.(field_id).current_sham.macrosaccade_after=='ipsi'); 
    Saccade_hemifield.(field_id).ipsi_ipsi.sham_amp=Saccade_Day.(field_id).current_sham.macrosaccade_amp(ipsi_ipsi_idx);
    Saccade_hemifield.(field_id).ipsi_ipsi.sham_vel=Saccade_Day.(field_id).current_sham.macrosaccade_vel(ipsi_ipsi_idx);

    % ipsi to contra
    ipsi_contra_idx = (Saccade_Day.(field_id).current_sham.macrosaccade_before=='ipsi') & (Saccade_Day.(field_id).current_sham.macrosaccade_after=='contra'); 
    Saccade_hemifield.(field_id).ipsi_contra.sham_amp=Saccade_Day.(field_id).current_sham.macrosaccade_amp(ipsi_contra_idx);
    Saccade_hemifield.(field_id).ipsi_contra.sham_vel=Saccade_Day.(field_id).current_sham.macrosaccade_vel(ipsi_contra_idx);

    % contra to ipsi
    contra_ipsi_idx = (Saccade_Day.(field_id).current_sham.macrosaccade_before=='contra') & (Saccade_Day.(field_id).current_sham.macrosaccade_after=='ipsi'); 
    Saccade_hemifield.(field_id).contra_ipsi.sham_amp=Saccade_Day.(field_id).current_sham.macrosaccade_amp(contra_ipsi_idx);
    Saccade_hemifield.(field_id).contra_ipsi.sham_vel=Saccade_Day.(field_id).current_sham.macrosaccade_vel(contra_ipsi_idx);

    % contra to contra
    contra_contra_idx = (Saccade_Day.(field_id).current_sham.macrosaccade_before=='contra') & (Saccade_Day.(field_id).current_sham.macrosaccade_after=='contra'); 
    Saccade_hemifield.(field_id).contra_contra.sham_amp=Saccade_Day.(field_id).current_sham.macrosaccade_amp(contra_contra_idx);
    Saccade_hemifield.(field_id).contra_contra.sham_vel=Saccade_Day.(field_id).current_sham.macrosaccade_vel(contra_contra_idx);

    end
    
end

save('Kinematics_Hemifield_Combined.mat','Saccade_hemifield','-v7.3');          

%% Fit a linear regression for saccade velocity over amplitude per day and get stim-sham slope for each combination of directions

fieldname=fieldnames(Saccade_hemifield);
direction={'ipsi_ipsi','ipsi_contra','contra_ipsi','contra_contra'};

for k=1:size(fieldname,1)
    field_id=char(fieldname(k)); 

     for ndirection=1:4
        direction_id=char(direction(ndirection));
      
        stim_real=fitlm(Saccade_hemifield.(field_id).(direction_id).stim_amp,Saccade_hemifield.(field_id).(direction_id).stim_vel);
        sham_real=fitlm(Saccade_hemifield.(field_id).(direction_id).sham_amp,Saccade_hemifield.(field_id).(direction_id).sham_vel);
        mdl.(field_id).(direction_id).stim_real_slope=stim_real.Coefficients.Estimate(2);
        mdl.(field_id).(direction_id).sham_real_slope=sham_real.Coefficients.Estimate(2);
        mdl.(field_id).(direction_id).stim_minus_sham_real_slope=mdl.(field_id).(direction_id).stim_real_slope-mdl.(field_id).(direction_id).sham_real_slope;

        nstim=length(Saccade_hemifield.(field_id).(direction_id).stim_amp);
        nsham=length(Saccade_hemifield.(field_id).(direction_id).sham_amp);
        ntotal=nstim+nsham;
        all_amps=[Saccade_hemifield.(field_id).(direction_id).stim_amp Saccade_hemifield.(field_id).(direction_id).sham_amp];
        all_vels=[Saccade_hemifield.(field_id).(direction_id).stim_vel Saccade_hemifield.(field_id).(direction_id).sham_vel];
    
        for rep=1:1000
        
            n_stim_idx(rep,:)=randperm(ntotal,nstim);
            n_sham_idx(rep,:)=setdiff(1:1:ntotal,n_stim_idx(rep,:));
            stim_amp_shuffled(rep,:)=all_amps(n_stim_idx(rep,:));
            stim_vel_shuffled(rep,:)=all_vels(n_stim_idx(rep,:));
            sham_amp_shuffled(rep,:)=all_amps(n_sham_idx(rep,:));
            sham_vel_shuffled(rep,:)=all_vels(n_sham_idx(rep,:));
            
            stim_shuffled{rep,1}=fitlm(stim_amp_shuffled(rep,:),stim_vel_shuffled(rep,:));
            sham_shuffled{rep,1}=fitlm(sham_amp_shuffled(rep,:),sham_vel_shuffled(rep,:));
    
            mdl.(field_id).(direction_id).stim_shuffled_slope(rep,1)=stim_shuffled{rep,1}.Coefficients.Estimate(2);
            mdl.(field_id).(direction_id).sham_shuffled_slope(rep,1)=sham_shuffled{rep,1}.Coefficients.Estimate(2);

            clear n_stim_idx n_sham_idx stim_amp_shuffled stim_vel_shuffled sham_amp_shuffled sham_vel_shuffled stim_shuffled sham_shuffled

        end  

        clear nstim nsham n_total all_amps all_vels
        clear stim_real sham_real

     end

end

save('Saccade_Kinematics_Hemifield_Linear_Regression_Combined.mat','mdl','-v7.3');        

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

%% Get Stats

monkey_names={'All', 'Lynch', 'Tarantino'};
direction={'ipsi_ipsi','ipsi_contra','contra_ipsi','contra_contra'};
    
for nmonkey=1:3
    monkey_id=char(monkey_names(nmonkey));

    for ndirection=1:4
        direction_id=char(direction(ndirection));

        Saccade_kinematics_hemifield.OFC.(monkey_id).(direction_id).stim_real_slope=[];
        Saccade_kinematics_hemifield.OFC.(monkey_id).(direction_id).sham_real_slope=[];
        
        for nOFC=1:length(OFC_day.(monkey_id))
    
            field_id=char(strcat('data_',OFC_day.(monkey_id)(nOFC)));
    
            Saccade_kinematics_hemifield.OFC.(monkey_id).(direction_id).stim_real_slope=[Saccade_kinematics_hemifield.OFC.(monkey_id).(direction_id).stim_real_slope mdl.(field_id).(direction_id).stim_real_slope];
            Saccade_kinematics_hemifield.OFC.(monkey_id).(direction_id).sham_real_slope=[Saccade_kinematics_hemifield.OFC.(monkey_id).(direction_id).sham_real_slope mdl.(field_id).(direction_id).sham_real_slope];
            
        end
        
        Saccade_kinematics_hemifield.dmPFC.(monkey_id).(direction_id).stim_real_slope=[];
        Saccade_kinematics_hemifield.dmPFC.(monkey_id).(direction_id).sham_real_slope=[];
       
        for ndmPFC=1:length(dmPFC_day.(monkey_id))
    
            field_id=char(strcat('data_',dmPFC_day.(monkey_id)(ndmPFC)));
    
            Saccade_kinematics_hemifield.dmPFC.(monkey_id).(direction_id).stim_real_slope=[Saccade_kinematics_hemifield.dmPFC.(monkey_id).(direction_id).stim_real_slope mdl.(field_id).(direction_id).stim_real_slope];
            Saccade_kinematics_hemifield.dmPFC.(monkey_id).(direction_id).sham_real_slope=[Saccade_kinematics_hemifield.dmPFC.(monkey_id).(direction_id).sham_real_slope mdl.(field_id).(direction_id).sham_real_slope];
           
        end

        Saccade_kinematics_hemifield.ACCg.(monkey_id).(direction_id).stim_real_slope=[];
        Saccade_kinematics_hemifield.ACCg.(monkey_id).(direction_id).sham_real_slope=[];
       
        for nACCg=1:length(ACCg_day.(monkey_id))
    
            field_id=char(strcat('data_',ACCg_day.(monkey_id)(nACCg)));
    
            Saccade_kinematics_hemifield.ACCg.(monkey_id).(direction_id).stim_real_slope=[Saccade_kinematics_hemifield.ACCg.(monkey_id).(direction_id).stim_real_slope mdl.(field_id).(direction_id).stim_real_slope];
            Saccade_kinematics_hemifield.ACCg.(monkey_id).(direction_id).sham_real_slope=[Saccade_kinematics_hemifield.ACCg.(monkey_id).(direction_id).sham_real_slope mdl.(field_id).(direction_id).sham_real_slope];
            
        end
    
        % OFC
        if isequal(sum(~isnan(Saccade_kinematics_hemifield.OFC.(monkey_id).(direction_id).stim_real_slope) & ~isnan(Saccade_kinematics_hemifield.OFC.(monkey_id).(direction_id).sham_real_slope)),0)
            Stats.p.OFC.(monkey_id).(direction_id) = NaN;
            Stats.h.OFC.(monkey_id).(direction_id) = NaN;
        else
            [Stats.p.OFC.(monkey_id).(direction_id), Stats.h.OFC.(monkey_id).(direction_id)] = signrank(Saccade_kinematics_hemifield.OFC.(monkey_id).(direction_id).stim_real_slope, Saccade_kinematics_hemifield.OFC.(monkey_id).(direction_id).sham_real_slope);
        end
        
        % dmPFC
        if isequal(sum(~isnan(Saccade_kinematics_hemifield.dmPFC.(monkey_id).(direction_id).stim_real_slope) & ~isnan(Saccade_kinematics_hemifield.dmPFC.(monkey_id).(direction_id).sham_real_slope)),0)
            Stats.p.dmPFC.(monkey_id).(direction_id) = NaN;
            Stats.h.dmPFC.(monkey_id).(direction_id) = NaN;
        else
            [Stats.p.dmPFC.(monkey_id).(direction_id), Stats.h.dmPFC.(monkey_id).(direction_id)] = signrank(Saccade_kinematics_hemifield.dmPFC.(monkey_id).(direction_id).stim_real_slope, Saccade_kinematics_hemifield.dmPFC.(monkey_id).(direction_id).sham_real_slope);
        end

        % ACCg
        if isequal(sum(~isnan(Saccade_kinematics_hemifield.ACCg.(monkey_id).(direction_id).stim_real_slope) & ~isnan(Saccade_kinematics_hemifield.ACCg.(monkey_id).(direction_id).sham_real_slope)),0)
            Stats.p.ACCg.(monkey_id).(direction_id) = NaN;
            Stats.h.ACCg.(monkey_id).(direction_id) = NaN;
        else
            [Stats.p.ACCg.(monkey_id).(direction_id), Stats.h.ACCg.(monkey_id).(direction_id)] = signrank(Saccade_kinematics_hemifield.ACCg.(monkey_id).(direction_id).stim_real_slope, Saccade_kinematics_hemifield.ACCg.(monkey_id).(direction_id).sham_real_slope);
        end

    end

end

save('Saccade_Kinematics_Hemifield_Stats_Combined.mat','Stats','-v7.3');  
save('Saccade_Kinematics_Hemifield_Data_Combined.mat','Saccade_kinematics_hemifield','-v7.3');  

%% Plotting

monkey_names={'All', 'Lynch', 'Tarantino'};
    
for nmonkey=1:3
    monkey_id=char(monkey_names(nmonkey));

    subplot(1,3,1)

    X=categorical({'ipsi to ipsi','ipsi to contra', 'contra to ipsi', 'contra to contra'});
    X=reordercats(X,{'ipsi to ipsi','ipsi to contra', 'contra to ipsi', 'contra to contra'});

    Y=[median(Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_ipsi.stim_real_slope-Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_ipsi.sham_real_slope,'omitnan') median(Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_contra.stim_real_slope-Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_contra.sham_real_slope,'omitnan')...
        median(Saccade_kinematics_hemifield.OFC.(monkey_id).contra_ipsi.stim_real_slope-Saccade_kinematics_hemifield.OFC.(monkey_id).contra_ipsi.sham_real_slope,'omitnan') median(Saccade_kinematics_hemifield.OFC.(monkey_id).contra_contra.stim_real_slope-Saccade_kinematics_hemifield.OFC.(monkey_id).contra_contra.sham_real_slope,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(OFC_day.(monkey_id)));
    line_hs=cell(length(OFC_day.(monkey_id)),1);
    line_labels=cell( size(line_hs));
    
    for m=1:length(OFC_day.(monkey_id))
        
        scatter(X(1),(Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_ipsi.sham_real_slope(m)),30,colorInd(m,:),'filled'); hold on   
        scatter(X(2),(Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_contra.sham_real_slope(m)),30,colorInd(m,:),'filled'); hold on   
        scatter(X(3),(Saccade_kinematics_hemifield.OFC.(monkey_id).contra_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.OFC.(monkey_id).contra_ipsi.sham_real_slope(m)),30,colorInd(m,:),'filled'); hold on   
        scatter(X(4),(Saccade_kinematics_hemifield.OFC.(monkey_id).contra_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.OFC.(monkey_id).contra_contra.sham_real_slope(m)),30,colorInd(m,:),'filled'); hold on   
       
        line_hs{m} = line([X(1) X(2)],[Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_ipsi.sham_real_slope(m) Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_contra.sham_real_slope(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.OFC.(monkey_id).ipsi_contra.sham_real_slope(m) Saccade_kinematics_hemifield.OFC.(monkey_id).contra_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.OFC.(monkey_id).contra_ipsi.sham_real_slope(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(3) X(4)],[Saccade_kinematics_hemifield.OFC.(monkey_id).contra_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.OFC.(monkey_id).contra_ipsi.sham_real_slope(m) Saccade_kinematics_hemifield.OFC.(monkey_id).contra_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.OFC.(monkey_id).contra_contra.sham_real_slope(m)], 'Color',colorInd(m,:)); hold on     
        line_labels{m} = OFC_day.(monkey_id){m};
    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);

    title('OFC')
    ax1=gca; 
    axis(ax1,'square');
    ylim([-500 500]);
    yticks([-500 -400 -300 -200 -100 0 100 200 300 400 500]);
    clear X Y m colorInd line_hs line_labels

    subplot(1,3,2)

    X=categorical({'ipsi to ipsi','ipsi to contra', 'contra to ipsi', 'contra to contra'});
    X=reordercats(X,{'ipsi to ipsi','ipsi to contra', 'contra to ipsi', 'contra to contra'});
    
    Y=[median(Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_ipsi.stim_real_slope-Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_ipsi.sham_real_slope,'omitnan') median(Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_contra.stim_real_slope-Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_contra.sham_real_slope,'omitnan')...
        median(Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_ipsi.stim_real_slope-Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_ipsi.sham_real_slope,'omitnan') median(Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_contra.stim_real_slope-Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_contra.sham_real_slope,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(dmPFC_day.(monkey_id)));
    line_hs=cell(length(dmPFC_day.(monkey_id)),1);
    line_labels=cell( size(line_hs));
    
    for m=1:length(dmPFC_day.(monkey_id))
        
        scatter(X(1),(Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_ipsi.sham_real_slope(m)),30,colorInd(m,:),'filled'); hold on   
        scatter(X(2),(Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_contra.sham_real_slope(m)),30,colorInd(m,:),'filled'); hold on   
        scatter(X(3),(Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_ipsi.sham_real_slope(m)),30,colorInd(m,:),'filled'); hold on   
        scatter(X(4),(Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_contra.sham_real_slope(m)),30,colorInd(m,:),'filled'); hold on   
       
        line_hs{m} = line([X(1) X(2)],[Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_ipsi.sham_real_slope(m) Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_contra.sham_real_slope(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.dmPFC.(monkey_id).ipsi_contra.sham_real_slope(m) Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_ipsi.sham_real_slope(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(3) X(4)],[Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_ipsi.sham_real_slope(m) Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.dmPFC.(monkey_id).contra_contra.sham_real_slope(m)], 'Color',colorInd(m,:)); hold on     
        line_labels{m} = dmPFC_day.(monkey_id){m};
    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
    title('dmPFC')
    ax2=gca; 
    axis(ax2,'square');
    ylim([-500 500]);
    yticks([-500 -400 -300 -200 -100 0 100 200 300 400 500]);
    clear X Y m colorInd line_hs line_labels

    subplot(1,3,3)

    X=categorical({'ipsi to ipsi','ipsi to contra', 'contra to ipsi', 'contra to contra'});
    X=reordercats(X,{'ipsi to ipsi','ipsi to contra', 'contra to ipsi', 'contra to contra'});
    
    Y=[median(Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_ipsi.stim_real_slope-Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_ipsi.sham_real_slope,'omitnan') median(Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_contra.stim_real_slope-Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_contra.sham_real_slope,'omitnan')...
        median(Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_ipsi.stim_real_slope-Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_ipsi.sham_real_slope,'omitnan') median(Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_contra.stim_real_slope-Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_contra.sham_real_slope,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(ACCg_day.(monkey_id)));
    line_hs=cell(length(ACCg_day.(monkey_id)),1);
    line_labels=cell( size(line_hs));
    
    for m=1:length(ACCg_day.(monkey_id))
        
        scatter(X(1),(Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_ipsi.sham_real_slope(m)),30,colorInd(m,:),'filled'); hold on   
        scatter(X(2),(Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_contra.sham_real_slope(m)),30,colorInd(m,:),'filled'); hold on   
        scatter(X(3),(Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_ipsi.sham_real_slope(m)),30,colorInd(m,:),'filled'); hold on   
        scatter(X(4),(Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_contra.sham_real_slope(m)),30,colorInd(m,:),'filled'); hold on   
       
        line_hs{m} = line([X(1) X(2)],[Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_ipsi.sham_real_slope(m) Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_contra.sham_real_slope(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.ACCg.(monkey_id).ipsi_contra.sham_real_slope(m) Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_ipsi.sham_real_slope(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(3) X(4)],[Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_ipsi.stim_real_slope(m)-Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_ipsi.sham_real_slope(m) Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_contra.stim_real_slope(m)-Saccade_kinematics_hemifield.ACCg.(monkey_id).contra_contra.sham_real_slope(m)], 'Color',colorInd(m,:)); hold on     
        line_labels{m} = ACCg_day.(monkey_id){m};
    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
    title('ACCg')
    ax3=gca; 
    axis(ax3,'square');
    ylim([-500 500]);
    yticks([-500 -400 -300 -200 -100 0 100 200 300 400 500]);
    clear X Y m colorInd line_hs line_labels
                
    linkaxes([ax1,ax2,ax3],'y');

    sgtitle(sprintf(['kinematics_hemifield_' monkey_id]),'Interpreter', 'none')   
    set(gcf, 'Renderer', 'painters');
    saveas(gcf,sprintf(['kinematics_hemifield_',monkey_id]))
    saveas(gcf,sprintf(['kinematics_hemifield_',monkey_id, '.jpg']))
    saveas(gcf,sprintf(['kinematics_hemifield_',monkey_id, '.epsc']))

    clf

end
