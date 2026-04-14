function [X_bathy, Y_bathy, bathy_mat, out_idx] = harmonise_XY(X,Y,newharm,bathname,folder_out)

newcalc=1;

round_nn = 100;

minx = min(X);maxx = max(X);
miny = min(Y);maxy = max(Y);


%% load bathymetry
[bathy_mat, bathy_geo] = geotiffread(['datain/', bathname,'.tif']);

if min(bathy_mat(:)) == -9999; 
    bathy_mat(bathy_mat==-9999)=NaN;
    bathy_mat=bathy_mat*-1;
    bathy_mat(isnan(bathy_mat))=-5;
else
    bathy_mat(bathy_mat>1000)=NaN;
    bathy_mat(isnan(bathy_mat))=-5;
end

[X_bathy, Y_bathy] = meshgrid(bathy_geo.XWorldLimits(1) :  bathy_geo.CellExtentInWorldX  : bathy_geo.XWorldLimits(2)-bathy_geo.CellExtentInWorldX, bathy_geo.YWorldLimits(1) :  bathy_geo.CellExtentInWorldY  : bathy_geo.YWorldLimits(2)-bathy_geo.CellExtentInWorldY);

nn = 10;
X_bathy = X_bathy(1 : nn : end, 1 : nn : end);
Y_bathy = Y_bathy(1 : nn : end, 1 : nn : end);
bathy_mat = bathy_mat(1 : nn : end, 1 : nn : end);

clear mat_in; mat_in(1,:,:) = X_bathy;
X_bathy = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';
clear mat_in; mat_in(1,:,:) = Y_bathy;
Y_bathy = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';
clear mat_in; mat_in(1,:,:) = bathy_mat;
bathy_mat = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';

idxout = find( X_bathy < minx | X_bathy > maxx | Y_bathy < miny | Y_bathy > maxy);
X_bathy(idxout) = [];
Y_bathy(idxout) = [];
bathy_mat(idxout) = [];


%{
nst = 1;
nnn = 1;
nsp = length(X_bathy); %100000;
figure; scatter(X_bathy(nst:nnn:nsp), Y_bathy(nst:nnn:nsp), 12, bathy_mat(nst:nnn:nsp), 'filled')
%}

if newcalc == 1
    
    %% harmonise methods data sets (same XY)
    if newharm == 1
        fprintf('new bathymetry harmonisation\n')
        [XY_idx] = find_harmonising_idx([X_bathy,Y_bathy],[X,Y],round_nn);
    %     save( ['easygsh2grabs_alldata_20240715',num2str(nn),'th'], 'XY_idx', '-v7.3');
        save( [folder_out,'XYidx_',bathname,num2str(nn),'th'], 'XY_idx', '-v7.3');
    else
        load( ['XYidx_',bathname,num2str(nn),'thalldata']);
    %     load('easygsh2grabs_alldata10th.mat');
    %     load('bathymetry2grabs_alldata.mat');
    %     load('bathymetry2grabs_modelzoom.mat');
    end

    % bathy_out_idx = find(XY_idx == 0);
    % X_bathy(bathy_out_idx) = [];
    % Y_bathy(bathy_out_idx) = [];
    % bathy_mat(bathy_out_idx) = [];
    % 
    % XY_idx(XY_idx == 0) = [];
    % X = X(XY_idx);
    % Y = Y(XY_idx);

else
        
    load('G:\Clayton_paper\data\interpolation_routine_all_together\out\output_CoK_25Aug2024223142_nosmoothing_200mgrid\XYidx_easygsh-db_201510th.mat')
    
end

out_idx = find(XY_idx == 0);
XY_idx(XY_idx == 0) = [];
X_bathy = X_bathy(XY_idx);
Y_bathy = Y_bathy(XY_idx);
bathy_mat = bathy_mat(XY_idx); bathy_mat(bathy_mat>1e5) = -5;
bathy_mat = double(bathy_mat);

% X(out_idx) = [];
% Y(out_idx) = [];

%{
round(X_bathy(1,1)/round_nn)*round_nn == round(X(1,1)/round_nn)*round_nn  % now equal position in meter resolution
figure; hold on
plot(X_bathy,Y_bathy,'.')
plot(X,Y,'o')
%}


function [XY_idx_out] = find_harmonising_idx(XY_model,XY_m45,round_nn)

XY_model_round = XY_model; % [ round(XY_model(:,1)/round_nn)*round_nn , round(XY_model(:,2)/round_nn)*round_nn ];
XY_m45_round = XY_m45; % [ round(XY_m45(:,1)/round_nn)*round_nn   , round(XY_m45(:,2)/round_nn)*round_nn ];


%{
figure; hold on; Xtmp = 488311;
plot( XY_model_round(:,1), XY_model_round(:,2),'.' )
plot( XY_m45_round(:,1)  , XY_m45_round(:,2)  ,'o' )
plot( XY_model_round(Xfit,1), XY_model_round(Xfit,2),'bs' )
plot( XY_model_round(fits,1), XY_model_round(fits,2),'bs' )

plot( XY_model_round(Yfit,1), XY_model_round(Yfit,2),'rs' )
plot( XY_m45_round(n,1)  , XY_m45_round(n,2)  ,'*' )

XY_model_round(fits,2) - XY_m45_round(n,2)
XY_model_round(fits,1) - XY_m45_round(n,1)

%}

XY_idx_out = zeros(length(XY_m45),2);
tic
for n = 1 : length(XY_m45)
    
    if n/5e4 == round(n/5e4)
        fprintf(['\nprogress ', num2str(n/length(XY_model)), '\n'])
    end
    
    Xtmp = unique(XY_model_round(:,1));
    Ytmp = unique(XY_model_round(:,2));
    Xfit = find( Xtmp(interp1(Xtmp, 1:length(Xtmp), XY_m45_round(n,1), 'nearest', 'extrap')) == XY_model_round(:,1));
    Yfit = find( Ytmp(interp1(Ytmp, 1:length(Ytmp), XY_m45_round(n,2), 'nearest', 'extrap')) == XY_model_round(:,2));
    
    if isempty(Xfit)==0 & isempty(Yfit)==0
        
        fits = intersect(Xfit,Yfit);
        
        if length(fits) > 1
            dis_tance = []; dist_ance_X = []; dist_ance_Y = [];
            %plot( XY_m45(n,1), XY_m45(n,2), 'ys' )
            for Ytmp = 1 : length(fits)
                %plot( XY_model(fits(pp),1),XY_model(fits(pp),2),'*')
                dist_ance_X(Ytmp) = abs( XY_model(fits(Ytmp),1) - XY_m45(n,1) );
                dist_ance_Y(Ytmp) = abs( XY_model(fits(Ytmp),2) - XY_m45(n,2) );
            end
            dis_tance = sqrt( dist_ance_X.^2 + dist_ance_Y.^2 );
            fits = fits( find( dis_tance == min(dis_tance) ) );
        end

        XY_idx_out(n,1:length(fits)) = fits;
        
    end
    
end
toc

XY_idx_out = XY_idx_out(:,1);



