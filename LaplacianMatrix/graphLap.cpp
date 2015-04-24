#include "math.h"

#define MAX(a,b) (((a)>(b))?(a):(b))
#define MIN(a,b) (((a)<(b))?(a):(b))

#include <iostream>

#include <mex.h>

using namespace std;


int computeK( double***& featureIn, int widthImage,
 int heightImage, int nbrFeature,
 int zone, int nnz,
 double*& valMatrixKOut,
 double*& iMatrixKOut, double*& jMatrixKOut)
{
 int compt=0;
 int nNode=0;
 const double threshold=0;
 double k;
 if(nnz!=-1)
 {
   //valMatrixKOut = new double[nnz];
   //iMatrixKOut = new double[nnz];
   //jMatrixKOut = new double[nnz];
 }
 for(int x1=0;x1<widthImage;x1++)
   for(int y1=0;y1<heightImage;y1++)
   {
       
       for(int x2=MAX(0,x1-zone);x2<=MIN(widthImage-1,x1+zone);x2++)
           for(int y2=MAX(0,y1-zone);y2<=MIN(heightImage-1,y1+zone);y2++)
       {
           if(x2==x1 && y2==y1)
               continue;
           
           double sum=0;
           for(int f=0;f<nbrFeature;f++)
               sum+=(featureIn[x1][y1][f]-featureIn[x2][y2][f])*(featureIn[x1][y1][f]-featureIn[x2][y2][f]);
               //sum+=MIN(featureIn[x1][y1][f],featureIn[x2][y2][f]);
           k=exp(-sum);
           //k=sum/3;
           if(k>0)//threshold)
           {
               if(nnz!=-1)
               {
                   valMatrixKOut[compt]=k;
                   iMatrixKOut[compt]=x1+y1*widthImage;
                   jMatrixKOut[compt]=x2+y2*widthImage;
               }
               compt++;
           }
           
        }
       
   }
 return compt;
}


int computeGraphLap(double***& featureIn, int nNode,int
widthImage,int heightImage,int nbrFeature,
 int zone,
  double* iMatrixK,
 double* jMatrixK,
  double* valMatrixK,
  mxArray*& plhs0,
  mxArray*& plhs1,
  mxArray*& plhs2
)
{
 double* matrixD=NULL;
 int nnz;
 nnz=computeK(featureIn,widthImage,heightImage,nbrFeature,zone,-1,valMatrixK,iMatrixK,jMatrixK);
 plhs0 = mxCreateDoubleMatrix(nnz,1,mxREAL);
 iMatrixK  = mxGetPr(plhs0);
 
 plhs1 = mxCreateDoubleMatrix(nnz,1,mxREAL);
 jMatrixK  = mxGetPr(plhs1);
 
 plhs2 = mxCreateDoubleMatrix(nnz,1,mxREAL);
 valMatrixK  = mxGetPr(plhs2);
 
 //iMatrixK = mxGetIr(plhs);
 //jMatrixK = mxGetJc(plhs);
 //mexPrintf(" hh %i %i %i\n", sizeof(size_t),sizeof(double),sizeof(mwIndex));
 computeK(featureIn,widthImage,heightImage,nbrFeature,zone,nnz,valMatrixK,iMatrixK,jMatrixK);
 return nnz;
}




int getFeature(double***& featureOut,double* image, int& widthImage,
int& heightImage,
double gammaC,double gammaG, int nbrFeature)
{
    
    //IplImage* image = cvLoadImage("image.bmp");
    //IplImage* imageMask = cvLoadImage("imageMask.bmp");
    
    //widthImage=image->width;
    //heightImage=image->height;
    
    //int widthImage=image->width;
    //int heightImage=image->height;
    int nNode=0;
    
    featureOut = new double**[widthImage];
    
    
    for(int x=0;x<widthImage;x++)
    {
        featureOut[x] = new double*[heightImage];
        for(int y=0;y<heightImage;y++)
        {
            featureOut[x][y] = new double[nbrFeature];
            featureOut[x][y][0] = gammaC*image[x+y*widthImage];
            featureOut[x][y][1] = gammaC*image[x+y*widthImage+heightImage*widthImage];
            featureOut[x][y][2] = gammaC*image[x+y*widthImage+2*heightImage*widthImage];
            featureOut[x][y][3] = gammaG*x;
            featureOut[x][y][4] = gammaG*y;
            nNode++;
        }
    }
    
    return nNode;
}



void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
 enum {IMAGE=0, ZONE};
 
 double* image;
 
 image=mxGetPr(prhs[IMAGE]);// contient les RGB
 
 
 
 
 int imageHeight=mxGetM(prhs[IMAGE]);
 int imageWidth=mxGetN(prhs[IMAGE])/3;
 
 int swapVal = imageWidth;
 imageWidth = imageHeight;
 imageHeight = swapVal;
 
 //return;
 double*** feature;
// int imageWidth,imageHeight;

 int zone=int(*mxGetPr(prhs[ZONE]));
 
 double gammaC=.05;//sqrt(1.*log(10)/(30*30));
 double gammaG=.001;//sqrt(1./((zone+1)*(zone+1))*log(10));
 
 int nbrFeature=5;// x,y, R,G,B
 int nNode;
 
 //mexPrintf("getting feature...\n");
 nNode=getFeature(feature,image,imageWidth,imageHeight,gammaC,gammaG,nbrFeature);
 
 
 //mexPrintf("computing Graph Laplacian...\n");
 int nnz;
 double* iMatrix;
 double* jMatrix;
 double* valMatrix;
 nnz=computeGraphLap(feature,nNode,imageWidth,imageHeight,nbrFeature,zone,iMatrix,jMatrix,valMatrix,plhs[0],plhs[1],plhs[2]);

}











