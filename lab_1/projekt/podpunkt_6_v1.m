% Optymalizacja wskaznika jakosci dla PID lub DMC

clear all;

reg=1;          % regulator: 0-PID, 1-DMC
x0=[20, 3, 1];     % [K, Ti, Td] lub [N, Nu, lambda]

if reg==0
    lb=[0, 0, 0];   % K>=0, Ti>=0, Td>=0
    ub=[Inf, Inf, Inf];
end    

if reg==1
    D=170;
    lb=[1, 1, 0]; % N>=1, Nu>=1, lambda>=0
    ub=[D, D, Inf]; % N<=D, Nu<=D
end

f=@(x)podpunkt_5_v1(x,reg);
x = fmincon(f, x0, [], [], [], [], lb, ub);

if reg==1
x(1)=floor(x(1));   % N jest naturalne
x(2)=floor(x(2));   % Nu jest naturalne
end

disp("Uzyskane parametry:");
disp(x);