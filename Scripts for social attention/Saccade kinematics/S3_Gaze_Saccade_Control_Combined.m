%% Put information together for each trial (four categories: sham_sham, sham_stim, stim_sham, and stim_stim; plus two general categories: current_sham and current_stim)

fieldname=fieldnames(GazeSaccade);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    field_run=fieldnames(GazeSaccade.(field_id));
    
    for l=1:size(field_run,1)
        run_id=char(field_run(l));
        field_stim=fieldnames(GazeSaccade.(field_id).(run_id));
        
        SaccadeResults.(field_id).(run_id).roi_m1_eyes=GazeSaccade.(field_id).(run_id).roi_m1_eyes;
        SaccadeResults.(field_id).(run_id).roi_m2_eyes=GazeSaccade.(field_id).(run_id).roi_m2_eyes;
        SaccadeResults.(field_id).(run_id).roi_m1_mouth=GazeSaccade.(field_id).(run_id).roi_m1_mouth;
        SaccadeResults.(field_id).(run_id).roi_m2_mouth=GazeSaccade.(field_id).(run_id).roi_m2_mouth;
        SaccadeResults.(field_id).(run_id).roi_m1_face=GazeSaccade.(field_id).(run_id).roi_m1_face;
        SaccadeResults.(field_id).(run_id).roi_m2_face=GazeSaccade.(field_id).(run_id).roi_m2_face;
        
        SaccadeResults.(field_id).(run_id).center_roi_m1_eyes=GazeSaccade.(field_id).(run_id).center_roi_m1_eyes;
        SaccadeResults.(field_id).(run_id).center_roi_m2_eyes=GazeSaccade.(field_id).(run_id).center_roi_m2_eyes;
        SaccadeResults.(field_id).(run_id).center_roi_m1_mouth=GazeSaccade.(field_id).(run_id).center_roi_m1_mouth;
        SaccadeResults.(field_id).(run_id).center_roi_m2_mouth=GazeSaccade.(field_id).(run_id).center_roi_m2_mouth;
        SaccadeResults.(field_id).(run_id).center_roi_m1_face=GazeSaccade.(field_id).(run_id).center_roi_m1_face;
        SaccadeResults.(field_id).(run_id).center_roi_m2_face=GazeSaccade.(field_id).(run_id).center_roi_m2_face;
        
        stim_label={char('sham_sham') char('sham_stim') char('stim_sham') char('stim_stim') char('current_sham') char('current_stim')};
        
        % n_not_stim is the number of other variables that are not stim
        
        n_not_stim = 16;
        
        for i=1:6
                  
            nstim=fieldnames(GazeSaccade.(field_id).(run_id));
            stim_id=char(nstim(n_not_stim+1));
            variables_list=fieldnames(GazeSaccade.(field_id).(run_id).(stim_id));

            for nvar=1:length(variables_list)

                varname=char(variables_list(nvar));        
                SaccadeResults.(field_id).(run_id).(stim_label{i}).(varname)=[];
            end

        end     
        
        for nstim=2:length(field_stim)-n_not_stim 
            stim_id=char(field_stim(nstim+n_not_stim));

            if isequal(GazeSaccade.(field_id).(run_id).current_label(nstim,:),'sham') && isequal(GazeSaccade.(field_id).(run_id).current_label(nstim-1,:),'sham')                    
                label_list={stim_label{1} stim_label{5}};   
            elseif isequal(GazeSaccade.(field_id).(run_id).current_label(nstim,:),'stim') && isequal(GazeSaccade.(field_id).(run_id).current_label(nstim-1,:),'sham')     
                label_list={stim_label{2} stim_label{6}};                
            elseif isequal(GazeSaccade.(field_id).(run_id).current_label(nstim,:),'sham') && isequal(GazeSaccade.(field_id).(run_id).current_label(nstim-1,:),'stim')      
                label_list={stim_label{3} stim_label{5}};            
            elseif isequal(GazeSaccade.(field_id).(run_id).current_label(nstim,:),'stim') && isequal(GazeSaccade.(field_id).(run_id).current_label(nstim-1,:),'stim')   
                label_list={stim_label{4} stim_label{6}};
            end

            for label_id=1:numel(label_list)
            
                label=label_list{1,label_id};

                variable_list_number=fieldnames(GazeSaccade.(field_id).(run_id).(stim_id));
               
                for n=1:length(variable_list_number)
                    variable_name=variable_list_number{n,1};
                    SaccadeResults.(field_id).(run_id).(label).(variable_name)=[SaccadeResults.(field_id).(run_id).(label).(variable_name) GazeSaccade.(field_id).(run_id).(stim_id).(variable_name)];
                    clear variable_name
                end
                
                clear n label variable_list_number
                
            end

            clear stim_id label_id

        end
            
        clear nstim run_id field_stim
        
    end

    clear l  field_id field_run

end
    
save('Saccade_Run_Combined.mat','SaccadeResults','-v7.3')


%% Put information together for each day (Average number, average duration, total duration, pupil size, distance to eyes, distance to mouth, and distance to face)

fieldname=fieldnames(SaccadeResults);

for k=1:size(fieldname,1)
    
    field_id=char(fieldname(k));
    field_run=fieldnames(SaccadeResults.(field_id));
    stim_label={char('sham_sham') char('sham_stim') char('stim_sham') char('stim_stim') char('current_sham') char('current_stim')};       
        
    for i=1:6

        variables_list=fieldnames(SaccadeResults.(field_id).run_1.(stim_label{i}));
       
        for nvar=1:length(variables_list)

            varname=char(variables_list(nvar));        
            Saccade_Day.(field_id).(stim_label{i}).(varname)=[];

        end

        clear nvar variables_list

    end

    clear i
        
    for l=1:size(field_run,1)
    
        run_id=char(field_run(l));
    
        for m=1:6

            label=stim_label{m};
            variables_list=fieldnames(SaccadeResults.(field_id).(run_id).(label));
       
            for nvar=1:length(variables_list)

                varname=char(variables_list(nvar));        
                Saccade_Day.(field_id).(label).(varname)=[Saccade_Day.(field_id).(label).(varname) SaccadeResults.(field_id).(run_id).(label).(varname)]; 

            end

            clear nvar label variables_list
            
        end
        
        clear m run_id
    
    end
    
    clear l field_id field_run 

end

save('Saccade_Day_Combined.mat','Saccade_Day','-v7.3')