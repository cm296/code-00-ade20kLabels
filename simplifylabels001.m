%% simplifylabels001
%
% Simplify object names
% 
%% Syntax
% 
% simplenames = simplifylabels001(objectnames)
% 
%% Description
% 
% Simplify object names. Try to create single-word labels for all objects.
% If any single-word labels are repeated, replace these with longer names. 
%
%% Example
%
%   simplenames = simplifylabels001(objectnames);
% 
%% See also
% 
% * <file:ade032.html ade032>
% * <file:mergerepeats001.html mergerepeats001>
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com michaelfbonner.com> 


%% Function

function simplenames = simplifylabels001(objectnames)

% Conditions
% * load condition names to check that they are not among the repeated
% labels, which could problems later when indexing the condition data
file = fullfile('..', 'ADE20K_labels', 'conditions.mat');
load(file);
% Loads:
% * conds
nConds = length(conds);

% Rename to single-word labels
nObjs = length(objectnames);
simplenames = cell(size(objectnames));
for iObjs = 1 : nObjs
    label = objectnames{iObjs};
    if strcmp(label, 'car' )
       label 
    end
    label = strsplit(label, ', ');
    objLabel = label{1};
%     if strcmp(objLabel, 'car' )
%        objLabel 
%     end
    % Exception for experimental conditions
    if any(strcmp({'monitor'}, objLabel)) && length(label)>1
        objLabel = label{2};
    end
    
    objLabel = regexprep(objLabel, ' ', '_');
    simplenames{iObjs} = objLabel;
end  % for iObjs = 1 : nObjs

% Rename repeated labels by appending their second associated name
[~, ia, ic] = unique(simplenames);
[count, ~, idxcount] = histcounts(ic, numel(ia));
repeatInds = count(idxcount) > 1;
repeatedLabels = unique(simplenames(repeatInds));
assert(~any(ismember(conds, repeatedLabels)))
nRepeats = length(repeatedLabels);
for iRepeats = 1 : nRepeats
    repeatLabel = repeatedLabels{iRepeats};
    repeatInds = find(ismember(simplenames, repeatLabel));
    nInds = length(repeatInds);
    for iInds = 1 : nInds
        repeatInd = repeatInds(iInds);
        label = objectnames{repeatInd};
        label = strsplit(label, ', ');
        if length(label) > 1
            objLabel = [label{1} '_' label{2}];
        else
            objLabel = label{1};
        end
        objLabel = regexprep(objLabel, ' ', '_');
        simplenames{repeatInd} = objLabel;
    end
end  % for iRepeats = 1 : nRepeats

% Check that repeats have been removed
[~, ia, ic] = unique(simplenames);
[count, ~, idxcount] = histcounts(ic,numel(ia));
repeatInds = count(idxcount) > 1;
assert(~any(repeatInds), 'Error in removal of repeats while simplifying labels')


end  % function simplenames = simplifylabels001(objectnames)
