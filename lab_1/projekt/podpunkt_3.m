%Wyznaczamy symulacyjnie odpowiedz skokowa dla procesu

clear;

%Stan ustalony
Upp = 1.1; %sygnal wejsciowy w stanie ustalonym
Ypp = 2; %sygnal wyjsciowy w stanie ustalonym

%Ograniczenia wartosci sygnalu sterujacego
Umin = 0.9;
Umax = 1.3;

Tp = 0.5; %okres probkowania
T = 100; %czas symulacji

T1 = 10; %czas skoku wartosci sygnalu sterujacego
Us = 1.2;
odp_skok;

wy1 = symulacja_obiektu3Y(Upp, Upp, Ypp, Ypp);
wy2 = symulacja_obiektu3Y(Upp, Upp, wy1, Ypp);

U_cale = [Upp, Upp];
Y = [wy1, wy2];

U_p = U_cale(end);
U = Upp;

%Przebieg
for i = 3:(T/Tp)
    if i == T1/Tp
        U = Us;
    end
    
    %Ograniczenia
    if (U < Umin)
        U = Umin;
    elseif (U > Umax)
        U = Umax;
    end
    
    U_cale = [U_cale, U];
    
    Y = [Y, symulacja_obiektu3Y(U, U_p, wy2, wy1)];
    wy1 = wy2;
    wy2 = Y(end);
end

figure;
plot(1:T/Tp, Y)
title("Sygnal wyjsciowy");

figure;
plot(1:T/Tp, U_cale)
title("Sygnal wejsciowy");

figure;
plot(odp_skok)
title("Odpowiedz skokowa");