x = 0:.001:pi;
y = sin(2*x.^4);

plot(x,y);
xlim([min(x) max(x)]);
xlabel('oœ X');
ylabel('oœ Y');
matlab2tikz('wykres_tex.tex','showInfo', false);