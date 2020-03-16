%Wyznaczamy symulacyjnie odpowiedz skokowa dla procesu

odp_skok = load('odp_skok.mat');
s = odp_skok.odp_skok;

%Stan ustalony
Upp = 1.1; %sygnal wejsciowy w stanie ustalonym
Ypp = 2; %sygnal wyjsciowy w stanie ustalonym

%Ograniczenia: 0 - wylaczone, 1 - wlaczone
ograniczenia = 1;
%Ograniczenia wartosci sygnalu sterowania
Umin = 0.9;
Umax = 1.3;
%Ograniczenie przyrostu wartosci sygnalu sterowania
dUmax = 0.05;

Tp = 0.5; %okres probkowania
T = 400; %czas symulacji
opoznienie = 11;

%Regulator: 0 - pid, inne - dmc
piddmc = 0;

%Parametry regulatora PID
if(piddmc == 0)
    K = 0.5;
    Ti = 13;
    Td = 3.5;
    r0 = K*(1 + Tp/(2*Ti) + Td/Tp);
    r1 = K*(Tp/(2*Ti) - (2*Td)/Tp - 1);
    r2 = (K*Td)/Tp;
end

%Duze wzmocnienie wprawialo uklad w oscylacje, aby wyeliminowac uchyb
%ustalony trzeba bylo zmniejszyc stala czasowa calkowania

%0.5 40 2.5 -> slabe
%0.5 10 5.5 -> 220
%0.2 10 5.5 -> 230
%0.1 10 5.5 -> 270

%0.5 10 3.5 -> 164
%0.5 12 3.5 -> 140 brak, male przeregulowanie
%0.5 13 3.5 -> 120 mega

%Parametry dobierane przy wart zad 2.1 z punktu pracy

%Parametry regulatora DMC
if(piddmc ~= 0)
    %Horyzonty
    D=length(odp_skok);
    N=length(odp_skok);
    Nu=3;
    
    %Wspolczynnik kary za przyrosty sterowania
    lambda=1;
    
    %Generacja macierzy
    M=zeros(N,Nu);
    for i=1:N
        for j=1:Nu
            if (i>=j)
                M(i,j)=s(i-j+1);
            end
        end
    end
    
    MP=zeros(N,D-1);
    for i=1:N
        for j=1:D-1
            if i+j<=D
                MP(i,j)=s(i+j)-s(j);
            else
                MP(i,j)=s(D)-s(j);
            end
        end
    end
    
    I=eye(Nu);
    K=((M'*M+lambda*I)^-1)*M';
    ku=K(1,:)*MP;
    ke=sum(K(1,:));
end

U_cale = Upp;
dU_cale = 0;
Y = Ypp;

Y_zad = 2.3;
e = Y_zad-Y;

%Opoznienie
for k = 2:opoznienie
    U_cale(k) = Upp;
    dU_cale(k) = U_cale(k)-U_cale(k-1);
    Y(k) = Ypp;
    e(k) = Y_zad-Y(k);
end

U = U_cale(end);

%Przebieg
for k = opoznienie+1:(T/Tp)
    e(k) = Y_zad-Y(k-1);
    %Regulator PID
    if(piddmc == 0)
        dU = r2*e(k-2) + r1*e(k-1) + r0*e(k);
    end
    
    %Regulator DMC
    if(piddmc ~= 0)
        sum = 0;
        for j = 1:D-1
            if(k>j)
                sum = sum + K(1,:)*MP(:, j)*dU_cale(k-j);
            end
        end
        dU = ke*e(k)-sum;
    end
    
    if (ograniczenia)
        %Ograniczenia przyrostu wartosci sygnalu sterowania
        if (dU > dUmax)
            dU = dUmax;
        elseif (dU < -dUmax)
            dU = -dUmax;
        end
    end
    
    U = dU + U_cale(k-1);
    
    if (ograniczenia)
        %Ograniczenia wartosci sygnalu sterowania
        if (U > Umax)
            U = Umax;
        elseif (U < Umin)
            U = Umin;
        end
    end
    
    U_cale(k) = U;
    dU_cale(k) = U_cale(k) - U_cale(k-1);
    Y = [Y, symulacja_obiektu3Y(U_cale(k-10), U_cale(k-11), Y(k-1), Y(k-2))];
end

figure;
stairs(U_cale);
title("Sygnal wejsciowy");

figure;
plot(1:T/Tp, Y);
title("Sygnal wyjsciowy");
