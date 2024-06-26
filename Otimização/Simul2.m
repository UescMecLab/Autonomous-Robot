clear;
cd 'C:\Users\João Vitor\Desktop\UESC\IC\Autonomous-Robot\Otimização\Dados'
dados = csvread('diagonal.csv');
posicao = dados(:,1:3);
setpoint = dados(:,4:5);
U = setpoint';
tam = size(dados,1);
tempo = dados(:,6)';

X0 = zeros(7,1);
X = X0;
X1 = X0;
T = 0.5;
%%
cd 'C:\Users\João Vitor\Desktop\UESC\IC\Autonomous-Robot\Otimização'
info = csvread('savede.csv');
H =info(1, 3:end);

%H =[0.0300    0.0700    0.0010    0.0079    0.4144    0.0119    0.0586    0.1803    0.1133    4.5622    0.0144];

%%
sim = zeros(size(tempo, 2)-1,2);
tic();
for i = 1:size(tempo, 2)-1
    [~, Xs] = ode45(@(t, X) Modelo_NoLinear2(t, X, U(:, i), H), [tempo(i), tempo(i+1)], X);
    X = Xs(end, :)'; % Atualiza as condições iniciais para a próxima iteração
    sim(i, 1:2) = X(1:2)';
end
 %%
figure;
hold on
plot(posicao(:,1),posicao(:,2), 'b');
plot(sim(:,1), sim(:,2), 'g--');
xlabel('Eixo X');
ylabel('Eixo Y');
title('Posição do Robô');
axis equal; % Mantém a proporção dos eixos
grid on;
