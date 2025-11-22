%compute the function 
Pg1 = [15:0.1:100];
Pe=120;
f = zeros(length(Pg1),0);
c1 = zeros(length(Pg1),0);
for i=1:length(Pg1)
    f(i) = 1.5 + 1.5*(Pg1(i)-95)^2 + 3*(Pe-Pg1(i)-48)^2;
    c1(i) = 0.5 + 1.5*(Pg1(i)-95)^2;
end

Pg2 = [7.5:0.1:50];
c2 = zeros(length(Pg2),0);
for i=1:length(Pg2)
     c2(i)=1 + 3*(Pg2(i)-48)^2;
end


%plot 
figure; % Create a new figure window
plot(Pg1, f,'r', 'LineWidth',1.5); % Plot the data points as circles connected by lines
grid on; % Display the grid lines
hold on 
plot(Pg1, c1,'b--', 'LineWidth',1);
plot(Pg2, c2,'g--', 'LineWidth',1);

legend('c_{12}(P_{g1})', 'c_{1}(P_{g1})', 'c_{2}(P_{g2})');
hold off

xlabel('P_{g}'); % Label for the x-axis
ylabel('c'); % Label for the y-axis
title('c(P_{g})  plot'); % Title for the plot


