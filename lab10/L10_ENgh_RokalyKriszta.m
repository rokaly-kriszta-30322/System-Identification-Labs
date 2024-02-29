%% calculating u_id
us = 0.3*ustep(70);
u0 = zeros(20, 1);
u_val = [u0' us' u0'];
u_id = idinput(200,'prbs',[],[-0.8 0.8]);
%% tune
na=2;
nb=2;
%% obj for motor
obj=DCMRun.start("Ts",10e-3); % from archive
%% with motor getting y_val
for k = 1:length(u_val)
    obj.wait(); % from archive
    y_val(k)= obj.step(u_val(k)); % from archive
end
%% originally needed when building y_val to stop the motor after
% obj.stop(); - commented cause the motor is needed later for the big for
%% plotting to see if correct
plot(u_val);
plot(y_val);
%% saving data if correct
save data10.mat u_val u_id y_val
%% initialising
Theta=zeros(na+nb,1); % column vector
P=zeros(na+nb,na+nb); % square matrix
for i=1:na+nb % for P0
    for j=1:na+nb
        if i==j
            P(i,j)=1000; % 1000 on the diagonal
        end
    end
end
%% big for
phi=zeros(200,na+nb);
for k=1:length(u_id)
    obj.wait();
    y_id(k)= obj.step(u_id(k)); % getting y_id with motor
    for j = 1:na % building phi with ARX
        if k<=j
            phi(k,j)=0;
        else
            phi(k,j) = -y_id(k-j);
        end
    end
    for j = 1:nb
        if k<=j
            phi(k,j)=0;
        else
            phi(k,j+na) = u_id(k-j);
        end
    end
    % pseudo code
    e=y_id(k)-phi(k,:)*Theta; % overwriting e for each k
    P=P-(P*phi(k,:)'*phi(k,:)*P)/(1+phi(k,:)*P*phi(k,:)'); % overwriting P for each k
    W=P*phi(k,:)'; % overwriting W for each k
    Theta=Theta+W*e; % overwriting Theta for each k
    obj.wait();
end
obj.stop(); % stopping motor
%% building model for compare
Ts=10e-3;
model=idpoly([1 Theta(1:na)'],[0 Theta(na+1:na+nb)'],[],[],[],0,Ts); % writing A and B directly
val=iddata(y_val',u_val',10e-3); % for compare
compare(val,model);