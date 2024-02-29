%% First order
% code to plot the input and output
u1=data.InputData;
y1=data.OutputData;
plot(t,u1);
hold on;
plot(t,y1);

% initial data
y1ss=3; %from graph
u1ss=2; %from graph

% calculations
K = y1ss/u1ss;
y1_max = 4;
yt2 = y1ss+(y1_max-y1ss)*0.368
figure;
plot(t,y1); %read t2 from here
hold on;
t2=5.209;
t1=3.72; %from graph
T=t2-t1; %from graph

% transfer function of order 1
A=-1/T;
B=K/T;
C=1;
D=0;
Hss1=ss(A,B,C,D)

% validation
figure;
y_hat1=lsim(Hss1,u1,t,y1ss);
plot(t,y_hat1);
hold on;
plot(t,y1);
hold on;
plot(t,u1);

% mse
y_hat1=lsim(Hss1,u1,t,y1ss);
mse1 = 1/length(t)*sum((y1-y_hat1).^2)

%% Second order
% plot of the input and output
u2=data.InputData;
y2=data.OutputData;
plot(t,u2);
hold on;
plot(t,y2);

% initial data
y2ss=0.5; %from graph
u2ss=1; %from graph

% calculations
K = y2ss/u2ss;
t00 = 2.70; %from graph
t01 = 3.75; %from graph
t02 = 4.85; %from graph
t1=3.15; %from graph
t3=5.4; %from graph
Ts=data.Ts; %from dataset
k00 = t00/Ts;
k01 = t01/Ts;
k02 = t02/Ts;
k1 = k00:k01;
k2 = k01:k02;
Amc = 0;
Apc = 0;
for k = k00:k01
    Apc = Apc + y2(round(k))-y2ss;
end
for k = k01:k02
    Amc = Amc + y2ss-y2(round(k));
end
Am=Ts*Amc;
Ap=Ts*Apc;
M = Am/Ap;
zeta = (log(1/M))/(sqrt(pi.^2+(log(M)).^2));
T0=t3-t1;
wn=(2*pi)/(T0*sqrt(1-zeta.^2));

% TF of order 2
A=[0 1; -wn.^2 -2*zeta*wn];
B=[0; K*wn.^2];
C=[1 0];
D=0;
Hss2=ss(A,B,C,D)

% validation
figure;
y_hat2=lsim(Hss2,u2,t,[y2ss 0]);
plot(t,y_hat2);
hold on;
plot(t,y2);
hold on;
plot(t,u2);

% mse
y_hat2=lsim(Hss2,u2,t,[y2ss 0]);
mse2 = 1/length(t)*sum((y2-y_hat2).^2)