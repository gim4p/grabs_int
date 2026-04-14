function [X,Y,Z,stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,stat_D10,stat_D90,stat_mode_1,stat_modestatus,grabsamplename,grabsampletime] = ...
    harmoniseback(X,Y,Z,stat_mean,stat_median,stat_skew,stat_std_dev_um,stat_sort_McL,stat_D10,stat_D90,stat_mode_1,stat_modestatus,grabsamplename,grabsampletime,out_idx)


X(out_idx) = [];
Y(out_idx) = [];
Z(:,out_idx) = [];
stat_mean(out_idx) = [];
stat_median(out_idx) = [];
stat_skew(out_idx) = [];
stat_std_dev_um(out_idx) = [];
stat_sort_McL(out_idx) = [];
stat_D10(out_idx) = [];
stat_D90(out_idx) = [];
stat_mode_1(out_idx) = [];
stat_modestatus(out_idx) = [];
grabsamplename(out_idx) = [];
grabsampletime(out_idx) = [];

