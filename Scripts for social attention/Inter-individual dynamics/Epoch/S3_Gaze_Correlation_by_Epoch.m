%% Calculate correlation between causal index and distance to eyes for stim in late and early epoches

% Upload Decomp_Temporal_Combined.mat and Decomp_Temporal_shuffled_Combined.mat 

h = 27; % monitor height in cm
d = 50; % subject to monitor in cm
r=768; % monitor height in pixel

deg_per_px = rad2deg(atan2(.5*h, d)) / (.5*r); 
px_per_deg = 1/deg_per_px;

fieldname=fieldnames(Decomp_Temporal_shuffled);
time_bin={'stim_1_45','stim_46_90'};

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    
    for n_bin=1:2

        bin_id=char(time_bin(n_bin));

        % real data

        [Corr_combined_stim.(field_id).(bin_id).distance.rho, Corr_combined_stim.(field_id).(bin_id).distance.p]=corr(deg_per_px*Decomp_Temporal.(field_id).(bin_id).stim.m1_distance_to_eyes',Decomp_Temporal.(field_id).(bin_id).stim.causal_m1m2_eyes_true','Type','Spearman','Rows','pairwise');
        [Corr_combined_stim.(field_id).(bin_id).ipsi.rho, Corr_combined_stim.(field_id).(bin_id).ipsi.p]=corr(deg_per_px*Decomp_Temporal.(field_id).(bin_id).stim.m1_distance_to_eyes_ipsi',Decomp_Temporal.(field_id).(bin_id).stim.causal_m1m2_eyes_true','Type','Spearman','Rows','pairwise');
        [Corr_combined_stim.(field_id).(bin_id).contra.rho, Corr_combined_stim.(field_id).(bin_id).contra.p]=corr(deg_per_px*Decomp_Temporal.(field_id).(bin_id).stim.m1_distance_to_eyes_contra',Decomp_Temporal.(field_id).(bin_id).stim.causal_m1m2_eyes_true','Type','Spearman','Rows','pairwise');
        
        [Corr_combined_sham.(field_id).(bin_id).distance.rho, Corr_combined_sham.(field_id).(bin_id).distance.p]=corr(deg_per_px*Decomp_Temporal.(field_id).(bin_id).sham.m1_distance_to_eyes',Decomp_Temporal.(field_id).(bin_id).sham.causal_m1m2_eyes_true','Type','Spearman','Rows','pairwise');
        [Corr_combined_sham.(field_id).(bin_id).ipsi.rho, Corr_combined_sham.(field_id).(bin_id).ipsi.p]=corr(deg_per_px*Decomp_Temporal.(field_id).(bin_id).sham.m1_distance_to_eyes_ipsi',Decomp_Temporal.(field_id).(bin_id).sham.causal_m1m2_eyes_true','Type','Spearman','Rows','pairwise');
        [Corr_combined_sham.(field_id).(bin_id).contra.rho, Corr_combined_sham.(field_id).(bin_id).contra.p]=corr(deg_per_px*Decomp_Temporal.(field_id).(bin_id).sham.m1_distance_to_eyes_contra',Decomp_Temporal.(field_id).(bin_id).sham.causal_m1m2_eyes_true','Type','Spearman','Rows','pairwise');
        
        mdl_stim_distance.(bin_id)=fitlm(deg_per_px*Decomp_Temporal.(field_id).(bin_id).stim.m1_distance_to_eyes',Decomp_Temporal.(field_id).(bin_id).stim.causal_m1m2_eyes_true');
        mdl_stim_ipsi.(bin_id)=fitlm(deg_per_px*Decomp_Temporal.(field_id).(bin_id).stim.m1_distance_to_eyes_ipsi',Decomp_Temporal.(field_id).(bin_id).stim.causal_m1m2_eyes_true');
        mdl_stim_contra.(bin_id)=fitlm(deg_per_px*Decomp_Temporal.(field_id).(bin_id).stim.m1_distance_to_eyes_contra',Decomp_Temporal.(field_id).(bin_id).stim.causal_m1m2_eyes_true');

        mdl_sham_distance.(bin_id)=fitlm(deg_per_px*Decomp_Temporal.(field_id).(bin_id).sham.m1_distance_to_eyes',Decomp_Temporal.(field_id).(bin_id).sham.causal_m1m2_eyes_true');
        mdl_sham_ipsi.(bin_id)=fitlm(deg_per_px*Decomp_Temporal.(field_id).(bin_id).sham.m1_distance_to_eyes_ipsi',Decomp_Temporal.(field_id).(bin_id).sham.causal_m1m2_eyes_true');
        mdl_sham_contra.(bin_id)=fitlm(deg_per_px*Decomp_Temporal.(field_id).(bin_id).sham.m1_distance_to_eyes_contra',Decomp_Temporal.(field_id).(bin_id).sham.causal_m1m2_eyes_true');

        mdl.(field_id).(bin_id).stim_distance_slope=mdl_stim_distance.(bin_id).Coefficients.Estimate(2);
        mdl.(field_id).(bin_id).stim_ipsi_slope=mdl_stim_ipsi.(bin_id).Coefficients.Estimate(2);
        mdl.(field_id).(bin_id).stim_contra_slope=mdl_stim_contra.(bin_id).Coefficients.Estimate(2);

        mdl.(field_id).(bin_id).sham_distance_slope=mdl_sham_distance.(bin_id).Coefficients.Estimate(2);
        mdl.(field_id).(bin_id).sham_ipsi_slope=mdl_sham_ipsi.(bin_id).Coefficients.Estimate(2);
        mdl.(field_id).(bin_id).sham_contra_slope=mdl_sham_contra.(bin_id).Coefficients.Estimate(2);

        for rep=1:1000

            [Corr_combined_stim_shuffled.(field_id).(bin_id).distance.rho(rep), Corr_combined_stim_shuffled.(field_id).(bin_id).distance.p(rep)]=corr(deg_per_px*Decomp_Temporal_shuffled.(field_id).(bin_id).stim.m1_distance_to_eyes(rep,:)',Decomp_Temporal_shuffled.(field_id).(bin_id).stim.causal_m1m2_eyes_null(rep,:)','Type','Spearman','Rows','pairwise');
            [Corr_combined_stim_shuffled.(field_id).(bin_id).ipsi.rho(rep), Corr_combined_stim_shuffled.(field_id).(bin_id).ipsi.p(rep)]=corr(deg_per_px*Decomp_Temporal_shuffled.(field_id).(bin_id).stim.m1_distance_to_eyes_ipsi(rep,:)',Decomp_Temporal_shuffled.(field_id).(bin_id).stim.causal_m1m2_eyes_null(rep,:)','Type','Spearman','Rows','pairwise');
            [Corr_combined_stim_shuffled.(field_id).(bin_id).contra.rho(rep), Corr_combined_stim_shuffled.(field_id).(bin_id).contra.p(rep)]=corr(deg_per_px*Decomp_Temporal_shuffled.(field_id).(bin_id).stim.m1_distance_to_eyes_contra(rep,:)',Decomp_Temporal_shuffled.(field_id).(bin_id).stim.causal_m1m2_eyes_null(rep,:)','Type','Spearman','Rows','pairwise');
            
            mdl_stim_distance_shuffled.(bin_id)=fitlm(deg_per_px*Decomp_Temporal_shuffled.(field_id).(bin_id).stim.m1_distance_to_eyes(rep,:)',Decomp_Temporal_shuffled.(field_id).(bin_id).stim.causal_m1m2_eyes_null(rep,:)');
            mdl_stim_ipsi_shuffled.(bin_id)=fitlm(deg_per_px*Decomp_Temporal_shuffled.(field_id).(bin_id).stim.m1_distance_to_eyes_ipsi(rep,:)',Decomp_Temporal_shuffled.(field_id).(bin_id).stim.causal_m1m2_eyes_null(rep,:)');
            mdl_stim_contra_shuffled.(bin_id)=fitlm(deg_per_px*Decomp_Temporal_shuffled.(field_id).(bin_id).stim.m1_distance_to_eyes_contra(rep,:)',Decomp_Temporal_shuffled.(field_id).(bin_id).stim.causal_m1m2_eyes_null(rep,:)');
            
            mdl_shuffled.(field_id).(bin_id).stim_distance_slope(rep)=mdl_stim_distance_shuffled.(bin_id).Coefficients.Estimate(2);
            mdl_shuffled.(field_id).(bin_id).stim_ipsi_slope(rep)=mdl_stim_ipsi_shuffled.(bin_id).Coefficients.Estimate(2);
            mdl_shuffled.(field_id).(bin_id).stim_contra_slope(rep)=mdl_stim_contra_shuffled.(bin_id).Coefficients.Estimate(2);
            
            [Corr_combined_sham_shuffled.(field_id).(bin_id).distance.rho(rep), Corr_combined_sham_shuffled.(field_id).(bin_id).distance.p(rep)]=corr(deg_per_px*Decomp_Temporal_shuffled.(field_id).(bin_id).sham.m1_distance_to_eyes(rep,:)',Decomp_Temporal_shuffled.(field_id).(bin_id).sham.causal_m1m2_eyes_null(rep,:)','Type','Spearman','Rows','pairwise');
            [Corr_combined_sham_shuffled.(field_id).(bin_id).ipsi.rho(rep), Corr_combined_sham_shuffled.(field_id).(bin_id).ipsi.p(rep)]=corr(deg_per_px*Decomp_Temporal_shuffled.(field_id).(bin_id).sham.m1_distance_to_eyes_ipsi(rep,:)',Decomp_Temporal_shuffled.(field_id).(bin_id).sham.causal_m1m2_eyes_null(rep,:)','Type','Spearman','Rows','pairwise');
            [Corr_combined_sham_shuffled.(field_id).(bin_id).contra.rho(rep), Corr_combined_sham_shuffled.(field_id).(bin_id).contra.p(rep)]=corr(deg_per_px*Decomp_Temporal_shuffled.(field_id).(bin_id).sham.m1_distance_to_eyes_contra(rep,:)',Decomp_Temporal_shuffled.(field_id).(bin_id).sham.causal_m1m2_eyes_null(rep,:)','Type','Spearman','Rows','pairwise');

            mdl_sham_distance_shuffled.(bin_id)=fitlm(deg_per_px*Decomp_Temporal_shuffled.(field_id).(bin_id).sham.m1_distance_to_eyes(rep,:)',Decomp_Temporal_shuffled.(field_id).(bin_id).sham.causal_m1m2_eyes_null(rep,:)');
            mdl_sham_ipsi_shuffled.(bin_id)=fitlm(deg_per_px*Decomp_Temporal_shuffled.(field_id).(bin_id).sham.m1_distance_to_eyes_ipsi(rep,:)',Decomp_Temporal_shuffled.(field_id).(bin_id).sham.causal_m1m2_eyes_null(rep,:)');
            mdl_sham_contra_shuffled.(bin_id)=fitlm(deg_per_px*Decomp_Temporal_shuffled.(field_id).(bin_id).sham.m1_distance_to_eyes_contra(rep,:)',Decomp_Temporal_shuffled.(field_id).(bin_id).sham.causal_m1m2_eyes_null(rep,:)');
            
            mdl_shuffled.(field_id).(bin_id).sham_distance_slope(rep)=mdl_sham_distance_shuffled.(bin_id).Coefficients.Estimate(2);
            mdl_shuffled.(field_id).(bin_id).sham_ipsi_slope(rep)=mdl_sham_ipsi_shuffled.(bin_id).Coefficients.Estimate(2);
            mdl_shuffled.(field_id).(bin_id).sham_contra_slope(rep)=mdl_sham_contra_shuffled.(bin_id).Coefficients.Estimate(2);
            
            clear mdl_stim_distance_shuffled mdl_stim_ipsi_shuffled mdl_stim_contra_shuffled mdl_sham_distance_shuffled mdl_sham_ipsi_shuffled mdl_sham_contra_shuffled

        end

        clear bin_id mdl_stim_distance mdl_stim_ipsi mdl_stim_contra mdl_sham_distance mdl_sham_ipsi mdl_sham_contra 
        
    end
    
end

Corr.Stim=Corr_combined_stim;
Corr.Sham=Corr_combined_sham;
Corr.Stim_shuffled=Corr_combined_stim_shuffled;
Corr.Sham_shuffled=Corr_combined_sham_shuffled;
Model.mdl=mdl;
Model.mdl_shuffled=mdl_shuffled;

save('Decomp_Temporal_Correlation_Combined.mat','Corr','-v7.3') 
save('Decomp_Temporal_Slope_Combined.mat','Model','-v7.3') 

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

%% Collapse data for each region (correlation rho, p, slope; stim effect on dmPFC slope and rho)

% Upload Decomp_Temporal_Slope_Combined_Epoch.mat and Decomp_Temporal_Correlation_Combined_Epoch.mat 

monkey_names={'All', 'Lynch', 'Tarantino'};
distance_variables={'distance','contra','ipsi'};

for nmonkey=1:3
    monkey_id=char(monkey_names(nmonkey));
    
    for ndistance=1:3
        distance_id=char(distance_variables(ndistance));
        stim_slope_id=['stim_' distance_id '_slope'];
        sham_slope_id=['sham_' distance_id '_slope'];

        % OFC
    
        % real stim and sham
        OFC.(monkey_id).stim_late.(distance_id).rho=[];
        OFC.(monkey_id).stim_late.(distance_id).p=[];
        OFC.(monkey_id).stim_late.(distance_id).slope=[];
        OFC.(monkey_id).stim_early.(distance_id).rho=[];
        OFC.(monkey_id).stim_early.(distance_id).p=[];
        OFC.(monkey_id).stim_early.(distance_id).slope=[];
    
        OFC.(monkey_id).sham_late.(distance_id).rho=[];
        OFC.(monkey_id).sham_late.(distance_id).p=[];
        OFC.(monkey_id).sham_late.(distance_id).slope=[];
        OFC.(monkey_id).sham_early.(distance_id).rho=[];
        OFC.(monkey_id).sham_early.(distance_id).p=[];
        OFC.(monkey_id).sham_early.(distance_id).slope=[];
    
        % shuffle 
        OFC.(monkey_id).stim_late.(distance_id).rho_shuffled=[];
        OFC.(monkey_id).stim_late.(distance_id).p_shuffled=[];
        OFC.(monkey_id).stim_late.(distance_id).slope_shuffled=[];
        OFC.(monkey_id).stim_early.(distance_id).rho_shuffled=[];
        OFC.(monkey_id).stim_early.(distance_id).p_shuffled=[];
        OFC.(monkey_id).stim_early.(distance_id).slope_shuffled=[];
    
        OFC.(monkey_id).sham_late.(distance_id).rho_shuffled=[];
        OFC.(monkey_id).sham_late.(distance_id).p_shuffled=[];
        OFC.(monkey_id).sham_late.(distance_id).slope_shuffled=[];
        OFC.(monkey_id).sham_early.(distance_id).rho_shuffled=[];
        OFC.(monkey_id).sham_early.(distance_id).p_shuffled=[];
        OFC.(monkey_id).sham_early.(distance_id).slope_shuffled=[];
    
        for nOFC=1:length(OFC_day.(monkey_id))
    
            field_id=char(strcat('data_',OFC_day.(monkey_id)(nOFC)));
    
            % real stim and sham
            OFC.(monkey_id).stim_late.(distance_id).rho=[OFC.(monkey_id).stim_late.(distance_id).rho Corr.Stim.(field_id).stim_46_90.(distance_id).rho];
            OFC.(monkey_id).stim_late.(distance_id).p=[OFC.(monkey_id).stim_late.(distance_id).p Corr.Stim.(field_id).stim_46_90.(distance_id).p];
            OFC.(monkey_id).stim_late.(distance_id).slope=[OFC.(monkey_id).stim_late.(distance_id).slope Model.mdl.(field_id).stim_46_90.(stim_slope_id)];
    
            OFC.(monkey_id).stim_early.(distance_id).rho=[OFC.(monkey_id).stim_early.(distance_id).rho Corr.Stim.(field_id).stim_1_45.(distance_id).rho];
            OFC.(monkey_id).stim_early.(distance_id).p=[OFC.(monkey_id).stim_early.(distance_id).p Corr.Stim.(field_id).stim_1_45.(distance_id).p];
            OFC.(monkey_id).stim_early.(distance_id).slope=[OFC.(monkey_id).stim_early.(distance_id).slope Model.mdl.(field_id).stim_1_45.(stim_slope_id)];
    
            OFC.(monkey_id).sham_late.(distance_id).rho=[OFC.(monkey_id).sham_late.(distance_id).rho Corr.Sham.(field_id).stim_46_90.(distance_id).rho];
            OFC.(monkey_id).sham_late.(distance_id).p=[OFC.(monkey_id).sham_late.(distance_id).p Corr.Sham.(field_id).stim_46_90.(distance_id).p];
            OFC.(monkey_id).sham_late.(distance_id).slope=[OFC.(monkey_id).sham_late.(distance_id).slope Model.mdl.(field_id).stim_46_90.(sham_slope_id)];
    
            OFC.(monkey_id).sham_early.(distance_id).rho=[OFC.(monkey_id).sham_early.(distance_id).rho Corr.Sham.(field_id).stim_1_45.(distance_id).rho];
            OFC.(monkey_id).sham_early.(distance_id).p=[OFC.(monkey_id).sham_early.(distance_id).p Corr.Sham.(field_id).stim_1_45.(distance_id).p];
            OFC.(monkey_id).sham_early.(distance_id).slope=[OFC.(monkey_id).sham_early.(distance_id).slope Model.mdl.(field_id).stim_1_45.(sham_slope_id)];
    
            % shuffled
            OFC.(monkey_id).stim_late.(distance_id).rho_shuffled=horzcat(OFC.(monkey_id).stim_late.(distance_id).rho_shuffled, Corr.Stim_shuffled.(field_id).stim_46_90.(distance_id).rho');
            OFC.(monkey_id).stim_late.(distance_id).p_shuffled=horzcat(OFC.(monkey_id).stim_late.(distance_id).p_shuffled, Corr.Stim_shuffled.(field_id).stim_46_90.(distance_id).p');
            OFC.(monkey_id).stim_late.(distance_id).slope_shuffled=horzcat(OFC.(monkey_id).stim_late.(distance_id).slope_shuffled, Model.mdl_shuffled.(field_id).stim_46_90.(stim_slope_id)');
    
            OFC.(monkey_id).stim_early.(distance_id).rho_shuffled=horzcat(OFC.(monkey_id).stim_early.(distance_id).rho_shuffled, Corr.Stim_shuffled.(field_id).stim_1_45.(distance_id).rho');
            OFC.(monkey_id).stim_early.(distance_id).p_shuffled=horzcat(OFC.(monkey_id).stim_early.(distance_id).p_shuffled, Corr.Stim_shuffled.(field_id).stim_1_45.(distance_id).p');
            OFC.(monkey_id).stim_early.(distance_id).slope_shuffled=horzcat(OFC.(monkey_id).stim_early.(distance_id).slope_shuffled, Model.mdl_shuffled.(field_id).stim_1_45.(stim_slope_id)');
        
            OFC.(monkey_id).sham_late.(distance_id).rho_shuffled=horzcat(OFC.(monkey_id).sham_late.(distance_id).rho_shuffled, Corr.Sham_shuffled.(field_id).stim_46_90.(distance_id).rho');
            OFC.(monkey_id).sham_late.(distance_id).p_shuffled=horzcat(OFC.(monkey_id).sham_late.(distance_id).p_shuffled, Corr.Sham_shuffled.(field_id).stim_46_90.(distance_id).p');
            OFC.(monkey_id).sham_late.(distance_id).slope_shuffled=horzcat(OFC.(monkey_id).sham_late.(distance_id).slope_shuffled, Model.mdl_shuffled.(field_id).stim_46_90.(sham_slope_id)');
    
            OFC.(monkey_id).sham_early.(distance_id).rho_shuffled=horzcat(OFC.(monkey_id).sham_early.(distance_id).rho_shuffled, Corr.Sham_shuffled.(field_id).stim_1_45.(distance_id).rho');
            OFC.(monkey_id).sham_early.(distance_id).p_shuffled=horzcat(OFC.(monkey_id).sham_early.(distance_id).p_shuffled, Corr.Sham_shuffled.(field_id).stim_1_45.(distance_id).p');
            OFC.(monkey_id).sham_early.(distance_id).slope_shuffled=horzcat(OFC.(monkey_id).sham_early.(distance_id).slope_shuffled, Model.mdl_shuffled.(field_id).stim_1_45.(sham_slope_id)');
        
        end
    
        [Stats.p.(monkey_id).OFC.stim.(distance_id).rho, Stats.h.(monkey_id).OFC.stim.(distance_id).rho] = signrank(OFC.(monkey_id).stim_late.(distance_id).rho, OFC.(monkey_id).stim_early.(distance_id).rho);
        [Stats.p.(monkey_id).OFC.stim.(distance_id).p, Stats.h.(monkey_id).OFC.stim.(distance_id).p] = signrank(OFC.(monkey_id).stim_late.(distance_id).p, OFC.(monkey_id).stim_early.(distance_id).p);
        [Stats.p.(monkey_id).OFC.stim.(distance_id).slope, Stats.h.(monkey_id).OFC.stim.(distance_id).slope] = signrank(OFC.(monkey_id).stim_late.(distance_id).slope, OFC.(monkey_id).stim_early.(distance_id).slope);
       
        [Stats.p.(monkey_id).OFC.sham.(distance_id).rho, Stats.h.(monkey_id).OFC.sham.(distance_id).rho] = signrank(OFC.(monkey_id).sham_late.(distance_id).rho, OFC.(monkey_id).sham_early.(distance_id).rho);
        [Stats.p.(monkey_id).OFC.sham.(distance_id).p, Stats.h.(monkey_id).OFC.sham.(distance_id).p] = signrank(OFC.(monkey_id).sham_late.(distance_id).p, OFC.(monkey_id).sham_early.(distance_id).p);
        [Stats.p.(monkey_id).OFC.sham.(distance_id).slope, Stats.h.(monkey_id).OFC.sham.(distance_id).slope] = signrank(OFC.(monkey_id).sham_late.(distance_id).slope, OFC.(monkey_id).sham_early.(distance_id).slope);
       
        Epoch_results.(monkey_id).OFC.stim.(distance_id).rho = median(OFC.(monkey_id).stim_late.(distance_id).rho-OFC.(monkey_id).stim_early.(distance_id).rho,'omitnan');
        Epoch_results.(monkey_id).OFC.stim.(distance_id).p = median(OFC.(monkey_id).stim_late.(distance_id).p-OFC.(monkey_id).stim_early.(distance_id).p,'omitnan');
        Epoch_results.(monkey_id).OFC.stim.(distance_id).slope = median(OFC.(monkey_id).stim_late.(distance_id).slope-OFC.(monkey_id).stim_early.(distance_id).slope,'omitnan');

        Epoch_results.(monkey_id).OFC.stim.(distance_id).rho_shuffled = median(OFC.(monkey_id).stim_late.(distance_id).rho_shuffled-OFC.(monkey_id).stim_early.(distance_id).rho_shuffled,2,'omitnan');
        Epoch_results.(monkey_id).OFC.stim.(distance_id).p_shuffled = median(OFC.(monkey_id).stim_late.(distance_id).p_shuffled-OFC.(monkey_id).stim_early.(distance_id).p_shuffled,2,'omitnan');
        Epoch_results.(monkey_id).OFC.stim.(distance_id).slope_shuffled = median(OFC.(monkey_id).stim_late.(distance_id).slope_shuffled-OFC.(monkey_id).stim_early.(distance_id).slope_shuffled,2,'omitnan');

        Epoch_results.(monkey_id).OFC.sham.(distance_id).rho = median(OFC.(monkey_id).sham_late.(distance_id).rho-OFC.(monkey_id).sham_early.(distance_id).rho,'omitnan');
        Epoch_results.(monkey_id).OFC.sham.(distance_id).p = median(OFC.(monkey_id).sham_late.(distance_id).p-OFC.(monkey_id).sham_early.(distance_id).p,'omitnan');
        Epoch_results.(monkey_id).OFC.sham.(distance_id).slope = median(OFC.(monkey_id).sham_late.(distance_id).slope-OFC.(monkey_id).sham_early.(distance_id).slope,'omitnan');

        Epoch_results.(monkey_id).OFC.sham.(distance_id).rho_shuffled = median(OFC.(monkey_id).sham_late.(distance_id).rho_shuffled-OFC.(monkey_id).sham_early.(distance_id).rho_shuffled,2,'omitnan');
        Epoch_results.(monkey_id).OFC.sham.(distance_id).p_shuffled = median(OFC.(monkey_id).sham_late.(distance_id).p_shuffled-OFC.(monkey_id).sham_early.(distance_id).p_shuffled,2,'omitnan');
        Epoch_results.(monkey_id).OFC.sham.(distance_id).slope_shuffled = median(OFC.(monkey_id).sham_late.(distance_id).slope_shuffled-OFC.(monkey_id).sham_early.(distance_id).slope_shuffled,2,'omitnan');

    % dmPFC
    
    % real stim and sham
        dmPFC.(monkey_id).stim_late.(distance_id).rho=[];
        dmPFC.(monkey_id).stim_late.(distance_id).p=[];
        dmPFC.(monkey_id).stim_late.(distance_id).slope=[];
        dmPFC.(monkey_id).stim_early.(distance_id).rho=[];
        dmPFC.(monkey_id).stim_early.(distance_id).p=[];
        dmPFC.(monkey_id).stim_early.(distance_id).slope=[];
    
        dmPFC.(monkey_id).sham_late.(distance_id).rho=[];
        dmPFC.(monkey_id).sham_late.(distance_id).p=[];
        dmPFC.(monkey_id).sham_late.(distance_id).slope=[];
        dmPFC.(monkey_id).sham_early.(distance_id).rho=[];
        dmPFC.(monkey_id).sham_early.(distance_id).p=[];
        dmPFC.(monkey_id).sham_early.(distance_id).slope=[];
    
        % shuffle 
        dmPFC.(monkey_id).stim_late.(distance_id).rho_shuffled=[];
        dmPFC.(monkey_id).stim_late.(distance_id).p_shuffled=[];
        dmPFC.(monkey_id).stim_late.(distance_id).slope_shuffled=[];
        dmPFC.(monkey_id).stim_early.(distance_id).rho_shuffled=[];
        dmPFC.(monkey_id).stim_early.(distance_id).p_shuffled=[];
        dmPFC.(monkey_id).stim_early.(distance_id).slope_shuffled=[];
    
        dmPFC.(monkey_id).sham_late.(distance_id).rho_shuffled=[];
        dmPFC.(monkey_id).sham_late.(distance_id).p_shuffled=[];
        dmPFC.(monkey_id).sham_late.(distance_id).slope_shuffled=[];
        dmPFC.(monkey_id).sham_early.(distance_id).rho_shuffled=[];
        dmPFC.(monkey_id).sham_early.(distance_id).p_shuffled=[];
        dmPFC.(monkey_id).sham_early.(distance_id).slope_shuffled=[];
    
        for ndmPFC=1:length(dmPFC_day.(monkey_id))
    
            field_id=char(strcat('data_',dmPFC_day.(monkey_id)(ndmPFC)));
    
            % real stim and sham
            dmPFC.(monkey_id).stim_late.(distance_id).rho=[dmPFC.(monkey_id).stim_late.(distance_id).rho Corr.Stim.(field_id).stim_46_90.(distance_id).rho];
            dmPFC.(monkey_id).stim_late.(distance_id).p=[dmPFC.(monkey_id).stim_late.(distance_id).p Corr.Stim.(field_id).stim_46_90.(distance_id).p];
            dmPFC.(monkey_id).stim_late.(distance_id).slope=[dmPFC.(monkey_id).stim_late.(distance_id).slope Model.mdl.(field_id).stim_46_90.(stim_slope_id)];
    
            dmPFC.(monkey_id).stim_early.(distance_id).rho=[dmPFC.(monkey_id).stim_early.(distance_id).rho Corr.Stim.(field_id).stim_1_45.(distance_id).rho];
            dmPFC.(monkey_id).stim_early.(distance_id).p=[dmPFC.(monkey_id).stim_early.(distance_id).p Corr.Stim.(field_id).stim_1_45.(distance_id).p];
            dmPFC.(monkey_id).stim_early.(distance_id).slope=[dmPFC.(monkey_id).stim_early.(distance_id).slope Model.mdl.(field_id).stim_1_45.(stim_slope_id)];
    
            dmPFC.(monkey_id).sham_late.(distance_id).rho=[dmPFC.(monkey_id).sham_late.(distance_id).rho Corr.Sham.(field_id).stim_46_90.(distance_id).rho];
            dmPFC.(monkey_id).sham_late.(distance_id).p=[dmPFC.(monkey_id).sham_late.(distance_id).p Corr.Sham.(field_id).stim_46_90.(distance_id).p];
            dmPFC.(monkey_id).sham_late.(distance_id).slope=[dmPFC.(monkey_id).sham_late.(distance_id).slope Model.mdl.(field_id).stim_46_90.(sham_slope_id)];
    
            dmPFC.(monkey_id).sham_early.(distance_id).rho=[dmPFC.(monkey_id).sham_early.(distance_id).rho Corr.Sham.(field_id).stim_1_45.(distance_id).rho];
            dmPFC.(monkey_id).sham_early.(distance_id).p=[dmPFC.(monkey_id).sham_early.(distance_id).p Corr.Sham.(field_id).stim_1_45.(distance_id).p];
            dmPFC.(monkey_id).sham_early.(distance_id).slope=[dmPFC.(monkey_id).sham_early.(distance_id).slope Model.mdl.(field_id).stim_1_45.(sham_slope_id)];
    
            % shuffled
            dmPFC.(monkey_id).stim_late.(distance_id).rho_shuffled=horzcat(dmPFC.(monkey_id).stim_late.(distance_id).rho_shuffled, Corr.Stim_shuffled.(field_id).stim_46_90.(distance_id).rho');
            dmPFC.(monkey_id).stim_late.(distance_id).p_shuffled=horzcat(dmPFC.(monkey_id).stim_late.(distance_id).p_shuffled, Corr.Stim_shuffled.(field_id).stim_46_90.(distance_id).p');
            dmPFC.(monkey_id).stim_late.(distance_id).slope_shuffled=horzcat(dmPFC.(monkey_id).stim_late.(distance_id).slope_shuffled, Model.mdl_shuffled.(field_id).stim_46_90.(stim_slope_id)');
    
            dmPFC.(monkey_id).stim_early.(distance_id).rho_shuffled=horzcat(dmPFC.(monkey_id).stim_early.(distance_id).rho_shuffled, Corr.Stim_shuffled.(field_id).stim_1_45.(distance_id).rho');
            dmPFC.(monkey_id).stim_early.(distance_id).p_shuffled=horzcat(dmPFC.(monkey_id).stim_early.(distance_id).p_shuffled, Corr.Stim_shuffled.(field_id).stim_1_45.(distance_id).p');
            dmPFC.(monkey_id).stim_early.(distance_id).slope_shuffled=horzcat(dmPFC.(monkey_id).stim_early.(distance_id).slope_shuffled, Model.mdl_shuffled.(field_id).stim_1_45.(stim_slope_id)');
        
            dmPFC.(monkey_id).sham_late.(distance_id).rho_shuffled=horzcat(dmPFC.(monkey_id).sham_late.(distance_id).rho_shuffled, Corr.Sham_shuffled.(field_id).stim_46_90.(distance_id).rho');
            dmPFC.(monkey_id).sham_late.(distance_id).p_shuffled=horzcat(dmPFC.(monkey_id).sham_late.(distance_id).p_shuffled, Corr.Sham_shuffled.(field_id).stim_46_90.(distance_id).p');
            dmPFC.(monkey_id).sham_late.(distance_id).slope_shuffled=horzcat(dmPFC.(monkey_id).sham_late.(distance_id).slope_shuffled, Model.mdl_shuffled.(field_id).stim_46_90.(sham_slope_id)');
    
            dmPFC.(monkey_id).sham_early.(distance_id).rho_shuffled=horzcat(dmPFC.(monkey_id).sham_early.(distance_id).rho_shuffled, Corr.Sham_shuffled.(field_id).stim_1_45.(distance_id).rho');
            dmPFC.(monkey_id).sham_early.(distance_id).p_shuffled=horzcat(dmPFC.(monkey_id).sham_early.(distance_id).p_shuffled, Corr.Sham_shuffled.(field_id).stim_1_45.(distance_id).p');
            dmPFC.(monkey_id).sham_early.(distance_id).slope_shuffled=horzcat(dmPFC.(monkey_id).sham_early.(distance_id).slope_shuffled, Model.mdl_shuffled.(field_id).stim_1_45.(sham_slope_id)');
        
        end
    
        [Stats.p.(monkey_id).dmPFC.stim.(distance_id).rho, Stats.h.(monkey_id).dmPFC.stim.(distance_id).rho] = signrank(dmPFC.(monkey_id).stim_late.(distance_id).rho, dmPFC.(monkey_id).stim_early.(distance_id).rho);
        [Stats.p.(monkey_id).dmPFC.stim.(distance_id).p, Stats.h.(monkey_id).dmPFC.stim.(distance_id).p] = signrank(dmPFC.(monkey_id).stim_late.(distance_id).p, dmPFC.(monkey_id).stim_early.(distance_id).p);
        [Stats.p.(monkey_id).dmPFC.stim.(distance_id).slope, Stats.h.(monkey_id).dmPFC.stim.(distance_id).slope] = signrank(dmPFC.(monkey_id).stim_late.(distance_id).slope, dmPFC.(monkey_id).stim_early.(distance_id).slope);
       
        [Stats.p.(monkey_id).dmPFC.sham.(distance_id).rho, Stats.h.(monkey_id).dmPFC.sham.(distance_id).rho] = signrank(dmPFC.(monkey_id).sham_late.(distance_id).rho, dmPFC.(monkey_id).sham_early.(distance_id).rho);
        [Stats.p.(monkey_id).dmPFC.sham.(distance_id).p, Stats.h.(monkey_id).dmPFC.sham.(distance_id).p] = signrank(dmPFC.(monkey_id).sham_late.(distance_id).p, dmPFC.(monkey_id).sham_early.(distance_id).p);
        [Stats.p.(monkey_id).dmPFC.sham.(distance_id).slope, Stats.h.(monkey_id).dmPFC.sham.(distance_id).slope] = signrank(dmPFC.(monkey_id).sham_late.(distance_id).slope, dmPFC.(monkey_id).sham_early.(distance_id).slope);
       
        Epoch_results.(monkey_id).dmPFC.stim.(distance_id).rho = median(dmPFC.(monkey_id).stim_late.(distance_id).rho-dmPFC.(monkey_id).stim_early.(distance_id).rho,'omitnan');
        Epoch_results.(monkey_id).dmPFC.stim.(distance_id).p = median(dmPFC.(monkey_id).stim_late.(distance_id).p-dmPFC.(monkey_id).stim_early.(distance_id).p,'omitnan');
        Epoch_results.(monkey_id).dmPFC.stim.(distance_id).slope = median(dmPFC.(monkey_id).stim_late.(distance_id).slope-dmPFC.(monkey_id).stim_early.(distance_id).slope,'omitnan');

        Epoch_results.(monkey_id).dmPFC.stim.(distance_id).rho_shuffled = median(dmPFC.(monkey_id).stim_late.(distance_id).rho_shuffled-dmPFC.(monkey_id).stim_early.(distance_id).rho_shuffled,2,'omitnan');
        Epoch_results.(monkey_id).dmPFC.stim.(distance_id).p_shuffled = median(dmPFC.(monkey_id).stim_late.(distance_id).p_shuffled-dmPFC.(monkey_id).stim_early.(distance_id).p_shuffled,2,'omitnan');
        Epoch_results.(monkey_id).dmPFC.stim.(distance_id).slope_shuffled = median(dmPFC.(monkey_id).stim_late.(distance_id).slope_shuffled-dmPFC.(monkey_id).stim_early.(distance_id).slope_shuffled,2,'omitnan');

        Epoch_results.(monkey_id).dmPFC.sham.(distance_id).rho = median(dmPFC.(monkey_id).sham_late.(distance_id).rho-dmPFC.(monkey_id).sham_early.(distance_id).rho,'omitnan');
        Epoch_results.(monkey_id).dmPFC.sham.(distance_id).p = median(dmPFC.(monkey_id).sham_late.(distance_id).p-dmPFC.(monkey_id).sham_early.(distance_id).p,'omitnan');
        Epoch_results.(monkey_id).dmPFC.sham.(distance_id).slope = median(dmPFC.(monkey_id).sham_late.(distance_id).slope-dmPFC.(monkey_id).sham_early.(distance_id).slope,'omitnan');

        Epoch_results.(monkey_id).dmPFC.sham.(distance_id).rho_shuffled = median(dmPFC.(monkey_id).sham_late.(distance_id).rho_shuffled-dmPFC.(monkey_id).sham_early.(distance_id).rho_shuffled,2,'omitnan');
        Epoch_results.(monkey_id).dmPFC.sham.(distance_id).p_shuffled = median(dmPFC.(monkey_id).sham_late.(distance_id).p_shuffled-dmPFC.(monkey_id).sham_early.(distance_id).p_shuffled,2,'omitnan');
        Epoch_results.(monkey_id).dmPFC.sham.(distance_id).slope_shuffled = median(dmPFC.(monkey_id).sham_late.(distance_id).slope_shuffled-dmPFC.(monkey_id).sham_early.(distance_id).slope_shuffled,2,'omitnan');
       
    % ACCg

    % real stim and sham
        ACCg.(monkey_id).stim_late.(distance_id).rho=[];
        ACCg.(monkey_id).stim_late.(distance_id).p=[];
        ACCg.(monkey_id).stim_late.(distance_id).slope=[];
        ACCg.(monkey_id).stim_early.(distance_id).rho=[];
        ACCg.(monkey_id).stim_early.(distance_id).p=[];
        ACCg.(monkey_id).stim_early.(distance_id).slope=[];
    
        ACCg.(monkey_id).sham_late.(distance_id).rho=[];
        ACCg.(monkey_id).sham_late.(distance_id).p=[];
        ACCg.(monkey_id).sham_late.(distance_id).slope=[];
        ACCg.(monkey_id).sham_early.(distance_id).rho=[];
        ACCg.(monkey_id).sham_early.(distance_id).p=[];
        ACCg.(monkey_id).sham_early.(distance_id).slope=[];
    
        % shuffle 
        ACCg.(monkey_id).stim_late.(distance_id).rho_shuffled=[];
        ACCg.(monkey_id).stim_late.(distance_id).p_shuffled=[];
        ACCg.(monkey_id).stim_late.(distance_id).slope_shuffled=[];
        ACCg.(monkey_id).stim_early.(distance_id).rho_shuffled=[];
        ACCg.(monkey_id).stim_early.(distance_id).p_shuffled=[];
        ACCg.(monkey_id).stim_early.(distance_id).slope_shuffled=[];
    
        ACCg.(monkey_id).sham_late.(distance_id).rho_shuffled=[];
        ACCg.(monkey_id).sham_late.(distance_id).p_shuffled=[];
        ACCg.(monkey_id).sham_late.(distance_id).slope_shuffled=[];
        ACCg.(monkey_id).sham_early.(distance_id).rho_shuffled=[];
        ACCg.(monkey_id).sham_early.(distance_id).p_shuffled=[];
        ACCg.(monkey_id).sham_early.(distance_id).slope_shuffled=[];
    
        for nACCg=1:length(ACCg_day.(monkey_id))
    
            field_id=char(strcat('data_',ACCg_day.(monkey_id)(nACCg)));
    
            % real stim and sham
            ACCg.(monkey_id).stim_late.(distance_id).rho=[ACCg.(monkey_id).stim_late.(distance_id).rho Corr.Stim.(field_id).stim_46_90.(distance_id).rho];
            ACCg.(monkey_id).stim_late.(distance_id).p=[ACCg.(monkey_id).stim_late.(distance_id).p Corr.Stim.(field_id).stim_46_90.(distance_id).p];
            ACCg.(monkey_id).stim_late.(distance_id).slope=[ACCg.(monkey_id).stim_late.(distance_id).slope Model.mdl.(field_id).stim_46_90.(stim_slope_id)];
    
            ACCg.(monkey_id).stim_early.(distance_id).rho=[ACCg.(monkey_id).stim_early.(distance_id).rho Corr.Stim.(field_id).stim_1_45.(distance_id).rho];
            ACCg.(monkey_id).stim_early.(distance_id).p=[ACCg.(monkey_id).stim_early.(distance_id).p Corr.Stim.(field_id).stim_1_45.(distance_id).p];
            ACCg.(monkey_id).stim_early.(distance_id).slope=[ACCg.(monkey_id).stim_early.(distance_id).slope Model.mdl.(field_id).stim_1_45.(stim_slope_id)];
    
            ACCg.(monkey_id).sham_late.(distance_id).rho=[ACCg.(monkey_id).sham_late.(distance_id).rho Corr.Sham.(field_id).stim_46_90.(distance_id).rho];
            ACCg.(monkey_id).sham_late.(distance_id).p=[ACCg.(monkey_id).sham_late.(distance_id).p Corr.Sham.(field_id).stim_46_90.(distance_id).p];
            ACCg.(monkey_id).sham_late.(distance_id).slope=[ACCg.(monkey_id).sham_late.(distance_id).slope Model.mdl.(field_id).stim_46_90.(sham_slope_id)];
    
            ACCg.(monkey_id).sham_early.(distance_id).rho=[ACCg.(monkey_id).sham_early.(distance_id).rho Corr.Sham.(field_id).stim_1_45.(distance_id).rho];
            ACCg.(monkey_id).sham_early.(distance_id).p=[ACCg.(monkey_id).sham_early.(distance_id).p Corr.Sham.(field_id).stim_1_45.(distance_id).p];
            ACCg.(monkey_id).sham_early.(distance_id).slope=[ACCg.(monkey_id).sham_early.(distance_id).slope Model.mdl.(field_id).stim_1_45.(sham_slope_id)];
    
            % shuffled
            ACCg.(monkey_id).stim_late.(distance_id).rho_shuffled=horzcat(ACCg.(monkey_id).stim_late.(distance_id).rho_shuffled, Corr.Stim_shuffled.(field_id).stim_46_90.(distance_id).rho');
            ACCg.(monkey_id).stim_late.(distance_id).p_shuffled=horzcat(ACCg.(monkey_id).stim_late.(distance_id).p_shuffled, Corr.Stim_shuffled.(field_id).stim_46_90.(distance_id).p');
            ACCg.(monkey_id).stim_late.(distance_id).slope_shuffled=horzcat(ACCg.(monkey_id).stim_late.(distance_id).slope_shuffled, Model.mdl_shuffled.(field_id).stim_46_90.(stim_slope_id)');
    
            ACCg.(monkey_id).stim_early.(distance_id).rho_shuffled=horzcat(ACCg.(monkey_id).stim_early.(distance_id).rho_shuffled, Corr.Stim_shuffled.(field_id).stim_1_45.(distance_id).rho');
            ACCg.(monkey_id).stim_early.(distance_id).p_shuffled=horzcat(ACCg.(monkey_id).stim_early.(distance_id).p_shuffled, Corr.Stim_shuffled.(field_id).stim_1_45.(distance_id).p');
            ACCg.(monkey_id).stim_early.(distance_id).slope_shuffled=horzcat(ACCg.(monkey_id).stim_early.(distance_id).slope_shuffled, Model.mdl_shuffled.(field_id).stim_1_45.(stim_slope_id)');
        
            ACCg.(monkey_id).sham_late.(distance_id).rho_shuffled=horzcat(ACCg.(monkey_id).sham_late.(distance_id).rho_shuffled, Corr.Sham_shuffled.(field_id).stim_46_90.(distance_id).rho');
            ACCg.(monkey_id).sham_late.(distance_id).p_shuffled=horzcat(ACCg.(monkey_id).sham_late.(distance_id).p_shuffled, Corr.Sham_shuffled.(field_id).stim_46_90.(distance_id).p');
            ACCg.(monkey_id).sham_late.(distance_id).slope_shuffled=horzcat(ACCg.(monkey_id).sham_late.(distance_id).slope_shuffled, Model.mdl_shuffled.(field_id).stim_46_90.(sham_slope_id)');
    
            ACCg.(monkey_id).sham_early.(distance_id).rho_shuffled=horzcat(ACCg.(monkey_id).sham_early.(distance_id).rho_shuffled, Corr.Sham_shuffled.(field_id).stim_1_45.(distance_id).rho');
            ACCg.(monkey_id).sham_early.(distance_id).p_shuffled=horzcat(ACCg.(monkey_id).sham_early.(distance_id).p_shuffled, Corr.Sham_shuffled.(field_id).stim_1_45.(distance_id).p');
            ACCg.(monkey_id).sham_early.(distance_id).slope_shuffled=horzcat(ACCg.(monkey_id).sham_early.(distance_id).slope_shuffled, Model.mdl_shuffled.(field_id).stim_1_45.(sham_slope_id)');
        
        end
    
        [Stats.p.(monkey_id).ACCg.stim.(distance_id).rho, Stats.h.(monkey_id).ACCg.stim.(distance_id).rho] = signrank(ACCg.(monkey_id).stim_late.(distance_id).rho, ACCg.(monkey_id).stim_early.(distance_id).rho);
        [Stats.p.(monkey_id).ACCg.stim.(distance_id).p, Stats.h.(monkey_id).ACCg.stim.(distance_id).p] = signrank(ACCg.(monkey_id).stim_late.(distance_id).p, ACCg.(monkey_id).stim_early.(distance_id).p);
        [Stats.p.(monkey_id).ACCg.stim.(distance_id).slope, Stats.h.(monkey_id).ACCg.stim.(distance_id).slope] = signrank(ACCg.(monkey_id).stim_late.(distance_id).slope, ACCg.(monkey_id).stim_early.(distance_id).slope);
       
        [Stats.p.(monkey_id).ACCg.sham.(distance_id).rho, Stats.h.(monkey_id).ACCg.sham.(distance_id).rho] = signrank(ACCg.(monkey_id).sham_late.(distance_id).rho, ACCg.(monkey_id).sham_early.(distance_id).rho);
        [Stats.p.(monkey_id).ACCg.sham.(distance_id).p, Stats.h.(monkey_id).ACCg.sham.(distance_id).p] = signrank(ACCg.(monkey_id).sham_late.(distance_id).p, ACCg.(monkey_id).sham_early.(distance_id).p);
        [Stats.p.(monkey_id).ACCg.sham.(distance_id).slope, Stats.h.(monkey_id).ACCg.sham.(distance_id).slope] = signrank(ACCg.(monkey_id).sham_late.(distance_id).slope, ACCg.(monkey_id).sham_early.(distance_id).slope);
       
        Epoch_results.(monkey_id).ACCg.stim.(distance_id).rho = median(ACCg.(monkey_id).stim_late.(distance_id).rho-ACCg.(monkey_id).stim_early.(distance_id).rho,'omitnan');
        Epoch_results.(monkey_id).ACCg.stim.(distance_id).p = median(ACCg.(monkey_id).stim_late.(distance_id).p-ACCg.(monkey_id).stim_early.(distance_id).p,'omitnan');
        Epoch_results.(monkey_id).ACCg.stim.(distance_id).slope = median(ACCg.(monkey_id).stim_late.(distance_id).slope-ACCg.(monkey_id).stim_early.(distance_id).slope,'omitnan');

        Epoch_results.(monkey_id).ACCg.stim.(distance_id).rho_shuffled = median(ACCg.(monkey_id).stim_late.(distance_id).rho_shuffled-ACCg.(monkey_id).stim_early.(distance_id).rho_shuffled,2,'omitnan');
        Epoch_results.(monkey_id).ACCg.stim.(distance_id).p_shuffled = median(ACCg.(monkey_id).stim_late.(distance_id).p_shuffled-ACCg.(monkey_id).stim_early.(distance_id).p_shuffled,2,'omitnan');
        Epoch_results.(monkey_id).ACCg.stim.(distance_id).slope_shuffled = median(ACCg.(monkey_id).stim_late.(distance_id).slope_shuffled-ACCg.(monkey_id).stim_early.(distance_id).slope_shuffled,2,'omitnan');

        Epoch_results.(monkey_id).ACCg.sham.(distance_id).rho = median(ACCg.(monkey_id).sham_late.(distance_id).rho-ACCg.(monkey_id).sham_early.(distance_id).rho,'omitnan');
        Epoch_results.(monkey_id).ACCg.sham.(distance_id).p = median(ACCg.(monkey_id).sham_late.(distance_id).p-ACCg.(monkey_id).sham_early.(distance_id).p,'omitnan');
        Epoch_results.(monkey_id).ACCg.sham.(distance_id).slope = median(ACCg.(monkey_id).sham_late.(distance_id).slope-ACCg.(monkey_id).sham_early.(distance_id).slope,'omitnan');

        Epoch_results.(monkey_id).ACCg.sham.(distance_id).rho_shuffled = median(ACCg.(monkey_id).sham_late.(distance_id).rho_shuffled-ACCg.(monkey_id).sham_early.(distance_id).rho_shuffled,2,'omitnan');
        Epoch_results.(monkey_id).ACCg.sham.(distance_id).p_shuffled = median(ACCg.(monkey_id).sham_late.(distance_id).p_shuffled-ACCg.(monkey_id).sham_early.(distance_id).p_shuffled,2,'omitnan');
        Epoch_results.(monkey_id).ACCg.sham.(distance_id).slope_shuffled = median(ACCg.(monkey_id).sham_late.(distance_id).slope_shuffled-ACCg.(monkey_id).sham_early.(distance_id).slope_shuffled,2,'omitnan');

    end

end

Epoch.OFC=OFC;
Epoch.dmPFC=dmPFC;
Epoch.ACCg=ACCg;

save('Correlation_Epoch_Data_Combined.mat','Epoch','-v7.3');
save('Correlation_Epoch_Stats_Combined.mat','Stats','-v7.3');
save('Correlation_Epoch_Results_Combined.mat','Epoch_results','-v7.3');
 
%% Plotting a dot for each day (rho) and plot true median against shuffled medians

distance_variables={'distance','contra','ipsi'};
rho_range=-0.8:0.05:0.8;

for ngaze=1:length(distance_variables)

    gaze_variables=char(distance_variables(ngaze));

    monkey_names={'All', 'Lynch', 'Tarantino'};
    
    for nmonkey=1:3
        monkey_id=char(monkey_names(nmonkey));
    
        % Correlation for early and Late epoches
            
        figure('Renderer', 'painters', 'Position', [100 1200 1200 700])
    
        subplot(2,3,1)
    
        X=categorical({'Early','Late'});
        X=reordercats(X,{'Early','Late'});
        Y=[median(Epoch.OFC.(monkey_id).stim_early.(gaze_variables).rho,'omitnan'),median(Epoch.OFC.(monkey_id).stim_late.(gaze_variables).rho,'omitnan')];
        bar(X,Y); hold on
        
        colorInd=jet(length(OFC_day.(monkey_id)));
        line_hs = cell( length(OFC_day.(monkey_id)), 1 );
        line_labels = cell( size(line_hs) );
    
        for m=1:length(OFC_day.(monkey_id))
            
            scatter(X(1),Epoch.OFC.(monkey_id).stim_early.(gaze_variables).rho(m),30,colorInd(m,:),'filled'); hold on           
            scatter(X(2),Epoch.OFC.(monkey_id).stim_late.(gaze_variables).rho(m),30,colorInd(m,:),'filled'); hold on
            line_hs{m} = line([X(1) X(2)],[Epoch.OFC.(monkey_id).stim_early.(gaze_variables).rho(m) Epoch.OFC.(monkey_id).stim_late.(gaze_variables).rho(m)], 'Color',colorInd(m,:)); hold on
            line_labels{m} = OFC_day.(monkey_id){m};
        
        end
        legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
        title('OFC')
        ax1=gca; 
        axis(ax1,'square')
        %set(gca, 'PlotBoxAspectRatio', [1,2,1])
        ylim([-1 1]);
        clear X Y m colorInd line_hs line_labels
    
        subplot(2,3,4)
        histogram(median(Epoch.OFC.(monkey_id).stim_late.(gaze_variables).rho_shuffled-Epoch.OFC.(monkey_id).stim_early.(gaze_variables).rho_shuffled,2,'omitnan'),rho_range); hold on
        line([median(Epoch.OFC.(monkey_id).stim_late.(gaze_variables).rho-Epoch.OFC.(monkey_id).stim_early.(gaze_variables).rho,'omitnan') median(Epoch.OFC.(monkey_id).stim_late.(gaze_variables).rho-Epoch.OFC.(monkey_id).stim_early.(gaze_variables).rho,'omitnan')], [0 100],'Color','r');
        xlim([-0.8 0.8]);
        ylim([0 240]);
        yticks([0 40 80 120 160 200 240]);
        title('OFC shuffled')
        ax4=gca; 
        axis(ax4,'square')

        subplot(2,3,2)
    
        X=categorical({'Early','Late'});
        X=reordercats(X,{'Early','Late'});
        Y=[median(Epoch.dmPFC.(monkey_id).stim_early.(gaze_variables).rho,'omitnan'),median(Epoch.dmPFC.(monkey_id).stim_late.(gaze_variables).rho,'omitnan')];
        bar(X,Y); hold on
        
        colorInd=jet(length(dmPFC_day.(monkey_id)));
        line_hs = cell( length(dmPFC_day.(monkey_id)), 1 );
        line_labels = cell( size(line_hs) );
    
        for m=1:length(dmPFC_day.(monkey_id))
            
            scatter(X(1),Epoch.dmPFC.(monkey_id).stim_early.(gaze_variables).rho(m),30,colorInd(m,:),'filled'); hold on           
            scatter(X(2),Epoch.dmPFC.(monkey_id).stim_late.(gaze_variables).rho(m),30,colorInd(m,:),'filled'); hold on
            line_hs{m} = line([X(1) X(2)],[Epoch.dmPFC.(monkey_id).stim_early.(gaze_variables).rho(m) Epoch.dmPFC.(monkey_id).stim_late.(gaze_variables).rho(m)], 'Color',colorInd(m,:)); hold on
            line_labels{m} = dmPFC_day.(monkey_id){m};
        
        end
        legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
        title('dmPFC')
        ax2=gca; 
        axis(ax2,'square')
        %set(gca, 'PlotBoxAspectRatio', [1,2,1])
        ylim([-1 1]);
        clear X Y m colorInd line_hs line_labels
    
        subplot(2,3,5)
        histogram(median(Epoch.dmPFC.(monkey_id).stim_late.(gaze_variables).rho_shuffled-Epoch.dmPFC.(monkey_id).stim_early.(gaze_variables).rho_shuffled,2,'omitnan'),rho_range); hold on
        line([median(Epoch.dmPFC.(monkey_id).stim_late.(gaze_variables).rho-Epoch.dmPFC.(monkey_id).stim_early.(gaze_variables).rho,'omitnan') median(Epoch.dmPFC.(monkey_id).stim_late.(gaze_variables).rho-Epoch.dmPFC.(monkey_id).stim_early.(gaze_variables).rho,'omitnan')], [0 100],'Color','r');
        xlim([-0.8 0.8]);
        ylim([0 240]);
        yticks([0 40 80 120 160 200 240]);
        title('dmPFC shuffled')
        ax5=gca; 
        axis(ax5,'square')

        subplot(2,3,3)
    
        X=categorical({'Early','Late'});
        X=reordercats(X,{'Early','Late'});
        Y=[median(Epoch.ACCg.(monkey_id).stim_early.(gaze_variables).rho,'omitnan'),median(Epoch.ACCg.(monkey_id).stim_late.(gaze_variables).rho,'omitnan')];
        bar(X,Y); hold on
        
        colorInd=jet(length(ACCg_day.(monkey_id)));
        line_hs = cell( length(ACCg_day.(monkey_id)), 1 );
        line_labels = cell( size(line_hs) );
    
        for m=1:length(ACCg_day.(monkey_id))
            
            scatter(X(1),Epoch.ACCg.(monkey_id).stim_early.(gaze_variables).rho(m),30,colorInd(m,:),'filled'); hold on           
            scatter(X(2),Epoch.ACCg.(monkey_id).stim_late.(gaze_variables).rho(m),30,colorInd(m,:),'filled'); hold on
            line_hs{m} = line([X(1) X(2)],[Epoch.ACCg.(monkey_id).stim_early.(gaze_variables).rho(m) Epoch.ACCg.(monkey_id).stim_late.(gaze_variables).rho(m)], 'Color',colorInd(m,:)); hold on
            line_labels{m} = ACCg_day.(monkey_id){m};
        
        end
        legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
        title('ACCg')
        ax3=gca; 
        axis(ax3,'square')
        %set(gca, 'PlotBoxAspectRatio', [1,2,1])
        ylim([-1 1]);
        clear X Y m colorInd line_hs line_labels
    
        subplot(2,3,6)
        histogram(median(Epoch.ACCg.(monkey_id).stim_late.(gaze_variables).rho_shuffled-Epoch.ACCg.(monkey_id).stim_early.(gaze_variables).rho_shuffled,2,'omitnan'),rho_range); hold on
        line([median(Epoch.ACCg.(monkey_id).stim_late.(gaze_variables).rho-Epoch.ACCg.(monkey_id).stim_early.(gaze_variables).rho,'omitnan') median(Epoch.ACCg.(monkey_id).stim_late.(gaze_variables).rho-Epoch.ACCg.(monkey_id).stim_early.(gaze_variables).rho,'omitnan')], [0 100],'Color','r');
        xlim([-0.8 0.8]);
        ylim([0 240]);
        yticks([0 40 80 120 160 200 240]);
        title('ACCg shuffled')
        ax6=gca; 
        axis(ax6,'square')
       
        linkaxes([ax1,ax2,ax3],'y');
        linkaxes([ax4,ax5,ax6],'y');
    
        sgtitle(sprintf(['rho_' gaze_variables '_' monkey_id]),'Interpreter', 'none')   
        set(gcf, 'Renderer', 'painters');
        saveas(gcf,sprintf(['rho_' gaze_variables,'_',monkey_id]))
        saveas(gcf,sprintf(['rho_' gaze_variables,'_',monkey_id,'.jpg']))
        saveas(gcf,sprintf(['rho_' gaze_variables,'_',monkey_id,'.epsc']))

    clf

    end

end

%% Plotting a dot for each day (slope) and plot true median against shuffled medians

% distance
slope_ylim=[-0.025 0.025]; 
slope_yticks=-0.025:0.005:0.025;
slope_range=-0.009:0.0005:0.009;
slope_xlim=[-0.009 0.009];
distance_variables={'distance'};

% contra and ipsi
% slope_ylim=[-0.03 0.03]; 
% slope_yticks=-0.03:0.005:0.03;
% slope_range=-0.015:0.0005:0.015;
% slope_xlim=[-0.015 0.015];
% distance_variables={'contra','ipsi'};


for ngaze=1:length(distance_variables)

    gaze_variables=char(distance_variables(ngaze));

    monkey_names={'All', 'Lynch', 'Tarantino'};
    
    for nmonkey=1:3
        monkey_id=char(monkey_names(nmonkey));
    
        % Correlation for early and Late epoches
            
        figure('Renderer', 'painters', 'Position', [100 1200 1200 700])
    
        subplot(2,3,1)
    
        X=categorical({'Early','Late'});
        X=reordercats(X,{'Early','Late'});
        Y=[median(Epoch.OFC.(monkey_id).stim_early.(gaze_variables).slope,'omitnan'),median(Epoch.OFC.(monkey_id).stim_late.(gaze_variables).slope,'omitnan')];
        bar(X,Y); hold on
        
        colorInd=jet(length(OFC_day.(monkey_id)));
        line_hs = cell( length(OFC_day.(monkey_id)), 1 );
        line_labels = cell( size(line_hs) );
    
        for m=1:length(OFC_day.(monkey_id))
            
            scatter(X(1),Epoch.OFC.(monkey_id).stim_early.(gaze_variables).slope(m),30,colorInd(m,:),'filled'); hold on           
            scatter(X(2),Epoch.OFC.(monkey_id).stim_late.(gaze_variables).slope(m),30,colorInd(m,:),'filled'); hold on
            line_hs{m} = line([X(1) X(2)],[Epoch.OFC.(monkey_id).stim_early.(gaze_variables).slope(m) Epoch.OFC.(monkey_id).stim_late.(gaze_variables).slope(m)], 'Color',colorInd(m,:)); hold on
            line_labels{m} = OFC_day.(monkey_id){m};
        
        end
        legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
        title('OFC')
        ax1=gca; 
        axis(ax1,'square')
        ylim(slope_ylim);
        yticks(slope_yticks);
        clear X Y m colorInd line_hs line_labels
    
        subplot(2,3,4)
        histogram(median(Epoch.OFC.(monkey_id).stim_late.(gaze_variables).slope_shuffled-Epoch.OFC.(monkey_id).stim_early.(gaze_variables).slope_shuffled,2,'omitnan'),slope_range); hold on
        line([median(Epoch.OFC.(monkey_id).stim_late.(gaze_variables).slope-Epoch.OFC.(monkey_id).stim_early.(gaze_variables).slope,'omitnan') median(Epoch.OFC.(monkey_id).stim_late.(gaze_variables).slope-Epoch.OFC.(monkey_id).stim_early.(gaze_variables).slope,'omitnan')], [0 100],'Color','r');
        xlim(slope_xlim);
        ylim([0 120]);
        yticks([0 20 40 60 80 100 120]);
        title('OFC shuffled')
        ax4=gca; 
        axis(ax4,'square')

        subplot(2,3,2)
    
        X=categorical({'Early','Late'});
        X=reordercats(X,{'Early','Late'});
        Y=[median(Epoch.dmPFC.(monkey_id).stim_early.(gaze_variables).slope,'omitnan'),median(Epoch.dmPFC.(monkey_id).stim_late.(gaze_variables).slope,'omitnan')];
        bar(X,Y); hold on
        
        colorInd=jet(length(dmPFC_day.(monkey_id)));
        line_hs = cell( length(dmPFC_day.(monkey_id)), 1 );
        line_labels = cell( size(line_hs) );
    
        for m=1:length(dmPFC_day.(monkey_id))
            
            scatter(X(1),Epoch.dmPFC.(monkey_id).stim_early.(gaze_variables).slope(m),30,colorInd(m,:),'filled'); hold on           
            scatter(X(2),Epoch.dmPFC.(monkey_id).stim_late.(gaze_variables).slope(m),30,colorInd(m,:),'filled'); hold on
            line_hs{m} = line([X(1) X(2)],[Epoch.dmPFC.(monkey_id).stim_early.(gaze_variables).slope(m) Epoch.dmPFC.(monkey_id).stim_late.(gaze_variables).slope(m)], 'Color',colorInd(m,:)); hold on
            line_labels{m} = dmPFC_day.(monkey_id){m};
        
        end
        legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
        title('dmPFC')
        ax2=gca; 
        axis(ax2,'square')
        ylim(slope_ylim);
        yticks(slope_yticks);
        clear X Y m colorInd line_hs line_labels
    
        subplot(2,3,5)
        histogram(median(Epoch.dmPFC.(monkey_id).stim_late.(gaze_variables).slope_shuffled-Epoch.dmPFC.(monkey_id).stim_early.(gaze_variables).slope_shuffled,2,'omitnan'),slope_range); hold on
        line([median(Epoch.dmPFC.(monkey_id).stim_late.(gaze_variables).slope-Epoch.dmPFC.(monkey_id).stim_early.(gaze_variables).slope,'omitnan') median(Epoch.dmPFC.(monkey_id).stim_late.(gaze_variables).slope-Epoch.dmPFC.(monkey_id).stim_early.(gaze_variables).slope,'omitnan')], [0 100],'Color','r');
        xlim(slope_xlim)
        ylim([0 120]);
        yticks([0 20 40 60 80 100 120]);
        title('dmPFC shuffled')
        ax5=gca; 
        axis(ax5,'square')

        subplot(2,3,3)
    
        X=categorical({'Early','Late'});
        X=reordercats(X,{'Early','Late'});
        Y=[median(Epoch.ACCg.(monkey_id).stim_early.(gaze_variables).slope,'omitnan'),median(Epoch.ACCg.(monkey_id).stim_late.(gaze_variables).slope,'omitnan')];
        bar(X,Y); hold on
        
        colorInd=jet(length(ACCg_day.(monkey_id)));
        line_hs = cell( length(ACCg_day.(monkey_id)), 1 );
        line_labels = cell( size(line_hs) );
    
        for m=1:length(ACCg_day.(monkey_id))
            
            scatter(X(1),Epoch.ACCg.(monkey_id).stim_early.(gaze_variables).slope(m),30,colorInd(m,:),'filled'); hold on           
            scatter(X(2),Epoch.ACCg.(monkey_id).stim_late.(gaze_variables).slope(m),30,colorInd(m,:),'filled'); hold on
            line_hs{m} = line([X(1) X(2)],[Epoch.ACCg.(monkey_id).stim_early.(gaze_variables).slope(m) Epoch.ACCg.(monkey_id).stim_late.(gaze_variables).slope(m)], 'Color',colorInd(m,:)); hold on
            line_labels{m} = ACCg_day.(monkey_id){m};
        
        end
        legend( vertcat(line_hs{:}), line_labels, 'Location', 'westoutside', 'FontSize',7);
    
        title('ACCg')
        ax3=gca; 
        axis(ax3,'square')
        ylim(slope_ylim);
        yticks(slope_yticks);
        clear X Y m colorInd line_hs line_labels
    
        subplot(2,3,6)
        histogram(median(Epoch.ACCg.(monkey_id).stim_late.(gaze_variables).slope_shuffled-Epoch.ACCg.(monkey_id).stim_early.(gaze_variables).slope_shuffled,2,'omitnan'),slope_range); hold on
        line([median(Epoch.ACCg.(monkey_id).stim_late.(gaze_variables).slope-Epoch.ACCg.(monkey_id).stim_early.(gaze_variables).slope,'omitnan') median(Epoch.ACCg.(monkey_id).stim_late.(gaze_variables).slope-Epoch.ACCg.(monkey_id).stim_early.(gaze_variables).slope,'omitnan')], [0 100],'Color','r');
        xlim(slope_xlim)
        ylim([0 120]);
        yticks([0 20 40 60 80 100 120]);
        title('ACCg shuffled')
        ax6=gca; 
        axis(ax6,'square')
       
        linkaxes([ax1,ax2,ax3],'y');
        linkaxes([ax4,ax5,ax6],'y');
    
        sgtitle(sprintf(['slope_' gaze_variables '_' monkey_id]),'Interpreter', 'none')   
        set(gcf, 'Renderer', 'painters');
        saveas(gcf,sprintf(['slope_' gaze_variables,'_',monkey_id]))
        saveas(gcf,sprintf(['slope_' gaze_variables,'_',monkey_id,'.jpg']))
        saveas(gcf,sprintf(['slope_' gaze_variables,'_',monkey_id,'.epsc']))

    clf

    end

end

%% Number of trials in 45 stims are actually involved in the correlation (non-NaNs) 

% Upload Decomp_Temporal_Combined.mat

monkey_names={'All', 'Lynch', 'Tarantino'};
    
for nmonkey=1:3
    monkey_id=char(monkey_names(nmonkey));
    
    % OFC

    OFC_nonNaN.(monkey_id).stim_late.distance=[];
    OFC_nonNaN.(monkey_id).stim_late.contra=[];
    OFC_nonNaN.(monkey_id).stim_late.ipsi=[];

    OFC_nonNaN.(monkey_id).stim_early.distance=[];
    OFC_nonNaN.(monkey_id).stim_early.contra=[];
    OFC_nonNaN.(monkey_id).stim_early.ipsi=[];

    for nOFC=1:length(OFC_day.(monkey_id))

        field_id=char(strcat('data_',OFC_day.(monkey_id)(nOFC)));

        % stim and sham general distance
        OFC_nonNaN.(monkey_id).stim_late.distance=[OFC_nonNaN.(monkey_id).stim_late.distance sum(~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes) & ~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true))];
        OFC_nonNaN.(monkey_id).stim_late.contra=[OFC_nonNaN.(monkey_id).stim_late.contra sum(~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes_contra) & ~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true))];
        OFC_nonNaN.(monkey_id).stim_late.ipsi=[OFC_nonNaN.(monkey_id).stim_late.ipsi sum(~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes_ipsi) & ~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true))];

        OFC_nonNaN.(monkey_id).stim_early.distance=[OFC_nonNaN.(monkey_id).stim_early.distance sum(~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes) & ~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true))];
        OFC_nonNaN.(monkey_id).stim_early.contra=[OFC_nonNaN.(monkey_id).stim_early.contra sum(~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes_contra) & ~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true))];
        OFC_nonNaN.(monkey_id).stim_early.ipsi=[OFC_nonNaN.(monkey_id).stim_early.ipsi sum(~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes_ipsi) & ~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true))];

    end

    OFC_nonNaN.(monkey_id).late_minus_early.distance=OFC_nonNaN.(monkey_id).stim_late.distance-OFC_nonNaN.(monkey_id).stim_early.distance;
    OFC_nonNaN.(monkey_id).late_minus_early.contra=OFC_nonNaN.(monkey_id).stim_late.contra-OFC_nonNaN.(monkey_id).stim_early.contra;
    OFC_nonNaN.(monkey_id).late_minus_early.ipsi=OFC_nonNaN.(monkey_id).stim_late.ipsi-OFC_nonNaN.(monkey_id).stim_early.ipsi;
    
    [p.OFC_nonNaN.(monkey_id).distance, h.OFC_nonNaN.(monkey_id).distance]=signrank(OFC_nonNaN.(monkey_id).late_minus_early.distance);
    [p.OFC_nonNaN.(monkey_id).contra, h.OFC_nonNaN.(monkey_id).contra]=signrank(OFC_nonNaN.(monkey_id).late_minus_early.contra);
    [p.OFC_nonNaN.(monkey_id).ipsi, h.OFC_nonNaN.(monkey_id).ipsi]=signrank(OFC_nonNaN.(monkey_id).late_minus_early.ipsi);

    % dmPFC

    dmPFC_nonNaN.(monkey_id).stim_late.distance=[];
    dmPFC_nonNaN.(monkey_id).stim_late.contra=[];
    dmPFC_nonNaN.(monkey_id).stim_late.ipsi=[];

    dmPFC_nonNaN.(monkey_id).stim_early.distance=[];
    dmPFC_nonNaN.(monkey_id).stim_early.contra=[];
    dmPFC_nonNaN.(monkey_id).stim_early.ipsi=[];

    for ndmPFC=1:length(dmPFC_day.(monkey_id))

        field_id=char(strcat('data_',dmPFC_day.(monkey_id)(ndmPFC)));

        % stim and sham general distance
        dmPFC_nonNaN.(monkey_id).stim_late.distance=[dmPFC_nonNaN.(monkey_id).stim_late.distance sum(~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes) & ~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true))];
        dmPFC_nonNaN.(monkey_id).stim_late.contra=[dmPFC_nonNaN.(monkey_id).stim_late.contra sum(~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes_contra) & ~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true))];
        dmPFC_nonNaN.(monkey_id).stim_late.ipsi=[dmPFC_nonNaN.(monkey_id).stim_late.ipsi sum(~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes_ipsi) & ~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true))];

        dmPFC_nonNaN.(monkey_id).stim_early.distance=[dmPFC_nonNaN.(monkey_id).stim_early.distance sum(~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes) & ~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true))];
        dmPFC_nonNaN.(monkey_id).stim_early.contra=[dmPFC_nonNaN.(monkey_id).stim_early.contra sum(~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes_contra) & ~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true))];
        dmPFC_nonNaN.(monkey_id).stim_early.ipsi=[dmPFC_nonNaN.(monkey_id).stim_early.ipsi sum(~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes_ipsi) & ~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true))];

    end

    dmPFC_nonNaN.(monkey_id).late_minus_early.distance=dmPFC_nonNaN.(monkey_id).stim_late.distance-dmPFC_nonNaN.(monkey_id).stim_early.distance;
    dmPFC_nonNaN.(monkey_id).late_minus_early.contra=dmPFC_nonNaN.(monkey_id).stim_late.contra-dmPFC_nonNaN.(monkey_id).stim_early.contra;
    dmPFC_nonNaN.(monkey_id).late_minus_early.ipsi=dmPFC_nonNaN.(monkey_id).stim_late.ipsi-dmPFC_nonNaN.(monkey_id).stim_early.ipsi;

    [p.dmPFC_nonNaN.(monkey_id).distance, h.dmPFC_nonNaN.(monkey_id).distance]=signrank(dmPFC_nonNaN.(monkey_id).late_minus_early.distance);
    [p.dmPFC_nonNaN.(monkey_id).contra, h.dmPFC_nonNaN.(monkey_id).contra]=signrank(dmPFC_nonNaN.(monkey_id).late_minus_early.contra);
    [p.dmPFC_nonNaN.(monkey_id).ipsi, h.dmPFC_nonNaN.(monkey_id).ipsi]=signrank(dmPFC_nonNaN.(monkey_id).late_minus_early.ipsi);

    % ACCg

    ACCg_nonNaN.(monkey_id).stim_late.distance=[];
    ACCg_nonNaN.(monkey_id).stim_late.contra=[];
    ACCg_nonNaN.(monkey_id).stim_late.ipsi=[];

    ACCg_nonNaN.(monkey_id).stim_early.distance=[];
    ACCg_nonNaN.(monkey_id).stim_early.contra=[];
    ACCg_nonNaN.(monkey_id).stim_early.ipsi=[];

    for nACCg=1:length(ACCg_day.(monkey_id))

        field_id=char(strcat('data_',ACCg_day.(monkey_id)(nACCg)));

        % stim and sham general distance
        ACCg_nonNaN.(monkey_id).stim_late.distance=[ACCg_nonNaN.(monkey_id).stim_late.distance sum(~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes) & ~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true))];
        ACCg_nonNaN.(monkey_id).stim_late.contra=[ACCg_nonNaN.(monkey_id).stim_late.contra sum(~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes_contra) & ~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true))];
        ACCg_nonNaN.(monkey_id).stim_late.ipsi=[ACCg_nonNaN.(monkey_id).stim_late.ipsi sum(~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes_ipsi) & ~isnan(Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true))];

        ACCg_nonNaN.(monkey_id).stim_early.distance=[ACCg_nonNaN.(monkey_id).stim_early.distance sum(~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes) & ~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true))];
        ACCg_nonNaN.(monkey_id).stim_early.contra=[ACCg_nonNaN.(monkey_id).stim_early.contra sum(~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes_contra) & ~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true))];
        ACCg_nonNaN.(monkey_id).stim_early.ipsi=[ACCg_nonNaN.(monkey_id).stim_early.ipsi sum(~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes_ipsi) & ~isnan(Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true))];

    end

    ACCg_nonNaN.(monkey_id).late_minus_early.distance=ACCg_nonNaN.(monkey_id).stim_late.distance-ACCg_nonNaN.(monkey_id).stim_early.distance;
    ACCg_nonNaN.(monkey_id).late_minus_early.contra=ACCg_nonNaN.(monkey_id).stim_late.contra-ACCg_nonNaN.(monkey_id).stim_early.contra;
    ACCg_nonNaN.(monkey_id).late_minus_early.ipsi=ACCg_nonNaN.(monkey_id).stim_late.ipsi-ACCg_nonNaN.(monkey_id).stim_early.ipsi;

    [p.ACCg_nonNaN.(monkey_id).distance, h.ACCg_nonNaN.(monkey_id).distance]=signrank(ACCg_nonNaN.(monkey_id).late_minus_early.distance);
    [p.ACCg_nonNaN.(monkey_id).contra, h.ACCg_nonNaN.(monkey_id).contra]=signrank(ACCg_nonNaN.(monkey_id).late_minus_early.contra);
    [p.ACCg_nonNaN.(monkey_id).ipsi, h.ACCg_nonNaN.(monkey_id).ipsi]=signrank(ACCg_nonNaN.(monkey_id).late_minus_early.ipsi);

end

nonNaN.OFC=OFC_nonNaN;
nonNaN.dmPFC=dmPFC_nonNaN;
nonNaN.ACCg=ACCg_nonNaN;
nonNaN.p.OFC_nonNaN=p.OFC_nonNaN;
nonNaN.p.dmPFC_nonNaN=p.dmPFC_nonNaN;
nonNaN.p.ACCg_nonNaN=p.ACCg_nonNaN;
save('nonNaN_Combined.mat','nonNaN','-v7.3');



