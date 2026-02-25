clear all %clear the workspace each time i run this program 
close all %close all figures

% DATA definition (all in SI unit) (carefully about case sensitive aspect
% on variable name definition) 
m1 = 10; m2 = 3;  % ; to hide the print of information when running 
J1 = 0.8; J2 = 0.2;
L1 = 0.5; L2 = 0.2;
k1 = 500; k2 = 500;
c1 = 0.2; c2 = 0.2; 
Dl02 = 0.1275;
theta0 = pi/6;
s0 = sin(theta0); c0 = cos(theta0);
g = 9.81;

%Matrix definition already found by hand (ph and jacobbians)
mph = diag([m1 m1 J1 m2 m2 J2]);
kph = diag([k1 k2]);
cph = diag([c1 c2]);

Lm = [1 -L1*s0 0;  %lambda m matrix
      0  L1*c0 0;
      0   1    0;
      1 -L1*s0 L2; 
      0  L1*c0 0;
      0   0    1];
Lk = [1   0    0;  %Lambda k matrix equal to lambda c!
      0 -2*L1*c0 0];

kelII2 = zeros(3, 3); %3x3 matrix full of zeros, than assign to element 2,2
kelII2(2,2) = k2*Dl02*2*L1*s0;

kg1 = zeros(3, 3);
kg1(2,2) = -m1*g*L1*s0;

kg2 = zeros(3, 3);
kg2(2,2) = -m2*g*L1*s0;
kg2(3,3) = m2*g*L2;

Lf = [1 -L1*s0 2*L2;
      1    0    0];
%now using this matrix we can define
M = Lm'*mph*Lm; %"'" meaning transpose
K = Lk'*kph*Lk + kelII2 + kg1 + kg2;
C = Lk'*cph*Lk;

%until now we just define the essential terms of lagrange equation.
%QUESTION 1: compute w, X?
%COMPUTE w (nat freq) and modal shapes for undamped system

[V, D] = eig(M\K); %M\K = M^-1 * K shortcut
%eig command ecxtract 2 matrixes V contaeining eigen vectors, while D diag
%matrix with eig values, so V = MODAL MATRIX, while from D we extract diag
%terms and takes its square
%on diag terms od D we have w^2 nat frequencies
freq = sqrt(diag(D))/pi/2; % diag command here extract diag element on D
% we get it in rad/s we would take it has Hz dividing by pi/2

%QUESTION 2: find the FRF of the system for the two excitation
% excitation ! related to force acting on BAR2 horizontally 
%find for a range of 0 to 3 Hz with 0.01 Hz space
f = [0:0.01:3]; % create a vector from 0 to 3 equally spaced by 0.01
Ome = 2*pi*f; %to define omega vector
i = sqrt(-1); %def im unit
F0 = Lf'*[1;0]; %using only the first element, super imposition..
% to define FRF we loop over all freq:
for j=1:length(Ome)
    A = (-Ome(j)^2*M + i*Ome(j)*C + K); %complex valued square matrix of coeff auxiliar
    X0 = A^-1*F0; %this found a 3x1 complex vector where  there is [phase and magnitude of x motion, theta, phi motion]
    % we can output from here 3 bode diagrams for each indip cohordinates
    mod1(j) = abs(X0(1));%(magnitude of first elem) extracting x (first cohord) mode from X0
    fas1(j) = angle(X0(1));%phase of first element of X0, for each freq j
    mod2(j) = abs(X0(2));
    fas2(j) = angle(X0(2));
    mod3(j) = abs(X0(3));
    fas3(j) = angle(X0(3));
end

%we can PLOT the bode diagrams:
figure(1) %'1' to define the fig number
%for first cohordinate, so respect x 
subplot(211) %2 rows and one column plot on figure 1 (subplot number 1)
plot(f,mod1);grid %plot contemt of mod1 respect f, vector of same size!
subplot(212) %working on subplot 2
plot(f,fas1);grid

%second bode plot 
figure(2)
subplot(211) 
plot(f,mod2);grid
subplot(212)
plot(f,fas2);grid

%third bode plot 
figure(3)
subplot(211) 
plot(f,mod3);grid
subplot(212)
plot(f,fas3);grid

%---WE CAN DO THE SAME FOR THE OTHER EXCITATION ---
% to define FRF we loop over all freq:
for j=1:length(Ome)
    A = (-Ome(j)^2*M + i*Ome(j)*C + K); %complex valued square matrix of coeff auxiliar
    F0 = Lf'*[0;k1+i*Ome(j)*c1];
    X0 = A^-1*F0; %this found a 3x1 complex vector where  there is [phase and magnitude of x motion, theta, phi motion]
    % we can output from here 3 bode diagrams for each indip cohordinates
    mod1(j) = abs(X0(1));%(magnitude of first elem) extracting x (first cohord) mode from X0
    fas1(j) = angle(X0(1));%phase of first element of X0, for each freq j
    mod2(j) = abs(X0(2));
    fas2(j) = angle(X0(2));
    mod3(j) = abs(X0(3));
    fas3(j) = angle(X0(3));
end

%we can PLOT the bode diagrams:
figure(4); %'1' to define the fig number
%for first cohordinate, so respect x 
subplot(211) %2 rows and one column plot on figure 1 (subplot number 1)
plot(f,mod1);grid %plot contemt of mod1 respect f, vector of same size!
 title("FRF of x for unit y")
subplot(212) %working on subplot 2
plot(f,fas1);grid

%second bode plot 
figure(5); 
subplot(211) 
plot(f,mod2);grid
title("FRF of \theta for unit y")
subplot(212)
plot(f,fas2);grid

%third bode plot 
figure(6);
subplot(211) 
plot(f,mod3);grid
title("FRF of \phi for unit y")
subplot(212)
plot(f,fas3);grid


%---LAB2---
%COLOCATED FRF, write the frf taking as output Xc the horizontal
%displacement of pendulum tip
F0 = Lf'*[1;0]; % effect of unit force applied on the pendulum tip
for j=1:length(Ome)
    A = (-Ome(j)^2*M + i*Ome(j)*C + K); %matrix of mech impedence for each freq
    X0 = A^-1*F0; %solve the linear problem obgtaining X0, than extract the single FRF 
    mod1(j) = abs(X0(1));
    fas1(j) = angle(X0(1));
    mod2(j) = abs(X0(2));
    fas2(j) = angle(X0(2));
    mod3(j) = abs(X0(3));
    fas3(j) = angle(X0(3));
    % once found all the x, theta, phi FRF: we compute Xc
    xc = X0(1) - L1*s0*X0(2) + 2*L2*X0(3); %definition of our new interested variable (complex value)
    %we wanna also extract this as:
    mod4(j) = abs(xc);
    fas4(j) = angle(xc);
end
%BODE PLOT of Xc FRF respect forcing F0 on the pendulum tip 
figure(7);
subplot(211) 
plot(f,mod4);grid
title("FRF of Xc for unit y")
subplot(212)
plot(f,fas4);grid

%EVALUATE THE FORCE OF PARALLEL SPRING AND DUMPER 2
for j=1:length(Ome)
    A = (-Ome(j)^2*M + i*Ome(j)*C + K); %complex valued square matrix of coeff auxiliar
    F0 = Lf'*[0;k1+i*Ome(j)*c1];
    X0 = A^-1*F0; 
    Dl2 = -2*L1*c0*X0(2); %using theta cohordinates value
    Fel2 = (k2 + i*Ome(j)*c2)*Dl2;
    %FIND ALSO THE V2 vertical contraint force acting on the cart 
    Yg1 = L1*c0*X0(2);
    Yg1dd = -(Ome(j)^2)*Yg1; %yg2 double dot derivative
    Yg2 = L1*c0*X0(2);
    Yg2dd = -(Ome(j)^2)*Yg2;
    Vadyn = m1*Yg1dd + m2*Yg2dd - Fel2;
    mod1(j) = abs(X0(1));
    fas1(j) = angle(X0(1));
    mod2(j) = abs(X0(2));
    fas2(j) = angle(X0(2));
    mod3(j) = abs(X0(3));
    fas3(j) = angle(X0(3));
    mod4(j) = abs(Fel2);
    fas4(j) = angle(Fel2);
    mod5(j) = abs(Vadyn);
    fas5(j) = angle(Vadyn);
end
%BODE PLOT of Fel2
figure(8);
subplot(211) 
plot(f,mod4);grid
title("FRF of F_{el} for unit y")
subplot(212)
plot(f,fas4);grid

%BODE PLOT of Vadyn
figure(9);
subplot(211) 
plot(f,mod5);grid
title("FRF of V_{A} for unit y")
subplot(212)
plot(f,fas5);grid