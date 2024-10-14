%% Load Gaze_Data_Combined.mat 

% Combine m1 whole face events and m2 whole face events and sort based on
% start time

fieldname=fieldnames(GazeData);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
    field_run=fieldnames(GazeData.(field_id));
    
    for l=1:size(field_run,1)
        run_id=char(field_run(l));
        sorted_events.whole_face.(field_id).(run_id).stim_ts=GazeData.(field_id).(run_id).stim_ts;
        sorted_events.whole_face.(field_id).(run_id).all_stim_labels=GazeData.(field_id).(run_id).all_stim_labels;
        sorted_events.whole_face.(field_id).(run_id).t=GazeData.(field_id).(run_id).t;
        
        sorted_events.all_face.(field_id).(run_id).stim_ts=GazeData.(field_id).(run_id).stim_ts;
        sorted_events.all_face.(field_id).(run_id).all_stim_labels=GazeData.(field_id).(run_id).all_stim_labels;
        sorted_events.all_face.(field_id).(run_id).t=GazeData.(field_id).(run_id).t;
       
        % column 7 is m1 start index; column 8 is m1 end index
        % column 9 is m2 start index; column 10 is m2 end index
        % column 11 is m1 start time; column 12 is m1 end time
        % column 13 is m2 start time; column 14 is m2 end time

        % combine m1 whole face and m2 whole face
        m1_start_time.whole_face=GazeData.(field_id).(run_id).m1_wholeface.Var1(:,7);
        m1_end_time.whole_face=GazeData.(field_id).(run_id).m1_wholeface.Var1(:,8);   
        m1_labels.whole_face=repmat({'m1'},size(m1_start_time.whole_face,1),1);
  
        m2_start_time.whole_face=GazeData.(field_id).(run_id).m2_wholeface.Var1(:,9);
        m2_end_time.whole_face=GazeData.(field_id).(run_id).m2_wholeface.Var1(:,10);
        m2_labels.whole_face=repmat({'m2'},size(m2_start_time.whole_face,1),1);

        start_time.whole_face=[m1_start_time.whole_face ; m2_start_time.whole_face];
        end_time.whole_face=[m1_end_time.whole_face ; m2_end_time.whole_face];
        event_labels.whole_face=[m1_labels.whole_face ; m2_labels.whole_face];

        [sorted_start_time.whole_face,sorted_order.whole_face]=sort(start_time.whole_face);
        sorted_end_time.whole_face=end_time.whole_face(sorted_order.whole_face);
        sorted_event_labels.whole_face=event_labels.whole_face(sorted_order.whole_face);

        sorted_events.whole_face.(field_id).(run_id).events(:,1)=sorted_start_time.whole_face;
        sorted_events.whole_face.(field_id).(run_id).events(:,2)=sorted_end_time.whole_face;
        sorted_events.whole_face.(field_id).(run_id).event_labels=sorted_event_labels.whole_face;

        % combine m1 whole face and m2 whole face and mutual whole face
        m1_start_time.all_face=vertcat(GazeData.(field_id).(run_id).m1_wholeface.Var1(:,7), GazeData.(field_id).(run_id).mutual_wholeface.Var1(:,7));
        m1_end_time.all_face=vertcat(GazeData.(field_id).(run_id).m1_wholeface.Var1(:,8), GazeData.(field_id).(run_id).mutual_wholeface.Var1(:,8));   
        m1_labels.all_face=repmat({'m1'},size(m1_start_time.all_face,1),1);
  
        m2_start_time.all_face=vertcat(GazeData.(field_id).(run_id).m2_wholeface.Var1(:,9), GazeData.(field_id).(run_id).mutual_wholeface.Var1(:,9));
        m2_end_time.all_face=vertcat(GazeData.(field_id).(run_id).m2_wholeface.Var1(:,10), GazeData.(field_id).(run_id).mutual_wholeface.Var1(:,10));   
        m2_labels.all_face=repmat({'m2'},size(m2_start_time.all_face,1),1);
 
        start_time.all_face=[m1_start_time.all_face ; m2_start_time.all_face];
        end_time.all_face=[m1_end_time.all_face ; m2_end_time.all_face];
        event_labels.all_face=[m1_labels.all_face ; m2_labels.all_face];

        [sorted_start_time.all_face,sorted_order.all_face]=sort(start_time.all_face);
        sorted_end_time.all_face=end_time.all_face(sorted_order.all_face);
        sorted_event_labels.all_face=event_labels.all_face(sorted_order.all_face);

        sorted_events.all_face.(field_id).(run_id).events(:,1)=sorted_start_time.all_face;
        sorted_events.all_face.(field_id).(run_id).events(:,2)=sorted_end_time.all_face;
        sorted_events.all_face.(field_id).(run_id).event_labels=sorted_event_labels.all_face;

        clear run_id 
        clear m1_start_time m1_end_time m1_labels m2_start_time m2_end_time m2_labels
        clear start_time end_time event_labels sorted_start_time sorted_order sorted_end_time sorted_event_labels

    end

    clear l field_id field_run

end

save('Sorted_Events_Combined.mat','sorted_events','-v7.3')

%% Select the sequences of m1 and m2 whole face events within 5 sec after stim/sham

fieldname=fieldnames(sorted_events.whole_face);
time_window=5; %sec

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
    field_run=fieldnames(sorted_events.whole_face.(field_id));
    
    for l=1:size(field_run,1)
        run_id=char(field_run(l));
        
        iti_events.whole_face.(field_id).(run_id).stim_time=[];  
        iti_events.whole_face.(field_id).(run_id).current_label=[];

        iti_events.all_face.(field_id).(run_id).stim_time=[];
        iti_events.all_face.(field_id).(run_id).current_label=[];
       
        for nstim=1:length(sorted_events.whole_face.(field_id).(run_id).stim_ts)        
            stim_id=char(strcat('stim_',num2str(nstim)));
        
            if sorted_events.whole_face.(field_id).(run_id).stim_ts(nstim) >= min(sorted_events.whole_face.(field_id).(run_id).t) && sorted_events.whole_face.(field_id).(run_id).stim_ts(nstim) < max(sorted_events.whole_face.(field_id).(run_id).t)-5
                  
            iti_events.whole_face.(field_id).(run_id).stim_time=[iti_events.whole_face.(field_id).(run_id).stim_time sorted_events.whole_face.(field_id).(run_id).stim_ts(nstim)];           
            iti_events.whole_face.(field_id).(run_id).current_label=[iti_events.whole_face.(field_id).(run_id).current_label sorted_events.whole_face.(field_id).(run_id).all_stim_labels(nstim)];
            
            iti_events.all_face.(field_id).(run_id).stim_time=[iti_events.all_face.(field_id).(run_id).stim_time sorted_events.all_face.(field_id).(run_id).stim_ts(nstim)];
            iti_events.all_face.(field_id).(run_id).current_label=[iti_events.all_face.(field_id).(run_id).current_label sorted_events.all_face.(field_id).(run_id).all_stim_labels(nstim)];

            stim_idx_start=find(sorted_events.whole_face.(field_id).(run_id).t<=sorted_events.whole_face.(field_id).(run_id).stim_ts(nstim),1,'last');
            stim_idx_end=stim_idx_start+time_window*1000-1;

            event_idx_whole_face=sorted_events.whole_face.(field_id).(run_id).events(:,1)>=stim_idx_start & sorted_events.whole_face.(field_id).(run_id).events(:,1)<stim_idx_end;
            event_idx_all_face=sorted_events.all_face.(field_id).(run_id).events(:,1)>=stim_idx_start & sorted_events.all_face.(field_id).(run_id).events(:,1)<stim_idx_end;
            
            iti_events.whole_face.(field_id).(run_id).(stim_id).events=sorted_events.whole_face.(field_id).(run_id).events(event_idx_whole_face,:);
            iti_events.whole_face.(field_id).(run_id).(stim_id).event_labels=sorted_events.whole_face.(field_id).(run_id).event_labels(event_idx_whole_face,1);
            
            iti_events.all_face.(field_id).(run_id).(stim_id).events=sorted_events.all_face.(field_id).(run_id).events(event_idx_all_face,:);
            iti_events.all_face.(field_id).(run_id).(stim_id).event_labels=sorted_events.all_face.(field_id).(run_id).event_labels(event_idx_all_face,1);
            
            clear stim_idx_start stim_idx_end event_idx_whole_face event_idx_all_face

            end

            clear stim_id
            
        end

        clear nstim run_id

    end

    clear l field_id field_run

end

save('ITI_Events_Combined.mat','iti_events','-v7.3')

%% Find m2 event(s) after stim/sham and look at iti till the next m1 looking (duration, frequency, and iti)

fieldname=fieldnames(iti_events.whole_face);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));    
    field_run=fieldnames(iti_events.whole_face.(field_id));
    
    for l=1:size(field_run,1)
  
        run_id=char(field_run(l));
        iti.whole_face.(field_id).(run_id).stim_time=[];
        iti.whole_face.(field_id).(run_id).current_label=[];

        iti.all_face.(field_id).(run_id).stim_time=[];
        iti.all_face.(field_id).(run_id).current_label=[];
       
        field_stim=fieldnames(iti_events.whole_face.(field_id).(run_id));
        n_not_stim=2;
        
        % include all trials
        for nstim = 1:length(field_stim)-n_not_stim
            stim_id=char(field_stim(nstim+n_not_stim));
            iti.whole_face.(field_id).(run_id).stim_time=[iti.whole_face.(field_id).(run_id).stim_time iti_events.whole_face.(field_id).(run_id).stim_time(nstim)];
            iti.whole_face.(field_id).(run_id).current_label=[iti.whole_face.(field_id).(run_id).current_label iti_events.whole_face.(field_id).(run_id).current_label(nstim)];
            
            iti.all_face.(field_id).(run_id).stim_time=[iti.all_face.(field_id).(run_id).stim_time iti_events.all_face.(field_id).(run_id).stim_time(nstim)];
            iti.all_face.(field_id).(run_id).current_label=[iti.all_face.(field_id).(run_id).current_label iti_events.all_face.(field_id).(run_id).current_label(nstim)];
           
            iti.whole_face.(field_id).(run_id).(stim_id).duration=[];
            iti.whole_face.(field_id).(run_id).(stim_id).iti=[];
            iti.whole_face.(field_id).(run_id).(stim_id).frequency=[];

            iti.all_face.(field_id).(run_id).(stim_id).duration=[];
            iti.all_face.(field_id).(run_id).(stim_id).iti=[];
            iti.all_face.(field_id).(run_id).(stim_id).frequency=[];
                       
            % Whole Face

            contains_m2_whole_face=contains(iti_events.whole_face.(field_id).(run_id).(stim_id).event_labels,'m2');
            contains_m1_whole_face=contains(iti_events.whole_face.(field_id).(run_id).(stim_id).event_labels,'m1');

            % if there is no m2 events, set things to NaN
            if sum(contains_m2_whole_face)==0

                iti.whole_face.(field_id).(run_id).(stim_id).duration=NaN;
                iti.whole_face.(field_id).(run_id).(stim_id).iti=NaN;
                iti.whole_face.(field_id).(run_id).(stim_id).frequency=NaN;
            
            % if there is at least one m2 event
            else

                % check if there is m1 events, if not, set things to NaN
                if sum(contains_m1_whole_face)==0

                    iti.whole_face.(field_id).(run_id).(stim_id).duration=NaN;
                    iti.whole_face.(field_id).(run_id).(stim_id).iti=NaN;
                    iti.whole_face.(field_id).(run_id).(stim_id).frequency=NaN;

                else

                    m2_idx_whole_face=find(contains_m2_whole_face==1);
                    [m2_start_idx_whole_face,m2_length_whole_face]=find_consecutive_bins(m2_idx_whole_face,0);  

                    for n_m2_whole_face=1:length(m2_start_idx_whole_face)

                        if m2_start_idx_whole_face(n_m2_whole_face)+m2_length_whole_face(n_m2_whole_face)<=length(contains_m2_whole_face)  
                            iti.whole_face.(field_id).(run_id).(stim_id).frequency=[iti.whole_face.(field_id).(run_id).(stim_id).frequency m2_length_whole_face(n_m2_whole_face)];
                            if iti_events.whole_face.(field_id).(run_id).(stim_id).events(m2_start_idx_whole_face(n_m2_whole_face)+m2_length_whole_face(n_m2_whole_face)-1,2)<=iti_events.whole_face.(field_id).(run_id).(stim_id).events(m2_start_idx_whole_face(n_m2_whole_face)+m2_length_whole_face(n_m2_whole_face),1)
                                iti.whole_face.(field_id).(run_id).(stim_id).duration=[iti.whole_face.(field_id).(run_id).(stim_id).duration...
                                sum(iti_events.whole_face.(field_id).(run_id).(stim_id).events(m2_start_idx_whole_face(n_m2_whole_face):m2_start_idx_whole_face(n_m2_whole_face)+m2_length_whole_face(n_m2_whole_face)-1,2)-iti_events.whole_face.(field_id).(run_id).(stim_id).events(m2_start_idx_whole_face(n_m2_whole_face):m2_start_idx_whole_face(n_m2_whole_face)+m2_length_whole_face(n_m2_whole_face)-1,1))];
                            else
                                iti.whole_face.(field_id).(run_id).(stim_id).duration=[iti.whole_face.(field_id).(run_id).(stim_id).duration...
                                sum(iti_events.whole_face.(field_id).(run_id).(stim_id).events(m2_start_idx_whole_face(n_m2_whole_face):m2_start_idx_whole_face(n_m2_whole_face)+m2_length_whole_face(n_m2_whole_face)-1,2)-iti_events.whole_face.(field_id).(run_id).(stim_id).events(m2_start_idx_whole_face(n_m2_whole_face):m2_start_idx_whole_face(n_m2_whole_face)+m2_length_whole_face(n_m2_whole_face)-1,1))...
                                +iti_events.whole_face.(field_id).(run_id).(stim_id).events(m2_start_idx_whole_face(n_m2_whole_face)+m2_length_whole_face(n_m2_whole_face),1)-iti_events.whole_face.(field_id).(run_id).(stim_id).events(m2_start_idx_whole_face(n_m2_whole_face)+m2_length_whole_face(n_m2_whole_face)-1,2)];
                            end
                                iti.whole_face.(field_id).(run_id).(stim_id).iti=[iti.whole_face.(field_id).(run_id).(stim_id).iti...
                                iti_events.whole_face.(field_id).(run_id).(stim_id).events(m2_start_idx_whole_face(n_m2_whole_face)+m2_length_whole_face(n_m2_whole_face),1)-iti_events.whole_face.(field_id).(run_id).(stim_id).events(m2_start_idx_whole_face(n_m2_whole_face),1)];
                        else
                           iti.whole_face.(field_id).(run_id).(stim_id).frequency=[iti.whole_face.(field_id).(run_id).(stim_id).frequency NaN];
                           iti.whole_face.(field_id).(run_id).(stim_id).duration=[iti.whole_face.(field_id).(run_id).(stim_id).duration NaN];
                           iti.whole_face.(field_id).(run_id).(stim_id).iti=[iti.whole_face.(field_id).(run_id).(stim_id).iti NaN];
                        end
            
                    end

                    clear n_m2_whole_face m2_idx_whole_face m2_start_idx_whole_face m2_length_whole_face

                end

            end

            clear contains_m2_whole_face contains_m1_whole_face 
            
            % All Face

            contains_m2_all_face=contains(iti_events.all_face.(field_id).(run_id).(stim_id).event_labels,'m2');
            contains_m1_all_face=contains(iti_events.all_face.(field_id).(run_id).(stim_id).event_labels,'m1');

            % if there is no m2 events, set things to NaN
            if sum(contains_m2_all_face)==0

                iti.all_face.(field_id).(run_id).(stim_id).duration=NaN;
                iti.all_face.(field_id).(run_id).(stim_id).iti=NaN;
                iti.all_face.(field_id).(run_id).(stim_id).frequency=NaN;
            
            % if there is at least one m2 event
            else

                % check if there is m1 events, if not, set things to NaN
                if sum(contains_m1_all_face)==0

                    iti.all_face.(field_id).(run_id).(stim_id).duration=NaN;
                    iti.all_face.(field_id).(run_id).(stim_id).iti=NaN;
                    iti.all_face.(field_id).(run_id).(stim_id).frequency=NaN;

                else

                    m2_idx_all_face=find(contains_m2_all_face==1);
                    [m2_start_idx_all_face,m2_length_all_face]=find_consecutive_bins(m2_idx_all_face,0);  

                    for n_m2_all_face=1:length(m2_start_idx_all_face)

                        if m2_start_idx_all_face(n_m2_all_face)+m2_length_all_face(n_m2_all_face)<=length(contains_m2_all_face)  
                            iti.all_face.(field_id).(run_id).(stim_id).frequency=[iti.all_face.(field_id).(run_id).(stim_id).frequency m2_length_all_face(n_m2_all_face)];
                            if iti_events.all_face.(field_id).(run_id).(stim_id).events(m2_start_idx_all_face(n_m2_all_face)+m2_length_all_face(n_m2_all_face)-1,2)<=iti_events.all_face.(field_id).(run_id).(stim_id).events(m2_start_idx_all_face(n_m2_all_face)+m2_length_all_face(n_m2_all_face),1)
                                iti.all_face.(field_id).(run_id).(stim_id).duration=[iti.all_face.(field_id).(run_id).(stim_id).duration...
                                sum(iti_events.all_face.(field_id).(run_id).(stim_id).events(m2_start_idx_all_face(n_m2_all_face):m2_start_idx_all_face(n_m2_all_face)+m2_length_all_face(n_m2_all_face)-1,2)-iti_events.all_face.(field_id).(run_id).(stim_id).events(m2_start_idx_all_face(n_m2_all_face):m2_start_idx_all_face(n_m2_all_face)+m2_length_all_face(n_m2_all_face)-1,1))];
                            else
                                iti.all_face.(field_id).(run_id).(stim_id).duration=[iti.all_face.(field_id).(run_id).(stim_id).duration...
                                sum(iti_events.all_face.(field_id).(run_id).(stim_id).events(m2_start_idx_all_face(n_m2_all_face):m2_start_idx_all_face(n_m2_all_face)+m2_length_all_face(n_m2_all_face)-1,2)-iti_events.all_face.(field_id).(run_id).(stim_id).events(m2_start_idx_all_face(n_m2_all_face):m2_start_idx_all_face(n_m2_all_face)+m2_length_all_face(n_m2_all_face)-1,1))...
                                +iti_events.all_face.(field_id).(run_id).(stim_id).events(m2_start_idx_all_face(n_m2_all_face)+m2_length_all_face(n_m2_all_face),1)-iti_events.all_face.(field_id).(run_id).(stim_id).events(m2_start_idx_all_face(n_m2_all_face)+m2_length_all_face(n_m2_all_face)-1,2)];
                            end
                                iti.all_face.(field_id).(run_id).(stim_id).iti=[iti.all_face.(field_id).(run_id).(stim_id).iti...
                                iti_events.all_face.(field_id).(run_id).(stim_id).events(m2_start_idx_all_face(n_m2_all_face)+m2_length_all_face(n_m2_all_face),1)-iti_events.all_face.(field_id).(run_id).(stim_id).events(m2_start_idx_all_face(n_m2_all_face),1)];
                        else
                           iti.all_face.(field_id).(run_id).(stim_id).frequency=[iti.all_face.(field_id).(run_id).(stim_id).frequency NaN];
                           iti.all_face.(field_id).(run_id).(stim_id).duration=[iti.all_face.(field_id).(run_id).(stim_id).duration NaN];
                           iti.all_face.(field_id).(run_id).(stim_id).iti=[iti.all_face.(field_id).(run_id).(stim_id).iti NaN];
                        end
            
                    end

                    clear n_m2_all_face m2_idx_all_face m2_start_idx_all_face m2_length_all_face

                end

            end

            clear contains_m2_all_face contains_m1_all_face          
            clear stim_id

        end

        clear nstim run_id field_stim 

    end

    clear l field_id field_run

end

save('ITI_Trial_Combined.mat','iti','-v7.3')

%% Put information together for each trial (four categories: sham_sham, sham_stim, stim_sham, and stim_stim; plus two general categories: current_sham and current_stim)

ROI={'whole_face','all_face'};

for nROI=1:2
    ROI_id=char(ROI(nROI));
    fieldname=fieldnames(iti.(ROI_id));
    
    for k=1:size(fieldname,1)
        field_id=char(fieldname(k));
        field_run=fieldnames(iti.(ROI_id).(field_id));
        
        for l=1:size(field_run,1)
            run_id=char(field_run(l));
            field_stim=fieldnames(iti.(ROI_id).(field_id).(run_id));
            
            ITIResults.(ROI_id).(field_id).(run_id).stim_time=iti.(ROI_id).(field_id).(run_id).stim_time;
            ITIResults.(ROI_id).(field_id).(run_id).current_label=iti.(ROI_id).(field_id).(run_id).current_label;
            
            stim_label={char('sham_sham') char('sham_stim') char('stim_sham') char('stim_stim') char('current_sham') char('current_stim')};
            
            % n_not_stim is the number of other variables that are not stim
            n_not_stim = 2;
            
            for i=1:6
    
                ITIResults.(ROI_id).(field_id).(run_id).(stim_label{i}).average_duration=[];
                %ITIResults.(ROI_id).(field_id).(run_id).(stim_label{i}).total_duration=[];
                ITIResults.(ROI_id).(field_id).(run_id).(stim_label{i}).average_frequency=[];
                %ITIResults.(ROI_id).(field_id).(run_id).(stim_label{i}).total_frequency=[];
                ITIResults.(ROI_id).(field_id).(run_id).(stim_label{i}).average_iti=[];
                %ITIResults.(ROI_id).(field_id).(run_id).(stim_label{i}).total_iti=[];
    
            end     
            
            % remove the first trial of a run
    
            for nstim=2:length(field_stim)-n_not_stim 
                stim_id=char(field_stim(nstim+n_not_stim));
    
                if isequal(iti.(ROI_id).(field_id).(run_id).current_label{1,nstim},'sham') && isequal(iti.(ROI_id).(field_id).(run_id).current_label{1,nstim-1},'sham')                    
                    label_list={stim_label{1} stim_label{5}};   
                elseif isequal(iti.(ROI_id).(field_id).(run_id).current_label{1,nstim},'stim') && isequal(iti.(ROI_id).(field_id).(run_id).current_label{1,nstim-1},'sham')     
                    label_list={stim_label{2} stim_label{6}};                
                elseif isequal(iti.(ROI_id).(field_id).(run_id).current_label{1,nstim},'sham') && isequal(iti.(ROI_id).(field_id).(run_id).current_label{1,nstim-1},'stim')      
                    label_list={stim_label{3} stim_label{5}};            
                elseif isequal(iti.(ROI_id).(field_id).(run_id).current_label{1,nstim},'stim') && isequal(iti.(ROI_id).(field_id).(run_id).current_label{1,nstim-1},'stim')   
                    label_list={stim_label{4} stim_label{6}};
                end
    
                for label_id=1:numel(label_list)
                
                    label=label_list{1,label_id};
    
                    ITIResults.(ROI_id).(field_id).(run_id).(label).average_frequency=[ITIResults.(ROI_id).(field_id).(run_id).(label).average_frequency mean(iti.(ROI_id).(field_id).(run_id).(stim_id).frequency,'omitnan')];
                    %ITIResults.(ROI_id).(field_id).(run_id).(label).total_frequency=[ITIResults.(ROI_id).(field_id).(run_id).(label).total_frequency sum(iti.(ROI_id).(field_id).(run_id).(stim_id).frequency,'omitnan')];
                    ITIResults.(ROI_id).(field_id).(run_id).(label).average_duration=[ITIResults.(ROI_id).(field_id).(run_id).(label).average_duration mean(iti.(ROI_id).(field_id).(run_id).(stim_id).duration,'omitnan')];
                    %ITIResults.(ROI_id).(field_id).(run_id).(label).total_duration=[ITIResults.(ROI_id).(field_id).(run_id).(label).total_duration sum(iti.(ROI_id).(field_id).(run_id).(stim_id).duration,'omitnan')];
                    ITIResults.(ROI_id).(field_id).(run_id).(label).average_iti=[ITIResults.(ROI_id).(field_id).(run_id).(label).average_iti mean(iti.(ROI_id).(field_id).(run_id).(stim_id).iti,'omitnan')];
                    %ITIResults.(ROI_id).(field_id).(run_id).(label).total_iti=[ITIResults.(ROI_id).(field_id).(run_id).(label).total_iti sum(iti.(ROI_id).(field_id).(run_id).(stim_id).iti,'omitnan')];

                    clear label 
                
                end
    
                clear label_id stim_id
         
            end
    
            clear nstim run_id field_stim
    
        end
    
        clear l field_id field_run
    
    end

    clear k ROI_id

end

save('ITI_Run_Combined.mat','ITIResults','-v7.3')

%% Put information together for each day (average and total frequency, duration, iti)

ROI={'whole_face','all_face'};

for nROI=1:2
    ROI_id=char(ROI(nROI));
    fieldname=fieldnames(ITIResults.(ROI_id));
    
    for k=1:size(fieldname,1)
        
        field_id=char(fieldname(k));
        field_run=fieldnames(ITIResults.(ROI_id).(field_id));
        stim_label={char('sham_sham') char('sham_stim') char('stim_sham') char('stim_stim') char('current_sham') char('current_stim')};       
    
        for i=1:6
    
            ITI_Day.(ROI_id).(field_id).(stim_label{i}).average_frequency=[];
            %ITI_Day.(ROI_id).(field_id).(stim_label{i}).total_frequency=[];
            ITI_Day.(ROI_id).(field_id).(stim_label{i}).average_duration=[];
            %ITI_Day.(ROI_id).(field_id).(stim_label{i}).total_duration=[];
            ITI_Day.(ROI_id).(field_id).(stim_label{i}).average_iti=[];
            %ITI_Day.(ROI_id).(field_id).(stim_label{i}).total_iti=[];
            
        end
    
        clear i
            
        for l=1:size(field_run,1)
        
            run_id=char(field_run(l));
          
            for m=1:6
    
                label=stim_label{m};
                ITI_Day.(ROI_id).(field_id).(label).average_frequency=[ITI_Day.(ROI_id).(field_id).(label).average_frequency ITIResults.(ROI_id).(field_id).(run_id).(label).average_frequency]; 
                %ITI_Day.(ROI_id).(field_id).(label).total_frequency=[ITI_Day.(ROI_id).(field_id).(label).total_frequency ITIResults.(ROI_id).(field_id).(run_id).(label).total_frequency]; 
                ITI_Day.(ROI_id).(field_id).(label).average_duration=[ITI_Day.(ROI_id).(field_id).(label).average_duration ITIResults.(ROI_id).(field_id).(run_id).(label).average_duration]; 
                %ITI_Day.(ROI_id).(field_id).(label).total_duration=[ITI_Day.(ROI_id).(field_id).(label).total_duration ITIResults.(ROI_id).(field_id).(run_id).(label).total_duration]; 
                ITI_Day.(ROI_id).(field_id).(label).average_iti=[ITI_Day.(ROI_id).(field_id).(label).average_iti ITIResults.(ROI_id).(field_id).(run_id).(label).average_iti]; 
                %ITI_Day.(ROI_id).(field_id).(label).total_iti=[ITI_Day.(ROI_id).(field_id).(label).total_iti ITIResults.(ROI_id).(field_id).(run_id).(label).total_iti]; 
    
            end
    
            clear label m run_id
        
        end
        
        clear l field_id field_run 
    
    end

    clear k ROI_id

end

save('ITI_Day_Combined.mat','ITI_Day','-v7.3')

