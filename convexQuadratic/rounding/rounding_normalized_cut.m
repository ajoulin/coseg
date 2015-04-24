function z=rounding_normalized_cut(y,K)



N=y*y';
N=N./2;
N=N+1./2;

d=1./(sum(N,2).^.5);
D=sparse(1:size(d,1),1:size(d,1),d);
clear d

N=D*N*D;
clear D

N=sparse((1:size(N,1))',(1:size(N,1))',1)-N;

[V,E]=eigs(N,K,'SR');



clear N
z=V(:,2:K);
