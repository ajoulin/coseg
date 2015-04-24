# Cosegmentation
This is the code for:

*Discriminative Clustering for Image Co-segmentation
Armand Joulin, Francis Bach and Jean Ponce.
CVPR, 2010.
*Multi-Class Cosegmentation
Armand Joulin, Francis Bach and Jean Ponce.
CVPR, 2012.

Please these papers if you use this code (bibtex below).

## Requirements:

You need the vlfeat image toolbox by Andrea Vedaldi and Brian Fulkerson:
http://www.vlfeat.org/

You need Mark Schmidt's optimization toolbox:
http://www.di.ens.fr/~mschmidt/Software/minFunc.html

## Install:
run mexAll.m in MATLAB to compile all mex files

## Run it:
There are three examples:
*coseg_example.m : classical coseg example
*multicoseg_example.m : multiclass coseg example
*grabcut_example.m : grabcut example on single image (note that you can use it on multiple images)

## Import options:
*param.onlyDiffrac : To run the cvpr'10 alone 
*param.initDiffac : Initialize the cvpr'12 cod by the cvpr'10 one 
*param.useMask : to use boundingboxes (i.e. grabcut)

*typeFeat : either 'color' or 'sift'
*typeKernel : either 'chi2' or 'Hellsinger'

## Contact:
Please if you have questions or problems, contact:
armand.joulin at gmail.com

## Bibtex:
## Contact:
Please if you have questions or problems, contact:
armand.joulin at gmail.com

## Bibtex:
@InProceedings{JouBacPon12,
   title = "Multi-Class Cosegmentation",
   booktitle = "Proceedings of the Conference on Computer Vision and Pattern Recognition (CVPR)",
   author = "A. Joulin and F. Bach and J. Ponce",
   year = "2012"
}

@InProceedings{JouBacPonc10_cvpr,
   title = "Discriminative Clustering for Image Co-segmentation",
   booktitle = "Proceedings of the Conference on Computer Vision and Pattern Recognition (CVPR)",
   author = "A. Joulin and F. Bach and J. Ponce",
   year = "2010"
}
