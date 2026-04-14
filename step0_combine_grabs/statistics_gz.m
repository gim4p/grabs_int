function stat_out=statistics_gz(dis_percent,gz_classes,stat_in,options)

%% statistics if not already there calculate again/ new

%% statistics for part bigger 63 µm 
if min(gz_classes)<63
    
    gz_classes_over63 = gz_classes(find(gz_classes>=63, 1):end);
    dis_percent_over63 = dis_percent(find(gz_classes>=63, 1):end,:);
    gz_classes_over63_mode =[0;gz_classes_over63]; % für mode dennoch wieder Null am Anfang ohne Wert einfügen! 
    dis_percent_over63_mode=[zeros(1,size(dis_percent_over63,2));dis_percent_over63];
    [mode_size_1_over63,mode_size_2_over63,mode_size_3_over63,modestatus_over63]=modestat(dis_percent_over63_mode,gz_classes_over63_mode);
    
    [artificial_median_over63, artificial_D10_over63, artificial_D90_over63, sieving_over63]=medianstat(dis_percent_over63,gz_classes_over63,stat_in);
    [arit_mean_over63,geo_mean_over63]=meanstat(dis_percent_over63, gz_classes_over63);
    
    %% sorting
    [sorting_num_FolkWard_over63,sorting_class_FolkWard_over63,sorting_num_stdev_over63]=sortingstat_FolkWart1957(sieving_over63);
    [sorting_num_McLaren_over63, sort_um_over63] = sorting_McLaren(dis_percent,gz_classes,geo_mean_over63); % phi
    sortMC_pos_over63 = sorting_num_McLaren_over63 + abs(min(sorting_num_McLaren_over63));

    %% skewness
    [skewness_McLaren_over63, skewness_matlab_over63] = skewness_McLaren_calc(dis_percent_over63,gz_classes_over63,geo_mean_over63,sorting_num_McLaren_over63);
    skewMC_pos_over63 = skewness_McLaren_over63 + abs(min(skewness_McLaren_over63));
    skewMC_pos_over63(isinf(skewMC_pos_over63))=NaN;
    
end


%% statistics for set gsc intervals
%% mode
if isfield(stat_in,{'mode_1'})==1 && options.calcmodenew~=1
    
    mode_size_1=stat_in.mode_1;
    mode_size_2=stat_in.mode_2;
    mode_size_3=stat_in.mode_3;
    
    if isfield(stat_in,{'modestatus'})~=1  % noch n Fehler check!
        modestatus=NaN(size(mode_size_1));
        modestatus((~isnan(mode_size_1)))=1;
        modestatus((~isnan(mode_size_1.*mode_size_2)))=2;
        modestatus((~isnan(mode_size_1.*mode_size_2.*mode_size_3)))=3;
    else
        modestatus=stat_in.modestatus;
    end
    
else
    
    [mode_size_1,mode_size_2,mode_size_3,modestatus]=modestat(dis_percent,gz_classes);
    
end


%% median
if isfield(stat_in,{'sieving'})==1;
    
    sieving=stat_in.sieving;
    
end

[artificial_median, artificial_D10, artificial_D90, sieving]=medianstat(dis_percent,gz_classes,stat_in);


%% mean
names=fieldnames(stat_in);

for i=1:length(names) % check if mean is not already there
    teststr=names{i}; 
    if strfind(teststr,'mean') > 0
        testval(i)={teststr};
    end
end

if exist('testval')~=1;

    [arit_mean,geo_mean]=meanstat(dis_percent, gz_classes);
    
else
    arit_mean = stat_in.arit_mean; % stat_in.testval % muss ich noch machen
    geo_mean = stat_in.geo_mean;
end


%% sorting
[sorting_num_FolkWard,sorting_class_FolkWard,sorting_num_stdev]=sortingstat_FolkWart1957(sieving);
[sorting_num_McLaren, sort_um] = sorting_McLaren(dis_percent,gz_classes,geo_mean); % phi
sortMC_pos = sorting_num_McLaren + abs(min(sorting_num_McLaren));


%% skewness
[skewness_McLaren, skewness_matlab] = skewness_McLaren_calc(dis_percent,gz_classes,geo_mean,sorting_num_McLaren);
skewMC_pos = skewness_McLaren + abs(min(skewness_McLaren));
skewMC_pos(isinf(skewMC_pos))=NaN;


%% output etwas geordnet
stat_out.samplename = stat_in.samplename;
stat_out.latlon = stat_in.latlon;
stat_out.XY = stat_in.XY;
stat_out.sampletimedate = stat_in.sampletimedate;

stat_out.sieving = sieving;
stat_out.gz_classes = gz_classes;
stat_out.dis_percent = dis_percent;

stat_out.finer63perc = stat_in.mudpart_from_acculumated_sieving;

stat_out.geo_mean = geo_mean;
stat_out.arit_mean = arit_mean;
stat_out.median = artificial_median;
stat_out.D10 = artificial_D10;
stat_out.D90 = artificial_D90;
stat_out.mode_1 = mode_size_1;
stat_out.mode_2 = mode_size_2;
stat_out.mode_3 = mode_size_3;
stat_out.modestatus = modestatus;

stat_out.sorting_num_FolkWard = sorting_num_FolkWard;
stat_out.sorting_class_FolkWard = sorting_class_FolkWard;
stat_out.sorting_num_McLaren = sorting_num_McLaren;
stat_out.sort_um = sort_um;
stat_out.sortMC_pos = sortMC_pos;
stat_out.sorting_num_stdev = sorting_num_stdev;

stat_out.skewness_McLaren = skewness_McLaren;
stat_out.skewMC_pos = skewMC_pos;
stat_out.skewness_matlab = skewness_matlab;


%% over63um (exclude all finer material, if it is initially included by the grain size classes given in the beginning)
if min(gz_classes)<63
    
    stat_out.mode_1_over63=mode_size_1_over63;
    stat_out.mode_2_over63=mode_size_2_over63;
    stat_out.mode_3_over63=mode_size_3_over63;
    stat_out.modestatus_over63=modestatus_over63;
    stat_out.median_over63=artificial_median_over63;
    stat_out.D10_over63 = artificial_D10_over63;
    stat_out.D90_over63 = artificial_D90_over63;
    stat_out.sieving_over63=sieving_over63;
    stat_out.arit_mean_over63=arit_mean_over63;
    stat_out.geo_mean_over63=geo_mean_over63;
    stat_out.dis_percent_over63=dis_percent_over63;
    stat_out.gz_classes_over63=gz_classes_over63;
    stat_out.sorting_num_McLaren_over63=sorting_num_McLaren_over63;
    stat_out.sort_um_over63 = sort_um_over63;
    stat_out.sortMC_pos_over63=sortMC_pos_over63;
    stat_out.sorting_num_FolkWard_over63=sorting_num_FolkWard_over63; % sorting
    stat_out.sorting_class_FolkWard_over63=sorting_class_FolkWard_over63;
    stat_out.sorting_num_stdev_over63=sorting_num_stdev_over63;
    stat_out.skewness_McLaren_over63=skewness_McLaren_over63; % skewness
    stat_out.skewMC_pos_over63=skewMC_pos_over63;
    stat_out.skewness_matlab_over63 = skewness_matlab_over63;
    
end

