%Wyznaczamy symulacyjnie odpowiedzi skokowe dla procesu, dla kilku zmian
%sygnalu sterujacego z uwzglednieniem ograniczen

clear;

%Stan ustalony
Upp = 1.1; %sygnal wejsciowy w stanie ustalonym
Ypp = 2; %sygnal wyjsciowy w stanie ustalonym

%Ograniczenia wartosci sygnalu sterujacego
Umin = 0.9;
Umax = 1.3;

Tp = 0.5; %okres probkowania
T = 300; %czas symulacji

T1 = 20; %czas 1. skoku wartosci sygnalu sterujacego
T2 = 80; %czas 2. skoku wartosci sygnalu sterujacego
T3 = 140; %czas 3. skoku wartosci sygnalu sterujacego
T4 = 200; %czas 4. skoku wartosci sygnalu sterujacego

U1 = 0.9;
U2 = 1;
U3 = 1.2;
U4 = 1.3;

wy1 = symulacja_obiektu3Y(Upp, Upp, Ypp, Ypp);
wy2 = symulacja_obiektu3Y(Upp, Upp, wy1, Ypp);

U_cale = [Upp, Upp];
Y = [wy1, wy2];

U_p = U_cale(end);
U = Upp;

%Przebieg
for i = 3:(T/Tp)
    switch i
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
plot([U1, U2, Upp, U3, U4], [Y(T2/Tp-1), Y(T3/Tp-1), Y(T1/Tp-1), Y(T4/Tp-1), Y(T/Tp)])
title("Charakterystyka statyczna");

grad = gradient([Y(T2/Tp-1), Y(T3/Tp-1), Y(T1/Tp-1), Y(T4/Tp-1), Y(T/Tp)]);

K_stat = mean(grad);

%Wlasciwosci statyczne i dynamiczne procesu sa w przyblizeniu liniowe
%Wzmocnienie statyczne wynosi 1.632