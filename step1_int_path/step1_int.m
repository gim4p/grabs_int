function step1_int(interpolation_method,p,savefiles,timeframe,furtherGeoZoom,tinytestzoom,newharm,gridresolution,folder_out,grabs_fname_out,fname_out_int,fname,semivar_again)

functionpath = pwd;


%% choose bathymetry
bathname = 'easygsh-db_2015_clipped';


%% load sedata
load([folder_out,'\',grabs_fname_out])


%%
gzclassmax = length(stat_combined.gz_classes);
gsc = stat_combined.gz_classes(1:gzclassmax);
grabsamplename = stat_combined.samplename;
grabsampletime = stat_combined.timenumber;
X(:,1) = stat_combined.XY(1,:);
Y(:,1) = stat_combined.XY(2,:);
Z(:,:) = stat_combined.dis_percent; Z = Z(1:gzclassmax,:);
stat_mean(:,1) = stat_combined.arit_mean;
stat_median(:,1) = stat_combined.median;
stat_D10(:,1) = stat_combined.D10;
stat_D90(:,1) = stat_combined.D90;
stat_mode_1(:,1) = stat_combined.mode_1(1,:);
stat_modestatus(:,1) = stat_combined.modestatus;
stat_skew(:,1) = stat_combined.skewness_matlab;
stat_std_dev_um(:,1) = stat_combined.sort_um;
stat_sort_McL(:,1) = stat_combined.sorting_num_McLaren;

%{
%% reinserted (was not in repo)
%% grabs in certain area
[X,Y,Z,stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,stat_D10,stat_D90,stat_mode_1,stat_modestatus,grabsamplename,grabsampletime] = ...
    select_grabs_in_modelarea(X,Y,Z,stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,stat_D10,stat_D90,stat_mode_1,stat_modestatus,grabsamplename,grabsampletime);
%%
%}

if strcmp(interpolation_method,'CoK')
    %% Co-Kriging
    %% load emodnet bathymetry, and fit to sediment data
    [X_bathy, Y_bathy, bathy, out_idx] = harmonise_XY(X,Y,newharm,bathname,folder_out);
    
    [X,Y,Z,stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,stat_D10,stat_D90,stat_mode_1,stat_modestatus,grabsamplename,grabsampletime] = ...
        harmoniseback(X,Y,Z,stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,stat_D10,stat_D90,stat_mode_1,stat_modestatus,grabsamplename,grabsampletime,out_idx);
    
    [ X,Y,Z,stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,stat_D10,stat_D90,stat_mode_1,stat_modestatus,grabsamplename,grabsampletime,bathy, X_bathy, Y_bathy  ] = ...
        remove_dub_XY_values(X,Y,Z,stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,stat_D10,stat_D90,stat_mode_1,stat_modestatus,grabsamplename,grabsampletime,bathy, X_bathy, Y_bathy );
    
    grabs.X = X;
    grabs.Y = Y;
    grabs.Z = Z;
    grabs.sz=stat_combined.gz_classes;
    save([folder_out,'grabsforint'],'grabs','-v7.3')
    
    
    
    %% interpolation Methode 5, Co-Kriging (necessary because Sievers included bathymetry and we take him as industrial standard.. :()
    [Xgrid, Ygrid,stat_mean_int,stat_median_int,stat_std_dev_um_int,stat_skew_int] = ...
                                        co_kriging_for_method5(X,Y,gridresolution,...
                                                               stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,...
                                                               stat_D10,stat_D90,...
                                                               bathy,folder_out,semivar_again);
    
    %% interpolation Methode 4 Co-Kriging
    krigout.gscin = gsc;
    [Zmat_all,Zmat_n,m4_theta_cross,gz_wanted] = co_kriging_for_method4(X,Y,Z(2:end-1,:),gsc,bathy,gridresolution,folder_out,semivar_again);
    gsc=gz_wanted;
    krigout.gsc_wanted = gz_wanted;
    
    
    %% save to be sure, and have a mat file for rechecking later   
    krigout.Xgrid=Xgrid;
    krigout.Ygrid=Ygrid;
    krigout.stat_mean_int=stat_mean_int;
    krigout.stat_median_int=stat_median_int;
    krigout.stat_std_dev_um_int=stat_std_dev_um_int;
    krigout.stat_skew_int=stat_skew_int;
    krigout.Zmat_all=Zmat_all;
    krigout.Zmat_n=Zmat_n;
    save([folder_out,'krigout_inbetween'],'krigout','-v7.3')
    
    cd ..; load('gsc_halfsize_tmp'); delete([pwd,'/','gsc_halfsize_tmp.mat']); cd step1_int_path
    if gsc_halfsize == 1
        gscm5recalc = stat_combined.gz_classes_model; % half size
    else
        gscm5recalc = gsc(2:end-1); % no half size
    end
    
    
    %% Method 5 psd reconstruction from statistical moments
    [PSD_sievers_reconstructed,PSD_recon_mat,gsc_sievers_reconstructed] = ...
            psd_reconstruction_sort_skew_D50(stat_median_int, stat_std_dev_um_int, stat_skew_int, gscm5recalc);
    
    X_coo = Xgrid(1,:)';
    Y_coo = Ygrid(:,1);
    Xint = Xgrid;
    Yint = Ygrid;
    
    
else
    %% IWD
    %% load emodnet bathymetry, and fit to sediment data
    [X_bathy, Y_bathy, bathy_datapoints, out_idx] = harmonise_XY(X,Y,newharm,bathname,folder_out);
    [Xint,Yint,bathy_fit_int] = loadbathy(X,Y,gridresolution,bathname);
    
    
    %% interpolation IDW Method 5 and Method 4
    [Xint,Yint,Zmat_all,Zmat_n,X_coo,Y_coo,stat_mean_int,stat_median_int,stat_skew_int,stat_std_dev_um_int,stat_sort_McL_int,stat_D10_int,stat_D90_int] = ...
        psd_class_interpolation_idw(p,gridresolution,gsc,X,Y,Z,stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,stat_D10,stat_D90,bathy_datapoints,bathy_fit_int,grabsampletime);
    
    cd ..; load('gsc_halfsize_tmp'); delete([pwd,'/','gsc_halfsize_tmp.mat']); cd step1_int_path
    if gsc_halfsize == 1
        gscm5recalc = stat_combined.gz_classes_model; % half size
    else
        gscm5recalc = gsc(2:end-1); % no half size
    end
    
    % reconstruct psd from statistical moments for Method 5
    [PSD_sievers_reconstructed,PSD_recon_mat,gsc_sievers_reconstructed] = ...
    psd_reconstruction_sort_skew_D50(stat_median_int, stat_std_dev_um_int, stat_skew_int, gscm5recalc);

end


%% categorical interpolation (no bathymetry input!)
fprintf('interpolation (IDW or CoK) done, next: categorical data interpolation (no bathy)\n')
[stat_mode_1_pde]     = PDFint_categorical_data(X_coo,Y_coo,X,Y,stat_mode_1);
[stat_modestatus_pde] = PDFint_categorical_data(X_coo,Y_coo,X,Y,stat_modestatus);


%% fit to Clayton's model grid afterwards
load('datain/nf_model_grid_v7mat.mat')
Xint_c = data.X;
Yint_c = data.Y;

[inX] = find((Xint_c>max(X)) | Xint_c<min(X));
[inY] = find((Yint_c>max(Y)) | Yint_c<min(Y));
chosen = unique([inX;inY]);
Xinttmp = Xint_c;
Xinttmp(chosen) = NaN;
[a,b]=find(diff(isnan(Xinttmp))~=0);

Xint_c = Xint_c(min(a):max(a) , min(b) : max(b));
Yint_c = Yint_c(min(a):max(a) , min(b) : max(b));

stat_mean_int_c = interp2(Xint,Yint,stat_mean_int,Xint_c,Yint_c);
stat_median_int_c = interp2(Xint,Yint,stat_median_int,Xint_c,Yint_c);
stat_skew_int_c = interp2(Xint,Yint,stat_skew_int,Xint_c,Yint_c);
stat_std_dev_um_int_c = interp2(Xint,Yint,stat_std_dev_um_int,Xint_c,Yint_c);

stat_mode_1_pdeint_c = interp2(Xint,Yint,stat_mode_1_pde,Xint_c,Yint_c);
stat_modestatus_pde_c = interp2(Xint,Yint,stat_modestatus_pde,Xint_c,Yint_c);

for n = 1 : size(Zmat_all,3)
    Zmat_all_c(:,:,n) = interp2(Xint,Yint,Zmat_all(:,:,n),Xint_c,Yint_c);
end
Zmat_n_c = permute(Zmat_all_c,[3 1 2]);
Zmat_n_c = reshape(Zmat_n_c, [size(Zmat_n_c,1), size(Zmat_n_c,2)*size(Zmat_n_c,3) ] )' ;

for n = 1 : size(PSD_sievers_reconstructed,3)
    PSD_reconstructed_c(:,:,n) = interp2(Xint,Yint,PSD_sievers_reconstructed(:,:,n),Xint_c,Yint_c);
end
PSD_reconstructed_n_c = permute(PSD_reconstructed_c,[3 1 2]);
PSD_reconstructed_n_c = reshape(PSD_reconstructed_n_c, [size(PSD_reconstructed_n_c,1), size(PSD_reconstructed_n_c,2)*size(PSD_reconstructed_n_c,3) ] )' ;


%%
grabsint.gsc = gsc;
grabsint.gsc_sievers_recon = gsc_sievers_reconstructed;
grabsint.gsc_model = gsc_sievers_reconstructed; %stat_combined.gz_classes_model;

grabsint.grabs.grabsamplename = grabsamplename';
grabsint.grabs.grabsampletime = grabsampletime';
grabsint.grabs.X = X;
grabsint.grabs.Y = Y;
grabsint.grabs.Z = Z;

grabsint.grabs.stat_mean = stat_mean;
grabsint.grabs.stat_median = stat_median;
grabsint.grabs.stat_skew = stat_skew;
grabsint.grabs.stat_std_dev_um = stat_std_dev_um;

grabsint.grabs.stat_mode_1 = stat_mode_1;
grabsint.grabs.stat_modestatus = stat_modestatus;

try
    grabsint.regulargridinterpolation.m4_theta_cross=m4_theta_cross;
catch
    grabsint.regulargridinterpolation.m4_theta_cross='no';
end

grabsint.regulargridinterpolation.gridresolution = gridresolution;
grabsint.regulargridinterpolation.p = p;
grabsint.regulargridinterpolation.X_coo = X_coo;
grabsint.regulargridinterpolation.Y_coo = Y_coo;
grabsint.regulargridinterpolation.X_grid = Xint;
grabsint.regulargridinterpolation.Y_grid = Yint;
grabsint.regulargridinterpolation.psd_recon_all3D = PSD_sievers_reconstructed;
grabsint.regulargridinterpolation.psd_recon_all2D = PSD_recon_mat;

if length(find(nansum(Zmat_n)==0)) > 0
    Zmat_all(:,:,find(nansum(Zmat_n)==0)) = [];
    Zmat_n(:,find(nansum(Zmat_n)==0)) = [];
end
grabsint.regulargridinterpolation.psd_all3D = Zmat_all;
grabsint.regulargridinterpolation.psd_all2D = Zmat_n;

grabsint.regulargridinterpolation.stat_mean = stat_mean_int;
grabsint.regulargridinterpolation.stat_median = stat_median_int;
grabsint.regulargridinterpolation.stat_skew_int = stat_skew_int;
grabsint.regulargridinterpolation.stat_sort_int = stat_std_dev_um_int;

grabsint.regulargridinterpolation.stat_mode_1 = stat_mode_1_pde;
grabsint.regulargridinterpolation.stat_modestatus = stat_modestatus_pde;
grabsint.claytongridinterpolation.X_grid = Xint_c;
grabsint.claytongridinterpolation.Y_grid = Yint_c;

if length(find(nansum(Zmat_n_c)==0)) > 0
    Zmat_all_c(:,:,find(nansum(Zmat_n_c)==0)) = [];
    Zmat_n_c(:,find(nansum(Zmat_n_c)==0)) = [];
end
grabsint.claytongridinterpolation.psd_all3D = Zmat_all_c;
grabsint.claytongridinterpolation.psd_all2D = Zmat_n_c;
grabsint.claytongridinterpolation.psd_recon_all3D = PSD_reconstructed_c;
grabsint.claytongridinterpolation.psd_recon_all2D = PSD_reconstructed_n_c;
grabsint.claytongridinterpolation.stat_mean = stat_mean_int_c;
grabsint.claytongridinterpolation.stat_median = stat_median_int_c;
grabsint.claytongridinterpolation.stat_skew_int_c = stat_skew_int_c;
grabsint.claytongridinterpolation.stat_std_dev_um_int_c = stat_std_dev_um_int_c;

grabsint.claytongridinterpolation.stat_mode_1 = stat_mode_1_pdeint_c;
grabsint.claytongridinterpolation.stat_modestatus = stat_modestatus_pde_c;


%% data output
if savefiles == 1
    cd(folder_out); save(fname_out_int, 'grabsint', '-v7.3');
    cd(functionpath)
    make_gis_table_distribution(grabsint,fname_out_int,folder_out)
    cd(functionpath)
end






