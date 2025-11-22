% Define the transfer function
num = 2*[500 1];
den = [5587.05 3286.5 0 0];

% Create transfer function
G = tf(num, den);

% Generate Bode plot
figure
bode(G)
grid on