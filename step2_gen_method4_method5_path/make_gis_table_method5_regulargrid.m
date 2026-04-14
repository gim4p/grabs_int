function make_gis_table_method5_regulargrid(method5,grabsint,fname,folder_out)


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

psd = grabsint.regulargridinterpolation.psd_recon_all2D;
N = size(psd, 2);

base = {
    Xtab(idxnonan), ...
    Ytab(idxnonan), ...
    stat_mean(idxnonan), ...
    stat_median(idxnonan)};

for i = 1:N
    base{end+1} = psd(idxnonan, i);
end

ta_b = table(base{:});

gsc_out = grabsint.gsc_sievers_recon;

tab_names = cell(1, 4 + N);
tab_names(1:4) = {'X_m','Y_m','mean_um','median_um'};

for i = 1:N
    if i <= numel(gsc_out)
        tab_names{4+i} = ['um' num2str(gsc_out(i))];
    else
        tab_names{4+i} = ['um' num2str(i)];
    end
end


