function param = maskCreator(param)


examplar={};it_ex=0;
new_obj = 1;


if  ~isfield( param,'featFileList') || param.reboot
    param=  createImageFileList(param);
end

if  ~isfield(param, 'maskFileList') || param.reboot
    param=  createMaskFileList(param);
end

%%%% DELETE OLD MASKS

maskExist = 0;

for iFile = 1 : param.nPics
    if ~isempty(dir(param.maskFileList{iFile}))
        maskExist = 1;
    end
end

if maskExist
    maskDelete = input('Do you want to remove existing masks? y/n [n]','s');
    if strcmp(maskDelete,'y')
        for iFile = 1 : param.nPics
            if ~isempty(dir(param.maskFileList{iFile}))
                delete(param.maskFileList{iFile}) ;
            end
        end
    end
end


%%% MASK CREATION

for iFile = 1 : param.nPics
    im = param.imread(param.imFileList{iFile});
    figure(1),clf
    imagesc(im)
    
    
    
    if ~isempty(dir(param.maskFileList{iFile}))
        contBool = input(sprintf('A mask for image %s already exist. Do you want to overwrite it? y/n [n])',param.maskFileList{iFile}),'s');
        if ~strcmp(contBool,'y')
            askCont = input('Do you want to annotate another image? y/n [n]','s');
            if ~strcmp(askCont,'y')
                break
            end
            continue;
        end
    end
    
    nbObjInIm = 0;
        
    allRectInIm = [];
    
    
    
    
    if ~exist('contBool','var')
        askAnot = input('Do you want to annotate this image ? y/n [n] : ','s');
    else
        askAnot = contBool;
    end
    
    
    if ~strcmp(askAnot,'y')
        askCont = input('Do you want to annotate another image? y/n [n]','s');
        
        if ~strcmp(askCont,'y')
            break
        end
        continue;
    end
    
    for it = 1:it_ex
        nbObjInIm = it;
        figure(100),clf
        imagesc(examplar{it})
        
        remainOldObj = input('Is there a similar object as in fig 100, in this image? y/n [n] : ','s');
        
        if  strcmp(remainOldObj , 'y')
            
            figure(1)
            sameObj = 'y';
            while strcmp(sameObj , 'y')
                fprintf('crop the type of object (if none, press : ESC)\n')
                [~ , rect] = imcrop(im);
                rect = round(rect);
                rect = [rect , nbObjInIm];
                allRectInIm = [allRectInIm;rect];
                sameObj = input('Is there a similar object in this image? y/n [n] : ','s');
                
            end
        end
    end
    
    if iFile == 1
        remainNewObj = 'y';
    else
        remainNewObj = input('Is there another NEW object in this image? y/n [n] : ','s');
    end
    
    while strcmp(remainNewObj , 'y')
        new_obj = 1;
        nbObjInIm = nbObjInIm + 1;
        
        sameObj = 'y';
        
        while strcmp(sameObj , 'y')
            fprintf('crop the type of object (if none, press :  ESC)\n')
            [tmp , rect] = imcrop(im);
            rect = round(rect);
            rect = [rect , nbObjInIm];
            
            
            if new_obj == 1
                it_ex = it_ex+1;
                examplar{it_ex} = tmp;
                new_obj = 0;
            end
            
            allRectInIm = [allRectInIm;rect];
            
            sameObj = input('Is there a similar object in this image? y/n [n]','s');
            
        end
        remainNewObj = input('Is there another NEW object in this image? y/n [n]','s');
    end
    
    if ~isempty(allRectInIm)
        save(param.maskFileList{iFile} , 'allRectInIm');
    end
    askCont = input('Do you want to annotate another image? y/n [n]','s');
    
    if ~strcmp(askCont,'y')
        break
    end
    
end
end

