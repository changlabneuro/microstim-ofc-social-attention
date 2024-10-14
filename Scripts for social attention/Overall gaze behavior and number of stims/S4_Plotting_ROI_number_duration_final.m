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

% All

All_day.All={'07202019'  '07312019'  '08052019'  '08122019'  '08292019' ...
    '09052019'  '09192019'  '10012019'  '11052019'   '12122019' ...  
    '12182019'  '01032020'  '01102020'  '01242020'  '02022020'...
    '11082021'  '12222021'  '01032022'  '01212022'  '01282022'...
    '02032022'  '02092022'  '02152022'  '02192022'  '02242022'...
    '02282022'  '03172022' ...
    '07222019'  '08022019'  '08072019'  '08232019'  '09172019' ...
    '09242019'  '09282019'  '10102019'  '12092019'  '12132019' ...
    '01072020'  '01172020'  '01272020'  '01312020'  '02072020'...
    '11042021'  '12292021'  '01202022'  '01312022'  '02212022'...
    '03242022'  '04192022'  '04262022'  '05172022'  '05242022'...
    '05272022'  '05302022'...
    '07182019','07262019'  '08092019'  '08142019'  '08212019' ...
    '09032019'  '09222019'  '10042019'  '12052019'  '12102019' ...
    '12162019'  '01022020'  '01132020'  '01222020'  '02062020'...
    '11052021'  '12172021'  '01242022'  '02122022'  '03052022'...
    '03182022'  '04012022'  '05032022'  '05122022'  '05142022'...
    '05192022'  '05262022'};  

All_day.Lynch={'07202019'  '07312019'  '08052019'  '08122019'  '08292019' ...
    '09052019'  '09192019'  '10012019'  '11052019'   '12122019' ...  
    '12182019'  '01032020'  '01102020'  '01242020'  '02022020'...
    '07222019'  '08022019'  '08072019'  '08232019'  '09172019' ...
    '09242019'  '09282019'  '10102019'  '12092019'  '12132019' ...
    '01072020'  '01172020'  '01272020'  '01312020'  '02072020'...
    '07182019','07262019'  '08092019'  '08142019'  '08212019' ...
    '09032019'  '09222019'  '10042019'  '12052019'  '12102019' ...
    '12162019'  '01022020'  '01132020'  '01222020'  '02062020'}; 

All_day.Tarantino={'11082021'  '12222021'  '01032022'  '01212022'  '01282022'...
    '02032022'  '02092022'  '02152022'  '02192022'  '02242022'...
    '02282022'  '03172022'...
    '11042021'  '12292021'  '01202022'  '01312022'  '02212022'...
    '03242022'  '04192022'  '04262022'  '05172022'  '05242022'...
    '05272022'  '05302022'...
    '11052021'  '12172021'  '01242022'  '02122022'  '03052022'...
    '03182022'  '04012022'  '05032022'  '05122022'  '05142022'...
    '05192022'  '05262022'};

%% Plotting

monkey_names={'All', 'Lynch', 'Tarantino'};

for nmonkey=1:3
    monkey_id=char(monkey_names(nmonkey));

    % Total number

    subplot(2,4,1)
    
    X=categorical({'Eyes','Non-eye Face','Dots'});
    X=reordercats(X,{'Eyes','Non-eye Face','Dots'});
    Y=[median(Gaze_summary.All_day.(monkey_id).m1_eye.total_number,'omitnan'),median(Gaze_summary.All_day.(monkey_id).m1_neface.total_number,'omitnan'),median(Dot_summary.All_day.(monkey_id).m1_eye.total_number,'omitnan')];
    bar(X,Y); hold on
%     ylim([0 250]);
%     yticks([0 50 100 150 200 250]);

    
    colorInd=jet(length(Gaze_summary.All_day.(monkey_id).m1_eye.total_number));
    line_hs = cell(length(Gaze_summary.All_day.(monkey_id).m1_eye.total_number), 1 );
    line_labels = cell( size(line_hs) );

    for m=1:length(Gaze_summary.All_day.(monkey_id).m1_eye.total_number)
        
        scatter(X(1),Gaze_summary.All_day.(monkey_id).m1_eye.total_number(m),20,colorInd(m,:),'filled'); hold on           
        scatter(X(2),Gaze_summary.All_day.(monkey_id).m1_neface.total_number(m),20,colorInd(m,:),'filled'); hold on
        scatter(X(3),Dot_summary.All_day.(monkey_id).m1_eye.total_number(m),20,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[Gaze_summary.All_day.(monkey_id).m1_eye.total_number(m) Gaze_summary.All_day.(monkey_id).m1_neface.total_number(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[Gaze_summary.All_day.(monkey_id).m1_neface.total_number(m) Dot_summary.All_day.(monkey_id).m1_eye.total_number(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = All_day.(monkey_id){m};

    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',3);
    
    title('Frequency All');
    ax1=gca; 
    set(ax1,'PositionConstraint','innerposition');
    axis(ax1,'square');
    set(ax1,'plotboxaspectratio',[1 1 1]);
    clear X Y m colorInd line_hs line_labels

    subplot(2,4,2)
    
    X=categorical({'Eyes','Non-eye Face','Dots'});
    X=reordercats(X,{'Eyes','Non-eye Face','Dots'});
    Y=[median(Gaze_summary.OFC.(monkey_id).m1_eye.total_number,'omitnan'),median(Gaze_summary.OFC.(monkey_id).m1_neface.total_number,'omitnan'),median(Dot_summary.OFC.(monkey_id).m1_eye.total_number,'omitnan')];
    bar(X,Y); hold on
%     ylim([0 250]);
%     yticks([0 50 100 150 200 250]);
    
    colorInd=jet(length(Gaze_summary.OFC.(monkey_id).m1_eye.total_number));
    line_hs = cell(length(Gaze_summary.OFC.(monkey_id).m1_eye.total_number), 1 );
    line_labels = cell( size(line_hs) );

    for m=1:length(Gaze_summary.OFC.(monkey_id).m1_eye.total_number)
        
        scatter(X(1),Gaze_summary.OFC.(monkey_id).m1_eye.total_number(m),20,colorInd(m,:),'filled'); hold on           
        scatter(X(2),Gaze_summary.OFC.(monkey_id).m1_neface.total_number(m),20,colorInd(m,:),'filled'); hold on
        scatter(X(3),Dot_summary.OFC.(monkey_id).m1_eye.total_number(m),20,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[Gaze_summary.OFC.(monkey_id).m1_eye.total_number(m) Gaze_summary.OFC.(monkey_id).m1_neface.total_number(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[Gaze_summary.OFC.(monkey_id).m1_neface.total_number(m) Dot_summary.OFC.(monkey_id).m1_eye.total_number(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = OFC_day.(monkey_id){m};

    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',3);
    
    title('Frequency OFC');
    ax2=gca; 
    set(ax2,'PositionConstraint','innerposition');
    axis(ax2,'square');
    set(ax2,'plotboxaspectratio',[1 1 1]);
    clear X Y m colorInd line_hs line_labels

    subplot(2,4,3)
    
    X=categorical({'Eyes','Non-eye Face','Dots'});
    X=reordercats(X,{'Eyes','Non-eye Face','Dots'});
    Y=[median(Gaze_summary.ACCg.(monkey_id).m1_eye.total_number,'omitnan'),median(Gaze_summary.ACCg.(monkey_id).m1_neface.total_number,'omitnan'),median(Dot_summary.ACCg.(monkey_id).m1_eye.total_number,'omitnan')];
    bar(X,Y); hold on
%     ylim([0 250]);
%     yticks([0 50 100 150 200 250]);
    
    colorInd=jet(length(Gaze_summary.ACCg.(monkey_id).m1_eye.total_number));
    line_hs = cell(length(Gaze_summary.ACCg.(monkey_id).m1_eye.total_number), 1 );
    line_labels = cell( size(line_hs) );

    for m=1:length(Gaze_summary.ACCg.(monkey_id).m1_eye.total_number)
        
        scatter(X(1),Gaze_summary.ACCg.(monkey_id).m1_eye.total_number(m),20,colorInd(m,:),'filled'); hold on           
        scatter(X(2),Gaze_summary.ACCg.(monkey_id).m1_neface.total_number(m),20,colorInd(m,:),'filled'); hold on
        scatter(X(3),Dot_summary.ACCg.(monkey_id).m1_eye.total_number(m),20,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[Gaze_summary.ACCg.(monkey_id).m1_eye.total_number(m) Gaze_summary.ACCg.(monkey_id).m1_neface.total_number(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[Gaze_summary.ACCg.(monkey_id).m1_neface.total_number(m) Dot_summary.ACCg.(monkey_id).m1_eye.total_number(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = ACCg_day.(monkey_id){m};

    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',3);
    
    title('Frequency ACCg');
    ax3=gca; 
    set(ax3,'PositionConstraint','innerposition');
    axis(ax3,'square');
    set(ax3,'plotboxaspectratio',[1 1 1]);
    clear X Y m colorInd line_hs line_labels

    subplot(2,4,4)
    
    X=categorical({'Eyes','Non-eye Face','Dots'});
    X=reordercats(X,{'Eyes','Non-eye Face','Dots'});
    Y=[median(Gaze_summary.dmPFC.(monkey_id).m1_eye.total_number,'omitnan'),median(Gaze_summary.dmPFC.(monkey_id).m1_neface.total_number,'omitnan'),median(Dot_summary.dmPFC.(monkey_id).m1_eye.total_number,'omitnan')];
    bar(X,Y); hold on
%     ylim([0 250]);
%     yticks([0 50 100 150 200 250]);
    
    colorInd=jet(length(Gaze_summary.dmPFC.(monkey_id).m1_eye.total_number));
    line_hs = cell(length(Gaze_summary.dmPFC.(monkey_id).m1_eye.total_number), 1 );
    line_labels = cell( size(line_hs) );

    for m=1:length(Gaze_summary.dmPFC.(monkey_id).m1_eye.total_number)
        
        scatter(X(1),Gaze_summary.dmPFC.(monkey_id).m1_eye.total_number(m),20,colorInd(m,:),'filled'); hold on           
        scatter(X(2),Gaze_summary.dmPFC.(monkey_id).m1_neface.total_number(m),20,colorInd(m,:),'filled'); hold on
        scatter(X(3),Dot_summary.dmPFC.(monkey_id).m1_eye.total_number(m),20,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[Gaze_summary.dmPFC.(monkey_id).m1_eye.total_number(m) Gaze_summary.dmPFC.(monkey_id).m1_neface.total_number(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[Gaze_summary.dmPFC.(monkey_id).m1_neface.total_number(m) Dot_summary.dmPFC.(monkey_id).m1_eye.total_number(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = dmPFC_day.(monkey_id){m};

    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',3);
    
    title('Frequency dmPFC');
    ax4=gca; 
    set(ax4,'PositionConstraint','innerposition');
    axis(ax4,'square');
    set(ax4,'plotboxaspectratio',[1 1 1]);
    clear X Y m colorInd line_hs line_labels

    linkaxes([ax2,ax3,ax4],'y');
    
    % Average duration

   subplot(2,4,5)
    
    X=categorical({'Eyes','Non-eye Face','Dots'});
    X=reordercats(X,{'Eyes','Non-eye Face','Dots'});
    Y=[median(Gaze_summary.All_day.(monkey_id).m1_eye.average_duration,'omitnan'),median(Gaze_summary.All_day.(monkey_id).m1_neface.average_duration,'omitnan'),median(Dot_summary.All_day.(monkey_id).m1_eye.average_duration,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(Gaze_summary.All_day.(monkey_id).m1_eye.average_duration));
    line_hs = cell(length(Gaze_summary.All_day.(monkey_id).m1_eye.average_duration), 1 );
    line_labels = cell( size(line_hs) );

    for m=1:length(Gaze_summary.All_day.(monkey_id).m1_eye.average_duration)
        
        scatter(X(1),Gaze_summary.All_day.(monkey_id).m1_eye.average_duration(m),20,colorInd(m,:),'filled'); hold on           
        scatter(X(2),Gaze_summary.All_day.(monkey_id).m1_neface.average_duration(m),20,colorInd(m,:),'filled'); hold on
        scatter(X(3),Dot_summary.All_day.(monkey_id).m1_eye.average_duration(m),20,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[Gaze_summary.All_day.(monkey_id).m1_eye.average_duration(m) Gaze_summary.All_day.(monkey_id).m1_neface.average_duration(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[Gaze_summary.All_day.(monkey_id).m1_neface.average_duration(m) Dot_summary.All_day.(monkey_id).m1_eye.average_duration(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = All_day.(monkey_id){m};

    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',3);
    
    title('Average Duration All');
    ax5=gca; 
    set(ax5,'PositionConstraint','innerposition');
    axis(ax5,'square');
    set(ax5,'plotboxaspectratio',[1 1 1]);
    clear X Y m colorInd line_hs line_labels

    subplot(2,4,6)
    
    X=categorical({'Eyes','Non-eye Face','Dots'});
    X=reordercats(X,{'Eyes','Non-eye Face','Dots'});
    Y=[median(Gaze_summary.OFC.(monkey_id).m1_eye.average_duration,'omitnan'),median(Gaze_summary.OFC.(monkey_id).m1_neface.average_duration,'omitnan'),median(Dot_summary.OFC.(monkey_id).m1_eye.average_duration,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(Gaze_summary.OFC.(monkey_id).m1_eye.average_duration));
    line_hs = cell(length(Gaze_summary.OFC.(monkey_id).m1_eye.average_duration), 1 );
    line_labels = cell( size(line_hs) );

    for m=1:length(Gaze_summary.OFC.(monkey_id).m1_eye.average_duration)
        
        scatter(X(1),Gaze_summary.OFC.(monkey_id).m1_eye.average_duration(m),20,colorInd(m,:),'filled'); hold on           
        scatter(X(2),Gaze_summary.OFC.(monkey_id).m1_neface.average_duration(m),20,colorInd(m,:),'filled'); hold on
        scatter(X(3),Dot_summary.OFC.(monkey_id).m1_eye.average_duration(m),20,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[Gaze_summary.OFC.(monkey_id).m1_eye.average_duration(m) Gaze_summary.OFC.(monkey_id).m1_neface.average_duration(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[Gaze_summary.OFC.(monkey_id).m1_neface.average_duration(m) Dot_summary.OFC.(monkey_id).m1_eye.average_duration(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = OFC_day.(monkey_id){m};

    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',3);
    
    title('Average Duration OFC');
    ax6=gca; 
    set(ax6,'PositionConstraint','innerposition');
    axis(ax6,'square');
    set(ax6,'plotboxaspectratio',[1 1 1]);
    clear X Y m colorInd line_hs line_labels

    subplot(2,4,7)
    
    X=categorical({'Eyes','Non-eye Face','Dots'});
    X=reordercats(X,{'Eyes','Non-eye Face','Dots'});
    Y=[median(Gaze_summary.ACCg.(monkey_id).m1_eye.average_duration,'omitnan'),median(Gaze_summary.ACCg.(monkey_id).m1_neface.average_duration,'omitnan'),median(Dot_summary.ACCg.(monkey_id).m1_eye.average_duration,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(Gaze_summary.ACCg.(monkey_id).m1_eye.average_duration));
    line_hs = cell(length(Gaze_summary.ACCg.(monkey_id).m1_eye.average_duration), 1 );
    line_labels = cell( size(line_hs) );

    for m=1:length(Gaze_summary.ACCg.(monkey_id).m1_eye.average_duration)
        
        scatter(X(1),Gaze_summary.ACCg.(monkey_id).m1_eye.average_duration(m),20,colorInd(m,:),'filled'); hold on           
        scatter(X(2),Gaze_summary.ACCg.(monkey_id).m1_neface.average_duration(m),20,colorInd(m,:),'filled'); hold on
        scatter(X(3),Dot_summary.ACCg.(monkey_id).m1_eye.average_duration(m),20,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[Gaze_summary.ACCg.(monkey_id).m1_eye.average_duration(m) Gaze_summary.ACCg.(monkey_id).m1_neface.average_duration(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[Gaze_summary.ACCg.(monkey_id).m1_neface.average_duration(m) Dot_summary.ACCg.(monkey_id).m1_eye.average_duration(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = ACCg_day.(monkey_id){m};

    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',3);
    
    title('Average Duration ACCg');
    ax7=gca; 
    set(ax7,'PositionConstraint','innerposition');
    axis(ax7,'square');
    set(ax7,'plotboxaspectratio',[1 1 1]);
    clear X Y m colorInd line_hs line_labels

    subplot(2,4,8)
    
    X=categorical({'Eyes','Non-eye Face','Dots'});
    X=reordercats(X,{'Eyes','Non-eye Face','Dots'});
    Y=[median(Gaze_summary.dmPFC.(monkey_id).m1_eye.average_duration,'omitnan'),median(Gaze_summary.dmPFC.(monkey_id).m1_neface.average_duration,'omitnan'),median(Dot_summary.dmPFC.(monkey_id).m1_eye.average_duration,'omitnan')];
    bar(X,Y); hold on
    
    colorInd=jet(length(Gaze_summary.dmPFC.(monkey_id).m1_eye.average_duration));
    line_hs = cell(length(Gaze_summary.dmPFC.(monkey_id).m1_eye.average_duration), 1 );
    line_labels = cell( size(line_hs) );

    for m=1:length(Gaze_summary.dmPFC.(monkey_id).m1_eye.average_duration)
        
        scatter(X(1),Gaze_summary.dmPFC.(monkey_id).m1_eye.average_duration(m),20,colorInd(m,:),'filled'); hold on           
        scatter(X(2),Gaze_summary.dmPFC.(monkey_id).m1_neface.average_duration(m),20,colorInd(m,:),'filled'); hold on
        scatter(X(3),Dot_summary.dmPFC.(monkey_id).m1_eye.average_duration(m),20,colorInd(m,:),'filled'); hold on
        line_hs{m} = line([X(1) X(2)],[Gaze_summary.dmPFC.(monkey_id).m1_eye.average_duration(m) Gaze_summary.dmPFC.(monkey_id).m1_neface.average_duration(m)], 'Color',colorInd(m,:)); hold on
        line_hs{m} = line([X(2) X(3)],[Gaze_summary.dmPFC.(monkey_id).m1_neface.average_duration(m) Dot_summary.dmPFC.(monkey_id).m1_eye.average_duration(m)], 'Color',colorInd(m,:)); hold on
        line_labels{m} = dmPFC_day.(monkey_id){m};

    end
    legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',3);
    
    title('Average Duration dmPFC');
    ax8=gca; 
    set(ax8,'PositionConstraint','innerposition');
    axis(ax8,'square');
    set(ax8,'plotboxaspectratio',[1 1 1]);
    clear X Y m colorInd line_hs line_labels

    linkaxes([ax6,ax7,ax8],'y');

    sgtitle(sprintf(['Gaze Behavior ' monkey_id]),'Interpreter', 'none')   
    set(gcf, 'Renderer', 'painters');
    saveas(gcf,sprintf(['Gaze Behavior ' monkey_id]))
    saveas(gcf,sprintf(['Gaze Behavior ' monkey_id '.jpg']))
    saveas(gcf,sprintf(['Gaze Behavior ' monkey_id '.epsc']))

    clf

end