% CHRONOS_3_g : 

% All calculation for global signal

GLOBAL_CHRONOS;
% DATA Structure
D = load('DATAXFILTPHASES.mat')%,'DATA','XF','XPHASES')
DATA = D.DATA; 
%                    Name: 'Chronos'
%     TABLETRIALEMOTDELAY: [54×6 table]
%                 YHeader: {'person'  'group'  'player'  'trial'  'emot'  'delay'}
%                       Y: [3240×6 double]
%         PERCENTMISSVALS: [3240×1 double]
%         UNIQUETINTERVAL: [2475×1 double]
        
% DATA.YHeader:{'person'}, {'group'},{'player'},{'trial'},{'emot'},{'delay'}
% XF, XPHASES - 2475 (Time)x (3240 = Ngroups 15 x Ntrials 54 x SizeGroup 4)

Y = DATA.Y;
UT = DATA.UNIQUETINTERVAL;
XF = D.XF; % Maybe USELESS
XPHASES = D.XPHASES;  clear D

Parameters.Visu = false; true;
Parameters.nofig = 0;
Parameters.GlobalOrDelay = 'delay';'global'; 
Parameters.TypicalCycleDuration = 1.5; % seconds SEE below
Parameters.NumbCyclesinSync = 3; % ?? significant nb. of cycles group is able to keep in sync

% IV GROUP
EMO_GROUP1 = zeros(NGROUPS,NTRIALS); % Aggregation of group EMOTION by Dist 2 group global
EMO_GROUP2 = zeros(NGROUPS,NTRIALS); % Aggregation of group EMOTION by Dist 2 group global
TTS_H = zeros(NGROUPS,NTRIALS); % Time To Sync global High
TTS_M = zeros(NGROUPS,NTRIALS); % Time To Sync global Medium
TTS_W = zeros(NGROUPS,NTRIALS); % Time To Sync global Weak
TIS_H = zeros(NGROUPS,NTRIALS); % Time In Sync global High
TIS_M = zeros(NGROUPS,NTRIALS); % Time In Sync global Medium
TIS_W = zeros(NGROUPS,NTRIALS); % Time In Sync global Weak
OPA = cell(NGROUPS,NTRIALS);    % Order PArameter global
OPAmedian = zeros(NGROUPS,NTRIALS); % median values of order parameter
OPAstd = zeros(NGROUPS,NTRIALS); % standard deviations of order parameter
NCY = zeros(NGROUPS,NTRIALS);   % Number of CYcles global
DCY = zeros(NGROUPS,NTRIALS);   % Duration of CYcles global

% IV INDIVIDUAL - Dist To Sync, Number of Cycles, Duration of Cycle
N = NGROUPS * NTRIALS * GROUPSIZE ;
SIMG_NC_DC = zeros(N,7); cptind = 0;
SIMG_NC_DCHeader = {'group','trial','person','emot','similarity_to_group','nbcycles','cycleduration'};

% SIMG_NC_DC(cptind,1) = group;
% SIMG_NC_DC(cptind,2) = trial;
% SIMG_NC_DC(cptind,3) = person;
% SIMG_NC_DC(cptind,4) = emot;
% SIMG_NC_DC(cptind,5) = similarity_to_group; the BIGGER the nearer this person is
% to group
% SIMG_NC_DC(cptind,6) = nbcycles
% DTS_NC_DC(cptind,7) = cycleduration

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
        
        disp([group,trial]), disp(emot_gt')
        
        % 0. Number of cycles for all participants of this (group, trial)
        % variant _g(lobal), _d(elay)
        Xgt = XF(:,Igt); [tgt,cgt] = size(Xgt);                
        
        if strcmp(Parameters.GlobalOrDelay, 'global')
            ind_delay1 = 1; ind_delay2 = tgt;
            trialduration = TRIALDURATION;            
        end
        if strcmp(Parameters.GlobalOrDelay, 'delay')
            ind_delay1 = unique(delay_gt) * TRIALFREQUENCY;
            ind_delay2 = ind_delay1 + IND35SECS;
            trialduration = 35;            
        end
        
        % Correct UT
        Xgt = Xgt(ind_delay1 : ind_delay2,:);
        ut = UT(ind_delay1 : ind_delay2); ut = ut - ut(1);
                       
        nbcycles = zeros(cgt,1);
        for participant = 1 : cgt            
            minh = mean(abs(Xgt(:,participant)));
            [pk, lk] = findpeaks(Xgt(:,participant),ut, 'MinPeakHeight', 0.1, 'MinPeakDistance', 0.6);
            nbcycles(participant) = length(lk);            
        end        

        % Update        
        NbGCycles = round(mean(nbcycles));               
        Parameters.TypicalCycleDuration = trialduration / NbGCycles;
        NCY(group,trial) = NbGCycles;   % Number of CYcles global
        DCY(group,trial) = trialduration / NbGCycles;   % Duration of CYcles global
        
        % 1. Extract the phase matrix of GROUPSIZE players in group for trial        
        Pgt = XPHASES(ind_delay1:ind_delay2,Igt)';        
        % 2. OrderParamTime = degree of phase synchronization in time
        [opmt, orderParam, timephase] = orderParameter(Pgt); 
        
        % Keep right the index of opmt
        %opmt = opmt(ind_delay1:ind_delay2);        
        
        % DISTGgt
        ind_delay = unique(delay_gt) * TRIALFREQUENCY;
        SIMGgt = f_DistSyncGSyncGminusOne(Pgt);%,ind_delay);        
        
        % Update Dist To Sync, Number of Cycles, Duration of Cycle
        for participant = 1 : GROUPSIZE
            cptind = cptind + 1;
            SIMG_NC_DC(cptind,1) = group_gt(participant); 
            SIMG_NC_DC(cptind,2) = trial_gt(participant); 
            SIMG_NC_DC(cptind,3) = person_gt(participant);
            SIMG_NC_DC(cptind,4) = emot_gt(participant);
            SIMG_NC_DC(cptind,5) = SIMGgt(participant); 
            SIMG_NC_DC(cptind,6) = nbcycles(participant); 
            SIMG_NC_DC(cptind,7) = trialduration / nbcycles(participant);
        end
        
        % GROUP        
        % EMO_GROUP - One aggregation
        % emot_gt, DGgt
        E = emot_gt' + 2; % bring to values 1, 2, 3
        un = ones(1,GROUPSIZE);
        ee = E * SIMGgt / (un * SIMGgt) - 2;        
        EMO_GROUP1(group,trial) = round(1.5 * ee);
        
        [zz,izz] = max(SIMGgt);
        EMO_GROUP2(group,trial) = emot_gt(izz);
        
        OPA{group,trial} = opmt;
        OPAmedian(group,trial) = median(opmt);
        OPAstd(group,trial) = std(opmt);
        
        DT = UT(2) - UT(1);
        synclevel = getfield(SYNCTHRESHOLD,'weaksync');
        TTS_W(group,trial) = f_TimeToSync(opmt,synclevel,ut);
        TIS_W(group,trial) = f_TimeInSync(opmt,DT,synclevel);
        
        synclevel = getfield(SYNCTHRESHOLD,'mediumsync');
        TTS_M(group,trial) = f_TimeToSync(opmt,synclevel,ut);
        TIS_M(group,trial) = f_TimeInSync(opmt,DT,synclevel);
        
        synclevel = getfield(SYNCTHRESHOLD,'highsync');
        TTS_H(group,trial) = f_TimeToSync(opmt,synclevel,ut);
        TIS_H(group,trial) = f_TimeInSync(opmt,DT,synclevel);        
                
        if Parameters.Visu
            thr1 = STHRESH(1) + zeros(1,length(opmt));
            thr2 = STHRESH(2) + zeros(1,length(opmt));
            thr3 = STHRESH(3) + zeros(1,length(opmt));
            
            xdelay = [delay_gt(1), delay_gt(1)];
            ydelay = [0,1];
            
            figure(3), clf
            subplot(311), plot(ut,Xgt')
            ylabel('X'), xlabel('Time [s]')
            subplot(312),plot(ut,Pgt'), 
            ylabel('Phases'), xlabel('Time [s]')
            title(['Group / Trial: ', num2str([group,trial])])
            subplot(313)
            plot(ut,opmt,'-k',ut,thr1,'-b',ut,thr2,'-g',ut,thr3,'-r',xdelay,ydelay,':k','LineWidth',1)
            ylabel(['Order Parameter'])%, Level: ',level]),
            xlabel('Time [s]')
            legend('Order Parameter','Weak Sync','Medium Sync','High Sync','Delay')
            
            tts_h = TTS_H(group,trial);
            tts_m = TTS_M(group,trial);   
            tts_w = TTS_W(group,trial);   
            tis_h = TIS_H(group,trial);
            tis_m = TIS_M(group,trial);   
            tis_w = TIS_W(group,trial);   
            
            title(['Group / Trial: ', num2str([group,trial])])%,, T2S_glob / TIS: ', num2str([tts_global,tis])])
            % get(0, 'CurrentFigure');
            ttt = {['TTS_H: ', sprintf('%.3f  ', tts_h)],...
                ['TTS_M: ', sprintf('%.3f  ', tts_m)],...
                ['TTS_W: ', sprintf('%.3f  ', tts_w)],...
                ['TIS_H: ', sprintf('%.3f  ', tis_h)],...
                ['TIS_M: ', sprintf('%.3f  ', tis_m)],...
                ['TIS_W: ', sprintf('%.3f  ', tis_w)]};
                %['TISglobalHi: ', sprintf('%.3f  ', tis_global_Hi)],...
                %['TTSdelayHi: ', sprintf('%.3f  ', tis_delay_Hi)]};
            text(-6, 0.5, ttt, 'FontSize', 10, 'Color', 'k');
            grid on
        end

        'wait' 
    end
end

% IV GROUP
figure(1)
subplot(121),histogram(EMO_GROUP1(:))
subplot(122),histogram(EMO_GROUP2(:))
EMO_GROUP = EMO_GROUP2;
name = 'EMO_GROUP'; filename = [name,Parameters.GlobalOrDelay,'.csv'];
save(filename,name,'-ascii')
name = 'TTS_H'; filename = [name,Parameters.GlobalOrDelay,'.csv'];
save(filename,name,'-ascii')
name = 'TTS_M'; filename = [name,Parameters.GlobalOrDelay,'.csv'];
save(filename,name,'-ascii')
name = 'TTS_W'; filename = [name,Parameters.GlobalOrDelay,'.csv'];
save(filename,name,'-ascii')
name = 'TIS_H'; filename = [name,Parameters.GlobalOrDelay,'.csv'];
save(filename,name,'-ascii')
name = 'TIS_M'; filename = [name,Parameters.GlobalOrDelay,'.csv'];
save(filename,name,'-ascii')
name = 'TIS_W'; filename = [name,Parameters.GlobalOrDelay,'.csv'];
save(filename,name,'-ascii')

name = 'OPA'; filename = [name,Parameters.GlobalOrDelay,'.mat'];
save(filename,name)
name = 'OPAmedian'; filename = [name,Parameters.GlobalOrDelay,'.csv'];
save(filename,name,'-ascii')
name = 'OPAstd'; filename = [name,Parameters.GlobalOrDelay,'.csv'];
save(filename,name,'-ascii')

name = 'NCY'; filename = [name,Parameters.GlobalOrDelay,'.csv'];
save(filename,name,'-ascii')
name = 'DCY'; filename = [name,Parameters.GlobalOrDelay,'.csv'];
save(filename,name,'-ascii')

% % IV INDIVIDUAL - Dist To Sync, Number of Cycles, Duration of Cycle
% name = 'DTS_NC_DC'; filename = [name,Parameters.GlobalOrDelay,'.csv'];
% save(filename,name,'-ascii')
