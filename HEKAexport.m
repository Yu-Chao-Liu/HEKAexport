%% Clean up
clear
close all
clc
imgshow = 0;

%% Load file
filepath = uigetdir;
cd(filepath);
        allDat = dir('*.dat');
        allData = {};
        for aa = 1:size(allDat,1)
            inputFile = HEKA_Importer(allDat(aa).name);
            dataPart = inputFile.RecTable.dataRaw;
            for dd = 1:size(dataPart,1)
                allData{end+1,1} = dataPart{dd};
            end
        end
        
%% Define the parameters         (Check the inputFile.RecTable)
% exp = 13;        % define the session to be extracted
SR = inputFile.RecTable.SR;     % sampling rate
gain_sig = 10^-3;
gain_stim = 10^-12;
% ExperimentName: # slice
% Experiment: # cell

%% Process the data and Plot the data
for exp = 1:size(inputFile.RecTable,1)

for n = 1:size(allData{exp},2)
    a = char(strcat(inputFile.RecTable.ExperimentName(exp),'_',num2str(inputFile.RecTable.Experiment(exp)),'_',num2str(inputFile.RecTable.Rec(exp)),'_',inputFile.RecTable.Stimulus(exp),'_',num2str(n))); 
if isempty(inputFile.RecTable.ChUnit{exp}{1,n}) ~= 1   
   if inputFile.RecTable.ChUnit{exp}{1,n}(1,1) == 'V'
   allData{exp}{1,n} = allData{exp}{1,n}./gain_sig;
   
   if imgshow
   figure('Name',a);
   plot((1:length(inputFile.RecTable.dataRaw{exp,1}{1,n}))/SR(exp,1),allData{exp}{1,n})  % Recording signals  (mV/s)
   end
   
   else % == 'A'
   allData{exp}{1,n} = allData{exp}{1,n}./gain_stim;
   
   if imgshow
   figure('Name',a);
   plot((1:length(inputFile.RecTable.dataRaw{exp,1}{1,n}))/SR(exp,1),allData{exp}{1,n})  % Stimulus protocol (pA/s)
   end
   end 
else
   if imgshow
   figure('Name',a);
   plot((1:length(inputFile.RecTable.dataRaw{exp,1}{1,n}))/SR(exp,1),allData{exp}{1,n})
   end
end
T = table (allData{exp,1}{1,n}); 
if ~contains(a,'*') == 1
    writetable(T, [a,'.txt']);  %% Save file as txt
else
    writetable(T, [erase(a,"*"),'.txt']);  %% Save file as txt
end
end          
end

sound(sin(1:3000));