%% plot of id and val to see shape
figure;
plot(val.X, val.Y, 'b');
hold on;
plot(id.X, id.Y, 'r');

%% phi, theta and mse calculations
mse_vec = [];

for n=1:20 %for the mse

    for i = 1:length(id.X) %for phi of the id
        for j = 1:n
            phi(i,j) = id.X(i).^(j-1);
        end
    end

    Theta=phi\transpose(id.Y); %theta for the id

    for i = 1:length(val.X) %phi for the val
        for j = 1:n
            phi_val(i,j) = val.X(i).^(j-1);
        end
    end
    
    Y_hat = phi_val*Theta; %approximation of Yval
    
    mse = 0;

    for i = 1:length(val.X) %for the sum
        mse = mse + (1/length(val.X))*(val.Y(i)-Y_hat(i)).^2;
    end
    
    mse_vec = [mse_vec mse]; %adds value to vector

end

%% plotting Y and approximation of Y
figure;
plot(val.X, val.Y, 'b');
hold on;
plot(val.X, Y_hat, 'r');

%% plotting the mse against n
figure;
plot(mse_vec);


