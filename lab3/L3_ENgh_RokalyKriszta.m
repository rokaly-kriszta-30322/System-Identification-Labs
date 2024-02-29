%% First order
% code to plot the input and output
u1=data.InputData;
y1=data.OutputData;
plot(t,u1);
hold on;
plot(t,y1);

% initial data
y1ss=8; %from graph
u1ss=2; %from graph
u10=0; %from graph
y10=0; %from graph

% calculations
K = (y1ss-y10)/(u1ss-u10);
yT = (y1ss-y10)*0.63
figure;
plot(t,y1); %read T from here
hold on;
T=0.502; %from graph

% transfer function of order 1
Hf1=tf(K, [T 1]);

% validation
u1_35=u1(201:500);
t1_35=t(201:500);
figure;
lsim(Hf1,u1_35,t1_35);
hold on;
plot(t,y1);

% mse
y1_35=y1(201:500);
y_hat1=lsim(Hf1,u1_35,t1_35);
mse1 = 1/length(t1_35)*sum((y1_35-y_hat1).^2)

%% Second order
% plot of the input and output
u2=data.InputData;
y2=data.OutputData;
plot(t,u2);
hold on;
plot(t,y2);

% initial data
y2ss=12; %from graph
u2ss=3; %from graph
u20=0; %from graph
y20=0; %from graph

% calculations
K = (y2ss-y20)/(u2ss-u20);
yt1 = 15; %from graph
M = (yt1-y2ss)/y2ss;
zeta = (log(1/M))/(sqrt(pi.^2+(log(M)).^2));
t1=1.7; %from graph
t3=5; %from graph
T0=t3-t1;
wn=(2*pi)/(T0*sqrt(1-zeta.^2));

% TF of order 2
den=K*wn.^2;
Hf2=tf(den, [1 2*zeta*wn wn.^2]);

% validation
u2_35=u2(201:500);
t2_35=t(201:500);
figure;
lsim(Hf2,u2_35,t2_35);
hold on;
plot(t,y2);

% mse
y2_35=y2(201:500);
y_hat2=lsim(Hf2,u2_35,t2_35);
mse2 = 1/length(t2_35)*sum((y2_35-y_hat2).^2)