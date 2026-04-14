function make_gis_table_distribution(stat_combined,table_name,folder_out)


%% write table
sc_nb = size(stat_combined.dis_percent,1);
[ta_b1, tab_names1] = tablenofun(stat_combined,sc_nb);
ta_b1.Properties.VariableNames  = tab_names1;

[ta_b2, tab_names2] = tablenofun_sieving(stat_combined);
ta_b2.Properties.VariableNames  = tab_names2;

cd(folder_out);  
writetable(ta_b1, table_name,  'Delimiter', '\t' );
writetable(ta_b2, [table_name,'_sieving'],  'Delimiter', '\t' );



%% sieving out
function [ta_b, tab_names] = tablenofun_sieving(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ['gs_1um_1um_',num2str(size(stat_combined.sieving,1)),'um'] };

ta_b = [ta_b , table(stat_combined.sieving') ];


%% grabs out
function [ta_b, tab_names] = tablenofun(stat_combined,sc_nb)


if sc_nb == 6
    [ta_b, tab_names] = tablenofun6(stat_combined);
elseif sc_nb == 7
    [ta_b, tab_names] = tablenofun7(stat_combined);
elseif sc_nb == 8
    [ta_b, tab_names] = tablenofun8(stat_combined);
elseif sc_nb == 9
    [ta_b, tab_names] = tablenofun9(stat_combined);
elseif sc_nb == 10
    [ta_b, tab_names] = tablenofun10(stat_combined);
elseif sc_nb == 11
    [ta_b, tab_names] = tablenofun11(stat_combined);
elseif sc_nb == 12
    [ta_b, tab_names] = tablenofun12(stat_combined);
elseif sc_nb == 13
    [ta_b, tab_names] = tablenofun13(stat_combined);
elseif sc_nb == 14
    [ta_b, tab_names] = tablenofun14(stat_combined);
elseif sc_nb == 15
    [ta_b, tab_names] = tablenofun15(stat_combined);
elseif sc_nb == 16
    [ta_b, tab_names] = tablenofun16(stat_combined);
elseif sc_nb == 17
    [ta_b, tab_names] = tablenofun17(stat_combined);
elseif sc_nb == 18
    [ta_b, tab_names] = tablenofun18(stat_combined);
elseif sc_nb == 19
    [ta_b, tab_names] = tablenofun19(stat_combined);
elseif sc_nb == 20
    [ta_b, tab_names] = tablenofun20(stat_combined);
elseif sc_nb == 21
    [ta_b, tab_names] = tablenofun21(stat_combined);
elseif sc_nb == 22
    [ta_b, tab_names] = tablenofun22(stat_combined);
elseif sc_nb == 40 % Clayton wants fine sed intervals
    [ta_b, tab_names] = tablenofun40(stat_combined);
elseif sc_nb == 41 % Clayton wants fine sed intervals
    [ta_b, tab_names] = tablenofun41(stat_combined);
end


%%
function [ta_b, tab_names] = tablenofun6(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)'    );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun7(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun8(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     2
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)'  );      

%     stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
%     stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
%     stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))]   }; 
         
%              ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
%              ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
%              ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
%              ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun9(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun10(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun11(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun12(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun13(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)',...    3
    stat_combined.dis_percent(13,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))],...
             ['um_',num2str(stat_combined.gz_classes(13,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun14(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)',...    3
    stat_combined.dis_percent(13,:)', stat_combined.dis_percent(14,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))],...
             ['um_',num2str(stat_combined.gz_classes(13,1))], ['um_',num2str(stat_combined.gz_classes(14,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun15(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)',...    3
    stat_combined.dis_percent(13,:)', stat_combined.dis_percent(14,:)', stat_combined.dis_percent(15,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))],...
             ['um_',num2str(stat_combined.gz_classes(13,1))], ['um_',num2str(stat_combined.gz_classes(14,1))],...
             ['um_',num2str(stat_combined.gz_classes(15,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun16(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)',...    3
    stat_combined.dis_percent(13,:)', stat_combined.dis_percent(14,:)', stat_combined.dis_percent(15,:)',...    3
    stat_combined.dis_percent(16,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))],...
             ['um_',num2str(stat_combined.gz_classes(13,1))], ['um_',num2str(stat_combined.gz_classes(14,1))],...
             ['um_',num2str(stat_combined.gz_classes(15,1))], ['um_',num2str(stat_combined.gz_classes(16,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun17(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)',...    3
    stat_combined.dis_percent(13,:)', stat_combined.dis_percent(14,:)', stat_combined.dis_percent(15,:)',...    3
    stat_combined.dis_percent(16,:)', stat_combined.dis_percent(17,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))],...
             ['um_',num2str(stat_combined.gz_classes(13,1))], ['um_',num2str(stat_combined.gz_classes(14,1))],...
             ['um_',num2str(stat_combined.gz_classes(15,1))], ['um_',num2str(stat_combined.gz_classes(16,1))],...
             ['um_',num2str(stat_combined.gz_classes(17,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun18(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)',...    3
    stat_combined.dis_percent(13,:)', stat_combined.dis_percent(14,:)', stat_combined.dis_percent(15,:)',...    3
    stat_combined.dis_percent(16,:)', stat_combined.dis_percent(17,:)', stat_combined.dis_percent(18,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))],...
             ['um_',num2str(stat_combined.gz_classes(13,1))], ['um_',num2str(stat_combined.gz_classes(14,1))],...
             ['um_',num2str(stat_combined.gz_classes(15,1))], ['um_',num2str(stat_combined.gz_classes(16,1))],...
             ['um_',num2str(stat_combined.gz_classes(17,1))], ['um_',num2str(stat_combined.gz_classes(18,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun19(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)',...    3
    stat_combined.dis_percent(13,:)', stat_combined.dis_percent(14,:)', stat_combined.dis_percent(15,:)',...    3
    stat_combined.dis_percent(16,:)', stat_combined.dis_percent(17,:)', stat_combined.dis_percent(18,:)',...    3
    stat_combined.dis_percent(19,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))],...
             ['um_',num2str(stat_combined.gz_classes(13,1))], ['um_',num2str(stat_combined.gz_classes(14,1))],...
             ['um_',num2str(stat_combined.gz_classes(15,1))], ['um_',num2str(stat_combined.gz_classes(16,1))],...
             ['um_',num2str(stat_combined.gz_classes(17,1))], ['um_',num2str(stat_combined.gz_classes(18,1))],...
             ['um_',num2str(stat_combined.gz_classes(19,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun20(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)',...    3
    stat_combined.dis_percent(13,:)', stat_combined.dis_percent(14,:)', stat_combined.dis_percent(15,:)',...    3
    stat_combined.dis_percent(16,:)', stat_combined.dis_percent(17,:)', stat_combined.dis_percent(18,:)',...    3
    stat_combined.dis_percent(19,:)', stat_combined.dis_percent(20,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))],...
             ['um_',num2str(stat_combined.gz_classes(13,1))], ['um_',num2str(stat_combined.gz_classes(14,1))],...
             ['um_',num2str(stat_combined.gz_classes(15,1))], ['um_',num2str(stat_combined.gz_classes(16,1))],...
             ['um_',num2str(stat_combined.gz_classes(17,1))], ['um_',num2str(stat_combined.gz_classes(18,1))],...
             ['um_',num2str(stat_combined.gz_classes(19,1))], ['um_',num2str(stat_combined.gz_classes(20,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun21(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)',...    3
    stat_combined.dis_percent(13,:)', stat_combined.dis_percent(14,:)', stat_combined.dis_percent(15,:)',...    3
    stat_combined.dis_percent(16,:)', stat_combined.dis_percent(17,:)', stat_combined.dis_percent(18,:)',...    3
    stat_combined.dis_percent(19,:)', stat_combined.dis_percent(20,:)', stat_combined.dis_percent(21,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))],...
             ['um_',num2str(stat_combined.gz_classes(13,1))], ['um_',num2str(stat_combined.gz_classes(14,1))],...
             ['um_',num2str(stat_combined.gz_classes(15,1))], ['um_',num2str(stat_combined.gz_classes(16,1))],...
             ['um_',num2str(stat_combined.gz_classes(17,1))], ['um_',num2str(stat_combined.gz_classes(18,1))],...
             ['um_',num2str(stat_combined.gz_classes(19,1))], ['um_',num2str(stat_combined.gz_classes(20,1))],...
             ['um_',num2str(stat_combined.gz_classes(21,1))]    }; 


%%
function [ta_b, tab_names] = tablenofun22(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)',...    3
    stat_combined.dis_percent(13,:)', stat_combined.dis_percent(14,:)', stat_combined.dis_percent(15,:)',...    3
    stat_combined.dis_percent(16,:)', stat_combined.dis_percent(17,:)', stat_combined.dis_percent(18,:)',...    3
    stat_combined.dis_percent(19,:)', stat_combined.dis_percent(20,:)', stat_combined.dis_percent(21,:)',...    3
    stat_combined.dis_percent(22,:)' );                                 

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))],...
             ['um_',num2str(stat_combined.gz_classes(13,1))], ['um_',num2str(stat_combined.gz_classes(14,1))],...
             ['um_',num2str(stat_combined.gz_classes(15,1))], ['um_',num2str(stat_combined.gz_classes(16,1))],...
             ['um_',num2str(stat_combined.gz_classes(17,1))], ['um_',num2str(stat_combined.gz_classes(18,1))],...
             ['um_',num2str(stat_combined.gz_classes(19,1))], ['um_',num2str(stat_combined.gz_classes(20,1))],...
             ['um_',num2str(stat_combined.gz_classes(21,1))], ['um_',num2str(stat_combined.gz_classes(22,1))]    }; 


%%

function [ta_b, tab_names] = tablenofun40(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)',...    3
    stat_combined.dis_percent(13,:)', stat_combined.dis_percent(14,:)', stat_combined.dis_percent(15,:)',...    3
    stat_combined.dis_percent(16,:)', stat_combined.dis_percent(17,:)', stat_combined.dis_percent(18,:)',...    3
    stat_combined.dis_percent(19,:)', stat_combined.dis_percent(20,:)', stat_combined.dis_percent(21,:)',...    3
    stat_combined.dis_percent(22,:)', stat_combined.dis_percent(23,:)', stat_combined.dis_percent(24,:)',...    3
    stat_combined.dis_percent(25,:)', stat_combined.dis_percent(26,:)', stat_combined.dis_percent(27,:)',...    3
    stat_combined.dis_percent(28,:)', stat_combined.dis_percent(29,:)', stat_combined.dis_percent(30,:)',...    3
    stat_combined.dis_percent(31,:)', stat_combined.dis_percent(32,:)', stat_combined.dis_percent(33,:)',...    3
    stat_combined.dis_percent(34,:)', stat_combined.dis_percent(35,:)', stat_combined.dis_percent(36,:)',...    3
    stat_combined.dis_percent(37,:)', stat_combined.dis_percent(38,:)', stat_combined.dis_percent(39,:)',...    3
    stat_combined.dis_percent(40,:)');
    

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))],...
             ['um_',num2str(stat_combined.gz_classes(13,1))], ['um_',num2str(stat_combined.gz_classes(14,1))],...
             ['um_',num2str(stat_combined.gz_classes(15,1))], ['um_',num2str(stat_combined.gz_classes(16,1))],...
             ['um_',num2str(stat_combined.gz_classes(17,1))], ['um_',num2str(stat_combined.gz_classes(18,1))],...
             ['um_',num2str(stat_combined.gz_classes(19,1))], ['um_',num2str(stat_combined.gz_classes(20,1))],...
             ['um_',num2str(stat_combined.gz_classes(21,1))], ['um_',num2str(stat_combined.gz_classes(22,1))],...
             ['um_',num2str(stat_combined.gz_classes(23,1))], ['um_',num2str(stat_combined.gz_classes(24,1))],...
             ['um_',num2str(stat_combined.gz_classes(25,1))], ['um_',num2str(stat_combined.gz_classes(26,1))],...
             ['um_',num2str(stat_combined.gz_classes(27,1))], ['um_',num2str(stat_combined.gz_classes(28,1))],...
             ['um_',num2str(stat_combined.gz_classes(29,1))], ['um_',num2str(stat_combined.gz_classes(30,1))],...
             ['um_',num2str(stat_combined.gz_classes(31,1))], ['um_',num2str(stat_combined.gz_classes(32,1))],...
             ['um_',num2str(stat_combined.gz_classes(33,1))], ['um_',num2str(stat_combined.gz_classes(34,1))],...
             ['um_',num2str(stat_combined.gz_classes(35,1))], ['um_',num2str(stat_combined.gz_classes(36,1))],...
             ['um_',num2str(stat_combined.gz_classes(37,1))], ['um_',num2str(stat_combined.gz_classes(38,1))],...
             ['um_',num2str(stat_combined.gz_classes(39,1))], ['um_',num2str(stat_combined.gz_classes(40,1))]   }; 


%%

function [ta_b, tab_names] = tablenofun41(stat_combined)

time_vec = datevec(stat_combined.timenumber'); % timestring quick
timestring = num2str(time_vec); year_nb = time_vec(:,1);
ID(:,1) = 1: length(stat_combined.timenumber);

ta_b = table(ID, stat_combined.timenumber', timestring, year_nb, stat_combined.projects', ...                   5
    stat_combined.samplename', stat_combined.XY(1,:)', stat_combined.XY(2,:)', ...                              3
    stat_combined.latlon(2,:)', stat_combined.latlon(1,:)', ...                                                 2
    stat_combined.geo_mean', stat_combined.arit_mean', stat_combined.median', ...                               3
    stat_combined.modestatus', stat_combined.mode_1', stat_combined.mode_2', stat_combined.mode_3',...          4
    stat_combined.sorting_nb_FolkWard57', stat_combined.sorting_class_FolkWard57', ...                          2
    stat_combined.sorting_num_stdev', stat_combined.sorting_num_McLaren', stat_combined.skewness_McLaren', ...  3
    stat_combined.sortMC_pos', stat_combined.skewMC_pos',  ...                                                  2
    stat_combined.skewness_matlab', stat_combined.sort_um', ...                                                 2
    stat_combined.LevelA', stat_combined.LevelB', stat_combined.LevelC', stat_combined.sedmost',...             4
    stat_combined.finematerial', stat_combined.justsand', stat_combined.justgravel', ...                        3
    stat_combined.finesand', stat_combined.middlesand', stat_combined.coarsesand',     ...                      3
    stat_combined.dis_percent(1,:)',  stat_combined.dis_percent(2,:)',  stat_combined.dis_percent(3,:)',...     3
    stat_combined.dis_percent(4,:)',  stat_combined.dis_percent(5,:)',  stat_combined.dis_percent(6,:)',...     3
    stat_combined.dis_percent(7,:)',  stat_combined.dis_percent(8,:)',  stat_combined.dis_percent(9,:)',...     3
    stat_combined.dis_percent(10,:)', stat_combined.dis_percent(11,:)', stat_combined.dis_percent(12,:)',...    3
    stat_combined.dis_percent(13,:)', stat_combined.dis_percent(14,:)', stat_combined.dis_percent(15,:)',...    3
    stat_combined.dis_percent(16,:)', stat_combined.dis_percent(17,:)', stat_combined.dis_percent(18,:)',...    3
    stat_combined.dis_percent(19,:)', stat_combined.dis_percent(20,:)', stat_combined.dis_percent(21,:)',...    3
    stat_combined.dis_percent(22,:)', stat_combined.dis_percent(23,:)', stat_combined.dis_percent(24,:)',...    3
    stat_combined.dis_percent(25,:)', stat_combined.dis_percent(26,:)', stat_combined.dis_percent(27,:)',...    3
    stat_combined.dis_percent(28,:)', stat_combined.dis_percent(29,:)', stat_combined.dis_percent(30,:)',...    3
    stat_combined.dis_percent(31,:)', stat_combined.dis_percent(32,:)', stat_combined.dis_percent(33,:)',...    3
    stat_combined.dis_percent(34,:)', stat_combined.dis_percent(35,:)', stat_combined.dis_percent(36,:)',...    3
    stat_combined.dis_percent(37,:)', stat_combined.dis_percent(38,:)', stat_combined.dis_percent(39,:)',...    3
    stat_combined.dis_percent(40,:)', stat_combined.dis_percent(41,:)');
    

tab_names = {'ID', 'timenumber', 'timestring', 'year', 'project', ...                                           5
             'samplename', 'X', 'Y',...                                                                         3
             'lat', 'lon', ...                                                                                  2
             'geo_mean', 'arit_mean', 'median',...                                                              3
             'modestatus', 'mode_1', 'mode_2', 'mode_3',...                                                     4
             'sortnum_FolkWard57', 'sort_classFolkWard57', ...                                                  2
             'sort_stdev', 'sortnum_McLaren', 'skew_McLaren',...                                                3
             'sortMCpos', 'skewMCpos' ,'skew_matlab', 'sort_um',...                                             4
             'LevelA', 'LevelB', 'LevelC','Sedmost',...                                                         4
             'finematerial', 'justsand', 'justgravel', ...
             'finesand', 'middlesand', 'coarsesand', ...
             ['um_',num2str(stat_combined.gz_classes(1,1))],  ['um_',num2str(stat_combined.gz_classes(2,1))],...
             ['um_',num2str(stat_combined.gz_classes(3,1))],  ['um_',num2str(stat_combined.gz_classes(4,1))],...
             ['um_',num2str(stat_combined.gz_classes(5,1))],  ['um_',num2str(stat_combined.gz_classes(6,1))],...
             ['um_',num2str(stat_combined.gz_classes(7,1))],  ['um_',num2str(stat_combined.gz_classes(8,1))],...
             ['um_',num2str(stat_combined.gz_classes(9,1))],  ['um_',num2str(stat_combined.gz_classes(10,1))],...
             ['um_',num2str(stat_combined.gz_classes(11,1))], ['um_',num2str(stat_combined.gz_classes(12,1))],...
             ['um_',num2str(stat_combined.gz_classes(13,1))], ['um_',num2str(stat_combined.gz_classes(14,1))],...
             ['um_',num2str(stat_combined.gz_classes(15,1))], ['um_',num2str(stat_combined.gz_classes(16,1))],...
             ['um_',num2str(stat_combined.gz_classes(17,1))], ['um_',num2str(stat_combined.gz_classes(18,1))],...
             ['um_',num2str(stat_combined.gz_classes(19,1))], ['um_',num2str(stat_combined.gz_classes(20,1))],...
             ['um_',num2str(stat_combined.gz_classes(21,1))], ['um_',num2str(stat_combined.gz_classes(22,1))],...
             ['um_',num2str(stat_combined.gz_classes(23,1))], ['um_',num2str(stat_combined.gz_classes(24,1))],...
             ['um_',num2str(stat_combined.gz_classes(25,1))], ['um_',num2str(stat_combined.gz_classes(26,1))],...
             ['um_',num2str(stat_combined.gz_classes(27,1))], ['um_',num2str(stat_combined.gz_classes(28,1))],...
             ['um_',num2str(stat_combined.gz_classes(29,1))], ['um_',num2str(stat_combined.gz_classes(30,1))],...
             ['um_',num2str(stat_combined.gz_classes(31,1))], ['um_',num2str(stat_combined.gz_classes(32,1))],...
             ['um_',num2str(stat_combined.gz_classes(33,1))], ['um_',num2str(stat_combined.gz_classes(34,1))],...
             ['um_',num2str(stat_combined.gz_classes(35,1))], ['um_',num2str(stat_combined.gz_classes(36,1))],...
             ['um_',num2str(stat_combined.gz_classes(37,1))], ['um_',num2str(stat_combined.gz_classes(38,1))],...
             ['um_',num2str(stat_combined.gz_classes(39,1))], ['um_',num2str(stat_combined.gz_classes(40,1))],...
             ['um_',num2str(stat_combined.gz_classes(41,1))]   }; 


%%



