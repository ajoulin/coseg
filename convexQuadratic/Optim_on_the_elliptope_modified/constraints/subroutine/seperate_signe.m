function [Rp,Rn]=seperate_signe(R)

Rp=R.*(R>0);

Rn=R.*(R<0);