% main program to simulate Lotka Volterra (predator prey) model. x0,y0 are
% the initial populations, and alpha, beta, gamma, delta define the
% relationships between the two species. This code uses ode23 (a veriable
% step RK solver). 

% Author: Punit Tulpule (tulpule.3@osu.edu)
% Used for IPR workshop 10/29/2020

x0 = 20;        % Initial prey population
y0 = 10;        % Initial predator population
tspan = [0 20]; % Timespan for simulation

% Parameters describing interaction between two species
alpha = 0.02;   
beta = 0.01;    
gamma = 1;
delta = 1;

% Solve Lotka-Volterra equations
[time,states] = ode23(@(x,t)Lotka(x,t,alpha,beta,gamma,delta),[0,20],[x0;y0]);


%% Plot evolution with time
figure,
plot(time,states)
xlabel('Time');
ylabel('Population');
legend('Prey', 'Predator');
title('Simulation results of Predator-Prey model')
%% Plot phase-diagram
figure,
plot(states(:,1),states(:,2));
xlabel('Population Prey');
ylabel('Population Predator');
title('Phase plot of Predator-Prey model')