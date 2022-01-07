
% ECG_load_and_filter :
% 1.
% 2.

clear all, close all

% Global Variables
global Where_cut D;
% come back 3 folders back then up 2 folders to get into the
% pathHRV = 'D:\_These_AS\Data\EMOSync\Physio_HRV\'; % BIG
pathHRV = '\\159.31.103.1\janaqi\Documents\artikuj\_These_AS\Data\EMOSync\Physio_HRV\'; % LITTLE
% cd ..\..\..\DAT\Physio_HRV
% tic
Where_cut = load('Trial_rows_indications_FINAL.csv'); %readmatrix('Trial_rows_indications_FINAL.csv');
% toc

% Group = 8;  % Condition = 1;
% Trial = 4;  % Condition 1 = 1:15; Condition 2 = 1:18
% Participant = P3; % P1, P2, P3

tic
for Group = 1:13 % There are 13 groups
    Filename_to_load = num2str((Group)', 'HRV_Groupe%d.csv');
    
    f = [pathHRV,Filename_to_load];
    D = readmatrix(f);
    
    
    for Condition = 1:2     % There are 2 conditions: 1 - group & 2 - solo
        
        if  Condition == 1
            N_Trials = 15; % Group trials
        elseif Condition == 2
            N_Trials = 18; % Solo trials
        end
        
        for Trial = 1:N_Trials % The N for Group & Solo trials respectively
            
            for Participant = 1:3
                
                % call the function
                f_RPeakDetection(Group, Condition, Trial, Participant)
                
            end
        end
    end
end
toc

