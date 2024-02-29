%%
id=iddata(y_id',u_id',Ts);
plot(id);
figure;
plot(val);
%% setting m
m=10;
% setting the a-s
a=zeros(1,m); % vector of 0s then changing the needed ones to 1
if m==10
    a(3)=1;
    a(10)=1;
end
% setting the x0
x=zeros(1,m);
x(1)=1;
% building the A matrix
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
% building the C matrix
for i=1:m
    if i<m
        C(1,i)=0;
    else
        C(1,i)=1;
    end
end
% building u(k)
for k=1:200
    
    u=C*x'; % u for the current k built with the previous x 
    x=mod((A*x'),2)'; % overwriting x
    a1=-0.7;
    b=0.7;
    u2(k)=a1+(b-a1)*u; % building the u2 vector element by element
    
end
%% building final u that will be used by the motor
u0 = zeros(10, 1);
us = 0.4*ustep(70); % using the function from the archive
u_DC = [u0' u2 u0' us'];
%% running the motor and saving the data
Ts=10e-3;
[vel, alpha, t] = run(u_DC, '4', Ts); % run function from archive
plot(t, vel); % to see if motor works well
save lab8.mat vel alpha t u_DC
%% getting id and val inputs and outputs
u_id=u_DC(11:210); % skip the zeros and take 200 values
u_val=u_DC(221:length(u_DC)); % skip the zeros and until end
y_id=vel(11:210);
y_val=vel(221:length(vel));
%% appointed data
alpha=0.1;
nk=3;
lmax=50;
delta=1e-5;
N=200;
e=zeros(1,N);
%e(1)=0;
%e(2)=0;
Theta=[1;1]; % first line is f second line is b
l=0;
%% pseudo code in actual code
for l=1:lmax % first condition to end the for
    % reinitialise data for next l
    de = zeros(2, N);
    e = zeros(1, N);
    hessian = 0;
    dv = 0;
    for k=1:nk
        de(1,k)=0; % def
        de(2,k)=0; % deb
        e(k)=y_id(k);
    end
    for k=(nk+1):N
        % recursion formulas
        e(k)=y_id(k)+Theta(1,l)*y_id(k-1)-Theta(2,l)*u_id(k-nk)-Theta(1,l)*e(k-1);
        de(1,k)=y_id(k-1)-e(k-1)-Theta(1,l)*de(1,k-1); % for def
        de(2,k)=-u_id(k-nk)-Theta(1,l)*de(2,k-1); % for deb
        dv=dv+2/(N-nk)*e(k)*de(:,k); % dv in the same for loop cause it uses the same structure
        hessian=hessian+2/(N-nk)*de(:,k)*transpose(de(:,k)); % hessian in the same for loop cause it uses the same structure
    end
    Theta(:,(l+1)) = Theta(:,l) - alpha*inv(hessian)*dv;
    if norm(Theta(:,l+1)-Theta(:,l))<=delta % second condition to end the for
        break;
    end
end
%% comparing model and validation data
Ts=10e-3; % sampling period
model=idpoly(1,[zeros(1, nk) Theta(2, l+1)], 1, 1, [1 Theta(1, l+1)], 0, Ts);
val=iddata(y_val',u_val',Ts); % build val to be able to compare the model to it
figure;
compare(model,val);