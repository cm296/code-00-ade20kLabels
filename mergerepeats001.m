%% mergerepeats001
%
% Merge ADE index data for repeated object labels using lowercase
% 
%% Syntax
% 
% merged = mergerepeats001(index)
% 
%% Description
% 
% Merge ADE index data for repeated object labels 
%
%% Example
%
%   merged = mergerepeats001(index);
% 
%% See also
% 
% * <file:ade032.html ade032>
% * <file:mergeobjects001.html mergeobjects001>
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com michaelfbonner.com> 


%% Function

function merged = mergerepeats001(index)

% Objects-by-image matrix
objectPresence = index.objectPresence; 

% Object labels
objectnames = index.objectnames;
objectnames = lower(objectnames);
nObjs = length(objectnames);

% Combine repeated labels
[~, ia, ic] = unique(objectnames);
[count, ~, idxcount] = histcounts(ic, numel(ia));
instanceCounts = count(idxcount);
repeatInds = instanceCounts > 1;
repeatedLabels = unique(objectnames(repeatInds));
nRepeats = length(repeatedLabels);
moved = false(nObjs, 1);
for iRepeats = 1 : nRepeats
    
    % Repeat indices
    repeatLabel = repeatedLabels{iRepeats};
    inds = find(ismember(objectnames, repeatLabel));
      
    % Merge data across all associated entries
    objectPresence(inds(1), :) = sum(objectPresence(inds, :), 1);
        
    % Log moved data
    movedEntries = inds(2:end);
    moved(movedEntries) = true;

end  % for iRepeats = 1 : nRepeats

% Update:
% * objectPresence 
% * objectcounts
% * objectnames
merged = index;
merged.objectPresence = objectPresence;
merged.objectcounts = sum(index.objectPresence, 2);
merged.objectnames = objectnames;

% Only keep entries that were not moved
keep = ~moved;
structFields = fieldnames(merged);
nFields = length(structFields);
nObjs = length(merged.objectnames);
for iFields = 1 : nFields

    % Field data
    structField = structFields{iFields};
    data = merged.(structField);
    dataSize = size(data);

    % Look for a dimension related to the objects
    objDim = find(dataSize==nObjs);
    if isempty(objDim)
        continue
    end
    
    % Remove object entries for moved data
    switch objDim
        case 1
            data = data(keep, :);
        case 2
            data = data(:, keep);
    end
    
    % Update field data
    merged.(structField) = data;
  
end  % for iFields = 1 : nFields

% Check that repeats have been removed
[~, ia, ic] = unique(merged.objectnames);
[count, ~, idxcount] = histcounts(ic,numel(ia));
repeatInds = count(idxcount) > 1;
assert(~any(repeatInds), 'Error in removal of repeat labels')

end  % function merged = mergerepeats001(index)