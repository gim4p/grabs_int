
function Fint = idw(X0,F0,Xint,p,bathypointlist,bathyintlist,grabsampletime,rad,L)
% function Fint = idw(X0,F0,Xint,p,rad,L)
%
% Inverse distance weight function to interpolate values based on
% sampled points.
%
% Fint = idw(X0,F0,Xint) uses input coordinates X0 and input values F0
% where X0 is a N by M input matrix of N samples and M number of variables.
% F0 is vector of N responses. Xint is a Q by M matrix of coordinates to be
% interpolated. Fint is the vector of Q interpolated values.
%
% Fint = idw(X0,F0,Xint,p,rad) uses the power p (default p = 2) and radius
% rad (default rad = inf).
%
% Fint = idw(X0,F0,Xint,p,rad,L) uses L-distance. By defaults L=2
% (Euclidean norm).
%
% Example:
%
% X1 = [800;2250;3250;2250;900;500];
% X2 = [3700;4200;5000;5700;5100;4900];
% F =  [13.84;12.15;12.87;12.68;14.41;14.59];
% Q = 100;
% [X1int,X2int] = meshgrid(0:4000/(Q-1):4000, 3200:(5700-3200)/(Q-1):5700);
% Fint = idw([X1,X2],F,[X1int(:),X2int(:)]);
% contourf(X1int, X2int, reshape(Fint,Q,Q), 20)
%
% Contact info:
%
% Andres Tovar
% tovara@iupui.edu
% Indiana University-Purdue University Indianapolis
%
% Code developed for the course Design of Complex Mechanical Systems (ME
% 597) offered for the first time in Spring 2014
% Default input parameters
if nargin < 9
    L = 2;
    if nargin < 8 % gia: since I added bathymetric data and time
        rad = inf;
        if nargin < 7
            p = 2;
        end
    end
end
% Basic dimensions
N = size(X0,1); % Number of samples
M = size(X0,2); % Number of variables
Q = size(Xint,1); % Number of interpolation points

alpha = .2; % depth influence

easyGSH_time = datenum([2015 6 14 0 0 0]);

% Inverse distance weight output
Fint = zeros(Q,1);
for ipos = 1:Q % for every interpolation point
    %% Distance matrix
    DeltaX = X0 - repmat(Xint(ipos,:),N,1); % gia: distance from interpolated point to every data point
    DabsL = zeros(size(DeltaX,1),1);
    for ncol = 1:M
        DabsL = DabsL + abs(DeltaX(:,ncol)).^L;
    end
    Dmat = DabsL.^(1/L); % gia: pythagoras for distances
    Dmat(Dmat==0) = eps;
    Dmat(Dmat>rad) = inf;
    
    % Weights by distance
    W_distance = 1./(Dmat.^p);

    %% depth matrix
    depthdiff = abs(bathypointlist - bathyintlist(ipos)); % Höhenunterschied interpol Points zu allen Datenpkten
    
    % Weights by depthdifference
    W_depth = exp(-1/alpha * depthdiff); % 
    % W_depth = 1./(depthdiff.^p); % figure; plot(W_depth)
    
    %% time weight
    try
    timediff = abs( grabsampletime - easyGSH_time ); % Höhenunterschied interpol Points zu allen Datenpkten
    catch
        ipos
    end
    timediff(timediff==0)=1;
%     W_time(:,1) = exp(-1/alpha * timediff); % 
    W_time(:,1) = 1./(timediff.^p); % figure; plot(log10(W_time))
    W_time(isnan(W_time))=min(W_time);
    
    %% combined weight figure; hold on; yyaxis left; plot(W_distance); yyaxis right; plot(W_depth)
    facto_r = 1.2;
    W_depth = facto_r * W_depth * (nanmean(W_distance)/nanmean(W_depth)); % sloppy 50/50 weight of distance and depth * factor
    W_time =  W_time * (nanmean(W_distance)/nanmean(W_time)) / 1;
    
    if ipos == 1
        fprintf( [ 'W depth: ', num2str( nanmean(W_depth) ), ' W distance ', num2str( nanmean(W_distance) ) , ' W time ', num2str( nanmean(W_time) ),'\ntime excluded this run\n' ] )
    end
    
    W = W_distance + W_depth ; %+ W_time; % figure;subplot(3,1,1);plot(W_distance);subplot(3,1,2);plot(W_depth);subplot(3,1,3);plot(W_time)
    
    
    %% Interpolation
    Fint(ipos) = sum(W.*F0)/sum(W);
    
    
end
end




