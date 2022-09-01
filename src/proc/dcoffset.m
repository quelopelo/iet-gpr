function data = dcoffset(data)
%  DCOFFSET Corrects the DC-offset of the B-Scan.
%
% 	 data = DCOFFSET(data) returns a matrix with the B-Scan data after
%    applying a DC-offset filter correction. The filter considers the last
%    half part of the signal and uses a linear weight funcion to give more
%    weight as the signal attenuation is greater (see code).
%
%    INPUT:
%    data           GPR B-Scan data (matrix)
%
%    OUTPUT:
%    data           GPR B-Scan data with the DC-offset correction (matrix)
%
%    See also: LINEAROFFSET.
%
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Calculate the mean 
midTrace = fix(size(data, 1) / 2);
weights = 1:1:midTrace;
meanArr = mean(data(end-midTrace+1:end, :), 2);
meanVal = weights * meanArr / sum(weights);

% Subtract the calculated mean to the B-scan
data = data - meanVal;

end