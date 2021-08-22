clear all
close all
clc
% Cat Magri 2021
% Explorartive analysis of scene distribution across object categories

file = fullfile('..','ADE20K_labels', 'filtered.mat');
load(file, 'filtered');

% Conditions
conds = conditionarray();
nConds = length(conds);
% Objects-by-images matrix
op = filtered.objectPresence; 
simplenames = filtered.simplenames;

sceneList = unique(filtered.scene);

counter = 0;
condition = [];
filepath = [];
filename = [];

LeftOverScenes = nan(81,500);
OriginalScenes = nan(81,500);
CatScenes = nan(81,500);
PercentGood = nan(81,1);
TotalScenes = nan(81,1);
for iConds = 1 : nConds
    
    % Display progress
    disp([num2str(iConds) ' of ' num2str(nConds)])
    
    cond = conds{iConds};
    ind = ismember(simplenames, cond);
    imgInds = find(op(ind,:));
    nStim = length(imgInds);
    
    thisScenes = filtered.scene(imgInds); %scenes for this object category, and all images occurring with this object
    if sum(strcmp(thisScenes,'~not labeled'))
        thisScenes(strcmp(thisScenes,'~not labeled')) = [];
    end
    [thisScenes_unique, b, c]  = unique(thisScenes);    %Unique list of scenes for that object category
    totalOriginal = [];
    for i = 1:length(thisScenes_unique)
        
       totalOriginal(i) = sum(strcmp(filtered.scene,thisScenes_unique{i})) ;
    end
    
    totalCat = hist(c,length(thisScenes_unique));
    
    theseImgs = totalCat./totalOriginal; %get values
    PercentGood(iConds) = sum(theseImgs<=0.5)/length(theseImgs); %what percent of all scene categories have half or less of the total images with this object
    TotalScenes(iConds) = length(theseImgs);
    
    CatScenes(iConds,1:length(thisScenes_unique)) = totalCat;
    OriginalScenes(iConds,1:length(thisScenes_unique)) = totalOriginal;
    LeftOverScenes(iConds,1:length(thisScenes_unique)) = totalCat./totalOriginal; %percent of total images that contain object category
%     freqs_percent = totalCat/length(thisScenes);
%     [vals,idx] = sort(freqs_percent);
%     %given a scene category, how often does it contain this specific object
%     %category? -> Diagnosticity: given scene, how often
%     %given a scene, how often is this scene category present in it? -> if
%     %more than 10% ...
%     TopScenes = thisScenes_unique(idx(vals>0.10));
%     
end

%Plotting the number of scenes per category
barh(vals)
yticks(1:length(conds))
set(gca,'yticklabel',conds(idx))

%Which categories are problematic:
%Let's look at beacon
probobjects = find(PercentGood<0.7);
probobjects = conds{probobjects(4)};
IdxObject = find(strcmp(filtered.simplenames, probobjects)); %index in the filtered structure
%How many images contain a beacon?
AllImgs = find(op(IdxObject,:));
AllImgs_length = length(AllImgs);
AllImgs_scene = unique(filtered.scene(:,AllImgs)); %The scenes with a beaon are only coast, lighthouse and not labeled. 
Percent_of_Total = [] 
for iSc = 1:length(AllImgs_scene)
    AllScImgs_forObject =  sum(strcmp(filtered.scene(:,AllImgs),AllImgs_scene{iSc}));
    AllScImgs_forScene =  sum(strcmp(filtered.scene , AllImgs_scene{iSc}));
    Percent_of_Total(iSc) = AllScImgs_forObject/AllScImgs_forScene; %Only a very small part of coastimages has a beacon
end
%How many scenes in this category have half or less of its images
%containing a certain category
sum(Percent_of_Total<=0.5)

%COAST
AllScImgs_forObject =  sum(strcmp(filtered.scene(:,AllImgs),AllImgs_scene{1}));
AllScImgs_forScene =  sum(strcmp(filtered.scene , AllImgs_scene{1}));
Percent_of_Total = AllScImgs_forObject/AllScImgs_forScene; %Only a very small part of coastimages has a beacon

%LIGHTHOUSE
AllScImgs_forObject = sum(strcmp(filtered.scene(:,AllImgs),AllImgs_scene{2}));
AllScImgs_forScene = sum(strcmp(filtered.scene , AllImgs_scene{2}));
Percent_of_Total = AllScImgs_forObject/AllScImgs_forScene; %Only a very small part of coastimages has a beacon




