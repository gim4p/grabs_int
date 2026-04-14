% skewness like McLaren 2006 (STA paper)

function [skew_MCL, skew_matlab] = skewness_McLaren_calc(dis_perc,gz,me_an, sorting)

gz_phi = (-log2(gz./1000)); % d_mm = (2.^(gz_phi.*(-1)).*1000)';
me_an = (-log2(me_an./1000));

for sample = 1 : length(me_an)
    
    if sum(isnan(dis_perc(:,sample))) == length(dis_perc(:,sample))
        skew_MCL(sample) = NaN;
        skew_matlab(sample) = NaN;
    else
        
        weighted_sizes = [];
        for n = 2:length(gz)-1
            weighted_sizes = [ weighted_sizes, repmat( gz(n), 1, round(100*dis_perc(n,sample)) ) ];
        end
        weighted_sizes = [weighted_sizes, gz(2:end-1)']; % artificially insert all size classes once to have the full range of possible values
        skew_matlab(sample) = skewness(weighted_sizes);
    %     figure(99); histogram(weighted_sizes,[gz(2:end-1)])
    %     pause(.5);
    %     figure(9);
    %     plot(gz_phi,dis_perc(:,sample))
    %     plot(gz,dis_perc(:,sample))
    
        skew_MCL(sample) = 1/sorting(sample)^3 * ( nansum( (gz_phi - ones(size(gz_phi))*me_an(sample)).^3 .* dis_perc(:,sample) ) );
    end
    
    

    
end

if any(imag(skew_MCL))==1
    skew_MCL=real(skew_MCL);
end

