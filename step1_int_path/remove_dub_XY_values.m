function [ X,Y,Z,stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,stat_D10,stat_D90,stat_mode_1,stat_modestatus,grabsamplename,grabsampletime,bathy, X_bathy, Y_bathy  ] = ...
    remove_dub_XY_values(X,Y,Z,stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,stat_D10,stat_D90,stat_mode_1,stat_modestatus,grabsamplename,grabsampletime,bathy, X_bathy, Y_bathy )


A = sum([X, Y],2);
[uniqueA i j] = unique(A,'first');
indexToDupes = find(not(ismember(1:numel(A),i)));


X(indexToDupes) = [];
Y(indexToDupes) = [];
Z(:,indexToDupes) = [];
stat_mean(indexToDupes) = [];
stat_median(indexToDupes) = [];
stat_skew(indexToDupes) = [];
stat_std_dev_um(indexToDupes) = [];
stat_sort_McL(indexToDupes) = [];
stat_D10(indexToDupes) = [];
stat_D90(indexToDupes) = [];
stat_mode_1(indexToDupes) = [];
stat_modestatus(indexToDupes) = [];
grabsamplename(indexToDupes) = [];
grabsampletime(indexToDupes) = [];
bathy(indexToDupes) = [];
X_bathy(indexToDupes) = [];
Y_bathy(indexToDupes) = [];
