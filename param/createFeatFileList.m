function [param,featEmptyFileList] = createFeatFileList(param)

if  ~isfield( param,'imFileList')  || param.reboot
   param=  createImageFileList(param);
end



param.featFileList  = cell(1,param.nPics);

featEmptyFileList = zeros(param.nPics,1);

iFile=1;
for iObj = 1:param.nObj
    for iIm = 1: param.listNPics(iObj)
        
        [~,fileName,~]      = fileparts(param.imFileList{iFile});
        param.featFileList{iFile}    = sprintf('%s%s.mat',param.path.feat{iObj},fileName);
        tmp = dir(param.featFileList{iFile});
        
        if isempty(tmp) || numel(tmp)>1  || param.reboot
            featEmptyFileList(iFile) = 1;
        end
        iFile = iFile + 1;
    end
end