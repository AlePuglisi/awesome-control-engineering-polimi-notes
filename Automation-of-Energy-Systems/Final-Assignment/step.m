Ti=500;
Ta=6.58;
T3=20;
k=0.052;

num = [-Ti*T3, -Ti, 0];
den = [Ti*Ta*T3, Ti*Ta,k*Ti, k];
G = tf(num, den);
figure(1)
step(G*0.033)

figure(2)
bode(G)
grid on
%plot(t, y);
%xlabel('Time');
%ylabel('Output');
%title('Step Response');
%grid on;