%% mergeobjects001
%
% Merge ADE index data for specified object labels
% 
%% Syntax
% 
% merged = mergeobjects001(index, labelGroups)
% 
%% Description
% 
% Merge ADE index data for specified object labels 
%
%% Example
%
%   merged = mergeobjects001(index, labelGroups);
% 
%% See also
% 
% * <file:ade032.html ade032>
% * <file:mergerepeats001.html mergerepeats001>
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com michaelfbonner.com> 


%% Function

function merged = mergeobjects001(index, labelGroups)

% Object label groups
nGroups = size(labelGroups, 1);

% Objects-by-image matrix
objectPresence = index.objectPresence; 

% Object labels
objectnames = index.objectnames;
objectnames = lower(objectnames);
nObjs = length(objectnames);

% Combine data for all labels associated with a condition
moved = false(nObjs, 1);
for iGroups = 1 : nGroups
    
    % Associated labels
    cond = labelGroups{iGroups, 1}{1};
    associatedLabels = labelGroups{iGroups, 2};
    nAssociated = length(associatedLabels);
    
    % Use index of first associated label for this condition
    inds = find(ismember(objectnames, associatedLabels));
    condInd = inds(1);
    objectnames{condInd} = cond;  % replace object label with condition name
    
    % Merge data across all associated entries
    objectPresence(condInd, :) = sum(objectPresence(inds, :), 1);
        
    % Log moved data
    if nAssociated > 1
        movedInds = inds(2:end);
        moved(movedInds) = true;
    end  % if nCondLabels > 1

end  % for iGroups = 1 : nGroups

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

end  % function merged = mergeobjects001(index)
