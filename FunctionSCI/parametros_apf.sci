// Parâmetros do robô
l = 0.099; // distância entre as rodas
r = 0.033; // raio das rodas
// Parâmetros do APF
etta = 1; // constante de repulsão //era 1
xi   = 4; // constante de atração
ro_o = 1; // raio de influência do campo repulsivo //era 1
a_max= 2;
a_min = 1;
F_v  = [0 0];
sig  = 1;
alpha= 0;
// Parâmetros do controlador
kr   = 5; // ganho da roda direita
kl   = 5; // ganho da roda esquerda
vel_min = 4;

precisao = 0.05;



