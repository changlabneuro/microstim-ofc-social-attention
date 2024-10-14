%% Put information together for each trial (four categories: sham_sham, sham_stim, stim_sham, and stim_stim; plus two general categories: current_sham and current_stim)

fieldname=fieldnames(DotMatrices);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    field_run=fieldnames(DotMatrices.(field_id));
    
    for l=1:size(field_run,1)
        run_id=char(field_run(l));
        field_stim=fieldnames(DotMatrices.(field_id).(run_id));
        
        DotResults.(field_id).(run_id).roi_m1_eyes=DotMatrices.(field_id).(run_id).roi_m1_eyes;
        DotResults.(field_id).(run_id).roi_m2_eyes=DotMatrices.(field_id).(run_id).roi_m2_eyes;
        DotResults.(field_id).(run_id).roi_m1_mouth=DotMatrices.(field_id).(run_id).roi_m1_mouth;
        DotResults.(field_id).(run_id).roi_m2_mouth=DotMatrices.(field_id).(run_id).roi_m2_mouth;
        DotResults.(field_id).(run_id).roi_m1_face=DotMatrices.(field_id).(run_id).roi_m1_face;
        DotResults.(field_id).(run_id).roi_m2_face=DotMatrices.(field_id).(run_id).roi_m2_face;
        
        DotResults.(field_id).(run_id).center_roi_m1_eyes=DotMatrices.(field_id).(run_id).center_roi_m1_eyes;
        DotResults.(field_id).(run_id).center_roi_m2_eyes=DotMatrices.(field_id).(run_id).center_roi_m2_eyes;
        DotResults.(field_id).(run_id).center_roi_m1_mouth=DotMatrices.(field_id).(run_id).center_roi_m1_mouth;
        DotResults.(field_id).(run_id).center_roi_m2_mouth=DotMatrices.(field_id).(run_id).center_roi_m2_mouth;
        DotResults.(field_id).(run_id).center_roi_m1_face=DotMatrices.(field_id).(run_id).center_roi_m1_face;
        DotResults.(field_id).(run_id).center_roi_m2_face=DotMatrices.(field_id).(run_id).center_roi_m2_face;
        
        stim_label={char('sham_sham') char('sham_stim') char('stim_sham') char('stim_stim') char('current_sham') char('current_stim')};
        
        % n_not_stim is the number of other variables that are not stim
        
        n_not_stim = 14;
        
        for i=1:6
                  
            nstim=fieldnames(DotMatrices.(field_id).(run_id));
            stim_id=char(nstim(n_not_stim+1));
            variables_list=fieldnames(DotMatrices.(field_id).(run_id).(stim_id));

            for nvar=1:length(variables_list)

                varname=char(variables_list(nvar));        
                DotResults.(field_id).(run_id).(stim_label{i}).(varname)=[];
            end

        end     
        
        for nstim=2:length(field_stim)-n_not_stim 
            stim_id=char(field_stim(nstim+n_not_stim));

            if isequal(DotMatrices.(field_id).(run_id).current_label(nstim,:),'sham') && isequal(DotMatrices.(field_id).(run_id).current_label(nstim-1,:),'sham')                    
                label_list={stim_label{1} stim_label{5}};   
            elseif isequal(DotMatrices.(field_id).(run_id).current_label(nstim,:),'stim') && isequal(DotMatrices.(field_id).(run_id).current_label(nstim-1,:),'sham')     
                label_list={stim_label{2} stim_label{6}};                
            elseif isequal(DotMatrices.(field_id).(run_id).current_label(nstim,:),'sham') && isequal(DotMatrices.(field_id).(run_id).current_label(nstim-1,:),'stim')      
                label_list={stim_label{3} stim_label{5}};            
            elseif isequal(DotMatrices.(field_id).(run_id).current_label(nstim,:),'stim') && isequal(DotMatrices.(field_id).(run_id).current_label(nstim-1,:),'stim')   
                label_list={stim_label{4} stim_label{6}};
            end

            for label_id=1:numel(label_list)
            
                label=label_list{1,label_id};

                variable_list_number={'fixation_m1_eye_number','fixation_m1_eye_ipsi_number','fixation_m1_eye_contra_number',...
                    'fixation_m1_mouth_number','fixation_m1_mouth_ipsi_number', 'fixation_m1_mouth_contra_number',...
                    'fixation_m1_nenmface_number','fixation_m1_nenmface_ipsi_number','fixation_m1_nenmface_contra_number',...
                    'fixation_m1_everywhere_number','fixation_m1_everywhere_ipsi_number','fixation_m1_everywhere_contra_number',...
                    'fixation_m1_neface_number','fixation_m1_neface_ipsi_number','fixation_m1_neface_contra_number',...
                    'fixation_m1_wholeface_number','fixation_m1_wholeface_ipsi_number','fixation_m1_wholeface_contra_number',...
                    'fixation_m1_all_number','fixation_m1_all_ipsi_number','fixation_m1_all_contra_number',...
                    'fixation_m1_eye_number_NaN','fixation_m1_eye_ipsi_number_NaN','fixation_m1_eye_contra_number_NaN',...
                    'fixation_m1_mouth_number_NaN','fixation_m1_mouth_ipsi_number_NaN', 'fixation_m1_mouth_contra_number_NaN',...
                    'fixation_m1_nenmface_number_NaN','fixation_m1_nenmface_ipsi_number_NaN','fixation_m1_nenmface_contra_number_NaN',...
                    'fixation_m1_everywhere_number_NaN','fixation_m1_everywhere_ipsi_number_NaN','fixation_m1_everywhere_contra_number_NaN',...
                    'fixation_m1_neface_number_NaN','fixation_m1_neface_ipsi_number_NaN','fixation_m1_neface_contra_number_NaN',...
                    'fixation_m1_wholeface_number_NaN','fixation_m1_wholeface_ipsi_number_NaN','fixation_m1_wholeface_contra_number_NaN',...
                    'fixation_m1_all_number_NaN','fixation_m1_all_ipsi_number_NaN','fixation_m1_all_contra_number_NaN'};
               
                for n=1:length(variable_list_number)
                    variable_name=variable_list_number{1,n};
                    DotResults.(field_id).(run_id).(label).(variable_name)=[DotResults.(field_id).(run_id).(label).(variable_name) DotMatrices.(field_id).(run_id).(stim_id).(variable_name)];
                    clear variable_name
                end
                clear n
                
                variable_list_duration={'fixation_m1_eye_duration','fixation_m1_eye_ipsi_duration','fixation_m1_eye_contra_duration',...
                    'fixation_m1_mouth_duration','fixation_m1_mouth_ipsi_duration', 'fixation_m1_mouth_contra_duration',...
                    'fixation_m1_nenmface_duration','fixation_m1_nenmface_ipsi_duration','fixation_m1_nenmface_contra_duration',...
                    'fixation_m1_everywhere_duration','fixation_m1_everywhere_ipsi_duration','fixation_m1_everywhere_contra_duration',...
                    'fixation_m1_neface_duration','fixation_m1_neface_ipsi_duration','fixation_m1_neface_contra_duration',...
                    'fixation_m1_wholeface_duration','fixation_m1_wholeface_ipsi_duration','fixation_m1_wholeface_contra_duration',...
                    'fixation_m1_all_duration','fixation_m1_all_ipsi_duration','fixation_m1_all_contra_duration'};
                
                for m=1:length(variable_list_duration)
                    variable_name=variable_list_duration{1,m};
                    DotResults.(field_id).(run_id).(label).(variable_name)=[ DotResults.(field_id).(run_id).(label).(variable_name) mean(DotMatrices.(field_id).(run_id).(stim_id).(variable_name))];                    
                    clear variable_name
                end
                clear  m

                variable_list_duration_NaN={'fixation_m1_eye_duration_NaN','fixation_m1_eye_ipsi_duration_NaN','fixation_m1_eye_contra_duration_NaN',...
                    'fixation_m1_mouth_duration_NaN','fixation_m1_mouth_ipsi_duration_NaN', 'fixation_m1_mouth_contra_duration_NaN',...
                    'fixation_m1_nenmface_duration_NaN','fixation_m1_nenmface_ipsi_duration_NaN','fixation_m1_nenmface_contra_duration_NaN',...
                    'fixation_m1_everywhere_duration_NaN','fixation_m1_everywhere_ipsi_duration_NaN','fixation_m1_everywhere_contra_duration_NaN',...
                    'fixation_m1_neface_duration_NaN','fixation_m1_neface_ipsi_duration_NaN','fixation_m1_neface_contra_duration_NaN',...
                    'fixation_m1_wholeface_duration_NaN','fixation_m1_wholeface_ipsi_duration_NaN','fixation_m1_wholeface_contra_duration_NaN',...
                    'fixation_m1_all_duration_NaN','fixation_m1_all_ipsi_duration_NaN','fixation_m1_all_contra_duration_NaN'};
                
                for p=1:length(variable_list_duration_NaN)
                    variable_name=variable_list_duration_NaN{1,p};
                    DotResults.(field_id).(run_id).(label).(variable_name)=[ DotResults.(field_id).(run_id).(label).(variable_name) mean(DotMatrices.(field_id).(run_id).(stim_id).(variable_name),'omitnan')];                    
                    clear variable_name
                end
                clear p

                variable_list_totalduration={'fixation_m1_eye_totalduration','fixation_m1_eye_ipsi_totalduration','fixation_m1_eye_contra_totalduration',...
                    'fixation_m1_mouth_totalduration','fixation_m1_mouth_ipsi_totalduration', 'fixation_m1_mouth_contra_totalduration',...
                    'fixation_m1_nenmface_totalduration','fixation_m1_nenmface_ipsi_totalduration','fixation_m1_nenmface_contra_totalduration',...
                    'fixation_m1_everywhere_totalduration','fixation_m1_everywhere_ipsi_totalduration','fixation_m1_everywhere_contra_totalduration',...
                    'fixation_m1_neface_totalduration','fixation_m1_neface_ipsi_totalduration','fixation_m1_neface_contra_totalduration',...
                    'fixation_m1_wholeface_totalduration','fixation_m1_wholeface_ipsi_totalduration','fixation_m1_wholeface_contra_totalduration',...
                    'fixation_m1_all_totalduration','fixation_m1_all_ipsi_totalduration','fixation_m1_all_contra_totalduration',...
                    'fixation_m1_eye_totalduration_NaN','fixation_m1_eye_ipsi_totalduration_NaN','fixation_m1_eye_contra_totalduration_NaN',...
                    'fixation_m1_mouth_totalduration_NaN','fixation_m1_mouth_ipsi_totalduration_NaN', 'fixation_m1_mouth_contra_totalduration_NaN',...
                    'fixation_m1_nenmface_totalduration_NaN','fixation_m1_nenmface_ipsi_totalduration_NaN','fixation_m1_nenmface_contra_totalduration_NaN',...
                    'fixation_m1_everywhere_totalduration_NaN','fixation_m1_everywhere_ipsi_totalduration_NaN','fixation_m1_everywhere_contra_totalduration_NaN',...
                    'fixation_m1_neface_totalduration_NaN','fixation_m1_neface_ipsi_totalduration_NaN','fixation_m1_neface_contra_totalduration_NaN',...
                    'fixation_m1_wholeface_totalduration_NaN','fixation_m1_wholeface_ipsi_totalduration_NaN','fixation_m1_wholeface_contra_totalduration_NaN',...
                    'fixation_m1_all_totalduration_NaN','fixation_m1_all_ipsi_totalduration_NaN','fixation_m1_all_contra_totalduration_NaN'};
                
                for q=1:length(variable_list_totalduration)
                    variable_name=variable_list_totalduration{1,q};
                    DotResults.(field_id).(run_id).(label).(variable_name)=[ DotResults.(field_id).(run_id).(label).(variable_name) DotMatrices.(field_id).(run_id).(stim_id).(variable_name)];                    
                    clear variable_name
                end
                clear q

                variable_list_pupil={'fixation_m1_eye_pupilsize','fixation_m1_eye_ipsi_pupilsize','fixation_m1_eye_contra_pupilsize',...
                    'fixation_m1_mouth_pupilsize','fixation_m1_mouth_ipsi_pupilsize', 'fixation_m1_mouth_contra_pupilsize',...
                    'fixation_m1_nenmface_pupilsize','fixation_m1_nenmface_ipsi_pupilsize','fixation_m1_nenmface_contra_pupilsize',...
                    'fixation_m1_everywhere_pupilsize','fixation_m1_everywhere_ipsi_pupilsize','fixation_m1_everywhere_contra_pupilsize',...
                    'fixation_m1_neface_pupilsize','fixation_m1_neface_ipsi_pupilsize','fixation_m1_neface_contra_pupilsize',...
                    'fixation_m1_wholeface_pupilsize','fixation_m1_wholeface_ipsi_pupilsize','fixation_m1_wholeface_contra_pupilsize',...
                    'fixation_m1_all_pupilsize','fixation_m1_all_ipsi_pupilsize','fixation_m1_all_contra_pupilsize'};
                
                for j=1:length(variable_list_pupil)
                    variable_name=variable_list_pupil{1,j};
                    DotResults.(field_id).(run_id).(label).(variable_name)=[ DotResults.(field_id).(run_id).(label).(variable_name) mean(DotMatrices.(field_id).(run_id).(stim_id).(variable_name),'omitnan')];                    
                    clear variable_name
                end
                clear j
               
                variable_list_distance={'m1_distance_to_eyes','m1_distance_to_mouth','m1_distance_to_face',...
                    'm1_distance_to_eyes_ipsi','m1_distance_to_mouth_ipsi','m1_distance_to_face_ipsi',...
                    'm1_distance_to_eyes_contra','m1_distance_to_mouth_contra','m1_distance_to_face_contra'};
                
                for r=1:length(variable_list_distance)
                    variable_name=variable_list_distance{1,r};
                    DotResults.(field_id).(run_id).(label).(variable_name)=[ DotResults.(field_id).(run_id).(label).(variable_name) mean(DotMatrices.(field_id).(run_id).(stim_id).(variable_name),'omitnan')];                    
                    clear  variable_name
                end
                clear r

                clear label

            end

            clear stim_id label_id

        end
            
        clear nstim run_id field_stim
        
    end

    clear l  field_id field_run

end
    
save('Dot_Basic_Behavior_Run_Combined.mat','DotResults','-v7.3')


%% Put information together for each day (Average number, average duration, total duration, pupil size, distance to eyes, distance to mouth, and distance to face)

fieldname=fieldnames(DotResults);

for k=1:size(fieldname,1)
    
    field_id=char(fieldname(k));
    field_run=fieldnames(DotResults.(field_id));
    stim_label={char('sham_sham') char('sham_stim') char('stim_sham') char('stim_stim') char('current_sham') char('current_stim')};       
        
    for i=1:6

        variables_list=fieldnames(DotResults.(field_id).run_1.(stim_label{i}));
       
        for nvar=1:length(variables_list)

            varname=char(variables_list(nvar));        
            Dot_Day.(field_id).(stim_label{i}).(varname)=[];

        end

        clear nvar variables_list

    end

    clear i
        
    for l=1:size(field_run,1)
    
        run_id=char(field_run(l));
    
        for m=1:6

            label=stim_label{m};
            variables_list=fieldnames(DotResults.(field_id).(run_id).(label));
       
            for nvar=1:length(variables_list)

                varname=char(variables_list(nvar));        
                Dot_Day.(field_id).(label).(varname)=[Dot_Day.(field_id).(label).(varname) DotResults.(field_id).(run_id).(label).(varname)]; 

            end

            clear nvar label variables_list
            
        end
        
        clear m run_id
    
    end
    
    clear l field_id field_run 

end

save('Dot_Basic_Behavior_Day_Combined.mat','Dot_Day','-v7.3')
