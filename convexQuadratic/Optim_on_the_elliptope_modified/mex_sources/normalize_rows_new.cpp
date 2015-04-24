#include "mex.h"

#include "normalize_rows_new.h"

#include "math.h"


/* the gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  
  mwSize mrows,ncols;
  
  /*  check for proper number of arguments */
  /* NOTE: You do not need an else statement when using mexErrMsgTxt
     within an if statement, because it will never get to the else
     statement if mexErrMsgTxt is executed. (mexErrMsgTxt breaks you out of
     the MEX-file) */
  
  /*  get the dimensions of the matrix input y */
  int ndim=2;
  int ndims[2];
  ndims[0] =static_cast<int>( mxGetM(prhs[0]));
  ndims[1] = static_cast<int>(mxGetN(prhs[0]));
  
  /*  set the output pointer to the output matrix */
  //plhs[0] = mxCreateDoubleMatrix(mrows,ncols, mxREAL);
  plhs[0] = mxCreateNumericArray  (ndim,ndims,mxGetClassID(prhs[0]),mxREAL);
  
  
  /*  create a pointer to the input matrix y */
  
  if (mxGetClassID(prhs[0]) == mxDOUBLE_CLASS)
  {
      class_handler<double>(plhs,prhs,ndims);
  }
  else
  {
    class_handler<float>(plhs,prhs,ndims);
  }
        

  

  
}
