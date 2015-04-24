function decision = condition_ARMIJO(f,f_proj,x,x_proj,gradient,param)

decision=( f_proj - f  <=  param.sigma_ * gradient(:)' * ( x_proj(:) - x(:) ));