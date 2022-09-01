function [mats, m] = saftmats(dataHeader, relPerm, sep, antPattern)
%  SAFTMATS Returns a cell with the SAFT coefficients matrixes.
%
% 	 [mats, m] = saftmats(dataHeader, relPerm, sep, antPattern) returns a
%    cell with the SAFT coefficents matrixes correspondig to data with header
%    information 'dataHeader', relative permitivity relPerm, separation between
%    sender and receiver 'sep', and an antenna with pattern 'antPattern'.
%    Each cell 'k' contains a sparse matrix obtained by executing the
%    functions saftmat1(k, m, n, sx, sz, antPattern) or saftmat2(k, m, n,
%    sx, sz, sep, antPattern) with appropriate inputs (see code).
%
%    REQUIRED INPUT:
%    dataHeader     Header info (struct)
%    relPerm        Relative permittivity (real)
% 
%    OPTIONAL INPUT:
%    sep            Separation between sender and receiver (real)
%    antPattern     Pattern of the antenna, defined as an array of real
%                   numbers from an angle 0°, or perpendicular to the plane,
%                   to an angle 90°, or parallel to the plane (vector)
%
%    OUTPUT:
%    mats           SAFT coefficients (cell of sparse matrixes)
%    m              Horizontal size of the matrixes (integer)
%
%    See also: SAFTMAT1, SAFTMAT2, SAFTPROC, SAFTPOST.
%
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Defect value of sep and antPattern
if nargin < 3 || isempty(sep)
    sep = 0.085;        % Approximate value (m)
end
if nargin < 4 || isempty(antPattern)
    load antPattern antPattern;
end

% Get the number of samples and the size of the pixel
c = 299792458e-9;
depthPerTrace = c * dataHeader.nanosecPerTrace / (2 * sqrt(relPerm));
n = dataHeader.samplesPerTrace;
sx = 1 / dataHeader.scansPerMeter;
sz = depthPerTrace / n;

% Compute the SAFT coefficients cell of sparse matrixes
mats = cell(n, 1);
if sep <= 0
    % If sep == 0, use saftmat1(k, m, n, sx, sz, antPattern)
    m = ceil(n * sz / sx);
    for k = 1 : n
        mats{k} = saftmat1(k, m, n, sx, sz, antPattern);
    end
else
    % If sep > 0, use saftmat2(k, m, n, sx, sz, sep, antPattern)
    m = ceil(sqrt((sep/2)^2 + (n*sz)^2) / sx);
    for k = 1 : n
        mats{k} = saftmat2(k, m, n, sx, sz, sep, antPattern);
    end
end

end