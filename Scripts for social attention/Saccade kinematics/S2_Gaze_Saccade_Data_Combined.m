%% Upload saccade information

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
        
        Gaze.(day_char).(run_char).events = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/raw_events_Lynch_gaze/',filename2)).var;
        Gaze.(day_char).(run_char).bounds = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/bounds/',filename2)).var;
        Gaze.(day_char).(run_char).saccades_time = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/saccades/',filename2)).microsaccades;
        Gaze.(day_char).(run_char).saccades_label= load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/saccades/',filename2)).saccade_labels;
        
        clear filename day_char run_char filename2
    end
    
    stringfile(stringindex)=[];
    
    clear string stringindex 
end

save('Saccade_Lynch.mat','Gaze','-v7.3')

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
        
        Dot.(day_char).(run_char).events = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/raw_events_Lynch_dot/',filename2)).var;
        Dot.(day_char).(run_char).bounds = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/bounds/',filename2)).var;
        Dot.(day_char).(run_char).saccades_time = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/saccades/',filename2)).microsaccades;
        Dot.(day_char).(run_char).saccades_label= load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/saccades/',filename2)).saccade_labels;
        
        clear filename day_char run_char filename2
    end
    
    stringfile(stringindex)=[];
    
    clear string stringindex 
end

save('Saccade_Lynch.mat','Dot','-v7.3')

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
        Gaze.(day_char).(run_char).bounds = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/bounds/',filename2)).var;
        Gaze.(day_char).(run_char).saccades_time = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/saccades/',filename2)).microsaccades;
        Gaze.(day_char).(run_char).saccades_label= load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/saccades/',filename2)).saccade_labels;
        
        clear filename day_char run_char filename2
    end
    
    stringfile(stringindex)=[];
    
    clear string stringindex 
end

save('Saccade_Tarantino.mat','Gaze','-v7.3')

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
        Dot.(day_char).(run_char).bounds = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/bounds/',filename2)).var;
        Dot.(day_char).(run_char).saccades_time = load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/saccades/',filename2)).microsaccades;
        Dot.(day_char).(run_char).saccades_label= load(append('/Volumes/Brains/BRAINS Microstimulation/Data/intermediates/saccades/',filename2)).saccade_labels;
        
        clear filename day_char run_char filename2
    end
    
    stringfile(stringindex)=[];
    
    clear string stringindex 
end

save('Saccade_Tarantino.mat','Dot','-v7.3')

%% upload SaccadeGaze_Data.mat and combine two monkeys

fieldname_Lynch=fieldnames(Lynch);
fieldname_Tarantino=fieldnames(Tarantino);

for nday_Lynch=1:size(fieldname_Lynch,1)

    field_id_Lynch=char(fieldname_Lynch(nday_Lynch));
    
    GazeSaccade.(field_id_Lynch)=Lynch.(field_id_Lynch);

end

for nday_Tarantino= 1:size(fieldname_Tarantino,1)

    field_id_Tarantino=char(fieldname_Tarantino(nday_Tarantino));
    
    GazeSaccade.(field_id_Tarantino)=Tarantino.(field_id_Tarantino);

end

save('Saccade_Gaze_Combined.mat','GazeSaccade','-v7.3')

%% upload SaccadeDot_Data.mat and combine two monkeys

fieldname_Lynch=fieldnames(Lynch);
fieldname_Tarantino=fieldnames(Tarantino);

for nday_Lynch=1:size(fieldname_Lynch,1)

    field_id_Lynch=char(fieldname_Lynch(nday_Lynch));
    
    DotSaccade.(field_id_Lynch)=Lynch.(field_id_Lynch);

end

for nday_Tarantino= 1:size(fieldname_Tarantino,1)

    field_id_Tarantino=char(fieldname_Tarantino(nday_Tarantino));
    
    DotSaccade.(field_id_Tarantino)=Tarantino.(field_id_Tarantino);

end

save('Saccade_Dot_Combined.mat','DotSaccade','-v7.3')
