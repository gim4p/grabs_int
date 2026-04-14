
function [sorting_num_FolkWard,sorting_class_FolkWard,sorting_num_stdev]=sortingstat_FolkWart1957(sieving)

for sample = 1 : size(sieving,2)
    
    %% Logarithmic (original) Folk and Ward (1957) graphical measures
    try        
        [~, row] = min(abs(sieving(:,sample) - .05)); percent_5 = row(1);
        if percent_5==1; temp=unique(abs(sieving(:,sample) - .05));
            percent_5 = find(abs(sieving(:,sample) - .05)==temp(2)); end
        [~, row] = min(abs(sieving(:,sample) - .16)); percent_16 = row(1);
        [~, row] = min(abs(sieving(:,sample) - .84)); percent_84 = row(1);
        [~, row] = min(abs(sieving(:,sample) - .95)); percent_95 = row(1);
        
        percent_5phi = -log2(percent_5 * 1e-3);   percent_16phi = -log2(percent_16 * 1e-3);
        percent_84phi = -log2(percent_84 * 1e-3); percent_95phi = -log2(percent_95 * 1e-3);

        sorting = (  ((percent_84phi - percent_16phi) / 4) + ((percent_95phi - percent_5phi) / 6.6)  )* (-1);
        if isempty(sorting)~=1
            sorting_num_FolkWard(sample) = sorting ;
            
            if sorting < 0.35
                sorting_class_FolkWard{sample} =  'Very well sorted';
            elseif sorting >= 0.35 && sorting < 0.50
                sorting_class_FolkWard{sample} =  'Well sorted';
            elseif sorting >= 0.50 && sorting < 0.72
                sorting_class_FolkWard{sample} =  'Moderately well sorted';
            elseif sorting >= 0.72 && sorting < 1
                sorting_class_FolkWard{sample} = 'Moderately sorted';
            elseif sorting >= 1 && sorting < 2
                sorting_class_FolkWard{sample} =  'Poor sorted';
            elseif sorting >= 2 && sorting < 4
                sorting_class_FolkWard{sample} =  'Very poor sorted';
            elseif sorting >= 4.00 
                sorting_class_FolkWard{sample} =  'Extremely poorly sorted';                
            end
        
        else
            sorting_num_FolkWard(sample) = NaN ; sorting_class_FolkWard{sample} =  'no classification';
        end
        
    catch
        sorting_num_FolkWard(sample) = NaN; sorting_class_FolkWard{sample} = 'no classification';
    end 
    
    %% stddev
    sorting_num_stdev(sample) = std(sieving(:,sample));

end

