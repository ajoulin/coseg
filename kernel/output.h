#include <stdlib.h>
#include "timer.h"

#ifdef MEX
#include "mex.h"

#define myprintf          mexPrintf
#define myerror(str)      mexErrMsgTxt(str)
#define mywarning(str)    mexWarnMsgTxt(str)
#define myassert(expr)    mxAssert(expr, "Assertion failed:\n");

#else

#include <stdio.h>
#include <assert.h>
#define myprintf          printf
#define myerror(str)      {fprintf(stderr, "%s:%d: ", __FILE__, __LINE__); fprintf(stderr, str); exit(1);}
#define mywarning(str)    printf("WARNING: %s\n", str)
#define myassert(expr)    assert(expr)

#endif

