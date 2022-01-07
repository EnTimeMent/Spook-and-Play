% CHRONOS_4 : 
% 1. TimeInSync, TimeToSync ...

clear all; clc; close all;

GLOBAL_CHRONOS;
% DATA Structure

D = load('OP_NC_DG.mat'); %,'OPMT','EMOTIg','NCYCLg','DISTGg');
OPMT = D.OPMT;
EMOTIg = D.EMOTIg;
NCYCLg = D.NCYCLg;
DISTGg = D.DISTGg;

% EMOTIg{group, trial} - four emotions of PERSONS in group for this trial
% NCYCLg{group, trial} - number of cycles of PERSONS in group for this trial
% DISTGg{group, trial} - distances between SYNC group and SYNC group \ Pi

group = 1; trial = 15;
opmt_gt=OPMT{group,trial};
e_gt = cell2mat(EMOTIg(group, :));
n_gt = cell2mat(NCYCLg(group, :));
d_gt = cell2mat(DISTGg(group, :));

person = 1;
END_p = [e_gt(person,:)',n_gt(person,:)',d_gt(person,:)']

% ANOVAS 11
[pn1,tbln1,stn1] = anova1(END_p(:,2),END_p(:,1))
ylabel('Nb of Cycles'), title('Person 1,group1')
[pn2,tbln2,stn2] = anova1(END_p(:,3),END_p(:,1))
ylabel('SYNC distances')

% Q1. Does the number of CYCLES vary with emotion
EMOT = cell2mat(EMOTIg); ZEMOT = EMOT(:);
[zemot,izemot] = sort(ZEMOT);
NCYCL = cell2mat(NCYCLg); ZNCYCL = NCYCL(:);
zncycl = ZNCYCL(izemot);
ax = 1 : length(zemot);
[RHO1,PVAL1] = corr(zemot, zncycl)
figure(1)
plot(ax,zemot,'-k', ax,zncycl,'-r')
legend('Emotions','NbCycles')

% Q2. Does the SYNC dist to the group SYNC vary with EMOTION
DIST = cell2mat(DISTGg); ZDIST = DIST(:);
zdist = ZDIST(izemot);
ax = 1 : length(zemot);
[RHO2,PVAL2] = corr(zemot, zdist)
figure(2)
plot(ax,zemot,'-k', ax,zdist,'-r')
legend('Emotions','Sync Dist')

% ANOVAS
[pn1,tbln1,stn1] = anova1(zncycl,zemot)
ylabel('Nb of Cycles')
[pn2,tbln2,stn2] = anova1(zdist,zemot)
ylabel('SYNC distances')



