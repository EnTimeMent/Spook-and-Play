% CHRONOS_1 : 
% 1. Fill missing data
% 2. Interpolate signals to unique TIME stamps

clear all; clc; close all;

GLOBAL_CHRONOS;
% Load Local Data
% DATA Structure
D = load('CHRONOSDATA.mat'); 
DATA = D.DATA; clear D
N = length(DATA.LEAP);
% DATA.Name = 'Chronos';
% DATA.YHeader = {'person','group','player','trial','emot','delay'}; 
% DATA.Y = zeros(N,6);
% DATA.LEAP = cell(N,1);

TABLETRIALEMOTDELAY = DATA.TABLETRIALEMOTDELAY;
Parameters.Visu = false; true;
Parameters.nofig = 0;

% 1. Fill Missing data
[LEAP,N0] = f_FillMissingData(DATA.LEAP);
DATA.NONMISSLEAP = LEAP;
DATA.PERCENTMISSVALS = N0;

% 2. Interpolate into a unified TIME interval
[T,X] = f_InterpolateUniqueTInterval(LEAP);
DATA.UNIQUETINTERVAL = T; % in seconds
DATA.FINALX = X; % in centimeters
DATA = rmfield(DATA,'LEAP');
DATA = rmfield(DATA,'NONMISSLEAP')

save('FINALDATA.mat','DATA')