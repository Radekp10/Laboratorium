%Wyznaczamy symulacyjnie odpowiedz skokowa dla procesu

clear;

%Stan ustalony
Upp = 1.1; %sygnal wejsciowy w stanie ustalonym
Ypp = 2; %sygnal wyjsciowy w stanie ustalonym

%Ograniczenia wartosci sygnalu sterowania
Umin = 0.9;
Umax = 1.3;

Tp = 0.5; %okres probkowania
T = 100; %czas symulacji
opoznienie = 11;

Ts = 10; %czas skoku wartosci sygnalu sterujacego
Us = 1.2;

U_cale = Upp;
Y = Ypp;

%Opoznienie
for k = 2:opoznienie
    U_cale = [U_cale, Upp];
    Y = [Y, Ypp];
end

U = U_cale(end);

%Przebieg
for k = opoznienie+1:(T/Tp)
    if k == Ts/Tp
        U = Us;
    end
    
    %Ograniczenia
    if (U < Umin)
        U = Umin;
    elseif (U > Umax)
        U = Umax;
    end
    
    U_cale = [U_cale, U];
    Y = [Y, symulacja_obiektu3Y(U_cale(k-10), U_cale(k-11), Y(k-1), Y(k-2))];
end

figure;
plot(1:T/Tp, Y*10)
title("Sygnal wyjsciowy");

figure;
stairs(1:T/Tp, U_cale/(Us-Upp)-Upp*10)
title("Sygnal wejsciowy");

%Zakladam ze odpowiedz skokowa ustabilizowala sie przy 190 probce (wartosc po
%ustabilizowaniu 23.18)

odp_skok = (Y(Ts/Tp:190)-Ypp)/(Us-Upp);

figure;
plot(Ts/Tp:190, odp_skok)
title("Odpowiedz skokowa");