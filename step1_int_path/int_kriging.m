%% co-kriging approach on basis of https://github.com/rckitson/cokriging
function [Xgrid, Ygrid, d_param, bathy_param, sed_param] = ...
    int_kriging(Xdata, Ydata, sedata, bathy, gridresolution, ...
    lob_cross, upb_cross, regr_primary, corr_primary)

%% 
[Xgrid, Ygrid] = meshgrid(min(Xdata):gridresolution:max(Xdata), ...
                         min(Ydata):gridresolution:max(Ydata));
grid_points = [Xgrid(:), Ygrid(:)];


%% add path
addpath([pwd,'\cokriging-master\'])
addpath([pwd,'\cokriging-master\dace\'])

%% normalise data
yc0 = (bathy - mean(bathy)) / std(bathy);
ye0 = (sedata - mean(sedata)) / std(sedata);

% low fidelity (secondary) = bathy
sc0 = [Xdata, Ydata];

% high fidelity (primary) = sediment
se0 = [Xdata, Ydata];

%% model settings (func input)
regr = regr_primary;
corr = corr_primary;

dim = size(sc0,2);

lb = lob_cross * ones(1,dim);
ub = upb_cross  * ones(1,dim);

%% GitHub co-kriging model
[dmodel, dmc, dmd] = cokriging2(sc0, yc0, se0, ye0, regr, corr, lb, ub);

fprintf('\nCo-kriging model (GitHub) trained.\nNow predicting...\n')

%% prediction
n = size(grid_points,1);

ypred_sed   = zeros(n,1); % final co-kriging (sediment)
ypred_bath  = zeros(n,1); % low fidelity
ypred_d = zeros(n,1); % discrepancy

for i = 1:n
    
    x = grid_points(i,:);
    
    x_norm = (x - dmodel.smean) ./ dmodel.sstd;
    
    [yL, ~] = predictor(x_norm, dmc);
    
    [d, ~] = predictor(x_norm, dmd);
    
    y = yL * dmodel.p + d;
%     alpha=.28;
%     y = (alpha * yL) * dmodel.p + d;
    
    y = dmodel.ymean + dmodel.ystd * y;
    yL_real = dmodel.ymean + dmodel.ystd * yL;
    d_real  = dmodel.ystd * d;
    
    ypred_sed(i)   = y;
    ypred_bath(i)  = yL_real;
    ypred_d(i) = d_real;
end

sedata = mean(sedata) + std(sedata) * ypred_sed;
ypred_bath = mean(bathy) + std(bathy) * ypred_bath;
ypred_d = mean(sedata) + std(sedata) * ypred_d;

%% reshaoe
sed_param   = reshape(sedata,   size(Xgrid));
bathy_param = reshape(ypred_bath,  size(Xgrid));
d_param = reshape(ypred_d, size(Xgrid));

%{
figure; 
subplot(3,1,1); imagesc(sed_param); title('prim')
subplot(3,1,2); imagesc(bathy_param); title('sec')
subplot(3,1,3); imagesc(d_param); title('cross')
%}

end
