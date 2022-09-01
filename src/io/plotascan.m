function fig = plotascan(data, header, startPos, endPos, relPerm)
%  PLOTASCAN Plots a series of A-Scans of the data.
%
% 	 fig = PLOTASCAN(data, header, startPos, endPos, relPerm) plots and
%    returns a figure with a series of A-Scans of the data between the two
%    positions 'startPos' and 'endPos', using the information of the header.
%    If the header  includes the relative permittivity or this is entered as
%    a parameter ('relPerm'), the y-axis is used to plot the depth. Otherwise,
%    the y-axis is used to plot the two-way travel time. To force the y-axis
%    to represent the time, enter relPermitivity == 0.
%
%    REQUIRED INPUT:
%    data           GPR B-Scan data (matrix)
%    header         Header info (struct)
% 
%    OPTIONAL INPUT:
%    startPos       Starting position (real)
%    endPos         Ending position (real)
%    relPerm        Relative permittivity (real)
%
%    OUTPUT:
%    fig            Handle to the figure object (line)
%
%    See also: PLOTBSCAN.
% 
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Defect value of startPos, endPos and relPerm
if nargin < 3 || isempty(startPos)
    startPos = header.startPosition;
end
if nargin < 4 || isempty(endPos)
    endPos = startPos + header.numOfColumns / header.scansPerMeter;
end
if nargin < 5 || isempty(relPerm)
    try
        relPerm = header.relPermittivity;
    catch
        relPerm = 0;
    end
end

% Get the vector of two way travel time or depth
if relPerm <= 0
    twtt = linspace(0, header.nanosecPerTrace, header.samplesPerTrace);
else
    c = 299792458e-9;
    depthPerTrace = c * header.nanosecPerTrace / (2 * sqrt(relPerm));
    depth = linspace(0, depthPerTrace, header.samplesPerTrace);
end

% Plot the set of A-Scans
if relPerm <= 0
    fig = plot(twtt, trimscan(data, header, startPos, endPos));
    xlabel('Two way travel time (ns)');
else
    fig = plot(depth, trimscan(data, header, startPos, endPos));
    xlabel('Depth (m)');
end
ylabel('Amplitude');

end