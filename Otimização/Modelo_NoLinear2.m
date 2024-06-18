function dX = Modelo_NoLinear2(~,X,U, H)
%X -> Vetor de Estador [x, y, thetta, wd, we, Xed, Xee]
%U -> Entrada [ud; ue]
%H -> Parametros variáveis [R, L, Ic, Iw, b, Kce,mw,Fs, Fk, alpha_s, d]

R = H(1); %0.0328; % Raio das rodas do robô -OTP GABRIEL
L = H(2); % Comprimento do semieixo das rodas do robô -OTP GABRIEL

Ic = H(3); % Momento de inércia total equivalente do robô -OTP GABRIEL
Iw = H(4); % Momento de inércia em torno do eixo de cada roda incluindo motor -OTP GABRIEL

b = H(5); % Coeficiente de atrito viscoso do motor CC -OTP GABRIEL
Kce = H(6);  % Constante de força contra-eletromotriz do motor CC -OTP GABRIEL
Kt = Kce; % Constante de torque do motor CC -OTP GABRIEL
Ra = 23; % Resistencia de armadura total do robô
N = 48; % Relação de engrenagens do motor CC 

mc = 0.572; % Massa da plataforma do robô -OTP GABRIEL
mw = H(7); %0.037; % Massa da roda do robô -OTP GABRIEL

Fs = H(8); % Coistência de armadura do motor CC -OTP GABRIEL
Fk = H(9); % Diferença entre coeficiente de atrito estático e cinético -OTP GABRIEL 
alpha_s = H(10); % Constante de saturação do atrito com o solo 
alpha_k = alpha_s; % Constantes de saturação do atrito com o solo 
d = H(11);
ki = 50; % Ganho Ki
kp = 15; % Ganho Kp


m = mc + 2*mw; %Massa do robô
It = Ic + 2*mw*L^2 + 2*Iw;
g = 9.81; %Aceleracao da gravidade


x_ponto = (R*X(4)*cos(X(3)))/2 + (R*X(5)*cos(X(3)))/2;
y_ponto = (R*X(4)*sin(X(3)))/2 + (R*X(5)*sin(X(3)))/2;
theta_ponto = (R*X(4))/(2*L) - (R*X(5))/(2*L);
wd_ponto = (981*m*(((Fk*tanh(X(4)*alpha_k) - Fs*tanh(X(4)*alpha_s))*(m*L^2*R^2 + 4*Iw*L^2 + It*R^2))/(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4) + (R^2*(- m*L^2 + It)*(Fk*tanh(X(5)*alpha_k) - Fs*tanh(X(5)*alpha_s)))/(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)))/100 + X(5)*((R^2*(- m*L^2 + It)*(b - (Kce*Kt)/Ra))/(N*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) - (Kt*R^2*kp*(- m*L^2 + It))/(Ra*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) + (R^2*d*m*theta_ponto*(m*L^2*R^2 + 4*Iw*L^2 + It*R^2))/(2*L*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4))) - X(4)*((Kt*kp*(m*L^2*R^2 + 4*Iw*L^2 + It*R^2))/(Ra*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) - ((b - (Kce*Kt)/Ra)*(m*L^2*R^2 + 4*Iw*L^2 + It*R^2))/(N*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) + (R^4*d*m*theta_ponto*(- m*L^2 + It))/(2*L*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4))) + (Kt*U(1)*kp*(m*L^2*R^2 + 4*Iw*L^2 + It*R^2))/(Ra*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) + (Kt*X(6)*ki*(m*L^2*R^2 + 4*Iw*L^2 + It*R^2))/(Ra*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) + (Kt*R^2*U(2)*kp*(- m*L^2 + It))/(Ra*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) + (Kt*R^2*X(7)*ki*(- m*L^2 + It))/(Ra*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4));
we_ponto = (981*m*(((Fk*tanh(X(4)*alpha_k) - Fs*tanh(X(4)*alpha_s))*(- m*L^2*R^2 + It*R^2))/(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4) + ((Fk*tanh(X(5)*alpha_k) - Fs*tanh(X(5)*alpha_s))*(m*L^2*R^2 + 4*Iw*L^2 + It*R^2))/(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)))/100 - X(4)*((Kt*kp*(- m*L^2*R^2 + It*R^2))/(Ra*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) - ((b - (Kce*Kt)/Ra)*(- m*L^2*R^2 + It*R^2))/(N*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) + (R^2*d*m*theta_ponto*(m*L^2*R^2 + 4*Iw*L^2 + It*R^2))/(2*L*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4))) + X(5)*(((b - (Kce*Kt)/Ra)*(m*L^2*R^2 + 4*Iw*L^2 + It*R^2))/(N*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) - (Kt*kp*(m*L^2*R^2 + 4*Iw*L^2 + It*R^2))/(Ra*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) + (R^2*d*m*theta_ponto*(- m*L^2*R^2 + It*R^2))/(2*L*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4))) + (Kt*U(1)*kp*(- m*L^2*R^2 + It*R^2))/(Ra*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) + (Kt*X(6)*ki*(- m*L^2*R^2 + It*R^2))/(Ra*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) + (Kt*U(2)*kp*(m*L^2*R^2 + 4*Iw*L^2 + It*R^2))/(Ra*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4)) + (Kt*X(7)*ki*(m*L^2*R^2 + 4*Iw*L^2 + It*R^2))/(Ra*(4*Iw^2*L^2 + 2*m*Iw*L^2*R^2 + 2*It*Iw*R^2 + It*m*R^4));
Xed_ponto = U(1) - X(4);
Xee_ponto = U(2) - X(5);

dX = [x_ponto; y_ponto; theta_ponto; wd_ponto; we_ponto; Xed_ponto;Xee_ponto];


end
