%% Divide time into early (1-45) and late (46-90) epoches

% Upload Decomp_Results_Combined.mat and collapse across trials

fieldname=fieldnames(Decomp_Results);
n_not_stim=2;

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    field_run=fieldnames(Decomp_Results.(field_id));

    for l=1:size(field_run,1)
        
        run_id=char(field_run(l));
        field_stim=fieldnames(Decomp_Results.(field_id).(run_id));
        Decomp_time.(field_id).(run_id).stim_time=Decomp_Results.(field_id).(run_id).stim_time;
        Decomp_time.(field_id).(run_id).current_label=Decomp_Results.(field_id).(run_id).current_label;
        
        Decomp_time.(field_id).(run_id).m1_distance_to_eyes_contra=[];
        Decomp_time.(field_id).(run_id).m1_distance_to_eyes_ipsi=[];
        Decomp_time.(field_id).(run_id).m1_distance_to_eyes=[];
        Decomp_time.(field_id).(run_id).causal_m1m2_eyes_true=[];
      
        % already removed the first trial
        
        for nstim=1:size(field_stim,1)-n_not_stim
            
        stim_id=char(field_stim(nstim+n_not_stim));

        Decomp_time.(field_id).(run_id).m1_distance_to_eyes_contra=[Decomp_time.(field_id).(run_id).m1_distance_to_eyes_contra Decomp_Results.(field_id).(run_id).(stim_id).m1_distance_to_eyes_contra];
        Decomp_time.(field_id).(run_id).m1_distance_to_eyes_ipsi=[Decomp_time.(field_id).(run_id).m1_distance_to_eyes_ipsi Decomp_Results.(field_id).(run_id).(stim_id).m1_distance_to_eyes_ipsi];
        Decomp_time.(field_id).(run_id).m1_distance_to_eyes=[Decomp_time.(field_id).(run_id).m1_distance_to_eyes Decomp_Results.(field_id).(run_id).(stim_id).m1_distance_to_eyes];
        Decomp_time.(field_id).(run_id).causal_m1m2_eyes_true=[Decomp_time.(field_id).(run_id).causal_m1m2_eyes_true Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_eyes.true_index];
        
        clear stim_id

        end

        clear nstim run_id field_stim

    end

    clear l field_id field_run

end

save('Decomp_Temporal_Run_Combined.mat','Decomp_time','-v7.3') 

%% Collapse across runs for each day

fieldname=fieldnames(Decomp_time);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    field_run=fieldnames(Decomp_time.(field_id));

    Decomp_day.(field_id).stim_time=[];
    Decomp_day.(field_id).current_label=[];
    Decomp_day.(field_id).m1_distance_to_eyes_contra=[];
    Decomp_day.(field_id).m1_distance_to_eyes_ipsi=[];
    Decomp_day.(field_id).m1_distance_to_eyes=[];
    Decomp_day.(field_id).causal_m1m2_eyes_true=[];

    for l=1:size(field_run,1)

        run_id=char(field_run(l));

        Decomp_day.(field_id).stim_time=[Decomp_day.(field_id).stim_time Decomp_time.(field_id).(run_id).stim_time];
        Decomp_day.(field_id).current_label=[Decomp_day.(field_id).current_label Decomp_time.(field_id).(run_id).current_label];
        Decomp_day.(field_id).m1_distance_to_eyes_contra=[Decomp_day.(field_id).m1_distance_to_eyes_contra Decomp_time.(field_id).(run_id).m1_distance_to_eyes_contra];
        Decomp_day.(field_id).m1_distance_to_eyes_ipsi=[Decomp_day.(field_id).m1_distance_to_eyes_ipsi Decomp_time.(field_id).(run_id).m1_distance_to_eyes_ipsi];
        Decomp_day.(field_id).m1_distance_to_eyes=[Decomp_day.(field_id).m1_distance_to_eyes Decomp_time.(field_id).(run_id).m1_distance_to_eyes];
        Decomp_day.(field_id).causal_m1m2_eyes_true=[Decomp_day.(field_id).causal_m1m2_eyes_true Decomp_time.(field_id).(run_id).causal_m1m2_eyes_true];
        
        clear run_id

    end

    clear l field_id field_run

end

save('Decomp_Temporal_Day_Combined.mat','Decomp_day','-v7.3') 

%% Calculate the numer of stim per day 

fieldname=fieldnames(Decomp_day);
Number_of_stim=[];
Number_of_sham=[];

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    Number_of_stim=[Number_of_stim sum(contains(Decomp_day.(field_id).current_label,'stim'))];
    Number_of_sham=[Number_of_sham sum(contains(Decomp_day.(field_id).current_label,'sham'))];
end

% 76 days with more than 90 stims 
% Five days excluded: 08122019 OFC Lynch, 11042021 Tarantino ACCg, 11052021 Tarantino dmPFC, 12172021 Tarantino dmPFC, 12222021 Tarantino OFC)

%% Put information together for each time bin (1-45, 46-90 stims)

fieldname=fieldnames(Decomp_day);
time_bin={'stim_1_45','stim_46_90'};

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));

    for n_bin=1:2

        bin_id=char(time_bin(n_bin));

        Decomp_Temporal.(field_id).(bin_id).stim.stim_time=[];
        Decomp_Temporal.(field_id).(bin_id).stim.current_label=[];
        Decomp_Temporal.(field_id).(bin_id).stim.m1_distance_to_eyes_contra=[];
        Decomp_Temporal.(field_id).(bin_id).stim.m1_distance_to_eyes_ipsi=[];
        Decomp_Temporal.(field_id).(bin_id).stim.m1_distance_to_eyes=[];
        Decomp_Temporal.(field_id).(bin_id).stim.causal_m1m2_eyes_true=[];
        
        Decomp_Temporal.(field_id).(bin_id).sham.stim_time=[];
        Decomp_Temporal.(field_id).(bin_id).sham.current_label=[];
        Decomp_Temporal.(field_id).(bin_id).sham.m1_distance_to_eyes_contra=[];
        Decomp_Temporal.(field_id).(bin_id).sham.m1_distance_to_eyes_ipsi=[];
        Decomp_Temporal.(field_id).(bin_id).sham.m1_distance_to_eyes=[];
        Decomp_Temporal.(field_id).(bin_id).sham.causal_m1m2_eyes_true=[];
        
    end

    number_stim=sum(contains(Decomp_day.(field_id).current_label,'stim'));
    n_trial=length(Decomp_day.(field_id).current_label);
    count_stim=1;

    if number_stim>=90

        for ntrial=1:n_trial

            if count_stim<=45

                if isequal(Decomp_day.(field_id).current_label{1,ntrial},'stim') 
                    Decomp_Temporal.(field_id).stim_1_45.stim.stim_time=[Decomp_Temporal.(field_id).stim_1_45.stim.stim_time Decomp_day.(field_id).stim_time(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_1_45.stim.current_label=[Decomp_Temporal.(field_id).stim_1_45.stim.current_label,{Decomp_day.(field_id).current_label(1,ntrial)}];
                    Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes_contra=[Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes_contra Decomp_day.(field_id).m1_distance_to_eyes_contra(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes_ipsi=[Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes_ipsi Decomp_day.(field_id).m1_distance_to_eyes_ipsi(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes=[Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes Decomp_day.(field_id).m1_distance_to_eyes(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true=[Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true Decomp_day.(field_id).causal_m1m2_eyes_true(1,ntrial)];
                    count_stim=count_stim+1;
                else
                    Decomp_Temporal.(field_id).stim_1_45.sham.stim_time=[Decomp_Temporal.(field_id).stim_1_45.sham.stim_time Decomp_day.(field_id).stim_time(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_1_45.sham.current_label=[Decomp_Temporal.(field_id).stim_1_45.sham.current_label, {Decomp_day.(field_id).current_label(1,ntrial)}];
                    Decomp_Temporal.(field_id).stim_1_45.sham.m1_distance_to_eyes_contra=[Decomp_Temporal.(field_id).stim_1_45.sham.m1_distance_to_eyes_contra Decomp_day.(field_id).m1_distance_to_eyes_contra(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_1_45.sham.m1_distance_to_eyes_ipsi=[Decomp_Temporal.(field_id).stim_1_45.sham.m1_distance_to_eyes_ipsi Decomp_day.(field_id).m1_distance_to_eyes_ipsi(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_1_45.sham.m1_distance_to_eyes=[Decomp_Temporal.(field_id).stim_1_45.sham.m1_distance_to_eyes Decomp_day.(field_id).m1_distance_to_eyes(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_1_45.sham.causal_m1m2_eyes_true=[Decomp_Temporal.(field_id).stim_1_45.sham.causal_m1m2_eyes_true Decomp_day.(field_id).causal_m1m2_eyes_true(1,ntrial)];    
                end

            elseif count_stim>45 && count_stim<=90

                 if isequal(Decomp_day.(field_id).current_label{1,ntrial},'stim') 
                    Decomp_Temporal.(field_id).stim_46_90.stim.stim_time=[Decomp_Temporal.(field_id).stim_46_90.stim.stim_time Decomp_day.(field_id).stim_time(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_46_90.stim.current_label=[Decomp_Temporal.(field_id).stim_46_90.stim.current_label,{Decomp_day.(field_id).current_label(1,ntrial)}];
                    Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes_contra=[Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes_contra Decomp_day.(field_id).m1_distance_to_eyes_contra(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes_ipsi=[Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes_ipsi Decomp_day.(field_id).m1_distance_to_eyes_ipsi(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes=[Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes Decomp_day.(field_id).m1_distance_to_eyes(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true=[Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true Decomp_day.(field_id).causal_m1m2_eyes_true(1,ntrial)];
                    count_stim=count_stim+1;
                else
                    Decomp_Temporal.(field_id).stim_46_90.sham.stim_time=[Decomp_Temporal.(field_id).stim_46_90.sham.stim_time Decomp_day.(field_id).stim_time(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_46_90.sham.current_label=[Decomp_Temporal.(field_id).stim_46_90.sham.current_label, {Decomp_day.(field_id).current_label(1,ntrial)}];
                    Decomp_Temporal.(field_id).stim_46_90.sham.m1_distance_to_eyes_contra=[Decomp_Temporal.(field_id).stim_46_90.sham.m1_distance_to_eyes_contra Decomp_day.(field_id).m1_distance_to_eyes_contra(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_46_90.sham.m1_distance_to_eyes_ipsi=[Decomp_Temporal.(field_id).stim_46_90.sham.m1_distance_to_eyes_ipsi Decomp_day.(field_id).m1_distance_to_eyes_ipsi(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_46_90.sham.m1_distance_to_eyes=[Decomp_Temporal.(field_id).stim_46_90.sham.m1_distance_to_eyes Decomp_day.(field_id).m1_distance_to_eyes(1,ntrial)];
                    Decomp_Temporal.(field_id).stim_46_90.sham.causal_m1m2_eyes_true=[Decomp_Temporal.(field_id).stim_46_90.sham.causal_m1m2_eyes_true Decomp_day.(field_id).causal_m1m2_eyes_true(1,ntrial)];
                end

            end

        end

    end

    clear count_stim n_trial number_stim

end

save('Decomp_Temporal_Combined.mat','Decomp_Temporal','-v7.3') 

%% Create null distribution by shuffling stim order and sham order separately 

fieldname=fieldnames(Decomp_Temporal);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));

    if ~isempty(Decomp_Temporal.(field_id).stim_1_45.stim.stim_time)
  
        n_stim=length(Decomp_Temporal.(field_id).stim_1_45.stim.stim_time)+length(Decomp_Temporal.(field_id).stim_46_90.stim.stim_time);
        n_sham=length(Decomp_Temporal.(field_id).stim_1_45.sham.stim_time)+length(Decomp_Temporal.(field_id).stim_46_90.sham.stim_time);
        n_sham_1_45=length(Decomp_Temporal.(field_id).stim_1_45.sham.stim_time);
        stim_m1_distance_to_eyes=[Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes];
        stim_m1_distance_to_eyes_ipsi=[Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes_ipsi Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes_ipsi];
        stim_m1_distance_to_eyes_contra=[Decomp_Temporal.(field_id).stim_1_45.stim.m1_distance_to_eyes_contra Decomp_Temporal.(field_id).stim_46_90.stim.m1_distance_to_eyes_contra];
        stim_causal_m1m2_eyes_true=[Decomp_Temporal.(field_id).stim_1_45.stim.causal_m1m2_eyes_true Decomp_Temporal.(field_id).stim_46_90.stim.causal_m1m2_eyes_true];
        
        sham_m1_distance_to_eyes=[Decomp_Temporal.(field_id).stim_1_45.sham.m1_distance_to_eyes Decomp_Temporal.(field_id).stim_46_90.sham.m1_distance_to_eyes];
        sham_m1_distance_to_eyes_ipsi=[Decomp_Temporal.(field_id).stim_1_45.sham.m1_distance_to_eyes_ipsi Decomp_Temporal.(field_id).stim_46_90.sham.m1_distance_to_eyes_ipsi];
        sham_m1_distance_to_eyes_contra=[Decomp_Temporal.(field_id).stim_1_45.sham.m1_distance_to_eyes_contra Decomp_Temporal.(field_id).stim_46_90.sham.m1_distance_to_eyes_contra];
        sham_causal_m1m2_eyes_true=[Decomp_Temporal.(field_id).stim_1_45.sham.causal_m1m2_eyes_true Decomp_Temporal.(field_id).stim_46_90.sham.causal_m1m2_eyes_true];
        
        % shuffle stim and sham separately
    
        for rep=1:1000
        
            n_stim_idx(rep,:)=randperm(n_stim,n_stim);
    
            Decomp_Temporal_shuffled.(field_id).stim_1_45.stim.m1_distance_to_eyes(rep,:)=stim_m1_distance_to_eyes(n_stim_idx(rep,1:45));
            Decomp_Temporal_shuffled.(field_id).stim_46_90.stim.m1_distance_to_eyes(rep,:)=stim_m1_distance_to_eyes(n_stim_idx(rep,46:90));
    
            Decomp_Temporal_shuffled.(field_id).stim_1_45.stim.m1_distance_to_eyes_ipsi(rep,:)=stim_m1_distance_to_eyes_ipsi(n_stim_idx(rep,1:45));
            Decomp_Temporal_shuffled.(field_id).stim_46_90.stim.m1_distance_to_eyes_ipsi(rep,:)=stim_m1_distance_to_eyes_ipsi(n_stim_idx(rep,46:90));
    
            Decomp_Temporal_shuffled.(field_id).stim_1_45.stim.m1_distance_to_eyes_contra(rep,:)=stim_m1_distance_to_eyes_contra(n_stim_idx(rep,1:45));
            Decomp_Temporal_shuffled.(field_id).stim_46_90.stim.m1_distance_to_eyes_contra(rep,:)=stim_m1_distance_to_eyes_contra(n_stim_idx(rep,46:90));
    
            Decomp_Temporal_shuffled.(field_id).stim_1_45.stim.causal_m1m2_eyes_null(rep,:)=stim_causal_m1m2_eyes_true(n_stim_idx(rep,1:45));
            Decomp_Temporal_shuffled.(field_id).stim_46_90.stim.causal_m1m2_eyes_null(rep,:)=stim_causal_m1m2_eyes_true(n_stim_idx(rep,46:90));
    
            n_sham_idx(rep,:)=randperm(n_sham,n_sham);
    
            Decomp_Temporal_shuffled.(field_id).stim_1_45.sham.m1_distance_to_eyes(rep,:)=sham_m1_distance_to_eyes(n_sham_idx(rep,1:n_sham_1_45));
            Decomp_Temporal_shuffled.(field_id).stim_46_90.sham.m1_distance_to_eyes(rep,:)=sham_m1_distance_to_eyes(n_sham_idx(rep,n_sham_1_45+1:end));
    
            Decomp_Temporal_shuffled.(field_id).stim_1_45.sham.m1_distance_to_eyes_ipsi(rep,:)=sham_m1_distance_to_eyes_ipsi(n_sham_idx(rep,1:n_sham_1_45));
            Decomp_Temporal_shuffled.(field_id).stim_46_90.sham.m1_distance_to_eyes_ipsi(rep,:)=sham_m1_distance_to_eyes_ipsi(n_sham_idx(rep,n_sham_1_45+1:end));
    
            Decomp_Temporal_shuffled.(field_id).stim_1_45.sham.m1_distance_to_eyes_contra(rep,:)=sham_m1_distance_to_eyes_contra(n_sham_idx(rep,1:n_sham_1_45));
            Decomp_Temporal_shuffled.(field_id).stim_46_90.sham.m1_distance_to_eyes_contra(rep,:)=sham_m1_distance_to_eyes_contra(n_sham_idx(rep,n_sham_1_45+1:end));
    
            Decomp_Temporal_shuffled.(field_id).stim_1_45.sham.causal_m1m2_eyes_null(rep,:)=sham_causal_m1m2_eyes_true(n_sham_idx(rep,1:n_sham_1_45));
            Decomp_Temporal_shuffled.(field_id).stim_46_90.sham.causal_m1m2_eyes_null(rep,:)=sham_causal_m1m2_eyes_true(n_sham_idx(rep,n_sham_1_45+1:end));
    
        end  
        
        clear n_stim_idx n_sham_idx n_stim n_sham n_sham_1_45 
        clear stim_m1_distance_to_eyes stim_m1_distance_to_eyes_ipsi stim_m1_distance_to_eyes_contra stim_causal_m1m2_eyes_true
        clear sham_m1_distance_to_eyes sham_m1_distance_to_eyes_ipsi sham_m1_distance_to_eyes_contra sham_causal_m1m2_eyes_true
    
    end

end

save('Decomp_Temporal_Shuffled_Combined.mat','Decomp_Temporal_shuffled','-v7.3') 

