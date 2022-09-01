function [data, dataHeader] = readdzt(filename)
%  READDZT Read and convert GSSI StructureScan Mini dzt format.
%
% 	 [data, header] = READDZT(filename) returns a matrix with the data of
%    the B-scan and a structure with the information of the B-scan.
%
%    INPUT:
%    filename       Local or global path of the dzt file (string)
%
%    OUTPUT:
%    data           GPR B-Scan data (matrix)
%    dataHeader     Header info (struct)
%
%  Strongly based on the script avaiable <a
%  href="https://github.com/NSGeophysics/GPR-O" />here</a>.
%  Modified by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Open the file for binary read access
fileID = fopen(filename);

% Get header information (this must be read byte by byte)
% Number of channels
fread(fileID, 1, 'uint16');
% Size of the header
headsize = fread(fileID, 1, 'uint16');
% Samples per trace
dataHeader.samplesPerTrace = fread(fileID, 1, 'uint16');
% Bits per word
bpdatum = fread(fileID, 1, 'uint16');
% Binary offset
fread(fileID, 1, 'int16');
% Scans per second
fread(fileID, 1, 'float32');
% Scans per meter
% If scansPerMeter==0, then no trigger wheel was used
dataHeader.scansPerMeter = fread(fileID, 1, 'float32');
% Meters per mark
fread(fileID, 1, 'float32');
% Start position (considered equal to 0)
dataHeader.startPosition = 0;
fread(fileID, 1, 'float32');
% header.startPosition = fread(fileID, 1, 'float32');
% Nanoseconds per trace
dataHeader.nanosecPerTrace = fread(fileID, 1, 'float32');
% Scans per pass
% header.scansPerPass = fread(fileID, 1, 'uint16');

% Define the data type
if bpdatum == 8
	datatype = 'uint8';
elseif bpdatum == 16
	datatype = 'uint16';
elseif bpdatum == 32
	datatype = 'uint32';
else
	error('Can not read data type')
end

% Read the entire file using the datatype
frewind(fileID);
vec = fread(fileID, Inf, datatype);

% Separate between header and data
headlength = headsize / (bpdatum/8);
% header = vec(1:headlength);
vec = vec(headlength+1:end);

% Reshape and remove the first two entries (they are just markers)
dataHeader.numOfColumns = length(vec) / dataHeader.samplesPerTrace;
data = reshape(vec, dataHeader.samplesPerTrace, dataHeader.numOfColumns);
data = data(3:end, :);
dataHeader.samplesPerTrace = dataHeader.samplesPerTrace - 2;

% Turn unsigned integers into signed integers
maxval = 2^bpdatum;
medval = maxval / 2;
% data = data - maxval/2;
ind = data > medval;
data(ind) = data(ind) - maxval;

% Close the file
fclose(fileID);

end