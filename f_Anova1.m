function [] = f_Anova1(X)

[N,T] = size(X); IAVANT = 1 : 3600; IAPRES = 3601 : 7200;

MU = zeros(4,2); SIG = zeros(4,2);
for row = 1 : 3
    MU(row,1) = mean(X(row,IAVANT)); SIG(row,1) = std(X(row,IAVANT));
    MU(row,2) = mean(X(row,IAPRES)); SIG(row,2) = std(X(row,IAPRES));
end
zav = X(:,IAVANT); zav = zav(:);
zap = X(:,IAPRES); zap = zap(:);
row = 4;
MU(row,1) = mean(zav); SIG(row,1) = std(zav);
MU(row,2) = mean(zap); SIG(row,2) = std(zap);

labelx = cell(1,T);
for k = IAVANT, labelx{k} = 'before'; end
for k = IAPRES, labelx{k} = 'after'; end

for n = 1 : N    
    [pn,tbln,stn] = anova1(X(n,:),labelx)
    'wait'
end

% All values
zz = [zav;zap] ; lzz = length(zz); labelx = cell(lzz,1);
IAVANT = 1 : length(zav);
IAPRES = 1 + length(zav) : lzz;
labelx = cell(lzz,1);
for k = IAVANT, labelx{k} = 'before'; end
for k = IAPRES, labelx{k} = 'after'; end
[pn,tbln,stn] = anova1(zz,labelx)
'aa'

% figure(5)
% row = 1;
% subplot(4,2,1), histogram(X(row,IAVANT)), title('AVANT 30s, trial 1')
% subplot(4,2,2), histogram(X(row,IAPRES)), title('APRES 30s, trial 1')
% 
% row = 2;
% subplot(4,2,3), histogram(X(row,IAVANT)), title('AVANT 30s, trial 2')
% subplot(4,2,4), histogram(X(row,IAPRES)), title('APRES 30s, trial 2')
% 
% row = 3;
% subplot(4,2,5), histogram(X(row,IAVANT)), title('AVANT 30s, trial 3')
% subplot(4,2,6), histogram(X(row,IAPRES)), title('APRES 30s, trial 3')
% 
% subplot(4,2,7), histogram(zav(:)), title('AVANT 30s, all')
% subplot(4,2,8), histogram(zap(:)), title('APRES 30s, all')