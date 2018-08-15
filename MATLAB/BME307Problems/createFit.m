function [fitresult, gof] = createFit(xm, delta)
%CREATEFIT(XM,DELTA)
%  Create a fit.
%
%  Data for 'Our Numerical Model' fit:
%      X Input : xm
%      Y Output: delta
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 22-Feb-2018 14:55:15


%% Fit: 'Our Numerical Model'.
x = 10:20:90; %cm
xm = x./100; %m
delta = [0.0215, 0.0385, 0.049, 0.058, 0.064];
[xData, yData] = prepareCurveData( xm, delta );

% Set up fittype and options.
ft = fittype( 'a.*X.*((1.23*0.072764*X)/1.79e-5).^(-1/2)', 'independent', 'X', 'dependent', 'Y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = 0.915735525189067;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Create a figure for the plots.
figure( 'Name', 'Our Numerical Model' );

% Plot fit with data.
subplot( 2, 1, 1 );
h = plot( fitresult, xData, yData );
legend( h, 'delta vs. xm', 'Our Numerical Model', 'Location', 'NorthEast' );
% Label axes
xlabel xm
ylabel delta
grid on

% Plot residuals.
subplot( 2, 1, 2 );
h = plot( fitresult, xData, yData, 'residuals' );
legend( h, 'Our Numerical Model - residuals', 'Zero Line', 'Location', 'NorthEast' );
% Label axes
xlabel xm
ylabel delta
grid on

