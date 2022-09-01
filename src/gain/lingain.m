function data = lingain(data, linFactor)
%  LINGAIN Applies a linear gain to the data.
%
%    data = LINGAIN(data, linFactor) returns a matrix with the B-Scan data
%    after applying a linear gain filter. The filter modifies the data in
%    such a way that the first samples are not amplified and the last
%    samples are amplified by 'linFactor'. Thus, if linFactor == 1, the
%    filter does not modifies the data.
%
%    INPUT:
%    data           GPR B-Scan data (matrix)
%    linFactor      Factor for linear amplification (real)
%
%    OUTPUT:
%    data           GPR B-Scan data after applying the gain (matrix)
%
%    See also: EXPGAIN, AGCGAIN, IADGAIN1, IADGAIN2.
% 
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Get the number of samples of one trace
nTrace = size(data, 1);

% Calculate the gain vector and apply to data
gainVec = linspace(1, linFactor, nTrace);
data = data .* gainVec';

end