# IET GPR

>**MATLAB function set toolbox for importing, processing, and plotting data from a GSSI-StructureScan Mini GPR**

## Introduction

IET GPR consists of a set of functions for importing, processing and ploting data from a GSSI-StructureScan Mini ground penetrating radar (GPR). The software is distributed as a [MATLAB toolbox](https://github.com/quelopelo/iet-gpr/tree/main/dist) or via the [open source code files](https://github.com/quelopelo/iet-gpr/tree/main/src).

Firstly, the program allows to load and convert a dzt file generated by a GSSI-StructureScan Mini GPR. In this way, the [readdzt](https://github.com/quelopelo/iet-gpr/blob/main/src/io/readdzt.m) function builds a numerical matrix and an information header, with which the data can be easily manipulated from MATLAB. This is the only function that was strongly based on a [previous work](https://github.com/NSGeophysics/GPR-O).

Once the data is loaded into MATLAB, the program allows to process it using various functions, including: DC-offset ([dcoffset](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/dcoffset.m)), linear-offset ([linearoffset](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/linearoffset.m)), trend removal ([removetrend](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/removetrend.m)) and noise reduction ([smoothscan](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/smoothscan.m)). IET GPR also includes a number of gain functions to improve the data visualization ([lingain](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/lingain.m), [expgain](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/expgain.m), [agcgain](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/agcgain.m), [iadgain1](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/iadgain1.m) and [iadgain2](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/iadgain2.m)).

With the processed data, the program allows applying the synthetic aperture focusing technique (SAFT) to improve the visualization by means of two functions: [saftproc](https://github.com/quelopelo/iet-gpr/blob/main/src/saft/saftproc.m) and [saftpost](https://github.com/quelopelo/iet-gpr/blob/main/src/saft/saftpost.m). This is one of many techniques available to focus or migrate data. 
As this can be a computationally demanding process, IET GPR incorporates two functions to reduce the amount of data: one to trim or cut a B-Scan ([trimscan](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/trimscan.m)) and the other to reduce its resolution ([resizescan](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/resizescan.m)).

Finally, the program includes a couple of functions to plot the GPR and SAFT data. These are [plotascan](https://github.com/quelopelo/iet-gpr/blob/main/src/io/plotascan.m), which plots a series of A-Scans, and [plotbscan](https://github.com/quelopelo/iet-gpr/blob/main/src/io/plotbscan.m), which plots a B-Scan.

All functions include a help text that can be consulted using the command `help` followed by the name of the function (example: `help plotbscan`). Additionally, there are three [example files](https://github.com/quelopelo/iet-gpr/tree/main/src/examples) that guide the user along the first steps.

## Installation

There are two ways of using the IET GPR set of functions.

1. Install the toolbox located in the [dist](https://github.com/quelopelo/iet-gpr/tree/main/dist) folder. This [official link](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html) contains additional information about the installation and management of toolboxes. This method adds the functions to the MATLAB path, so that they are built into the IDE each time MATLAB is started.

2. Download the [src](https://github.com/quelopelo/iet-gpr/tree/main/dist) folder to your computer. Change the MATLAB current path to the downloaded folder and run the `ietgpr` command. This second step is not automatic, so it must be repeated every time MATLAB is restarted.

## List of functions

### Load GPR data (input)

[**readdzt**](https://github.com/quelopelo/iet-gpr/blob/main/src/io/readdzt.m) – Read and convert GSSI StructureScan Mini dzt format.

- Syntax: `[data, header] = readdzt(filename)`
- Application: see [Example 1](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example1.html)

### Visualize data (output)

[**plotascan**](https://github.com/quelopelo/iet-gpr/blob/main/src/io/plotascan.m) – Plots a series of A-Scans of the data between two positions.

- Syntax: `fig = plotascan(data, header, startPos, endPos, relPerm)`
- Application: see [Example 1](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example1.html)

[**plotbscan**](https://github.com/quelopelo/iet-gpr/blob/main/src/io/plotbscan.m) – Plots a B-Scan of the data.

- Syntax: `fig = plotbscan(data, header, relPerm)`
- Application: see [Example 1](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example1.html)

### Process data

[**dcoffset**](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/dcoffset.m) – Corrects the DC-offset of a B-Scan data.

- Syntax: `data = dcoffset(data)`
- Application: see [linearoffset](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/linearoffset.m) in [Example 2](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example2.html)

[**linearoffset**](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/linearoffset.m) – Corrects the linear-offset of a B-Scan data.

- Syntax: `data = linearoffset(data)`
- Application: see [Example 2](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example2.html)

[**removetrend**](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/removetrend.m) – Removes the trend from a B-Scan data.

- Syntax: `data = removetrend(data, cvFactor)`
- Application: see [Example 2](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example2.html)

[**smoothscan**](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/smoothscan.m) – Reduces the noise (or smooths) of a B-Scan data.

- Syntax: `data = smoothscan(data, dataHeader, horScale, verScale)`
- Application: see [Example 2](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example2.html)

[**trimscan**](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/trimscan.m) – Trims a B-Scan data between two positions.

- Syntax: `[data, dataHeader] = trimscan(data, dataHeader, startPos, endPos)`
- Application: see [resizescan](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/resizescan.m) in [Example 3](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example3.html)

[**resizescan**](https://github.com/quelopelo/iet-gpr/blob/main/src/proc/resizescan.m) – Resizes a B-Scan data to the specified size.

- Syntax: `[data, dataHeader] = resizescan(data, dataHeader, horSize, verSize)`
- Application: see [Example 3](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example3.html)

### Apply a gain function

[**lingain**](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/lingain.m) – Applies a custom linear gain to the data.

- Syntax: `data = lingain(data, linFactor)`
- Application: see [iadgain1](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/iadgain1.m) in [Example 2](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example2.html)

[**expgain**](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/expgain.m) – Applies a custom exponencial gain to the data.

- Syntax: `data = expgain(data, expFactor)`
- Application: see [iadgain1](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/iadgain1.m) in [Example 2](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example2.html)

[**agcgain**](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/agcgain.m) – Applies an automatic gain control to the data.

- Syntax: `data = agcgain(data, windowSize, gainFactor)`
- Application: see [iadgain1](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/iadgain1.m) in [Example 2](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example2.html)

[**iadgain1**](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/iadgain1.m) – Applies an inverse amplitude decay to the data, based on the curve $y=a e^{-b x} + c$.

- Syntax: `data = iadgain1(data, gainFactor)`
- Application: see [iadgain1](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/iadgain1.m) in [Example 2](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example2.html)

[**iadgain2**](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/iadgain2.m) – Applies an inverse amplitude decay to the data, based on the curve $y=a \frac{(b x)}{b x + 1} e^{-c x} + d$.

- Syntax: `data = iadgain2(data, gainFactor)`
- Application: see [iadgain1](https://github.com/quelopelo/iet-gpr/blob/main/src/gain/iadgain1.m) in [Example 2](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example2.html)

### Migrate using SAFT algorithm

[**saftproc**](https://github.com/quelopelo/iet-gpr/blob/main/src/saft/saftproc.m) – Returns a matrix (and a header) with the results of the SAFT migration process.

- Syntax: `[saft, saftHeader] = saftproc(data, dataHeader, relPerm, sep, antPattern)`
- Application: see [Example 3](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example3.html)

[**saftpost**](https://github.com/quelopelo/iet-gpr/blob/main/src/saft/saftpost.m) – Post-processes the results of the SAFT algorithm (trim or mirror the edges).

- Syntax: `[saft, saftHeader] = saftpost(saft, saftHeader, mirror)`
- Application: see [Example 3](https://htmlpreview.github.io/?https://github.com/quelopelo/iet-gpr/blob/main/docs/example3.html)

### Auxiliary functions

[**safmat1**](https://github.com/quelopelo/iet-gpr/blob/main/src/saft/saftmat1.m) – Returns the SAFT coefficients matrix corresponding to index 'k', considering a null separation between the sender and the receiver.

[**saftmat2**](https://github.com/quelopelo/iet-gpr/blob/main/src/saft/saftmat2.m) – Returns the SAFT coefficients matrix corresponding to index 'k',
%  considering a separation between the sender and the receiver 'sep'

[**saftmats**](https://github.com/quelopelo/iet-gpr/blob/main/src/saft/saftmats.m) – Returns a cell with the SAFT coefficients matrixes.

[**linearcoef**](https://github.com/quelopelo/iet-gpr/blob/main/src/utils/linearcoef.m) – Returns the square of the linear approximation coefficient.

## Possible future works

The program is in an early stage, so there is room for many improvements.

- Add support for other ground penetrating radars and antennas.
- Add processing functions, such as a dewow, a band-pass filter or a process to remove bad traces.
- Add gain functions, especially one that uses a numerical physical model to determine the attenuation as a function of the relative permittivity of the medium.
- Add other focusing or migration techniques.
- Add support for importing, processing and visualizing 3D scans.
- Add a focusing or migration technique for 3D scans.
- Add a graphical user interface (GUI).
- Rewrite the program in an open and widely used programming language, such as Python.

## Licence and citation

The code is distributed under a [GNU-GPL 3.0 license](https://github.com/quelopelo/iet-gpr/blob/main/LICENCE.md).

If you use this software, please cite it using [these metadata](https://github.com/quelopelo/iet-gpr/blob/main/CITATION.cff).
