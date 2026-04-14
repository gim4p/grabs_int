%% INTERPOLATION routine (all together)
clear all; close all; clc
tStart = tic;
funpath = pwd;


%% set, half size
gridresolution = 200; % m of regular grid for interpolation
name_addition = '';
semivar_again = 0;   % recalculate variograms

interpolation_method = 'CoK'; % 'IDW'; %

t_n=datestr(now);t_n = strrep(t_n,'-','');t_n = strrep(t_n,' ','');t_n = strrep(t_n,':','');
folder_out = [pwd,'\out\',interpolation_method,'grid',num2str(gridresolution),'m_',name_addition,'_',t_n,'\'];
mkdir(folder_out)

fprintf(['\n',interpolation_method,'\n'])


%% step 0: combine grab samples
cd step0_combine_grabs
try
    [fname_out_grabs,gsc] = step0_combine_grabs(t_n,folder_out);
catch
    [fname_out_grabs,gsc] = step0_combine_grabs_open(t_n,folder_out); % for all
end
fname = fname_out_grabs;
cd ..


%% step 1: interpolation
p = 3; % inverse distance weighting parameter (sensitivity)
savefiles = 1;
timeframe = 0;
furtherGeoZoom = 0; % model area zoom
tinytestzoom = 0; % tiny zoom for testing data, else model zoom
newharm = 1; % new harmonisation of bathymetry and sedsamples
if tinytestzoom == 1; newharm = 1; end
addinfo = 'info';
if timeframe == 1
    addinfo = [addinfo,'timeframe'];
else
    addinfo = [addinfo,'alltime'];
end
if furtherGeoZoom == 1
    addinfo = [addinfo,'_geozoom'];
end

if strcmp(interpolation_method,'CoK')
    fname_out_int = ['CoK_',addinfo,'_', gsc,'_regintgridres',num2str(gridresolution),'m_', t_n];
    fname_out_int = strrep(fname_out_int,'.','');
else
    fname_out_int = ['IDWp',num2str(p),'_',addinfo,'_', gsc,'_regintgridres',num2str(gridresolution),'m_', t_n];
    fname_out_int = strrep(fname_out_int,'.','');
end

save([folder_out,'/infofile'])

cd step1_int_path
step1_int(interpolation_method,p,savefiles,timeframe,furtherGeoZoom,tinytestzoom,newharm,gridresolution,folder_out,fname_out_grabs,fname_out_int,fname,semivar_again)
cd ..

fprintf([datestr(now),'\nstep 1 finished\n'])


%% step 2: generate method4 stat moments and method5 PSD
fname_out_method4 = ['method4_modelgrid_',fname_out_int];
fname_out_method5 = ['method5_modelgrid_',fname_out_int];
fname_out_method4_reg = ['method4_regulargrid_',fname_out_int];
fname_out_method5_reg = ['method5_regulargrid_',fname_out_int];
save([folder_out,'/infofile'])

cd step2_gen_method4_method5_path
step2_gen_method4_method5_regulargrid(fname_out_int,folder_out,fname_out_method4_reg,fname_out_method5_reg)
step2_gen_method4_method5(fname_out_int,folder_out,fname_out_method4,fname_out_method5)
cd ..

tmiddle = toc(tStart);
fprintf([datestr(now),'\nstep 2 finished in ',num2str(tmiddle/3600),'\n'])


%% finished
save([folder_out,'/infofile'])

cd(funpath)
tEnd = toc(tStart);
fprintf(['\nall done in ', num2str(tEnd/3600), ' hours \n'])




