function [meanTheta, meanRho] = meansPolars(phase)
% parent function: summarizeThatPhasePlot.m

% save('/home/mark/matlab_temp_variables/mPs')
% ccc
% load('/home/mark/matlab_temp_variables/mPs')

%%
theta = phase.RadPhase ;
rho = phase.Engangement ;

%% from serapio:
[x,y] = pol2cart(theta, rho);

x_hat = mean(x);
y_hat = mean(y);

[theta_hat, rho_hat] = cart2pol(x_hat, y_hat);

%%
meanTheta = theta_hat ;
meanRho = rho_hat ;