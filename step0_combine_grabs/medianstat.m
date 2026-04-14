
function [artificial_median, artificial_D10, artificial_D90, sieving]=medianstat(dis_percent,gz_classes,stat_in)

%% median
for sample = 1 : size(dis_percent,2)
    
    if nansum(dis_percent(:,sample)) == 0
        
        artificial_median(sample) = NaN;
        artificial_D10(sample) = NaN;
        artificial_D90(sample) = NaN;
        
    else
        
        if isfield(stat_in,'sieving')~=1

            for sc = 1 : size(dis_percent, 1) % accumulated curve quickly start 
                if exist('siebkurve') == 1 
                    siebkurve(sc) = siebkurve(sc-1) + dis_percent(sc, sample);
                else
                    siebkurve(sc) = dis_percent(sc, sample);
                end
            end
            
            siebkurve = interp1(gz_classes,siebkurve,1:gz_classes(end)); siebkurve(isnan(siebkurve)) = 0;
            sieving(:,sample) = siebkurve;   % accumulated curve quickly stop 
            [~, row] = min(abs(siebkurve - .5)); % median
            if isempty(row)~=1; artificial_median(sample) = row(1); else  artificial_median(sample) = NaN; end
            [~, row] = min(abs(siebkurve - .1)); % median
            if isempty(row)~=1; artificial_D10(sample) = row(1); else  artificial_D10(sample) = NaN; end
            [~, row] = min(abs(siebkurve - .9)); % median
            if isempty(row)~=1; artificial_D90(sample) = row(1); else  artificial_D90(sample) = NaN; end

        else
            
            siebkurve = stat_in.sieving(:,sample);
            [~, row] = min(abs(siebkurve - .5)); % median
            if isempty(row)~=1; artificial_median(sample) = row(1); else  artificial_median(sample) = NaN; end
            [~, row] = min(abs(siebkurve - .1)); % median
            if isempty(row)~=1; artificial_D10(sample) = row(1); else  artificial_D10(sample) = NaN; end
            [~, row] = min(abs(siebkurve - .9)); % median
            if isempty(row)~=1; artificial_D90(sample) = row(1); else  artificial_D90(sample) = NaN; end
            
        end
       
    end
    
end

if isfield(stat_in,'sieving')==1
    sieving=stat_in.sieving;
end


