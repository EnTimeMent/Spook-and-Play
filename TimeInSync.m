function [TIS]=TimeInSync(orderParamTime, Period, NumbPer, sampFreq)

% Author: Carmela Calabrese
% Input:
% - orderParamTime: degree of phase synchronization in time after the removal of
%                   the perceptual stimuli (e.g., visual/acoustic coupling)
%
% Output:
% - TIS: time in synchronization after the removal of the perceptual
%        stimuli. It is the first time instant such that Levelr<Weak if the
%        players stayed in sync (Levelr>Weak) after closing their eyes for at
%        least 3 consecutive period

PeriodInSamp = round(NumbPer*Period*sampFreq);
Level_r_min = 0.7;

temp = length(find(orderParamTime > Level_r_min));

TIS = 0;
if(temp >= PeriodInSamp), TIS = temp/sampFreq; end