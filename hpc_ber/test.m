train_sc = 2.^(3:19);
tap_sc = 2:10;
step_sc = linspace(0.0001,0.01,20);
for i = tap_sc
	if i == 2
		scan = combvec(i,1:(i-1),train_sc,step_sc);
	else
		scan = [scan combvec(i,1:(i-1),train_sc,step_sc)];
	end
end
size(scan)

