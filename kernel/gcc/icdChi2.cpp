// mex icdChi2.cpp

#include "mex.h"
#include <iostream>
#include <math.h>
#include "mexOliUtil.h"

#ifdef _MSC_VER
    typedef __declspec(align(16)) float _myfloat4[4];
#else
    typedef float _myfloat4 __attribute__((vector_size(16)));
#endif

typedef union myfloat4 {
    _myfloat4 v;
    float f[4];
} myfloat4;



void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
    
    enum{ 
        featurei,
        lambdai,
        toli,
        nFeatMaxi};
    
    enum{
        approxMapi,
        assigni,
        nFeati};
        
        oliCheckArgNumber(nrhs, 4, nlhs, 3);
        
        int nDim, nFeat;
        
        float* feature   = (float*)oliCheckArg(prhs, featurei, &nDim, &nFeat, oliSingle);
        float  lambda    = (*(float*) oliCheckArg(prhs, lambdai, 1, 1, oliSingle));
        float  tol       = (*(float*) oliCheckArg(prhs, toli, 1, 1, oliSingle));
        int    nFeatMax  = *((int*) oliCheckArg(prhs, nFeatMaxi, 1, 1, oliInt));
        
        int nPad = (nFeat % 4 == 0) ? nFeat : nFeat + 4 - nFeat % 4;
        
        
        plhs[approxMapi]  = mxCreateNumericMatrix(nPad, nFeatMax, mxSINGLE_CLASS, mxREAL); // WARNING : CHECK SIZE
        float* approxMap =(float*) mxGetPr(plhs[approxMapi]);
        
        //////////////// INIT ////////////////
        
        int     iFeat, 
                jFeat, 
                iDim;       
        
        int *permIndices;
        permIndices = (int*) calloc (nFeat, sizeof(int));
        
        for (iFeat = 0; iFeat < nFeat; iFeat++)
            permIndices[iFeat] = iFeat;
        
       
        int     nFeatSelected   = 0,
                lastFeat        = 0,
                tmpIdx; 
        
        float  tmpNum;
        float  tmpDen, 
                maxdiagG,
                chiDist,
                diagKernel    = 1,
                diagApproxMap = 1,
                residual      = nFeat;
        
        
        float *bufVal;
        bufVal = (float*)mxCalloc(nPad, sizeof(float));
                
        while( residual > tol &&  nFeatSelected < nFeatMax )
        {
            /* switches already calculated elements of G and order in permIndices */
            
            if (lastFeat != nFeatSelected)
            {
                tmpIdx                       = permIndices[lastFeat];
                permIndices[lastFeat]        = permIndices[nFeatSelected];
                permIndices[nFeatSelected]   = tmpIdx;
                
                for (iFeat = 0; iFeat <= nFeatSelected; iFeat++) {
                    tmpNum                                   = approxMap[lastFeat + nPad * iFeat];
                    approxMap[lastFeat + nPad * iFeat]      = approxMap[nFeatSelected + nPad * iFeat];
                    approxMap[nFeatSelected + nPad * iFeat] = tmpNum;
                }

            }
            
            //// Compute Kernel coefficient
            
             approxMap[ nFeatSelected * (nPad + 1) ] = sqrt(diagApproxMap);
           
             for (iFeat = nFeatSelected + 1; iFeat<= nFeat-1; iFeat++) {
                 
                 chiDist = 0;
                 
                 for (iDim = 0;  iDim <= nDim - 1; iDim ++) {
                     tmpDen  = feature[ iDim + nDim * permIndices[nFeatSelected]] + feature[ iDim + nDim * permIndices[iFeat] ];
                     if (tmpDen!=0) {
                         tmpNum  = tmpDen - 2 * feature[ iDim + nDim * permIndices[iFeat] ];
                         chiDist += (tmpNum * tmpNum) / tmpDen;
                     }
                 }
                 approxMap[ iFeat + nFeatSelected * nPad ] = exp( - lambda * chiDist );
             }
            tmpDen = 1. / approxMap[nFeatSelected * (nPad + 1)];
             
            
            int stopAt = nFeatSelected + 1  + ( (nFeatSelected + 1) % 4 == 0 ? 0 : 4 - ((nFeatSelected + 1) % 4));
            stopAt = (stopAt > nFeat)? nFeat : stopAt;
            
            
            for (jFeat = 0; jFeat <= nFeatSelected - 1; jFeat++)
            {
                tmpNum = approxMap[ nFeatSelected + jFeat * nPad];
                
                for (iFeat = nFeatSelected + 1; iFeat < stopAt; iFeat ++) 
                    approxMap[ iFeat + nFeatSelected * nPad ] -= approxMap[ iFeat + jFeat * nPad] * tmpNum;
                
                myfloat4* approxMap4i       = (myfloat4*)(approxMap + stopAt + nFeatSelected * nPad );
                myfloat4* approxMap4ij      = (myfloat4*)(approxMap + stopAt + jFeat * nPad);
                myfloat4  tmpNum4;
                tmpNum4.f[0] = tmpNum4.f[1] =  tmpNum4.f[2] = tmpNum4.f[3] = tmpNum;
                
                for(iFeat = 0; iFeat < (nPad - stopAt) / 4; iFeat++, approxMap4i++, approxMap4ij++)
                    approxMap4i->v -= approxMap4ij->v * tmpNum4.v;
                
            }
            
            for (iFeat = nFeatSelected + 1; iFeat <= nFeat-1; iFeat ++)
                approxMap[ iFeat + nFeatSelected * nPad] *= tmpDen;
            
            lastFeat = nFeatSelected + 1;
            
            
            /////////////////// Compute residual + additional point.
            maxdiagG = 0;
            residual = 0;
            
            std::fill(bufVal,bufVal + nFeat, 1);
            
            
            
            for (jFeat = 0; jFeat <= nFeatSelected; jFeat++) {
                              
                for (iFeat = nFeatSelected + 1; iFeat < stopAt; iFeat ++) 
                    bufVal[iFeat] -= approxMap[iFeat + jFeat * nPad] * approxMap[iFeat + jFeat * nPad];
                
                myfloat4* bufVal4    = (myfloat4*)(bufVal + stopAt);
                myfloat4* approxMap4 = (myfloat4*)(approxMap + stopAt + jFeat * nPad);
                
                
                for(iFeat = 0; iFeat < (nPad - stopAt) / 4; iFeat++, bufVal4++, approxMap4++)
                    bufVal4->v -= approxMap4->v * approxMap4->v;
            }
             
            
            
            
            
            for (iFeat = nFeatSelected + 1; iFeat < nFeat; iFeat ++) {
                tmpNum = bufVal[iFeat];
                if ( tmpNum > maxdiagG) {
                    lastFeat = iFeat;
                    maxdiagG = tmpNum;
                }
                residual += tmpNum;
            }

            diagApproxMap = maxdiagG;
            nFeatSelected ++;
            
            
        }
        
        plhs[assigni]    = mxCreateDoubleMatrix(1, nFeat, mxREAL); 
        double* assign   = mxGetPr(plhs[assigni]);
        
        for (iFeat = 0; iFeat <= nFeat-1; iFeat++) 
            assign[iFeat] = 1 + permIndices[iFeat];
        
        
        plhs[nFeati]     = mxCreateDoubleMatrix(1, 1, mxREAL); 
        double* nFeatEnd = mxGetPr(plhs[nFeati]);        
        nFeatEnd[0]      = nFeatSelected;
        
        mxFree(permIndices);
        
        
}



