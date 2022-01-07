function D = f_DistSyncGSyncGminusOne(PG) %,delay)

% Calculates the order parameter of PHASES of the group G
% For each Person in G calculates the order paremeter of Phases in G \ Pi
% Calculates D(i) = emd(G, G\pi) = dist(cdf(G, cdf(G\Pi))) after delay
% Input
% PG - phases of group members
% Output
% D(i) = emd(G, G\pi) = dist(cdf(G, cdf(G\Pi))) after delay
% D(i) - BIG - Pi is NEAR from the group
% D(i) - LOW - Pi is FAR from the group

[nG,TG] = size(PG);

[G, ~, ~] = orderParameter(PG); % Group SYNC
GG = zeros(nG,TG);
for g = 1 : nG
    Pg = PG; Pg(g,:) = [];
    [GG(g,:), ~, ~] = orderParameter(Pg);
end

% G = G(delay + 1 : end);
% GG = GG(:, delay + 1 : end);

xmin = 0; xmax = 1; nbpdf = 77;
typefunction = 'cdf';
[cdfG,xi] = f_PdfCdf(G,nbpdf,xmin, xmax, typefunction);
cdfGG = zeros(nG,nbpdf);
for g = 1 : nG
    [cdfGG(g,:),xi] = f_PdfCdf(GG(g,:),nbpdf,xmin, xmax, typefunction);
end

% Compute emds for CDFV
deltav = xi(2) - xi(1);
D = zeros(nG,1);
for g = 1 : nG
    D(g) = sum(abs(cdfG - cdfGG(g,:))) * deltav;    
end