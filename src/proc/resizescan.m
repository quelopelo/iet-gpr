function [data, dataHeader] = resizescan(data, dataHeader, horSize, verSize)
%  RESIZESCAN Resizes a B-Scan to the specified size.
%
% 	 [data, dataHeader] = RESIZESCAN(data, dataHeader, horSize, verSize)
%    returns a matrix (and a header) with the B-Scan resized to 'horSize'
%    (numOfColumns) by 'verSize' (samplesPerTrace).
% 
%    REQUIRED INPUT:
%    data           GPR B-Scan data (matrix)
%    dataHeader     Header info (struct)
% 
%    OPTIONAL INPUT:
%    horSize        Horizontal size (numOfColumns) in pixels (integer)
%    verSize        Vertical size (samplesPerTrace) in pixels (integer)
% 
%    OUTPUT:
%    data           GPR B-Scan data after resizing (matrix)
%    dataHeader     Updated header info (struct)
%
%    See also: TRIMSCAN.
% 
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Defect value of horSize and verSize
if nargin < 3 || isempty(horSize)
    horSize = dataHeader.numOfColumns;
end
if nargin < 4 || isempty(verSize)
    verSize = dataHeader.samplesPerTrace;
end

% Resizes the B-Scan using the image resize function implemented in MATLAB
data = imresize(data, [verSize,horSize]);

% Update the header information
dataHeader.samplesPerTrace = verSize;
dataHeader.scansPerMeter = dataHeader.scansPerMeter * ... 
                           horSize / dataHeader.numOfColumns;
dataHeader.numOfColumns = horSize;

end