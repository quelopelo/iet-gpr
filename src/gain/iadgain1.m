function data = iadgain1(data, gainFactor)
%  IADGAIN1 Applies an inverse amplitude decay to the data.
%
% 	 data = IADGAIN1(data, gainFactor) returns a matrix with the B-Scan
%    data after applying an inverse amplitude decay gain filter. The filter
%    first estimates the mean energy of all the traces, then fits the curve
%    y = a * exp(-b*x) + c, and lastly amplifies the B-Scan based on the
%    estimated amplitud decay function.
%
%    REQUIRED INPUT:
%    data           GPR B-Scan data (matrix)
% 
%    OPTIONAL INPUT:
%    gainFactor     Interpolation factor for amplification (real)
%
%    OUTPUT:
%    data           GPR B-Scan data after applying the gain (matrix)
%
%    See also: IADGAIN2, AGCGAIN, LINGAIN, EXPGAIN.
% 
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Defect value of gainFactor
if nargin < 2 || isempty(gainFactor)
    gainFactor = 1;
end

% Get the number of samples and construct an interpolation vector
n = size(data, 1);
u = linspace(0, 1, n)';

% Get the normalized mean amplitude of the signal
amp = abs(hilbert(data));
amp = mean(amp, 2);
amp = amp / mean(amp);

% Estimate the minumum, the maximum and its location
ymin = min(amp);
[ymax, xmax] = max(amp);
xmax = xmax / n;

% Get the initial parameters for the fit (start point values)
ao = ymin * (ymax/ymin) ^ (1/(1-xmax));
bo = log(ymax/ymin) / (1-xmax);

% Fit the curve y = a * exp(-b*x) to the amp vector
fo = fitoptions('Method','NonlinearLeastSquares', ...
               'Lower',[0 0], ...
               'Upper',[Inf Inf], ...
               'StartPoint', [ao bo]);
ft = fittype('a * exp(-b*x)', 'options',fo);
f = fit(u, amp, ft);
iac = f(u);

% Compute the independent term (c) so as to nullify the relationship
% between amp and the corrected iac
coef = @(c) linearcoef(u, amp ./ (iac + c^2));
c = fminsearch(coef, ymin);
iac = iac + c^2;

% Apply the interpolation amplification factor
data = (1 - gainFactor) * data + gainFactor * data ./ iac;

end