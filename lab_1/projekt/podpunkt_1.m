%Sprawdzamy popprawnosc punktu pracy wyliczajac np. 400 kolejnych wartosci
%wyjscia obiektu (powinny byc takie same - ustalone)

clear;

Upp = 1.1;
Ypp = 2;

Tp = 0.5; %okres probkowania
T = 200; %czas symulacji

wy1 = symulacja_obiektu3Y(Upp, Upp, Ypp, Ypp);
wy2 = symulacja_obiektu3Y(Upp, Upp, wy1, Ypp);

y = [wy1, wy2];

for i = 3:T/Tp
    y = [y, symulacja_obiektu3Y(Upp, Upp, wy2, wy1)];
    wy1 = wy2;
    wy2 = y(end);
end

plot(1:T/Tp, y)

%Mozemy zauwazyc stan ustalony