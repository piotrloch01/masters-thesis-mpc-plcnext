% Parametry układu
Ts = 0.5; % okres probkowania regulatora        
H_max = 0.382; % maksymalna wysokosc zbiornika      
At = 0.149 * 0.149; % pole powierzchni swobodnej zbiornikow

%% Macierze modelu zlinearyzowanego
Ad = [0.999436756659707,  4.474592260672250e-04; 
      4.474592260672250e-04,  0.997778655174822];

Bd = [2.543874254777753e-05, -4.311599938606081e-06; 
      5.701217675515939e-09,  4.308018603241678e-06];
      
Cd = [1 0; 0 1];
Dd = [0 0; 0 0];

% Obiekt modelu dyskretnego
plant_d = ss(Ad, Bd, Cd, Dd, Ts);

%% Konfiguracja regulatora
mpc_obj = mpc(plant_d, Ts);

% Ograniczenia wartości regulowanych
mpc_obj.OV(1).Min = 0.15 * H_max;   mpc_obj.OV(1).Max = 0.9 * H_max; % Poziom h1
mpc_obj.OV(2).Min = 0.15 * H_max;   mpc_obj.OV(2).Max = 0.9 * H_max; % Poziom h2
mpc_obj.OV(1).MinECR = 0.02;         mpc_obj.OV(1).MaxECR = 0.02; % 0.02/0.382 = ok. 5% zakresu zmiennych
mpc_obj.OV(2).MinECR = 0.02;         mpc_obj.OV(2).MaxECR = 0.02;

% Ograniczenia sygnałów sterujących
mpc_obj.MV(1).Min = 40;             mpc_obj.MV(1).Max = 90;  % Pompa
mpc_obj.MV(2).Min = 30;             mpc_obj.MV(2).Max = 100; % Zawór
mpc_obj.MV(1).MinECR = 0;           mpc_obj.MV(1).MaxECR = 0; % ograniczenia twarde
mpc_obj.MV(2).MinECR = 0;           mpc_obj.MV(2).MaxECR = 0;

% Skalowanie zmiennych
mpc_obj.OV(1).ScaleFactor = mpc_obj.OV(1).Max - mpc_obj.OV(1).Min; 
mpc_obj.OV(2).ScaleFactor = mpc_obj.OV(2).Max - mpc_obj.OV(2).Min; 
mpc_obj.MV(1).ScaleFactor = mpc_obj.MV(1).Max - mpc_obj.MV(1).Min;
mpc_obj.MV(2).ScaleFactor = mpc_obj.MV(2).Max - mpc_obj.MV(2).Min;

% Ograniczenie tempa zmiany sterowania u_v
mpc_obj.MV(2).RateMax = Ts*0.7; % 0.35% zakresu
mpc_obj.MV(2).RateMin = Ts*(-0.7); %-0.35%/Ts
mpc_obj.MV(2).RateMaxECR = 0.005;
mpc_obj.MV(2).RateMinECR = 0.005; % ok. 1.5% dopuszczalnego przyrostu

% Ograniczenie tempa zmiany sterowania u_p
mpc_obj.MV(1).RateMax = 20; % 20% zakresu;
mpc_obj.MV(1).RateMin = -20;
mpc_obj.MV(1).RateMaxECR = 0.3; % 1.5% dopuszczalnego przyrostu
mpc_obj.MV(1).RateMinECR = 0.3;

% Horyzonty
mpc_obj.PredictionHorizon = 75; 
mpc_obj.ControlHorizon = 3;

% Wagi
mpc_obj.Weights.ManipulatedVariables = [0 0];
mpc_obj.Weights.ManipulatedVariablesRate = [5 5];
mpc_obj.Weights.OutputVariables = [0.4 0.6]

% Eliminacja błędu statycznego
setoutdist(mpc_obj, 'Integrators');

%% Inicjalizacja stanu początkowego
xmpc = mpcstate(mpc_obj);

% Wartości początkowe wielkości regulowanych
xmpc.Plant = [0.5*H_max; 0.5*H_max]; 

% Ostanie sterowanie
xmpc.LastMove = [65; 70];
%xmpc.LastMove = [60; 72];