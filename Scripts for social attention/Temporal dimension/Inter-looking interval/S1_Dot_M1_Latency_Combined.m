%% Load Dot_Data_Combined.mat 

% Get m1 events

fieldname=fieldnames(DotData);
time_window=5; %sec

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
    field_run=fieldnames(DotData.(field_id));
    
    for l=1:size(field_run,1)
        run_id=char(field_run(l));

        m1_behavior.(field_id).(run_id).stim_ts=[];
        m1_behavior.(field_id).(run_id).all_stim_labels=[];

        % column 7 is m1 start index; column 8 is m1 end index
        % column 9 is m2 start index; column 10 is m2 end index
        % column 11 is m1 start time; column 12 is m1 end time
        % column 13 is m2 start time; column 14 is m2 end time

        [sorted_start_time_eyes,sorted_order_eyes]=sort(DotData.(field_id).(run_id).m1_eye.Var1(:,7));
        [sorted_start_time_mouth,sorted_order_mouth]=sort(DotData.(field_id).(run_id).m1_mouth.Var1(:,7));
        [sorted_start_time_wholeface,sorted_order_wholeface]=sort(DotData.(field_id).(run_id).m1_wholeface.Var1(:,7));
   
        for nstim=1:length(DotData.(field_id).(run_id).stim_ts)        
            stim_id=char(strcat('stim_',num2str(nstim)));
        
            if DotData.(field_id).(run_id).stim_ts(nstim) >= min(DotData.(field_id).(run_id).t) && DotData.(field_id).(run_id).stim_ts(nstim) < max(DotData.(field_id).(run_id).t)-5
                
                m1_behavior.(field_id).(run_id).stim_ts=[m1_behavior.(field_id).(run_id).stim_ts DotData.(field_id).(run_id).stim_ts(nstim)];
                m1_behavior.(field_id).(run_id).all_stim_labels=[m1_behavior.(field_id).(run_id).all_stim_labels DotData.(field_id).(run_id).all_stim_labels(nstim)];

                stim_idx_start=find(DotData.(field_id).(run_id).t<=DotData.(field_id).(run_id).stim_ts(nstim),1,'last');
                stim_idx_end=stim_idx_start+time_window*1000-1;

                m1_first_looking_eyes=sorted_start_time_eyes(find(sorted_start_time_eyes>stim_idx_start,1,'first'));
                if m1_first_looking_eyes<stim_idx_end
                    m1_behavior.(field_id).(run_id).(stim_id).m1_latency_eyes=m1_first_looking_eyes-stim_idx_start;
                else
                    m1_behavior.(field_id).(run_id).(stim_id).m1_latency_eyes=NaN;
                end

                m1_first_looking_mouth=sorted_start_time_mouth(find(sorted_start_time_mouth>stim_idx_start,1,'first'));
                if m1_first_looking_mouth<stim_idx_end
                    m1_behavior.(field_id).(run_id).(stim_id).m1_latency_mouth=m1_first_looking_mouth-stim_idx_start;
                else
                    m1_behavior.(field_id).(run_id).(stim_id).m1_latency_mouth=NaN;
                end

                m1_first_looking_face=sorted_start_time_wholeface(find(sorted_start_time_wholeface>stim_idx_start,1,'first'));
                if m1_first_looking_face<stim_idx_end
                    m1_behavior.(field_id).(run_id).(stim_id).m1_latency_face=m1_first_looking_face-stim_idx_start;
                else
                    m1_behavior.(field_id).(run_id).(stim_id).m1_latency_face=NaN;
                end

            end

            clear stim_id stim_idx_start stim_idx_end m1_first_looking_eyes m1_first_looking_mouth m1_first_looking_face

        end

        clear nstim sorted_start_time_eyes sorted_order_eyes sorted_start_time_mouth sorted_order_mouth sorted_start_time_wholeface sorted_order_wholeface run_id

    end

    clear l field_id field_run

end

save('M1_Behavior_Combined.mat','m1_behavior','-v7.3')

%% Put information together for each trial (four categories: sham_sham, sham_stim, stim_sham, and stim_stim; plus two general categories: current_sham and current_stim)

fieldname=fieldnames(m1_behavior);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    field_run=fieldnames(m1_behavior.(field_id));
    
    for l=1:size(field_run,1)
        run_id=char(field_run(l));
        field_stim=fieldnames(m1_behavior.(field_id).(run_id));
        
        m1_behavior_run.(field_id).(run_id).stim_time=m1_behavior.(field_id).(run_id).stim_ts;
        m1_behavior_run.(field_id).(run_id).current_label=m1_behavior.(field_id).(run_id).all_stim_labels;
        
        stim_label={char('sham_sham') char('sham_stim') char('stim_sham') char('stim_stim') char('current_sham') char('current_stim')};
        
        % n_not_stim is the number of other variables that are not stim
        n_not_stim = 2;
        
        for i=1:6

            m1_behavior_run.(field_id).(run_id).(stim_label{i}).m1_latency_eyes=[];
            m1_behavior_run.(field_id).(run_id).(stim_label{i}).m1_latency_mouth=[];
            m1_behavior_run.(field_id).(run_id).(stim_label{i}).m1_latency_face=[];
           
        end     
        
        % remove the first trial of a run

        for nstim=2:length(field_stim)-n_not_stim 
            stim_id=char(field_stim(nstim+n_not_stim));

            if isequal(m1_behavior_run.(field_id).(run_id).current_label{1,nstim},'sham') && isequal(m1_behavior_run.(field_id).(run_id).current_label{1,nstim-1},'sham')                    
                label_list={stim_label{1} stim_label{5}};   
            elseif isequal(m1_behavior_run.(field_id).(run_id).current_label{1,nstim},'stim') && isequal(m1_behavior_run.(field_id).(run_id).current_label{1,nstim-1},'sham')     
                label_list={stim_label{2} stim_label{6}};                
            elseif isequal(m1_behavior_run.(field_id).(run_id).current_label{1,nstim},'sham') && isequal(m1_behavior_run.(field_id).(run_id).current_label{1,nstim-1},'stim')      
                label_list={stim_label{3} stim_label{5}};            
            elseif isequal(m1_behavior_run.(field_id).(run_id).current_label{1,nstim},'stim') && isequal(m1_behavior_run.(field_id).(run_id).current_label{1,nstim-1},'stim')   
                label_list={stim_label{4} stim_label{6}};
            end


            for label_id=1:numel(label_list)
            
                label=label_list{1,label_id};

                m1_behavior_run.(field_id).(run_id).(label).m1_latency_eyes=[m1_behavior_run.(field_id).(run_id).(label).m1_latency_eyes m1_behavior.(field_id).(run_id).(stim_id).m1_latency_eyes];
                m1_behavior_run.(field_id).(run_id).(label).m1_latency_mouth=[m1_behavior_run.(field_id).(run_id).(label).m1_latency_mouth m1_behavior.(field_id).(run_id).(stim_id).m1_latency_mouth];
                m1_behavior_run.(field_id).(run_id).(label).m1_latency_face=[m1_behavior_run.(field_id).(run_id).(label).m1_latency_face m1_behavior.(field_id).(run_id).(stim_id).m1_latency_face];
                
                clear label 
            
            end

            clear label_id stim_id
     
        end

        clear nstim run_id field_stim

    end

    clear l field_id field_run

end

save('M1_Behavior_Run_Combined.mat','m1_behavior_run','-v7.3')

%% Put information together for each day (m1 latency for eyes, mouth, and whole face)

fieldname=fieldnames(m1_behavior_run);

for k=1:size(fieldname,1)
    
    field_id=char(fieldname(k));
    field_run=fieldnames(m1_behavior_run.(field_id));
    stim_label={char('sham_sham') char('sham_stim') char('stim_sham') char('stim_stim') char('current_sham') char('current_stim')};       

    for i=1:6

        m1_behavior_day.(field_id).(stim_label{i}).m1_latency_eyes=[];
        m1_behavior_day.(field_id).(stim_label{i}).m1_latency_mouth=[];
        m1_behavior_day.(field_id).(stim_label{i}).m1_latency_face=[];
                
    end

    clear i
        
    for l=1:size(field_run,1)
    
        run_id=char(field_run(l));
      
        for m=1:6

            label=stim_label{m};
            m1_behavior_day.(field_id).(label).m1_latency_eyes=[m1_behavior_day.(field_id).(label).m1_latency_eyes m1_behavior_run.(field_id).(run_id).(label).m1_latency_eyes]; 
            m1_behavior_day.(field_id).(label).m1_latency_mouth=[m1_behavior_day.(field_id).(label).m1_latency_mouth m1_behavior_run.(field_id).(run_id).(label).m1_latency_mouth]; 
            m1_behavior_day.(field_id).(label).m1_latency_face=[m1_behavior_day.(field_id).(label).m1_latency_face m1_behavior_run.(field_id).(run_id).(label).m1_latency_face]; 
          
        end

        clear label m run_id
    
    end
    
    clear l field_id field_run 

end


save('M1_Behavior_Day_Combined.mat','m1_behavior_day','-v7.3')
