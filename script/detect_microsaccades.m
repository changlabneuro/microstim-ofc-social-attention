function saccs = detect_microsaccades(pos_deg, fs, data_folder)

% this code depends on the microsaccade detection toolbox from 
% Unsupervised clustering method to detect microsaccades, Otero-Millan et 
% al. 2014, available here: http://smc.neuralcorrelate.com/sw/microsaccade-detection/

session = 'test';
    
samples = [];
samples(:, 1) = 1:size(pos_deg, 2);
samples(:, 2:3) = pos_deg';
samples(:, 4:5) = pos_deg';
blinks = any( isnan(samples), 2 );

% Loads the recording and prepares it por processing
recording = ClusterDetection.EyeMovRecording.Create( data_folder, session, samples, blinks, fs );

% Runs the saccade detection
[saccades stats] = recording.FindSaccades();
saccs = saccades(:, 1:2); % [start, stop]

rm_p = fullfile( data_folder, session );
system( sprintf('rm -rf "%s"', rm_p) );

end