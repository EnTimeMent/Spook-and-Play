function [test1] = f_RPeakDetection(Group, Condition, Trial, Participant)

% clf

% Group 7: trial 2 P1 + trial 3 P2
% Group 8: trial 1 P3 + Trial 3 P2 + Trial 4 P3
%
% 5th column is Group#, 6th column is Trial# and 7th column is the
% condition (e.g., Group = 1 & Solo = 2)

% Group = 8; % Trial = 4; % Condition = 1;

global Where_cut D;

C = Where_cut(Where_cut(:, 5) == Group & Where_cut(:, 6) == Trial & Where_cut(:, 7) == Condition, :);

from_here = C(:, 3);  to_here = C(:, 4); % Index of rows to cut

% This will indicate the column number from where to retrive the corresponding data
% 1 column P1 time; 2 column P1 ECG; 3 column P2 time; 4
% column P2 ECG; 5 column P3 time; 6 column P3 ECG

if  Participant == 1
        Participant_col = 2;  Participant_name = 'P1.csv';
elseif Participant == 2
        Participant_col = 4; Participant_name = 'P2.csv';
elseif Participant == 3
        Participant_col = 6; Participant_name = 'P3.csv';
end

sig = D(from_here:to_here, Participant_col);
tm = D(from_here:to_here,1);

% OPTION  2. from here https://www.youtube.com/watch?v=J2wSPZZLKTw
% % Program to get QRS Peaks and Hear Rate from ECG signal
% [filename, pathname] = uigetfile('*.*', 'Select the ECG Signal');
% filewithpath = strcat(pathname,filename)%
% Fs = input('Enter Sampling Rate: '); 
Fs = 2148; % This is global
% ecg = load(filename); % Reading ECG signal
% ecgsig = (ecg.val)./200; % normalize gain
% ecgsig = (sig)./200; % normalize gain
ecgsig = sig; t = 1 : length(ecgsig); % No. of samples
tx = t./Fs; % Getting Time vector

wt = modwt(ecgsig, 4, 'sym4'); %  4-level undecimated DWT using sym4
wtrec = zeros(size(wt));
wtrec(4:5,:) = wt(4:5,:); % Extracting only d3 and d4 coefficients NOT REALLY/ because 4 & 5 give results

y = imodwt(wtrec, 'sym4'); % IDWT with only d3 and d4
y = abs(y).^2; % Magnitude square

avg = mean(y); % Getting the average of y^2 as threshold

% Finding Peaks
%[Rpeaks, locs] = findpeaks(y,t, 'MinPeakHeight', 8*avg, 'MinPeakDistance', 50);
% [Rpeaks, locs] = findpeaks(y,t, 'MinPeakHeight', 4*avg, 'MinPeakDistance', Fs * 0.3); % Fs * 0.3 means within the 30% of a second or 300 ms TRIAD 3
% SOLO TRIAL 2 Participant2
% [Rpeaks, locs] = findpeaks(y,t, 'MinPeakHeight', 8*avg, 'MinPeakDistance', 250); % Fs * 0.3 means within the 30% of a second or 300 ms

[Rpeaks, locs] = findpeaks(y,t, 'MinPeakHeight', 4*avg, 'MinPeakDistance', Fs * 0.333); % Fs * 0.3 means within the 30% of a second or 300 ms
% 0.333 because 60000/IBI (here I consider to take 180 bpm as a maximum)

nohb = length(locs); %No. of beats
timelimit = length(ecgsig)/Fs;
hbpermin = (nohb*60)/timelimit; % Getting BPM
disp(strcat('Heart Rate = ', num2str(hbpermin)));

% Displaying ECG signal and detected R-Peaks
subplot(211), plot(tx, ecgsig); xlim([0, timelimit]);
grid on; xlabel('Seconds'), title('ECG Signal')

subplot(212), plot(t,y), grid on; xlim([0, length(ecgsig)]);
hold on, plot(locs, Rpeaks, 'ro'), xlabel('Samples')
title(strcat('R peaks found and Heart Rate: ', num2str(hbpermin)))

%
test1 = diff(locs/Fs)';

Gr = num2str(Group, 'Triad%d_');
if Condition == 1, Con = 'Group_';  end
if Condition == 2, Con = 'Solo_'; end
Tr = num2str(Trial, 'Trial%d_');

Filename_to_save = strcat('C:\Work\PhD_Experiments\Exp1_EMOSYNC\RES\RR_Matlab_Wavelets\',Gr,Con,Tr,Participant_name);

% Save the RR interal as a separate file
writematrix(test1, Filename_to_save) ;

% CALCULATE how much is done
how_many_files_in_folder = numel(dir('C:\Work\PhD_Experiments\Exp1_EMOSYNC\RES\RR_Matlab_Wavelets\*.csv'));
num2str(how_many_files_in_folder, 'There are %d files created out of 1287')

end