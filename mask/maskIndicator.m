function [param] = maskIndicator(param,descr)

mask_pos = cell(param.nPics, 1);

K_mask =0;

if ~isfield(param, 'maskFileList')
    param=  createMaskFileList(param);
end

% Number of object below a mask: 
for i = 1 : param.nPics
    if isempty(dir(param.maskFileList{i}))
        continue
    end
    
    tmp = importdata(param.maskFileList{i});
    
    if isempty(tmp)
        continue
    end
    
    if K_mask < max(tmp(:,end))
        K_mask = max(tmp(:,end));
    end
    
    mask_pos{i} =  tmp;
    
end

param.nClass = max(param.nClass ,  K_mask+1);

param.maskInd = zeros(param.nDescr, param.nClass);

param.maskInd(:,K_mask+1:end) = 1;

indIm = [0;cumsum(param.lW_px)];

for i = 1 : param.nPics
    
    if isempty( mask_pos{i} )
        param.maskInd ( indIm(i)+1 : indIm(i+1) , : ) =1;
        continue
    end
    
    for m = 1 : size(mask_pos{i},1)
        
        indice = find( ...
            (descr.x{i}(:) > mask_pos{i}(m,1)) .* (descr.x{i}(:)  < mask_pos{i}(m,1)+mask_pos{i}(m,3)).*...
            (descr.y{i}(:)  > mask_pos{i}(m,2)) .* (descr.y{i}(:) < mask_pos{i}(m,2)+mask_pos{i}(m,4)) );
        param.maskInd(indIm(i)+indice,mask_pos{i}(m,5))=1;
        
    end
end

