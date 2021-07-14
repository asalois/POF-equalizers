clear; clc; close all;

timeForStep = 6;
step = 0.1;
timeTotal = 0;
for i = 1:20
    timeTotal = timeTotal + i / step * timeForStep;
end
timeTotal = timeTotal * 1;

hours = timeTotal/3600
days = hours/24
hoursPlus = mod(hours,24)