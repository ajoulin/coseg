function [descr, param] = openFeature(param)


if  ~isfield( param,'featFileList') || param.reboot
    [param,featEmptyFileList] =  createFeatFileList(param);
    
    if sum(featEmptyFileList(:))~=0
        generateAllFeatures(param,featEmptyFileList);
    end
    
end



fsift = cellfun(@(L) importdata(L), param.featFileList);


descr.data = double(cell2mat(convertData( {fsift(:).data}',3)));

descr.x =  convertData( {fsift(:).x},2);
descr.y =  convertData( {fsift(:).y},2);

param.lW_px = cellfun(@(L) firstSize(L,3) ,{fsift.data})';


%%%%%%%%%%%%%%%%%%%%%%%%% SUBFUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function z = convertData(y,d)
        z = cellfun(@(x) reshape(x, [firstSize(x,d), secondSize(x,d)]), y,'UniformOutput',0);
    end


    function sz = firstSize(x,d)
        sz = size(x,1) * ( (size(x,2) - 1) * (size(x,d)~=1) + 1);
    end

    function sz = secondSize(x,d)
        sz = numel(x) / firstSize(x,d) ;
    end


end



