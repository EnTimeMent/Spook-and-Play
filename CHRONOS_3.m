% CHRONOS_3 : 
% 1. TimeInSync, TimeToSync ...

% clear all; clc; close all;

GLOBAL_CHRONOS;
% DATA Structure
D = load('DATAXFILTPHASES.mat')%,'DATA','XF','XPHASES')
DATA = D.DATA; 
%                    Name: 'Chronos', TABLETRIALEMOTDELAY: [54×6 table]
%                 YHeader: {1×6 cell},Y: [3240×6 double]
%         PERCENTMISSVALS: [3240×1 double]
%         UNIQUETINTERVAL: [2475×1 double]
% DATA.YHeader:{'person'}, {'group'},{'player'},{'trial'},{'emot'},{'delay'}
% XF, XPHASES - 2475 (Time)x (3240 = Ngroups 15 x Ntrials 54 x SizeGroup 4)
Y = DATA.Y;
UT = DATA.UNIQUETINTERVAL;
XF = D.XF; % Maybe USELESS
XPHASES = D.XPHASES;  clear D

Parameters.Visu = true; false;   
Parameters.nofig = 0;
Parameters.TypicalCycleDuration = 1.5; % seconds SEE below
Parameters.NumbCyclesinSync = 3; % ?? significant nb. of cycles group is able to keep in sync

% Three tables for further analysis
% EMOTIg{group, trial} - four emotions of PERSONS in group for this trial
EMOTIg = cell(NGROUPS,NTRIALS);
% NCYCLg{group, trial} - number of cycles of PERSONS in group for this trial
NCYCLg = cell(NGROUPS,NTRIALS);
% DISTGg{group, trial} - distances between SYNC group and SYNC group \ Pi
DISTGg = cell(NGROUPS,NTRIALS);

% IV GROUP
EMO_GROUP_g = zeros(NGROUPS,NTRIALS); % Aggregation of group EMOTION by Dist 2 group global
EMO_GROUP_d = zeros(NGROUPS,NTRIALS); % Aggregation of group EMOTION by Dist 2 group delay
TTS_g_H = zeros(NGROUPS,NTRIALS); % Time To Sync global High
TTS_g_M = zeros(NGROUPS,NTRIALS); % Time To Sync global Medium
TTS_g_W = zeros(NGROUPS,NTRIALS); % Time To Sync global Weak
TTS_d_H = zeros(NGROUPS,NTRIALS); % Time To Sync delay High
TTS_d_M = zeros(NGROUPS,NTRIALS); % Time To Sync delay Medium
TTS_d_W = zeros(NGROUPS,NTRIALS); % Time To Sync delay Weak
TIS_g_H = zeros(NGROUPS,NTRIALS); % Time In Sync global High
TIS_g_M = zeros(NGROUPS,NTRIALS); % Time In Sync global Medium
TIS_g_W = zeros(NGROUPS,NTRIALS); % Time In Sync global Weak
TIS_d_H = zeros(NGROUPS,NTRIALS); % Time In Sync delay High
TIS_d_M = zeros(NGROUPS,NTRIALS); % Time In Sync delay Medium
TIS_d_W = zeros(NGROUPS,NTRIALS); % Time In Sync delay Weak
OPA_g = cell(NGROUPS,NTRIALS);    % Order PArameter global
OPA_d = cell(NGROUPS,NTRIALS);    % Order PArameter delay
NCY_g = zeros(NGROUPS,NTRIALS);   % Number of CYcles global
NCY_d = zeros(NGROUPS,NTRIALS);   % Number of CYcles delay
DCY_g = zeros(NGROUPS,NTRIALS);   % Duration of CYcles global
DCY_d = zeros(NGROUPS,NTRIALS);   % Duration of CYcles delay

% IV INDIVIDUAL
N = NGROUPS * NTRIALS * GROUPSIZE ;
DTS_NC_DC_g = zeros(N,10); % Dist To Sync, Number of Cycles, Duration of Cycle
DTS_NC_DC_d = zeros(N,10); % Dist To Sync, Number of Cycles, Duration of Cycle
cptind = 0;

for group = 1 : NGROUPS
    for trial = 1 : NTRIALS
        
        Igt = and(Y(:,YCOLS.group) == group, Y(:,YCOLS.trial) == trial);
        
        % This section of Data
        % YCOLS = struct('person',1,'group',2,'player',3,'trial',4,'emot',5,'delay',6);
        person_gt = Y(Igt,YCOLS.person);
        group_gt = Y(Igt,YCOLS.group);
        player_gt = Y(Igt,YCOLS.player);
        trial_gt =  Y(Igt,YCOLS.trial);        
        emot_gt = Y(Igt,YCOLS.emot);
        delay_gt = Y(Igt,YCOLS.delay);
        
        % Update
        % EMOTIg{group,trial} = emot_gt;
        disp([group,trial]), disp(emot_gt')
        
        % for all _d results
        ind_delay1 = unique(delay_gt) * TRIALFREQUENCY;
        ind_delay2 = ind_delay1 + IND35SECS;
        
        
        % 0. Number of cycles for all participants of this (group, trial)
        % variant _g(lobal), _d(elay)
        Xgt = XF(:,Igt); [tgt,cgt] = size(Xgt);        
        nbcycles_g = zeros(cgt,1); nbcycles_d = zeros(cgt,1);
        for k = 1 : cgt
            % _g variant
            minh = mean(abs(Xgt(:,k)));
            [pk, lk] = findpeaks(Xgt(:,k),UT, 'MinPeakHeight', 0.1, 'MinPeakDistance', 0.6);
            nbcycles_g(k) = length(lk);
            
            % _d variant
            minh = mean(abs(Xgt(ind_delay1:ind_delay2,k)));
            [pk, lk] = findpeaks(Xgt(ind_delay1:ind_delay2,k),UT, 'MinPeakHeight', 0.1, 'MinPeakDistance', 0.6);
            nbcycles_d(k) = length(lk);            
        end        

        % Update
        NCYCLg{group,trial} = nbcycles_g;
        
        NbGCycles = round(mean(nbcycles_g));
        TYPICALCYCLEDURATION(group,trial) = TRIALDURATION / NbGCycles;
        Parameters.TypicalCycleDuration = TRIALDURATION / NbGCycles;
        
        % 1. Extract the phase matrix of GROUPSIZE players in group for trial
        
        Pgt = XPHASES(:,Igt)';        
        % 2. OrderParamTime = degree of phase synchronization in time
        [opmt, orderParam, timephase] = orderParameter(Pgt);                
        ORDERPARAMTIME{group,trial} = opmt;
        
        % DISTGg        
        DGg = f_DistSyncGSyncGminusOne(Pgt,ind_delay); 
        DISTGg{group,trial} = DGg;
        
        DTS_NC_DC_g = zeros(N,10); % Dist To Sync, Number of Cycles, Duration of Cycle
        DTS_NC_DC_d = zeros(N,10); % Dist To Sync, Number of Cycles, Duration of Cycle
        cptind = 0;
        
        % Calculate TTS and TIS for all conditions
        % [level,thrlevel] = f_LevelR1(opmt);
                
        TTS_g_H(group,trial) = f_TimeToSync(opmt, thrlevel, UT,[]);
        TTS_delay(group,trial) = f_TimeToSync(opmt, thrlevel, UT,ind_delay);
        
        DT = UT(2) - UT(1);
        synclevel = getfield(SYNCTHRESHOLD,'weaksync');
        TIS_g_W(group,trial) = f_TimeInSync(opmt,DT,synclevel,[]);
        TIS_d_W(group,trial) = f_TimeInSync(opmt,DT,synclevel,ind_delay);
        synclevel = getfield(SYNCTHRESHOLD,'mediumsync');
        TIS_g_M(group,trial) = f_TimeInSync(opmt,DT,synclevel,[]);
        TIS_delay_Md(group,trial) = f_TimeInSync(opmt,DT,synclevel,ind_delay);
        synclevel = getfield(SYNCTHRESHOLD,'highsync');
        TIS_global_Hi(group,trial) = f_TimeInSync(opmt,DT,synclevel,[]);        
        TIS_delay_Hi(group,trial) = f_TimeInSync(opmt,DT,synclevel,ind_delay);                
        
        if Parameters.Visu
            thr1 = STHRESH(1) + zeros(1,length(opmt));
            thr2 = STHRESH(2) + zeros(1,length(opmt));
            thr3 = STHRESH(3) + zeros(1,length(opmt));
            xdelay = [delay_gt(1), delay_gt(1)];
            ydelay = [0,1];
            
            figure(3), clf
            subplot(211),plot(Pgt'), 
            ylabel('Phases'), xlabel('Time [s]')
            title(['Group / Trial: ', num2str([group,trial])])
            subplot(212)
            plot(UT,opmt,'-k',UT,thr1,'-b',UT,thr2,'-g',UT,thr3,'-r',xdelay,ydelay,':k','LineWidth',1)
            ylabel(['Order Parameter'])%, Level: ',level]),
            xlabel('Time [s]')
            legend('Order Parameter','Weak Sync','Medium Sync','High Sync','Delay')
            
            % tts/tis
            tts_global = TTS_g_H(group,trial);
            tts_delay = TTS_delay(group,trial);            
            tis_global_Wk = TIS_g_W(group,trial);
            tis_delay_Wk = TIS_d_W(group,trial);        
            tis_global_Md = TIS_g_M(group,trial);
            tis_delay_Md = TIS_delay_Md(group,trial);
            tis_global_Hi = TIS_global_Hi(group,trial);
            tis_delay_Hi = TIS_delay_Hi(group,trial);
            
            title(['Group / Trial: ', num2str([group,trial])])%,, T2S_glob / TIS: ', num2str([tts_global,tis])])
            % get(0, 'CurrentFigure');
            ttt = {['TTSglobal: ', sprintf('%.3f  ', tts_global)],...
                ['TTSdelay: ', sprintf('%.3f  ', tts_delay)],...
                ['TISglobalWk: ', sprintf('%.3f  ', tis_global_Wk)],...
                ['TISdelayWk: ', sprintf('%.3f  ', tis_delay_Wk)],...
                ['TISglobalMd: ', sprintf('%.3f  ', tis_global_Md)],...
                ['TISdelayMd: ', sprintf('%.3f  ', tis_delay_Md)],...
                ['TISglobalHi: ', sprintf('%.3f  ', tis_global_Hi)],...
                ['TTSdelayHi: ', sprintf('%.3f  ', tis_delay_Hi)]};
            text(-6, 0.5, ttt, 'FontSize', 10, 'Color', 'k');
            grid on
        end
%         disp([group,trial])
%         disp(level)

        'wait' 
    end
end

OPMT = ORDERPARAMTIME;
save('OP_NC_DG.mat','OPMT','EMOTIg','NCYCLg','DISTGg','TIS','TTS');

save('TTS_global.csv','TTS_global','-ascii')
save('TTS_delay.csv', 'TTS_delay','-ascii')
save('TIS_global_Wk.csv','TIS_global_Wk','-ascii')
save('TIS_delay_Wk.csv', 'TIS_delay_Wk','-ascii')
save('TIS_global_Md.csv','TIS_global_Md','-ascii')
save('TIS_delay_Md.csv', 'TIS_delay_Md','-ascii')
save('TIS_global_Hi.csv','TIS_global_Hi','-ascii')
save('TIS_delay_Hi.csv','TIS_delay_Hi','-ascii')

% hist(OPMT,101)
