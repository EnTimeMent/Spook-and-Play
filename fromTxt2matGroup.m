% A COMMENT HERE ... ?

clc, clear all, close all

folderGroup = 'Group3/'; % MANUAL ?
numPlayers = 6; % GROUPSIZE

nameTop = input('Insert the name of the topology without spaces: ', 's');
indexTrial = input('Insert the number of the trial without spaces: ');

for indexPlayer = 1 : numPlayers
    
    fileID = fopen(strcat(folderGroup,nameTop, '/',nameTop,'Trial',num2str(indexTrial),'/P6_player',int2str(indexPlayer) , '_1d.txt'),'r');
    
    data(indexPlayer).nameFile = strcat('P6_player', int2str(indexPlayer), '_1d.txt');        
    data(indexPlayer).samples = fscanf(fileID, '%d %f', [2 inf])'; % size = [2 inf];
    fclose(fileID);    
end

save(strcat('dataGroup3_', nameTop,'_Trial',num2str(indexTrial),'.mat'), 'data');

% WOW ! MANUAL: FOR EACH GROUP/TOPOLOGY/TRIAL creates a data*.mat file
% Visualize
% hold on
% plot(data(1).samples(:,2)), plot(data(2).samples(:,2)), plot(data(3).samples(:,2))
% plot(data(4).samples(:,2)), plot(data(5).samples(:,2)), plot(data(6).samples(:,2)),
disp('All done!');