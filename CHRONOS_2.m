% CHRONOS_2 : 
% 1. Filter (if needed) with butterwoth
% 2. Calculate instantaneous phases with Hilbert transform
% 3. Put parameters into GLOBAL_CHRONOS

clear all; clc; close all;

GLOBAL_CHRONOS;
% Load Local Data
% DATA Structure
D = load('FINALDATA.mat'); %,'DATA')
DATA = D.DATA; clear D
% DATA = 
%                    Name: 'Chronos'
%     TABLETRIALEMOTDELAY: [54×6 table]
%                 YHeader: {1×6 cell}
%                       Y: [3240×6 double]
%         PERCENTMISSVALS: [3240×1 double]
%         UNIQUETINTERVAL: [2475×1 double]
%                  FINALX: [2475×3240 double]
%                  
% ! Positions are in COLUMNS of FINALX

UT = DATA.UNIQUETINTERVAL;
X = DATA.FINALX; DATA = rmfield(DATA,'FINALX'); % gain memory
[T,N] = size(X); 

Parameters.Visu = false; true;
Parameters.nofig = 0;

% see InterpFiltData 
% Filtering_and_Cutting
XF = X ;  % filtered positions
DT = UT(2) - UT(1); % miliseconds
FREQ = round(1 / DT); %FREQ = 57; 
CUTOFFFREQ = 5; %the maximum frequency of players in group is 6.45 rad/s <-> 1.03Hz
[b,a] = butter(2, 2 * CUTOFFFREQ / FREQ, 'low'); %filter

for n = 1 : N   
    XF(:,n) = filtfilt(b,a,X(:,n)); %FiltPos = filtfilt(b,a,InterpPos');        
end

% Calculate PHASES
XPHASES = XF; % = zeros(num_players,num_time_instants);
for n =  1 : N %num_players 26 : 26
    disp(n)
    protophase = co_hilbproto(XF(:,n));
    [phases,~,~] = co_fbtrT(protophase);  %in [0,2*pi[
    X3PHASES(:,n) = phases;
    
    if Parameters.Visu
        Parameters.nofig = 1; %Parameters.nofig + 1;
        figure(Parameters.nofig), clf
        ICOL = 1 : 500;
        subplot(211)
        plot(UT(ICOL),X(ICOL,n),'-k',UT(ICOL),XF(ICOL,n),'-r'), legend('x','xfilt')
        title('Positions'), grid on
        
        subplot(212)
        plot(UT(ICOL),protophase(ICOL),'-k',UT(ICOL),phases(ICOL),'-r'), legend('protoPH','PH')
        title('Phases'), grid on
        'wait'
    end
end

% DATA.XF = XF;
% DATA.PHASES = PHASES;
DATA
save('DATAXFILTPHASES.mat','DATA','XF','XPHASES')
