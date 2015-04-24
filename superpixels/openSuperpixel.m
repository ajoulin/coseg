function [projMatrix, supPixIndices, param] = openSuperpixel(descr, param)


subSupPixIm             = cell(numel(param.imFileList),1);
param.supPixFileList    =  cell(numel(param.imFileList),1);
supPixIndices  = cell(numel(param.imFileList),1);

printMessage('Open superpixels files...', 0 , mfilename, 'm');

indPt = 0;
createSP = 0;


for iIm = 1:numel(param.imFileList)
    
    [pathIm, fileName, ~] = fileparts(param.imFileList{iIm});
    
    %imFileName =
    %['/scratch/joulin/data/Images/face/superpixel/face_00',num2str(iIm),'_nb05_Seg.mat'];
    
    imFileName = [pathIm, '/superpixel/',fileName,'.mat'];
    
    %%%%% LOAD SUPERPIXELS
    if isempty(dir(imFileName))  || param.reboot
        if iIm == 1
            fprintf('\n')
        end
        createSP = 1;
        printMessage(sprintf('compute superpixels for image : %s ...',param.imFileList{iIm}), 0, mfilename,'w');
        supPixIm    = param.compSupPix(param.imFileList{iIm});
        save(imFileName,'supPixIm');
        printMessage('done');
    else
        supPixIm = importdata(imFileName);
    end
    
    param.supPixFileList {iIm} = imFileName;
    
    supPixIndices{iIm} = supPixIm( descr.y{iIm} + size(supPixIm,1) * (descr.x{iIm}-1) ) ;
    
    subSupPixIm{iIm}  = indPt + supPixIndices{iIm} ;
    
    indPt = indPt + numel(unique(supPixIm(:)));
    
end


param.lW_supPix     = cellfun(@(x) numel(unique(x)), subSupPixIm);
param.nSupPix       = sum(param.lW_supPix);

supPixIndices       = cellfun(@(x) unique(x), supPixIndices,'uniformOutput', 0);

subSupPixIm         = double(cell2mat (subSupPixIm));
projMatrix          = sparse( (1 : numel(subSupPixIm))', subSupPixIm(:), 1 , numel(subSupPixIm), max(subSupPixIm(:)));


projMatrix(:,sum(projMatrix,1)==0) = [];
if createSP ==1
    printMessage('Open superpixels files...done', 1 , mfilename, 'm');
else
    printMessage('done');
end