function [Xint,Yint,bathy_fit] = loadbathy(X,Y,gridresolution,bathname)


%% make grid for interpolation
[Xint,Yint] = meshgrid(min(X) :  gridresolution  : max(X), min(Y) :  gridresolution  : max(Y));


%% load emodnet bathymetry
[bathy_mat, bathy_geo] = geotiffread(['datain/', bathname,'.tif']);
if min(bathy_mat(:)) == -9999; % not emodnet (means Clayton's bathy)
    bathy_mat(bathy_mat==-9999)=NaN;
    bathy_mat(bathy_mat>0)=NaN;
    bathy_mat=bathy_mat*-1;
    bathy_mat(isnan(bathy_mat))=-5;
end


[X_bathy, Y_bathy] = meshgrid(bathy_geo.XWorldLimits(1) :  bathy_geo.CellExtentInWorldX  : bathy_geo.XWorldLimits(2)-bathy_geo.CellExtentInWorldX, bathy_geo.YWorldLimits(1) :  bathy_geo.CellExtentInWorldY  : bathy_geo.YWorldLimits(2)-bathy_geo.CellExtentInWorldY);

nn = 10;
X_bathy = X_bathy(1 : nn : end, 1 : nn : end);
Y_bathy = Y_bathy(1 : nn : end, 1 : nn : end);
bathy_mat = bathy_mat(1 : nn : end, 1 : nn : end);
bathy_mat = flipud(bathy_mat);

%% fit bathymetry to interpolated grid
bathy_fit = interp2(X_bathy,Y_bathy,bathy_mat,Xint,Yint);
bathy_fit(bathy_fit>100)=NaN; 

co_factor = 15;

