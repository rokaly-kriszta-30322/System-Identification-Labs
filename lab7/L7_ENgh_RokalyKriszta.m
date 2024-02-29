%% setting m (3 or 10)
m=10;
%% setting the a-s for the m of our choosing
a=zeros(1,m); % vector of 0s then changing the needed ones to 1
if m==3
    a(1)=1;
    a(3)=1;
end
if m==4
    a(1)=1;
    a(4)=1;
end
if m==5
    a(2)=1;
    a(5)=1;
end
if m==6
    a(1)=1;
    a(6)=1;
end
if m==7
    a(1)=1;
    a(7)=1;
end
if m==8
    a(1)=1;
    a(2)=1;
    a(7)=1;
    a(8)=1;
end
if m==9
    a(4)=1;
    a(9)=1;
end
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
for k=1:200
    
    u=C*x'; % u for the current k built with the previous x 
    x=mod((A*x'),2)'; % overwriting x
    a1=-0.7;
    b=0.7;
    if m==3
        u1(k)=a1+(b-a1)*u; % building the u1 vector element by element
    end
    if m==10
        u2(k)=a1+(b-a1)*u; % building the u2 vector element by element
    end
    
end
%% using DC motor from here
%% building final u that will be used by the motor
u0 = zeros(10, 1);
us = 0.4*ustep(70); % using the function from the archive
final_u = [u0' u1 u0' u2 u0' us'];
Ts=10e-3;
%% running the motor and saving the data
[vel, alpha, t] = run(final_u, '4', Ts); % run function from archive
plot(t, vel); % to see if motor works well
% vel=[y0 y1 y0 y2 y0 yval] - form of vel
save data1.mat vel alpha t final_u
%% cutting out the ys from vel
y1=vel(12:211); % cutting y1 from vel - 200 values
y2=vel(221:420); % cutting y2 from vel - 200 values
yval=vel(431:length(vel)); % cutting yval from vel - 80 values
%% checking if works and tuning
id=iddata(y1',u1',Ts); % building id for y1 and u1
model=arx(id,[4 4 1]); % tuning
compare(model,id); 

figure;
id2=iddata(y2',u2',Ts); % for y2 and u2
model=arx(id2,[30 30 1]); % tuning
compare(model,id2);

figure;
val=iddata(yval',us,Ts); % for yval and us
model=arx(val,[4 4 1]); % tuning
compare(model,val);