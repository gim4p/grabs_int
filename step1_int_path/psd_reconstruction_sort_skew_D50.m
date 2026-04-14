function [PSD_recon_all,PSD_recon_mat,gsc_recon] = psd_reconstruction_sort_skew_D50(D50, sort, skew, gsc)

for nn = 1 : size(D50,1)
    
    for mm = 1 : size(D50,2)
        
        if round(mm/10000) == mm/10000
            fprintf(['\nprogress',num2str(mm/size(D50,2)),'\n'])
        end
        
        [PSD_recon,gsc_recon] = reconstructPSD(D50(nn,mm),skew(nn,mm),sort(nn,mm),gsc(1:end)); % figure; plot(gsc_recon,PSD_recon) % gsc(2:end-1)
        
        PSD_recon_all(nn,mm,:) = PSD_recon;
        
    end
    
end

PSD_recon_mat = permute(PSD_recon_all,[3 1 2]);
PSD_recon_mat = reshape(PSD_recon_mat, [size(PSD_recon_mat,1), size(PSD_recon_mat,2)*size(PSD_recon_mat,3) ] )' ;


function [grain_distribution,size_classes] = reconstructPSD(D50,skew,sort,varargin)

if length(varargin) == 1
    size_classes = varargin{1};
else
    size_classes = [1:1000];
end

%% make synthetic distribution
n = 1000; % Number of data points
mu = D50; % Mean in phi units

sigma = sort; % Standard deviation in phi units

synthetic_um = normrnd(mu, sigma, n, 1); % figure; histogram(synthetic_um)


%% apply skewness (using Box-Cox transformation)
%{
if skew < 0         % bei skewness < 0: zum Gröberen hin verschoben
    
    lambda = abs(skew);
    synthetic_um_skew = -((synthetic_um(synthetic_um>0) .^ lambda) - 1) / lambda;
    synthetic_um_skew_n = synthetic_um_skew ./ (mean(synthetic_um_skew) / mean(synthetic_um));
    
elseif skew > 0     % bei matlab skewness > 0: zum Feineren hin verschoben
    
    lambda = 1 + 1 / skew;
    synthetic_um_skew = ((synthetic_um(synthetic_um>0) .^ lambda) - 1) / lambda;
    synthetic_um_skew_n = synthetic_um_skew ./ (mean(synthetic_um_skew) / mean(synthetic_um));

else
    
    synthetic_um_skew_n = synthetic_um;
    
end

%{
figure('Color', 'w', 'Position', [50 450 650 170]);
subplot(1,3,1)
histogram(synthetic_um)
title('normal distribution, just std dev')
subplot(1,3,2)
histogram(synthetic_um_skew)
title('normal distribution, also skewness')
subplot(1,3,3)
histogram(abs(synthetic_um_skew_n))
title('normal distribution, also skewness and shift')
%}
%}


%% into gsc intervals
synthetic = synthetic_um;
% synthetic = synthetic_um_skew_n;

grain_distribution = zeros(1, length(size_classes));

for i = 1 : length(size_classes)
    if i == length(size_classes)
        grain_distribution(i) = sum(synthetic >= size_classes(i));
    else
        grain_distribution(i) = sum(synthetic >= size_classes(i) & synthetic < size_classes(i+1));
    end
end

grain_distribution = grain_distribution ./ sum(grain_distribution);


% figure; plot(grain_distribution)



