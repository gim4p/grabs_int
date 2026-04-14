function [ypred_sed_out,ypred_bath_out] = prediction_parallel_cores(grid_points,dmodel_sediment_semi_pri_sec_cross)


%% set cores
delete(gcp('nocreate'))
% Start parallel pool
try delete(poolobj); catch; disp('No pool active'); end
parpool('local'); poolobj = gcp('nocreate'); % delete(gcp('nocreate')) % terminate existing session

if isempty(poolobj)
	error('No parallel pool active. Check setup!');
else
	poolsize = poolobj.NumWorkers;
end

zL = size(grid_points,1); % Loop length
idx = 1 : zL; 
nL = round(zL/poolsize);
tasks = nan(nL,poolsize);


%% start loops
fprintf(['\nstart ', num2str(poolsize), ' parallel cores..\n'])

for i = 1 : poolsize
       
	if i < poolsize
        tasks(1:nL,i) = idx(nL*(i-1)+1:i*nL);
    else
        tasks(1:length(idx(nL*(i-1)+1:end)),i) = idx(nL*(i-1)+1:end);
	end
end


spmd
    % labindex = CPU Index
	task = tasks(~isnan(tasks(:,labindex)),labindex); 
%       length(task)
	for j = 1 : length(task)
        
        if j/1000 == round(j/1000)
            fprintf(['\n progress: ' num2str( j/length(task)*100 ) '%\n' ]); pause(0.001); end
        
        [ypred_sed_tmp,ypred_bath_tmp] = predict_gridpoints(task,grid_points,dmodel_sediment_semi_pri_sec_cross);
        ypred_sed(j,:) = ypred_sed_tmp;
        ypred_bath(j,:) = ypred_bath_tmp;
    end
end


%% close loops
for i = 1:poolsize
    id_x=task{i};id_x=id_x(1:end-1);
    pred_sed=ypred_sed{i};
    pred_bath=ypred_bath{i};
    
	ypred_sed_out(id_x) = pred_sed(1:end-1); % Get output from CPU cell array
    ypred_bath_out(id_x) = pred_bath(1:end-1); % Get output from CPU cell array
end
delete(poolobj);


%%


