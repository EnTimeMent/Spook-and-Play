function [T,X] = f_InterpolateUniqueTInterval(L)

GLOBAL_CHRONOS;
NPOINTS = TRIALDURATION*TRIALFREQUENCY;
T = linspace(0,TRIALDURATION,NPOINTS)'; % in seconds
N = length(L); 
X = zeros(NPOINTS,N);
for n = 1 : N
    xt = L{n};
    Tn = xt(:,1) / 1000; % bring it into seconds
    [Tn,itn,icn] = unique(Tn);
    Xn = xt(itn,2);
    disp(n)
    x = interp1(Tn,Xn,T,'spline');
    X(:,n) = x;
    
    if Parameters.Visu
        figure(4), clf
        plot(Tn,Xn,':r',T,X,'.k')
        xlim([0 45])
    end
%     'wait'
end
