function [tmpp] = normalise_again(Zn,Zall,gz_wanted)
    
    if min(Zn(:)) < 0
        Zn = Zn + abs(min(Zn(:))); % Zn=Zn/max(Zn(:));
        Zn = Zn ./ repmat(sum(Zn,2),1,size(Zn,2));
%         Zall = Zall + abs(min(Zall(:))); % figure;imagesc(Zall(:,:,1))
    end
    
    % Zn back to Zall
    tmpp = permute(Zn,[3 1 2]);
    tmpp = reshape(tmpp, [ size(Zall,1), size(Zall,2), length(gz_wanted) ] );
    
    
    
    % for ml = 1 : length(tmp(1,1,:))
    %     figure(99); imagesc( tmp(:,:,ml) ); colorbar;title(num2str(gsc(ml)))
    %     caxis([min(tmp(:)) max(tmp(:))]);
    %     pause(.1)
    % end
%{    
    % Zn back to Zall
    tmpp = permute(Zn,[3 1 2]);
    try
        tmpp = reshape(tmpp, [ size(Zall,1), size(Zall,2), length(gz_c) ] );
    catch
        tmpp = reshape(tmpp, [ size(Zall,1), size(Zall,2), length(gz_wanted) ] );
    end
%     figure;imagesc(tmpp(:,:,1))
    
    

    % randi1=randi((size(tmp,2)));
    % randi2=randi((size(tmp,1)));
    % figure;plot(tmpp(:,randi2,randi1))
    % kk=tmpp(:,randi2,randi1);
    % sum(kk/sum(kk))
    
    tmpp = permute(Zall,[3 2 1]);
    for na = 1 : size(tmpp,2)
        for ne = 1 : size(tmpp,3)
            vectmp = tmpp(:,na,ne)/sum(tmpp(:,na,ne)); sum(vectmp)
            matrixtmp(:,na,ne)=vectmp;
        end
    end
    
    tmppp = permute(matrixtmp,[3 1 2]); % figure;imagesc(matrixtmp(:,:,1));
    tmppp = reshape(tmppp, [size(tmppp,1), size(tmppp,2)*size(tmppp,3) ] )';
    
    
    figure;plot(tmppp(888,:)); sum(tmppp,2)
    
    %{
    for ml = 1 : length(tmp(1,1,:))
        figure(99); imagesc( tmppp(:,:,ml) ); colorbar;title(num2str(gsc(ml)))
        caxis([min(tmppp(:)) max(tmppp(:))]);
        pause(.06)
    end
    %}

%     Zmat_all = tmppp;
%     figure;imagesc(Zmat_all(:,:,1))
    
 %}   
    