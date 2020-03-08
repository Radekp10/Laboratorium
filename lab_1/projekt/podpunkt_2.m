%Wyznaczamy symulacyjnie odpowiedzi skokowe dla procesu, dla kilku zmian
%sygnalu sterowania z uwzglednieniem ograniczen

clear;

%Stan ustalony
Upp = 1.1; %sygnal wejsciowy w stanie ustalonym
Ypp = 2; %sygnal wyjsciowy w stanie ustalonym

%Ograniczenia wartosci sygnalu sterowania
Umin = 0.9;
Umax = 1.3;

Tp = 0.5; %okres probkowania
T = 300; %czas symulacji
opoznienie = 11;

T1 = 20; %czas 1. skoku wartosci sygnalu sterowania
T2 = 80; %czas 2. skoku wartosci sygnalu sterowania
T3 = 140; %czas 3. skoku wartosci sygnalu sterowania
T4 = 200; %czas 4. skoku wartosci sygnalu sterowania

U1 = 0.9;
U2 = 1;
U3 = 1.2;
U4 = 1.3;

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
    switch k
        case T1/Tp
            U = U1;
        case T2/Tp
            U = U2;
        case T3/Tp
            U = U3;
        case T4/Tp
            U = U4;
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
plot(1:T/Tp, Y)
title("Sygnal wyjsciowy");

figure;
stairs(1:T/Tp, U_cale)
title("Sygnal wejsciowy");

figure;
plot([U1, U2, Upp, U3, U4], [Y(T2/Tp-1), Y(T3/Tp-1), Y(T1/Tp-1), Y(T4/Tp-1), Y(T/Tp)])
title("Charakterystyka statyczna");

K_stat = (Y(T/Tp)-Y(T2/Tp-1)) / (U4 - U1);

%Wlasciwosci statyczne i dynamiczne procesu sa w przyblizeniu liniowe
%Wzmocnienie statyczne wynosi 12.3223