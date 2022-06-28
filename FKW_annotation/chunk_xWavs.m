% Workflow for processing xwavs for FKW annotation
% 
% to make working with multi-channel xwavs in Silbido easier
% This script:
% (1) reads in existing xwavs
% (2) outputs wav files that are 75 sec duration (one raw file) and only
% one channel
% 
% folder structure is as follows
% E:\Recordings, where there are three subfolders, 
% LANAI_A_01_S_disk01-03, 
% LANAI_A_01_E_C4_disk01-06
% LANAI_A_01_W_disk01-06.
% xwav files are named with project name_date, ie LANAI_A_01_S_201208_000000.x.wav.

clear all
warning('off')

%%%%%%%%%%%%%%%%%%%% CONFIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computer/user specific inputs that may need to be updated

% inputs
drive = 'E:\'; % which drive is the hard drive plugged in to?
projectName = 'LANAI_A_01_S_disk01-03'; % change this for each of the three subfolders to be run

% outputs
% create a folder named "chunked" within each project name subfolder
path_out = fullfile(drive, projectName, 'chunked');
mkdir(path_out);
drive = 'C:\Users\Selene.Fregosi\Downloads\drive-download-20220628T134017Z-001';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Run

xwavList = dir(fullfile(drive, projectName, '*.x.wav')); 
fprintf(1, 'Starting %s, processing %i xwavs...\n', projectName, length(xwavList))
for xw = 1:length(xwavList)
    try
    [s,fs] = audioread(fullfile(xwavList(xw).folder, xwavList(xw).name));
    catch
        fprintf('ATTENTION: audioread of %s failed\n', xwavList(xw).name)
    end

fprintf(1, 'Starting %s\n', dasbrNum)


