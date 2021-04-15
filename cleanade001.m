%% cleanade001
%
% Cleaned and filtered ADE20K index
% 
%% Syntax
% 
% cleanade001
% 
%% Description
% 
% Clean up ADE20K index file
% * merge entries for repeated object labels
% * merge entries for all labels associated with each experimental
% condition
% * filter objects by the number of images they appear in
% * simplify object names
%
%% Example
%
%   cleanade001;
% 
%% See also
% 
% * <file:ade007.html ade007>
% * <file:mergerepeats001.html mergerepeats001>
% * <file:mergeobjects001.html mergeobjects001>
% * <file:frequencyfilter001.html frequencyfilter001>
% * <file:simplifylabels001.html simplifylabels001>
% 
% Michael F. Bonner | University of Pennsylvania | <http://www.michaelfbonner.com michaelfbonner.com> 


%% Assign variables

% Output directory
outDir = fullfile('..', 'ADE20K_labels');
if ~exist(outDir, 'dir'); mkdir(outDir); end

% ADE20K objects-by-images matrix
file = fullfile('..', 'ADE20K', 'ADE20K_2016_07_26', 'index_ade20k.mat');
load(file, 'index');
index.objectnames{ismember(index.objectnames, 'hood')} = 'car hood';  % rename car 'hood' label to distinguish it from range 'hood'

% Conditions
conds = conditionarray();
nConds = length(conds);

% Condition associated labels
groups = labelgroups001();

% Objects-by-images parameters
MIN_IMGS = 1;  % remove objects that occur in fewer images than this



%% Preprocess

% Preprocess ADE20K index
merged = mergerepeats001(index);  % merge data for repeated object labels
merged = mergeobjects001(merged, groups);  % merge data for all object labels associated with each condition
filtered = frequencyfilter001(merged, MIN_IMGS);  % filter by object frequency
simplenames = simplifylabels001(filtered.objectnames);  % simplify object names
filtered.simplenames = simplenames;

% Save index
file = fullfile(outDir, 'filtered.mat');
save(file, 'filtered');

