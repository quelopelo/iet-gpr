function mat = saftmat1(k, m, n, sx, sz, antPattern)
%  SAFTMAT1 Returns the SAFT coefficients matrix corresponding to index 'k',
%  considering a null separation between the sender and the receiver.
%
% 	 mat = SAFTMAT1(k, m, n, sx, sz, antPattern) returns a matrix with the
%    SAFT coefficentes corresponding to index (or position) 'k', horizontal
%    size (or number of traces) 'm', vertical size (or number of samples)'n', 
%    pixel sizes 'sx' and 'sz', and an antenna with pattern 'antPattern'.
%    This function assumes, in a simplified way, that the transmitting and
%    receiving antenna are located at the same point.
%
%    REQUIRED INPUT:
%    k              Index or position (integer between 1 and n)
%    m              Horizontal size of the matrix (integer)
%    n              Vertical size of the matrix (integer)
%    sx             Horizontal size of a pixel (real)
%    sz             Vertical size of a pixel (real)
% 
%    OPTIONAL INPUT:
%    antPattern     Pattern of the antenna, defined as an array of real
%                   numbers from an angle 0°, or perpendicular to the plane,
%                   to an angle 90°, or parallel to the plane (vector)
%
%    OUTPUT:
%    mat            SAFT matrix coefficients corresponding to index k, where
%                   the first column corresponds to the column of the SAFT
%                   matrix, the second column corresponds to the row of the
%                   SAFT matrix, and the last column correspond to the SAFT
%                   coefficient (sparse matrix)
%
%    See also: SAFTMAT2, SAFTMATS, SAFTPROC, SAFTPOST.
%
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Defect value of antPattern
if nargin < 5 || isempty(antPattern)
    load antPattern antPattern;
end

% Define the vector of angles relative to antPattern
angVec = linspace(0, pi/2, length(antPattern));
% Get the distance relative to index k
dk = (k - 0.5) * sz;

% Compute the SAFT coefficients matrix
nonZeroEst = ceil(1.1 * pi * k * sz / sx);
mVec = zeros(nonZeroEst, 1);
nVec = mVec;
cVec = mVec;
ind = 1;
% Iterate over each pixel to get the SAFT coefficient
for i = 1 : n
    for j = 1 : m
        x = (j - 1) * sx;           % x-projected distance
        z = (i - 0.5) * sz;         % z-projected distnace
        ang = atan(x/z);            % Angle with respect to the vertical
        d = sqrt(x^2 + z^2);        % Total distance
        dr = (d - dk) / sz;         % Normalized relative distance to dk
        % Calculate the c(i,j) SAFT coefficient
        if (dr > -1) && (dr < 1)
            c = 0.5 * (1 - cos((dr+1) * pi));
            c = c * interp1(angVec, antPattern, ang);
            % Fill the SAFT matrix if the c(i,j) > 0 
            if c > 0
                mVec(ind) = j-1;
                nVec(ind) = i;
                cVec(ind) = c;
                ind = ind + 1;
            end
        end
    end
end
% Remove the excess space in the sparce matrix 
mVec = mVec(1:ind-1);
nVec = nVec(1:ind-1);
cVec = cVec(1:ind-1);
mat = [mVec, nVec, cVec];

end