% SOME COMMENT ... ?
% interpolation

clc, clear all, close all

% Solo parameters
%num_seconds = 30; num_players = 1;

% Group parameters
num_seconds = 75; num_players = 6;

% Common parameters
sampFreq = 100; DT = 10; % miliseconds
num_time_instants = num_seconds*sampFreq;
num_ms = num_seconds * 1000;

% Solo
% namePlayer = input('Insert the name of the player without spaces: ', 's');
% load(strcat(namePlayer,'.mat'))
% num_Trials = 10;
%
% for i = 1 : num_Trials
%     % Time Jump > 20000 indicates the end of that individual trial
%     % BUT this seems to be more a starting point of valid data
%     EndPoint = find(abs(diff(data(i).samples(:,1))) > 20000);
%     if any(EndPoint)
%         time = data(i).samples(EndPoint(end)+1:end, 1);
%         position = data(i).samples(EndPoint(end)+1:end, 2);
%     else
%         time = data(i).samples(:, 1);
%         position = data(i).samples(:, 2);
%     end
%     %interpolated_time = 0:num_time_instants-1;
%         interpolated_time = 0:DT:num_ms-1; % row vector; 75s to 100Hz
%         interpolated_position = spline(time, position, interpolated_time);   % row vector
%         data_interp(i).samples = [interpolated_time; interpolated_position]';
%         InterpPos(i,:)=interpolated_position';
% end
% save(strcat(namePlayer,'_interp.mat'), 'data');

% Group - WITHOUT THE TOPOLOGY ?
numGroup = input('Insert the number of the group: ', 's');
nameTrial = input('Insert the name of the trial without spaces: ', 's');
load(strcat('dataGroup', num2str(numGroup),'_',nameTrial,'.mat'))

% HERE num_players is not defined 
for i = 1 : num_players
    EndPoint = find(abs(diff(data(i).samples(:,1)))>50000);  %this part is useful to check picks in the signal
    if any(EndPoint)
        time = data(i).samples(EndPoint(end)+1:end, 1);
        position = data(i).samples(EndPoint(end)+1:end, 2);
    else
        time = data(i).samples(:, 1);
        position = data(i).samples(:, 2);
    end
        
    %interpolated_time = 0:num_time_instants-1;
    interpolated_time = 0:DT:num_ms-1; % row vector; 75s to 100Hz
    interpolated_position = spline(time, position, interpolated_time);   % row vector
    data_interp(i).samples = [interpolated_time; interpolated_position]';
    InterpPos(i,:)=interpolated_position';    
end
save(strcat(nameTrial,'_interp.mat'), 'data');

% Filtering_and_Cutting
CutOffFreq = 5; %the maximum frequency of players in group is 6.45 rad/s <-> 1.03Hz
[b,a] = butter(2, 2 * CutOffFreq / sampFreq, 'low'); %filter
FiltPos= filtfilt(b,a,InterpPos');
Positions = FiltPos;

%save(strcat('Solo_Positions_',namePlayer),'Positions') %solo
save(strcat('Positions_',nameTrial),'Positions') %group

phases = zeros(num_players,num_time_instants);

for k=1:num_players
    [protophase] = co_hilbproto(Positions(:,k));
    [phases(k,:),~,~] = co_fbtrT(protophase);  %in [0,2*pi[
end

save(strcat('Phases_',nameTrial),'phases') %group