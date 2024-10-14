%% Load files and create "Dot" variable

files = dir('*.mat');
filesname = {files.name};
sortedfilesname = natsort(filesname);
characterfile=char(sortedfilesname);

% stringfile is the file names in right order: 1, 2, ... 9, 10, 11
stringfile=deblank(string(characterfile));

% datafile is the first 8 digit of the file names (Data)
datefile=string(characterfile(:,1:8));

% date is distinct experiment days
date=unique(datefile);

for i=1:length(date)
    string_binary=strfind(stringfile,date(i));
    string=cellfun(@(a)~isempty(a) && a>0,string_binary);
    stringindex=find(string==1);
    
    for j=stringindex(1):stringindex(end)
        
        filename=cellstr(extractBefore(stringfile(j),'.mat'));
        filename2=stringfile(j);
        
        day_char=char(strcat('data_',date(i)));
        run_char=char(strcat('run_',num2str(j)));
        
        Dot.(day_char).(run_char).events = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/raw_events_Tarantino_dot_eyes/',filename2)).var;
        Dot.(day_char).(run_char).stim = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/stim/',filename2)).var;
        Dot.(day_char).(run_char).rois = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/rois/',filename2)).dot_roi;
        Dot.(day_char).(run_char).position = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/position/',filename2)).var;
        Dot.(day_char).(run_char).offsets = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/single_origin_offsets/',filename2)).dot_f;
        Dot.(day_char).(run_char).time = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/time/',filename2)).var;
        Dot.(day_char).(run_char).bounds = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/bounds/',filename2)).var;
        Dot.(day_char).(run_char).meta = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/meta/',filename2)).var;
        Dot.(day_char).(run_char).start_stop_time = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/plex_start_stop_times/',filename2)).start_stop_file; 
        Dot.(day_char).(run_char).isfixation = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/raw_eye_mmv_fixations/',filename2)).var;
        Dot.(day_char).(run_char).pupil = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/pupil_size/',filename2)).var;
       
        clear filename day_char run_char filename2
    end
    
    stringfile(stringindex)=[];
    
    clear string stringindex 
end

save('Dot_Tarantino.mat','Dot','-v7.3')

%% Get data

ROI_eyes = 'eyes_nf';
ROI_mouth = 'mouth';
ROI_face = 'face';
ROI_stim_eyes = 'stim_eyes_nf';

% get the field names
fieldname=fieldnames(Dot);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    
    field_run=fieldnames(Dot.(field_id));
    
    for l=1:size(field_run,1)
        
        run_id=char(field_run(l));
        
        % Get offsets
        Offsets_m1=Dot.(field_id).(run_id).offsets.m1;
        Offsets_m2=Dot.(field_id).(run_id).offsets.m2;
        Offsets_m2_m1=Dot.(field_id).(run_id).offsets.m2_to_m1;
        
        % ROI info for eyes (m1 roi is m2's eyes from m1's perspective)
        roi_m1_eyes=Dot.(field_id).(run_id).rois.m1.rects(ROI_eyes);
        roi_m2_eyes=Dot.(field_id).(run_id).rois.m2.rects(ROI_eyes);
        roi_m1_eyes([1,3])=roi_m1_eyes([1,3])+Offsets_m1(1);
        roi_m1_eyes([2,4])=roi_m1_eyes([2,4])+Offsets_m1(2);
        roi_m2_eyes([1,3])=Offsets_m2_m1(1)-(roi_m2_eyes([1,3])+Offsets_m2(1));
        roi_m2_eyes([2,4])=roi_m2_eyes([2,4])+Offsets_m2(2);
        
        DotData.(field_id).(run_id).roi_m1_eyes=roi_m1_eyes;
        DotData.(field_id).(run_id).roi_m2_eyes=roi_m2_eyes;
        
        % Get the center of ROI for eyes
        center_roi_m1_eyes=[(roi_m1_eyes(1)+roi_m1_eyes(3))/2 (roi_m1_eyes(2)+roi_m1_eyes(4))/2];
        center_roi_m2_eyes=[(roi_m2_eyes(1)+roi_m2_eyes(3))/2 (roi_m2_eyes(2)+roi_m2_eyes(4))/2];
        
        DotData.(field_id).(run_id).center_roi_m1_eyes=center_roi_m1_eyes;
        DotData.(field_id).(run_id).center_roi_m2_eyes=center_roi_m2_eyes;
        
        % ROI info for mouth
        roi_m1_mouth=Dot.(field_id).(run_id).rois.m1.rects(ROI_mouth);
        roi_m2_mouth=Dot.(field_id).(run_id).rois.m2.rects(ROI_mouth);
        roi_m1_mouth([1,3])=roi_m1_mouth([1,3])+Offsets_m1(1);
        roi_m1_mouth([2,4])=roi_m1_mouth([2,4])+Offsets_m1(2);
        roi_m2_mouth([1,3])=Offsets_m2_m1(1)-(roi_m2_mouth([1,3])+Offsets_m2(1));
        roi_m2_mouth([2,4])=roi_m2_mouth([2,4])+Offsets_m2(2);
        
        DotData.(field_id).(run_id).roi_m1_mouth=roi_m1_mouth;
        DotData.(field_id).(run_id).roi_m2_mouth=roi_m2_mouth;
        
        % Get the center of ROI for mouth
        center_roi_m1_mouth=[(roi_m1_mouth(1)+roi_m1_mouth(3))/2 (roi_m1_mouth(2)+roi_m1_mouth(4))/2];
        center_roi_m2_mouth=[(roi_m2_mouth(1)+roi_m2_mouth(3))/2 (roi_m2_mouth(2)+roi_m2_mouth(4))/2];
        
        DotData.(field_id).(run_id).center_roi_m1_mouth=center_roi_m1_mouth;
        DotData.(field_id).(run_id).center_roi_m2_mouth=center_roi_m2_mouth;
        
        % ROI info for face
        roi_m1_face=Dot.(field_id).(run_id).rois.m1.rects(ROI_face);
        roi_m2_face=Dot.(field_id).(run_id).rois.m2.rects(ROI_face);
        roi_m1_face([1,3])=roi_m1_face([1,3])+Offsets_m1(1);
        roi_m1_face([2,4])=roi_m1_face([2,4])+Offsets_m1(2);
        roi_m2_face([1,3])=Offsets_m2_m1(1)-(roi_m2_face([1,3])+Offsets_m2(1));
        roi_m2_face([2,4])=roi_m2_face([2,4])+Offsets_m2(2);
        
        DotData.(field_id).(run_id).roi_m1_face=roi_m1_face;
        DotData.(field_id).(run_id).roi_m2_face=roi_m2_face;
        
        % Get the center of ROI for face
        center_roi_m1_face=[(roi_m1_face(1)+roi_m1_face(3))/2 (roi_m1_face(2)+roi_m1_face(4))/2];
        center_roi_m2_face=[(roi_m2_face(1)+roi_m2_face(3))/2 (roi_m2_face(2)+roi_m2_face(4))/2];
        
        DotData.(field_id).(run_id).center_roi_m1_face=center_roi_m1_face;
        DotData.(field_id).(run_id).center_roi_m2_face=center_roi_m2_face;
        
        % Coordinates of gaze positions
        x_m1=Dot.(field_id).(run_id).position.m1(1,:)+Offsets_m1(1);
        y_m1=Dot.(field_id).(run_id).position.m1(2,:)+Offsets_m1(2);
        
        DotData.(field_id).(run_id).x_m1=x_m1;
        DotData.(field_id).(run_id).y_m1=y_m1;
          
        % Get different types of events
        DotData.(field_id).(run_id).labels=Dot.(field_id).(run_id).events.labels;
        DotData.(field_id).(run_id).events=Dot.(field_id).(run_id).events.events;
        DotData.(field_id).(run_id).categories=Dot.(field_id).(run_id).events.categories;
        
        % Label contra- or ipsi- lateral for each event (Tarantino's chamber is
        % on the right side of the head)

        for nevent=1:length(DotData.(field_id).(run_id).events)

            start_idx=DotData.(field_id).(run_id).events(nevent,1);
            end_idx=DotData.(field_id).(run_id).events(nevent,2);
            m1_x=mean(DotData.(field_id).(run_id).x_m1(1,start_idx:end_idx),'omitnan');
            
            if m1_x > DotData.(field_id).(run_id).center_roi_m2_face(1)
                DotData.(field_id).(run_id).event_info_m1(nevent,:)=table(DotData.(field_id).(run_id).events(nevent,:),string('ipsi'));
            elseif m1_x < DotData.(field_id).(run_id).center_roi_m2_face(1)
                DotData.(field_id).(run_id).event_info_m1(nevent,:)=table(DotData.(field_id).(run_id).events(nevent,:),string('contra'));
            else
                DotData.(field_id).(run_id).event_info_m1(nevent,:)=table(DotData.(field_id).(run_id).events(nevent,:),string('notavailable'));
            end

            clear start_idx end_idx m1_x 

        end

        % Order stim and sham trials
        stim_times=Dot.(field_id).(run_id).stim.stimulation_times;
        sham_times=Dot.(field_id).(run_id).stim.sham_times;
        
        stim_ts = [ stim_times'; sham_times' ];
        stim_labels = repmat( {'stim'}, numel(stim_times), 1 );
        sham_labels = repmat( {'sham'}, numel(sham_times), 1 );
        all_stim_labels = [ stim_labels; sham_labels ];

        [stim_ts, sorted_order] = sort( stim_ts );
        all_stim_labels = all_stim_labels(sorted_order);
        
        DotData.(field_id).(run_id).all_stim_labels=all_stim_labels;
        DotData.(field_id).(run_id).stim_ts=stim_ts;
        
        % Bounds
        DotData.(field_id).(run_id).bounds_m1_eyes=Dot.(field_id).(run_id).bounds.m1(ROI_eyes);
        DotData.(field_id).(run_id).bounds_m1_mouth=Dot.(field_id).(run_id).bounds.m1(ROI_mouth);
        DotData.(field_id).(run_id).bounds_m1_face=Dot.(field_id).(run_id).bounds.m1(ROI_face);
        DotData.(field_id).(run_id).bounds_m1_stim_eyes=Dot.(field_id).(run_id).bounds.m1(ROI_stim_eyes);
        
        % Time and pupil size
        DotData.(field_id).(run_id).t=Dot.(field_id).(run_id).time.t;
        DotData.(field_id).(run_id).pupil_m1=Dot.(field_id).(run_id).pupil.m1;
        
        % Fixation and start_stop_time
        DotData.(field_id).(run_id).m1_isfixation=Dot.(field_id).(run_id).isfixation.m1;
        DotData.(field_id).(run_id).start_stop_time=Dot.(field_id).(run_id).start_stop_time;
        
        clear run_id Offsets_m1 roi_m1_eyes center_roi_m1_eyes 
        clear roi_m1_mouth center_roi_m1_mouth 
        clear roi_m1_face center_roi_m1_face x_m1 y_m1
        clear stim_times sham_times stim_ts stim_labels sham_labels all_stim_labels sorted_order   
        
    end
    
    clear l field_id field_run
    
end
    
%% Get all relevant events

fieldname=fieldnames(DotData);

    for k=1:size(fieldname,1)
        field_id=char(fieldname(k));    
        field_run=fieldnames(DotData.(field_id));
        
        for l=1:size(field_run,1)
            run_id=char(field_run(l));
            
            % get indices of all types of events
            labels= DotData.(field_id).(run_id).labels;
            event_label_column_names = DotData.(field_id).(run_id).categories;
            roi_ind = strcmp( event_label_column_names, 'roi' );
            looks_by_ind = strcmp( event_label_column_names, 'looks_by' );
            m1_ind = strcmp( labels(:, looks_by_ind), 'm1' );
            
            % eye_ind is eyes
            eye_ind = strcmp( labels(:, roi_ind), 'eyes_nf' );
            % mouth_ind is mouth
            mouth_ind = strcmp( labels(:, roi_ind), 'mouth' ); 
            % face_ind is non-eye, non-mouth face
            face_ind = strcmp( labels(:, roi_ind), 'face' );  
            % everywhere_ind is everything else
            everywhere_ind = strcmp( labels(:, roi_ind), 'everywhere' );
            % get rid of a trial if the start or end time is unavailable
            non_nan_ind = ~isnan(DotData.(field_id).(run_id).events(:,11)) & ~isnan(DotData.(field_id).(run_id).events(:,12)) & ~isnan(DotData.(field_id).(run_id).events(:,13)) & ~isnan(DotData.(field_id).(run_id).events(:,14));
            
            % exclusive m1 events
            m1_eye_ind = m1_ind & eye_ind & non_nan_ind;
            m1_mouth_ind = m1_ind & mouth_ind & non_nan_ind;
            m1_nenmface_ind = m1_ind & face_ind & non_nan_ind;
            m1_everywhere_ind = m1_ind & everywhere_ind & non_nan_ind;
    
            m1_neface_ind = m1_mouth_ind | m1_nenmface_ind;
            m1_wholeface_ind = m1_eye_ind | m1_mouth_ind | m1_nenmface_ind;
            m1_all_ind = m1_eye_ind | m1_mouth_ind | m1_nenmface_ind | m1_everywhere_ind;
        
            % Events
            
            % exclulsive m1 events (use ipsi/contra label from m1's perspective)
            DotData.(field_id).(run_id).m1_eye=DotData.(field_id).(run_id).event_info_m1(m1_eye_ind,:);
            DotData.(field_id).(run_id).m1_mouth=DotData.(field_id).(run_id).event_info_m1(m1_mouth_ind,:);
            DotData.(field_id).(run_id).m1_nenmface=DotData.(field_id).(run_id).event_info_m1(m1_nenmface_ind,:);
            DotData.(field_id).(run_id).m1_everywhere=DotData.(field_id).(run_id).event_info_m1(m1_everywhere_ind,:);
    
            DotData.(field_id).(run_id).m1_neface=DotData.(field_id).(run_id).event_info_m1(m1_neface_ind,:);
            DotData.(field_id).(run_id).m1_wholeface=DotData.(field_id).(run_id).event_info_m1(m1_wholeface_ind,:);
            DotData.(field_id).(run_id).m1_all=DotData.(field_id).(run_id).event_info_m1(m1_all_ind,:);
        
            clear run_id labels event_label_column_names roi_ind looks_by_ind m1_ind 
            clear eye_ind mouth_ind face_ind everywhere_ind non_nan_ind
            clear m1_eye_ind m1_mouth_ind m1_nenmface_ind m1_everywhere_ind m1_neface_ind m1_wholeface_ind m1_all_ind 
           
        end
        
        clear l field_id field_run
        
    end

save('Dot_Data_Tarantino.mat','DotData','-v7.3')
            
%% Plotting an example trial


for nstim=1:length(stim_times)
    
   
    %fixation_faceevent_idx=find(m1_face_matrix(:,4)>=stim_times(nstim) & m1_face_matrix(:,4)<stim_times(nstim)+5);
    
    %nfixation=[nfixation length(fixation_event_idx)];
    %nfixation_eye=[nfixation_eye length(fixation_eyeevent_idx)];
    %nfixation_face=[nfixation_face length(fixation_faceevent_idx)];
    
    stim_t = stim_times(nstim);
    t0 = stim_t;
    t1 = t0 + 5;
    t_ind = time_file.t >= t0-0.2 & time_file.t < t1;
    m1_pos_slice_x = m1_position_x(t_ind);
    m1_pos_slice_y = m1_position_y(t_ind);
    
    scatter( m1_pos_slice_x, m1_pos_slice_y ); hold on
      
    
    for nevent=1:length(start_time)

    [~, start_time_idx(nevent)]=min(abs(time_file.t'-start_time(nevent)));
    [~, end_time_idx(nevent)]=min(abs(time_file.t'-end_time(nevent)));
    
    m1_position_mean_x(nevent)=nanmean(m1_position_x(start_time_idx(nevent):end_time_idx(nevent)));
    m1_position_mean_y(nevent)=nanmean(m1_position_y(start_time_idx(nevent):end_time_idx(nevent)));
    
    scatter(m1_position_x(start_time_idx(nevent):end_time_idx(nevent)),m1_position_y(start_time_idx(nevent):end_time_idx(nevent)),10,'filled','k');
    scatter(m1_position_mean_x(nevent),m1_position_mean_y(nevent),'filled','r'); hold on
    text(m1_position_mean_x(nevent)+6,m1_position_mean_y(nevent),num2str(nevent)); hold on
    
    end
    
    for neyeevent=1:length(fixation_eyeevent_idx)
    
    [~, start_eye_time_idx(neyeevent)]=min(abs(time_file.t'-start_eye_time(neyeevent)));
    [~, end_eye_time_idx(neyeevent)]=min(abs(time_file.t'-end_eye_time(neyeevent)));
    
    m1_position_mean_eye_x(neyeevent)=nanmean(m1_position_x(start_eye_time_idx(neyeevent):end_eye_time_idx(neyeevent)));
    m1_position_mean_eye_y(neyeevent)=nanmean(m1_position_y(start_eye_time_idx(neyeevent):end_eye_time_idx(neyeevent)));
    
    %scatter(m1_position_x(start_eye_time_idx(neyeevent):end_eye_time_idx(neyeevent)),m1_position_y(start_eye_time_idx(neyeevent):end_eye_time_idx(neyeevent)),10,'filled','k');
    scatter(m1_position_mean_eye_x(neyeevent),m1_position_mean_eye_y(neyeevent),'filled','y'); hold on
    %text(m1_position_mean_x(nevent)+6,m1_position_mean_y(neyeevent),num2str(neyeevent)); hold on
        
    end
    
    
    rectangle('Position',[roi_m1_eyes(1),roi_m1_eyes(2),roi_m1_eyes(3)-roi_m1_eyes(1),roi_m1_eyes(4)-roi_m1_eyes(2)]); hold on
    rectangle('Position',[roi_m1_face(1),roi_m1_face(2),roi_m1_face(3)-roi_m1_face(1),roi_m1_face(4)-roi_m1_face(2)]);
     
    saveas(gcf,sprintf(['stim_' num2str(nstim) '.png']))
    clf
    clear stim_t t0 t1 t_ind m1_pos_splice_x m1_pos_slice_y neyeevent start_eye_time_idx end_eye_time_idx m1_position_mean_eye_x m1_position_mean_eye_y
    clear nevent eye_event_idx start_eye end_eye fixation_event_idx start_time end_time fixation_eyeevent_idx fixation_faceevent_idx start_time_idx end_time_idx m1_position_mean_x m1_position_mean_y
    
end

    