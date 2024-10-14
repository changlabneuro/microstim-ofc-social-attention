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

% List of significant variables
Gaze_variables_distance={'m1_distance_to_eyes', 'm1_distance_to_eyes_ipsi','m1_distance_to_eyes_contra'};
%Gaze_variables_distance={'m1_distance_to_eyes', 'm1_distance_to_eyes_ipsi','m1_distance_to_eyes_contra'...
    %'m1_distance_to_mouth', 'm1_distance_to_mouth_ipsi','m1_distance_to_mouth_contra'...
    %'m1_distance_to_face', 'm1_distance_to_face_ipsi','m1_distance_to_face_contra'};

h = 27; % monitor height in cm
d = 50; % subject to monitor in cm
r=768; % monitor height in pixel

deg_per_px = rad2deg(atan2(.5*h, d)) / (.5*r); 

%% Plotting each day as a dot for both Gaze and Dot conditions (m1 only)

% m1
n_m1=1:length(Gaze_variables_distance);

% Specify variables
for ngaze=n_m1

    gaze_variables=char(Gaze_variables_distance(ngaze));
    monkey_names={'All', 'Lynch', 'Tarantino'};
    
    for nmonkey=1:3
        monkey_id=char(monkey_names(nmonkey));

        %stats_type={'mean','median'};
        stats_type={'mean'};
    
        for n_type=1:length(stats_type)
            
            type_id=char(stats_type(n_type));
    
            % Current Sham vs. Current Stim
            
            subplot(3,3,1)
        
            X=categorical({'Gaze Current Sham','Gaze Current Stim','Dot Current Sham','Dot Current Stim'});
            X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim','Dot Current Sham','Dot Current Stim'});
            Y=[deg_per_px*median(Gaze.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(OFC_day.(monkey_id)));
            line_hs = cell( length(OFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );

            for m=1:length(OFC_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Gaze.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Gaze.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(3),deg_per_px*Dot.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(4),deg_per_px*Dot.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(2) X(3)],[deg_per_px*Gaze.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(3) X(4)],[deg_per_px*Dot.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line_labels{m} = OFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('OFC')
            ax1=gca; 
            axis(ax1,'square');
            clear X Y m colorInd line_hs line_labels
            
            subplot(3,3,2)
            
            X=categorical({'Gaze Current Sham','Gaze Current Stim','Dot Current Sham','Dot Current Stim'});
            X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim','Dot Current Sham','Dot Current Stim'});
            Y=[deg_per_px*median(Gaze.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(ACCg_day.(monkey_id)));
            line_hs = cell( length(ACCg_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );

            for m=1:length(ACCg_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Gaze.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Gaze.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(3),deg_per_px*Dot.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(4),deg_per_px*Dot.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(2) X(3)],[deg_per_px*Gaze.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(3) X(4)],[deg_per_px*Dot.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line_labels{m} = ACCg_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('ACCg')
            ax2=gca; 
            axis(ax2,'square');
            clear X Y m colorInd line_hs line_labels
         
            subplot(3,3,3)
            
            X=categorical({'Gaze Current Sham','Gaze Current Stim','Dot Current Sham','Dot Current Stim'});
            X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim','Dot Current Sham','Dot Current Stim'});
            Y=[deg_per_px*median(Gaze.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(dmPFC_day.(monkey_id)));
            line_hs = cell( length(dmPFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );

            for m=1:length(dmPFC_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Gaze.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Gaze.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(3),deg_per_px*Dot.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(4),deg_per_px*Dot.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(2) X(3)],[deg_per_px*Gaze.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(3) X(4)],[deg_per_px*Dot.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line_labels{m} = dmPFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
           
            title('dmPFC')
            ax3=gca; 
            axis(ax3,'square');
            clear X Y m colorInd line_hs line_labels
            
            % Previous Sham vs. Stim for Current Sham vs. Stim
            
            subplot(3,3,4)
        
            X=categorical({'Gaze Sham Sham', 'Gaze Stim Sham', 'Gaze Sham Stim', 'Gaze Stim Stim', 'Dot Sham Sham', 'Dot Stim Sham', 'Dot Sham Stim', 'Dot Stim Stim'});
            X=reordercats(X,{'Gaze Sham Sham', 'Gaze Stim Sham', 'Gaze Sham Stim', 'Gaze Stim Stim', 'Dot Sham Sham', 'Dot Stim Sham', 'Dot Sham Stim', 'Dot Stim Stim'});
            Y=[deg_per_px*median(Gaze.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'), deg_per_px*median(Gaze.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),...
                deg_per_px*median(Dot.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'), deg_per_px*median(Dot.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
         
            colorInd=jet(length(OFC_day.(monkey_id)));
            line_hs = cell( length(OFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );
        
            for m=1:length(OFC_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Gaze.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Gaze.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(3),deg_per_px*Gaze.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(4),deg_per_px*Gaze.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(5),deg_per_px*Dot.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(6),deg_per_px*Dot.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(7),deg_per_px*Dot.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(8),deg_per_px*Dot.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(2) X(3)],[deg_per_px*Gaze.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(3) X(4)],[deg_per_px*Gaze.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line([X(4) X(5)],[deg_per_px*Gaze.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on                        
                line([X(5) X(6)],[deg_per_px*Dot.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line([X(6) X(7)],[deg_per_px*Dot.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line([X(7) X(8)],[deg_per_px*Dot.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on              
                line_labels{m} = OFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside' , 'FontSize',7);
        
            title('OFC')
            ax4=gca; 
            axis(ax4,'square');
            clear X Y m colorInd line_hs line_labels
            
            subplot(3,3,5)
        
            X=categorical({'Gaze Sham Sham', 'Gaze Stim Sham', 'Gaze Sham Stim', 'Gaze Stim Stim', 'Dot Sham Sham', 'Dot Stim Sham', 'Dot Sham Stim', 'Dot Stim Stim'});
            X=reordercats(X,{'Gaze Sham Sham', 'Gaze Stim Sham', 'Gaze Sham Stim', 'Gaze Stim Stim', 'Dot Sham Sham', 'Dot Stim Sham', 'Dot Sham Stim', 'Dot Stim Stim'});
            Y=[deg_per_px*median(Gaze.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'), deg_per_px*median(Gaze.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),...
                deg_per_px*median(Dot.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'), deg_per_px*median(Dot.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
         
            colorInd=jet(length(ACCg_day.(monkey_id)));
            line_hs = cell( length(ACCg_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );
        
            for m=1:length(ACCg_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Gaze.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Gaze.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(3),deg_per_px*Gaze.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(4),deg_per_px*Gaze.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(5),deg_per_px*Dot.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(6),deg_per_px*Dot.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(7),deg_per_px*Dot.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(8),deg_per_px*Dot.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(2) X(3)],[deg_per_px*Gaze.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(3) X(4)],[deg_per_px*Gaze.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line([X(4) X(5)],[deg_per_px*Gaze.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line([X(5) X(6)],[deg_per_px*Dot.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line([X(6) X(7)],[deg_per_px*Dot.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line([X(7) X(8)],[deg_per_px*Dot.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on              
                line_labels{m} = ACCg_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside' , 'FontSize',7);
        
            title('ACCg')
            ax5=gca; 
            axis(ax5,'square');
            clear X Y m colorInd line_hs line_labels

            subplot(3,3,6)
        
            X=categorical({'Gaze Sham Sham', 'Gaze Stim Sham', 'Gaze Sham Stim', 'Gaze Stim Stim', 'Dot Sham Sham', 'Dot Stim Sham', 'Dot Sham Stim', 'Dot Stim Stim'});
            X=reordercats(X,{'Gaze Sham Sham', 'Gaze Stim Sham', 'Gaze Sham Stim', 'Gaze Stim Stim', 'Dot Sham Sham', 'Dot Stim Sham', 'Dot Sham Stim', 'Dot Stim Stim'});
            Y=[deg_per_px*median(Gaze.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'), deg_per_px*median(Gaze.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),...
                deg_per_px*median(Dot.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'), deg_per_px*median(Dot.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
         
            colorInd=jet(length(dmPFC_day.(monkey_id)));
            line_hs = cell( length(dmPFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );
        
            for m=1:length(dmPFC_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Gaze.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Gaze.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(3),deg_per_px*Gaze.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(4),deg_per_px*Gaze.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(5),deg_per_px*Dot.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(6),deg_per_px*Dot.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(7),deg_per_px*Dot.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(8),deg_per_px*Dot.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(2) X(3)],[deg_per_px*Gaze.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(3) X(4)],[deg_per_px*Gaze.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line([X(4) X(5)],[deg_per_px*Gaze.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on          
                line([X(5) X(6)],[deg_per_px*Dot.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line([X(6) X(7)],[deg_per_px*Dot.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line([X(7) X(8)],[deg_per_px*Dot.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on              
                line_labels{m} = dmPFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside' , 'FontSize',7);
        
            title('dmPFC')
            ax6=gca; 
            axis(ax6,'square');
            clear X Y m colorInd line_hs line_labels
            
            % Current Stim-Sham
            
            subplot(3,3,7);
            %axis( ax, 'square' );
    
            X=categorical({'Gaze Current St-Sh','Dot Current St-Sh'});
            X=reordercats(X,{'Gaze Current St-Sh','Dot Current St-Sh'});
            Y=[deg_per_px*median((Gaze.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)-Gaze.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)),'omitnan'),...
                deg_per_px*median((Dot.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)-Dot.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)),'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(OFC_day.(monkey_id)));
            line_hs= cell(length(OFC_day.(monkey_id)),1); 
            line_labels=cell(size(line_hs));
            
            for m=1:length(OFC_day.(monkey_id))
                
                scatter(X(1),(deg_per_px*Gaze.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Gaze.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m)),30,colorInd(m,:),'filled'); hold on   
                scatter(X(2),(deg_per_px*Dot.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Dot.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m)),30,colorInd(m,:),'filled'); hold on   
                
                line_hs{m} = line([X(1) X(2)],[(deg_per_px*Gaze.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Gaze.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m))  (deg_per_px*Dot.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Dot.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m))], 'Color',colorInd(m,:)); hold on
                line_labels{m}=OFC_day.(monkey_id){m};
               
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('OFC')
            ax7=gca; 
            axis(ax7,'square');
            clear X Y m colorInd line_hs line_labels

            subplot(3,3,8)
    
            X=categorical({'Gaze Current St-Sh','Dot Current St-Sh'});
            X=reordercats(X,{'Gaze Current St-Sh','Dot Current St-Sh'});
            Y=[deg_per_px*median((Gaze.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)-Gaze.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)),'omitnan'),...
                deg_per_px*median((Dot.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)-Dot.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)),'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(ACCg_day.(monkey_id)));
            line_hs= cell(length(ACCg_day.(monkey_id)),1); 
            line_labels=cell(size(line_hs));
            
            for m=1:length(ACCg_day.(monkey_id))
                
                scatter(X(1),(deg_per_px*Gaze.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Gaze.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m)),30,colorInd(m,:),'filled'); hold on   
                scatter(X(2),(deg_per_px*Dot.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Dot.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m)),30,colorInd(m,:),'filled'); hold on   
                
                line_hs{m} = line([X(1) X(2)],[(deg_per_px*Gaze.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Gaze.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m))  (deg_per_px*Dot.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Dot.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m))], 'Color',colorInd(m,:)); hold on
                line_labels{m}=ACCg_day.(monkey_id){m};
               
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('ACCg')
            ax8=gca; 
            axis(ax8,'square');
            clear X Y m colorInd line_hs line_labels
                    
            subplot(3,3,9)
    
            X=categorical({'Gaze Current St-Sh','Dot Current St-Sh'});
            X=reordercats(X,{'Gaze Current St-Sh','Dot Current St-Sh'});
            Y=[deg_per_px*median((Gaze.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)-Gaze.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)),'omitnan'),...
                deg_per_px*median((Dot.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)-Dot.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)),'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(dmPFC_day.(monkey_id)));
            line_hs= cell(length(dmPFC_day.(monkey_id)),1); 
            line_labels=cell(size(line_hs));
            
            for m=1:length(dmPFC_day.(monkey_id))
                
                scatter(X(1),(deg_per_px*Gaze.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Gaze.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)),30,colorInd(m,:),'filled'); hold on   
                scatter(X(2),(deg_per_px*Dot.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Dot.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)),30,colorInd(m,:),'filled'); hold on   
                
                line_hs{m} = line([X(1) X(2)],[(deg_per_px*Gaze.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Gaze.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m))  (deg_per_px*Dot.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Dot.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m))], 'Color',colorInd(m,:)); hold on
                line_labels{m}=dmPFC_day.(monkey_id){m};
               
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('dmPFC')
            ax9=gca; 
            axis(ax9,'square');
            clear X Y m colorInd line_hs line_labels
                    
            linkaxes([ax1,ax2,ax3,ax4,ax5,ax6],'y');
            linkaxes([ax7,ax8,ax9],'y');
        
            sgtitle(sprintf([gaze_variables '_' monkey_id '_' type_id]),'Interpreter', 'none')   
            set(gcf, 'Renderer', 'painters');
            saveas(gcf,sprintf([gaze_variables,'_',monkey_id,'_',type_id]))
            saveas(gcf,sprintf([gaze_variables,'_',monkey_id,'_',type_id,'.jpg']))
            saveas(gcf,sprintf([gaze_variables,'_',monkey_id,'_',type_id,'.epsc']))
        
            clf
    
        end

    end

end


%% Plotting each day as a dot for Gaze condition only

% m1
n_m1=1:length(Gaze_variables_distance);

% Specify variables
for ngaze=n_m1

    gaze_variables=char(Gaze_variables_distance(ngaze));
    monkey_names={'All', 'Lynch', 'Tarantino'};
    
    for nmonkey=1:3
        monkey_id=char(monkey_names(nmonkey));

        %stats_type={'mean','median'};
        stats_type={'mean'};
    
        for n_type=1:length(stats_type)
            
            type_id=char(stats_type(n_type));
    
            % Current Sham vs. Current Stim
            
            subplot(3,3,1)
        
            X=categorical({'Gaze Current Sham','Gaze Current Stim'});
            X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim'});
            Y=[deg_per_px*median(Gaze.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(OFC_day.(monkey_id)));
            line_hs = cell( length(OFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );

            for m=1:length(OFC_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Gaze.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Gaze.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line_labels{m} = OFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('OFC')
            ax1=gca; 
            axis(ax1,'square');
            clear X Y m colorInd line_hs line_labels
            
            subplot(3,3,2)
            
            X=categorical({'Gaze Current Sham','Gaze Current Stim'});
            X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim'});
            Y=[deg_per_px*median(Gaze.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),median(deg_per_px*Gaze.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(ACCg_day.(monkey_id)));
            line_hs = cell( length(ACCg_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );

            for m=1:length(ACCg_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Gaze.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Gaze.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line_labels{m} = ACCg_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('ACCg')
            ax2=gca; 
            axis(ax2,'square');
            clear X Y m colorInd line_hs line_labels
         
            subplot(3,3,3)
            
            X=categorical({'Gaze Current Sham','Gaze Current Stim'});
            X=reordercats(X,{'Gaze Current Sham','Gaze Current Stim'});
            Y=[median(deg_per_px*Gaze.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(dmPFC_day.(monkey_id)));
            line_hs = cell( length(dmPFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );

            for m=1:length(dmPFC_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Gaze.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Gaze.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line_labels{m} = dmPFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
           
            title('dmPFC')
            ax3=gca; 
            axis(ax3,'square');
            clear X Y m colorInd line_hs line_labels
            
            % Previous Sham vs. Stim for Current Sham vs. Stim
            
            subplot(3,3,4)
        
            X=categorical({'Gaze Sham Sham', 'Gaze Stim Sham', 'Gaze Sham Stim', 'Gaze Stim Stim'});
            X=reordercats(X,{'Gaze Sham Sham', 'Gaze Stim Sham', 'Gaze Sham Stim', 'Gaze Stim Stim'});
            Y=[deg_per_px*median(Gaze.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'), deg_per_px*median(Gaze.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
         
            colorInd=jet(length(OFC_day.(monkey_id)));
            line_hs = cell( length(OFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );
        
            for m=1:length(OFC_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Gaze.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Gaze.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(3),deg_per_px*Gaze.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(4),deg_per_px*Gaze.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
               
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(2) X(3)],[deg_per_px*Gaze.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(3) X(4)],[deg_per_px*Gaze.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line_labels{m} = OFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside' , 'FontSize',7);
        
            title('OFC')
            ax4=gca; 
            axis(ax4,'square');
            clear X Y m colorInd line_hs line_labels
            
            subplot(3,3,5)
        
            X=categorical({'Gaze Sham Sham', 'Gaze Stim Sham', 'Gaze Sham Stim', 'Gaze Stim Stim'});
            X=reordercats(X,{'Gaze Sham Sham', 'Gaze Stim Sham', 'Gaze Sham Stim', 'Gaze Stim Stim'});
            Y=[deg_per_px*median(Gaze.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'), deg_per_px*median(Gaze.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
         
            colorInd=jet(length(ACCg_day.(monkey_id)));
            line_hs = cell( length(ACCg_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );
        
            for m=1:length(ACCg_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Gaze.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Gaze.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(3),deg_per_px*Gaze.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(4),deg_per_px*Gaze.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
               
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(2) X(3)],[deg_per_px*Gaze.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(3) X(4)],[deg_per_px*Gaze.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line_labels{m} = ACCg_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside' , 'FontSize',7);
            title('ACCg')
            ax5=gca;
            axis(ax5,'square');
            clear X Y m colorInd line_hs line_labels

            subplot(3,3,6)
        
            X=categorical({'Gaze Sham Sham', 'Gaze Stim Sham', 'Gaze Sham Stim', 'Gaze Stim Stim'});
            X=reordercats(X,{'Gaze Sham Sham', 'Gaze Stim Sham', 'Gaze Sham Stim', 'Gaze Stim Stim'});
            Y=[deg_per_px*median(Gaze.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'), deg_per_px*median(Gaze.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Gaze.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
         
            colorInd=jet(length(dmPFC_day.(monkey_id)));
            line_hs = cell( length(dmPFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );
        
            for m=1:length(dmPFC_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Gaze.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Gaze.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(3),deg_per_px*Gaze.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(4),deg_per_px*Gaze.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
               
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(2) X(3)],[deg_per_px*Gaze.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(3) X(4)],[deg_per_px*Gaze.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Gaze.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line_labels{m} = dmPFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside' , 'FontSize',7);
        
            title('dmPFC')
            ax6=gca; 
            axis(ax6,'square');
            clear X Y m colorInd line_hs line_labels
            
            % Current Stim-Sham
            
            subplot(3,3,7)
    
            X=categorical({'Gaze Current St-Sh'});
            Y=deg_per_px*median((Gaze.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)-Gaze.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)),'omitnan');
            bar(X,Y); hold on
            
            colorInd=jet(length(OFC_day.(monkey_id)));
            scatter_hs=cell(length(OFC_day.(monkey_id)),1);
            scatter_labels=cell(size(scatter_hs));
            
            for m=1:length(OFC_day.(monkey_id))
                
                scatter_hs{m}=scatter(X,(deg_per_px*Gaze.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Gaze.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m)),30,colorInd(m,:),'filled'); hold on   
                scatter_labels{m}=OFC_day.(monkey_id){m};
               
            end
            legend( vertcat(scatter_hs{:}), scatter_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('OFC')
            ax7=gca; 
            axis(ax7,'square');
            clear X Y m colorInd scatter_hs scatter_labels

            subplot(3,3,8)
    
            X=categorical({'Gaze Current St-Sh'});
            Y=deg_per_px*median((Gaze.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)-Gaze.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)),'omitnan');
            bar(X,Y); hold on
            
            colorInd=jet(length(ACCg_day.(monkey_id)));
            scatter_hs=cell(length(ACCg_day.(monkey_id)),1);
            scatter_labels=cell(size(scatter_hs));
            
            for m=1:length(ACCg_day.(monkey_id))
                
                scatter_hs{m}=scatter(X,(deg_per_px*Gaze.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Gaze.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m)),30,colorInd(m,:),'filled'); hold on   
                scatter_labels{m}=ACCg_day.(monkey_id){m};
               
            end
            legend( vertcat(scatter_hs{:}), scatter_labels, 'Location', 'westoutside', 'FontSize',7);        
        
            title('ACCg')
            ax8=gca; 
            axis(ax8,'square');
            clear X Y m colorInd scatter_hs scatter_labels
                    
            subplot(3,3,9)
    
            X=categorical({'Gaze Current St-Sh'});
            Y=deg_per_px*median((Gaze.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)-Gaze.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)),'omitnan');
            bar(X,Y); hold on
            
            colorInd=jet(length(dmPFC_day.(monkey_id)));
            scatter_hs=cell(length(dmPFC_day.(monkey_id)),1);
            scatter_labels=cell(size(scatter_hs));
            
            for m=1:length(dmPFC_day.(monkey_id))
                
                scatter_hs{m}=scatter(X,(deg_per_px*Gaze.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Gaze.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)),30,colorInd(m,:),'filled'); hold on   
                scatter_labels{m}=dmPFC_day.(monkey_id){m};
               
            end
            legend( vertcat(scatter_hs{:}), scatter_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('dmPFC')
            ax9=gca; 
            axis(ax9,'square');
            clear X Y m colorInd scatter_hs scatter_labels
                    
            linkaxes([ax1,ax2,ax3,ax4,ax5,ax6],'y');
            linkaxes([ax7,ax8,ax9],'y');
        
            sgtitle(sprintf([gaze_variables '_' monkey_id '_' type_id]),'Interpreter', 'none')   
            set(gcf, 'Renderer', 'painters');
            saveas(gcf,sprintf([gaze_variables,'_',monkey_id,'_',type_id]))
            saveas(gcf,sprintf([gaze_variables,'_',monkey_id,'_',type_id,'.jpg']))
            saveas(gcf,sprintf([gaze_variables,'_',monkey_id,'_',type_id,'.epsc']))
        
            clf
    
        end

    end

end


%% Plotting each day as a dot for Dot condition only

% m1
n_m1=1:length(Gaze_variables_distance);

% Specify variables
for ngaze=n_m1

    gaze_variables=char(Gaze_variables_distance(ngaze));
    monkey_names={'All', 'Lynch', 'Tarantino'};
    
    for nmonkey=1:3
        monkey_id=char(monkey_names(nmonkey));

        %stats_type={'mean','median'};
        stats_type={'mean'};
    
        for n_type=1:length(stats_type)
            
            type_id=char(stats_type(n_type));
    
            % Current Sham vs. Current Stim
            
            subplot(3,3,1)
        
            X=categorical({'Dot Current Sham','Dot Current Stim'});
            X=reordercats(X,{'Dot Current Sham','Dot Current Stim'});
            Y=[deg_per_px*median(Dot.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(OFC_day.(monkey_id)));
            line_hs = cell( length(OFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );

            for m=1:length(OFC_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Dot.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Dot.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Dot.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line_labels{m} = OFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('OFC')
            ax1=gca; 
            axis(ax1,'square');
            clear X Y m colorInd line_hs line_labels
            
            subplot(3,3,2)
            
            X=categorical({'Dot Current Sham','Dot Current Stim'});
            X=reordercats(X,{'Dot Current Sham','Dot Current Stim'});
            Y=[deg_per_px*median(Dot.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),median(deg_per_px*Dot.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(ACCg_day.(monkey_id)));
            line_hs = cell( length(ACCg_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );

            for m=1:length(ACCg_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Dot.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Dot.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Dot.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line_labels{m} = ACCg_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('ACCg')
            ax2=gca; 
            axis(ax2,'square');
            clear X Y m colorInd line_hs line_labels
         
            subplot(3,3,3)
            
            X=categorical({'Dot Current Sham','Dot Current Stim'});
            X=reordercats(X,{'Dot Current Sham','Dot Current Stim'});
            Y=[median(deg_per_px*Dot.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
            
            colorInd=jet(length(dmPFC_day.(monkey_id)));
            line_hs = cell( length(dmPFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );

            for m=1:length(dmPFC_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Dot.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Dot.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Dot.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line_labels{m} = dmPFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
           
            title('dmPFC')
            ax3=gca; 
            axis(ax3,'square');
            clear X Y m colorInd line_hs line_labels
            
            % Previous Sham vs. Stim for Current Sham vs. Stim
            
            subplot(3,3,4)
        
            X=categorical({'Dot Sham Sham', 'Dot Stim Sham', 'Dot Sham Stim', 'Dot Stim Stim'});
            X=reordercats(X,{'Dot Sham Sham', 'Dot Stim Sham', 'Dot Sham Stim', 'Dot Stim Stim'});
            Y=[deg_per_px*median(Dot.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'), deg_per_px*median(Dot.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
         
            colorInd=jet(length(OFC_day.(monkey_id)));
            line_hs = cell( length(OFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );
        
            for m=1:length(OFC_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Dot.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Dot.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(3),deg_per_px*Dot.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(4),deg_per_px*Dot.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
               
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Gaze.Sham_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(2) X(3)],[deg_per_px*Dot.Stim_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(3) X(4)],[deg_per_px*Dot.Sham_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Stim_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line_labels{m} = OFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside' , 'FontSize',7);
        
            title('OFC')
            ax4=gca; 
            axis(ax4,'square');
            clear X Y m colorInd line_hs line_labels
            
            subplot(3,3,5)
        
            X=categorical({'Dot Sham Sham', 'Dot Stim Sham', 'Dot Sham Stim', 'Dot Stim Stim'});
            X=reordercats(X,{'Dot Sham Sham', 'Dot Stim Sham', 'Dot Sham Stim', 'Dot Stim Stim'});
            Y=[deg_per_px*median(Dot.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'), deg_per_px*median(Dot.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
         
            colorInd=jet(length(ACCg_day.(monkey_id)));
            line_hs = cell( length(ACCg_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );
        
            for m=1:length(ACCg_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Dot.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Dot.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(3),deg_per_px*Dot.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(4),deg_per_px*Dot.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
               
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Dot.Sham_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(2) X(3)],[deg_per_px*Dot.Stim_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(3) X(4)],[deg_per_px*Dot.Sham_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Stim_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line_labels{m} = ACCg_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside' , 'FontSize',7);
            title('ACCg')
            ax5=gca;
            axis(ax5,'square');
            clear X Y m colorInd line_hs line_labels

            subplot(3,3,6)
        
            X=categorical({'Dot Sham Sham', 'Dot Stim Sham', 'Dot Sham Stim', 'Dot Stim Stim'});
            X=reordercats(X,{'Dot Sham Sham', 'Dot Stim Sham', 'Dot Sham Stim', 'Dot Stim Stim'});
            Y=[deg_per_px*median(Dot.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'), deg_per_px*median(Dot.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan'),deg_per_px*median(Dot.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id),'omitnan')];
            bar(X,Y); hold on
         
            colorInd=jet(length(dmPFC_day.(monkey_id)));
            line_hs = cell( length(dmPFC_day.(monkey_id)), 1 );
            line_labels = cell( size(line_hs) );
        
            for m=1:length(dmPFC_day.(monkey_id))
                
                scatter(X(1),deg_per_px*Dot.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on           
                scatter(X(2),deg_per_px*Dot.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(3),deg_per_px*Dot.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
                scatter(X(4),deg_per_px*Dot.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m),30,colorInd(m,:),'filled'); hold on
               
                line_hs{m} = line([X(1) X(2)],[deg_per_px*Dot.Sham_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(2) X(3)],[deg_per_px*Dot.Stim_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on
                line([X(3) X(4)],[deg_per_px*Dot.Sham_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m) deg_per_px*Dot.Stim_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)], 'Color',colorInd(m,:)); hold on         
                line_labels{m} = dmPFC_day.(monkey_id){m};
            
            end
            legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside' , 'FontSize',7);
        
            title('dmPFC')
            ax6=gca; 
            axis(ax6,'square');
            clear X Y m colorInd line_hs line_labels
            
            % Current Stim-Sham
            
            subplot(3,3,7)
    
            X=categorical({'Dot Current St-Sh'});
            Y=deg_per_px*median((Dot.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)-Dot.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)),'omitnan');
            bar(X,Y); hold on
            
            colorInd=jet(length(OFC_day.(monkey_id)));
            scatter_hs=cell(length(OFC_day.(monkey_id)),1);
            scatter_labels=cell(size(scatter_hs));
            
            for m=1:length(OFC_day.(monkey_id))
                
                scatter_hs{m}=scatter(X,(deg_per_px*Dot.Current_Stim.OFC.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Dot.Current_Sham.OFC.(gaze_variables).(monkey_id).(type_id)(m)),30,colorInd(m,:),'filled'); hold on   
                scatter_labels{m}=OFC_day.(monkey_id){m};
               
            end
            legend( vertcat(scatter_hs{:}), scatter_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('OFC')
            ax7=gca; 
            axis(ax7,'square');
            clear X Y m colorInd scatter_hs scatter_labels

            subplot(3,3,8)
    
            X=categorical({'Dot Current St-Sh'});
            Y=deg_per_px*median((Dot.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)-Dot.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)),'omitnan');
            bar(X,Y); hold on
            
            colorInd=jet(length(ACCg_day.(monkey_id)));
            scatter_hs=cell(length(ACCg_day.(monkey_id)),1);
            scatter_labels=cell(size(scatter_hs));
            
            for m=1:length(ACCg_day.(monkey_id))
                
                scatter_hs{m}=scatter(X,(deg_per_px*Dot.Current_Stim.ACCg.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Dot.Current_Sham.ACCg.(gaze_variables).(monkey_id).(type_id)(m)),30,colorInd(m,:),'filled'); hold on   
                scatter_labels{m}=ACCg_day.(monkey_id){m};
               
            end
            legend( vertcat(scatter_hs{:}), scatter_labels, 'Location', 'westoutside', 'FontSize',7);        
        
            title('ACCg')
            ax8=gca; 
            axis(ax8,'square');
            clear X Y m colorInd scatter_hs scatter_labels
                    
            subplot(3,3,9)
    
            X=categorical({'Dot Current St-Sh'});
            Y=deg_per_px*median((Dot.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)-Dot.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)),'omitnan');
            bar(X,Y); hold on
            
            colorInd=jet(length(dmPFC_day.(monkey_id)));
            scatter_hs=cell(length(dmPFC_day.(monkey_id)),1);
            scatter_labels=cell(size(scatter_hs));
            
            for m=1:length(dmPFC_day.(monkey_id))
                
                scatter_hs{m}=scatter(X,(deg_per_px*Dot.Current_Stim.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)-deg_per_px*Dot.Current_Sham.dmPFC.(gaze_variables).(monkey_id).(type_id)(m)),30,colorInd(m,:),'filled'); hold on   
                scatter_labels{m}=dmPFC_day.(monkey_id){m};
               
            end
            legend( vertcat(scatter_hs{:}), scatter_labels, 'Location', 'westoutside', 'FontSize',7);
        
            title('dmPFC')
            ax9=gca; 
            axis(ax9,'square');
            clear X Y m colorInd scatter_hs scatter_labels
                    
            linkaxes([ax1,ax2,ax3,ax4,ax5,ax6],'y');
            linkaxes([ax7,ax8,ax9],'y');
        
            sgtitle(sprintf([gaze_variables '_' monkey_id '_' type_id]),'Interpreter', 'none')   
            set(gcf, 'Renderer', 'painters');
            saveas(gcf,sprintf([gaze_variables,'_',monkey_id,'_',type_id]))
            saveas(gcf,sprintf([gaze_variables,'_',monkey_id,'_',type_id,'.jpg']))
            saveas(gcf,sprintf([gaze_variables,'_',monkey_id,'_',type_id,'.epsc']))
        
            clf
    
        end

    end

end
