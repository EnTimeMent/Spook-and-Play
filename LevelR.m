function [level]=LevelR(orderParamTime)

% Author: Carmela Calabrese
% Input:
% - orderParamTime: degree of phase synchronization in time
%
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

T = length(orderParamTime);
%Level_rand=0.35;
bandwidth=[0.7 0.85 0.95];

Msg = {'Not in sync','Weak','Medium','High'};
% Order Parameter Analysis

[row1_r,~] = find(orderParamTime>=bandwidth(1) & orderParamTime<bandwidth(2)); % weak
[row2_r,~] = find(orderParamTime>=bandwidth(2) & orderParamTime<bandwidth(3)); % medium
[row3_r,~] = find(orderParamTime>=bandwidth(3)); % high

Tsync_r=[length(row1_r) length(row2_r) length(row3_r)];
Fsync=[Tsync_r(1)/sum(Tsync_r) Tsync_r(2)/sum(Tsync_r) Tsync_r(3)/sum(Tsync_r)]; %time spent by the group in each slot
Fsync=[1-sum(Fsync) Fsync];

if (sum(Tsync_r)/T>0.5) %48% is the time ordPar>=0.7 with random phases taken in [0,pi]
    %This condition is checked to exclude from the analysis the trials
    %in which synchronization was only occasionally
    %achieved.
    if (max(Fsync)>0.75)
        IndLevel_r=find(Fsync==max(Fsync));
    else
        temp=[Fsync(2)+Fsync(3);Fsync(3)+Fsync(4)];
        if (max(temp)>0.75)
            lev=find(temp==max(temp));
            if(lev==1)
                IndLevel_r=3;
            else
                IndLevel_r=4;
            end
        else
            IndLevel_r=2;
        end
    end
else
    IndLevel_r=1;
end
level= Msg(IndLevel_r);
end