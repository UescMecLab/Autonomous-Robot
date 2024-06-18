cd 'C:\Users\João Vitor\Desktop\UESC\IC\Autonomous-Robot\Otimização\Dados'

dados = [csvread('diagonal.csv'); csvread('retax.csv'); csvread('retay.csv');];

Inputs = dados(:,4:5)';
Posicoes = dados(1:end-1,1:2);
Tempos = dados(:,6)';

X0 = zeros(7,1);
X = X0;

cd 'C:\Users\João Vitor\Desktop\UESC\IC\Autonomous-Robot\Otimização'
%%
%H -> Parametros variáveis [R, L, Ic, Iw, b, Kce,mw,Fs, Fk,alpha_s,  d]
H = [0.0328,    0.099,  0.0002,    0.0002,    0.0150,    0.0109,    0.08,  0.0250,    0.0200,1,  0.01]; %starter
limites(1,:) = [0.035, 0.13,0.01, 0.01, 1, 0.1, 0.2, 0.25, 0.2, 10, 0.03 ]; %Superiores
limites(2,:) = [0.03,  0.070, 0.001, 0.0001, 0, 0.001, 0.01, 0.01, 0.01,0.1 0]; %Inferiores 

%% DE GAbriel

NP = 60;
itMax = inf; 
tempoMax = 10*60;
info = 1;

[Fbest, gbest, it, x] = de(@(j) RMSE(j,Posicoes, Tempos, Inputs, X, X0), limites, H,NP, itMax, tempoMax, info);


%%

