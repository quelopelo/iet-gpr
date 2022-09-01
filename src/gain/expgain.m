function data = expgain(data, expFactor)
%  EXPGAIN Applies an exponential gain to the data.
%
%    data = EXPGAIN(data, expFactor) returns a matrix with the B-Scan data
%    after applying an exponential gain filter. The filter modifies the
%    data in such a way that the first samples are not amplified and the
%    last samples are amplified by exp(expFactor). Thus, if expFactor == 0,
%    the filter does not modifies the data.
%
%    INPUT:
%    data           GPR B-Scan data (matrix)
%    expFactor      Factor for exponential amplification (real)
%
%    OUTPUT:
%    data           GPR B-Scan data after applying the gain (matrix)
%
%    See also: LINGAIN, AGCGAIN, IADGAIN1, IADGAIN2.
% 
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Get the number of samples of one trace
nTrace = size(data, 1);

% Calculate the gain vector and apply to data
gainVec = exp(linspace(0, expFactor, nTrace));
data = data .* gainVec';

end