% combining data sets and calculate gaps if possible
function [filename_out,gsc] = step0_combine_grabs_open(t_n,folder_out)

functionpath = pwd;

%% set desired grainsize classes  %  'nfsued_intervals'  %  'manually'  %  'modelclayton'
[gz_classes,gz_classes_model] = make_gsc_interval('modelclayton'); % manipulate gsc in make_gsc_interval.m


%% set info
sedatapath = [pwd, '\sedata\'];
options.calcmodenew=1; % calculate mode again
setGlobalx(options)


%% load stuff 1 % StatFigge; % figge
fname='figge_stat_h.mat';
load([sedatapath, fname])
stat_out1 = unify_sedata(StatFigge_h,gz_classes); % sedata process 1


%% combine with more data and fill gaps
stat_combined = sumup_sedata_open(stat_out1); % Figge, Sedino, FTZ, STopP, NFS


%% make Sediment type levels (BSH level A, level B, level C and sedmost)
[stat_combined] = make_sedtype_level(stat_combined);


%% data output name
stat_combined.gz_classes_model=gz_classes_model;
gsc = [num2str(gz_classes(1)),'to',num2str(gz_classes(end)),'um'];
filename_out = ['grabs_', gsc, '_', t_n];


%% safe combined data as structure
cd(folder_out); save(filename_out,'stat_combined','-v7.3');
cd(functionpath)


%% make gis table
make_gis_table_distribution(stat_combined,filename_out,folder_out);
cd(functionpath)



%% RGB data info plot
%{
idx_info=find(stat_combined.modestatus~=0&~isnan(stat_combined.modestatus));

rcol(:,1)=log(stat_combined.mode_1(1,idx_info))./log(nanmax(stat_combined.mode_1(1,idx_info)));
gcol(:,1)=log(stat_combined.median(1,idx_info))./log(nanmax(stat_combined.median(1,idx_info)));
bcol(:,1)=log(stat_combined.arit_mean(1,idx_info))./log(nanmax(stat_combined.arit_mean(1,idx_info)));
col=[rcol,gcol,bcol];
figure; scatter( stat_combined.latlon(2,idx_info), stat_combined.latlon(1,idx_info), 10, col, 'filled')
title('RGB value = mean, median, mode1')

%}






function stat_out = sumup_sedata_open(stat_in1)

stat_out.projects = repelem([{'Figge'}], ...
    [length(stat_in1.samplename) ]);

stat_out.samplename = [stat_in1.samplename];
stat_out.latlon = [stat_in1.latlon];
stat_out.XY = [stat_in1.XY];
stat_out.timenumber = [stat_in1.sampletimedate];
stat_out.timenumber(stat_out.timenumber==0)=NaN;

stat_out.sieving = [stat_in1.sieving];

stat_out.finer63perc = [stat_in1.finer63perc];

stat_out.gz_classes = [stat_in1.gz_classes];
stat_out.dis_percent = [stat_in1.dis_percent];
stat_out.geo_mean = [stat_in1.geo_mean];
stat_out.arit_mean = [stat_in1.arit_mean];

stat_out.median = [stat_in1.median];
stat_out.D10 = [stat_in1.D10];
stat_out.D90 = [stat_in1.D90];

stat_out.mode_1 = [stat_in1.mode_1];
stat_out.mode_2 = [stat_in1.mode_2];
stat_out.mode_3 = [stat_in1.mode_3];

stat_out.modestatus = [stat_in1.modestatus];
stat_out.sorting_nb_FolkWard57 = [stat_in1.sorting_num_FolkWard];
stat_out.sorting_class_FolkWard57 = [stat_in1.sorting_class_FolkWard];
stat_out.sorting_num_stdev = [stat_in1.sorting_num_stdev];
stat_out.sorting_num_McLaren=[stat_in1.sorting_num_McLaren];
stat_out.sort_um = [stat_in1.sort_um];
stat_out.sortMC_pos = [stat_in1.sortMC_pos];

stat_out.skewness_McLaren=[stat_in1.skewness_McLaren];
stat_out.skewMC_pos = [stat_in1.skewMC_pos];
stat_out.skewness_matlab = [stat_in1.skewness_matlab];


%% over 63 um
if isfield(stat_in1,{'mode_1_over63'})==1
    
    stat_out.median_over63 = [stat_in1.median_over63];
    stat_out.D10_over63 = [stat_in1.D10];
    stat_out.D90_over63 = [stat_in1.D90];

    
    stat_out.mode_1_over63 = [stat_in1.mode_1_over63];
    stat_out.mode_2_over63 = [stat_in1.mode_2_over63];
    stat_out.mode_3_over63 = [stat_in1.mode_3_over63];
    stat_out.modestatus_over63 = [stat_in1.modestatus_over63];
    stat_out.median_over63 = [stat_in1.median_over63];
    stat_out.sieving_over63 = [stat_in1.sieving_over63];
    stat_out.arit_mean_over63 = [stat_in1.arit_mean_over63];
    stat_out.geo_mean_over63 = [stat_in1.geo_mean_over63];
    stat_out.dis_percent_over63 = [stat_in1.dis_percent_over63];
    stat_out.gz_classes_over63 = [stat_in1.gz_classes_over63];
    stat_out.sorting_num_McLaren_over63 = [stat_in1.sorting_num_McLaren_over63];
    stat_out.sortMC_pos_over63 =  [stat_in1.sortMC_pos_over63];
    stat_out.skewness_McLaren_over63= [stat_in1.skewness_McLaren_over63];
    stat_out.sort_um_over63 = [stat_in1.sort_um_over63];
    stat_out.skewMC_pos_over63= [stat_in1.skewMC_pos_over63];
    stat_out.skewness_matlab_over63 = [stat_in1.skewness_matlab_over63];
    stat_out.sorting_nb_FolkWard57_over63 = [stat_in1.sorting_num_FolkWard_over63];
    stat_out.sorting_class_FolkWard57_over63 = [stat_in1.sorting_class_FolkWard_over63];
    stat_out.sorting_num_stdev_over63 = [stat_in1.sorting_num_stdev_over63];
    
end


%%
idx_out = sort(unique([find(isnan(stat_out.median)),find(stat_out.modestatus==0),find(isnan(stat_out.modestatus))]));
stat_out.projects(idx_out)=[];

stat_out.samplename(idx_out)=[];
stat_out.latlon(:,idx_out)=[];
stat_out.XY(:,idx_out)=[];
stat_out.timenumber(idx_out)=[];

stat_out.sieving(:,idx_out)=[];

stat_out.dis_percent(:,idx_out)=[];
stat_out.geo_mean(idx_out)=[];
stat_out.arit_mean(idx_out)=[];

stat_out.finer63perc(idx_out)=[];

stat_out.median(idx_out)=[];
stat_out.D10(idx_out)=[];
stat_out.D90(idx_out)=[];

stat_out.mode_1(:,idx_out)=[];
stat_out.mode_2(:,idx_out)=[];
stat_out.mode_3(:,idx_out)=[];

stat_out.modestatus(idx_out)=[];
stat_out.sorting_nb_FolkWard57(idx_out)=[];
stat_out.sorting_class_FolkWard57(idx_out)=[];
stat_out.sorting_num_stdev(idx_out)=[];
stat_out.sorting_num_McLaren(idx_out)=[];
stat_out.sort_um(idx_out)=[];
stat_out.sortMC_pos(idx_out)=[];

stat_out.skewness_McLaren(idx_out)=[];
stat_out.skewMC_pos(idx_out)=[];
stat_out.skewness_matlab(idx_out)=[];


%% over 63 um
if isfield(stat_in1,{'mode_1_over63'})==1
    
    stat_out.median_over63(idx_out)=[];
    stat_out.mode_1_over63(:,idx_out)=[];
    stat_out.mode_2_over63(:,idx_out)=[];
    stat_out.mode_3_over63(:,idx_out)=[];
    stat_out.modestatus_over63(idx_out)=[];
    stat_out.D10_over63(idx_out)=[];
    stat_out.D90_over63(idx_out)=[];
    stat_out.sieving_over63(:,idx_out)=[];
    stat_out.arit_mean_over63(idx_out)=[];
    stat_out.geo_mean_over63(idx_out)=[];
    stat_out.dis_percent_over63(:,idx_out)=[];
    stat_out.sorting_num_McLaren_over63(idx_out)=[];
    stat_out.sortMC_pos_over63(idx_out)=[];
    stat_out.skewness_McLaren_over63(idx_out)=[];
    stat_out.skewMC_pos_over63(idx_out)=[];
    stat_out.skewness_matlab_over63(idx_out)=[];
    stat_out.sorting_nb_FolkWard57_over63(idx_out)=[];
    stat_out.sorting_class_FolkWard57_over63(idx_out)=[];
    stat_out.sorting_num_stdev_over63(idx_out)=[];
    stat_out.sort_um_over63(idx_out)=[];

end

%% remove dublicates (same Sample Identification Name) | duplicate samples
[uniqueA i j] = unique(stat_out.samplename,'first');
idx_out = find(not(ismember(1:numel(stat_out.samplename),i)));

stat_out.projects(idx_out)=[];

stat_out.samplename(idx_out)=[];
stat_out.latlon(:,idx_out)=[];
stat_out.XY(:,idx_out)=[];
stat_out.timenumber(idx_out)=[];

stat_out.sieving(:,idx_out)=[];

stat_out.dis_percent(:,idx_out)=[];
stat_out.geo_mean(idx_out)=[];
stat_out.arit_mean(idx_out)=[];

stat_out.finer63perc(idx_out)=[];

stat_out.median(idx_out)=[];
stat_out.D10(idx_out)=[];
stat_out.D90(idx_out)=[];
stat_out.mode_1(:,idx_out)=[];
stat_out.mode_2(:,idx_out)=[];
stat_out.mode_3(:,idx_out)=[];

stat_out.modestatus(idx_out)=[];
stat_out.sorting_nb_FolkWard57(idx_out)=[];
stat_out.sorting_class_FolkWard57(idx_out)=[];
stat_out.sorting_num_stdev(idx_out)=[];
stat_out.sorting_num_McLaren(idx_out)=[];
stat_out.sortMC_pos(idx_out)=[];
stat_out.sort_um(idx_out)=[];

stat_out.skewness_McLaren(idx_out)=[];
stat_out.skewMC_pos(idx_out)=[];
stat_out.skewness_matlab(idx_out)=[];


%% over 63 um
if isfield(stat_in1,{'mode_1_over63'})==1
    
    stat_out.median_over63(idx_out)=[];
    stat_out.mode_1_over63(:,idx_out)=[];
    stat_out.mode_2_over63(:,idx_out)=[];
    stat_out.mode_3_over63(:,idx_out)=[];
    stat_out.modestatus_over63(idx_out)=[];
    stat_out.D10_over63(idx_out)=[];
    stat_out.D90_over63(idx_out)=[];
    stat_out.sieving_over63(:,idx_out)=[];
    stat_out.arit_mean_over63(idx_out)=[];
    stat_out.geo_mean_over63(idx_out)=[];
    stat_out.dis_percent_over63(:,idx_out)=[];
    stat_out.sorting_num_McLaren_over63(idx_out)=[];
    stat_out.sortMC_pos_over63(idx_out)=[];
    stat_out.skewness_McLaren_over63(idx_out)=[];
    stat_out.skewMC_pos_over63(idx_out)=[];
    stat_out.skewness_matlab_over63(idx_out)=[];
    stat_out.sort_um_over63(idx_out)=[];
    stat_out.sorting_nb_FolkWard57_over63(idx_out)=[];
    stat_out.sorting_class_FolkWard57_over63(idx_out)=[];
    stat_out.sorting_num_stdev_over63(idx_out)=[];
end






