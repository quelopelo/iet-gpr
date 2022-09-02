function data = smoothscan(data, dataHeader, horScale, verScale)
%  SMOOTHSCAN Reduces the noise of a B-Scan.
% 
%    data = SMOOTHSCAN(data, dataHeader, horScale, verScale) returns a
%    matrix with the B-Scan after applying a noise reduction filter.
% 
%    REQUIRED INPUT:
%    data           GPR B-Scan data (matrix)
% 
%    OPTIONAL INPUT:
%    horScale       Horizontal window sizing parameter (real)
%    verScale       Vertical window sizing parameter (real)
% 
%    OUTPUT:
%    data           GPR B-Scan data after applying the noise reduction
%                   filter (matrix)
% 
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Defect value of horScale and verScale
if nargin < 3 || isempty(horScale)
    horScale = 1;
end
if nargin < 4 || isempty(verScale)
    verScale = 1;
end

% Define the size of the window
horWindowSize = 0.016;      % [m]
verWindowSize = 0.1;        % [ns]

% Calculate the size of the window in pixels
horWindowSize = max(round(horScale * horWindowSize * ...
                dataHeader.scansPerMeter), 1);
verWindowSize = max(round(verScale * verWindowSize / ...
                dataHeader.nanosecPerTrace * dataHeader.samplesPerTrace), 1);

% Filter the B-Scan using a MATLAB built-in function
data = wiener2(data, [verWindowSize horWindowSize]);

end