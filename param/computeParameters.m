


param.nClass = nClass;

%%%%%%%%%%%%%%%%%%%%%%%%% OBJ + IMAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~iscell(typeObj)
    typeObj = {typeObj};
end

param.nObj = numel(typeObj);

%%% Number of images to load:
if ~exist('nPics','var')
    printMessage('only one image loaded', 1, mfilename,'w');
    nPics = 1;
end

if numel(nPics) == 1
    param.nPics = param.nObj * nPics;
    nPics = nPics .* ones(param.nObj, 1);
elseif numel(nPics) ~= param.nObj
    printMessage('Ambiguous number of images', 1, mfilename,'e');
    return
else
    param.nPics = sum(nPics(:));
end

param.listObj       = typeObj;
param.listNPics     = nPics;

param.picMaxSize    = 160;

%%%%%%%%%%%%%%%%%%%%%%%%% FEATURES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('typeFeat','var')
    typeFeat='sift';
end

if ~exist('patchSize','var') && strcmp(typeFeat,'color')
    patchSize = 2;
elseif ~exist('patchSize','var') 
    patchSize = 16;
end

if ~exist('gridSpacing','var') && strcmp(typeFeat,'sift')
    gridSpacing = 2;
elseif ~exist('gridSpacing','var')
    gridSpacing = 2;
end


param.featType      = typeFeat;
param.patchSize     = patchSize;
param.gridSpacing   = gridSpacing;

param.resolution    = 16;


%%%%%%%%%%%%%%%%%%%%%%%%% KERNEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

param.df             = 400;

if  ~exist('typeKernel','var')
     typeKernel = 'chi2';
else
    param.typeKernel = typeKernel;
end

if ~strcmp(param.typeKernel,'Hellinger') && ~strcmp(typeFeat,'colorSift')
    param.paramKernel         = .1;
elseif ~strcmp(param.typeKernel,'Hellinger')
    param.paramKernel         = 1e-3;
end

%%%%%%%%%%%%%%%%%%%%%%%%% REGULARIZATION %%%%%%%%%%%%%%%%%%%%%%%%

param.lambda = 1;

%%%%%%%%%%%%%%%%%%%%%%%%% BINARY TERM %%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('lapWght','var')
   lapWght          =.1;
end
param.lapWght       = lapWght;

%%%%%%%%%%%%%%%%%%%%%%%%% OPTIM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~exist('itMax','var')
   itMax          = 10;
end

param.itMax         = itMax;

if param.initDiffrac==1 || param.onlyDiffrac==1
    
    if ~exist('lambda0','var')
        lambda0 = 0.05;
    end
    
    param.optim.lambda0 = lambda0;
    param.optim.lambda_init= 1e-03;
    param.optim.beta=1.01;
    
    % smoothing =1 <=>  exp(1+log(-alpha*[.]))
    param.optim.smoothing=0;
    param.optim.alpha=.1;
    param.optim.epsilon=0;
end


%%%%%%%%%%%%%%%%%%%%%%%%% SUPERPIXELS %%%%%%%%%%%%%%%%%%%%%%%%%

%%%% you can either use superpixels or no.
if~exist('useSuperpix','var')
    useSuperpix = 1;
elseif ischar(useSuperpix)
    useSuperpix = str2double(useSuperpix);
end

param.useSuperpix  = useSuperpix;



%%%%%%%%%%%%%%%%%%%%%%%%% GRABCUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if  ~isfield(param,'useMask')
    if  ~exist('useMask','var')
        useMask = 0;
    elseif ischar(useMask)
        useMask = str2double(useMask);
    end
    
    param.useMask  = useMask;
end

if param.useMask==1
    param.onlyDiffrac   = 0;
    param.initDiffrac   = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%% TAGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('useTag','var')
    useTag = 0;
elseif ischar(useTag)
    useTag = str2double(useTag);
end

param.useTag  = useTag;


%%%%%%%%%%%%%%%%%%%%%%%%% PATH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

param.path.root         = './';

param.path.output       = [param.path.root,'output/',cell2mat(param.listObj),'/'];
sp_make_dir( param.path.output );

%where the images and descriptors are
im_path         = [param.path.root ,  'input/images/'];
data_path       = [param.path.root , 'input/descr/'];

param.path.pic  = cellfun( @(x) sprintf('%s%s/',im_path , x),   param.listObj, 'UniformOutput', 0);
param.path.feat = cellfun( @(x) sprintf('%s%s/',data_path , x), param.listObj, 'UniformOutput', 0);

if param.useSuperpix==1
    param.path.superpixel =  cellfun( @(x) sprintf('%ssuperpixel/',x), param.path.pic, 'UniformOutput', 0);
    cellfun(@(x) sp_make_dir(x), param.path.superpixel);
end

if param.useMask==1
    param.path.mask     =  cellfun( @(x) sprintf('%smask/',x), param.path.feat, 'UniformOutput', 0);
    cellfun(@(x) sp_make_dir(x), param.path.mask);
end

if param.useTag==1
    param.path.tag     =  cellfun( @(x) sprintf('%smask/',x), param.path.feat, 'UniformOutput', 0);
    cellfun(@(x) sp_make_dir(x), param.path.tag);
end

param.path.feat = cellfun( @(x) sprintf('%s%s/',x, param.featType), param.path.feat, 'UniformOutput', 0);
cellfun(@(x) sp_make_dir(x), param.path.feat);


%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

param.imresize  = @(I) min(max(imresize(I, param.picMaxSize ./ max(size(I,1) , size(I,2)) ),0),255);
param.imread    = @(imPath) param.imresize(imread(imPath));

if strcmp(param.typeKernel,'Hellsinger')
    funKernel   = @(X) featureHellinger(X);
else
    funKernel   = @(X) double(chi2Kernel(single(X)', single(param.paramKernel), param.df));
end


if strcmp(param.featType,'color')
    param.funFeat   = @(X) GenerateColorDescriptors(param.imread(X), param.patchSize, param.gridSpacing, param.resolution);
elseif strcmp(param.featType,'sift')
    param.funFeat   = @(X) dense_sift(param.imread(X), param.patchSize, param.gridSpacing);
elseif strcmp(param.featType,'colorSift')
    param.funFeat   = @(X)  run_colorDescriptor(X, param, '--detector densesampling  --descriptor csift');
else
    printMessage(sprintf('"%s" is not suported - change feature type to sift',param.featType), 1, mfilename,'w');
    param.featType  = 'sift';
    param.funFeat   = @(X) dense_sift(X, param.patchSize, param.gridSpacing);
end




%  vl_slic(supPixIm, 10, 500) + 1;
param.compSupPix    = @(imPath) vl_quickseg(param.imresize(single(imread( imPath))./255), .7, 2, 15);





