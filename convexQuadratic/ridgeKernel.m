function xtilde = ridgeKernel(x,lambda)

C = x * x' +  lambda * eye(size(x,1));
%C = xtilde * xtilde' +  n * lambda * eye(size(xtilde,1));

try
    C = chol(C);
catch
    % augment lambda if not positive enough and error is produced
    warning('lambda was augmented');
    keyboard
end
C = inv(C)';

xtilde = C * x;
clear C 



