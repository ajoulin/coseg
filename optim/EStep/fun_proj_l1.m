
function z  = fun_proj_l1(z,param)  

[N K] =size(z);

% z =z./repmat(sum(z,2),1,K);
for n=1:N 
    z(n,:) = projection_on_l1_ball(z(n,:)')'; 
end;

if param.useMask
    z(sum(param.maskInd,2)==1,:) = param.maskInd(sum(param.maskInd,2)==1,:);
end
