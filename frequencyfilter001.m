%% frequencyfilter001
%
% Filter ADE index data to remove low frequency objects
% 
%% Syntax
% 
% filtered = frequencyfilter001(index, frequency)
% 
%% Description
% 
% Remove entries for low frequency objects based on the number of images
% the objects occur in
%
%% Example
%
%   filtered = frequencyfilter001(index, frequency);
% 
%% See also
% 
% * <file:ade032.html ade032>
% * <file:mergerepeats001.html mergerepeats001>
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com michaelfbonner.com> 


%% Function

function filtered = frequencyfilter001(index, frequency)

% Frequency: number of images object appears in
binaryPresence = index.objectPresence > 0;
imgCounts = sum(binaryPresence, 2);

% Filter by frequency
keep = imgCounts >= frequency;
filtered = index;
structFields = fieldnames(filtered);
nFields = length(structFields);
nObjs = length(filtered.objectnames);
for iFields = 1 : nFields

    % Field data
    structField = structFields{iFields};
    data = filtered.(structField);
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
    filtered.(structField) = data;
  
end  % for iFields = 1 : nFields


end  % function filtered = frequencyfilter001(index, frequency)
