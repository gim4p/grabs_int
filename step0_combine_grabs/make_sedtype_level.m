
function  [stat] = make_sedtype_level(stat)

if isfield(stat,'level_A')
    disp('levels already calculated')
else
    
    gsc_sedtype = [63, 200, 630, 2000, 6300]; %fSa mSa cSa gravel
    stattmp = stat;
    if size(stattmp.sieving,1) < gsc_sedtype(end)
        stattmp.sieving = [ stat.sieving ; ones(  gsc_sedtype(end)- size(stattmp.sieving,1) , size(stattmp.sieving,2) ) ];
    end
    
    feiner_als_feinsand_percent_all = stattmp.sieving(63,:);
    feinsand_percent_all = stattmp.sieving(200,:) - stattmp.sieving(63,:);
    mittelsand_percent_all = stattmp.sieving(630,:) - stattmp.sieving(200,:);
    grobsand_percent_all = stattmp.sieving(2000,:) - stattmp.sieving(630,:);
    all_sand_percent_all = stattmp.sieving(2000,:) - stattmp.sieving(63,:);
    gravel_percent_all = stattmp.sieving(6300,:) - stattmp.sieving(2000,:);
    
    % nur innerhalb Sand
    sand_fSa_percent = feinsand_percent_all./ (feinsand_percent_all+mittelsand_percent_all+grobsand_percent_all);
    sand_mSa_percent = mittelsand_percent_all./ (feinsand_percent_all+mittelsand_percent_all+grobsand_percent_all);
    sand_cSa_percent = grobsand_percent_all./ (feinsand_percent_all+mittelsand_percent_all+grobsand_percent_all);
    
    
    %% 
    Lfeinsand_100 = sand_fSa_percent./(sand_fSa_percent+sand_mSa_percent+sand_cSa_percent);
    Lmittelsand_100 = sand_mSa_percent./(sand_fSa_percent+sand_mSa_percent+sand_cSa_percent);
    Lgrobsand_100 = sand_cSa_percent./(sand_fSa_percent+sand_mSa_percent+sand_cSa_percent);
    
    
    %% mud sand gravel into struct
    stat.finematerial=feiner_als_feinsand_percent_all;
    stat.justsand=all_sand_percent_all;
    stat.finesand=feinsand_percent_all;
    stat.middlesand=sand_mSa_percent;
    stat.coarsesand=sand_cSa_percent;
    stat.justgravel=gravel_percent_all;
    
    
    %% Folk 1954 Grobeinteilung Ebene B

    level_B = zeros( 1, length(sand_fSa_percent) );

    level_B( find(gravel_percent_all > .8 & gravel_percent_all <= 1) ) = 1;  % 1: Grobsediment G
    level_B( find(gravel_percent_all < .8 & gravel_percent_all > .3) ) = 4;  % 2: mG, msG, sG (nur weil ich die zeros drin haben möchte für nicht funtzende) 
    level_B( find(gravel_percent_all < .3 & gravel_percent_all > .05)) = 7;  % 3: gM, gmS, gS 
    level_B( find(gravel_percent_all < .05& gravel_percent_all >= 0) ) = 11; % 3: M, sM, mS, S  (bei normal Folk: 10%, in BSH-Klassifizierung: 5%)

    Folk_class_temp_1 = ones( 1, length(sand_fSa_percent) ) * 4; Folk_class_temp_1(find(level_B ~=  4)) = 0; 
    Folk_class_temp_2 = ones( 1, length(sand_fSa_percent) ) * 7; Folk_class_temp_2(find(level_B ~=  7)) = 0;
    Folk_class_temp_3 = ones( 1, length(sand_fSa_percent) ) *11; Folk_class_temp_3(find(level_B ~= 11)) = 0;

    % mG, msG, sG    
    Folk_class_temp_1( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .1 ) ) = ...
        Folk_class_temp_1( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .1 ) ) - 1; % msG
    Folk_class_temp_1( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .5 ) ) = ...
        Folk_class_temp_1( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .5 ) ) - 1; % mG
    Folk_class_temp_1(Folk_class_temp_1<0) = 0;

    % gM, gmS, gS
    Folk_class_temp_2( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .1 ) ) = ...
        Folk_class_temp_2( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .1 ) )- 1; % gmS
    Folk_class_temp_2( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .5 ) ) = ...
        Folk_class_temp_2( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .5 ) )- 1; % gM
    Folk_class_temp_2(Folk_class_temp_2<0) = 0;

    % M, sM, mS, S
    Folk_class_temp_3( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .1 ) ) = ...
        Folk_class_temp_3( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .1 ) )- 1; % mS
    Folk_class_temp_3( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .5 ) ) = ...
        Folk_class_temp_3( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .5 ) )- 1; % sM
    Folk_class_temp_3( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .9 ) ) = ...
        Folk_class_temp_3( find( feiner_als_feinsand_percent_all./ (feiner_als_feinsand_percent_all + all_sand_percent_all) > .9 ) )- 1; % M
    Folk_class_temp_3( find( gravel_percent_all > .01 & Folk_class_temp_2 == 10 ) ) = ...
        Folk_class_temp_3( find( gravel_percent_all > .01 & Folk_class_temp_2 == 10 ) ) - 1; % gS von S trennen 
    Folk_class_temp_3( find( gravel_percent_all > .01 & Folk_class_temp_2 == 6 ) ) = ...
        Folk_class_temp_3( find( gravel_percent_all > .01 & Folk_class_temp_2 == 6 ) ) - 1;  % gM von M trennen 
    Folk_class_temp_3(Folk_class_temp_3<0) = 0;

    temp = Folk_class_temp_1 + Folk_class_temp_2 + Folk_class_temp_3; 

    level_B = strtrim(cellstr(num2str(NaN( 1, length(sand_fSa_percent) )'))');
    level_B (find( temp == 1 ) ) = {'G'}; 
    level_B (find( temp == 2 ) ) = {'mG'}; 
    level_B (find( temp == 3 ) ) = {'msG'}; 
    level_B (find( temp == 4 ) ) = {'sG'}; 
    level_B (find( temp == 5 ) ) = {'gM'}; 
    level_B (find( temp == 6 ) ) = {'gmS'}; 
    level_B (find( temp == 7 ) ) = {'gS'}; 
    level_B (find( temp == 8 ) ) = {'M'}; 
    level_B (find( temp == 9 ) ) = {'sM'}; 
    level_B (find( temp ==10 ) ) = {'mS'}; 
    level_B (find( temp ==11 ) ) = {'S'}; 

    %% Ebene A -> am gröbsten

    level_A = strtrim( cellstr(num2str(NaN( 1, length(sand_fSa_percent) )' ) ) )';
    level_A(   find( temp == 11) ) = {'S'};     % S    
    level_A( [ find( temp == 1 ), find( temp == 4 ), find( temp == 7 ) ] ) = {'cSed'};  % cSed
    level_A( [ find( temp == 8 ), find( temp == 9 ), find( temp == 10) ] ) = {'fSed'};  % fSed
    level_A( [ find( temp == 2 ), find( temp == 3 ), find( temp == 5 ), find( temp == 6 ) ] ) = {'mxSed'}; % mxSed

    %% Figge Sandeinteilung  1:gS, 2:mS-gS, 3:fS, 4:mS 
    %     Figge_class  = zeros(1, length(feinsand_percent) ) ;    
    level_C  =  strtrim( cellstr(num2str(NaN( 1, length(sand_fSa_percent) )' ) ) )';

    for n = 1 : numel(level_C)
        if sand_mSa_percent(n) > .4
            level_C(n) = {'mSa'}; % 4 = mS     
        else
            level_C(n) = {'fSa'}; % 3 = fS 
        end
    end

    level_C(find(sand_cSa_percent > .6)) = {'gSa'}; % 1 = gS
    level_C(find(sand_cSa_percent < .6 & sand_cSa_percent > .1)) = {'mSa-gSa'}; % 2 = mS-gS 
    level_C(find(temp ~=11)) = {'NC'};


    %% Sedmost
    sedmost = cell(size(level_A));
    for n = 1 : length(sedmost)
        if level_A{n} == 'S'
            sedmost{n} = level_C{n};
        else
            sedmost{n} = level_B{n};
        end
    end


    %% add to structure
    stat.LevelA=level_A;
    stat.LevelB=level_B;
    stat.LevelC=level_C;
    stat.sedmost=sedmost;



end




