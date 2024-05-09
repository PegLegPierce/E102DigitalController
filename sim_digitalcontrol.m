function [yout, tout, info, K, Kr, L] = sim_digitalcontrol(Q11, Q22);

Ts = 0.1;

% Define matrices

A = [
    -2.5, -1;
    1, 0
];

B = [
    1; 0
];

C = [
    0, 1
];

D = [
    0
];


% Calculate system
sysc = ss(A, B, C, D);
sysd = c2d(sysc, Ts);

% Extract Ad, Bd, Cd, and Dd
Ad = sysd.A;
Bd = sysd.B;
Cd = sysd.C;
Dd = sysd.D;

% Optimize using dlqr

R = 1/2*1;
N = 1/2*[0; 0];
Q = 1/2*[Q11, 0;
    0, Q22];

[K, S, e] = dlqr(Ad, Bd, Q, R);

Kr = 1 / ((-Cd-Dd*K)*(inv(eye(2)-Ad+Bd*K)*Bd)+Dd);

Adc = Ad - Bd*K;
Bdc = Bd * Kr;
Cdc = Cd - Dd*K;
Ddc = Dd * Kr;

con_poles = eig((Adc));
obs_poles = con_poles / 2;

L = place(Adc', Cdc', obs_poles)';

% Call simulink model and output statistics

h = load_system("con_obs_sys.mdl");
hws = get_param(bdroot,'modelworkspace');
hws = get_param('con_obs_sys','modelworkspace');
list = whos;
N = length(list);
for i = 1:N
    hws.assignin(list(i).name,eval(list(i).name))
end
sim("con_obs_sys.mdl");
info = stepinfo(yout(:,1),tout,"SettlingTimeThreshold",0.01);




