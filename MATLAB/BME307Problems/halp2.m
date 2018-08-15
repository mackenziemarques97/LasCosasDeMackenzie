%% Initialization
clear;
%% Setting up the problem 
Co = 1*10^6; 
Dncs = 3*10^-6;
Ddtb = 5*10^-9;
k = 5*10^-5;
h1 = 0.02;
h2 = 0.02;
dt = 0.02;
dx = 0.0005;
t = 0:dt:(24*60*60); 
x = 0:dx:(h1+h2);
x1 = 0:dx:h1;
x2 = h1:dx:(h1+h2);
M = (max(t)-min(t))/dt;
N = (max(x)-min(x))/dx;
N1 = (max(x1)-min(x1))/dx; 
C = zeros(N+1,M+1); 
C(1:N1+1,1) = Co; 
C(N1+2:end,1) = 0;
%% Loop
for j = 1:M % Time loop
    C(1,j+1) = C(1,j)+((2*Dncs*dt)/(dx^2))*(C(2,j)-C(1,j));
     %Position loop
     for i = 2:N1
        C(i,j+1) = C(i,j) + ((Dncs*dt)/(dx^2))*(C(i+1,j)-2*C(i,j)+C(i-1,j));
     end
     
     for i = N1+2:N
        C(i,j+1) = (1-k*dt)*C(i,j) + ((Ddtb*dt)/(dx^2))*(C(i+1,j)-2*C(i,j)+C(i-1,j));
     end
    C(41,j+1) = (Ddtb*C(42,j+1) + Dncs*C(40,j+1))/(Dncs+Ddtb);
    C(N+1,j+1) = C(N+1,j)+((2*Ddtb*dt)/(dx^2))*(C(N,j)-C(N+1,j));
end %ending time loop
%% Plotting 
figure(1); clf;
plot(x,C(:,1));
hold on
plot(x,C(:,10));
plot(x,C(:,100));
plot(x,C(:,1000));
plot(x,C(:,10000));
plot(x,C(:,100000));
plot(x,C(:,200000));
plot(x,C(:,500000));
plot(x,C(:,700000));
plot(x,C(:,1000000));
plot(x,C(:,2000000));
plot(x,C(:,3000000));
plot(x,C(:,4000000));
hold off
%% Finding time
Time_ind = find(C(N+1,:)>=1.0e05);
Time_ind = Time_ind(1);
Time = (Time_ind*dt)/3600
%% Plotting vs time
hold on
%plot(t,C(1,:));
%plot(t,C(10,:));
%plot(t,C(20,:));
%plot(t,C(30,:));
%plot(t,C(50,:));
%plot(t,C(60,:));
%plot(t,C(70,:));
%plot(t,C(80,:));