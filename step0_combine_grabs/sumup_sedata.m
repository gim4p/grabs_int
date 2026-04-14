

function stat_out = sumup_sedata(stat_in1,stat_in2,stat_in3,stat_in4,stat_in5,stat_in6,stat_in7)

stat_out.projects = repelem([{'Figge'}, {'Sedino'}, {'NFSued'}, {'FTZ'}, {'STopP'}, {'Sedimentinventar und Hydromorphologie der Schlei'}, {'AL552_8samples'}], ...
    [length(stat_in1.samplename) length(stat_in2.samplename) length(stat_in3.samplename) length(stat_in4.samplename) length(stat_in5.samplename) length(stat_in6.samplename) length(stat_in7.samplename)]);

stat_out.samplename = [stat_in1.samplename,stat_in2.samplename,stat_in3.samplename,stat_in4.samplename,stat_in5.samplename,stat_in6.samplename,stat_in7.samplename];
stat_out.latlon = [stat_in1.latlon,stat_in2.latlon,stat_in3.latlon,stat_in4.latlon,stat_in5.latlon,stat_in6.latlon,stat_in7.latlon];
stat_out.XY = [stat_in1.XY,stat_in2.XY,stat_in3.XY,stat_in4.XY,stat_in5.XY,stat_in6.XY,stat_in7.XY];
stat_out.timenumber = [stat_in1.sampletimedate,stat_in2.sampletimedate,stat_in3.sampletimedate,stat_in4.sampletimedate,stat_in5.sampletimedate,stat_in6.sampletimedate,stat_in7.sampletimedate];
stat_out.timenumber(stat_out.timenumber==0)=NaN;

stat_out.sieving = [stat_in1.sieving,stat_in2.sieving,stat_in3.sieving,stat_in4.sieving,stat_in5.sieving,stat_in6.sieving,stat_in7.sieving];

stat_out.finer63perc = [stat_in1.finer63perc,stat_in2.finer63perc,stat_in3.finer63perc,stat_in4.finer63perc,stat_in5.finer63perc,stat_in6.finer63perc,stat_in7.finer63perc];

stat_out.gz_classes = [stat_in1.gz_classes,stat_in2.gz_classes,stat_in3.gz_classes,stat_in4.gz_classes,stat_in5.gz_classes,stat_in6.gz_classes,stat_in7.gz_classes];
stat_out.dis_percent = [stat_in1.dis_percent,stat_in2.dis_percent,stat_in3.dis_percent,stat_in4.dis_percent,stat_in5.dis_percent,stat_in6.dis_percent,stat_in7.dis_percent];
stat_out.geo_mean = [stat_in1.geo_mean,stat_in2.geo_mean,stat_in3.geo_mean,stat_in4.geo_mean,stat_in5.geo_mean,stat_in6.geo_mean,stat_in7.geo_mean];
stat_out.arit_mean = [stat_in1.arit_mean,stat_in2.arit_mean,stat_in3.arit_mean,stat_in4.arit_mean,stat_in5.arit_mean,stat_in6.arit_mean,stat_in7.arit_mean];

stat_out.median = [stat_in1.median,stat_in2.median,stat_in3.median,stat_in4.median,stat_in5.median,stat_in6.median,stat_in7.median];
stat_out.D10 = [stat_in1.D10,stat_in2.D10,stat_in3.D10,stat_in4.D10,stat_in5.D10,stat_in6.D10,stat_in7.D10];
stat_out.D90 = [stat_in1.D90,stat_in2.D90,stat_in3.D90,stat_in4.D90,stat_in5.D90,stat_in6.D90,stat_in7.D90];

stat_out.mode_1 = [stat_in1.mode_1,stat_in2.mode_1,stat_in3.mode_1,stat_in4.mode_1,stat_in5.mode_1,stat_in6.mode_1,stat_in7.mode_1];
stat_out.mode_2 = [stat_in1.mode_2,stat_in2.mode_2,stat_in3.mode_2,stat_in4.mode_2,stat_in5.mode_2,stat_in6.mode_2,stat_in7.mode_2];
stat_out.mode_3 = [stat_in1.mode_3,stat_in2.mode_3,stat_in3.mode_3,stat_in4.mode_3,stat_in5.mode_3,stat_in6.mode_3,stat_in7.mode_3];

stat_out.modestatus = [stat_in1.modestatus,stat_in2.modestatus,stat_in3.modestatus,stat_in4.modestatus,stat_in5.modestatus,stat_in6.modestatus,stat_in7.modestatus];
stat_out.sorting_nb_FolkWard57 = [stat_in1.sorting_num_FolkWard,stat_in2.sorting_num_FolkWard,stat_in3.sorting_num_FolkWard,stat_in4.sorting_num_FolkWard,stat_in5.sorting_num_FolkWard,stat_in6.sorting_num_FolkWard,stat_in7.sorting_num_FolkWard];
stat_out.sorting_class_FolkWard57 = [stat_in1.sorting_class_FolkWard,stat_in2.sorting_class_FolkWard,stat_in3.sorting_class_FolkWard,stat_in4.sorting_class_FolkWard,stat_in5.sorting_class_FolkWard,stat_in6.sorting_class_FolkWard,stat_in7.sorting_class_FolkWard];
stat_out.sorting_num_stdev = [stat_in1.sorting_num_stdev,stat_in2.sorting_num_stdev,stat_in3.sorting_num_stdev,stat_in4.sorting_num_stdev,stat_in5.sorting_num_stdev,stat_in6.sorting_num_stdev,stat_in7.sorting_num_stdev];
stat_out.sorting_num_McLaren=[stat_in1.sorting_num_McLaren,stat_in2.sorting_num_McLaren,stat_in3.sorting_num_McLaren,stat_in4.sorting_num_McLaren,stat_in5.sorting_num_McLaren,stat_in6.sorting_num_McLaren,stat_in7.sorting_num_McLaren];
stat_out.sort_um = [stat_in1.sort_um,stat_in2.sort_um,stat_in3.sort_um,stat_in4.sort_um,stat_in5.sort_um,stat_in6.sort_um,stat_in7.sort_um];
stat_out.sortMC_pos = [stat_in1.sortMC_pos,stat_in2.sortMC_pos,stat_in3.sortMC_pos,stat_in4.sortMC_pos,stat_in5.sortMC_pos,stat_in6.sortMC_pos,stat_in7.sortMC_pos];

stat_out.skewness_McLaren=[stat_in1.skewness_McLaren,stat_in2.skewness_McLaren,stat_in3.skewness_McLaren,stat_in4.skewness_McLaren,stat_in5.skewness_McLaren,stat_in6.skewness_McLaren,stat_in7.skewness_McLaren];
stat_out.skewMC_pos = [stat_in1.skewMC_pos,stat_in2.skewMC_pos,stat_in3.skewMC_pos,stat_in4.skewMC_pos,stat_in5.skewMC_pos,stat_in6.skewMC_pos,stat_in7.skewMC_pos];
stat_out.skewness_matlab = [stat_in1.skewness_matlab,stat_in2.skewness_matlab,stat_in3.skewness_matlab,stat_in4.skewness_matlab,stat_in5.skewness_matlab,stat_in6.skewness_matlab,stat_in7.skewness_matlab];


%% over 63 um
if isfield(stat_in1,{'mode_1_over63'})==1
    
    stat_out.median_over63 = [stat_in1.median_over63,stat_in2.median_over63,stat_in3.median_over63,stat_in4.median_over63,stat_in5.median_over63,stat_in6.median_over63,stat_in7.median_over63];
    stat_out.D10_over63 = [stat_in1.D10,stat_in2.D10,stat_in3.D10,stat_in4.D10,stat_in5.D10,stat_in6.D10,stat_in7.D10];
    stat_out.D90_over63 = [stat_in1.D90,stat_in2.D90,stat_in3.D90,stat_in4.D90,stat_in5.D90,stat_in6.D90,stat_in7.D90];

    
    stat_out.mode_1_over63 = [stat_in1.mode_1_over63,stat_in2.mode_1_over63,stat_in3.mode_1_over63,stat_in4.mode_1_over63,stat_in5.mode_1_over63,stat_in6.mode_1_over63,stat_in7.mode_1_over63];
    stat_out.mode_2_over63 = [stat_in1.mode_2_over63,stat_in2.mode_2_over63,stat_in3.mode_2_over63,stat_in4.mode_2_over63,stat_in5.mode_2_over63,stat_in6.mode_2_over63,stat_in7.mode_2_over63];
    stat_out.mode_3_over63 = [stat_in1.mode_3_over63,stat_in2.mode_3_over63,stat_in3.mode_3_over63,stat_in4.mode_3_over63,stat_in5.mode_3_over63,stat_in6.mode_3_over63,stat_in7.mode_3_over63];
    stat_out.modestatus_over63 = [stat_in1.modestatus_over63,stat_in2.modestatus_over63,stat_in3.modestatus_over63,stat_in4.modestatus_over63,stat_in5.modestatus_over63,stat_in6.modestatus_over63,stat_in7.modestatus_over63];
    stat_out.median_over63 = [stat_in1.median_over63,stat_in2.median_over63,stat_in3.median_over63,stat_in4.median_over63,stat_in5.median_over63,stat_in6.median_over63,stat_in7.median_over63];
    stat_out.sieving_over63 = [stat_in1.sieving_over63,stat_in2.sieving_over63,stat_in3.sieving_over63,stat_in4.sieving_over63,stat_in5.sieving_over63,stat_in6.sieving_over63,stat_in7.sieving_over63];
    stat_out.arit_mean_over63 = [stat_in1.arit_mean_over63,stat_in2.arit_mean_over63,stat_in3.arit_mean_over63,stat_in4.arit_mean_over63,stat_in5.arit_mean_over63,stat_in6.arit_mean_over63,stat_in7.arit_mean_over63];
    stat_out.geo_mean_over63 = [stat_in1.geo_mean_over63,stat_in2.geo_mean_over63,stat_in3.geo_mean_over63,stat_in4.geo_mean_over63,stat_in5.geo_mean_over63,stat_in6.geo_mean_over63,stat_in7.geo_mean_over63];
    stat_out.dis_percent_over63 = [stat_in1.dis_percent_over63,stat_in2.dis_percent_over63,stat_in3.dis_percent_over63,stat_in4.dis_percent_over63,stat_in5.dis_percent_over63,stat_in6.dis_percent_over63,stat_in7.dis_percent_over63];
    stat_out.gz_classes_over63 = [stat_in1.gz_classes_over63,stat_in2.gz_classes_over63,stat_in3.gz_classes_over63,stat_in4.gz_classes_over63,stat_in5.gz_classes_over63,stat_in6.gz_classes_over63,stat_in7.gz_classes_over63];
    stat_out.sorting_num_McLaren_over63 = [stat_in1.sorting_num_McLaren_over63,stat_in2.sorting_num_McLaren_over63,stat_in3.sorting_num_McLaren_over63,stat_in4.sorting_num_McLaren_over63,stat_in5.sorting_num_McLaren_over63,stat_in6.sorting_num_McLaren_over63,stat_in7.sorting_num_McLaren_over63];
    stat_out.sortMC_pos_over63 =  [stat_in1.sortMC_pos_over63,stat_in2.sortMC_pos_over63,stat_in3.sortMC_pos_over63,stat_in4.sortMC_pos_over63,stat_in5.sortMC_pos_over63,stat_in6.sortMC_pos_over63,stat_in7.sortMC_pos_over63];
    stat_out.skewness_McLaren_over63= [stat_in1.skewness_McLaren_over63,stat_in2.skewness_McLaren_over63,stat_in3.skewness_McLaren_over63,stat_in4.skewness_McLaren_over63,stat_in5.skewness_McLaren_over63,stat_in6.skewness_McLaren_over63,stat_in7.skewness_McLaren_over63];
    stat_out.sort_um_over63 = [stat_in1.sort_um_over63,stat_in2.sort_um_over63,stat_in3.sort_um_over63,stat_in4.sort_um_over63,stat_in5.sort_um_over63,stat_in6.sort_um_over63,stat_in7.sort_um_over63];
    stat_out.skewMC_pos_over63= [stat_in1.skewMC_pos_over63,stat_in2.skewMC_pos_over63,stat_in3.skewMC_pos_over63,stat_in4.skewMC_pos_over63,stat_in5.skewMC_pos_over63,stat_in6.skewMC_pos_over63,stat_in7.skewMC_pos_over63];
    stat_out.skewness_matlab_over63 = [stat_in1.skewness_matlab_over63,stat_in2.skewness_matlab_over63,stat_in3.skewness_matlab_over63,stat_in4.skewness_matlab_over63,stat_in5.skewness_matlab_over63,stat_in6.skewness_matlab_over63,stat_in7.skewness_matlab_over63];
    stat_out.sorting_nb_FolkWard57_over63 = [stat_in1.sorting_num_FolkWard_over63,stat_in2.sorting_num_FolkWard_over63,stat_in3.sorting_num_FolkWard_over63,stat_in4.sorting_num_FolkWard_over63,stat_in5.sorting_num_FolkWard_over63,stat_in6.sorting_num_FolkWard_over63,stat_in7.sorting_num_FolkWard_over63];
    stat_out.sorting_class_FolkWard57_over63 = [stat_in1.sorting_class_FolkWard_over63,stat_in2.sorting_class_FolkWard_over63,stat_in3.sorting_class_FolkWard_over63,stat_in4.sorting_class_FolkWard_over63,stat_in5.sorting_class_FolkWard_over63,stat_in6.sorting_class_FolkWard_over63,stat_in7.sorting_class_FolkWard_over63];
    stat_out.sorting_num_stdev_over63 = [stat_in1.sorting_num_stdev_over63,stat_in2.sorting_num_stdev_over63,stat_in3.sorting_num_stdev_over63,stat_in4.sorting_num_stdev_over63,stat_in5.sorting_num_stdev_over63,stat_in6.sorting_num_stdev_over63,stat_in7.sorting_num_stdev_over63];
    
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



