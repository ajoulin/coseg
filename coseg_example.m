% Show an example from MSRC database for cosegmentation

clear all
warning off

dirName = fileparts(mfilename('fullpath'));
addpath(genpath(dirName));
cd(dirName);


rand('seed',1);
randn('seed',1);

%%%% PARAMETERS

nPics               = 5; %nb of pics
nClass              = 2; % nb of class(es)

typeObj             ='face';

lapWght             = 1e-1; % binary paremeter (\mu in the article)

typeKernel          = 'chi2';% 'chi2' or 'Hellsinger'
typeFeat            = 'sift';% 'color' or 'sift'


param.onlyDiffrac   = 0; % if 1 , then only the CVPR'10
param.initDiffrac   = 1; % if 1,  init by CVPR'10

itMax               = 1; % nb of random init

param.reboot        = 1; % to recompute everything

param.ViewOn        = 1; % to look at results

param.useMask       = 0; % = 1 for grabcut



%%%% Run Coseg algorithm

run_coseg;



