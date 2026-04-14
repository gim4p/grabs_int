
function [artificial_median, artificial_D10, artificial_D90, sieving]=medianstat(dis_percent,gz_classes)

if size(dis_percent,1)~=length(gz_classes)
    dis_percent=dis_percent';
end


%% median
for sample = 1 : size(dis_percent,2)
    
    if nansum(dis_percent(:,sample)) == 0
        artificial_median(sample) = NaN;
        artificial_D10(sample) = NaN;
        artificial_D90(sample) = NaN;
        sieving(:,sample) = zeros(gz_classes(end),1);
    else
        
        siebkurve = cumsum(dis_percent(:, sample));
        siebkurve = interp1(gz_classes,siebkurve,1:gz_classes(end)); siebkurve(isnan(siebkurve)) = 0;
        sieving(:,sample) = siebkurve;
        
        [~, row] = min(abs(siebkurve - .5)); % median
        if isempty(row)~=1; artificial_median(sample) = row(1); else  artificial_median(sample) = NaN; end
        [~, row] = min(abs(siebkurve - .1)); % median
        if isempty(row)~=1; artificial_D10(sample) = row(1); else  artificial_D10(sample) = NaN; end
        [~, row] = min(abs(siebkurve - .9)); % median
        if isempty(row)~=1; artificial_D90(sample) = row(1); else  artificial_D90(sample) = NaN; end
        
    end
    
end






