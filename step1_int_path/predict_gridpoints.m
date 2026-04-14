

function [ypred_sed,ypred_bath]=predict_gridpoints(task,grid_points,dmodel_sediment_semi_pri_sec_cross)

for n = 1
    ypred_sed(n)=NaN;
    ypred_bath(n)=NaN;
    try
        
        point = grid_points(task, 1);
        [ysed, mse, ydepth, dmse] = co_kriging_predictor(point, dmodel_sediment_semi_pri_sec_cross);
        ypred_sed(n) = ysed;
        
        try
            ypred_bath(n) = ydepth;
        catch
            ypred_bath(n) = NaN; % xx = Xgrid; yy = Ygrid(:); figure; scatter(xx(1:length(ypred_sed)), yy(1:length(ypred_sed)), 22, ypred_sed,'filled')
        end
        
    catch
        
    end
    
end

% ypred_sed(ypred_sed<0)=0;
% ypred_bath(ypred_bath<0)=0;



%%
%{
ypred = zeros(size(grid_points, 1), 1);
for i = 1  :  size(grid_points, 1)
    point = grid_points(i, :);
    
    [ysed, mse, ydepth, dmse] = co_kriging_predictor(point, dmodel_sediment_semi_pri_sec_cross);
    
    ypred_sed(i) = ysed;
    try
        ypred_bath(i) = ydepth;
    catch
        ypred_bath(i) = NaN; % xx = Xgrid; yy = Ygrid(:); figure; scatter(xx(1:length(ypred_sed)), yy(1:length(ypred_sed)), 22, ypred_sed,'filled')
    end
end

ypred_sed(ypred_sed<0)=0;
ypred_bath(ypred_bath<0)=0;
%}

