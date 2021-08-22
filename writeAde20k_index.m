clear all
close all
clc
adefile = load('../index_ade20k.mat');
folder = [];
filename = [];
for i = 1 : length(adefile.index.filename)
    folder{i} = adefile.index.folder{i} ;
    filename{i}= adefile.index.filename{i};
end
T = table(folder',filename','VariableNames',{'folder','filename'});
writetable(T,'../ADE20K_labels/Ade20K_index')
