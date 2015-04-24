#ifndef _AUX_FCT_
#define _AUX_FCT_



#include "mex.h"
#include <sstream>
#include "math.h"

using namespace std;

template <class T>
void wxyz(T *w, T *x, T *y, T *z, mwSize m, mwSize n)
{
 mwSize i,j,count1,count2=0;
 
    for (i=0; i<m; i++) {
         T d = 0;
         for (j=0; j<n; j++) {
            count1=m*j+i;
            d += *(w+count1) * *(x+count1);            
        }
         for (j=0; j<n; j++) {
             count2=m*j+i;
            *(z+count2)= d * *(y+count2);
        }
    }
}

template <class T>
void class_handler(mxArray *plhs[],const mxArray *prhs[],int ndims[])
{
    
    T* w = reinterpret_cast<T*>(mxGetPr(prhs[0]));
    T* x = reinterpret_cast<T*>(mxGetPr(prhs[1]));
    T* y = reinterpret_cast<T*>(mxGetPr(prhs[2]));
    
    T* z = reinterpret_cast<T*>(mxGetPr(plhs[0]));
           /*  call the C subroutine */
   wxyz(w,x,y,z,ndims[0],ndims[1]);
    
}



#endif