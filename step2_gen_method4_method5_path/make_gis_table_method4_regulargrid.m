function make_gis_table_method4_regulargrid(method4,grabsint,fname,folder_out)
% Claytons size classes


%% fill table
thetacross=num2str(grabsint.regulargridinterpolation.m4_theta_cross);
thetacross = strrep(thetacross,'.','_');
table_name = ['method4statfrominterpolatedPSDs_thetacross_',thetacross,'_',fname];


%% table method 4 statistic moments recalculated from interpolated PSD
[ta_b,tab_names] = make_ta_b(method4,grabsint);


%% export CSV
ta_b.Properties.VariableNames  = tab_names;

cd(folder_out);

writetable(ta_b, table_name,  'Delimiter', '\t' );

cd ..


function [ta_b, tab_names] = make_ta_b(method4, grabsint)

Xtab = method4.X;
Ytab = method4.Y;

stat_mean   = method4.mean;
stat_median = method4.median;
stat_D10    = method4.D10;
stat_D90    = method4.D90;

psd = grabsint.regulargridinterpolation.psd_all2D;

idxnonan = find(~isnan(stat_median));

gsc_out = grabsint.gsc_model;

data = {
    Xtab(idxnonan), ...
    Ytab(idxnonan), ...
    stat_mean(idxnonan), ...
    stat_median(idxnonan), ...
    stat_D10(idxnonan), ...
    stat_D90(idxnonan)};

tab_names = {
    'X_m','Y_m','mean_um','median_um','D10','D90'};

nPSD = size(psd,2);

for i = 1:nPSD
    data{end+1} = psd(idxnonan,i);
    tab_names{end+1} = ['um' num2str(gsc_out(i))];
end

ta_b = table(data{:}, 'VariableNames', tab_names);



