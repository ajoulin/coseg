% This script solves the maximal cut SDP relaxation
%   min_X   Tr(A X)
%   s.t.    diag(X)=1
%           X'=X
%           X \succeq 0
%
% with A=-0.25 L, where L is the Laplacian of the graph of interest
%
% Reference: 
% M. Journ�e, F. Bach, P.-A. Absil and R. Sepulchre, Low-rank optimization for semidefinite convex problems, arXiv:0807.4423v1, 2008
%

clear all
% load 'toruspm3-8-50.mat' 
% c=c*50000;
% A=reshape(c,512,512);       
% n=512;

load 'torusg3-8.mat' 
c=c*0.5;
A=reshape(c,512,512);
n=512;
        
fun_set=@functions_elliptope;
fun_obj=@functions_max_cut;
param{1}=A;
y0=feval(fun_set,'retraction',randn(n,2),zeros(n,2),param);

[y,f]=low_rank_optim(fun_set,fun_obj,param,y0,'TR');
