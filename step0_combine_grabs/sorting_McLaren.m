% sorting like McLaren 2006 (STA paper), just variance

function [sorting,sort_um] = sorting_McLaren(dis_perc,gz,me_an)

me_an(me_an==0) = NaN;

gz_phi = (-log2(gz./1000)); % d_mm = (2.^(gz_phi.*(-1)).*1000)';
me_an = (-log2(me_an./1000));

for sample = 1 : length(me_an)
    
    if sum(isnan(dis_perc(:,sample))) == length(dis_perc(:,sample))
        sorting(sample) = NaN;
        sort_um(sample) = NaN;
    else
    
        %% mclaen sort
        sorting(sample) = sqrt( nansum( (gz_phi - ones(size(gz_phi))*me_an(sample)).^2 .* dis_perc(:,sample) ) );


        %% std in um for reconstruction
        weighted_sizes = [];
        for n = 1:length(gz)
            weighted_sizes = [ weighted_sizes, repmat( gz(n), 1, round(100*dis_perc(n,sample))) ];
        end
        weighted_sizes = [weighted_sizes, gz(2:end-1)']; % artificially insert all size classes once to have the full range of possible values
        sort_um(sample) = std(weighted_sizes);
        
    end
    
end

if any(imag(sorting))==1
    sorting=real(sorting);
end


