%% Upload data

% Upload Gaze_Matrices_Combined_0_15.mat in Basic behaviors 0_1.5 folder

files = dir('*.mat');

%% Read through files in a result folder

fieldname = {files.name};
folder_name='cd_output_null_02_1000_150_100_10';

for k=1:size(fieldname,2)
    field_id=char(fieldname{1,k}(1:end-4));    
    Decomp_data.(field_id) = load(append('/Volumes/Brains/BRAINS Microstimulation/Combined/Gaze/Eyes/Dynamics/Distance/Causal Decomposition/',folder_name,'/',fieldname{1,k})).res.(field_id);
    
    field_run=fieldnames(GazeMatrices.(field_id));

    for l=1:size(field_run,1)
        run_id=char(field_run(l));

        field_stim=fieldnames(GazeMatrices.(field_id).(run_id));

        Decomp.(field_id).(run_id).stim_ts=[];
        Decomp.(field_id).(run_id).all_stim_labels=[];

        n_not_stim = 14;

        % remove the first trial in a run

        for nstim=2:size(field_stim,1)-n_not_stim     
            stim_id=char(field_stim(nstim+n_not_stim));

            Decomp.(field_id).(run_id).stim_ts=[Decomp.(field_id).(run_id).stim_ts GazeMatrices.(field_id).(run_id).stim_time(nstim)];
            Decomp.(field_id).(run_id).all_stim_labels=[Decomp.(field_id).(run_id).all_stim_labels {GazeMatrices.(field_id).(run_id).current_label(nstim,:)}];

            Decomp.(field_id).(run_id).(stim_id).m1_distance_to_eyes_contra=mean(GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes_contra,'omitnan');
            Decomp.(field_id).(run_id).(stim_id).m1_distance_to_eyes_ipsi=mean(GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes_ipsi,'omitnan');
            Decomp.(field_id).(run_id).(stim_id).m1_distance_to_eyes=mean(GazeMatrices.(field_id).(run_id).(stim_id).m1_distance_to_eyes,'omitnan');
                
            if isfield(Decomp_data.(field_id),run_id)

                if isfield(Decomp_data.(field_id).(run_id),stim_id)
    
                    Decomp.(field_id).(run_id).(stim_id).causal_m1m2_eyes=Decomp_data.(field_id).(run_id).(stim_id).causal_m1m2_eyes;
                    Decomp.(field_id).(run_id).(stim_id).causal_m1m2_mouth=Decomp_data.(field_id).(run_id).(stim_id).causal_m1m2_mouth;
                    Decomp.(field_id).(run_id).(stim_id).causal_m1m2_face=Decomp_data.(field_id).(run_id).(stim_id).causal_m1m2_face;
    
                else
    
                    Decomp.(field_id).(run_id).(stim_id).causal_m1m2_eyes=NaN;
                    Decomp.(field_id).(run_id).(stim_id).causal_m1m2_mouth=NaN;
                    Decomp.(field_id).(run_id).(stim_id).causal_m1m2_face=NaN;
                
                end    

            else

                Decomp.(field_id).(run_id).(stim_id).causal_m1m2_eyes=NaN;
                Decomp.(field_id).(run_id).(stim_id).causal_m1m2_mouth=NaN;
                Decomp.(field_id).(run_id).(stim_id).causal_m1m2_face=NaN;

            end
       
            clear stim_id

        end

        clear nstim field_stim
        
    end

    clear l field_id field_run

end

save('Decomposition_Combined.mat','Decomp','-v7.3')

%% Calculate decomposition index

fieldname=fieldnames(Decomp);
n_not_stim=2;

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    field_run=fieldnames(Decomp.(field_id));
    
    for l=1:size(field_run,1)
        
        run_id=char(field_run(l));
        field_stim=fieldnames(Decomp.(field_id).(run_id));

        Decomp_Results.(field_id).(run_id).stim_time=Decomp.(field_id).(run_id).stim_ts;
        Decomp_Results.(field_id).(run_id).current_label=Decomp.(field_id).(run_id).all_stim_labels;
        
        for nstim=1:size(field_stim,1)-n_not_stim
            
        stim_id=char(field_stim(nstim+n_not_stim));

        Decomp_Results.(field_id).(run_id).(stim_id).m1_distance_to_eyes_contra=Decomp.(field_id).(run_id).(stim_id).m1_distance_to_eyes_contra;
        Decomp_Results.(field_id).(run_id).(stim_id).m1_distance_to_eyes_ipsi=Decomp.(field_id).(run_id).(stim_id).m1_distance_to_eyes_ipsi;
        Decomp_Results.(field_id).(run_id).(stim_id).m1_distance_to_eyes=Decomp.(field_id).(run_id).(stim_id).m1_distance_to_eyes;
        
            if isstruct(Decomp.(field_id).(run_id).(stim_id).causal_m1m2_eyes)

                if ~isnan(Decomp.(field_id).(run_id).(stim_id).causal_m1m2_eyes.true)
            
                Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_eyes.true_index=mean(Decomp.(field_id).(run_id).(stim_id).causal_m1m2_eyes.true(:,1));
                Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_mouth.true_index=mean(Decomp.(field_id).(run_id).(stim_id).causal_m1m2_mouth.true(:,1));
                Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_face.true_index=mean(Decomp.(field_id).(run_id).(stim_id).causal_m1m2_face.true(:,1));
                
                else
                    
                    Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_eyes.true_index=NaN;
                    Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_mouth.true_index=NaN;
                    Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_face.true_index=NaN;
                  
                end

            else

                Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_eyes.true_index=NaN;
                Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_mouth.true_index=NaN;
                Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_face.true_index=NaN;
              
            end
            
            clear stim_id
        
        end
        
        clear nstim run_id field_stim
        
    end
    
    clear l field_id field_run
    
end
        
save('Decomp_Results_Combined.mat','Decomp_Results','-v7.3')

%% Put information together for each current sham and stim

fieldname=fieldnames(Decomp_Results);
n_not_stim = 2;

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    field_run=fieldnames(Decomp_Results.(field_id));
    
    for l=1:size(field_run,1)
        
        run_id=char(field_run(l));
        field_stim=fieldnames(Decomp_Results.(field_id).(run_id));
        stim_label={char('current_sham') char('current_stim')};
        
        for i=1:2

            Decomp_Results_run.(field_id).(run_id).(stim_label{i}).causal_m1m2_eyes.true_index=[];
            Decomp_Results_run.(field_id).(run_id).(stim_label{i}).causal_m1m2_mouth.true_index=[];
            Decomp_Results_run.(field_id).(run_id).(stim_label{i}).causal_m1m2_face.true_index=[];

            Decomp_Results_run.(field_id).(run_id).(stim_label{i}).causal_m1m2_eyes.null_index=[];
            Decomp_Results_run.(field_id).(run_id).(stim_label{i}).causal_m1m2_mouth.null_index=[];
            Decomp_Results_run.(field_id).(run_id).(stim_label{i}).causal_m1m2_face.null_index=[];
            
            Decomp_Results_run.(field_id).(run_id).(stim_label{i}).m1_distance_to_eyes_contra=[];
            Decomp_Results_run.(field_id).(run_id).(stim_label{i}).m1_distance_to_eyes_ipsi=[];
            Decomp_Results_run.(field_id).(run_id).(stim_label{i}).m1_distance_to_eyes=[];
           
        end     
        
        % already moved the first trial 

        for nstim=1:length(field_stim)-n_not_stim 
            stim_id=char(field_stim(nstim+n_not_stim));

            if isequal(Decomp_Results.(field_id).(run_id).current_label{1,nstim},'sham')                   
                label=stim_label{1};   
            elseif isequal(Decomp_Results.(field_id).(run_id).current_label{1,nstim},'stim')
                label=stim_label{2};
            end
 
            Decomp_Results_run.(field_id).(run_id).(label).causal_m1m2_eyes.true_index=[Decomp_Results_run.(field_id).(run_id).(label).causal_m1m2_eyes.true_index, Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_eyes.true_index];
            Decomp_Results_run.(field_id).(run_id).(label).causal_m1m2_mouth.true_index=[Decomp_Results_run.(field_id).(run_id).(label).causal_m1m2_mouth.true_index, Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_mouth.true_index];
            Decomp_Results_run.(field_id).(run_id).(label).causal_m1m2_face.true_index=[Decomp_Results_run.(field_id).(run_id).(label).causal_m1m2_face.true_index, Decomp_Results.(field_id).(run_id).(stim_id).causal_m1m2_face.true_index];
            
            Decomp_Results_run.(field_id).(run_id).(label).m1_distance_to_eyes_contra=[Decomp_Results_run.(field_id).(run_id).(label).m1_distance_to_eyes_contra, Decomp_Results.(field_id).(run_id).(stim_id).m1_distance_to_eyes_contra];
            Decomp_Results_run.(field_id).(run_id).(label).m1_distance_to_eyes_ipsi=[Decomp_Results_run.(field_id).(run_id).(label).m1_distance_to_eyes_ipsi, Decomp_Results.(field_id).(run_id).(stim_id).m1_distance_to_eyes_ipsi];
            Decomp_Results_run.(field_id).(run_id).(label).m1_distance_to_eyes=[Decomp_Results_run.(field_id).(run_id).(label).m1_distance_to_eyes, Decomp_Results.(field_id).(run_id).(stim_id).m1_distance_to_eyes];
           
            clear label  stim_id
            
        end
            
        clear nstim run_id field_stim
        
    end

    clear l field_id field_run

end
    
save('Decomp_Results_Run_Combined.mat','Decomp_Results_run','-v7.3') 

%% Put information together for each day

fieldname=fieldnames(Decomp_Results_run);

for k=1:size(fieldname,1)
    
    field_id=char(fieldname(k));
    field_run=fieldnames(Decomp_Results_run.(field_id));
    stim_label={char('current_sham') char('current_stim')};

    for i=1:2
        
    Decomp_Results_day.(field_id).(stim_label{i}).causal_m1m2_eyes.true_index=[];
    Decomp_Results_day.(field_id).(stim_label{i}).causal_m1m2_mouth.true_index=[];
    Decomp_Results_day.(field_id).(stim_label{i}).causal_m1m2_face.true_index=[];

    Decomp_Results_day.(field_id).(stim_label{i}).m1_distance_to_eyes_contra=[];
    Decomp_Results_day.(field_id).(stim_label{i}).m1_distance_to_eyes_ipsi=[];
    Decomp_Results_day.(field_id).(stim_label{i}).m1_distance_to_eyes=[];

    end

    clear i

    for l=1:size(field_run,1)
    
    run_id=char(field_run(l));
    
        for m=1:2

            label=stim_label{m};

            Decomp_Results_day.(field_id).(label).causal_m1m2_eyes.true_index = [Decomp_Results_day.(field_id).(label).causal_m1m2_eyes.true_index Decomp_Results_run.(field_id).(run_id).(label).causal_m1m2_eyes.true_index];
            Decomp_Results_day.(field_id).(label).causal_m1m2_mouth.true_index = [Decomp_Results_day.(field_id).(label).causal_m1m2_mouth.true_index Decomp_Results_run.(field_id).(run_id).(label).causal_m1m2_mouth.true_index];
            Decomp_Results_day.(field_id).(label).causal_m1m2_face.true_index = [Decomp_Results_day.(field_id).(label).causal_m1m2_face.true_index Decomp_Results_run.(field_id).(run_id).(label).causal_m1m2_face.true_index];
            
            Decomp_Results_day.(field_id).(label).m1_distance_to_eyes_contra = [Decomp_Results_day.(field_id).(label).m1_distance_to_eyes_contra Decomp_Results_run.(field_id).(run_id).(label).m1_distance_to_eyes_contra];
            Decomp_Results_day.(field_id).(label).m1_distance_to_eyes_ipsi = [Decomp_Results_day.(field_id).(label).m1_distance_to_eyes_ipsi Decomp_Results_run.(field_id).(run_id).(label).m1_distance_to_eyes_ipsi];
            Decomp_Results_day.(field_id).(label).m1_distance_to_eyes = [Decomp_Results_day.(field_id).(label).m1_distance_to_eyes Decomp_Results_run.(field_id).(run_id).(label).m1_distance_to_eyes];
            
            clear label
            
        end
        
        clear m run_id
    
    end
    
    clear l field_id field_run 
    
end

save('Decomp_Results_Day_Combined_.mat','Decomp_Results_day','-v7.3') 




