%compute the function 
Pg1 = [15:0.1:100];
Pe=[50:10:150];
f = zeros(length(Pg1),length(Pe));
for j=1:length(Pe)
    for i=1:length(Pg1)
        f(i,j) = 1.5 + 1.5*(Pg1(i)-95)^2 + 3*(Pe(j)-Pg1(i)-48)^2;
    end
end


%plot 
figure; % Create a new figure window
hold on 
for j=1:length(Pe)
    plot(Pg1, f(:,j)); % Plot the data points as circles connected by lines
end

grid on; % Display the grid lines

legend('Pe=50','Pe=60','Pe=70','Pe=80','Pe=90','Pe=100','Pe=110','Pe=120','Pe=130','Pe=140','Pe=150');
hold off

xlabel('P_{g1}'); % Label for the x-axis
ylabel('c_{12}'); % Label for the y-axis
title('c_{12}(P_{g1}) with increasing Pe plot'); % Title for the plot


