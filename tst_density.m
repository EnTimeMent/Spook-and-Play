% tst_icdf
D = load('OPMT.mat');%,'OPMT')
x = D.OPMT(:);
% hist(OPMT,101)
% x = OPMT;
m = min(x); M = max(x);
xi = linspace(m,M,100);
PDF = ksdensity(x,xi,'Function','pdf');

% MODE and STD
[MODE,iMODE] = max(PDF);
xMODE = xi(iMODE);
xstd = std(x);

seuils = xMODE - [xstd; 2*xstd; 3* xstd]; 

CDF = ksdensity(x,xi,'Function','cdf');
delta = 0.5/3; ii = (0 : 3)';
yI = 0.5 + ii * delta;
ICDF = ksdensity(x,yI,'Function','icdf');
% z = [randn(30,1); 5+randn(30,1)];
% [PDFz,zI] = ksdensity(z,'Function','pdf');
% [CDFz,zI] = ksdensity(z,'Function','cdf');
% yi = linspace(.1,.99,11);
% g = ksdensity(z,yi,'Function','icdf');
figure(4)
subplot(131), plot(xi,PDF), title('PDF of ALL Order Parameter Time')
subplot(132), plot(xi,CDF), title('PDF of ALL Order Parameter Time')
subplot(133), plot(yI,ICDF,'-or'), title('Inverse CDF of ALL Order Parameter Time')