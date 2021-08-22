clear all
close all
clc
% Cleaned up ADE20K index
file = fullfile('..','ADE20K_labels', 'filtered.mat');
load(file, 'filtered');

% Conditions
conds = conditionarray();
nConds = length(conds);

% Objects-by-images matrix
op = filtered.objectPresence; 
simplenames = filtered.simplenames;

% % Scene images
% condResults = cell(nConds, 1);

counter = 0;
condition = [];
filepath = [];
filename = [];
%Find frequency of most occurring scenes
for iConds = 1 : nConds
    
    % Display progress
    disp([num2str(iConds) ' of ' num2str(nConds)])
    
    cond = conds{iConds};
    ind = ismember(simplenames, cond);
    imgInds = find(op(ind,:));
    nStim = length(imgInds);
    
    
    
    results = cell(nStim, 1);
    for iStim = 1 : nStim
        counter = counter + 1;
        % Image
        imgInd = imgInds(iStim);
        file = fullfile('..','..','adeContext-datasets', 'ADE20K',filtered.folder{imgInd}, filtered.filename{imgInd});               
%         condResults{iConds}{iStim} = file;
        conditionNumber{counter} = iConds;
        conditionNumber_orig{counter} = find(ind);
        condition{counter} = cond;
        filepath{counter} = fullfile('..','..','adeContext-datasets', 'ADE20K', filtered.folder{imgInd});
        filename{counter} = filtered.filename{imgInd}(1:end-4);
        scene_freq()
        
    end  
 
end 

T = table(conditionNumber',condition',filepath',filename','VariableNames',{'condition','object','filepath','filename'});
writetable(T,'../ADE20K_labels/Ade20K_labels_local')

