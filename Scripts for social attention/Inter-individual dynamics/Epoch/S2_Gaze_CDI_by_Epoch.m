%% Causal decomposition index by time epoch (late-early for sitm and sham)

% Upload Decomp_Temporal_Combined.mat 

fieldname=fieldnames(Decomp_Temporal);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));

    if ~isempty(Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true)
    
        Epoch_diff.(field_id).stim_late=mean(Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true,'omitnan');
        Epoch_diff.(field_id).stim_early=mean(Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true,'omitnan');
        Epoch_diff.(field_id).sham_late=mean(Decomp_Temporal.(field_id).stim_46_90.sham.causal_m1m2_eyes_true,'omitnan');
        Epoch_diff.(field_id).sham_early=mean(Decomp_Temporal.(field_id).stim_1_45.sham.causal_m1m2_eyes_true,'omitnan');
        Epoch_diff.(field_id).stim_diff=Epoch_diff.(field_id).stim_late-Epoch_diff.(field_id).stim_early;
        Epoch_diff.(field_id).sham_diff=Epoch_diff.(field_id).sham_late-Epoch_diff.(field_id).sham_early;
    
    end

end

%% Variables and day information 

% 76 days with more than 90 stims 
% Five days excluded: 08122019 OFC Lynch, 11042021 Tarantino ACCg, 11052021 Tarantino dmPFC, 12172021 Tarantino dmPFC, 12222021 Tarantino OFC)

% All days
OFC_day.All={'07202019'  '07312019'  '08052019'   '08292019' ...
    '09052019'  '09192019'  '10012019'  '11052019'   '12122019' ...  
    '12182019'  '01032020'  '01102020'  '01242020'  '02022020'...
    '11082021'   '01032022'  '01212022'  '01282022'...
    '02032022'  '02092022'  '02152022'  '02192022'  '02242022'...
    '02282022'  '03172022'}; 

ACCg_day.All={'07222019'  '08022019'  '08072019'  '08232019'  '09172019' ...
    '09242019'  '09282019'  '10102019'  '12092019'  '12132019' ...
    '01072020'  '01172020'  '01272020'  '01312020'  '02072020'...
    '12292021'  '01202022'  '01312022'  '02212022'...
    '03242022'  '04192022'  '04262022'  '05172022'  '05242022'...
    '05272022'  '05302022'};  

dmPFC_day.All={'07182019','07262019'  '08092019'  '08142019'  '08212019' ...
    '09032019'  '09222019'  '10042019'  '12052019'  '12102019' ...
    '12162019'  '01022020'  '01132020'  '01222020'  '02062020'...
    '01242022'  '02122022'  '03052022'...
    '03182022'  '04012022'  '05032022'  '05122022'  '05142022'...
    '05192022'  '05262022'};  

% Lynch days
OFC_day.Lynch={'07202019'  '07312019'  '08052019'  '08292019' ...
    '09052019'  '09192019'  '10012019'  '11052019'   '12122019' ...  
    '12182019'  '01032020'  '01102020'  '01242020'  '02022020'};  
ACCg_day.Lynch={'07222019'  '08022019'  '08072019'  '08232019'  '09172019' ...
    '09242019'  '09282019'  '10102019'  '12092019'  '12132019' ...
    '01072020'  '01172020'  '01272020'  '01312020'  '02072020'};  
dmPFC_day.Lynch={'07182019','07262019'  '08092019'  '08142019'  '08212019' ...
    '09032019'  '09222019'  '10042019'  '12052019'  '12102019' ...
    '12162019'  '01022020'  '01132020'  '01222020'  '02062020'};            

% Tarantino days
OFC_day.Tarantino={'11082021'  '01032022'  '01212022'  '01282022'...
    '02032022'  '02092022'  '02152022'  '02192022'  '02242022'...
    '02282022'  '03172022'}; 
ACCg_day.Tarantino={'12292021'  '01202022'  '01312022'  '02212022'...
    '03242022'  '04192022'  '04262022'  '05172022'  '05242022'...
    '05272022'  '05302022'};  
dmPFC_day.Tarantino={'01242022'  '02122022'  '03052022'...
    '03182022'  '04012022'  '05032022'  '05122022'  '05142022'...
    '05192022'  '05262022'};  

%% Collapse data for each region (causal decomposition index; no stim effect on the index)

monkey_names={'All', 'Lynch', 'Tarantino'};
    
for nmonkey=1:3
    monkey_id=char(monkey_names(nmonkey));
    
    OFC.(monkey_id).stim_late=[];
    OFC.(monkey_id).stim_early=[];
    OFC.(monkey_id).sham_late=[];
    OFC.(monkey_id).sham_early=[];
    OFC.(monkey_id).stim_diff=[];
    OFC.(monkey_id).sham_diff=[];

    for nOFC=1:length(OFC_day.(monkey_id))

        field_id=char(strcat('data_',OFC_day.(monkey_id)(nOFC)));

        OFC.(monkey_id).stim_late=[OFC.(monkey_id).stim_late Epoch_diff.(field_id).stim_late];
        OFC.(monkey_id).stim_early=[OFC.(monkey_id).stim_early Epoch_diff.(field_id).stim_early];
        OFC.(monkey_id).sham_late=[OFC.(monkey_id).sham_late Epoch_diff.(field_id).sham_late];
        OFC.(monkey_id).sham_early=[OFC.(monkey_id).sham_early Epoch_diff.(field_id).sham_early];
        OFC.(monkey_id).stim_diff=[OFC.(monkey_id).stim_diff Epoch_diff.(field_id).stim_diff];
        OFC.(monkey_id).sham_diff=[OFC.(monkey_id).sham_diff Epoch_diff.(field_id).sham_diff];

    end

    [Stats.p.(monkey_id).OFC.early, Stats.h.(monkey_id).OFC.early] = signrank(OFC.(monkey_id).stim_early,OFC.(monkey_id).sham_early);
    [Stats.p.(monkey_id).OFC.late, Stats.h.(monkey_id).OFC.late] = signrank(OFC.(monkey_id).stim_late,OFC.(monkey_id).sham_late);
    [Stats.p.(monkey_id).OFC.diff, Stats.h.(monkey_id).OFC.diff] = signrank(OFC.(monkey_id).stim_diff,OFC.(monkey_id).sham_diff);
    [Stats.p.(monkey_id).OFC.stim, Stats.h.(monkey_id).OFC.stim] = signrank(OFC.(monkey_id).stim_late,OFC.(monkey_id).stim_early);
    [Stats.p.(monkey_id).OFC.sham, Stats.h.(monkey_id).OFC.sham] = signrank(OFC.(monkey_id).sham_late,OFC.(monkey_id).sham_early);

    dmPFC.(monkey_id).stim_late=[];
    dmPFC.(monkey_id).stim_early=[];
    dmPFC.(monkey_id).sham_late=[];
    dmPFC.(monkey_id).sham_early=[];
    dmPFC.(monkey_id).stim_diff=[];
    dmPFC.(monkey_id).sham_diff=[];

    for ndmPFC=1:length(dmPFC_day.(monkey_id))

        field_id=char(strcat('data_',dmPFC_day.(monkey_id)(ndmPFC)));

        dmPFC.(monkey_id).stim_late=[dmPFC.(monkey_id).stim_late Epoch_diff.(field_id).stim_late];
        dmPFC.(monkey_id).stim_early=[dmPFC.(monkey_id).stim_early Epoch_diff.(field_id).stim_early];
        dmPFC.(monkey_id).sham_late=[dmPFC.(monkey_id).sham_late Epoch_diff.(field_id).sham_late];
        dmPFC.(monkey_id).sham_early=[dmPFC.(monkey_id).sham_early Epoch_diff.(field_id).sham_early];
        dmPFC.(monkey_id).stim_diff=[dmPFC.(monkey_id).stim_diff Epoch_diff.(field_id).stim_diff];
        dmPFC.(monkey_id).sham_diff=[dmPFC.(monkey_id).sham_diff Epoch_diff.(field_id).sham_diff];

    end

    [Stats.p.(monkey_id).dmPFC.early, Stats.h.(monkey_id).dmPFC.early] = signrank(dmPFC.(monkey_id).stim_early,dmPFC.(monkey_id).sham_early);
    [Stats.p.(monkey_id).dmPFC.late, Stats.h.(monkey_id).dmPFC.late] = signrank(dmPFC.(monkey_id).stim_late,dmPFC.(monkey_id).sham_late);
    [Stats.p.(monkey_id).dmPFC.diff, Stats.h.(monkey_id).dmPFC.diff] = signrank(dmPFC.(monkey_id).stim_diff,dmPFC.(monkey_id).sham_diff);
    [Stats.p.(monkey_id).dmPFC.stim, Stats.h.(monkey_id).dmPFC.stim] = signrank(dmPFC.(monkey_id).stim_late,dmPFC.(monkey_id).stim_early);
    [Stats.p.(monkey_id).dmPFC.sham, Stats.h.(monkey_id).dmPFC.sham] = signrank(dmPFC.(monkey_id).sham_late,dmPFC.(monkey_id).sham_early);

    ACCg.(monkey_id).stim_late=[];
    ACCg.(monkey_id).stim_early=[];
    ACCg.(monkey_id).sham_late=[];
    ACCg.(monkey_id).sham_early=[];
    ACCg.(monkey_id).stim_diff=[];
    ACCg.(monkey_id).sham_diff=[];

    for nACCg=1:length(ACCg_day.(monkey_id))

        field_id=char(strcat('data_',ACCg_day.(monkey_id)(nACCg)));

        ACCg.(monkey_id).stim_late=[ACCg.(monkey_id).stim_late Epoch_diff.(field_id).stim_late];
        ACCg.(monkey_id).stim_early=[ACCg.(monkey_id).stim_early Epoch_diff.(field_id).stim_early];
        ACCg.(monkey_id).sham_late=[ACCg.(monkey_id).sham_late Epoch_diff.(field_id).sham_late];
        ACCg.(monkey_id).sham_early=[ACCg.(monkey_id).sham_early Epoch_diff.(field_id).sham_early];
        ACCg.(monkey_id).stim_diff=[ACCg.(monkey_id).stim_diff Epoch_diff.(field_id).stim_diff];
        ACCg.(monkey_id).sham_diff=[ACCg.(monkey_id).sham_diff Epoch_diff.(field_id).sham_diff];

    end

    [Stats.p.(monkey_id).ACCg.early, Stats.h.(monkey_id).ACCg.early] = signrank(ACCg.(monkey_id).stim_early,ACCg.(monkey_id).sham_early);
    [Stats.p.(monkey_id).ACCg.late, Stats.h.(monkey_id).ACCg.late] = signrank(ACCg.(monkey_id).stim_late,ACCg.(monkey_id).sham_late);
    [Stats.p.(monkey_id).ACCg.diff, Stats.h.(monkey_id).ACCg.diff] = signrank(ACCg.(monkey_id).stim_diff,ACCg.(monkey_id).sham_diff);
    [Stats.p.(monkey_id).ACCg.stim, Stats.h.(monkey_id).ACCg.stim] = signrank(ACCg.(monkey_id).stim_late,ACCg.(monkey_id).stim_early);
    [Stats.p.(monkey_id).ACCg.sham, Stats.h.(monkey_id).ACCg.sham] = signrank(ACCg.(monkey_id).sham_late,ACCg.(monkey_id).sham_early);

end

index_by_epoch.OFC=OFC;
index_by_epoch.dmPFC=dmPFC;
index_by_epoch.ACCg=ACCg;
index_by_epoch.Stats=Stats;

save('Index_by_Epoch_Stats_Combined.mat','index_by_epoch','-v7.3');

Index_by_epoch_p_raw_All=[index_by_epoch.Stats.p.All.OFC.early index_by_epoch.Stats.p.All.OFC.late index_by_epoch.Stats.p.All.OFC.stim index_by_epoch.Stats.p.All.OFC.sham ...
    index_by_epoch.Stats.p.All.dmPFC.early index_by_epoch.Stats.p.All.dmPFC.late index_by_epoch.Stats.p.All.dmPFC.stim index_by_epoch.Stats.p.All.dmPFC.sham ...
    index_by_epoch.Stats.p.All.ACCg.early index_by_epoch.Stats.p.All.ACCg.late index_by_epoch.Stats.p.All.ACCg.stim index_by_epoch.Stats.p.All.ACCg.sham];

Index_by_epoch_p_corected_All=dsp3.fdr(Index_by_epoch_p_raw_All);

Index_by_epoch_p_raw_Lynch=[index_by_epoch.Stats.p.Lynch.OFC.early index_by_epoch.Stats.p.Lynch.OFC.late index_by_epoch.Stats.p.Lynch.OFC.stim index_by_epoch.Stats.p.Lynch.OFC.sham ...
    index_by_epoch.Stats.p.Lynch.dmPFC.early index_by_epoch.Stats.p.Lynch.dmPFC.late index_by_epoch.Stats.p.Lynch.dmPFC.stim index_by_epoch.Stats.p.Lynch.dmPFC.sham ...
    index_by_epoch.Stats.p.Lynch.ACCg.early index_by_epoch.Stats.p.Lynch.ACCg.late index_by_epoch.Stats.p.Lynch.ACCg.stim index_by_epoch.Stats.p.Lynch.ACCg.sham];

Index_by_epoch_p_corected_Lynch=dsp3.fdr(Index_by_epoch_p_raw_Lynch);

Index_by_epoch_p_raw_Tarantino=[index_by_epoch.Stats.p.Tarantino.OFC.early index_by_epoch.Stats.p.Tarantino.OFC.late index_by_epoch.Stats.p.Tarantino.OFC.stim index_by_epoch.Stats.p.Tarantino.OFC.sham ...
    index_by_epoch.Stats.p.Tarantino.dmPFC.early index_by_epoch.Stats.p.Tarantino.dmPFC.late index_by_epoch.Stats.p.Tarantino.dmPFC.stim index_by_epoch.Stats.p.Tarantino.dmPFC.sham ...
    index_by_epoch.Stats.p.Tarantino.ACCg.early index_by_epoch.Stats.p.Tarantino.ACCg.late index_by_epoch.Stats.p.Tarantino.ACCg.stim index_by_epoch.Stats.p.Tarantino.ACCg.sham];

Index_by_epoch_p_corected_Tarantino=dsp3.fdr(Index_by_epoch_p_raw_Tarantino);

%% Plotting each day as a dot 

monkey_names={'All', 'Lynch', 'Tarantino'};

for nmonkey=1:3
    monkey_id=char(monkey_names(nmonkey));

    % Early Sham, Early Stim, Late Sham, Late Stim
        
    subplot(3,3,1)

    X=categorical({'Gaze Early Sham', 'Gaze Early Stim', 'Gaze Late Sham', 'Gaze Late Stim'});
    X=reordercats(X,{'Gaze Early Sham', 'Gaze Early Stim', 'Gaze Late Sham', 'Gaze Late Stim'});
    Y=[median(index_by_epoch.OFC.(monkey_id).sham_early,'omitnan'), median(index_by_epoch.OFC.(monkey_id).stim_early,'omitnan'),median(index_by_epoch.OFC.(monkey_id).sham_late,'omitnan'),median(index_by_epoch.OFC.(monkey_id).stim_late,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(OFC_day.(monkey_id)));
    line_hs = cell( length(OFC_day.(monkey_id)), 1 );
    line_labels = cell( size(line_hs) );

    for m=1:length(OFC_day.(monkey_id))
        
        scatter(X(1),index_by_epoch.OFC.(monkey_id).sham_early(m),30,colorInd(m,:),'filled'); hold on           
        scatter(X(2),index_by_epoch.OFC.(monkey_id).stim_early(m),30,colorInd(m,:),'filled'); hold on
        scatter(X(3),index_by_epoch.OFC.(monkey_id).sham_late(m),30,colorInd(m,:),'filled'); hold on           
        scatter(X(4),index_by_epoch.OFC.(monkey_id).stim_late(m),30,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[index_by_epoch.OFC.(monkey_id).sham_early(m) index_by_epoch.OFC.(monkey_id).stim_early(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[index_by_epoch.OFC.(monkey_id).stim_early(m) index_by_epoch.OFC.(monkey_id).sham_late(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(3) X(4)],[index_by_epoch.OFC.(monkey_id).sham_late(m) index_by_epoch.OFC.(monkey_id).stim_late(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = OFC_day.(monkey_id){m};
    
    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);

    title('OFC')
    ax1=gca; 
    axis(ax1,'square');
    ylim([0.3 0.7]);
    clear X Y m colorInd line_hs line_labels
        
    subplot(3,3,2)

    X=categorical({'Gaze Early Sham', 'Gaze Early Stim', 'Gaze Late Sham', 'Gaze Late Stim'});
    X=reordercats(X,{'Gaze Early Sham', 'Gaze Early Stim', 'Gaze Late Sham', 'Gaze Late Stim'});
    Y=[median(index_by_epoch.dmPFC.(monkey_id).sham_early,'omitnan'), median(index_by_epoch.dmPFC.(monkey_id).stim_early,'omitnan'),median(index_by_epoch.dmPFC.(monkey_id).sham_late,'omitnan'),median(index_by_epoch.dmPFC.(monkey_id).stim_late,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(dmPFC_day.(monkey_id)));
    line_hs = cell( length(dmPFC_day.(monkey_id)), 1 );
    line_labels = cell( size(line_hs) );

    for m=1:length(dmPFC_day.(monkey_id))
        
        scatter(X(1),index_by_epoch.dmPFC.(monkey_id).sham_early(m),30,colorInd(m,:),'filled'); hold on           
        scatter(X(2),index_by_epoch.dmPFC.(monkey_id).stim_early(m),30,colorInd(m,:),'filled'); hold on
        scatter(X(3),index_by_epoch.dmPFC.(monkey_id).sham_late(m),30,colorInd(m,:),'filled'); hold on           
        scatter(X(4),index_by_epoch.dmPFC.(monkey_id).stim_late(m),30,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[index_by_epoch.dmPFC.(monkey_id).sham_early(m) index_by_epoch.dmPFC.(monkey_id).stim_early(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[index_by_epoch.dmPFC.(monkey_id).stim_early(m) index_by_epoch.dmPFC.(monkey_id).sham_late(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(3) X(4)],[index_by_epoch.dmPFC.(monkey_id).sham_late(m) index_by_epoch.dmPFC.(monkey_id).stim_late(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = dmPFC_day.(monkey_id){m};
    
    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);

    title('dmPFC')
    ax2=gca; 
    axis(ax2,'square');
    ylim([0.3 0.7]);
    clear X Y m colorInd line_hs line_labels

    subplot(3,3,3)

    X=categorical({'Gaze Early Sham', 'Gaze Early Stim', 'Gaze Late Sham', 'Gaze Late Stim'});
    X=reordercats(X,{'Gaze Early Sham', 'Gaze Early Stim', 'Gaze Late Sham', 'Gaze Late Stim'});
    Y=[median(index_by_epoch.ACCg.(monkey_id).sham_early,'omitnan'), median(index_by_epoch.ACCg.(monkey_id).stim_early,'omitnan'),median(index_by_epoch.ACCg.(monkey_id).sham_late,'omitnan'),median(index_by_epoch.ACCg.(monkey_id).stim_late,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(ACCg_day.(monkey_id)));
    line_hs = cell( length(ACCg_day.(monkey_id)), 1 );
    line_labels = cell( size(line_hs) );

    for m=1:length(ACCg_day.(monkey_id))
        
        scatter(X(1),index_by_epoch.ACCg.(monkey_id).sham_early(m),30,colorInd(m,:),'filled'); hold on           
        scatter(X(2),index_by_epoch.ACCg.(monkey_id).stim_early(m),30,colorInd(m,:),'filled'); hold on
        scatter(X(3),index_by_epoch.ACCg.(monkey_id).sham_late(m),30,colorInd(m,:),'filled'); hold on           
        scatter(X(4),index_by_epoch.ACCg.(monkey_id).stim_late(m),30,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[index_by_epoch.ACCg.(monkey_id).sham_early(m) index_by_epoch.ACCg.(monkey_id).stim_early(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[index_by_epoch.ACCg.(monkey_id).stim_early(m) index_by_epoch.ACCg.(monkey_id).sham_late(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(3) X(4)],[index_by_epoch.ACCg.(monkey_id).sham_late(m) index_by_epoch.ACCg.(monkey_id).stim_late(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = ACCg_day.(monkey_id){m};
    
    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);

    title('ACCg')
    ax3=gca; 
    axis(ax3,'square');
    ylim([0.3 0.7]);
    clear X Y m colorInd line_hs line_labels
         
    linkaxes([ax1,ax2,ax3],'y');

    sgtitle(sprintf(['index_by_epoch_' monkey_id]),'Interpreter', 'none')   
    set(gcf, 'Renderer', 'painters');
    saveas(gcf,sprintf(['index_by_epoch_',monkey_id]))
    saveas(gcf,sprintf(['index_by_epoch_',monkey_id,'.jpg']))
    saveas(gcf,sprintf(['index_by_epoch_',monkey_id,'.epsc']))

    clf

end


