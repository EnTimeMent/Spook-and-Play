function [TTS]=TimeToSync(orderParamTime, Period, NumbPer, level,sampFreq)

% Author: Carmela Calabrese
% Input:
% - orderParamTime: degree of phase synchronization in time
% - Period= typical period of the oscillation
% - NumbPer= minimum amount of period required to define synchronization
% - level= level of synchronization detected with LevelR.m (it does not
%          apply to trials 'Not in sync')
% - sampFreq= sampling frequency of the signal;
%
% Output:
% - TTS: time to synchronization, defined as the the first time instant such that
%        the order parameter enters in its detected LevelR

T=length(orderParamTime);
PeriodInSamp=round(NumbPer*Period*sampFreq); %it translates the minimum number of
% periods required in
% synchronization in samples

TTS = inf; %where it is not possible to define TTS, it is equal to infinity

% the following part translates the level in the minimum calue of order
% parameter for that bandwidth
if(strcmp(level,'Weak'))
    thr=0.7;
elseif(strcmp(level,'Medium'))
    thr=0.85;
elseif(strcmp(level,'High'))
    thr=0.95;
else
    disp('Incompatible level')
    return
end

for k=1:(T-PeriodInSamp)
    if(orderParamTime(k)>=thr)
        % once the algorithm has found the first time order parameter enters in
        % its level, it needs to check that it stays there for at least 3
        % periods (to avoid detection of fluctuation)
        Indexes=find(orderParamTime(k:(k+PeriodInSamp-1))>=thr);
        if(length(Indexes)==PeriodInSamp)
            TTS = k / sampFreq;
            break
        end
    end
end