function [gz_classes,gz_classes_model] = make_gsc_interval(input_info)


if strcmp(input_info,'nfsued_intervals') == 1 % NF-Sued Siebintervalle
    
    gz_classes = [63;75;90;106;125;150;180;212;250;300;355;425;500;...
                  600;710;850;1000;1180;1400;1700;2000;2360;2800;3350;...
                  4000;4750;5600;6300;6700;8000;9500;11200;12500;13200;...
                  16000;20000];
    
elseif strcmp(input_info,'manually') == 1
    
    gz_classes = [63;75;90;106;125;150;180;212;250;300;355;425;500;...
                  600;710;850;1000;1180;1400;1700;2000];
              
elseif strcmp(input_info,'modelclayton') == 1
    
    gz_classes_model = [ 105  150  210  300  420  600  ]; % Claytons final classes 16.01.2025
    
    gsc_halfsize = 1;
    cd ..; save('gsc_halfsize_tmp','gsc_halfsize'); cd step0_combine_grabs
    
    if gsc_halfsize ~= 1
        gz_classes_model = [ 105  150  210  300  420  600  605 ]'; 
    end
    
    gz_classes = gz_classes_model; % new
    
    
    if gsc_halfsize == 1
        %% Clayton grabs higherresolution for comparing
        
        gz_classes = -log2(gz_classes_model/1000);
        diffints = abs(diff(gz_classes)/2);

        gz_classes = sort(gz_classes); % calc halfes of phi scale
        diffints = fliplr(diffints);

        clear strtemp
        for nn = 1 : length(gz_classes)-1
            if nn == 1
                strtemp(nn,1) = gz_classes(nn) - diffints(nn);
                strtemp(nn+1,1) = gz_classes(nn) + diffints(nn);
            else
                strtemp(nn+1,1) = gz_classes(nn) + diffints(nn);
            end
            if nn == length(gz_classes)-1
                strtemp(nn+2,1) = gz_classes(nn+1) + diffints(nn);
            end
        end

        gz_classes = strtemp;
        gz_classes = fliplr(strtemp); % phi
        gz_classes_um = 2.^(gz_classes*(-1))*1000;

        phi =       [9 8 7  6  5  4  3.25 2.75  3  2.25  2  1.75  1.25   1  0.75  0   -1   -2   -3   -4     -5    -6];
        microns =   [2 4 8 16 32 63  105  150 125  210  250  300   420  500 600  1000 2000 4000 8000 16000 32000 63000];
        
        gz_classes=sort(round(gz_classes_um));
        
        %{
        figure; hold on
        plot(microns,phi,'o-')
        plot([min(microns),max(microns)],[0,0],'k')
        plot(gz_classes_model, -log2(gz_classes_model/1000) ,'k*')
        plot(gz_classes_um,gz_classes,'r*')
        ylabel('phi'); xlabel('microns'); grid on
        %}
        
    end
    
end

