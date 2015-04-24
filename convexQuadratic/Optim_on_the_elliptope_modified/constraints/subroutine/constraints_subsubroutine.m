function [R]=constraints_subsubroutine(x, V, lambda, signe, param)



id_im   = V*ones(1,size(x,2));%I_{im}
sum_x   = sum(x.*id_im);% \bar{Y} dans le rapport
T       = (x*sum_x');%Y*\bar{Y}'

R       = x_plus(signe.*(T-lambda),param.optim.epsilon);
