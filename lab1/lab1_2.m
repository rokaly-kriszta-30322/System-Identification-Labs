y=[]
g=[]
e=[]
for x=0:0.25:4
    for i=1:length(x)
        yi=2*exp(-x^2)+2*sin(0.67*x+0.1);
        y=[y yi];
    end
    for i=1:length(x)
        gi=2.2159+1.243*x-2.6002*x.^2+1.7223*x.^3-0.4683*x.^4+0.0437*x.^5;
        g=[g gi];
    end
    e=y-g;
end

x=0:0.25:4;
plot(x,y,'b');
hold on;
plot(x,g,'r');
figure;
plot(e,'g');

mse=(1/length(x))*sum((y-g).^2)
