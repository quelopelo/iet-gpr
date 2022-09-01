function [saft, saftHeader] = saftproc(data, dataHeader, relPerm, ...
                                       sep, antPattern)
%  SAFTPROC Returns a matrix with the results of the SAFT process.
%
% 	 [saft, saftHeader] = SAFTPROC(data, dataHeader, relPerm, sep,
%    antPattern) returns a matrix (and a header) with the results of the
%    synthetic aperture focusing technique (SAFT) process, applied to 'data'.
%    The function requires the input the header ('dataHeader') and the relative
%    permittivity ('relPerm'), and allows the input of the separation between
%    sender and receiver ('sep'), and an antenna pattern ('antPattern').
% 
%    REQUIRED INPUT:
%    data           GPR B-Scan data (matrix)
%    dataHeader     Data header info (struct)
%    relPerm        Relative permittivity (real)
% 
%    OPTIONAL INPUT:
%    sep            Separation between sender and receiver (real)
%    antPattern     Pattern of the antenna, defined as an array of real
%                   numbers from an angle 0°, or perpendicular to the plane,
%                   to an angle 90°, or parallel to the plane (vector)
% 
%    OUTPUT:
%    saft           GPR SAFT data (matrix)
%    saftHeader     SAFT header info (struct)
% 
%    See also: SAFTMAT1, SAFTMAT2, SAFTMATS, SAFTPOST.
% 
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Defect value of sep and antPattern
if nargin < 4 || isempty(sep)
    sep = 0.085;        % Approximate value (m)
end
if nargin < 5 || isempty(antPattern)
    load antPattern antPattern;
end

% Get the amplitude of the signal (Hilbert filter)
h = abs(hilbert(data));

% Obtain a cell with the SAFT coefficients
[sm, ms] = saftmats(dataHeader, relPerm, sep, antPattern);

% Get the number of samples per trace (n) and the number of traces (md)
[n, md] = size(data);

% Construct a 3D array container to store the information
madd = ms - 1;
M = md + 2 * madd;
saft = zeros(n, M, n);

% Generate the 3D array with the SAFT processiong of each sample
for i = 1 : n
    smi = sm{i};
    for j = 1 : md
        for k = 1 : size(smi, 1)
            ik = smi(k,2);
            jk = j + madd + smi(k,1);
            vk = h(i, j) * smi(k,3);
            saft(ik, jk, i) = saft(ik, jk, i) + vk;
            if smi(k,1) > 0
                jk = j + madd - smi(k,1);
                saft(ik, jk, i) = saft(ik, jk, i) + vk;
            end
        end
    end
end

% Get the sum of all the matrixes
saft = sum(saft, 3);

% Construct the header information
c = 299792458e-9;
saftHeader.relPermittivity = relPerm;
saftHeader.samplesPerTrace = n;
saftHeader.scansPerMeter = dataHeader.scansPerMeter;
saftHeader.startPosition = dataHeader.startPosition - ...
                           madd / dataHeader.scansPerMeter;
saftHeader.nanosecPerTrace = dataHeader.nanosecPerTrace;
saftHeader.depthPerTrace = c * dataHeader.nanosecPerTrace / (2 * sqrt(relPerm));
saftHeader.numOfColumns = M;
saftHeader.numOfTraces = md;

end