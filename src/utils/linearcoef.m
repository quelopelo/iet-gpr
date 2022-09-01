function coef = linearcoef(x, y)
%  LINEARCOEF Returns the square of the linear approximation coefficient.
%
% 	 coef = LINEARCOEF(x, y) returns the square linear coefficient of the
%    best fit (in a least-squares sense) of the form y = a*x + b.
%
%    INPUT:
%    x          	Query points (vector)
%    y              Fitted values at query points (vector)
%
%    OUTPUT:
%    coef           Least-squares fit linear coefficeint.
%
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

p = polyfit(x,y,1);
coef = p(1)^2;

end