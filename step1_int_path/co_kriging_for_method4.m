function [Zmat_all,Zmat_n,theta_cross,gz_wanted] = co_kriging_for_method4(X,Y,Z,gsc,bathy,gridresolution,folder_out,semivar_again)

gsc_down=gsc(1);
gsc_up = gsc(end);
gsc_org = gsc;
gsc=gsc(2:end-1);


%% check variogram
if semivar_again == 1
    for aa = 1 : length(gsc)
        semivar_data = m4_check_variograms(X,Y,bathy,Z(aa,:),gsc(aa),folder_out);
        save([folder_out,'semivariogram'],'semivar_data','-v7.3')
    end
end


%% Define regression trend and correlation functions (based on variograms)
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
lob_primary = 10;
upb_primary = 300;
theta_primary   = 200;
lob_secondary = .1;
upb_secondary = 30;
theta_secondary = 1;

smooth2d = 1;
winin = round(gridresolution*5);

theta_list = [  6 6 6 6 6 6 ];


%%
fig=figure('Color', 'w', 'Position', [80 80 1000 800]); separ=2;

for gsc_nb = 1 : length(gsc)
    
    lob_cross = theta_list(gsc_nb)/10;
    lob_primary = lob_cross;
    thetacross_start = theta_list(gsc_nb);
    theta_cross = theta_list(gsc_nb);
    theta_primary = theta_cross;
    upb_cross = theta_list(gsc_nb)*10;
    upb_primary = upb_cross;
    
    %%
    fprintf(['\n',num2str(gsc_nb),' of ',num2str(length(gsc)),' grain size class ',num2str(gsc(gsc_nb)),' microns\n'])
    fprintf([datestr(now),'\n'])
    
    tic
%     [Xgrid, Ygrid,  prim, ~, gsc_tmp,theta_cross] = co_kriging_int_crosscorr(X, Y, Z(gsc_nb,:)', bathy, gridresolution,...
%     thet_a, theta_primary, theta_secondary, theta_cross,...
%     lob_primary, lob_secondary, lob_cross, upb_primary, upb_secondary, upb_cross,...
%     regr_primary, regr_secondary, corr_primary, corr_secondary, corr_cross, nuggetlist(gsc_nb));

    [Xgrid, Ygrid,  ~, ~, gsc_tmp] = int_kriging(X, Y, Z(gsc_nb,:)', bathy, gridresolution,...
        lob_cross, upb_cross, regr_primary, corr_primary);
    toc

    %% theta med
    krigingset_m4.thetacross_start(gsc_nb)=thetacross_start;
    krigingset_m4.theta_cross(gsc_nb)=theta_cross;
    krigingset_m4.lob_cross(gsc_nb)=lob_cross;
    krigingset_m4.upb_cross(gsc_nb)=upb_cross;
    krigingset_m4.gsc_um(gsc_nb)=gsc(gsc_nb);
    krigingset_m4.smooth = smooth2d;
    krigingset_m4.smoothwin = winin;
    save([folder_out,'m4_theta_cob_upb_cross'],'krigingset_m4')
    
    
    %% smooth if wanted
    if smooth2d == 1

        win_size=winin; win_size = round(win_size/gridresolution);
        valu_e=.01;
        win_dow=valu_e*(ones(win_size))';

        Zinttmp = conv2(gsc_tmp, win_dow, 'same' );

    else
        Zinttmp = gsc_tmp;
    end
    
    Zmat_all(:,:,gsc_nb) = Zinttmp; 
    
    %%%%%%%%%%%%%
    fig;subplot(ceil(length(gsc)/separ),ceil(length(gsc)/ceil(length(gsc)/separ)),gsc_nb); imagesc(Zinttmp); title(['sc ',num2str((gsc(gsc_nb))),' um'])

    ta_b = table(Xgrid(:), Ygrid(:), Zinttmp(:));
    tab_names = {'X_m', 'Y_m', 'stat'};
    ta_b.Properties.VariableNames  = tab_names;
    nameout = ['xygz_',num2str(gsc(gsc_nb)),'theta_from',num2str(thetacross_start),'to',num2str(theta_cross), 'lob',num2str(lob_cross), 'upb',num2str(upb_cross)];
    nameout=strrep(nameout,'.','');
    writetable(ta_b, [folder_out,nameout], 'Delimiter', '\t' );
    
end

Zmat_n = permute(Zmat_all,[3 1 2]);
Zmat_n = reshape(Zmat_n, [size(Zmat_n,1), size(Zmat_n,2)*size(Zmat_n,3) ] )' ;


%% 
Zmat_n = permute(Zmat_all,[3 1 2]);
Zmat_n = reshape(Zmat_n, [size(Zmat_n,1), size(Zmat_n,2)*size(Zmat_n,3) ] )' ;
testmat=(Zmat_n<0); allnegatives = find(sum(testmat,2)==size(testmat,2));
rowMix = abs(min(Zmat_n(allnegatives,:), [], 2));

Zmat_n(allnegatives,:) = Zmat_n(allnegatives,:)+ repmat(rowMix , 1, size(testmat,2));
Zmat_n(Zmat_n<0)=0;

intout2 = Zmat_n;
intout2 = reshape(intout2, [ size(Zmat_all,1), size(Zmat_all,2), size(Zmat_all,3) ] );

Zmat_alltmp = intout2;
Zmat_all = Zmat_alltmp ./ repmat( sum(Zmat_alltmp,3), 1,1,size(Zmat_alltmp,3) );
save([folder_out,'m4_Zmat_all_normalized_0'],'Zmat_all','-v7.3')

Zmat_n = permute(Zmat_all,[3 1 2]);
Zmat_n = reshape(Zmat_n, [size(Zmat_n,1), size(Zmat_n,2)*size(Zmat_n,3) ] )' ; 
gsc_mat = ones(size(Zmat_n));

for w = 1 : length(gsc);
    gsc_mat(:,w) = gsc_mat(:,w)*gsc(w);
end

method4_mean = nansum(gsc_mat.*Zmat_n,2);
Zmat_n_o=Zmat_n;


%% erase negatives (since they are extremely negatives, it shall be just zero)
if min(Zmat_n(:)) < 0
    Zmat_all(Zmat_all<0)=0;
    Zmat_all = Zmat_all ./ repmat( sum(Zmat_all,3), 1,1,size(Zmat_all,3) );
    Zmat_n = permute(Zmat_all,[3 1 2]);
    Zmat_n = reshape(Zmat_n, [size(Zmat_n,1), size(Zmat_n,2)*size(Zmat_n,3) ] )' ;
end

save([folder_out,'m4_Zmat_all_end'],'Zmat_all','-v7.3')
save([folder_out,'m4_Zman_end'],'Zmat_n','-v7.3')


gz_wanted = gsc_org;


function semivar_data = m4_check_variograms(x,y,z,percentile,gsc_um,folder_out)
%% construct own semi variogram vd distance and depth
new_comparision = 1;
makenew_idx = 1;
binnb = 200;
nn = length(x);

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
                semivar_data.diff_percentile(n,m) = abs(percentile(n)-percentile(m));
                
                % param cross depth
                semivar_data.z_percentile(n,m) = abs(percentile(n)-percentile(m)) * abs(z(n)-z(m)); % abs(z(n)-d50(m));
                
            end

        end
                
        toc
        save( [folder_out,'m4_semivariogram_data_results',num2str(gsc_um),'microns_bins',num2str(binnb)], 'semivar_data', '-v7.3');
    else
        load('m4_semivariogram_data_results.mat')
    end


    %% actually make semivariorgam
    if makenew_idx == 1
        %% XY vs depth and stat moments
        XY_Zstatmoments = [semivar_data.xy_dist(:),semivar_data.diff_z(:),semivar_data.diff_percentile(:),semivar_data.z_percentile(:)];
        XY_Zstatmoments = sortrows(XY_Zstatmoments);
        XY_Zstatmoments(XY_Zstatmoments(:,1)==0,:) = [];

        intvec = linspace(1,max(XY_Zstatmoments(:,1)),binnb);
        for n = 1 : length(intvec)-1
            idx_XY_10{n} = find( XY_Zstatmoments(:,1) > intvec(n) & XY_Zstatmoments(:,1) < intvec(n+1));
        end
        
        semivar_data.names1 = {'xy_diff', 'depth_diff', 'percentile_diff'};
        semivar_data.XY_Zstatmoments = XY_Zstatmoments;
        semivar_data.idx_XY = idx_XY_10;


        %% depth vs stat moments
        Z_statmoments = [semivar_data.diff_z(:),semivar_data.diff_percentile(:)];
        Z_statmoments = sortrows(Z_statmoments);
        Z_statmoments(Z_statmoments(:,1)==0,:) = [];

        intvec = linspace(1,max(Z_statmoments(:,1))+1,binnb);
        for n = 1 : length(intvec)-1
            fprintf([num2str(intvec(n)) ' m to ' num2str(intvec(n+1)), 'm\n' ])
            idx_Z_10{n} = find( Z_statmoments(:,1) > intvec(n) & Z_statmoments(:,1) < intvec(n+1) );
        end
        semivar_data.names2 = {'depth_diff', 'percentile_diff'};
        semivar_data.Z_statmoments = Z_statmoments;
        semivar_data.idx_Z = idx_Z_10;
        
        semivar_data.folder_out = folder_out;
        semivar_data.gsc_um = gsc_um;
        semivar_data.binnb = binnb;
        
        save( [folder_out,'m4_semivariogram_data_results_idx',num2str(gsc_um),'microns_bins',num2str(binnb)], 'semivar_data', '-v7.3');
    else
        load('m4_semivariogram_data_results_idx.mat')
    end
else
    load('m4_semivariogram_data_results_idx.mat')
end

%% checkplots
plot_semivariograms(semivar_data)


%% make cross variogram (covariance of depth and statistical moment which shall be interpolated)
plot_crossvariogram(semivar_data);


function plot_semivariograms(varargin)

if length(varargin)==0
    load('semivariogram_data_results.mat')
else
    semivar_data = varargin{1, 1}; 
    clear varargin
end


%% perc vs distance
fig1 = figure('Color', 'w', 'Position', [80 100 440 800]);
s1 = subplot(3,1,1); hold on
for n = 1 : length(semivar_data.idx_XY)
    plot(nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},1))/1000,nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},3)),'k.')
end
title(['semivariogram gsc ',num2str(semivar_data.gsc_um),' um bins',num2str(semivar_data.binnb)])
ylabel(['averaged percentile diff']);xlabel('averaged distance difference [km]')

%% dist vs depth
s2 = subplot(3,1,2); hold on
for n = 1 : length(semivar_data.idx_XY)
    plot(nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},1))/1000,nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},2)),'k.')
end
ylabel('averaged depth difference [m]');xlabel('averaged distance difference [km]')

%% perc vs depth
s3 = subplot(3,1,3); hold on
for n = 1 : length(semivar_data.idx_Z)
    plot(nanmean(semivar_data.Z_statmoments(semivar_data.idx_Z{n},1)),nanmean(semivar_data.Z_statmoments(semivar_data.idx_Z{n},2)),'k.')
end
ylabel(['averaged percentile diff gsc ',num2str(semivar_data.gsc_um),' um']);xlabel('averaged depth difference [m]')

linkaxes([s1,s2,s3],'x')
saveas(fig1, [semivar_data.folder_out,'m4_semivariogram_',num2str(semivar_data.gsc_um),'microns_bins',num2str(semivar_data.binnb),'.fig'])


function plot_crossvariogram(semivar_data)

cross_variogram_z_perc = zeros(length(semivar_data.idx_XY), 1);
   

for n = 1 : length(semivar_data.idx_XY)
    
    bin_km(n) = nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},1))/1000;
    cross_variogram_z_perc(n)  = .5*nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},2) .* semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},3)); % depth * d50
    cross_variogram_z_cross_perc(n)  = .5*nanmean(semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},2) .* semivar_data.XY_Zstatmoments(semivar_data.idx_XY{n},4)); % depth * d50
    
end

fig3 = figure('Color', 'w', 'Position', [1000 500 600 400]);
plot(bin_km,cross_variogram_z_cross_perc,'k.')
xlabel('averaged distance difference [km]');ylabel('cross variogram (depth cross perc)');
title([num2str(semivar_data.gsc_um ),' microns bins',num2str(semivar_data.binnb)])

saveas(fig3, [semivar_data.folder_out,'m4_crossvariograms_2_',num2str(semivar_data.gsc_um ),'micron_bins',num2str(semivar_data.binnb),'.fig'])



