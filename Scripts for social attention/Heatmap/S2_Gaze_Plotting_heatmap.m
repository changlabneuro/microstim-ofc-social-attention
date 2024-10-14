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

%% Plotting heatmaps for two monkeys separately and combined (without flipping)

fieldname = fieldnames( GazeHeat );

monkey_names={'Lynch', 'Tarantino','All'};   

for nmonkey=1:3
    monkey_id=char(monkey_names(nmonkey));
    OFC.(monkey_id).idx=[];
    ACCg.(monkey_id).idx=[];
    dmPFC.(monkey_id).idx=[];

    for nOFC=1:length(OFC_day.(monkey_id))
        OFC.(monkey_id).idx=[OFC.(monkey_id).idx find(contains(fieldname,OFC_day.(monkey_id){nOFC})==1)];
    end

    for nACCg=1:length(ACCg_day.(monkey_id))
        ACCg.(monkey_id).idx=[ACCg.(monkey_id).idx find(contains(fieldname,ACCg_day.(monkey_id){nACCg})==1)];
    end

    for ndmPFC=1:length(dmPFC_day.(monkey_id))
        dmPFC.(monkey_id).idx=[dmPFC.(monkey_id).idx find(contains(fieldname,dmPFC_day.(monkey_id){ndmPFC})==1)];
    end

    % OFC
    
    colorbar_range=[-2.5*10^-4 2.5*10^-4];
    filter_para=2.2;

    subplot(3,2,1)
    Gaze_mat_OFC=mean_many(Gaze_mats{OFC.(monkey_id).idx});
    filtered = imgaussfilt( Gaze_mat_OFC, filter_para );
    xs = -20:20;
    ys = -20:20;

    flip_y = true;   
    if ( flip_y )
        filtered = flipud( filtered );
    end 
    imagesc(xs, ys, filtered ); colorbar; hold on
    colormap jet
    rectangle('Position',[mean(Gaze_ROI.eyes(OFC.(monkey_id).idx,1)) mean(Gaze_ROI.eyes(OFC.(monkey_id).idx,2))...
        mean(Gaze_ROI.eyes(OFC.(monkey_id).idx,3)-Gaze_ROI.eyes(OFC.(monkey_id).idx,1)) mean(Gaze_ROI.eyes(OFC.(monkey_id).idx,4)-Gaze_ROI.eyes(OFC.(monkey_id).idx,2))],'EdgeColor','r'); hold on
    rectangle('Position',[mean(Gaze_ROI.mouth(OFC.(monkey_id).idx,1)) mean(Gaze_ROI.mouth(OFC.(monkey_id).idx,2))...
        mean(Gaze_ROI.mouth(OFC.(monkey_id).idx,3)-Gaze_ROI.mouth(OFC.(monkey_id).idx,1)) mean(Gaze_ROI.mouth(OFC.(monkey_id).idx,4)-Gaze_ROI.mouth(OFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
    rectangle('Position',[mean(Gaze_ROI.face(OFC.(monkey_id).idx,1)) mean(Gaze_ROI.face(OFC.(monkey_id).idx,2))...
        mean(Gaze_ROI.face(OFC.(monkey_id).idx,3)-Gaze_ROI.face(OFC.(monkey_id).idx,1)) mean(Gaze_ROI.face(OFC.(monkey_id).idx,4)-Gaze_ROI.face(OFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
    axis square
    title('OFC Gaze');
    caxis(colorbar_range);
    ax1=gca;

    subplot(3,2,2)
    Dot_mat_OFC=mean_many(Dot_mats{OFC.(monkey_id).idx});
    filtered = imgaussfilt( Dot_mat_OFC, filter_para  );
    xs = -20:20;
    ys = -20:20;

    flip_y = true;   
    if ( flip_y )
        filtered = flipud( filtered );
    end 
    imagesc(xs, ys, filtered ); colorbar; hold on
    rectangle('Position',[mean(Dot_ROI.eyes(OFC.(monkey_id).idx,1)) mean(Dot_ROI.eyes(OFC.(monkey_id).idx,2))...
        mean(Dot_ROI.eyes(OFC.(monkey_id).idx,3)-Dot_ROI.eyes(OFC.(monkey_id).idx,1)) mean(Dot_ROI.eyes(OFC.(monkey_id).idx,4)-Dot_ROI.eyes(OFC.(monkey_id).idx,2))],'EdgeColor','r'); hold on
    rectangle('Position',[mean(Dot_ROI.mouth(OFC.(monkey_id).idx,1)) mean(Dot_ROI.mouth(OFC.(monkey_id).idx,2))...
        mean(Dot_ROI.mouth(OFC.(monkey_id).idx,3)-Dot_ROI.mouth(OFC.(monkey_id).idx,1)) mean(Dot_ROI.mouth(OFC.(monkey_id).idx,4)-Dot_ROI.mouth(OFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
    rectangle('Position',[mean(Dot_ROI.face(OFC.(monkey_id).idx,1)) mean(Dot_ROI.face(OFC.(monkey_id).idx,2))...
        mean(Dot_ROI.face(OFC.(monkey_id).idx,3)-Dot_ROI.face(OFC.(monkey_id).idx,1)) mean(Dot_ROI.face(OFC.(monkey_id).idx,4)-Dot_ROI.face(OFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
    axis square
    title('OFC Dot');
    caxis(colorbar_range);
    ax2=gca;

    % ACCg
    
    subplot(3,2,3)
    Gaze_mat_ACCg=mean_many(Gaze_mats{ACCg.(monkey_id).idx});
    filtered = imgaussfilt( Gaze_mat_ACCg, filter_para );
    xs = -20:20;
    ys = -20:20;

    flip_y = true;   
    if ( flip_y )
        filtered = flipud( filtered );
    end 
    imagesc(xs, ys, filtered ); colorbar; hold on
    rectangle('Position',[mean(Gaze_ROI.eyes(ACCg.(monkey_id).idx,1)) mean(Gaze_ROI.eyes(ACCg.(monkey_id).idx,2))...
        mean(Gaze_ROI.eyes(ACCg.(monkey_id).idx,3)-Gaze_ROI.eyes(ACCg.(monkey_id).idx,1)) mean(Gaze_ROI.eyes(ACCg.(monkey_id).idx,4)-Gaze_ROI.eyes(ACCg.(monkey_id).idx,2))],'EdgeColor','r'); hold on
    rectangle('Position',[mean(Gaze_ROI.mouth(ACCg.(monkey_id).idx,1)) mean(Gaze_ROI.mouth(ACCg.(monkey_id).idx,2))...
        mean(Gaze_ROI.mouth(ACCg.(monkey_id).idx,3)-Gaze_ROI.mouth(ACCg.(monkey_id).idx,1)) mean(Gaze_ROI.mouth(ACCg.(monkey_id).idx,4)-Gaze_ROI.mouth(ACCg.(monkey_id).idx,2))],'EdgeColor','k'); hold on
    rectangle('Position',[mean(Gaze_ROI.face(ACCg.(monkey_id).idx,1)) mean(Gaze_ROI.face(ACCg.(monkey_id).idx,2))...
        mean(Gaze_ROI.face(ACCg.(monkey_id).idx,3)-Gaze_ROI.face(ACCg.(monkey_id).idx,1)) mean(Gaze_ROI.face(ACCg.(monkey_id).idx,4)-Gaze_ROI.face(ACCg.(monkey_id).idx,2))],'EdgeColor','k'); hold on
    axis square
    title('ACCg Gaze');
    caxis(colorbar_range);
    ax3=gca;

    subplot(3,2,4)
    Dot_mat_ACCg=mean_many(Dot_mats{ACCg.(monkey_id).idx});
    filtered = imgaussfilt( Dot_mat_ACCg, filter_para );
    xs = -20:20;
    ys = -20:20;

    flip_y = true;   
    if ( flip_y )
        filtered = flipud( filtered );
    end 
    imagesc(xs, ys, filtered ); colorbar; hold on
    rectangle('Position',[mean(Dot_ROI.eyes(ACCg.(monkey_id).idx,1)) mean(Dot_ROI.eyes(ACCg.(monkey_id).idx,2))...
        mean(Dot_ROI.eyes(ACCg.(monkey_id).idx,3)-Dot_ROI.eyes(ACCg.(monkey_id).idx,1)) mean(Dot_ROI.eyes(ACCg.(monkey_id).idx,4)-Dot_ROI.eyes(ACCg.(monkey_id).idx,2))],'EdgeColor','r'); hold on
    rectangle('Position',[mean(Dot_ROI.mouth(ACCg.(monkey_id).idx,1)) mean(Dot_ROI.mouth(ACCg.(monkey_id).idx,2))...
        mean(Dot_ROI.mouth(ACCg.(monkey_id).idx,3)-Dot_ROI.mouth(ACCg.(monkey_id).idx,1)) mean(Dot_ROI.mouth(ACCg.(monkey_id).idx,4)-Dot_ROI.mouth(ACCg.(monkey_id).idx,2))],'EdgeColor','k'); hold on
    rectangle('Position',[mean(Dot_ROI.face(ACCg.(monkey_id).idx,1)) mean(Dot_ROI.face(ACCg.(monkey_id).idx,2))...
        mean(Dot_ROI.face(ACCg.(monkey_id).idx,3)-Dot_ROI.face(ACCg.(monkey_id).idx,1)) mean(Dot_ROI.face(ACCg.(monkey_id).idx,4)-Dot_ROI.face(ACCg.(monkey_id).idx,2))],'EdgeColor','k'); hold on
    axis square
    title('ACCg Dot');
    caxis(colorbar_range);
    ax4=gca;

    % dmPFC

    subplot(3,2,5)
    Gaze_mat_dmPFC=mean_many(Gaze_mats{dmPFC.(monkey_id).idx});
    filtered = imgaussfilt( Gaze_mat_dmPFC, filter_para );
    xs = -20:20;
    ys = -20:20;

    flip_y = true;   
    if ( flip_y )
        filtered = flipud( filtered );
    end 
    imagesc(xs, ys, filtered ); colorbar; hold on
    rectangle('Position',[mean(Gaze_ROI.eyes(dmPFC.(monkey_id).idx,1)) mean(Gaze_ROI.eyes(dmPFC.(monkey_id).idx,2))...
        mean(Gaze_ROI.eyes(dmPFC.(monkey_id).idx,3)-Gaze_ROI.eyes(dmPFC.(monkey_id).idx,1)) mean(Gaze_ROI.eyes(dmPFC.(monkey_id).idx,4)-Gaze_ROI.eyes(dmPFC.(monkey_id).idx,2))],'EdgeColor','r'); hold on
    rectangle('Position',[mean(Gaze_ROI.mouth(dmPFC.(monkey_id).idx,1)) mean(Gaze_ROI.mouth(dmPFC.(monkey_id).idx,2))...
        mean(Gaze_ROI.mouth(dmPFC.(monkey_id).idx,3)-Gaze_ROI.mouth(dmPFC.(monkey_id).idx,1)) mean(Gaze_ROI.mouth(dmPFC.(monkey_id).idx,4)-Gaze_ROI.mouth(dmPFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
    rectangle('Position',[mean(Gaze_ROI.face(dmPFC.(monkey_id).idx,1)) mean(Gaze_ROI.face(dmPFC.(monkey_id).idx,2))...
        mean(Gaze_ROI.face(dmPFC.(monkey_id).idx,3)-Gaze_ROI.face(dmPFC.(monkey_id).idx,1)) mean(Gaze_ROI.face(dmPFC.(monkey_id).idx,4)-Gaze_ROI.face(dmPFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
    axis square
    title('dmPFC Gaze');
    caxis(colorbar_range);
    ax5=gca;

    subplot(3,2,6)
    Dot_mat_dmPFC=mean_many(Dot_mats{dmPFC.(monkey_id).idx});
    filtered = imgaussfilt( Dot_mat_dmPFC, filter_para );
    xs = -20:20;
    ys = -20:20;

    flip_y = true;   
    if ( flip_y )
        filtered = flipud( filtered );
    end 
    imagesc(xs, ys, filtered ); colorbar; hold on
    rectangle('Position',[mean(Dot_ROI.eyes(dmPFC.(monkey_id).idx,1)) mean(Dot_ROI.eyes(dmPFC.(monkey_id).idx,2))...
        mean(Dot_ROI.eyes(dmPFC.(monkey_id).idx,3)-Dot_ROI.eyes(dmPFC.(monkey_id).idx,1)) mean(Dot_ROI.eyes(dmPFC.(monkey_id).idx,4)-Dot_ROI.eyes(dmPFC.(monkey_id).idx,2))],'EdgeColor','r'); hold on
    rectangle('Position',[mean(Dot_ROI.mouth(dmPFC.(monkey_id).idx,1)) mean(Dot_ROI.mouth(dmPFC.(monkey_id).idx,2))...
        mean(Dot_ROI.mouth(dmPFC.(monkey_id).idx,3)-Dot_ROI.mouth(dmPFC.(monkey_id).idx,1)) mean(Dot_ROI.mouth(dmPFC.(monkey_id).idx,4)-Dot_ROI.mouth(dmPFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
    rectangle('Position',[mean(Dot_ROI.face(dmPFC.(monkey_id).idx,1)) mean(Dot_ROI.face(dmPFC.(monkey_id).idx,2))...
        mean(Dot_ROI.face(dmPFC.(monkey_id).idx,3)-Dot_ROI.face(dmPFC.(monkey_id).idx,1)) mean(Dot_ROI.face(dmPFC.(monkey_id).idx,4)-Dot_ROI.face(dmPFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
    axis square
    title('dmPFC Dot');
    caxis(colorbar_range);
    ax6=gca;
   
    sgtitle(sprintf(['fixation heatmap ' monkey_id ' stim-sham']),'Interpreter', 'none')   
    set(gcf, 'Renderer', 'painters');
    saveas(gcf,sprintf(['fixation heatmap_' monkey_id '_stim minus sham']))
    saveas(gcf,sprintf(['fixation heatmap_' monkey_id '_stim minus sham','.jpg']))
    saveas(gcf,sprintf(['fixation heatmap_' monkey_id '_stim minus sham','.epsc']))

    clf

end


%% Plotting heatmaps for two monkeys combined (flip Tarantino's)

fieldname = fieldnames( GazeHeat );  
Gaze_mats_new=Gaze_mats;
Dot_mats_new=Dot_mats;

% Flip Tarantino's heatmap
monkey_names={'Tarantino'}; 

for nmonkey=1
    monkey_id=char(monkey_names(nmonkey));
   
    for nOFC=1:length(OFC_day.(monkey_id))
        OFC_idx=find(contains(fieldname,OFC_day.(monkey_id){nOFC})==1);
        for ncolumn=1:41
        Gaze_mats_new{OFC_idx,1}(:,ncolumn)=Gaze_mats{OFC_idx,1}(:,41-ncolumn+1);
        Dot_mats_new{OFC_idx,1}(:,ncolumn)=Dot_mats{OFC_idx,1}(:,41-ncolumn+1);
        end
        clear OFC_idx
    end

    for nACCg=1:length(ACCg_day.(monkey_id))
        ACCg_idx=find(contains(fieldname,ACCg_day.(monkey_id){nACCg})==1);
        for ncolumn=1:41
        Gaze_mats_new{ACCg_idx,1}(:,ncolumn)=Gaze_mats{ACCg_idx,1}(:,41-ncolumn+1);
        Dot_mats_new{ACCg_idx,1}(:,ncolumn)=Dot_mats{ACCg_idx,1}(:,41-ncolumn+1);
        end
        clear ACCg_idx
    end

   for ndmPFC=1:length(dmPFC_day.(monkey_id))
        dmPFC_idx=find(contains(fieldname,dmPFC_day.(monkey_id){ndmPFC})==1);
        for ncolumn=1:41
        Gaze_mats_new{dmPFC_idx,1}(:,ncolumn)=Gaze_mats{dmPFC_idx,1}(:,41-ncolumn+1);
        Dot_mats_new{dmPFC_idx,1}(:,ncolumn)=Dot_mats{dmPFC_idx,1}(:,41-ncolumn+1);
        end
        clear dmPFC_idx
    end
end

clear fieldname monkey_names

% Plot

fieldname = fieldnames( GazeHeat );
monkey_names={'All'};   

nmonkey=1;
monkey_id=char(monkey_names(nmonkey));
OFC.(monkey_id).idx=[];
ACCg.(monkey_id).idx=[];
dmPFC.(monkey_id).idx=[];

for nOFC=1:length(OFC_day.(monkey_id))
    OFC.(monkey_id).idx=[OFC.(monkey_id).idx find(contains(fieldname,OFC_day.(monkey_id){nOFC})==1)];
end

for nACCg=1:length(ACCg_day.(monkey_id))
    ACCg.(monkey_id).idx=[ACCg.(monkey_id).idx find(contains(fieldname,ACCg_day.(monkey_id){nACCg})==1)];
end

for ndmPFC=1:length(dmPFC_day.(monkey_id))
    dmPFC.(monkey_id).idx=[dmPFC.(monkey_id).idx find(contains(fieldname,dmPFC_day.(monkey_id){ndmPFC})==1)];
end

 % OFC

colorbar_range=[-2.5*10^-4 2.5*10^-4];
filter_para=2.2;

subplot(3,2,1)
Gaze_mat_OFC=mean_many(Gaze_mats_new{OFC.(monkey_id).idx});
filtered = imgaussfilt( Gaze_mat_OFC, filter_para );
xs = -20:20;
ys = -20:20;

flip_y = true;   
if ( flip_y )
    filtered = flipud( filtered );
end 
imagesc(xs, ys, filtered ); colorbar; hold on
colormap jet
rectangle('Position',[mean(Gaze_ROI.eyes(OFC.(monkey_id).idx,1)) mean(Gaze_ROI.eyes(OFC.(monkey_id).idx,2))...
    mean(Gaze_ROI.eyes(OFC.(monkey_id).idx,3)-Gaze_ROI.eyes(OFC.(monkey_id).idx,1)) mean(Gaze_ROI.eyes(OFC.(monkey_id).idx,4)-Gaze_ROI.eyes(OFC.(monkey_id).idx,2))],'EdgeColor','r'); hold on
rectangle('Position',[mean(Gaze_ROI.mouth(OFC.(monkey_id).idx,1)) mean(Gaze_ROI.mouth(OFC.(monkey_id).idx,2))...
    mean(Gaze_ROI.mouth(OFC.(monkey_id).idx,3)-Gaze_ROI.mouth(OFC.(monkey_id).idx,1)) mean(Gaze_ROI.mouth(OFC.(monkey_id).idx,4)-Gaze_ROI.mouth(OFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
rectangle('Position',[mean(Gaze_ROI.face(OFC.(monkey_id).idx,1)) mean(Gaze_ROI.face(OFC.(monkey_id).idx,2))...
    mean(Gaze_ROI.face(OFC.(monkey_id).idx,3)-Gaze_ROI.face(OFC.(monkey_id).idx,1)) mean(Gaze_ROI.face(OFC.(monkey_id).idx,4)-Gaze_ROI.face(OFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
axis square
title('OFC Gaze');
caxis(colorbar_range);
ax1=gca;

subplot(3,2,2)
Dot_mat_OFC=mean_many(Dot_mats_new{OFC.(monkey_id).idx});
filtered = imgaussfilt( Dot_mat_OFC, filter_para  );
xs = -20:20;
ys = -20:20;

flip_y = true;   
if ( flip_y )
    filtered = flipud( filtered );
end 
imagesc(xs, ys, filtered ); colorbar; hold on
rectangle('Position',[mean(Dot_ROI.eyes(OFC.(monkey_id).idx,1)) mean(Dot_ROI.eyes(OFC.(monkey_id).idx,2))...
    mean(Dot_ROI.eyes(OFC.(monkey_id).idx,3)-Dot_ROI.eyes(OFC.(monkey_id).idx,1)) mean(Dot_ROI.eyes(OFC.(monkey_id).idx,4)-Dot_ROI.eyes(OFC.(monkey_id).idx,2))],'EdgeColor','r'); hold on
rectangle('Position',[mean(Dot_ROI.mouth(OFC.(monkey_id).idx,1)) mean(Dot_ROI.mouth(OFC.(monkey_id).idx,2))...
    mean(Dot_ROI.mouth(OFC.(monkey_id).idx,3)-Dot_ROI.mouth(OFC.(monkey_id).idx,1)) mean(Dot_ROI.mouth(OFC.(monkey_id).idx,4)-Dot_ROI.mouth(OFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
rectangle('Position',[mean(Dot_ROI.face(OFC.(monkey_id).idx,1)) mean(Dot_ROI.face(OFC.(monkey_id).idx,2))...
    mean(Dot_ROI.face(OFC.(monkey_id).idx,3)-Dot_ROI.face(OFC.(monkey_id).idx,1)) mean(Dot_ROI.face(OFC.(monkey_id).idx,4)-Dot_ROI.face(OFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
axis square
title('OFC Dot');
caxis(colorbar_range);
ax2=gca;

% ACCg

subplot(3,2,3)
Gaze_mat_ACCg=mean_many(Gaze_mats_new{ACCg.(monkey_id).idx});
filtered = imgaussfilt( Gaze_mat_ACCg, filter_para );
xs = -20:20;
ys = -20:20;

flip_y = true;   
if ( flip_y )
    filtered = flipud( filtered );
end 
imagesc(xs, ys, filtered ); colorbar; hold on
rectangle('Position',[mean(Gaze_ROI.eyes(ACCg.(monkey_id).idx,1)) mean(Gaze_ROI.eyes(ACCg.(monkey_id).idx,2))...
    mean(Gaze_ROI.eyes(ACCg.(monkey_id).idx,3)-Gaze_ROI.eyes(ACCg.(monkey_id).idx,1)) mean(Gaze_ROI.eyes(ACCg.(monkey_id).idx,4)-Gaze_ROI.eyes(ACCg.(monkey_id).idx,2))],'EdgeColor','r'); hold on
rectangle('Position',[mean(Gaze_ROI.mouth(ACCg.(monkey_id).idx,1)) mean(Gaze_ROI.mouth(ACCg.(monkey_id).idx,2))...
    mean(Gaze_ROI.mouth(ACCg.(monkey_id).idx,3)-Gaze_ROI.mouth(ACCg.(monkey_id).idx,1)) mean(Gaze_ROI.mouth(ACCg.(monkey_id).idx,4)-Gaze_ROI.mouth(ACCg.(monkey_id).idx,2))],'EdgeColor','k'); hold on
rectangle('Position',[mean(Gaze_ROI.face(ACCg.(monkey_id).idx,1)) mean(Gaze_ROI.face(ACCg.(monkey_id).idx,2))...
    mean(Gaze_ROI.face(ACCg.(monkey_id).idx,3)-Gaze_ROI.face(ACCg.(monkey_id).idx,1)) mean(Gaze_ROI.face(ACCg.(monkey_id).idx,4)-Gaze_ROI.face(ACCg.(monkey_id).idx,2))],'EdgeColor','k'); hold on
axis square
title('ACCg Gaze');
caxis(colorbar_range);
ax3=gca;

subplot(3,2,4)
Dot_mat_ACCg=mean_many(Dot_mats_new{ACCg.(monkey_id).idx});
filtered = imgaussfilt( Dot_mat_ACCg, filter_para );
xs = -20:20;
ys = -20:20;

flip_y = true;   
if ( flip_y )
    filtered = flipud( filtered );
end 
imagesc(xs, ys, filtered ); colorbar; hold on
rectangle('Position',[mean(Dot_ROI.eyes(ACCg.(monkey_id).idx,1)) mean(Dot_ROI.eyes(ACCg.(monkey_id).idx,2))...
    mean(Dot_ROI.eyes(ACCg.(monkey_id).idx,3)-Dot_ROI.eyes(ACCg.(monkey_id).idx,1)) mean(Dot_ROI.eyes(ACCg.(monkey_id).idx,4)-Dot_ROI.eyes(ACCg.(monkey_id).idx,2))],'EdgeColor','r'); hold on
rectangle('Position',[mean(Dot_ROI.mouth(ACCg.(monkey_id).idx,1)) mean(Dot_ROI.mouth(ACCg.(monkey_id).idx,2))...
    mean(Dot_ROI.mouth(ACCg.(monkey_id).idx,3)-Dot_ROI.mouth(ACCg.(monkey_id).idx,1)) mean(Dot_ROI.mouth(ACCg.(monkey_id).idx,4)-Dot_ROI.mouth(ACCg.(monkey_id).idx,2))],'EdgeColor','k'); hold on
rectangle('Position',[mean(Dot_ROI.face(ACCg.(monkey_id).idx,1)) mean(Dot_ROI.face(ACCg.(monkey_id).idx,2))...
    mean(Dot_ROI.face(ACCg.(monkey_id).idx,3)-Dot_ROI.face(ACCg.(monkey_id).idx,1)) mean(Dot_ROI.face(ACCg.(monkey_id).idx,4)-Dot_ROI.face(ACCg.(monkey_id).idx,2))],'EdgeColor','k'); hold on
axis square
title('ACCg Dot');
caxis(colorbar_range);
ax4=gca;

% dmPFC

subplot(3,2,5)
Gaze_mat_dmPFC=mean_many(Gaze_mats_new{dmPFC.(monkey_id).idx});
filtered = imgaussfilt( Gaze_mat_dmPFC, filter_para );
xs = -20:20;
ys = -20:20;

flip_y = true;   
if ( flip_y )
    filtered = flipud( filtered );
end 
imagesc(xs, ys, filtered ); colorbar; hold on
rectangle('Position',[mean(Gaze_ROI.eyes(dmPFC.(monkey_id).idx,1)) mean(Gaze_ROI.eyes(dmPFC.(monkey_id).idx,2))...
    mean(Gaze_ROI.eyes(dmPFC.(monkey_id).idx,3)-Gaze_ROI.eyes(dmPFC.(monkey_id).idx,1)) mean(Gaze_ROI.eyes(dmPFC.(monkey_id).idx,4)-Gaze_ROI.eyes(dmPFC.(monkey_id).idx,2))],'EdgeColor','r'); hold on
rectangle('Position',[mean(Gaze_ROI.mouth(dmPFC.(monkey_id).idx,1)) mean(Gaze_ROI.mouth(dmPFC.(monkey_id).idx,2))...
    mean(Gaze_ROI.mouth(dmPFC.(monkey_id).idx,3)-Gaze_ROI.mouth(dmPFC.(monkey_id).idx,1)) mean(Gaze_ROI.mouth(dmPFC.(monkey_id).idx,4)-Gaze_ROI.mouth(dmPFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
rectangle('Position',[mean(Gaze_ROI.face(dmPFC.(monkey_id).idx,1)) mean(Gaze_ROI.face(dmPFC.(monkey_id).idx,2))...
    mean(Gaze_ROI.face(dmPFC.(monkey_id).idx,3)-Gaze_ROI.face(dmPFC.(monkey_id).idx,1)) mean(Gaze_ROI.face(dmPFC.(monkey_id).idx,4)-Gaze_ROI.face(dmPFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
axis square
title('dmPFC Gaze');
caxis(colorbar_range);
ax5=gca;

subplot(3,2,6)
Dot_mat_dmPFC=mean_many(Dot_mats_new{dmPFC.(monkey_id).idx});
filtered = imgaussfilt( Dot_mat_dmPFC, filter_para );
xs = -20:20;
ys = -20:20;

flip_y = true;   
if ( flip_y )
    filtered = flipud( filtered );
end 
imagesc(xs, ys, filtered ); colorbar; hold on
rectangle('Position',[mean(Dot_ROI.eyes(dmPFC.(monkey_id).idx,1)) mean(Dot_ROI.eyes(dmPFC.(monkey_id).idx,2))...
    mean(Dot_ROI.eyes(dmPFC.(monkey_id).idx,3)-Dot_ROI.eyes(dmPFC.(monkey_id).idx,1)) mean(Dot_ROI.eyes(dmPFC.(monkey_id).idx,4)-Dot_ROI.eyes(dmPFC.(monkey_id).idx,2))],'EdgeColor','r'); hold on
rectangle('Position',[mean(Dot_ROI.mouth(dmPFC.(monkey_id).idx,1)) mean(Dot_ROI.mouth(dmPFC.(monkey_id).idx,2))...
    mean(Dot_ROI.mouth(dmPFC.(monkey_id).idx,3)-Dot_ROI.mouth(dmPFC.(monkey_id).idx,1)) mean(Dot_ROI.mouth(dmPFC.(monkey_id).idx,4)-Dot_ROI.mouth(dmPFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
rectangle('Position',[mean(Dot_ROI.face(dmPFC.(monkey_id).idx,1)) mean(Dot_ROI.face(dmPFC.(monkey_id).idx,2))...
    mean(Dot_ROI.face(dmPFC.(monkey_id).idx,3)-Dot_ROI.face(dmPFC.(monkey_id).idx,1)) mean(Dot_ROI.face(dmPFC.(monkey_id).idx,4)-Dot_ROI.face(dmPFC.(monkey_id).idx,2))],'EdgeColor','k'); hold on
axis square
title('dmPFC Dot');
caxis(colorbar_range);
ax6=gca;

sgtitle(sprintf(['fixation heatmap ' monkey_id ' stim-sham']),'Interpreter', 'none')   
set(gcf, 'Renderer', 'painters');
saveas(gcf,sprintf(['fixation heatmap_' monkey_id '_stim minus sham']))
saveas(gcf,sprintf(['fixation heatmap_' monkey_id '_stim minus sham','.jpg']))
saveas(gcf,sprintf(['fixation heatmap_' monkey_id '_stim minus sham','.epsc']))

clf
