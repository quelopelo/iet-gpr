function data = agcgain(data, windowSize, gainFactor)
%  AGCGAIN Applies an automatic gain control to the data.
%
% 	 data = IADGAIN2(data, windowSize, gainFactor) returns a matrix with
%    the B-Scan data after applying an automatic gain control filter. The
%    filter first estimates the mean energy of all the traces, then smooths
%    the curve using a moving window (see code), and lastly amplifies the
%    B-Scan based on the estimated amplitud decay function.
%
%    REQUIRED INPUT:
%    data           GPR B-Scan data (matrix)
% 
%    OPTIONAL INPUT:
%    windowSize     Number of data points for calculating the smoothed value,
%                   specified as an integer or as a scalar value in the range
%                   (0,1) denoting a fraction of the total number of data
%                   points (integer or real between 0 and 1)
%    gainFactor     Interpolation factor for amplification (real)
%
%    OUTPUT:
%    data           GPR B-Scan data after applying the gain (matrix)
%
%    See also: IADGAIN1, IADGAIN2, LINGAIN, EXPGAIN.
% 
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Defect value of windowSize and gainFactor
if nargin < 2 || isempty(windowSize)
    windowSize = 0.25;
end
if nargin < 3 || isempty(gainFactor)
    gainFactor = 1;
end

% Get the number of samples and construct an interpolation vector
n = size(data, 1);
u = linspace(0, 1, n)';

% Get the normalized mean amplitude of the signal
amp = abs(hilbert(data));
amp = mean(amp, 2);
amp = amp / mean(amp);

% Compute the filtered amplitude decay (automatic gain control)
agc = smooth(amp, windowSize, 'rlowess');

% Compute the independent term (d) so as to nullify the relationship
% between amp and the corrected agc
coef = @(a) linearcoef(u, amp ./ (agc + a^2));
a = fminsearch(coef, 0);
agc = agc + a^2;

% Apply the interpolation amplification factor
data = (1 - gainFactor) * data + gainFactor * data ./ agc;

end