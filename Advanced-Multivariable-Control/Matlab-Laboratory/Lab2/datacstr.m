close all %#ok<*NOPTS>

%% PARAMETERS
q=100;          % q:	liquid volumetric flow rate			[L/min]
V=100;          % V:	tank's capacity                     [L]
ko=7.2*10^10;   % ko:	constant 							[1/min]
ER=8750;        % E/R: 	constant                            [K]
Tf=350;         % Tf:	temperature at the inlet 			[K]
DH=-5*10^4;     % DH:   tank's specific entalpy             [J/mol]
r=1000;         % r:	density of the liquid               [g/L]
cp=0.239;       % cp:	specific heat of the liquid 		[J/gK]
UA=5*10^4;      % UA:	heat exchange coefficient           [J/minK]
