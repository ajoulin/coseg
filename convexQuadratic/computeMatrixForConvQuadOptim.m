function C = computeMatrixForConvQuadOptim(param, xDif, lapMatrix, projMatrix)


C = projMatrix'*projMatrix - sum(projMatrix)'*sum(projMatrix)/param.nDescr - (xDif * projMatrix)' * xDif * projMatrix;


if size(lapMatrix,1) == size(C,1)
    C   = C + lapMatrix;
else
    C   = C + param.lapWght*(projMatrix'*lapMatrix*projMatrix);
end

C       = C ./ param.nDescr;

trC     = trace(C);
C       = C/trC;