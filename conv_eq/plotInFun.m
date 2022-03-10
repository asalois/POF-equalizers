hold on
s = 1000;
n = 2^9;
d = 14;
plot(inSig(s:n+s))
plot(filtered(s:n+s))
plot(outSig(s:n+s))
legend("Tx","filtered","Rx")
saveas(gcf,"filtered.png")
hold off