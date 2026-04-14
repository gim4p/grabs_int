function make_gis_table_distribution(grabsint,filename_out,folder_out)


%% fill table
table1_name = ['out1_grabs_', filename_out];
table2_name = ['out1_reggrid_',filename_out];
table3_name = ['out1_modelgrid_',filename_out];


%% write three tables
%% table 1 grabs
sc_nb = size(grabsint.grabs.Z'  ,2);
[ta_b1, tab_names1] = table1nofun(grabsint,sc_nb);
ta_b1.Properties.VariableNames  = tab_names1;


%% table 2 regular interpolation
sc_nb = length(grabsint.gsc_sievers_recon);
[ta_b2, tab_names2] = table2nofun(grabsint,sc_nb);
ta_b2.Properties.VariableNames  = tab_names2;


%% table 3 interpolation on claytons grid
sc_nb = length(grabsint.gsc_sievers_recon);
[ta_b3, tab_names3] = table3nofun(grabsint,sc_nb);
ta_b3.Properties.VariableNames  = tab_names3;


%% export CSV
cd(folder_out);

writetable(ta_b1, table1_name,  'Delimiter', '\t' );
writetable(ta_b2, table2_name,  'Delimiter', '\t' );
writetable(ta_b3, table3_name,  'Delimiter', '\t' );



function [ta_b, tab_names] = table1nofun(stat_combined,sc_nb)

grabs = stat_combined.grabs;

base_cols = {
    grabs.grabsamplename, ...
    grabs.grabsampletime, ...
    grabs.X, ...
    grabs.Y, ...
    grabs.stat_mean, ...
    grabs.stat_median, ...
    grabs.stat_skew, ...
    grabs.stat_std_dev_um, ...
    grabs.stat_mode_1, ...
    grabs.stat_modestatus
};

Z_cols = num2cell(grabs.Z(1:sc_nb, :)', 1);

ta_b = table(base_cols{:}, Z_cols{:});

tab_names = {
    'name', 'timenb', 'X_m', 'Y_m', ...
    'mean_um', 'median_um', 'skew', 'stdev_um', ...
    'mode_1_um', 'modestatus'
};

gsc_names(1,:) = arrayfun(@(x) ['um_' num2str(x)], ...
                     stat_combined.gsc(1:sc_nb), ...
                     'UniformOutput', false);

tab_names = [tab_names, gsc_names];


function [ta_b, tab_names] = table2nofun(grabsint,sc_nb)

base_cols = {
    grabsint.regulargridinterpolation.X_grid(:), ...
    grabsint.regulargridinterpolation.Y_grid(:), ...
    grabsint.regulargridinterpolation.stat_mean(:), ...
    grabsint.regulargridinterpolation.stat_median(:), ...
    grabsint.regulargridinterpolation.stat_mode_1(:), ...
    grabsint.regulargridinterpolation.stat_modestatus(:) };

psd = grabsint.regulargridinterpolation.psd_all2D;
psd_sievers = grabsint.regulargridinterpolation.psd_recon_all2D;
n = sc_nb;

psd_cols = num2cell(psd(:,1:n), 1);
psd_s_cols = num2cell(psd_sievers(:,1:n), 1);

ta_b =  table(base_cols{:}, psd_cols{:}, psd_s_cols{:} );

tab_names = [
    {'X_m','Y_m','mean_um','median_um','mode_1_um','modestatus'}, ...
    strcat("um_", string(grabsint.gsc_sievers_recon(1:n))), ...
    strcat("siev_um_", string(grabsint.gsc_sievers_recon(1:n)))];



function [ta_b, tab_names] = table3nofun(stat_combined,sc_nb)

g = stat_combined.claytongridinterpolation;

X = g.X_grid(:);
Y = g.Y_grid(:);

stat_mean = g.stat_mean(:);
stat_median = g.stat_median(:);
stat_mode_1 = g.stat_mode_1(:);
stat_modestatus = g.stat_modestatus(:);

idx = ~isnan(stat_median);

X = X(idx);
Y = Y(idx);
stat_mean = stat_mean(idx);
stat_median = stat_median(idx);
stat_mode_1 = stat_mode_1(idx);
stat_modestatus = stat_modestatus(idx);

psd = g.psd_all2D(idx, 1:sc_nb);
psd_s = g.psd_recon_all2D(idx, 1:sc_nb);

ta_b = table(X, Y, stat_mean, stat_median, stat_mode_1, stat_modestatus);

ta_b = [ta_b array2table(psd) array2table(psd_s)];

tab_names = [
    {'X_m','Y_m','mean_um','median_um','mode_1_um','modestatus'}, ...
    strcat("um_", string(stat_combined.gsc_sievers_recon(1:sc_nb))), ...
    strcat("siev_um_", string(stat_combined.gsc_sievers_recon(1:sc_nb)))
];
