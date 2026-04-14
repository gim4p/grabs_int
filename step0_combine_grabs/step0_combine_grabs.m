% combining data sets and calculate gaps if possible
function [filename_out,gsc] = step0_combine_grabs(t_n,folder_out)

functionpath = pwd;

%% set desired grainsize classes  %  'nfsued_intervals'  %  'manually'  %  'modelclayton'
[gz_classes,gz_classes_model] = make_gsc_interval('modelclayton'); % manipulate gsc in make_gsc_interval.m


%% set info
sedatapath = [pwd, '\sedata\'];
options.calcmodenew=1; % calculate mode again
setGlobalx(options)


%% load stuff 1 % StatFigge; % figge
fname='figge_stat.mat';
load([sedatapath, fname])
stat_out1 = unify_sedata(StatFigge,gz_classes); % sedata process 1


%% load stuff 2 % StatPeter; % peter
fname='peter_stat.mat';
load([sedatapath, fname])
stat_out2 = unify_sedata(StatPeter,gz_classes); % sedata process 2


%% load stuff 3 % StatNFS; % nfs
fname='nfsued_stat20220116_31micronsclass.mat';
load([sedatapath, fname])
stat_out3 = unify_sedata(StatNFS,gz_classes); % sedata process 3


%% load stuff 4 % StatNFS; % ftz
fname='ftz_stat.mat';
load([sedatapath, fname])
stat_out4 = unify_sedata(StatFTZ,gz_classes); % sedata process 4


%% load stuff 5 % STopP
fname='stopp_stat.mat';
load([sedatapath, fname])
stat_out5 = unify_sedata(StatSTopP,gz_classes); % sedata process 5


%% load stuff 6 % Schlei by David
fname='schlei.mat';
load([sedatapath, fname])
stat_out6 = unify_sedata(schlei,gz_classes); % sedata process 6


%% load stuff 7 % AL552 Giuli
fname='AL552_8samples.mat';
load([sedatapath, fname])
stat_out7 = unify_sedata(StatAL552,gz_classes); % sedata process 7


%% combine with more data and fill gaps
stat_combined = sumup_sedata(stat_out1,stat_out2,stat_out3,stat_out4,stat_out5,stat_out6,stat_out7); % Figge, Sedino, FTZ, STopP, NFS


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





