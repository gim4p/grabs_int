% return to frequ distribution
function [array_values,gz_c,mat] = backward_creation_dist(stat,gz_classes)

mat=stat.sieving;

if gz_classes(end) == size(mat,1)
    gz_c = gz_classes;
elseif gz_classes(end) > size(mat,1)
    gz_c = gz_classes(1:interp1(gz_classes,1:length(gz_classes),size(mat,1),'nearest'));
else
    if length(mat(gz_classes(end),:)) == sum(mat(gz_classes(end),:))
        gz_c = gz_classes;
        mat = mat(1:gz_classes(end),:);
    else
        gz_c = [gz_classes;size(mat,1)];
    end
end


%% distribution bigger set smallest gz class (probably 63)
clear array_values; array_values=zeros(length(gz_c),size(mat,2));
for n = 1 : length(gz_c)-1
    if gz_c(n) ~= 0
        array_values(n,:) = mat(gz_c(n+1),:) - mat(gz_c(n),:);
    else
        array_values(n,:) = 0;
    end
end




