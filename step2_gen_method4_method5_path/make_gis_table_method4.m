function make_gis_table_method4(method4,grabsint,fname,folder_out)

%% fill table
table_name = ['method4statfrominterpolatedPSDs_',fname];
         
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

idxnonan = ~isnan(stat_median);

psd = grabsint.claytongridinterpolation.psd_all2D;
gsc_out = grabsint.gsc_model(:);

base_data = {
    Xtab(idxnonan), ...
    Ytab(idxnonan), ...
    stat_mean(idxnonan), ...
    stat_median(idxnonan), ...
    stat_D10(idxnonan), ...
    stat_D90(idxnonan)};

base_names = {'X_m','Y_m','mean_um','median_um','D10','D90'};

nPSD = size(psd,2);

psd_data = arrayfun(@(i) psd(idxnonan,i), 1:nPSD, 'UniformOutput', false);
nGSC = length(gsc_out);
gsc_names = arrayfun(@(i) sprintf('um%d', gsc_out(i)), 1:nGSC, 'UniformOutput', false);

ta_b = table(base_data{:}, psd_data{:});

tab_names = [base_names, gsc_names];

