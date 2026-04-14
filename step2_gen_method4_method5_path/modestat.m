% modestat simply
function [mode_size_1,mode_size_2,mode_size_3,modestatus]=modestat(dis_percent,gz_classes)

mode_detect_val_thh = .00000000000000005; % 0 to 1 range


%%
if size(dis_percent,1)~=length(gz_classes)
    dis_percent=dis_percent';
end


% fig=figure;
for sample = 1 : size(dis_percent,2) % mode start
    
%         clf(fig)
%         figure;semilogx(gz_classes, dis_percent(:,sample), 'Color', 'r', 'LineWidth', 2)
        
        if nansum(dis_percent(:,sample)) == 0  % mode start

            mode_size_1(1,sample) = NaN; mode_size_2(1,sample) = NaN; mode_size_3(1,sample) = NaN;
            mode_size_1(2,sample) = NaN; mode_size_2(2,sample) = NaN; mode_size_3(2,sample) = NaN;
            modestatus(sample) = NaN;

        else
            [pks,locs] = findpeaks(dis_percent(:,sample),gz_classes, 'Threshold', mode_detect_val_thh); % threshold für minimalen Höhenunterschied, der erreicht werden muss: % 

        if isempty(locs)  % wenn flat peaks
            [pks,locs] = findpeaks(dis_percent(:,sample),gz_classes);
            locs(pks < 0.0002) = []; pks(pks < 0.0002) = []; 
        end

        
        pks_sorted = sort(pks, 'descend');
        try
            mode_size_1(1,sample) = locs(find(pks == max(pks))); % mode 1
            mode_size_1(2,sample) = pks_sorted(1);
        catch
            [a,b]=max(dis_percent(:,sample));
            mode_size_1(1,sample) = gz_classes( b ); % mode 1
            mode_size_1(2,sample) = a;
        end
        
        
        
%         ylabel('Class Weight %'); xlabel('Particle Diameter [microns]'); xlim([0 5000])
%         x0=860; y0=420; width=490; height=250;
%         set(gcf,'units','points','position',[x0,y0,width,height])
%         set(gca,'FontSize',15,'XMinorTick','on','XScale','log','XTick',...
%             [1 10 63 100 200 800 2000 5000]);
%         title(num2str(mode_size_1(1,sample)))
        
        
        if numel(pks_sorted) == 2
            
            if pks_sorted(1) == pks_sorted(2)
                mode_size_2(1,sample) = pks_sorted(1); % mode 2
                mode_size_2(2,sample) = pks_sorted(2);
            else
                mode_size_2(1,sample) = locs(find(pks == pks_sorted(2))); % mode 2
                mode_size_2(2,sample) = pks_sorted(2);
            end
            
            mode_size_3(1:2,sample) = 0;

        elseif numel(pks_sorted) > 3

            if numel(find(pks == pks_sorted(2))) > 1
                equalvalues = find(pks == pks_sorted(2));
                mode_size_2(1,sample) = locs(equalvalues(1)); % mode 2
                mode_size_2(2,sample) = pks_sorted(2);
                mode_size_3(1,sample) = locs(equalvalues(2)); % mode 3         
                mode_size_3(2,sample) = pks_sorted(3);                 
            else
                temp_locs_2=locs(find(pks == pks_sorted(2)));
                mode_size_2(1,sample) = temp_locs_2(1); % mode 2
                mode_size_2(2,sample) = pks_sorted(2);
                temp_locs_3=locs(find(pks == pks_sorted(3)));
                mode_size_3(1,sample) = temp_locs_3(1); % mode 3 
                mode_size_3(2,sample) = pks_sorted(3);
            end

        else
            mode_size_2(1:2,sample) = 0;
            mode_size_3(1:2,sample) = 0;

        end
        
        if mode_size_2(1,sample) ~= 0 && mode_size_3(1,sample) ~= 0
            modestatus(sample) = 3;
        elseif mode_size_2(1,sample) ~= 0 && mode_size_3(1,sample) == 0
            modestatus(sample) = 2;
        else
            modestatus(sample) = 1;
        end 
        
        end
        
end
    

% figure(4); plot(modestatus,'.')
