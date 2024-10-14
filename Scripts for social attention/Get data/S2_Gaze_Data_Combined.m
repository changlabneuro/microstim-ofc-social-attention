%% upload Gaze_Data.mat and combine two monkeys

fieldname_Lynch=fieldnames(Lynch);
fieldname_Tarantino=fieldnames(Tarantino);

for nday_Lynch=1:size(fieldname_Lynch,1)

    field_id_Lynch=char(fieldname_Lynch(nday_Lynch));
    
    GazeData.(field_id_Lynch)=Lynch.(field_id_Lynch);

end

for nday_Tarantino= 1:size(fieldname_Tarantino,1)

    field_id_Tarantino=char(fieldname_Tarantino(nday_Tarantino));
    
    GazeData.(field_id_Tarantino)=Tarantino.(field_id_Tarantino);

end
