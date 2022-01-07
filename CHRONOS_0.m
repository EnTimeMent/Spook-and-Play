% CHRONOS_0 : 
% 1. Read and organize Chronos data into *.mat format


clear all; clc; close all;

GLOBAL_CHRONOS;

fname = 'Chronos_trial_order.csv';
dline = [2, 56];
TABLETRIALEMOTDELAY = f_ImportTED(fname, dline);


% path/to/input/directory
% pathDATA = '/Users/marta.bienkiewicz/Desktop/spook_n_play_data_for_processing/bulk_GMS_files/';
% pathDATA = 'E:\MB\Data\bulk_GMS_files\';
% pathDATA = '\\159.31.103.1\janaqi\Documents\artikuj\_These_AS\Data\bulk_GMS_files\';
pathDATA = 'D:\_These_AS\Data\bulk_GMS_files\';
% path/to/output/file
% output = '/Users/marta.bienkiewicz/Desktop/spook_n_play_data_for_processing/bulk_GMS_files/GroupData.mat';  % % % .mat file

% DATA Structure
N = NGROUPS * GROUPSIZE * NTRIALS;
DATA.Name = 'Chronos';
DATA.TABLETRIALEMOTDELAY = TABLETRIALEMOTDELAY;
DATA.YHeader = {'person','group','player','trial','emot','delay'}; 
DATA.Y = zeros(N,6);
DATA.LEAP = cell(N,1);

% % % initialize
person = 0; row = 0;
for group = 1 : NGROUPS
    
    sg = num2str(group);
    if group < 10, sg = ['0',sg]; end
    
    for player = 1 : GROUPSIZE
        
        spl = num2str(player);
        % Identify Person 1 : 60
        person = person + 1;
        sp = num2str(person);
        if person < 10, sp = ['0',sp]; end
        
        % Create data filename
        dfn = ['P',sp,'_G',sg,'_player',spl,'_1d.txt'];        
        F = load([pathDATA,dfn]); [nf,df] = size(F);
        
        % Cut F in trials
        % Detect the cut points
        cutpoints = find(F(:,1) == -1);
        notrials = F(cutpoints,2);
        
        
        for trial = 1 : NTRIALS
            
            % EMOT DELAY
            ed  = table2array(TABLETRIALEMOTDELAY(trial,:));
            em = ed(2:5); delay = ed(6);
            emot = em(player);                        
            r1 = cutpoints(trial) + 1;
            r2 = nf;
            if trial < NTRIALS
                r2 = cutpoints(trial + 1) - 1;
            end
            
            row = row + 1;
            DATA.Y(row,:) = [person,group,player,trial,emot,delay];
            XT = F(r1 : r2,:);
            DATA.LEAP{row} = XT;
            disp([row,size(XT)])
        end
    end
end
zz = unique(DATA.Y(:,YCOLS.emot))
save('CHRONOSDATA.mat','DATA')

