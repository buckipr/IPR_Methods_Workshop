% Lotka defines the differential equations for Lotka-Volterra predator-prey
% model in continuous time.  

% Punit Tulpule
% 10/29/2020

function dS = Lotka(~,states, alpha,beta,gamma,delta)

x = states(1);      %Prey population
y = states(2);      %Predator population

dx = gamma*x-alpha*x*y;
dy = -delta*y+beta*x*y;

dS = [dx;dy];

