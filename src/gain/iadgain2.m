function data = iadgain2(data, gainFactor)
%  IADGAIN2 Applies an inverse amplitude decay to the data.
%
% 	 data = IADGAIN2(data, gainFactor) returns a matrix with the B-Scan
%    data after applying an inverse amplitude decay gain filter. The filter
%    first estimates the mean energy of all the traces, then fits the curve
%    y = a * (b*x/(1+b*x)) * exp(-c*x) + d, and lastly amplifies the B-Scan
%    based on the estimated amplitud decay function.
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
%    See also: IADGAIN1, AGCGAIN, LINGAIN, EXPGAIN.
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
co = log(ymax/ymin) / (1-xmax);
bo = (1 - co*xmax) / (co*xmax^2);
ao = (exp(co + co*xmax) * (1 - co*(1-xmax)*xmax) * (ymax-ymin)) / ...
     ((1 - co*xmax) * (exp(co) * (1 - co*(1-xmax)*xmax) - exp(co*xmax)));

% Fit the curve y = a * (b*x/(1+b*x)) * exp(-c*x) to the amp vector
fo = fitoptions('Method','NonlinearLeastSquares', ...
               'Lower',[0 0 0], ...
               'Upper',[Inf Inf Inf], ...
               'StartPoint', [ao bo co]);
ft = fittype('a * (b*x/(1+b*x)) * exp(-c*x)', 'options',fo);
f = fit(u, amp, ft);
iac = f(u);

% Compute the independent term (d) so as to nullify the relationship
% between amp and the corrected iac
coef = @(d) linearcoef(u, amp ./ (iac + d^2));
d = fminsearch(coef, ymin);
iac = iac + d^2;

% Apply the interpolation amplification factor
data = (1 - gainFactor) * data + gainFactor * data ./ iac;

end