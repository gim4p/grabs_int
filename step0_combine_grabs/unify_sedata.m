
function stat_out = unify_sedata(stat_in,gz_classes)

options = getGlobalx;

%% save mudpart before defining gsc intervals and normalising to them
stat_in.mudpart_from_acculumated_sieving = stat_in.sieving(63,:)./max(stat_in.sieving);


%% unify accumulated sieving sizes
if size(stat_in.sieving,1) > gz_classes(end)
    % if we want to concentrate on a certain part of the distribution, normalise to zoom
    siev = stat_in.sieving(min(gz_classes):max(gz_classes),:);
    siev = siev - repmat(siev(1,:),size(siev,1),1);
    siev = siev ./  repmat(max(siev),size(siev,1),1);
    stat_in.sieving = [NaN(min(gz_classes)-1,size(siev,2)); siev];
else % (not so nice for memory)
    siev = stat_in.sieving(min(gz_classes) : end, :);
    stat_in.sieving=[siev; NaN(  gz_classes(end)-size(siev,1), size(siev,2)  )];
end


%% make maximal value for the rest of sieving curve and zero to the start of it
[maxval,idxmaxval] = nanmax(stat_in.sieving);
[~,idxminval] = nanmin(stat_in.sieving);

for k = 1 : length(idxmaxval)
    stat_in.sieving(idxmaxval(k):end,k)=maxval(k);
    try
        stat_in.sieving(1:idxminval(k)-1,k)=0;
    catch
        stat_in.sieving(1,k)=0;
    end
end


%% if not yet percent (divide column-max per column)
stat_in.sieving = stat_in.sieving./ repmat(max(stat_in.sieving), [size(stat_in.sieving,1),1]);


%% filter the ones showing a lack of data (e.g. direct jump from 0 to 100)
stat_in.sieving(:,find(max(diff(stat_in.sieving,1))>.99)) = NaN;


%% get grainsize statistics
[dis_percent,gz_classes,sievingmat] = backward_creation_dist(stat_in,gz_classes);
if size(sievingmat,1) ~= size(stat_in.sieving,1)
    stat_in.sieving=sievingmat;
end


%% add zero with no data to hit origin in plot and for statistics
if min(gz_classes)~=0 && size(dis_percent,1) == length(gz_classes)
    gz_classes =[0;gz_classes];
    dis_percent=[zeros(1,size(dis_percent,2));dis_percent];
end


%% again make sure dis percent is in percentage (was necessarry for ftz, -> backward_creation), necessary for cookie cutting parts of distribution for pleasing Clayton's model...
a=ones(size(dis_percent)) ./ repmat( sum(dis_percent,1),size(dis_percent,1),1);
a(a==Inf)=0; dis_percent=a.*dis_percent;


%% 
stat_out = statistics_gz(dis_percent,gz_classes,stat_in,options);



