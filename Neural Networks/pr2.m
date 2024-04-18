clc, clear, close all
rng(200)

%% Ucitavanje
pod=readtable('Weather.csv');
pod.RainTomorrow=categorical(pod.RainTomorrow);
pod.RainTomorrow=renamecats(pod.RainTomorrow,{'Yes', 'No'}, {'1', '0'});
pod.RainTomorrow=str2double(string(pod.RainTomorrow));

pod.RainToday=categorical(pod.RainToday);
pod.RainToday=renamecats(pod.RainToday,{'Yes', 'No'}, {'1', '0'});
pod.RainToday=str2double(string(pod.RainToday));


izlaz=pod.RainTomorrow;
izlaz=izlaz';
a1=findgroups(pod.WindGustDir);
a2=findgroups(pod.WindDir9am);
a3=findgroups(pod.WindDir3pm);

pod.WindGustDir=a1;
pod.WindDir9am=a2;
pod.WindDir3pm=a3;
ulaz=[pod.MinTemp,	pod.MaxTemp,	pod.Rainfall,	pod.WindGustDir,	pod.WindGustSpeed,	pod.WindDir9am,	pod.WindDir3pm,	pod.WindSpeed9am,	pod.WindSpeed3pm,	pod.Humidity9am,pod.Humidity3pm,	pod.Pressure9am,	pod.Pressure3pm,	pod.Temp9am,	pod.Temp3pm,	pod.RainToday];
ulaz=ulaz';
%% Histogram
figure
histogram(izlaz);
%% Podela na klase
K1 = ulaz(:, izlaz == 1);
K2 = ulaz(:, izlaz == 0);
figure, hold all
plot(K1(1, :), K1(2, :), 'o')
plot(K2(1, :), K2(2, :), '*')

%% Izdvajanje trening, test i val skupa za svaku prvu klasu
N1 = length(K1);
K1trening = K1(:, 1 : 0.7*N1);
K1test = K1(:, 0.7*N1+1 : 0.85*N1);
K1val = K1(:, 0.85*N1+1 : N1);

%% Izdvajanje trening, test i val skupa za svaku drugu klasu
N2 = length(K2);
K2trening = K2(:, 1 : 0.7*N2);
K2test = K2(:, 0.7*N2+1 : 0.85*N2);
K2val = K2(:, 0.85*N2+1 : N2);
%% Formiranje zajednockog trening, test i val skupa
ulazTrening = [K1trening, K2trening];
izlazTrening = [ones(1,0.7*N1), zeros(1, 0.7*N2)];

ind = randperm(length(izlazTrening));
ulazTrening = ulazTrening(:, ind);
izlazTrening = izlazTrening(ind);

ulazTest = [K1test, K2test];
izlazTest = [ones(1, 0.15*N1), zeros(1, 0.15*N2)];

ulazVal = [K1val, K2val];
izlazVal = [ones(1, 0.15*N1), zeros(1, 0.15*N2)];

%% Formiranje skupa koji ce se prosledidi NM za treniranje (sadrzi validaciju)
ulazSve = [ulazTrening, ulazVal];
izlazSve = [izlazTrening, izlazVal];

