%% interpolate mode by probability density function (like in my QGis plugin)
function [jjn] = PDFint_categorical_data(X_coo,Y_coo,X,Y,category)

[Xgrid,Ygrid] = meshgrid(X_coo,Y_coo);

xy = [X,Y];
MIN_XY = [min(X),min(Y)];
MAX_XY = [max(X),max(Y)];

sc = unique(category);
resolution_xy = 100; % yet don't get it really (always to the next power of 2, other way around would be better, maybe change later) % figure;plot([300,100,50,30,500,600],[512,128,64,32,512,1024],'*')

for n = 1 : length(sc)
    
    idxtmp = find(category == sc(n));
    xy_in = xy(idxtmp,:);
    
    
    %% kde
    try
        [bandwidth,density,Xgrid_kde,Ygrid_kde]=kde2d(xy_in,resolution_xy,MIN_XY,MAX_XY);
    catch
        density = zeros( 2^ceil(log2(resolution_xy)) );
    end
    
    
    %% make right gridresolution and equidistant grid
    if n == 1
        fprintf(['kde resolution x and y [m]: ',num2str([median(diff(Xgrid_kde(1,:))),median(diff(Ygrid_kde(:,1)))]),'\n'])
    end
    density_rightresolution = interp2(Xgrid_kde,Ygrid_kde,density,Xgrid,Ygrid);
    density_sc_cube(:,:,n) = density_rightresolution * length(idxtmp);
    

end


%% get indicies for maximum values (nth mode)
jjn1 = permute(density_sc_cube,[3 1 2]);
[~,b]=max(jjn1);
jjn = permute(b,[2 3 1]); % backwards into array again


for n = 1 : length(sc)
    
    jjn(jjn == (n)) = sc(n);
    
end






