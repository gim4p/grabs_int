
function [arit_mean,geo_mean]=meanstat(dis_percent, gz_classes)

for sample = 1 : size(dis_percent,2)
    
    if nansum(dis_percent(:,sample)) == 0  % mode start
        arit_mean(sample) = 0; geo_mean(sample) = 0;
    else

        % arit mean
        arit_mean(sample) = nansum(prod([gz_classes, dis_percent(:,sample)], 2));
        % geo mean
        geo_mean(sample) = exp(nansum(prod([log(gz_classes), dis_percent(:,sample)], 2)));

    end
    
end