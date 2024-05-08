clf

%% Analytical
R = 50e3;
C = 10e-6;
syms s

G = 1/(4*R^2*C^2*s^2 + 5*R*C*s + 1);
roots([1 2.5 1])

% sys = tf(2.5,[1 2.5 1]); 
% [step tstep] = step(sys);
% This wasn't working because of the sample time 
% of the step function. So I just wrote it in its closed form solution
% below.

t = 0:0.1:15;
zeta = 1.25;
wn = 1;
z2 = sqrt(zeta^2-1);
B1 = (-zeta-z2)/(2*z2);
B2 = (zeta-z2)/(2*z2);
Vout = 2.5*(1+B1*exp(-0.5*t)+B2*exp(-2*t));

%% Experimental
fs = 10; % 10 Hz sample frequency
RawStepResponse = importdata('StepResponse.txt'); 
StepResponse = [RawStepResponse(:,1)/fs RawStepResponse(:,2)];

%% Data Analysis
figure(1)
plot(t,Vout)
xlabel("Time [s]")
ylabel("Voltage [V]")
title("Analytical Open Loop Step Response")

figure(2)
plot(t,Vout)
hold on
plot(StepResponse(1:151,1), StepResponse(1:151,2))
legend("Analytical", "Experimental")
xlabel("Time [s]")
ylabel("Voltage [V]")
title("Analytical vs. Experimental Open Loop Step Response")


%% Phase Margin
Kp = 2.349;
Ki = 0.855;
sysPI = tf([Kp Ki], [1 2.5 1 0]);
figure(3)
margin(sysPI)

%% PI Control

%Simulink
figure(4)
plot(tout(1:100), yout(1:100, 1), tout(1:100), yout(1:100, 2))
hold on

%Data
% RawPIcontrol = importdata('PIcontrol.txt');
% PIcontrol = [RawPIcontrol(:,1)/fs RawPIcontrol(:,2) RawPIcontrol(:,3)];
% plot(PIcontrol(1:100, 1), PIcontrol(1:100, 2), PIcontrol(1:100, 1), PIcontrol(1:100, 3));

% RawPIcontrol = importdata('PIcontrol_phi80.txt');
% PIcontrol = [RawPIcontrol(:,1)/fs RawPIcontrol(:,2) RawPIcontrol(:,3)];
% plot(PIcontrol(1:100, 1), PIcontrol(1:100, 2), PIcontrol(1:100, 1), PIcontrol(1:100, 3));

RawPIcontrol = importdata('PIcontrol_Woc2.txt');
PIcontrol = [RawPIcontrol(:,1)/fs RawPIcontrol(:,2) RawPIcontrol(:,3)];
plot(PIcontrol(1:100, 1), PIcontrol(1:100, 2), PIcontrol(1:100, 1), PIcontrol(1:100, 3));

legend("y(t) simulink", "u(t) simulink", "y(t) experiment", "u(t) experiment")
xlabel("Time [s]")
ylabel("Magnitude")
title("Digital PI Control for 2.5 Step Input. Phi=70, Woc=2")






