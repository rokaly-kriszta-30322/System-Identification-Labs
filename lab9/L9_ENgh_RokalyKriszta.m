%% setting m
m=10;
%% setting the a-s
a=zeros(1,m); % vector of 0s then changing the needed ones to 1
if m==10
    a(3)=1;
    a(10)=1;
end
%% setting the x0
x=zeros(1,m);
x(1)=1;
%% building the A matrix
for i=1:m
    for j=1:m
        if i==1
            A(i,j)=a(j); % first line
        elseif i==(j+1)
            A(i,j)=1; % unity matrix at a shifted position
        else
            A(i,j)=0; % rest is 0
        end
    end
end
%% building the C matrix
for i=1:m
    if i<m
        C(1,i)=0;
    else
        C(1,i)=1;
    end
end
%% building u(k)
for k=1:300
    
    u=C*x'; % u for the current k built with the previous x 
    x=mod((A*x'),2)'; % overwriting x
    a1=-0.8;
    b=0.8;
    u2(k)=a1+(b-a1)*u; % building the u2 vector element by element
    
end
%% building final u that will be used by the motor
u0 = zeros(10, 1);
us = 0.3*ustep(70); % using the function from the archive
u_DC = [u0' u2 u0' us'];
%% running the motor and saving the data
% Ts=10e-3;
% [vel, alpha, t] = run(u_DC, '6', Ts); % run function from archive
% plot(t, vel); % to see if motor works well
% save lab9.mat vel alpha t u_DC
%% getting id and val inputs and outputs
u_id=u_DC(11:310);
u_val=u_DC(321:length(u_DC));
y_id=vel(11:310);
y_val=vel(321:length(vel));
%% make id and val
Ts=10e-3; % sampling period
id=iddata(y_id',u_id',Ts);
val=iddata(y_val',u_val',Ts);
%% tuning
na=3;
nb=3;
nk=2;
model=arx(id,[na nb nk]);
compare(model,id);
%% getting A and B -> Theta
A=model.A(2:end);
B=model.B(2:end);
Theta=[model.A(2:end),model.B(2:end)]; % skipping the first elements of A and B
%% building phi - ARX code
for i = 1:length(id.u) % number of rows
    for j = 1:length(A) % for the first A columns
        if i<=j
            phi(i,j)=0;
        else
            phi(i,j) = id.y(i-j);
        end
    end
    for j = 1:length(B) % for the next B columns
        if i<=j
            phi(i,j)=0;
        else
            phi(i,j+length(A)) = id.u(i-j);
        end
    end
end
%% creating z_sim
for k=1:length(id.y)
    z_sim(k)=phi(k,:)*Theta'; % z_sim line by line
end
%% building Z - ARX code
Z=zeros(300,na+nb);
for i=1:length(id.y) % number of rows
    for j = 1:na % for the first na columns
        if i<=j
            Z(i,j)=0;
        else
            Z(i,j) = -z_sim(i-j);
        end
    end
    for j = 1:nb % for the next nb columns
        if i<=(j+nk-1)
            Z(i,j+na)=0;
        else
            Z(i,j+na) = id.u(i-nk-j+1);
        end
    end
end
%% building fiv - ARX code
for i = 1:length(id.u)
    for j = 1:na % for the first na columns
        if i<=j
            fiv(i,j)=0;
        else
            fiv(i,j) = id.y(i-j);
        end
    end
    for j = 1:nb % for the next nb columns
        if i<=(j+nk-1)
            fiv(i,j+na)=0;
        else
            fiv(i,j+na) = id.u(i-nk-j+1);
        end
    end
end
%% calculating PHI
PHI=0;
for k = 1:length(id.u) % for artificial sum
    PHI=PHI+(1/(300-nk+1))*Z(k,:)*fiv(k,:)'; % multiplying line with column for a scalar
end
%% calculating Y
Y=0;
for k = 1:length(id.u) % for artificial sum
    Y=Y+(1/(300-nk+1))*Z(k,:)*id.y(k,:)'; % multiplying line with column for a scalar
end
%% calculating THETA with left division
THETA=PHI\Y;
%% buid model to compare to val
Ts=10e-3; % sampling period
model=idpoly([1,A],[zeros(1,nk) B],[],[],[],0,Ts);
figure;
compare(model,val);