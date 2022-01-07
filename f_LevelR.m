function [level,thrlevel] = f_LevelR(opmt)

% Author: CC + SJ
% Input:
% opmt = orderParamTime: degree of phase synchronization in time
% Output:
% - LevelR: level of phase synchronization.
% We discretize the order parameters into four phase-synchronization
% bandwidth = [0, 0.7, 0.85, 0.95, 1] MANUAL :) !
% 1. orderParamTime(k) < 0.7            (not in sync),
% 2. 0.70 < orderParamTime(k) < 0.85    (weak synchronization),
% 3. 0.85 < orderParamTime(k) < 0.95    (medium synchronization),
% 4. 0.95 < orderParamTime(k)           (high synchronization)
%
% For a given trial, we denote Tsync_r,i as the number of sampling instants
% such that bandwidth(k) =i, and the corresponding fraction Fsync,i=Tsync,i/T, for i=1,...,4.
% We computed TTS only for trials in which Fsync,1 > 0.5 in order to exclude from the
% analysis the trials in which synchronization was only occasionally achieved
% and then the trial was considered an instance of Not in Synchronization.
% The remaining trials were classified as follows:
% 1.if Fsync,2+Fsync,3>0.75(1?Fsync,1), then the trial was considered as an instance of Medium synchronization;
% 2.if FSync,3+FSync,4>0.75(1?Fsync,1), then the trial was considered as an instance of High synchronization;
% 3.if neither condition 1 nor 2 are satisfied, then the trial is considered as an instance of Weak synchronization

GLOBAL_CHRONOS;

T = length(opmt);

%Level_rand=0.35;
% see SYNCTHRESHOLD; bandwidth=[0.7 0.85 0.95];
% see SYNCLEVELS % Msg = {'Not in sync','Weak','Medium','High'};

% Order Parameter Analysis
SYNCLEVELS = fieldnames(SYNCTHRESHOLD);
nlevels = length(SYNCLEVELS);
rr = zeros(1,nlevels - 1);
for k = 2 : nlevels
    bwk = getfield(SYNCTHRESHOLD,SYNCLEVELS{k});
    Ibwk = and(opmt >= bwk(1), opmt < bwk(2));
    rr(k - 1) = sum(Ibwk);
end
% [r1,~] = find(opmt>=bandwidth(1) & opmt<bandwidth(2)); % weak
% [row2_r,~] = find(opmt>=bandwidth(2) & opmt<bandwidth(3)); % medium
% [row3_r,~] = find(opmt>=bandwidth(3)); % high

% rr = [length(row1_r) length(row2_r) length(row3_r)];
frr = rr / sum(rr); %[rr(1)/sum(rr) rr(2)/sum(rr) rr(3)/sum(rr)]; %time spent by the group in each slot
frr = [1-sum(frr), frr];

if (sum(rr)/T < 0.5)
    % NoSync
    level = SYNCLEVELS{1}; % 'nosync'
    bwk = getfield(SYNCTHRESHOLD,level);
    thrlevel = min(bwk);
    
    % Otherwise
else
    
    % 48% is the time ordPar >= 0.7 with random phases taken in [0,pi]
    % Checked to exclude from the analysis the trials
    % in which synchronization was only occasionally achieved.
    
    if max(frr) > 0.75 % a NET winner
        [~,IndLevel_r] = max(frr);
    else
        
        IndLevel_r = 2;
        temp = [frr(2) + frr(3); frr(3) + frr(4)];
        if max(temp) > 0.75
            [~,lev] = max(temp);
            if lev == 1
                IndLevel_r = 3;
            else
                IndLevel_r = 4;
            end
        end
    end
    level= SYNCLEVELS{IndLevel_r};
    bwk = getfield(SYNCTHRESHOLD,level); thrlevel = min(bwk);
end
