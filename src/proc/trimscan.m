function [data, dataHeader] = trimscan(data, dataHeader, startPos, endPos)
%  TRIMSCAN Trims a B-Scan between two positions.
%
% 	 [data, dataHeader] = trimscan(data, dataHeader, startPos, endPos) returns
%    a matrix (and a header) with the B-Scan between 'startPos' and 'endPos'.
%    If the start position is not specified, 'startPos' is set equal to the
%    beginning of the scan. Similarly, if the final position is not specified, 
%    'endPos' is set equal to the end of the scan.
% 
%    REQUIRED INPUT:
%    data           GPR B-Scan data (matrix)
%    dataHeader     Header info (struct)
% 
%    OPTIONAL INPUT:
%    startPos       Starting position (real)
%    endPos         Ending position (real)
% 
%    OUTPUT:
%    data           GPR B-Scan data after trimming (matrix)
%    dataHeader     Updated header info (struct)
%
%    See also: RESIZESCAN.
% 
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Default value of startPos and endPos
if nargin < 3 || isempty(startPos)
    startPos = dataHeader.startPosition;
end
if nargin < 4 || isempty(endPos)
    endPos = startPos + dataHeader.numOfColumns / dataHeader.scansPerMeter;
end

% Get the first and last index
xs = (startPos - dataHeader.startPosition) * dataHeader.scansPerMeter;
xe = xs + (endPos - startPos) * dataHeader.scansPerMeter;
is = max(1, floor(xs));
ie = min(dataHeader.numOfColumns, ceil(xe));

% Trim the B-Scam
data = data(:, is:ie);

% Update the header information
dataHeader.startPosition = dataHeader.startPosition + ...
                           (is - 1) / dataHeader.scansPerMeter;
dataHeader.numOfColumns = size(data, 2);

end