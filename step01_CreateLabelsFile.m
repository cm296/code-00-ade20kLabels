clear all
close all
clc
% Cleaned up ADE20K index
%Cat Magri 2021
% This code builds the file structure to work locally
%includes Scene Label

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
        scenename{counter} = filtered.scene{imgInd};
        
    end  
 
end 

T = table(conditionNumber',condition',filepath',filename',scenename','VariableNames',{'condition','object','filepath','filename','scene'});
writetable(T,'../ADE20K_labels/Ade20K_labels_local_scene')

