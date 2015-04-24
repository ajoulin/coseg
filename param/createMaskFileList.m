function param = createMaskFileList(param)



param.maskFileList  = cell(1,param.nPics);

iFile=1;

for iObj = 1:param.nObj
    for iIm = 1: param.listNPics(iObj)
        
        [~,fileName,~]      = fileparts(param.imFileList{iFile});
        param.maskFileList{iFile}    = sprintf('%s%s.mat',param.path.mask{iObj},fileName);
        
        iFile = iFile + 1;
    end
end

