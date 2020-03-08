%Sprawdzamy popprawnosc punktu pracy wyliczajac np. 400 kolejnych wartosci
%wyjscia obiektu (powinny byc takie same - ustalone)

clear;

%Stan ustalony
Upp = 1.1; %sygnal wejsciowy w stanie ustalonym
Ypp = 2; %sygnal wyjsciowy w stanie ustalonym

%Ograniczenia wartosci sygnalu sterowania
Umin = 0.9;
Umax = 1.3;

Tp = 0.5; %okres probkowania
T = 200; %czas symulacji
opoznienie = 11;

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
    
    %Ograniczenia
    if (U < Umin)
        U = Umin;
    elseif (U > Umax)
        U = Umax;
    end
    
    U_cale = [U_cale, U];
    Y = [Y, symulacja_obiektu3Y(U_cale(k-10), U_cale(k-11), Y(k-1), Y(k-2))];
end

plot(1:T/Tp, Y)

%Mozemy zauwazyc stan ustalony (wartosc wyjscia nie zmienia sie na calym
%przebiegu