groups = labelgroups001_cm();
index_dataset = load('../ADE20K/ADE20K_2016_07_26/index_ade20k');

original_index_col1 = {}
original_index_col2 = {}

for i = 1:size(groups,1)
    original_index_col1{i} = find(ismember(index_dataset.index.objectnames,groups{i,1}));
    original_index_col2{i} = find(ismember(index_dataset.index.objectnames,groups{i,2}));
end

original_index = {};
for i = 1:length(original_index_col1)
    original_index{i} = union(original_index_col1{i},original_index_col2{i})
end

newCellArray_Names = cell(81,3);
newCellArray_Index = cell(81,3);
for i =1: size(groups,1)
    for j=1:length(groups{i,2})
        newCellArray{i,j} = groups{i,2}{j};
    end  
end
for i =1: size(groups,1)
    for j=1:length(original_index{i})
        newCellArray_Index{i,j} = original_index{i}(j)
    end
end

T = cell2table([groups(:,1),newCellArray,newCellArray_Index],'VariableNames',{'Object' 'MoreNames1' 'MoreNames2' 'MoreNames3' 'MoreNames4' 'IndexName1' 'IndexName2' 'IndexName3' 'IndexName4'});
writetable(T,'../ADE20K_labels/saved_groups.csv')
%i manually change this to add "groups3,groups4,groups5" to header to be
%able to read it in pandas 