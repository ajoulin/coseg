function param = createImageFileList(param)


param.imFileList  = cell(1,param.nPics);


iFile=0;
for iObj =1 : param.nObj
    fileName = sprintf('%s*',param.path.pic{iObj});
    fileList = dir(fileName);
    
    fileList([fileList.isdir]==1)                       = [];
    fileList(cellfun(@(x) x(1)=='.',{fileList.name}))   = [];

    if isempty(fileList)
        printMessage( sprintf('No images in %s\n',param.path.pic{iObj}) , mfilename, 'e');
        param.listNPics(iObj) = numel(fileList);
        param.nPics = sum(param.listNPics(:));
        param.imFileList = param.imFileList(1:param.nPics);
        continue
    end
    
   
    
    if numel(fileList) < param.listNPics(iObj)
        printMessage(sprintf('Not enough images in %s nPics for %s is change to %i\n',param.path.pic{iObj},param.listObj{iObj},numel(fileList)), mfilename, 'w');
        param.listNPics(iObj) = numel(fileList);
        param.nPics = sum(param.listNPics(:));
        param.imFileList = param.imFileList(1:param.nPics);
    end
    
    fileList = cellfun( @(x) sprintf('%s%s',param.path.pic{iObj}, x),  {fileList(1: param.listNPics(iObj)).name}, 'UniformOutput', 0);
    param.imFileList(iFile+1:iFile+param.listNPics(iObj)) = fileList;
    
    iFile = iFile+param.listNPics(iObj);
end