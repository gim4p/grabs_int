%% Inverse Distance Weighting for every particle size
function [Xint,Yint,Zmat_all,Zmat_n,X_coo,Y_coo,stat_mean,stat_median,stat_skew,stat_sort,stat_sort_McL,stat_D10,stat_D90] =...
    psd_class_interpolation_idw(p,gridresolution,gsc,X,Y,Z,stat_mean,stat_median,stat_skew,stat_sort,stat_sort_McL,stat_D10,stat_D90,bathy_points,bathy_int,grabsampletime)


%% make grid for interpolation
[Xint,Yint] = meshgrid(min(X) :  gridresolution  : max(X), min(Y) :  gridresolution  : max(Y));

xtmp = find(sum(~isnan(Xint),2) == max(sum(~isnan(Xint),2)) );
ytmp = find(sum(~isnan(Yint),1) == max(sum(~isnan(Yint),1)) );
X_coo = Xint(xtmp(1),:);
Y_coo = Yint(:,ytmp(1));

bathypointlist = bathy_points(:);
bathyintlist = bathy_int(:);


%% idw
%% method 4
for n = 1 : length(gsc)
    fprintf(['\n',datestr(now),num2str(n),'th of ',num2str(length(gsc)), ', grain size class: ', num2str(gsc(n)),' µm\n'])
    tic
    Zin(:,1) = Z(n,:);
    Fint = idw([X,Y],Zin,[Xint(:),Yint(:)],p,bathypointlist,bathyintlist,grabsampletime); % bathymetric weighting in idw not afterwards!    
    
    %%
    Zmat=reshape(Fint,size(Yint,1),size(Yint,2));
    
    Zmat_all(:,:,n) = Zmat;
    
    figure(9)
    subplot( ceil(length(gsc)/3), ceil(length(gsc)/ceil(length(gsc)/3) ), n )
    hold on;
    subs{n}=imagesc(X_coo, Y_coo, Zmat); axis equal
%     scatter(X,Y,50,(Zin),'filled','MarkerEdgeColor',[0 0 0]);
    xlabel('X');ylabel('Y');colorbar
    title(['grain size class nb: ',num2str(gsc(n)),' µm'])
    pause(.5)
    toc
end

Zmat_n = permute(Zmat_all,[3 1 2]);
Zmat_n = reshape(Zmat_n, [size(Zmat_n,1), size(Zmat_n,2)*size(Zmat_n,3) ] )' ;


%% method 5
fprintf('\nmethod 5\nmean')
stat_mean = idw([X,Y],stat_mean,[Xint(:),Yint(:)],p,bathypointlist,bathyintlist,grabsampletime);
fprintf('\nmedian')
stat_median = idw([X,Y],stat_median,[Xint(:),Yint(:)],p,bathypointlist,bathyintlist,grabsampletime);
fprintf('\nskewness')
stat_skew = idw([X,Y],stat_skew,[Xint(:),Yint(:)],p,bathypointlist,bathyintlist,grabsampletime);
fprintf('\nsorting')
stat_sort = idw([X,Y],stat_sort,[Xint(:),Yint(:)],p,bathypointlist,bathyintlist,grabsampletime);
fprintf('\nsorting Mc L')
stat_sort_McL = idw([X,Y],stat_sort_McL,[Xint(:),Yint(:)],p,bathypointlist,bathyintlist,grabsampletime);
fprintf('\nD10')
stat_D10 = idw([X,Y],stat_D10,[Xint(:),Yint(:)],p,bathypointlist,bathyintlist,grabsampletime);
fprintf('\nD90')
stat_D90 = idw([X,Y],stat_D90,[Xint(:),Yint(:)],p,bathypointlist,bathyintlist,grabsampletime);

stat_mean=reshape(stat_mean,size(Yint,1),size(Yint,2));
stat_median=reshape(stat_median,size(Yint,1),size(Yint,2));
stat_skew=reshape(stat_skew,size(Yint,1),size(Yint,2));
stat_sort=reshape(stat_sort,size(Yint,1),size(Yint,2));
stat_sort_McL=reshape(stat_sort_McL,size(Yint,1),size(Yint,2));
stat_D10=reshape(stat_D10,size(Yint,1),size(Yint,2));
stat_D90=reshape(stat_D90,size(Yint,1),size(Yint,2));




