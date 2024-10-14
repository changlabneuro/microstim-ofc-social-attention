%% Total number of stim/sham per day

% Upload Gaze_Basic_Behavior_Day_Combined.mat from Basic behaviors, 0_1.5
% folder

fieldname=fieldnames(Gaze_Day);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
   
    Number_Gaze.(field_id).stim=size(Gaze_Day.(field_id).current_stim.fixation_m1_eye_number,2);
    Number_Gaze.(field_id).sham=size(Gaze_Day.(field_id).current_sham.fixation_m1_eye_number,2);
    
end

% Upload Dot_Basic_Behavior_Day_Combined.mat from Basic behaviors, 0_1.5
% folder

fieldname=fieldnames(Dot_Day);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
   
    Number_Dot.(field_id).stim=size(Dot_Day.(field_id).current_stim.fixation_m1_eye_number,2);
    Number_Dot.(field_id).sham=size(Dot_Day.(field_id).current_sham.fixation_m1_eye_number,2);
    
end

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

%% Collapse data across days for each region

monkey_names={'All', 'Lynch', 'Tarantino'};

for nmonkey=1:3
    monkey_id=char(monkey_names(nmonkey));

    Number.(monkey_id).OFC.gaze_stim=[];
    Number.(monkey_id).OFC.gaze_sham=[];
    Number.(monkey_id).OFC.dot_stim=[];
    Number.(monkey_id).OFC.dot_sham=[];

    for nOFC=1:length(OFC_day.(monkey_id))

        field_id=char(strcat('data_',OFC_day.(monkey_id)(nOFC)));
        Number.(monkey_id).OFC.gaze_stim=[Number.(monkey_id).OFC.gaze_stim Number_Gaze.(field_id).stim];
        Number.(monkey_id).OFC.gaze_sham=[Number.(monkey_id).OFC.gaze_sham Number_Gaze.(field_id).sham];
        Number.(monkey_id).OFC.dot_stim=[Number.(monkey_id).OFC.dot_stim Number_Dot.(field_id).stim];
        Number.(monkey_id).OFC.dot_sham=[Number.(monkey_id).OFC.dot_sham Number_Dot.(field_id).sham];

    end

    Number.(monkey_id).dmPFC.gaze_stim=[];
    Number.(monkey_id).dmPFC.gaze_sham=[];
    Number.(monkey_id).dmPFC.dot_stim=[];
    Number.(monkey_id).dmPFC.dot_sham=[];

    for ndmPFC=1:length(dmPFC_day.(monkey_id))

        field_id=char(strcat('data_',dmPFC_day.(monkey_id)(ndmPFC)));
        Number.(monkey_id).dmPFC.gaze_stim=[Number.(monkey_id).dmPFC.gaze_stim Number_Gaze.(field_id).stim];
        Number.(monkey_id).dmPFC.gaze_sham=[Number.(monkey_id).dmPFC.gaze_sham Number_Gaze.(field_id).sham];
        Number.(monkey_id).dmPFC.dot_stim=[Number.(monkey_id).dmPFC.dot_stim Number_Dot.(field_id).stim];
        Number.(monkey_id).dmPFC.dot_sham=[Number.(monkey_id).dmPFC.dot_sham Number_Dot.(field_id).sham];
        
    end

    Number.(monkey_id).ACCg.gaze_stim=[];
    Number.(monkey_id).ACCg.gaze_sham=[];
    Number.(monkey_id).ACCg.dot_stim=[];
    Number.(monkey_id).ACCg.dot_sham=[];

    for nACCg=1:length(ACCg_day.(monkey_id))

        field_id=char(strcat('data_',ACCg_day.(monkey_id)(nACCg)));
        Number.(monkey_id).ACCg.gaze_stim=[Number.(monkey_id).ACCg.gaze_stim Number_Gaze.(field_id).stim];
        Number.(monkey_id).ACCg.gaze_sham=[Number.(monkey_id).ACCg.gaze_sham Number_Gaze.(field_id).sham];
        Number.(monkey_id).ACCg.dot_stim=[Number.(monkey_id).ACCg.dot_stim Number_Dot.(field_id).stim];
        Number.(monkey_id).ACCg.dot_sham=[Number.(monkey_id).ACCg.dot_sham Number_Dot.(field_id).sham];
        
    end

end

save('Number_of_Stim_Combined.mat','Number','-v7.3')

%% Get Stats

monkey_names={'All', 'Lynch', 'Tarantino'};

for nmonkey=1:3

    monkey_id=char(monkey_names(nmonkey));

    [Stats.Gaze.(monkey_id).stim.OFC_dmPFC.p, Stats.Gaze.(monkey_id).stim.OFC_dmPFC.h] = ranksum(Number.(monkey_id).OFC.gaze_stim, Number.(monkey_id).dmPFC.gaze_stim);
    [Stats.Gaze.(monkey_id).stim.dmPFC_ACCg.p, Stats.Gaze.(monkey_id).stim.dmPFC_ACCg.h] = ranksum(Number.(monkey_id).dmPFC.gaze_stim, Number.(monkey_id).ACCg.gaze_stim);
    [Stats.Gaze.(monkey_id).stim.ACCg_OFC.p, Stats.Gaze.(monkey_id).stim.ACCg_OFC.h] = ranksum(Number.(monkey_id).ACCg.gaze_stim, Number.(monkey_id).OFC.gaze_stim);

    [Stats.Dot.(monkey_id).stim.OFC_dmPFC.p, Stats.Dot.(monkey_id).stim.OFC_dmPFC.h] = ranksum(Number.(monkey_id).OFC.dot_stim, Number.(monkey_id).dmPFC.dot_stim);
    [Stats.Dot.(monkey_id).stim.dmPFC_ACCg.p, Stats.Dot.(monkey_id).stim.dmPFC_ACCg.h] = ranksum(Number.(monkey_id).dmPFC.dot_stim, Number.(monkey_id).ACCg.dot_stim);
    [Stats.Dot.(monkey_id).stim.ACCg_OFC.p, Stats.Dot.(monkey_id).stim.ACCg_OFC.h] = ranksum(Number.(monkey_id).ACCg.dot_stim, Number.(monkey_id).OFC.dot_stim);
    
    [Stats.Gaze.(monkey_id).sham.OFC_dmPFC.p, Stats.Gaze.(monkey_id).sham.OFC_dmPFC.h] = ranksum(Number.(monkey_id).OFC.gaze_sham, Number.(monkey_id).dmPFC.gaze_sham);
    [Stats.Gaze.(monkey_id).sham.dmPFC_ACCg.p, Stats.Gaze.(monkey_id).sham.dmPFC_ACCg.h] = ranksum(Number.(monkey_id).dmPFC.gaze_sham, Number.(monkey_id).ACCg.gaze_sham);
    [Stats.Gaze.(monkey_id).sham.ACCg_OFC.p, Stats.Gaze.(monkey_id).sham.ACCg_OFC.h] = ranksum(Number.(monkey_id).ACCg.gaze_sham, Number.(monkey_id).OFC.gaze_sham);

    [Stats.Dot.(monkey_id).sham.OFC_dmPFC.p, Stats.Dot.(monkey_id).sham.OFC_dmPFC.h] = ranksum(Number.(monkey_id).OFC.dot_sham, Number.(monkey_id).dmPFC.dot_sham);
    [Stats.Dot.(monkey_id).sham.dmPFC_ACCg.p, Stats.Dot.(monkey_id).sham.dmPFC_ACCg.h] = ranksum(Number.(monkey_id).dmPFC.dot_sham, Number.(monkey_id).ACCg.dot_sham);
    [Stats.Dot.(monkey_id).sham.ACCg_OFC.p, Stats.Dot.(monkey_id).sham.ACCg_OFC.h] = ranksum(Number.(monkey_id).ACCg.dot_sham, Number.(monkey_id).OFC.dot_sham);
    
end

[Stats.Gaze.LynchTarantino.stim.OFC.p, Stats.Gaze.LynchTarantino.stim.OFC.h] = ranksum(Number.Lynch.OFC.gaze_stim, Number.Tarantino.OFC.gaze_stim);
[Stats.Gaze.LynchTarantino.stim.dmPFC.p, Stats.Gaze.LynchTarantino.stim.dmPFC.h] = ranksum(Number.Lynch.dmPFC.gaze_stim, Number.Tarantino.dmPFC.gaze_stim);
[Stats.Gaze.LynchTarantino.stim.ACCg.p, Stats.Gaze.LynchTarantino.stim.ACCg.h] = ranksum(Number.Lynch.ACCg.gaze_stim, Number.Tarantino.ACCg.gaze_stim);

[Stats.Dot.LynchTarantino.stim.OFC.p, Stats.Dot.LynchTarantino.stim.OFC.h] = ranksum(Number.Lynch.OFC.dot_stim, Number.Tarantino.OFC.dot_stim);
[Stats.Dot.LynchTarantino.stim.dmPFC.p, Stats.Dot.LynchTarantino.stim.dmPFC.h] = ranksum(Number.Lynch.dmPFC.dot_stim, Number.Tarantino.dmPFC.dot_stim);
[Stats.Dot.LynchTarantino.stim.ACCg.p, Stats.Dot.LynchTarantino.stim.ACCg.h] = ranksum(Number.Lynch.ACCg.dot_stim, Number.Tarantino.ACCg.dot_stim);

[Stats.Gaze.LynchTarantino.sham.OFC.p, Stats.Gaze.LynchTarantino.sham.OFC.h] = ranksum(Number.Lynch.OFC.gaze_sham, Number.Tarantino.OFC.gaze_sham);
[Stats.Gaze.LynchTarantino.sham.dmPFC.p, Stats.Gaze.LynchTarantino.sham.dmPFC.h] = ranksum(Number.Lynch.dmPFC.gaze_sham, Number.Tarantino.dmPFC.gaze_sham);
[Stats.Gaze.LynchTarantino.sham.ACCg.p, Stats.Gaze.LynchTarantino.sham.ACCg.h] = ranksum(Number.Lynch.ACCg.gaze_sham, Number.Tarantino.ACCg.gaze_sham);

[Stats.Dot.LynchTarantino.sham.OFC.p, Stats.Dot.LynchTarantino.sham.OFC.h] = ranksum(Number.Lynch.OFC.dot_sham, Number.Tarantino.OFC.dot_sham);
[Stats.Dot.LynchTarantino.sham.dmPFC.p, Stats.Dot.LynchTarantino.sham.dmPFC.h] = ranksum(Number.Lynch.dmPFC.dot_sham, Number.Tarantino.dmPFC.dot_sham);
[Stats.Dot.LynchTarantino.sham.ACCg.p, Stats.Dot.LynchTarantino.sham.ACCg.h] = ranksum(Number.Lynch.ACCg.dot_sham, Number.Tarantino.ACCg.dot_sham);

save('Stats_Number_of_Stim_Combined.mat','Stats','-v7.3')

%% fdr correction

% Social 

total_number_social_stim_p_raw=[Stats.Gaze.All.stim.OFC_dmPFC.p Stats.Gaze.All.stim.dmPFC_ACCg.p Stats.Gaze.All.stim.ACCg_OFC.p...
    Stats.Gaze.Lynch.stim.OFC_dmPFC.p Stats.Gaze.Lynch.stim.dmPFC_ACCg.p Stats.Gaze.Lynch.stim.ACCg_OFC.p...
    Stats.Gaze.Tarantino.stim.OFC_dmPFC.p Stats.Gaze.Tarantino.stim.dmPFC_ACCg.p Stats.Gaze.Tarantino.stim.ACCg_OFC.p...
    Stats.Gaze.LynchTarantino.stim.OFC.p Stats.Gaze.LynchTarantino.stim.dmPFC.p Stats.Gaze.LynchTarantino.stim.ACCg.p];
total_number_social_stim_p_correct=dsp3.fdr(total_number_social_stim_p_raw);

total_number_social_sham_p_raw=[Stats.Gaze.All.sham.OFC_dmPFC.p Stats.Gaze.All.sham.dmPFC_ACCg.p Stats.Gaze.All.sham.ACCg_OFC.p...
    Stats.Gaze.Lynch.sham.OFC_dmPFC.p Stats.Gaze.Lynch.sham.dmPFC_ACCg.p Stats.Gaze.Lynch.sham.ACCg_OFC.p...
    Stats.Gaze.Tarantino.sham.OFC_dmPFC.p Stats.Gaze.Tarantino.sham.dmPFC_ACCg.p Stats.Gaze.Tarantino.sham.ACCg_OFC.p...
    Stats.Gaze.LynchTarantino.sham.OFC.p Stats.Gaze.LynchTarantino.sham.dmPFC.p Stats.Gaze.LynchTarantino.sham.ACCg.p];
total_number_social_sham_p_correct=dsp3.fdr(total_number_social_sham_p_raw);

% Non-social

total_number_nonsocial_stim_p_raw=[Stats.Dot.All.stim.OFC_dmPFC.p Stats.Dot.All.stim.dmPFC_ACCg.p Stats.Dot.All.stim.ACCg_OFC.p...
    Stats.Dot.Lynch.stim.OFC_dmPFC.p Stats.Dot.Lynch.stim.dmPFC_ACCg.p Stats.Dot.Lynch.stim.ACCg_OFC.p...
    Stats.Dot.Tarantino.stim.OFC_dmPFC.p Stats.Dot.Tarantino.stim.dmPFC_ACCg.p Stats.Dot.Tarantino.stim.ACCg_OFC.p...
    Stats.Dot.LynchTarantino.stim.OFC.p Stats.Dot.LynchTarantino.stim.dmPFC.p Stats.Dot.LynchTarantino.stim.ACCg.p];
total_number_nonsocial_stim_p_correct=dsp3.fdr(total_number_nonsocial_stim_p_raw);

total_number_nonsocial_sham_p_raw=[Stats.Dot.All.sham.OFC_dmPFC.p Stats.Dot.All.sham.dmPFC_ACCg.p Stats.Dot.All.sham.ACCg_OFC.p...
    Stats.Dot.Lynch.sham.OFC_dmPFC.p Stats.Dot.Lynch.sham.dmPFC_ACCg.p Stats.Dot.Lynch.sham.ACCg_OFC.p...
    Stats.Dot.Tarantino.sham.OFC_dmPFC.p Stats.Dot.Tarantino.sham.dmPFC_ACCg.p Stats.Dot.Tarantino.sham.ACCg_OFC.p...
    Stats.Dot.LynchTarantino.sham.OFC.p Stats.Dot.LynchTarantino.sham.dmPFC.p Stats.Dot.LynchTarantino.sham.ACCg.p];
total_number_nonsocial_sham_p_correct=dsp3.fdr(total_number_nonsocial_sham_p_raw);

%% Plotting

subplot (2,2,1)

X=categorical({'Gaze OFC Stim','Gaze OFC Sham','Gaze dmPFC Stim','Gaze dmPFC Sham','Gaze ACCg Stim','Gaze ACCg Sham'});
X=reordercats(X,{'Gaze OFC Stim','Gaze OFC Sham','Gaze dmPFC Stim','Gaze dmPFC Sham','Gaze ACCg Stim','Gaze ACCg Sham'});

for m=1:length(Number.Lynch.OFC.gaze_stim)
    
    scatter(X(1), Number.Lynch.OFC.gaze_stim(m),50,'filled','r'); hold on   
    scatter(X(2), Number.Lynch.OFC.gaze_sham(m),50,'filled','k'); hold on   
    scatter(X(3), Number.Lynch.dmPFC.gaze_stim(m),50,'filled','r'); hold on   
    scatter(X(4), Number.Lynch.dmPFC.gaze_sham(m),50,'filled','k'); hold on   
    scatter(X(5), Number.Lynch.ACCg.gaze_stim(m),50,'filled','r'); hold on   
    scatter(X(6), Number.Lynch.ACCg.gaze_sham(m),50,'filled','k'); hold on   
    
    line([X(1) X(2)],[Number.Lynch.OFC.gaze_stim(m) Number.Lynch.OFC.gaze_sham(m)],'Color','k'); hold on
    line([X(3) X(4)],[Number.Lynch.dmPFC.gaze_stim(m) Number.Lynch.dmPFC.gaze_sham(m)],'Color','k'); hold on
    line([X(5) X(6)],[Number.Lynch.ACCg.gaze_stim(m) Number.Lynch.ACCg.gaze_sham(m)],'Color','k'); hold on
    
end

title('Social Lynch')
ax1=gca; 
ylim([30 180]);
yticks([30 80 130 180]);

subplot (2,2,2)

X=categorical({'Gaze OFC Stim','Gaze OFC Sham','Gaze dmPFC Stim','Gaze dmPFC Sham','Gaze ACCg Stim','Gaze ACCg Sham'});
X=reordercats(X,{'Gaze OFC Stim','Gaze OFC Sham','Gaze dmPFC Stim','Gaze dmPFC Sham','Gaze ACCg Stim','Gaze ACCg Sham'});

for m=1:length(Number.Tarantino.OFC.gaze_stim)
    
    scatter(X(1), Number.Tarantino.OFC.gaze_stim(m),50,'filled','r'); hold on   
    scatter(X(2), Number.Tarantino.OFC.gaze_sham(m),50,'filled','k'); hold on   
    scatter(X(3), Number.Tarantino.dmPFC.gaze_stim(m),50,'filled','r'); hold on   
    scatter(X(4), Number.Tarantino.dmPFC.gaze_sham(m),50,'filled','k'); hold on   
    scatter(X(5), Number.Tarantino.ACCg.gaze_stim(m),50,'filled','r'); hold on   
    scatter(X(6), Number.Tarantino.ACCg.gaze_sham(m),50,'filled','k'); hold on   
    
    line([X(1) X(2)],[Number.Tarantino.OFC.gaze_stim(m) Number.Tarantino.OFC.gaze_sham(m)],'Color','k'); hold on
    line([X(3) X(4)],[Number.Tarantino.dmPFC.gaze_stim(m) Number.Tarantino.dmPFC.gaze_sham(m)],'Color','k'); hold on
    line([X(5) X(6)],[Number.Tarantino.ACCg.gaze_stim(m) Number.Tarantino.ACCg.gaze_sham(m)],'Color','k'); hold on
    
end

title('Social Tarantino')
ax2=gca; 
ylim([30 180]);
yticks([30 80 130 180]);

subplot (2,2,3)

X=categorical({'Dot OFC Stim','Dot OFC Sham','Dot dmPFC Stim','Dot dmPFC Sham','Dot ACCg Stim','Dot ACCg Sham'});
X=reordercats(X,{'Dot OFC Stim','Dot OFC Sham','Dot dmPFC Stim','Dot dmPFC Sham','Dot ACCg Stim','Dot ACCg Sham'});

for m=1:length(Number.Lynch.OFC.dot_stim)
    
    scatter(X(1), Number.Lynch.OFC.dot_stim(m),50,'filled','r'); hold on   
    scatter(X(2), Number.Lynch.OFC.dot_sham(m),50,'filled','k'); hold on   
    scatter(X(3), Number.Lynch.dmPFC.dot_stim(m),50,'filled','r'); hold on   
    scatter(X(4), Number.Lynch.dmPFC.dot_sham(m),50,'filled','k'); hold on   
    scatter(X(5), Number.Lynch.ACCg.dot_stim(m),50,'filled','r'); hold on   
    scatter(X(6), Number.Lynch.ACCg.dot_sham(m),50,'filled','k'); hold on   
    
    line([X(1) X(2)],[Number.Lynch.OFC.dot_stim(m) Number.Lynch.OFC.dot_sham(m)],'Color','k'); hold on
    line([X(3) X(4)],[Number.Lynch.dmPFC.dot_stim(m) Number.Lynch.dmPFC.dot_sham(m)],'Color','k'); hold on
    line([X(5) X(6)],[Number.Lynch.ACCg.dot_stim(m) Number.Lynch.ACCg.dot_sham(m)],'Color','k'); hold on
    
end

title('Non-social Lynch')
ax3=gca; 
ylim([0 120]);
yticks([0 40 80 120]);

subplot (2,2,4)

X=categorical({'Dot OFC Stim','Dot OFC Sham','Dot dmPFC Stim','Dot dmPFC Sham','Dot ACCg Stim','Dot ACCg Sham'});
X=reordercats(X,{'Dot OFC Stim','Dot OFC Sham','Dot dmPFC Stim','Dot dmPFC Sham','Dot ACCg Stim','Dot ACCg Sham'});

for m=1:length(Number.Tarantino.OFC.dot_stim)
    
    scatter(X(1), Number.Tarantino.OFC.dot_stim(m),50,'filled','r'); hold on   
    scatter(X(2), Number.Tarantino.OFC.dot_sham(m),50,'filled','k'); hold on   
    scatter(X(3), Number.Tarantino.dmPFC.dot_stim(m),50,'filled','r'); hold on   
    scatter(X(4), Number.Tarantino.dmPFC.dot_sham(m),50,'filled','k'); hold on   
    scatter(X(5), Number.Tarantino.ACCg.dot_stim(m),50,'filled','r'); hold on   
    scatter(X(6), Number.Tarantino.ACCg.dot_sham(m),50,'filled','k'); hold on   
    
    line([X(1) X(2)],[Number.Tarantino.OFC.dot_stim(m) Number.Tarantino.OFC.dot_sham(m)],'Color','k'); hold on
    line([X(3) X(4)],[Number.Tarantino.dmPFC.dot_stim(m) Number.Tarantino.dmPFC.dot_sham(m)],'Color','k'); hold on
    line([X(5) X(6)],[Number.Tarantino.ACCg.dot_stim(m) Number.Tarantino.ACCg.dot_sham(m)],'Color','k'); hold on
    
end

title('Non-social Tarantino')
ax4=gca; 
ylim([0 120]);
yticks([0 40 80 120]);

linkaxes([ax1,ax2],'y');
linkaxes([ax3,ax4],'y');
        
sgtitle(sprintf('Number of stim/sham'),'Interpreter', 'none')   
set(gcf, 'Renderer', 'painters');
saveas(gcf,'Number of stim or sham')
saveas(gcf,'Number of stim or sham.jpg')
saveas(gcf,'Number of stim or sham.epsc')
