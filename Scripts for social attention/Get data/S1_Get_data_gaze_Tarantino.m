%% Load files and create "Gaze" variable

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
        
        Gaze.(day_char).(run_char).events = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/raw_events_Tarantino_gaze_eyes/',filename2)).var;
        Gaze.(day_char).(run_char).stim = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/stim/',filename2)).var;
        Gaze.(day_char).(run_char).rois = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/rois/',filename2)).var;
        Gaze.(day_char).(run_char).position = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/position/',filename2)).var;
        Gaze.(day_char).(run_char).offsets = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/single_origin_offsets/',filename2)).var;
        Gaze.(day_char).(run_char).time = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/time/',filename2)).var;
        Gaze.(day_char).(run_char).bounds = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/bounds/',filename2)).var;
        Gaze.(day_char).(run_char).meta = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/meta/',filename2)).var;
        Gaze.(day_char).(run_char).start_stop_time = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/plex_start_stop_times/',filename2)).start_stop_file; 
        Gaze.(day_char).(run_char).isfixation = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/raw_eye_mmv_fixations/',filename2)).var;
        Gaze.(day_char).(run_char).pupil = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/pupil_size/',filename2)).var;
       
        clear filename day_char run_char filename2
    end
    
    stringfile(stringindex)=[];
    
    clear string stringindex 
end

save('Gaze_Tarantino.mat','Gaze','-v7.3')

%% Get data

ROI_eyes = 'eyes_nf';
ROI_mouth = 'mouth';
ROI_face = 'face';
ROI_stim_eyes = 'stim_eyes_nf';

% get the field names
fieldname=fieldnames(Gaze);

for k=1:size(fieldname,1)
    field_id=char(fieldname(k));
    
    field_run=fieldnames(Gaze.(field_id));
    
    for l=1:size(field_run,1)
        
        run_id=char(field_run(l));
        
        % Get offsets
        Offsets_m1=Gaze.(field_id).(run_id).offsets.m1;
        Offsets_m2=Gaze.(field_id).(run_id).offsets.m2;
        Offsets_m2_m1=Gaze.(field_id).(run_id).offsets.m2_to_m1;
        
        % ROI info for eyes
        roi_m1_eyes=Gaze.(field_id).(run_id).rois.m1.rects(ROI_eyes);
        roi_m2_eyes=Gaze.(field_id).(run_id).rois.m2.rects(ROI_eyes);
        roi_m1_eyes([1,3])=roi_m1_eyes([1,3])+Offsets_m1(1);
        roi_m1_eyes([2,4])=roi_m1_eyes([2,4])+Offsets_m1(2);
        roi_m2_eyes([1,3])=Offsets_m2_m1(1)-(roi_m2_eyes([1,3])+Offsets_m2(1));
        roi_m2_eyes([2,4])=roi_m2_eyes([2,4])+Offsets_m2(2);
        
        GazeData.(field_id).(run_id).roi_m1_eyes=roi_m1_eyes;
        GazeData.(field_id).(run_id).roi_m2_eyes=roi_m2_eyes;
        
        % Get the center of ROI for eyes
        center_roi_m1_eyes=[(roi_m1_eyes(1)+roi_m1_eyes(3))/2 (roi_m1_eyes(2)+roi_m1_eyes(4))/2];
        center_roi_m2_eyes=[(roi_m2_eyes(1)+roi_m2_eyes(3))/2 (roi_m2_eyes(2)+roi_m2_eyes(4))/2];
        
        GazeData.(field_id).(run_id).center_roi_m1_eyes=center_roi_m1_eyes;
        GazeData.(field_id).(run_id).center_roi_m2_eyes=center_roi_m2_eyes;
        
        % ROI info for mouth
        roi_m1_mouth=Gaze.(field_id).(run_id).rois.m1.rects(ROI_mouth);
        roi_m2_mouth=Gaze.(field_id).(run_id).rois.m2.rects(ROI_mouth);
        roi_m1_mouth([1,3])=roi_m1_mouth([1,3])+Offsets_m1(1);
        roi_m1_mouth([2,4])=roi_m1_mouth([2,4])+Offsets_m1(2);
        roi_m2_mouth([1,3])=Offsets_m2_m1(1)-(roi_m2_mouth([1,3])+Offsets_m2(1));
        roi_m2_mouth([2,4])=roi_m2_mouth([2,4])+Offsets_m2(2);
        
        GazeData.(field_id).(run_id).roi_m1_mouth=roi_m1_mouth;
        GazeData.(field_id).(run_id).roi_m2_mouth=roi_m2_mouth;
        
        % Get the center of ROI for mouth
        center_roi_m1_mouth=[(roi_m1_mouth(1)+roi_m1_mouth(3))/2 (roi_m1_mouth(2)+roi_m1_mouth(4))/2];
        center_roi_m2_mouth=[(roi_m2_mouth(1)+roi_m2_mouth(3))/2 (roi_m2_mouth(2)+roi_m2_mouth(4))/2];
        
        GazeData.(field_id).(run_id).center_roi_m1_mouth=center_roi_m1_mouth;
        GazeData.(field_id).(run_id).center_roi_m2_mouth=center_roi_m2_mouth;
        
        % ROI info for face
        roi_m1_face=Gaze.(field_id).(run_id).rois.m1.rects(ROI_face);
        roi_m2_face=Gaze.(field_id).(run_id).rois.m2.rects(ROI_face);
        roi_m1_face([1,3])=roi_m1_face([1,3])+Offsets_m1(1);
        roi_m1_face([2,4])=roi_m1_face([2,4])+Offsets_m1(2);
        roi_m2_face([1,3])=Offsets_m2_m1(1)-(roi_m2_face([1,3])+Offsets_m2(1));
        roi_m2_face([2,4])=roi_m2_face([2,4])+Offsets_m2(2);
        
        GazeData.(field_id).(run_id).roi_m1_face=roi_m1_face;
        GazeData.(field_id).(run_id).roi_m2_face=roi_m2_face;
        
        % Get the center of ROI for face
        center_roi_m1_face=[(roi_m1_face(1)+roi_m1_face(3))/2 (roi_m1_face(2)+roi_m1_face(4))/2];
        center_roi_m2_face=[(roi_m2_face(1)+roi_m2_face(3))/2 (roi_m2_face(2)+roi_m2_face(4))/2];
        
        GazeData.(field_id).(run_id).center_roi_m1_face=center_roi_m1_face;
        GazeData.(field_id).(run_id).center_roi_m2_face=center_roi_m2_face;
      
        % Coordinates of gaze positions
        x_m1=Gaze.(field_id).(run_id).position.m1(1,:)+Offsets_m1(1);
        y_m1=Gaze.(field_id).(run_id).position.m1(2,:)+Offsets_m1(2);
        
        x_m2= Offsets_m2_m1(1)-(Gaze.(field_id).(run_id).position.m2(1,:)+Offsets_m2(1));
        y_m2= Gaze.(field_id).(run_id).position.m2(2,:)+Offsets_m2(2);
      
        GazeData.(field_id).(run_id).x_m1=x_m1;
        GazeData.(field_id).(run_id).y_m1=y_m1;
        
        GazeData.(field_id).(run_id).x_m2=x_m2;
        GazeData.(field_id).(run_id).y_m2=y_m2; 
            
        % Get different types of events
        GazeData.(field_id).(run_id).labels=Gaze.(field_id).(run_id).events.labels;
        GazeData.(field_id).(run_id).events=Gaze.(field_id).(run_id).events.events;
        GazeData.(field_id).(run_id).categories=Gaze.(field_id).(run_id).events.categories;
        
        % Label contra- or ipsi- lateral for each event (Tarantino's chamber is
        % on the right side of the head)

        for nevent=1:length(GazeData.(field_id).(run_id).events)

            start_idx=GazeData.(field_id).(run_id).events(nevent,1);
            end_idx=GazeData.(field_id).(run_id).events(nevent,2);
            m1_x=mean(GazeData.(field_id).(run_id).x_m1(1,start_idx:end_idx),'omitnan');
            m2_x=mean(GazeData.(field_id).(run_id).x_m2(1,start_idx:end_idx),'omitnan');

            if m1_x > GazeData.(field_id).(run_id).center_roi_m2_face(1)
                GazeData.(field_id).(run_id).event_info_m1(nevent,:)=table(GazeData.(field_id).(run_id).events(nevent,:),string('ipsi'));
            elseif m1_x < GazeData.(field_id).(run_id).center_roi_m2_face(1)
                GazeData.(field_id).(run_id).event_info_m1(nevent,:)=table(GazeData.(field_id).(run_id).events(nevent,:),string('contra'));
            else
                GazeData.(field_id).(run_id).event_info_m1(nevent,:)=table(GazeData.(field_id).(run_id).events(nevent,:),string('notavailable'));
            end

            if m2_x > GazeData.(field_id).(run_id).center_roi_m2_face(1)
                GazeData.(field_id).(run_id).event_info_m2(nevent,:)=table(GazeData.(field_id).(run_id).events(nevent,:),string('ipsi'));
            elseif m2_x < GazeData.(field_id).(run_id).center_roi_m2_face(1)
                GazeData.(field_id).(run_id).event_info_m2(nevent,:)=table(GazeData.(field_id).(run_id).events(nevent,:),string('contra'));
            else
                GazeData.(field_id).(run_id).event_info_m2(nevent,:)=table(GazeData.(field_id).(run_id).events(nevent,:),string('notavailable'));
            end

            clear start_idx end_idx m1_x m2_x

        end

        % Order stim and sham trials
        stim_times=Gaze.(field_id).(run_id).stim.stimulation_times;
        sham_times=Gaze.(field_id).(run_id).stim.sham_times;
        
        stim_ts = [ stim_times'; sham_times' ];
        stim_labels = repmat( {'stim'}, numel(stim_times), 1 );
        sham_labels = repmat( {'sham'}, numel(sham_times), 1 );
        all_stim_labels = [ stim_labels; sham_labels ];

        [stim_ts, sorted_order] = sort( stim_ts );
        all_stim_labels = all_stim_labels(sorted_order);
        
        GazeData.(field_id).(run_id).all_stim_labels=all_stim_labels;
        GazeData.(field_id).(run_id).stim_ts=stim_ts;
        
        % Bounds
        GazeData.(field_id).(run_id).bounds_m1_eyes=Gaze.(field_id).(run_id).bounds.m1(ROI_eyes);
        GazeData.(field_id).(run_id).bounds_m1_mouth=Gaze.(field_id).(run_id).bounds.m1(ROI_mouth);
        GazeData.(field_id).(run_id).bounds_m1_face=Gaze.(field_id).(run_id).bounds.m1(ROI_face);
        GazeData.(field_id).(run_id).bounds_m1_stim_eyes=Gaze.(field_id).(run_id).bounds.m1(ROI_stim_eyes);
        
        GazeData.(field_id).(run_id).bounds_m2_eyes=Gaze.(field_id).(run_id).bounds.m2(ROI_eyes);
        GazeData.(field_id).(run_id).bounds_m2_mouth=Gaze.(field_id).(run_id).bounds.m2(ROI_mouth);
        GazeData.(field_id).(run_id).bounds_m2_face=Gaze.(field_id).(run_id).bounds.m2(ROI_face);
        
        % Time and pupil size
        GazeData.(field_id).(run_id).t=Gaze.(field_id).(run_id).time.t;
        GazeData.(field_id).(run_id).pupil_m1=Gaze.(field_id).(run_id).pupil.m1;
        GazeData.(field_id).(run_id).pupil_m2=Gaze.(field_id).(run_id).pupil.m2;
        
        % Fixation and start_stop_time
        GazeData.(field_id).(run_id).m1_isfixation=Gaze.(field_id).(run_id).isfixation.m1;
        GazeData.(field_id).(run_id).m2_isfixation=Gaze.(field_id).(run_id).isfixation.m2;
        GazeData.(field_id).(run_id).start_stop_time=Gaze.(field_id).(run_id).start_stop_time;
        
        clear run_id Offsets_m1 Offsets_m2 Offsets_m2_m1 roi_m1_eyes roi_m2_eyes center_roi_m1_eyes center_roi_m2_eyes
        clear roi_m1_mouth roi_m2_mouth center_roi_m1_mouth center_roi_m2_mouth
        clear roi_m1_face roi_m2_face center_roi_m1_face center_roi_m2_face x_m1 y_m1 x_m2 y_m2
        clear stim_times sham_times stim_ts stim_labels sham_labels all_stim_labels sorted_order   
        
    end
    
    clear l field_id field_run
    
end
    
%% Get all relevant events

fieldname=fieldnames(GazeData);

    for k=1:size(fieldname,1)
        field_id=char(fieldname(k));    
        field_run=fieldnames(GazeData.(field_id));
        
        for l=1:size(field_run,1)
            run_id=char(field_run(l));
            
            % get indices of all types of events
            labels= GazeData.(field_id).(run_id).labels;
            event_label_column_names = GazeData.(field_id).(run_id).categories;
            roi_ind = strcmp( event_label_column_names, 'roi' );
            looks_by_ind = strcmp( event_label_column_names, 'looks_by' );
            m1_ind = strcmp( labels(:, looks_by_ind), 'm1' );
            m2_ind = strcmp( labels(:, looks_by_ind), 'm2' );
            mutual_ind = strcmp( labels(:, looks_by_ind), 'mutual' );
    
            % eye_ind is eyes
            eye_ind = strcmp( labels(:, roi_ind), 'eyes_nf' );
            % mouth_ind is mouth
            mouth_ind = strcmp( labels(:, roi_ind), 'mouth' ); 
            % face_ind is non-eye, non-mouth face
            face_ind = strcmp( labels(:, roi_ind), 'face' );  
            % everywhere_ind is everything else
            everywhere_ind = strcmp( labels(:, roi_ind), 'everywhere' );
            % get rid of a trial if the start or end time is unavailable
            non_nan_ind = ~isnan(GazeData.(field_id).(run_id).events(:,11)) & ~isnan(GazeData.(field_id).(run_id).events(:,12)) & ~isnan(GazeData.(field_id).(run_id).events(:,13)) & ~isnan(GazeData.(field_id).(run_id).events(:,14));
            
            % exclusive m1 events
            m1_eye_ind = m1_ind & eye_ind & non_nan_ind;
            m1_mouth_ind = m1_ind & mouth_ind & non_nan_ind;
            m1_nenmface_ind = m1_ind & face_ind & non_nan_ind;
            m1_everywhere_ind = m1_ind & everywhere_ind & non_nan_ind;
    
            m1_neface_ind = m1_mouth_ind | m1_nenmface_ind;
            m1_wholeface_ind = m1_eye_ind | m1_mouth_ind | m1_nenmface_ind;
            m1_all_ind = m1_eye_ind | m1_mouth_ind | m1_nenmface_ind | m1_everywhere_ind;
    
            % exclusive m2 events
            m2_eye_ind = m2_ind & eye_ind & non_nan_ind;
            m2_mouth_ind = m2_ind & mouth_ind & non_nan_ind;
            m2_nenmface_ind = m2_ind & face_ind & non_nan_ind;
            m2_everywhere_ind = m2_ind & everywhere_ind & non_nan_ind;
    
            m2_neface_ind = m2_mouth_ind | m2_nenmface_ind;
            m2_wholeface_ind = m2_eye_ind | m2_mouth_ind | m2_nenmface_ind;
            m2_all_ind = m2_eye_ind | m2_mouth_ind | m2_nenmface_ind | m2_everywhere_ind;
            
            % mutual events
            mutual_eye_ind = mutual_ind & eye_ind & non_nan_ind;
            mutual_mouth_ind = mutual_ind & mouth_ind & non_nan_ind;
            mutual_face_ind = mutual_ind & face_ind & non_nan_ind;
            mutual_wholeface_ind = mutual_eye_ind | mutual_mouth_ind | mutual_face_ind;
    
            % Events
            
            % exclulsive m1 events (use ipsi/contra label from m1's perspective)
            GazeData.(field_id).(run_id).m1_eye=GazeData.(field_id).(run_id).event_info_m1(m1_eye_ind,:);
            GazeData.(field_id).(run_id).m1_mouth=GazeData.(field_id).(run_id).event_info_m1(m1_mouth_ind,:);
            GazeData.(field_id).(run_id).m1_nenmface=GazeData.(field_id).(run_id).event_info_m1(m1_nenmface_ind,:);
            GazeData.(field_id).(run_id).m1_everywhere=GazeData.(field_id).(run_id).event_info_m1(m1_everywhere_ind,:);
    
            GazeData.(field_id).(run_id).m1_neface=GazeData.(field_id).(run_id).event_info_m1(m1_neface_ind,:);
            GazeData.(field_id).(run_id).m1_wholeface=GazeData.(field_id).(run_id).event_info_m1(m1_wholeface_ind,:);
            GazeData.(field_id).(run_id).m1_all=GazeData.(field_id).(run_id).event_info_m1(m1_all_ind,:);
            
            % exclulsive m2 events (use ipsi/contra label from m2's perspective)
            GazeData.(field_id).(run_id).m2_eye=GazeData.(field_id).(run_id).event_info_m2(m2_eye_ind,:);
            GazeData.(field_id).(run_id).m2_mouth=GazeData.(field_id).(run_id).event_info_m2(m2_mouth_ind,:);
            GazeData.(field_id).(run_id).m2_nenmface=GazeData.(field_id).(run_id).event_info_m2(m2_nenmface_ind,:);
            GazeData.(field_id).(run_id).m2_everywhere=GazeData.(field_id).(run_id).event_info_m2(m2_everywhere_ind,:);
    
            GazeData.(field_id).(run_id).m2_neface=GazeData.(field_id).(run_id).event_info_m2(m2_neface_ind,:);
            GazeData.(field_id).(run_id).m2_wholeface=GazeData.(field_id).(run_id).event_info_m2(m2_wholeface_ind,:);
            GazeData.(field_id).(run_id).m2_all=GazeData.(field_id).(run_id).event_info_m2(m2_all_ind,:);
            
            % mutual events (use ipsi/contra label from m1's perspective)
            GazeData.(field_id).(run_id).mutual_eye=GazeData.(field_id).(run_id).event_info_m1(mutual_eye_ind,:);
            GazeData.(field_id).(run_id).mutual_mouth=GazeData.(field_id).(run_id).event_info_m1(mutual_mouth_ind,:);
            GazeData.(field_id).(run_id).mutual_face=GazeData.(field_id).(run_id).event_info_m1(mutual_face_ind,:);
            GazeData.(field_id).(run_id).mutual_wholeface=GazeData.(field_id).(run_id).event_info_m1(mutual_wholeface_ind,:);
            
            
            clear run_id labels event_label_column_names roi_ind looks_by_ind m1_ind m2_ind mutual_ind
            clear eye_ind mouth_ind face_ind everywhere_ind non_nan_ind
            clear m1_eye_ind m1_mouth_ind m1_nenmface_ind m1_everywhere_ind m1_neface_ind m1_wholeface_ind m1_all_ind 
            clear m2_eye_ind m2_mouth_ind m2_nenmface_ind m2_everywhere_ind m2_neface_ind m2_wholeface_ind m2_all_ind
            clear mutual_eye_ind mutual_mouth_ind mutual_face_ind mutual_wholeface_ind 
    
        end
        
        clear l field_id field_run
        
    end

save('Gaze_Data_Tarantino.mat','GazeData','-v7.3')
            
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

    