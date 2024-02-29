% us = 0.2*ustep(70);
% %ur = 0.7*urand(500);
% ur = -0.7 + (0.7-(-0.7)).*rand(500,1);
% u0 = zeros(10, 1);
% u = [u0; ur; u0; us];
% [vel, alpha, t] = run(u, '3', 0.01);
% plot(t, vel);
% data.vel=vel;
% data.alpha=alpha;
% data.t=t;
% data.u=u;

%% verify and move to 0 mean
plot(tid,id.u);
figure;
plot(tid,id.y);
figure;
plot(tval,val.u);
figure;
plot(tval,val.y);
id.u=detrend(id.u);
id.y=detrend(id.y);

%% initial data
N=2499;
M=100;
T=2500;

%% code for ru matrix
ru=zeros(1,N+1);
for tau = 1:(N+1)
    for k = 1:(N+1-tau+1) 
        ru(tau)=ru(tau)+(1/N)*(id.u(k+tau-1)*id.u(k));
    end
end

%% code for ryu matrix
ryu=zeros(1,N+1);
for tau = 1:(N+1)
    for k = 1:(N+1-tau+1)
        ryu(tau)=ryu(tau)+(1/N)*(id.y(k+tau-1)*id.u(k));
    end
end

%% code for Ryu matrix
Ryu=zeros(length(ryu),1);
for i=1:T
    Ryu(i,1)=ryu(i);
end

%% code for Ru matrix
Ru=zeros(T,M);
for i=1:T
    for j=1:M
        if (j>i)
            Ru(i,j)=ru((j-i)+1);
        else
            Ru(i,j)=ru((i-j)+1);
        end
    end
end

%% getting h and y_hat
h=Ru\Ryu;
y_hat_val = conv(val.u,h);
y_hat_id = conv(id.u,h);

%% simulation longer than needed so we cut it off
y_hat_id = y_hat_id(1:length(id.u));
y_hat_val = y_hat_val(1:length(val.u));

%% plotting
figure;
plot(tid,y_hat_id);
hold on;
plot(tid,id.y);
figure;
plot(tval,y_hat_val);
hold on;
plot(tval,val.y);