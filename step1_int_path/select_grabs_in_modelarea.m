function [X,Y,Z,stat_mean,stat_median,stat_skew,stat_sort,stat_sort_McL,stat_D10,stat_D90,stat_mode_1,stat_modestatus,grabsamplename,grabsampletime] = select_grabs_in_modelarea(X,Y,Z,stat_mean,stat_median,stat_skew,stat_sort,stat_sort_McL,stat_D10,stat_D90,stat_mode_1,stat_modestatus,grabsamplename,grabsampletime)

% poly = shaperead('datain/DOI.shp'); % 'clayton_area_polygon.shp' % 'clayton_modelarea_polygon.shp' %
% poly = shaperead('datain/testpoly.shp');
poly = shaperead('datain/clayton_modelarea_polygon.shp');
[in, ~] = inpolygon(X,Y,poly.X,poly.Y);
idx_in_poly = find(in==1);

X = X(idx_in_poly);
Y = Y(idx_in_poly);
Z = Z(:,idx_in_poly);
stat_mean = stat_mean(idx_in_poly);
stat_median = stat_median(idx_in_poly);
stat_D10 = stat_D10(idx_in_poly);
stat_D90 = stat_D90(idx_in_poly);
stat_mode_1 = stat_mode_1(idx_in_poly);
stat_modestatus = stat_modestatus(idx_in_poly);
stat_skew = stat_skew(idx_in_poly);
stat_sort = stat_sort(idx_in_poly);
stat_sort_McL = stat_sort_McL(idx_in_poly);

grabsamplename = grabsamplename(idx_in_poly);
grabsampletime = grabsampletime(idx_in_poly);
