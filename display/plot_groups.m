function plot_groups( param, labels, supPixIndices, nfig,titre)

color= [ ...
    [1  1  1];...
    [1 0 0];...
    [0 1 0];...
    [0 0 1];...
    [1 1 0];...
    [0 1 1];...
    [1 0 1];...
    [.5 0.5 0];...
    [0 1 1];...
    [1 0 1];...
    [0 0.5 .5];...
    [0.5 0 0];...
    [0.5 .5 .5];...
    ];


 labels = (labels==repmat(max(labels,[],2),1,param.nClass));


pos = 1;

sumlW = 0;oldFig =1;
for iIm = 1 : param.nPics
    
    image       = param.imread(param.imFileList{iIm});
    
    superPixIm  = importdata(param.supPixFileList{iIm});
    
    %     figure,imagesc(superPixIm)
    
    superPixIm(~ismember(superPixIm, supPixIndices{iIm})) = 0;
    
    labelsForImage = labels(sumlW + 1 : sumlW + numel(supPixIndices{iIm}),:);
    
    sumlW =  sumlW + numel(supPixIndices{iIm});
    
    imageClass = ones(size(superPixIm));
    
    for iClass = 1 : param.nClass
        imageClass(ismember(superPixIm, supPixIndices{iIm}(labelsForImage(:,iClass)==1) ) ) = iClass+1;
    end
    
    
   
    imagekk = imageClass;
    imageClass(imagekk(:,1:end-1)~=imagekk(:,2:end,:)) = 1;
    imagekk = imagekk';
    imageClass = imageClass';
    imageClass(imagekk(:,1:end-1)~=imagekk(:,2:end,:)) = 1;
    imageClass = imageClass';
    
     
     
    imageFinal = reshape(color(imageClass,:),[size(imageClass) 3]);
    
    imageFinal =  0.4*imageFinal + 0.6*double(image)./255;
    imageFinal = imageFinal.*repmat(imageClass~=1, [ 1 1 3]) + repmat(imageClass==1, [ 1 1 3]);
    
    
    i0 = mod(iIm,4)+4*(mod(iIm,4)==0);
    j0 = floor((iIm-1)/4);
    
    if j0~=oldFig
        oldFig=j0;
        set(gcf,'NextPlot','add');
        axes;
        h = title(titre);
        set(gca,'Visible','off');
        set(h,'Visible','on');
    end
    
    figure(nfig+j0)
    
    if i0==1
        clf
 
    end
    
    subplot(2,4,i0)
    imagesc( image );
    set(gca, 'YTick', [])
    set(gca, 'XTick', [])
    hold on
    
    subplot(2,4,i0+4)
    imagesc( imageFinal );
    set(gca, 'YTick', [])
    set(gca, 'XTick', [])
    hold on
end

        
set(gcf,'NextPlot','add');
axes;
h = title(titre);
set(gca,'Visible','off');
set(h,'Visible','on');

