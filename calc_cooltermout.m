%% State Space
clear
clf
Ts = 0.1;
ref = 2.5;
Q11 = 10;
Q22 = 1000000;
max_index = 101;
[yout, tout, info, K, Kr, L] = sim_digitalcontrol(Q11, Q22);

% RawObscontrol = importdata('obs_q11of100_q22of1.txt');
% RawObscontrol = importdata('q11_1_q22_1.txt');
RawObscontrol = importdata('q11_1_q22_100.txt');
data_re = [RawObscontrol(:,1)*Ts RawObscontrol(:,2) RawObscontrol(:,3)];
hold on
plot(tout(1:max_index), yout(1:max_index,:))
plot(data_re(1:max_index, 1), data_re(1:max_index, 2:3));
realinfo = stepinfo(data_re(:,2),data_re(:,1),"SettlingTimeThreshold",0.01);
ts = realinfo.SettlingTime
os = realinfo.Overshoot
settle = realinfo.SettlingMax;
sse = (ref-settle)/ref
U = mean(settle-data_re(:,2))*length(data_re)

legend("y(t) simulink", "u(t) simulink", "y(t) experiment", "u(t) experiment")
xlabel("Time [s]")
ylabel("Voltage [V]")
title("Observer for Q11 "+num2str(Q11)+" and Q22 "+num2str(Q22))