clc; clear;

folderSolo = 'C:/Users/Carmela/Desktop/Game/Experiments/Dati_Montpellier_Feb/experimentsFebruary2019/SoloCondition/';

%ask the total number of the trial
numTrials = 10;

% solo experiment
namePlayer = input('Insert the name of the player without spaces: ', 's');

for x = 1:1:numTrials
    
    fileID = fopen(strcat(folderSolo,namePlayer, '/P2_player2_', int2str(x), '_1d.txt'),'r');
    
    data(x).nameFile = strcat('P2_player2_', int2str(x), '_1d.txt');        
    data(x).samples = fscanf(fileID, '%d %f', [2 inf])'; size = [2 inf];
    
    fclose(fileID);    
    
    save(strcat(namePlayer,'.mat'), 'data');
end

disp('All done!');

% MANUALLY FOR EACH PLAYER/TRIAL CREATES a *.mat datafile ! :)