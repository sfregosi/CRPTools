%Eliza Taylor
%Updated: 6-8-21

%This function reads in a .ann tonal file and compiles the data into a csv 
%file format
%Works for files with the following naming structure:
%####_YYYYMMDD_HHMMSS_sss.ann
%Sample function call : manipulate_tonals('1706_20170830_014647_938.ann')

silbido_init;
%Loads tonals from .ann file
folder = 'C:\Users\Elizabeth.Taylor\Documents\MATLAB\Silbido\Annotations_67\ann\';
file = dir('C:\Users\Elizabeth.Taylor\Documents\MATLAB\Silbido\Annotations_67\ann\*.ann');
savefolder='C:\Users\Elizabeth.Taylor\Documents\MATLAB\Silbido\Annotations_67\csv\';

for k=1:size(file,1)

tonal_set=dtTonalsLoad([folder,file(k).name]);

%Change these for different naming structure:
id=str2double(extractBetween(file(k).name,1,4));
year=str2double(extractBetween(file(k).name,6,9));
month=str2double(extractBetween(file(k).name,10,11));
day=str2double(extractBetween(file(k).name,12,13));
hour=str2double(extractBetween(file(k).name,15,16));
min=str2double(extractBetween(file(k).name,17,18));
sec=str2double(extractBetween(file(k).name,19,20));
ms=str2double(extractBetween(file(k).name,22,24));

%Set timing variables
time=datetime(year,month,day,hour,min,sec,ms);
time.Format='uuuu/MM/dd HH:mm:ss.SSS';

%Starting values of the matrix
real_time=time;
n=0;
tonal_time=0;
tonal_freq=0;
tonal_matrix=timetable(real_time,n,tonal_time,tonal_freq);

%Iterates through each tonal in the tonal set
for i=0:tonal_set.size()-1
    %Indentifies individual tonal
    tonal_temp=tonal_set.get(i);
    %Makes an array the size of the temp tonal used for numbering whistes
    %within the set
    n=zeros(tonal_temp.size(),1);
    %Each data point is labeled according to the whistle that it is apart
    %of, indexing variable
    for j=1:tonal_temp.size()
        n(j)=i+1;
    end
    %Array of times for one whistle
    tonal_time=tonal_temp.get_time();
    %Array of relative times for one whistle
    real_time=time+seconds(tonal_time);
    %Array of frequencies for one whistle
    tonal_freq=tonal_temp.get_freq();
    %temp matrix created with values for one whistle
    temp_matrix=timetable(real_time,n,tonal_time,tonal_freq);
    %temporary matrix added to tonal matrix
    %IMPROVE: preallocate space for tonal matrix instead of increasing its
    %size with each iteration
    tonal_matrix=[tonal_matrix;temp_matrix];
end
%Creates new filename, can be changed based on naming structure of files
new_filename=strcat(num2str(id,'%04.0f'),'_',num2str(year,'%04.0f'),num2str(month,'%02.0f'),num2str(day,'%02.0f'),'_',num2str(hour,'%02.0f'),num2str(min,'%02.0f'),num2str(sec,'%02.0f'),'_',num2str(ms,'%03.0f'),'.csv');
%Deletes first row, contained placeholder values
tonal_matrix(1,:)=[];
%Writes timetable to .csv located in same folder as .ann file
writetimetable(tonal_matrix,[savefolder,new_filename]);
end

