function [saft, saftHeader] = saftpost(saft, saftHeader, mirror)
%  SAFTOST Post-processes the results of the SAFT algorithm.
%
% 	 [saft, saftHeader] = SAFTPOST(saft, saftHeader, mirror) returns a
%    matrix (and a header) with the results of the SAFT process modified to
%    trim the data generated at the edges. If mirror == false, the function
%    only trims the edges; otherwise, if mirror == true, the funcion first
%    mirrors the edges and then crops them. This feature can be useful to
%    improve results on relatively uniform scans (without edge effects).
% 
%    REQUIRED INPUT:
%    saft           GPR SAFT data (matrix)
%    saftHeader     SAFT header info (struct)
% 
%    OPTIONAL INPUT:
%    mirror         Flag to control the behavior of the function (boolean)
% 
%    OUTPUT:
%    saft           GPR SAFT data (matrix)
%    saftHeader     SAFT header info (struct)
% 
%    See also: SAFTMAT1, SAFTMAT2, SAFTMATS, SAFTPROC.
% 
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Defect value of mirror
if nargin < 3 || isempty(mirror)
    mirror = false;
end

% Get the width of the original and the processed data
md = saftHeader.numOfTraces;
M = saftHeader.numOfColumns;
madd = (M - md) / 2;

% Mirror the ends of the signals (if mirror = true)
if mirror
    saft(:, madd+1:2*madd) = saft(:, madd+1:2*madd) + ...
                             flip(saft(:, 1:madd), 2);
    saft(:, md+1:md+madd) = saft(:, md+1:md+madd) + ...
                            flip(saft(:, md+madd+1:end), 2);
end

% Cut the sides of the SAFT data
saft = saft(:, madd+1:end-madd);

% Update the header information
saftHeader.startPosition = saftHeader.startPosition + ... 
                           madd / saftHeader.scansPerMeter;
saftHeader.numOfColumns = md;

end