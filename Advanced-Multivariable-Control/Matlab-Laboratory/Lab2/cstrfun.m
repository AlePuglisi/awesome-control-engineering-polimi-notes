function dx=cstrfun(u,q,V,ko,ER,Tf,DH,r,cp,UA)
% RETURNS the states derivatives of the CSTR

    % q:	liquid volumetric flow rate			[L/min]
    % V:	tank's capacity                     [L]
    % ko:	constant 							[1/min]
    % ER: 	constant                            [K]
    % Tf:	temperature at the inlet 			[K]
    % DH:   tank's specific entalpy             [J/mol]
    % r:	density of the liquid               [g/L]
    % cp:	specific heat of the liquid 		[J/gK]
    % UA:	heat exchange coefficient           [J/minK]

    % Previous states: first two elements of input vector u
    x=u(1:2);

    % System inputs: third and fourth element of input vector u
    ui=u(3:4);

    % State equations
    dx(1)=(q/V)*[ui(1)-x(1)] - ko*[exp(-ER/x(2))]*x(1);
    dx(2)=(q/V)*[Tf-x(2)] + [(-DH)/(r*cp)]*ko*[exp(-ER/x(2))]*x(1) + [UA/(V*r*cp)]*[ui(2)-x(2)];

