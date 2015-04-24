function L = LaplacianMatrix(descr, param)
% EVALUTATE THE LAPLACIAN MATRIX
% when we use dense sifts on a gride.
% The output is the combination of the Laplacian matrices at different
% scales.


printMessage('Computing Laplacian matrix (mex file)....', 0 , mfilename, 'm');

I=cell(param.nPics,1);
J=cell(param.nPics,1);
V=cell(param.nPics,1);

if numel(param.featFileList) ~= numel(param.imFileList)
    printMessage('wrong number of features or images', 1 , mfilename, 'e');
end

iFeat=0; L_size = 0;
for iIm = 1 : numel(param.imFileList) 
    
    Im = param.imread( param.imFileList{iIm});

    iFeat   = iFeat + param.lW_px(iIm);
    
    L = LaplacianMatrixForOneImage(descr.x{iIm} ,descr.y{iIm}, Im);
    
    [I{iIm}, J{iIm}, V{iIm}] = find(L);
    
    I{iIm} = I{iIm} + L_size;
    J{iIm} = J{iIm} + L_size;
    L_size = L_size + size(L,1);
end

L = sparse(cell2mat(I),cell2mat(J),cell2mat(V),L_size,L_size);

printMessage('done');
