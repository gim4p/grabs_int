function [Xgrid, Ygrid,stat_mean_int,stat_median_int,stat_std_dev_um_int,stat_skew_int] = ...
                                                                co_kriging_for_method5(X,Y,gridresolution,...
                                                                stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,...
                                                                stat_D10,stat_D90,...
                                                                bathy,folder_out,semivar_again)
%% 
smooth2d = 1;
winin = round(gridresolution*5);


%% check variogram
if semivar_again == 1
    semivar_data = check_variograms(X,Y,bathy,stat_median,stat_skew,stat_std_dev_um,folder_out);
    save([folder_out,'semivariogram'],'semivar_data','-v7.3')
end


%% full cokriging solve linear equation matrix for weights for every desired point
%{
% good for understanding, but not really working
sill_pri = 100;
range_pri = 8;
nugget_pri = 10;
sill_sec = 2;
range_sec = 2;
nugget_sec = .5;

weights_out = test_own_solver(X, Y, stat_median, bathy, semivar_data,gridresolution,sill_pri,range_pri,nugget_pri,sill_sec,range_sec,nugget_sec);
%}


%% Define trend and correlation functions (later for every parameter!)
trendFunction = @regpoly1;
correlationFunction = @correxp;

%{
@corrcubic
@correxpg
@corrlin:      % linear model
@correxp:      % exponential model
@corrgauss;    % Gaussian correlation function
@corrspherical % spherical
@corrspline

regpoly0;  % Zero-order polynomial (constant mean)
regpoly1   % first order
@regpoly2; % second order
%}


%% from my laptop
regr_primary    = trendFunction;
regr_secondary  = trendFunction;
corr_primary    = correlationFunction;
corr_secondary  = correlationFunction;
corr_cross      = correlationFunction;

thet_a = 10;
theta_primary = 200;
theta_secondary = 1;
lob_primary = 10;
lob_secondary = .1;
upb_primary = 400;
upb_secondary = 30;


%% median CoK setting  % we could benefit from parfor!
lob_cross = 15; 
thetacross_start = 15;
theta_cross = thetacross_start;
upb_cross = 21;
nugget = 234;

fprintf(['\n',datestr(now),' median interpolation (m5)'])
tic
% [Xgrid, Ygrid,  stat_median_int, bathymedian, cross_param_median,theta_cross] = co_kriging_int_crosscorr(X, Y, stat_median, bathy, gridresolution,...
%     thet_a, theta_primary, theta_secondary, thetacross_start,...
%     lob_primary, lob_secondary, lob_cross, upb_primary, upb_secondary, upb_cross,...
%     regr_primary, regr_secondary, corr_primary, corr_secondary, corr_cross,nugget);

[Xgrid, Ygrid,  stat_median_int, bathymedian, cross_param_median] = int_kriging(X, Y, stat_median, bathy, gridresolution,...
    lob_cross, upb_cross, regr_primary, corr_primary);
toc

krigingset_m5med.thetacross_start=thetacross_start;
krigingset_m5med.theta_cross=theta_cross;
krigingset_m5med.lob_cross=lob_cross;
krigingset_m5med.upb_cross=upb_cross;
save([folder_out,'m5_theta_cob_upb_cross'],'krigingset_m5med')

if smooth2d == 1
    
    win_size=winin; win_size = round(win_size/gridresolution);
    valu_e=.1;
    win_dow=valu_e*(ones(win_size))';
    cross_param_median_tmp = conv2(cross_param_median, win_dow, 'same' );
    xx=nanmean(cross_param_median(:))/nanmean(cross_param_median_tmp(:));
    
    cross_param_median=cross_param_median_tmp*xx;

    
else
    
end

dd=cross_param_median;

cross_param_median=dd;
cross_param_median(cross_param_median<110) = NaN;
cross_param_median=inpaint_nans(cross_param_median);

cross_param_median(cross_param_median<0) = 0;

stat_median_int = cross_param_median;

ta_b = table(Xgrid(:),Ygrid(:),cross_param_median(:));
tab_names = {'X_m', 'Y_m', 'D50'};
ta_b.Properties.VariableNames  = tab_names;
nameout = ['xymed_','theta_from',num2str(thetacross_start),'to',num2str(theta_cross), 'lob',num2str(lob_cross), 'upb',num2str(upb_cross)];
nameout=strrep(nameout,'.','');
writetable(ta_b, [folder_out,nameout],  'Delimiter', '\t' );



%% sorting CoK setting
lob_cross = 8;
thetacross_start = 10;
theta_cross = thetacross_start;
upb_cross = 12;
nugget = 70; % crosscorr 2


fprintf(['\n',datestr(now),' sort interpolation (m5)'])
tic
% [Xgrid, Ygrid, stat_std_dev_um_int, ~, cross_param_stddev] = co_kriging_int_crosscorr(X, Y, stat_std_dev_um, bathy, gridresolution,...
%     thet_a, theta_primary, theta_secondary, thetacross_start,...
%     lob_primary, lob_secondary, lob_cross, upb_primary, upb_secondary, upb_cross,...
%     regr_primary, regr_secondary, corr_primary, corr_secondary, corr_cross, nugget);  % co_kriging_int_cross

[Xgrid, Ygrid, stat_std_dev_um_int, ~, cross_param_stddev] = int_kriging(X, Y, stat_median, bathy, gridresolution,...
    lob_cross, upb_cross, regr_primary, corr_primary);
toc

if smooth2d == 1
    
    win_size=winin; win_size = round(win_size/gridresolution);
    valu_e=.01;
    win_dow=valu_e*(ones(win_size))';

    cross_param_stddev_tmp = conv2(cross_param_stddev, win_dow, 'same' );
    xx=nanmean(cross_param_stddev(:))/nanmean(cross_param_stddev_tmp(:));
    cross_param_stddev=cross_param_stddev_tmp*xx;
    
end

cross_param_stddev(cross_param_stddev<1) = NaN;

stat_std_dev_um_int=cross_param_stddev;

ta_b = table(Xgrid(:),Ygrid(:),cross_param_stddev(:));
tab_names = {'X_m', 'Y_m', 'stddev'};
ta_b.Properties.VariableNames  = tab_names;
nameout = ['xysort_','theta_from',num2str(thetacross_start),'to',num2str(theta_cross), 'lob',num2str(lob_cross), 'upb',num2str(upb_cross)];
nameout=strrep(nameout,'.','');
writetable(ta_b, [folder_out,nameout],  'Delimiter', '\t' );


%% skew
lob_cross = 8; % -> 0.4
thetacross_start = 10;%.4; % just for being faster for now (for med directly start with a good value saving iterations)
theta_cross = thetacross_start; %3;    % .1
upb_cross = 12;
nugget = 5; % crosscorr 2

% skewness must be positive for interpolation
skew_shift = abs(min(stat_skew)) + 0.01;
stat_skewsh = stat_skew + skew_shift;

fprintf(['\n',datestr(now),' skew interpolation (m5)'])

tic

% [Xgrid, Ygrid,  stat_skew_int, bathyskew, cross_param_skew] = co_kriging_int_crosscorr(X, Y, stat_skewsh, bathy, gridresolution,...
%     thet_a, theta_primary, theta_secondary, thetacross_start,...
%     lob_primary, lob_secondary, lob_cross, upb_primary, upb_secondary, upb_cross,...
%     regr_primary, regr_secondary, corr_primary, corr_secondary, corr_cross,nugget);

[Xgrid, Ygrid, stat_skew_int, ~, cross_param_skew] = int_kriging(X, Y, stat_skewsh, bathy, gridresolution,...
    lob_cross, upb_cross, regr_primary, corr_primary);
toc

if smooth2d == 1
    
    win_size=winin; win_size = round(win_size/gridresolution);
    valu_e=.03;
    win_dow=valu_e*(ones(win_size))';

    cross_param_skew_tmp = conv2(cross_param_skew, win_dow, 'same' );
    xx=nanmean(cross_param_skew(:))/nanmean(cross_param_skew_tmp(:));
    cross_param_skew=cross_param_skew_tmp*xx;

end

cross_param_skew = cross_param_skew - skew_shift;
stat_skew_int = stat_skew_int - skew_shift;


stat_skew_int = cross_param_skew;

ta_b = table(Xgrid(:),Ygrid(:),stat_skew_int(:));
tab_names = {'X_m', 'Y_m', 'skew'};
ta_b.Properties.VariableNames  = tab_names;
nameout = ['xyscew_','theta_from',num2str(thetacross_start),'to',num2str(theta_cross), 'lob',num2str(lob_cross), 'upb',num2str(upb_cross)];
nameout=strrep(nameout,'.','');
writetable(ta_b, [folder_out,nameout],  'Delimiter', '\t' );


%% mean
lob_cross = 10;
thetacross_start = 11;
theta_cross = thetacross_start;
upb_cross = 20;
nugget = 300;

fprintf(['\n',datestr(now),' mean interpolation (m5)'])
tic

% [Xgrid, Ygrid, stat_mean_int, bathymean, cross_param_mean] = co_kriging_int_crosscorr(X, Y, stat_mean, bathy, gridresolution,...
%     thet_a, theta_primary, theta_secondary, thetacross_start,...
%     lob_primary, lob_secondary, lob_cross, upb_primary, upb_secondary, upb_cross,...
%     regr_primary, regr_secondary, corr_primary, corr_secondary, corr_cross,nugget);

[Xgrid, Ygrid, ~, ~, cross_param_mean] = int_kriging(X, Y, stat_mean, bathy, gridresolution,...
    lob_cross, upb_cross, regr_primary, corr_primary);
toc

if smooth2d == 1
    win_size=winin; win_size = round(win_size/gridresolution);
    valu_e=.02;
    win_dow=valu_e*(ones(win_size))';

    cross_param_mean_tmp = conv2(cross_param_mean, win_dow, 'same' );
    xx=nanmean(cross_param_mean_tmp(:))/nanmean(cross_param_mean(:));
    cross_param_mean=cross_param_mean_tmp*xx;

end

stat_mean_int=cross_param_mean;

ta_b = table(Xgrid(:),Ygrid(:),stat_mean_int(:));
tab_names = {'X_m', 'Y_m', 'mean'};
ta_b.Properties.VariableNames  = tab_names;
nameout = ['xymean_','theta_from',num2str(thetacross_start),'to',num2str(theta_cross), 'lob',num2str(lob_cross), 'upb',num2str(upb_cross)];
nameout=strrep(nameout,'.','');
writetable(ta_b, [folder_out,nameout],  'Delimiter', '\t' );


%%


%% functions
function semivar_data = check_variograms(x,y,z,d50,skew,sortum,folder_out)
%% construct own semi variogram vd distance and depth
new_comparision = 1;
makenew_idx = 1;
binnb = 200; % 185;

nn = length(x); % 100

if new_comparision == 1 || makenew_idx == 1
    %% start semivariogram calculation
    if new_comparision == 1
        fprintf('start loop comparing data points\n')
        
        tic
        for n = 1 : length(x)

            if round(length(x)/10) == length(x)/10
                fprintf(['point progress: ',num2str(n/length(x)),' %\n'])
            end

            for m = 1 : length(y)
                semivar_data.xy_dist(n,m) = sqrt( (abs(x(n)-x(m)))^2 + (abs(y(n)-y(m)))^2 );
                semivar_data.diff_z(n,m) = abs(z(n)-z(m));
                semivar_data.diff_d50(n,m) = abs(d50(n)-d50(m));
                semivar_data.diff_skew(n,m) = abs(skew(n)-skew(m));
                semivar_data.diff_sortum(n,m) = abs(sortum(n)-sortum(m));
                % param cross depth
                semivar_data.z_d50(n,m) =  abs(d50(n)-d50(m)) * abs(z(n)-z(m)); % abs(z(n)-d50(m));
                semivar_data.z_skew(n,m) = abs(skew(n)-skew(m)) * abs(z(n)-z(m)); % abs(z(n)-skew(m));
                semivar_data.z_sort(n,m) = abs(sortum(n)-sortum(m)) * abs(z(n)-z(m)); % abs(z(n)-sortum(m));
            end

        end
                
        toc
        save( [folder_out,'m5_semivariogram_data_results'], 'semivar_data', '-v7.3');
    else
        load('m5_semivariogram_data_results.mat')
    end


    %% actually make semivariorgam
    if makenew_idx == 1
        %% XY vs depth and stat moments
        XY_Zstatmoments = [semivar_data.xy_dist(:),semivar_data.diff_z(:),semivar_data.diff_d50(:),semivar_data.diff_skew(:),semivar_data.diff_sortum(:),semivar_data.z_d50(:),semivar_data.z_skew(:),semivar_data.z_sort(:)];
        XY_Zstatmoments = sortrows(XY_Zstatmoments);
        XY_Zstatmoments(XY_Zstatmoments(:,1)==0,:) = [];

        intvec = linspace(1,max(XY_Zstatmoments(:,1)),binnb);
        for n = 1 : length(intvec)-1
            idx_XY_10{n} = find( XY_Zstatmoments(:,1) > intvec(n) & XY_Zstatmoments(:,1) < intvec(n+1));
        end
        
        semivar_data.names1 = {'xy_diff', 'depth_diff', 'd50_diff', 'skew_diff', 'sort_diff'};
        semivar_data.XY_Zstatmoments = XY_Zstatmoments;
        semivar_data.idx_XY = idx_XY_10;


        %% depth vs stat moments
        Z_statmoments = [semivar_data.diff_z(:),semivar_data.diff_d50(:),semivar_data.diff_skew(:),semivar_data.diff_sortum(:)];
        Z_statmoments = sortrows(Z_statmoments);
        Z_statmoments(Z_statmoments(:,1)==0,:) = [];

        intvec = linspace(1,max(Z_statmoments(:,1))+1,binnb);
        for n = 1 : length(intvec)-1
            fprintf([num2str(intvec(n)) ' m to ' num2str(intvec(n+1)), 'm\n' ])
            idx_Z_10{n} = find( Z_statmoments(:,1) > intvec(n) & Z_statmoments(:,1) < intvec(n+1) );
        end
        semivar_data.names2 = {'depth_diff', 'd50_diff', 'skew_diff', 'sort_diff'};
        semivar_data.Z_statmoments = Z_statmoments;
        semivar_data.idx_Z = idx_Z_10;
        
        semivar_data.folder_out=folder_out;
        semivar_data.binnb=binnb;
        
        save( [folder_out,'m5_semivariogram_data_results_idx_',num2str(binnb)], 'semivar_data', '-v7.3');
    else
        load('m5_semivariogram_data_results_idx.mat')
    end
else
    load('m5_semivariogram_data_results_idx.mat')
end


%% checkplots
plot_semivariograms(semivar_data)


%% make cross variogram (covariance of depth and statistical moment which shall be interpolated)
plot_crossvariogram(semivar_data);


%%
semivar_data.cross_z_d50  = .5* ( semivar_data.diff_z .* semivar_data.diff_d50 );
semivar_data.cross_z_skew = .5* ( semivar_data.diff_z .* semivar_data.diff_skew );
semivar_data.cross_z_sort = .5* ( semivar_data.diff_z .* semivar_data.diff_sortum );
save( [folder_out,'m5_semivariogram_',num2str(binnb)], 'semivar_data', '-v7.3');



function plot_semivariograms(varargin)

if length(varargin)==0
    load('semivariogram_data_results.mat')
else
    semivar_data = varargin{1, 1}; clear varargin
end


%% vs distance
fig1 = figure('Color', 'w', 'Position', [80 100 1500 800]);
s1 = subplot(2,4,1); hold on
for n = 1 : length(semivar_data.idx_XY)
    plot(nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},1))/1000,nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},3)),'k.')
end
title('semivariograms')
ylabel('averaged d50 difference');xlabel('averaged distance difference [km]')
s2 = subplot(2,4,2); hold on
for n = 1 : length(semivar_data.idx_XY)
    plot(nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},1))/1000,nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},4)),'k.')
end
ylabel('averaged skewness difference');xlabel('averaged distance difference [km]')
s3 = subplot(2,4,3); hold on
for n = 1 : length(semivar_data.idx_XY)
    plot(nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},1))/1000,nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},5)),'k.')
end
ylabel('averaged sorting [µm] difference');xlabel('averaged distance difference [km]')

s4 = subplot(2,4,4); hold on
for n = 1 : length(semivar_data.idx_XY)
    plot(nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},1))/1000,nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},2)),'k.')
end
ylabel('averaged depth difference [m]');xlabel('averaged distance difference [km]')


%% vs depth
s5 = subplot(2,4,5); hold on
for n = 1 : length(semivar_data.idx_Z)
    plot(nanmean(semivar_data.Z_statmoments(semivar_data.idx_Z{n},1)),nanmean(semivar_data.Z_statmoments(semivar_data.idx_Z{n},2)),'k.')
end
ylabel('averaged d50 difference');xlabel('averaged depth difference [m]')
s6 = subplot(2,4,6); hold on
for n = 1 : length(semivar_data.idx_Z)
    plot(nanmean(semivar_data.Z_statmoments(semivar_data.idx_Z{n},1)),nanmean(semivar_data.Z_statmoments(semivar_data.idx_Z{n},3)),'k.')
end
ylabel('averaged skewness difference');xlabel('averaged depth difference [m]')
s7 = subplot(2,4,7); hold on
for n = 1 : length(semivar_data.idx_Z)
    plot(nanmean(semivar_data.Z_statmoments(semivar_data.idx_Z{n},1)),nanmean(semivar_data.Z_statmoments(semivar_data.idx_Z{n},4)),'k.')
end
ylabel('averaged sorting [µm] difference');xlabel('averaged depth difference [m]')
linkaxes([s1,s2,s3,s4],'x')
linkaxes([s5,s6,s7],'x')

saveas(fig1, [semivar_data.folder_out,'m5_semivariorams.fig'])


function plot_crossvariogram(semivar_data)

cross_variogram_z_d50 = zeros(length(semivar_data.idx_XY), 1);
cross_variogram_z_skew = zeros(length(semivar_data.idx_XY), 1);
cross_variogram_z_sort = zeros(length(semivar_data.idx_XY), 1);
cross_variogram_z_cross_d50 = zeros(length(semivar_data.idx_XY), 1);
cross_variogram_z_cross_skew = zeros(length(semivar_data.idx_XY), 1);
cross_variogram_z_cross_sort = zeros(length(semivar_data.idx_XY), 1);

for n = 1 : length(semivar_data.idx_XY)
    
    bin_km(n) = nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},1))/1000;
    
    cross_variogram_z_d50(n)  = .5*nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},2) .* semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},3)); % depth * d50
    cross_variogram_z_skew(n) = .5*nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},2) .* semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},4)); % depth * skew
    cross_variogram_z_sort(n) = .5*nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},2) .* semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},5)); % depth * sort
    
    cross_variogram_z_cross_d50(n)  = .5*nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},2) .* semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},6)); % depth * d50
    cross_variogram_z_cross_skew(n) = .5*nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},2) .* semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},7)); % depth * skew
    cross_variogram_z_cross_sort(n) = .5*nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},2) .* semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},8)); % depth * sort
    
end


fig3 = figure('Color', 'w', 'Position', [1000 500 900 400]);
s1=subplot(1,3,1);
plot(bin_km,cross_variogram_z_cross_d50,'k.')
xlabel('averaged distance difference [km]');ylabel('cross variogram (depth cross d50)');
s2=subplot(1,3,2);
plot(bin_km,cross_variogram_z_cross_skew,'k.')
xlabel('averaged distance difference [km]');ylabel('cross variogram (depth cross skew)');
s3=subplot(1,3,3);
plot(bin_km,cross_variogram_z_cross_sort,'k.')
xlabel('averaged distance difference [km]');ylabel('cross variogram (depth cross sort)');
linkaxes([s1,s2,s3],'x')

saveas(fig3, [semivar_data.folder_out,'m5_crossvariorams_2.fig'])



%% just for better understanding te process, not being used (June 2024)
function weights_out = test_own_solver(Xdata, Ydata, stat_median, bathy, semivar_data,gridresolution,sill_primary,range_primary,nugget_primary,sill_secondary,range_secondary,nugget_secondary)


%% data format and make grid for interpolation
[Xgrid, Ygrid] = meshgrid(min(Xdata) :  gridresolution  : max(Xdata), min(Ydata) :  gridresolution  : max(Ydata));
grid_points = [Xgrid(:), Ygrid(:)];

dist = semivar_data.xy_dist;
d50 = semivar_data.diff_d50;
depth = semivar_data.diff_z;
depth_d50 = semivar_data.cross_z_d50;


%% Normalize data (stolen from dace)
mS = mean(dist(:));   sS = std(dist(:));
mY = mean(d50(:));   sY = std(d50(:));
mz = mean(depth(:));   sz = std(depth(:));
mcross = mean(depth_d50(:));   scross = std(depth_d50(:));

% Check for 'missing dimension'
j = find(sS == 0);
if  ~isempty(j),  sS(j) = 1; end
j = find(sY == 0);
if  ~isempty(j),  sY(j) = 1; end
norm_diff_dist = (dist - repmat(mS,size(dist))) ./ repmat(sS,size(dist));
A_primary = (d50 - repmat(mY,size(d50))) ./ repmat(sY,size(d50));
A_secondary = (depth - repmat(mz,size(depth))) ./ repmat(sz,size(depth));
A_cross = (depth_d50 - repmat(mcross,size(depth_d50))) ./ repmat(scross,size(depth_d50));


%% full co-kriging matrix
% also added Lagrange multipliers [1 1 1 1 1 0]
A = [ [A_primary, ones(length(A_primary), 1); ones(1, length(A_primary)), 0] ,...
      [A_cross;   ones(1, length(A_primary))] ; ... 
      [A_cross';  ones(1, length(A_primary))], ...
      [A_secondary, ones(length(A_primary), 1); ones(1, length(A_primary)), 0] ]; % figure; imagesc(A);

% A = [ A_primary , A_cross; A_cross', A_secondary]; % figure; imagesc(A);


semivariogram = @(h, range, sill) sill * (1 - exp(-h / range));


for every_grid_point = 1 %: numel(Xgrid)
    %% make vector b (distance from prediction point to all points)
    b = sqrt( (Xdata - Xgrid(every_grid_point)).^2 + (Ydata - Ygrid(every_grid_point)).^2 );
    
    % Calculate semivariances for these distances
    b_primary   =  [b;1]; %[semivariogram(b, range_primary, sill_primary); 1];
    b_secondary =  [b;1]; %[semivariogram(b, range_secondary, sill_secondary); 1];


    %% solving linear equation (of co-kriging system)
    weight_out = A \ [b_primary;b_secondary]; % figure;plot(weight_out)
    
    % Extract the kriging weights
    kriging_weights_primary   = weight_out(1:length(b_primary)-1);
    kriging_weights_secondary = weight_out(length(b_primary):end-1);
    
    mean(stat_median.*(kriging_weights_primary))
    sum(bathy.*kriging_weights_secondary)
    
end










