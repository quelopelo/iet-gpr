function data = removetrend(data, cvFactor)
%  REMOVETREND Removes the trend from a B-Scan.
% 
%    data = removetrend(data, cvFactor) returns a matrix with the B-Scan
%    after removing the trend of the data. The estimation of the trend is
%    done considering the mean and subtracting the standard deviation
%    multiplied by 'cvFactor' (see code). Thus, if cv == 0, the algorithm
%    subtracts the mean trace, while if cv -> Inf, the algorithm leaves the
%    data unchanged. By default, cvFactor is taken equal to 2.
% 
%    REQUIRED INPUT:
%    data           GPR B-Scan data (matrix)
% 
%    OPTIONAL INPUT:
%    cvFactor       Coefficient of variation factor (real or vector)
% 
%    OUTPUT:
%    data           GPR B-Scan data after removing the trend (matrix)
% 
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Defect value of cvFactor
if nargin < 2 || isempty(cvFactor)
    cvFactor = 2;
end

% Convert the specified factor as a single value to a vector
if length(cvFactor) == 1
    cvFactor = [cvFactor cvFactor];
end

% Compute two traces with the mean and the standard deviation
u = mean(data, 2);
s = std(data, 0, 2);

% Estimate the trend using the mean and the standard deviation
cvFactor = interp1(linspace(0, 1, length(cvFactor)), cvFactor, ...
                   linspace(0, 1, length(u)));
v = sign(u) .* max((abs(u) - cvFactor' .* s), 0);

% Remove the calculated trend from the data
data = data - v;

end