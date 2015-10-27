
% Analysing new weather data

path_to_dataBase = 'C:\Users\gardhi\Documents\Bhutan Project\matlab-microgrid-components\dataBase\';
irr = importdata([path_to_dataBase, 'NewData_solar_rad_watm2.mat']);                       % Use \ for Windows and / for Mac and Linux

t = 0:length(irr)-1;
plot(t,irr);
