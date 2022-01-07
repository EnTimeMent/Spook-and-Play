% GLOBAL_CHRONOS

global NGROUPS GROUPSIZE NTRIALS;
NGROUPS = 15; GROUPSIZE = 4; NTRIALS = 54;

global TRIALDURATION TRIALFREQUENCY IND30SEC;
TRIALDURATION = 45; % Seconds
TRIALFREQUENCY = 55; % Hertz
IND35SECS = 35 * TRIALFREQUENCY;
global TABLETRIALEMOTDELAY;
global Parameters;
global YCOLS;
YCOLS = struct('person',1,'group',2,'player',3,'trial',4,'emot',5,'delay',6);
global SYNCTHRESHOLD SYNCLEVELS STHRESH;    
SYNCTHRESHOLD = struct('nosync',[0,0.5025],'weaksync',[0.5025,0.6650],...
                'mediumsync',[0.6650, 0.8274],'highsync',[0.8274,1]);
SYNCLEVELS = fieldnames(SYNCTHRESHOLD);
STHRESH = [0.5025, 0.6650, 0.8274] ;

global EMOT;
EMOT = struct('POSITIVE',1,'NEUTRAL',0,'NEGATIVE',-1);
% FOR US
% CUT yI = [0 NOSYNC 0.5 WEAKSYNC 0.6667 MEDIUMSYNC 0.8333 HIGHSYNC 1]
% ICDF =   [0  NOSYNC .9431 WEAKSYNC 0.9685 MEDIUMSYNC 0.9851 HIGHSYNC Inf]
% SYNCTHRESHOLD = struct('nosync',[0,0.7],'weaksync',[0.7,0.85],...
% CC           'mediumsync',[0.85, 0.95],'highsync',[0.95, 1]);  
            