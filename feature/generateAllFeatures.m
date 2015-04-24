function generateAllFeatures(param, featEmptyFileList)

if nargin<2
    featEmptyFileList = ones(param.nPics,1);
end


for iFile = 1 : param.nPics
    if featEmptyFileList(iFile)==1
        text = sprintf(' %s feature for %s is computed...',  param.featType, param.imFileList{iFile});
        printMessage(text,0,mfilename,'w');
        generateFeature(param.imFileList{iFile}, param.featFileList{iFile},  param);
        printMessage('done');
    end
    
end