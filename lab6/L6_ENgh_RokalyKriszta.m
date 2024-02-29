%% plot to see
plot(id);
figure;
plot(val);
%% initial values
na=30;
nb=30;
k1=125;
k2=315;
N=na+nb;
%% build phi_id
for i = 1:k1
    for j = 1:na
        if i<=j
            phi(i,j)=0;
        else
            phi(i,j) = id.y(i-j);
        end
    end
    for j = 1:nb
        if i<=j
            phi(i,j)=0;
        else
            phi(i,j+na) = id.u(i-j);
        end
    end
end
%% get theta
Theta=phi\id.y;
%% build phi_val
for i = 1:k2
    for j = 1:na
        if i<=j
            phi(i,j)=0;
        else
            phi_val(i,j) = val.y(i-j);
        end
    end
    for j = 1:nb
        if i<=j
            phi(i,j)=0;
        else
            phi_val(i,j+na) = val.u(i-j);
        end
    end
end
%% prediction
%y_pred = phi_val*Theta;
%% simulation failed - overcomplicated prediction
yu_k = zeros(1,N);
for z=1:k2
    for i=1:N
        yu_k(1,i) = phi_val(z,i);
    end
    for j=1:k2
        y_pred(z)=yu_k*Theta;
    end
    yu_k = 0;
end
%% simulation real
y_sim=zeros(1,N);
for k=2:k2
    sum_y=0;
    p_y_sim=0;
    for i=1:na
        if k<=i
            y = 0;
        else
            y = y_sim(k-i);
        end
        sum_y=sum_y+y*Theta(i);
    end
    sum_u=0;
    for j=1:nb
        if k<=j
            u = 0;
        else
            u = val.u(k-j);
        end
        sum_u=sum_u+u*Theta(na+j);
    end
    y_sim(k)=sum_y+sum_u;
end
%%
figure;
plot(y_sim,'r');
hold on;
plot(val.y,'b');
% figure
% plot(y_pred,'g');
% hold on;
% plot(val.y,'b');