

function [mode_size_1,mode_size_2,mode_size_3,modestatus]=make_mode_dis_perc(sample,dis_percent,gz_classes)

mode_detect_val_thh = 0.001;

% mode
if nansum(dis_percent(:,sample)) ~= 0

    [pks,locs] = findpeaks(dis_percent(:,sample), 'Threshold', mode_detect_val_thh); % threshold für minimalen Höhenunterschied, der erreicht werden muss: % 

        if isempty(locs)  % wenn flat peaks
            [pks,locs] = findpeaks(dis_percent(:,sample));
            locs(pks < 0.02) = []; pks(pks < 0.02) = []; 
        else
        end

    pks_sorted = sort(pks, 'descend');
    mode_size_1(1,1) = gz_classes(locs(find(pks == max(pks)))); % mode 1
    mode_size_1(2,1) = pks_sorted(1);

    if numel(pks_sorted) == 2

        mode_size_2(1,1) = gz_classes(locs(find(pks == pks_sorted(2)))); % mode 2
        mode_size_2(2,1) = pks_sorted(2);                  
        mode_size_3(1:2,1) = 0;

    elseif numel(pks_sorted) > 3

        if numel(find(pks == pks_sorted(2))) > 1
            equalvalues = find(pks == pks_sorted(2));
            mode_size_2(1,1) = gz_classes(locs(equalvalues(1))); % mode 2
            mode_size_2(2,1) = pks_sorted(2);
            mode_size_3(1,1) = gz_classes(locs(equalvalues(2))); % mode 3         
            mode_size_3(2,1) = pks_sorted(3);                 
        else       
            mode_size_2(1,1) = gz_classes(locs(find(pks == pks_sorted(2)))); % mode 2
            mode_size_2(2,1) = pks_sorted(2);
            mode_size_3(1,1) = gz_classes(locs(find(pks == pks_sorted(3)))); % mode 3 
            mode_size_3(2,1) = pks_sorted(3);
        end

    else
        mode_size_2(1:2,1) = 0;
        mode_size_3(1:2,1) = 0;

    end

    if mode_size_2(1,1) ~= 0 && mode_size_3(1,1) ~= 0
        modestatus(1) = 3;
    elseif mode_size_2(1,1) ~= 0 && mode_size_3(1,1) == 0
        modestatus(1) = 2;
    else
        modestatus(1) = 1;
    end
else
    mode_size_1=[0;0];
    mode_size_2=[0;0];
    mode_size_3=[0;0];
    modestatus=0;
end
