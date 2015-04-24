#ifndef _NORM_ROWS_
#define _NORM_ROWS_



#include "mex.h"
#include <sstream>
#include "math.h"


using namespace std;


template <class T>
void wxyz(T *x, T *z, mwSize m, mwSize n)
{
 mwSize i,j,count1,count2=0;
 
    for (i=0; i<m; i++) {
         T d = 0;
         for (j=0; j<n; j++) {
            count1=m*j+i;
            d += *(x+count1) * *(x+count1);            
        }
         d = 1/sqrt(d);
         for (j=0; j<n; j++) {
             count2=m*j+i;
            *(z+count2)= d * *(x+count2);
        }
    }
}


template <class T>
void class_handler(mxArray *plhs[],const mxArray *prhs[],int ndims[])
{
    
    T* x = reinterpret_cast<T*>(mxGetPr(prhs[0]));
    
    T* z = reinterpret_cast<T*>(mxGetPr(plhs[0]));
           /*  call the C subroutine */
   wxyz(x,z,ndims[0],ndims[1]);
    
}




#endif