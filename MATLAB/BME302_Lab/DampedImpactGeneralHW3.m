
% DampedImpactGeneralHW.m

% The code for a critically damped system is provided below. Your homework
% is to complete the code so that it can plot results for an overdamped
% system (DF>1) and an underdamped system (DF<1).

% v4 - 3/26/13 update the comments to specify a change in C to change DF.

% The DF can be changed by changing C. Turn in overlayed plots for DFs of
% 0.25, 0.5, 1, 2, and 4

K = 1;          % Stiffness
M = 1;          % Mass
C = 8;          % Damping Constant

% The Initial Conditions - note that they are generalized, but for impact,
% Xo should be set to 0.

Vo = 6;         % Initial Velocity
Xo = 0;         % Initial Displacement

% The values of the parameters below will be reported in the Command Window
% - you may find them useful for tuing your system

OmegaN = sqrt(K/M);				% Natural Frequency (Rad/sec)
DF = C/(2*M*OmegaN)				% Damping Factor
OmegaD = OmegaN*sqrt(1-DF^2);	% Damped Natural Frequency (Rad/sec)
CriticalC = 2*M*OmegaN			% Critical Damping Constant
Undampedfreq = OmegaN/(2*pi)    % Undamped Natural Frequency
Dampedfreq = OmegaD/(2*pi)      % Damped Natural Frequency
period = 1/Undampedfreq;

% controls the range and sampling on the time axis

numperiods = 1; % controls the range on the time axis
timeaxis = period*numperiods;
t = 0:timeaxis/500:timeaxis;


%   For a critically damped system

if DF==1
    A1=Xo;
    A2=Vo+Xo*DF*OmegaN;
    x = (A1+A2*t).*exp(-DF*OmegaN*t);
    v = (-A1*DF*OmegaN+A2*(1-DF*OmegaN*t)).*exp(-DF*OmegaN*t);
    F = M*(A1*(DF*OmegaN)^2-A2*(2*DF*OmegaN-(DF*OmegaN)^2*t)).*exp(-DF*OmegaN*t);
    subplot(2,2,1)
    % plot the displacment history
    plot(t,x,'-g','linewidth', 2);
    hold off
    hold on      % uncomment this line to overlay plots for each run
    xlabel('time [sec]'), ylabel('displacement [m]')
    grid
    title('Damped Impact')
    subplot(2,2,2)
    % plot the velocity history
    plot(t,v,'-g','linewidth', 2);
    hold off
    hold on      % uncomment this line to overlay plots for each run
    xlabel('time [sec]'), ylabel('Velocity [m/s]')
    grid
    subplot(2,2,3)
    % plot the force history
    plot(t,F,'-g','linewidth', 2);
    hold off
    hold on      % uncomment this line to overlay plots for each run
    xlabel('time [sec]'), ylabel('Force (N)')
    grid
    subplot(2,2,4)
    % plot the force-displacment response
    plot(x,F,'-g','linewidth', 2);
    hold off
    hold on      % uncomment this line to overlay plots for each run
    xlabel('displacement [m]'), ylabel('Force (N)')
    grid
end

%   For an underdamped system - YOU NEED TO DERIVE AND CODE THIS

if DF<1
    disp('This is your HW - you have not coded this DF condition yet')
    s2 = (-DF + (((DF).^2)-1)^(0.5)).*OmegaN;
    s1 = (-DF - (((DF).^2)-1)^(0.5)).*OmegaN;
    A1 = -(6./(s2-s1));
    A2 = (6./(s2-s1));
    x = A1.*exp(s1.*t)+A2.*exp(s2.*t);
    v = A1.*s1.*exp(s1.*t)+A2.*s2.*exp(s2.*t);
    F = M.*(A1.*(s1.^2).*exp(s1.*t)+A2.*(s2.^2).*exp(s2.*t));
    %A1 = Xo/2;
    %A2 = (-Vo + DF.*OmegaN.*Xo)./(2.*OmegaD);
    %x = (A1.*exp(1i.*OmegaD.*t)+A2.*exp(-1i.*OmegaD.*t)).*exp(-DF.*OmegaN.*t);
    %v = (exp(DF.*OmegaN.*(t.^2).*1i.*OmegaD).*((1i.*A1.*exp(2.*1i.*OmegaD.*t).*(OmegaD+(1i.*DF.*OmegaN))+(A2((-DF.*OmegaN)-(1i.*OmegaD))))));
    %F = M.*((-C.*(OmegaD.^2).*exp(-DF.*OmegaN.*t).*sind(OmegaD.*t+phase))+(C.*(DF.^2).*(OmegaN.^2).*exp(-DF.*OmegaN.*t).*sind(OmegaD.*t+phase))-(2.*C.*DF.*OmegaD.*OmegaN.*exp(-DF.*OmegaN.*t).*cosd(OmegaD.*t+phase)));
     subplot(2,2,1)
     % plot the displacment history
     plot(t,x,'-r','linewidth', 2);
     hold off
     hold on
     xlabel('time [sec]'), ylabel('displacement [m]')
     grid
     title('Damped Impact')
     subplot(2,2,2)
     % plot the velocity history
     plot(t,v,'-r','linewidth', 2);
     hold off
     hold on
     xlabel('time [sec]'), ylabel('Velocity [m/s]')
     grid
     subplot(2,2,3)
     % plot the force history
     plot(t,F, 'r', 'linewidth', 2);
     hold off
     hold on
     xlabel('time [sec]'), ylabel('Force (N)')
     grid
     subplot(2,2,4)
     % plot the force-displacment response
     plot(x,F,'-r','linewidth', 2);
     hold off
     hold on
     xlabel('displacement [m]'), ylabel('Force (N)')
     grid
end

%   For an overdamped system - YOU NEED TO DERIVE AND CODE THIS

if DF>1
    disp('This is your HW - you have not coded this DF condition yet')
    s2 = (-DF + (((DF).^2)-1)^(0.5)).*OmegaN;
    s1 = (-DF - (((DF).^2)-1)^(0.5)).*OmegaN;
    A1 = -(6./(s2-s1));
    A2 = (6./(s2-s1));
    x = A1.*exp(s1.*t)+A2.*exp(s2.*t);
    v = A1.*s1.*exp(s1.*t)+A2.*s2.*exp(s2.*t);
    F = M.*(A1.*(s1.^2).*exp(s1.*t)+A2.*(s2.^2).*exp(s2.*t));
    subplot(2,2,1)
    % plot the displacment history
    plot(t,x,'-b','linewidth', 2);
    hold off
    hold on
    xlabel('time [sec]'), ylabel('displacement [m]')
    grid
    title('Damped Impact')
    subplot(2,2,2)
    % plot the velocity history
    plot(t,v,'-b','linewidth', 2);
    hold off
    hold on
    xlabel('time [sec]'), ylabel('Velocity [m/s]')
    grid
    subplot(2,2,3)
    % plot the force history
    plot(t,F, 'b', 'linewidth', 2);
    hold off
    hold on
    xlabel('time [sec]'), ylabel('Force (N)')
    grid
    subplot(2,2,4)
    % plot the force-displacment response
    plot(x,F,'-b','linewidth', 2);
    hold off
    hold on
    xlabel('displacement [m]'), ylabel('Force (N)')
    grid
end