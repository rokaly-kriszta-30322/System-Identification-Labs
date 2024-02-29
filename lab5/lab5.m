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
plot(tid,id.u);
id.u=detrend(id.u);
id.y=detrend(id.y);
N=2500;
M=10;
T=1000;
ru=zeros(1,N);
for tau = 1:N
    for k = 1:(N-tau+1)
        ru(tau)=ru(tau)+(1/N)*(id.u(k+tau-1)*id.u(k));
    end
end

ryu=zeros(1,N);
for tau = 1:N
    for k = 1:(N-tau+1)
        ryu(tau)=ru(tau)+(1/N)*(id.y(k+tau-1)*id.u(k));
    end
end
for i=1:length(T)
    Ryu(i,1)=ryu(i);
end

for i=1:length(T)
    for j=1:length(M)
        Ru(i,j)=ru(1+abs(i-j));
    end
end

h=Ru\Ryu;
y_hat=conv(val.u,h);
y_hat1 = conv(id.u,h);
y_hat1 = y_hat1(1:length(id.u));
y_hat = y_hat(1:length(val.u));
plot(u.id,y_hat1);
figure
plot(val.y,y_hat);