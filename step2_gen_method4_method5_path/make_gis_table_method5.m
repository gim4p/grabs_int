function make_gis_table_method5(method5,grabsint,fname,folder_out)


%% fill table
table_name = ['method5statint_', fname];
         
%% table method 5 statistic moments
[ta_b,tab_names] = make_ta_b(method5,grabsint);


%% export CSV
ta_b.Properties.VariableNames  = tab_names;

cd(folder_out);

writetable(ta_b, table_name,  'Delimiter', '\t' );
cd ..


function [ta_b, tab_names] = make_ta_b(method5, grabsint)

Xtab = method5.X;
Ytab = method5.Y;
stat_mean = method5.mean;
stat_median = method5.median;

idxnonan = ~isnan(stat_median);

psd = grabsint.claytongridinterpolation.psd_recon_all2D;
ncols = size(psd, 2);

if isfield(grabsint, 'gsc_sievers_recon')
    gsc_out = grabsint.gsc_sievers_recon;
else
    gsc_out = grabsint.gsc_model;
end

gsc_out = gsc_out(:);

base_cols = {
    Xtab(idxnonan), ...
    Ytab(idxnonan), ...
    stat_mean(idxnonan), ...
    stat_median(idxnonan)};

psd_cols = num2cell(psd(idxnonan, 1:ncols), 1);

ta_b = table(base_cols{:}, psd_cols{:});

base_names = {'X_m','Y_m','mean_um','median_um'};
psd_names = "um" + string(gsc_out(1:ncols));

tab_names = [base_names, cellstr(psd_names')];

ta_b.Properties.VariableNames = tab_names;


