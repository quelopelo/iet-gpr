function data = linearoffset(data)
%  LINEAROFFSET Corrects the linear-offset of the B-Scan.
%
% 	 data = LINEAROFFSET(data) returns a matrix with the B-Scan data after
%    applying a linear-offset filter correction. The filter considers the
%    first sample and the last half part of the signal (with a linear weight
%    funcion to give more weight as the signal attenuation is greater) to 
%    obtain the linear component to subtract.
%
%    INPUT:
%    data           GPR B-Scan data (matrix)
%
%    OUTPUT:
%    data           GPR B-Scan data with the linear-offset correction (matrix)
%
%    See also: DCOFFSET.
%
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Calculate the mean of the first line
meanVal1 = mean(data(1, :), 2);

% Calculate the mean of the last half lines
nTrace = size(data, 1);
midTrace = fix(nTrace / 2);
weights = 1:1:midTrace;
meanArr = mean(data(end-midTrace+1:end, :), 2);
meanVal2 = weights * meanArr / sum(weights);

% Get the linear component of the signal
meanVec = linspace(meanVal1, meanVal2, nTrace);

% Subtract the calculated mean to the B-scan
data = data - meanVec';

end