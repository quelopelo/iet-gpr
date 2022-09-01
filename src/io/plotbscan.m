function fig = plotbscan(data, header, relPerm)
%  PLOTBSCAN Plots a B-Scan of the data.
%
% 	 fig = PLOTBSCAN(data, header, relPerm) plots and returns a figure with
%    a B-Scan of the data, using the information of the header. If the header 
%    includes the relative permittivity or this is entered as a parameter
%    ('relPerm'), the y-axis is used to plot the depth. Otherwise, the y-axis
%    is used to plot the two-way travel time. To force the y-axis to represent
%    the time, enter relPermitivity == 0.
%
%    REQUIRED INPUT:
%    data           GPR B-Scan data (matrix)
%    header         Header info (struct)
% 
%    OPTIONAL INPUT:
%    relPerm        Relative permittivity (real)
%
%    OUTPUT:
%    fig            Handle to the figure object (pcolor)
%
%    See also: PLOTASCAN.
% 
%  Developed by quelopelo - IET, FING, UDELAR (2022)
%  For more information, visit https://github.com/quelopelo/iet-gpr

% Defect value of relPerm
if nargin < 3 || isempty(relPerm)
    try
        relPerm = header.relPermittivity;
    catch
        relPerm = 0;
    end
end

% Get the vector of position
xpos = linspace(header.startPosition, header.startPosition + ...
                header.numOfColumns/header.scansPerMeter, header.numOfColumns);

% Get the vector of two way travel time or depth
if relPerm <= 0
    twtt = linspace(0, header.nanosecPerTrace, header.samplesPerTrace);
else
    c = 299792458e-9;
    depthPerTrace = c * header.nanosecPerTrace / (2 * sqrt(relPerm));
    depth = linspace(0, depthPerTrace, header.samplesPerTrace);
end

% Plot the B-Scan
if relPerm <= 0
    fig = pcolor(xpos, twtt, data);
    ylabel('Two way travel time (ns)');
else
    fig = pcolor(xpos, depth, data);
    ylabel('Depth (m)');
end
colormap jet;
shading interp;             % Deletes the grid lines
axis ij;                    % Flips the y-axis of the plot
xlabel('Distance (m)');

end