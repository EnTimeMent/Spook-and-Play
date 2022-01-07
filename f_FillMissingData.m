function [L1,N0] = f_FillMissingData(L)

% Special fill data LEAP

GLOBAL_CHRONOS;

% MAXDELAY = max(TABLETRIALEMOTDELAY.delay);
% NDELAY = MAXDELAY * TRIALFREQUENCY;

N = length(L); L1 = L; N0 = zeros(N,1);

if Parameters.Visu
    Parameters.nofig = Parameters.nofig + 1;
end

for n = 1 : N
    xt = L{n};
    T = xt(:,1); X = xt(:,2); nT = length(T);
    IX0 = abs(X) < eps; n0n = mean(IX0); N0(n) = n0n;
    X0 = X(not(IX0)); T0 = T(not(IX0));
    
    % if n0n <= 5% interpolation will fill it otherwise complete X0
    % !? but keep the first 450 values (8 * 55 = 440) from the original X
    
    if n0n > 0.05 % more than 5%
        z0 = X0; lx0 = length(z0);
        while lx0 < nT
            z = -flipud(z0); z0 = [z0; z]; lx0 = length(z0);
        end
        % z0(1 : NDELAY) = X(1 : NDELAY);
        XX = z0(1 : nT); % corrected signal
        XX(not(IX0)) = X0;
        
        %         if Parameters.Visu
        %             figure(3), clf
        %             %             subplot(211)
        %             %             plot(T0, X0,'-k',T1, X1, 'ro',T2,-X2,'bo',T0,y1,':g');
        %             %             xlim([0, max(T0)]);
        %             %             legend('Signal','Max','min','Wsig')
        %             %             grid on; xlabel('Time [ms]'), title('Position [cm]')
        %             %             subplot(212)%
        %             plot(T,X,'-b',T0,X0+0.1,'-r',T,XX+0.2,'-k')
        %             grid on, xlim([0, max(T)]);
        %             legend('X','X0','XX')
        %             xlabel('Time [ms]'), ylabel('Position [cm]')
        %             title(['Missing %:',num2str(n0n * 100)])
        %         end
        %         'wait'
        L1{n} = [T,XX];       
    end
end
hist(N0(N0>0),101), title('Distribution of % of missing values')
N00 = sum(N0 > 0.05);

%
%         % Find Peaks
%         [X1,T1,X2,T2,y1] = f_RPeakDetection(X0,T0);
%
%         % Fit a*sin(b*T0) to X0 - bad pioche
%         a = median(abs([X1;X2]));
%         DT1 = mean(diff(T1));
%         DT2 = mean(diff(T2));
%         PERIOD = 0.5 * (DT1 + DT2);
%         b = median((X0/a) ./ T0);
%         XSIN = a * sin(T * (2*pi)/PERIOD);
%         XX = XSIN; XX(not(IX0)) = X0;
