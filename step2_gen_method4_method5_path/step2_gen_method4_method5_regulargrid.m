%% generate cgis csv method 4 to method 5
function step2_gen_method4_method5_regulargrid(fname_out_int,folder_out,fname_out_method4,fname_out_method5)

functionpath = pwd;

calculate_structs_new=1;

fpath = [folder_out,'\'];
fname = fname_out_int;
load( [fpath,fname,'.mat'] )


%% method 4 recalculate statistic moments from interpolated psds (I suppose question of resolution)
gsc_mat = ones(size(grabsint.regulargridinterpolation.psd_all2D));
for n = 1 : length(grabsint.gsc_sievers_recon);
    gsc_mat(:,n) = gsc_mat(:,n)*grabsint.gsc_sievers_recon(n);
end

method4_mean = nansum(gsc_mat.*grabsint.regulargridinterpolation.psd_all2D,2);

clear mat_in; mat_in(1,:,:) = grabsint.regulargridinterpolation.X_grid;
method4_X = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';
clear mat_in; mat_in(1,:,:) = grabsint.regulargridinterpolation.Y_grid;
method4_Y = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';


if calculate_structs_new == 1
    
    psd_all2D = [grabsint.regulargridinterpolation.psd_all2D];
    
    startstop = round(linspace(0,length(grabsint.regulargridinterpolation.psd_all2D),12));

    method4_median_all=[];
    method4_D10_all = [];
    method4_D90_all = [];
    sieving_new_all = [];
    
    method4_mode1_all=[];
    method4_mode2_all=[];
    method4_mode3_all=[];
    method4_modestatus_all = [];


    for mm = 1 : length(startstop)-1

        fprintf([num2str(mm+1),' in process, ',num2str(length(startstop)/mm+1),'\n'])

        startn = startstop(mm)+1;
        stopn  = startstop(mm+1);

        [method4_median, method4_D10, method4_D90, ~]=medianstat(psd_all2D(startn:stopn,:),grabsint.gsc_model);

        [method4_mode_size_1,method4_mode_size_2,method4_mode_size_3,method4_modestatus]=modestat(psd_all2D(startn:stopn,:),grabsint.gsc_model);
        pause(.1)

        method4_median_all = [method4_median_all, method4_median];
        method4_D10_all = [method4_D10_all, method4_D10];
        method4_D90_all = [method4_D90_all, method4_D90];
        
        method4_mode1_all  = [method4_mode1_all, method4_mode_size_1];
        method4_mode2_all  = [method4_mode2_all, method4_mode_size_2];
        method4_mode3_all  = [method4_mode3_all, method4_mode_size_3];
        method4_modestatus_all = [method4_modestatus_all ,method4_modestatus];

    end
    
    
    method4.X = method4_X;
    method4.Y = method4_Y;
    method4.mean = method4_mean;
    method4.median = method4_median_all';
    method4.D10 = method4_D10_all';
    method4.D90 = method4_D90_all';
    method4.mode1 = method4_mode1_all';
    method4.modestat = method4_modestatus_all';
    method4.int_gsc = grabsint.gsc;
    method4.psd_gsc = grabsint.gsc_sievers_recon;
    
    psd_3dtmp = grabsint.regulargridinterpolation.psd_all3D;
    psd_3d = psd_3dtmp;
    psd_2dtmp = grabsint.regulargridinterpolation.psd_all2D;
    psd_2d = psd_2dtmp;
    
    method4.X_grid = grabsint.regulargridinterpolation.X_grid;
    method4.Y_grid = grabsint.regulargridinterpolation.Y_grid;
    method4.psd3D = psd_3d;
    method4.psd2D = psd_2d;
    method4.mode2 = method4_mode2_all';
    method4.mode3 = method4_mode3_all';
    
        
    cd(folder_out)
    save(fname_out_method4, 'method4', '-v7.3');
    cd(functionpath)
    
else
    load('method4_stat_grab_interpolation_IDWp2.5_regintgridres50m_tmp.mat') 
end


%% method 5 interpolated statistic moments and reconstructed psd

clear mat_in; mat_in(1,:,:) = grabsint.regulargridinterpolation.X_grid;
method5_X = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';
clear mat_in; mat_in(1,:,:) = grabsint.regulargridinterpolation.Y_grid;
method5_Y = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';
clear mat_in; mat_in(1,:,:) = grabsint.regulargridinterpolation.stat_mean;
method5_mean = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';
clear mat_in; mat_in(1,:,:) = grabsint.regulargridinterpolation.stat_median;
method5_median = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';
% clear mat_in; mat_in(1,:,:) = grabsint.regulargridinterpolation.stat_D10;
% method5_D10 = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';
% clear mat_in; mat_in(1,:,:) = grabsint.regulargridinterpolation.stat_D90;
% method5_D90 = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';
clear mat_in; mat_in(1,:,:) = grabsint.regulargridinterpolation.stat_mode_1;
method5_mode1 = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';

clear mat_in; mat_in(1,:,:) = grabsint.regulargridinterpolation.stat_modestatus;
method5_modestatus = reshape(mat_in, [size(mat_in,1), size(mat_in,2)*size(mat_in,3) ] )';

method5.X = method5_X;
method5.Y = method5_Y;
method5.mean = method5_mean;
method5.median = method5_median;
% method5.D10 = method5_D10;
% method5.D90 = method5_D90;
method5.mode1 = method5_mode1;
method5.modestat = method5_modestatus;
method5.psd_gsc = grabsint.gsc_sievers_recon;

psd_3dtmp = grabsint.regulargridinterpolation.psd_recon_all3D;
psd_3d = psd_3dtmp;
psd_2dtmp = grabsint.regulargridinterpolation.psd_recon_all2D;
psd_2d = psd_2dtmp;

method5.X_grid = grabsint.regulargridinterpolation.X_grid;
method5.Y_grid = grabsint.regulargridinterpolation.Y_grid;
method5.psd3D = psd_3d;
method5.psd3D = psd_3d;
method5.psd2D = psd_2d;


cd(folder_out)
save(fname_out_method5, 'method5', '-v7.3');
cd(functionpath)



%% gistable
make_gis_table_method4_regulargrid(method4,grabsint,fname_out_method4,folder_out)
cd(functionpath)
make_gis_table_method5_regulargrid(method5,grabsint,fname_out_method5,folder_out)
cd(functionpath)

