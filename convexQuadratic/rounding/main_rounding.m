function [zz, z] = main_rounding(y,param,wght)


if param.nClass>2
    Y=y*y';
    Y=Y./2;
    Y=Y+1./2;
    
    [~,e,u]=svds(Y, param.nClass);
    
    e = e.^2;
    [~,b]=sort(-diag(e));
    
    un =u(:, b(1:param.nClass));
    en =e(b(1:param.nClass), b(1:param.nClass));
    
    un = Y * un * diag(1./sqrt(diag(en)));
    
    normalized = sqrt(sum(un.^2,2));
    un = un ./ repmat( normalized, 1, param.nClass);
    [z,~,~] = kmeans_restarts_1_0(un,param.nClass, 'weights',wght);
    
    
    zz = zeros(param.nClass,size(z,1));
    zz(z'+(0:size(z,1)-1)*param.nClass) = 1;
    zz = zz';
    z = zz;
   
else
    z = rounding_normalized_cut(y,param.nClass);
    zz= [z>0 , z<=0];
    
    z = z./2 + 1./2;
    z = [ z ,  1-z];
    z = max( z , 0 );
    z = min( z , 1 );

end
