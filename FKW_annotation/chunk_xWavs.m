% Workflow for processing xwavs for FKW annotation
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%
% this REQUIRES rdxwavhd_so.m from LonglineAcoustics code
%
% 2022 06 28 S Fregosi, selene.fregosi@noaa.gov, CRPTools/FKW_annotations
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
warning('off')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONFIGURE PATHS
% computer/user specific inputs that may need to be updated

% path to folder containing project subfolders
path_in = 'E:\Recordings';
% path_in = 'C:\Users\selene\Downloads\Recordings\';

% project subfolder name; uncomment which you want to run, one at a time
projectName = 'LANAI_A_01_S_disk01-03';
% projectName = 'LANAI_A_01_E_C4_disk01-06';
% projectName = 'LANAI_A_01_W_disk01-06';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set up outputs
% create a folder named "chunked" within each project name subfolder
path_out = fullfile(path_in, projectName, 'chunked');
mkdir(path_out);

% get list of xwavs in this folder
xwavList = dir(fullfile(path_in, projectName, '*.x.wav'));
fprintf(1, 'Starting %s, processing %i xwavs...\n', projectName, length(xwavList))

% loop through all xwavs
for xw = 1:length(xwavList)
    xwav = fullfile(xwavList(xw).folder, xwavList(xw).name);
    % read xwav header to get file info (num raw files, sample rate, etc.)
    hdr = rdxwavhd_so(xwav, false);
    
    % try to read in the audio file
    try
        [s,fs] = audioread(xwav);
    catch
        fprintf('ATTENTION: audioread of %s failed\n', xwavList(xw).name)
        continue % skip processing this xwav
    end
    
    % check num ch matches num cols in s
    if hdr.nch ~= size(s,2)
        fprintf('ATTENTION: num channels does not match signal read for %s\n', xwavList(xw).name)
        continue % skip processing this xwav
        
    elseif hdr.nch == size(s,2)
        
        % create folders for each channel, if numCh > 1
        if hdr.nch > 1
            for ch = 1:hdr.nch
                mkdir(fullfile(path_out, ['ch0' num2str(ch)]));
            end
        end
        
        % get the original file prefix for new names later
        [~, prefix_strs] = regexp(xwavList(xw).name, '\d{6}[_]\d{6}', 'match', 'split');
        % set up lists for new file names based on raw file dates
        rawDateList = NaT(hdr.xhd.NumOfRawFiles,1);
        newFileNameList = cell(hdr.xhd.NumOfRawFiles,1);
        
        % get the length of each raw file in sec, based on samples and fs
        rfDur_samp = size(s,1)/hdr.xhd.NumOfRawFiles/fs;
        
        % loop through all raw files
        for rf = 1:hdr.xhd.NumOfRawFiles
            % get new file name from raw file start time
            xdatevec = [hdr.xhd.year(rf)+2000 hdr.xhd.month(rf) hdr.xhd.day(rf) ...
                hdr.xhd.hour(rf) hdr.xhd.minute(rf) hdr.xhd.secs(rf) + ...
                hdr.xhd.ticks(rf)/1000];
            rawDateList(rf) = datetime(xdatevec);
            % if not rf = 1, check that is rf dur after last file start
            if rf > 1
                rfDurCheck = rawDateList(rf) - rawDateList(rf-1);
                if rfDurCheck == 0 % doesn't pass
                    fprintf('ATTENTION: rf durations do not match samples in %s\n', xwavList(xw).name)
                    continue % skip processing this xwav
                end
            end
            newFileStartStr = datestr(rawDateList(rf),'yymmdd_HHMMSS');
            newFileNameList{rf} = [prefix_strs{1} newFileStartStr];
            
            % get indices of samples for this raw file
            sampStart = (rf-1)*fs*rfDur_samp + 1;
            sampEnd = rf*fs*rfDur_samp;
            
            % loop through each channel and write new output file if > 1 ch
            if hdr.nch > 1
                for ch = 1:hdr.nch
                    audiowrite(fullfile(path_out, ['ch0' num2str(ch)],...
                        [newFileNameList{rf} '_ch0' num2str(ch) '.wav']), ...
                        s(sampStart:sampEnd,ch), fs);
                end
            elseif hdr.nch == 1 % if only one channel, simpler file name
                audiowrite(fullfile(path_out, [newFileNameList{rf} '.wav']), ...
                    s(sampStart:sampEnd,1), fs);
            end % nch check
        end % loop through raw files
    end % nch check
end % loop through all xwavs

