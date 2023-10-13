#include <PID_v1.h>
#include <AFMotor.h>
#include <stdlib.h>
#include <LiquidCrystal_I2C.h>


LiquidCrystal_I2C lcd(0x3F,16,2); 

//---Controle de Velocidade

AF_DCMotor motorD(2);             //Seleciona o motor direito na porta 2
AF_DCMotor motorE(1);             //Seleciona o motor esquerdo na porta 1

int ps2D = 32, ps2E = 33;         //Pinos do Arduino conectados ao encoder
int countE = 0, countD = 0;
double velD = 0, velE = 0; // Velocidade em rad/s
int s1D = 0, s1E = 0;          // Primeiros valores lidos pelo encoder

unsigned long tvel = 50000; //Intervalo de amostragem do encoder
unsigned long t0 =0, t =0; //marcador de inicio de tempo e variável de controle do tempo
unsigned long tOP = 0; // marca o tempo total de processamento 
 
 //---Odometria
double r=0.034; //raio em metros
double l=0.147; //comprimento em metros
double x0=0, y0 = 0, theta0 = 0; //posição inicial
double x=0, y = 0, theta=0; //posição atual

//---PID

double Kpe = 3, Kie = 8.5, Kde = 0;   // Ganhos da roda esquerda
double Kpd = 3, Kid = 8.3, Kdd = 0;   // Ganhos da roda direita

double SetpointD = 0, InputD = 0, EsfControleD=0,  SetpointE = 0, InputE = 0, EsfControleE=0; //  Variaveis relacionadas ao PID

PID myPIDe(&InputE, &EsfControleE, &SetpointE, Kpe, Kie, Kde, DIRECT); // Declaraçao do PID esquerdo
PID myPIDd(&InputD, &EsfControleD, &SetpointD, Kpd, Kid, Kdd, DIRECT); // Declaraçao do PID direito

 
 
 //---Comunicação
 String recebido = "";
 String outD_str = "";
 String outE_str = "";
double outD = 0;
double outE = 0;
int index=0;

int parar = 1; //variável de saída de laço
void setup() {
  Serial.begin(115200);
  motorD.setSpeed(0);
  motorE.setSpeed(0);


  lcd.init();
  lcd.clear();

    // Parametros PID
  myPIDd.SetOutputLimits(0, 255); myPIDe.SetOutputLimits(0, 255);
  myPIDd.SetSampleTime(100); myPIDe.SetSampleTime(100);
  myPIDd.SetMode(AUTOMATIC); myPIDe.SetMode(AUTOMATIC);
  
}


void loop() {
  motorD.run(FORWARD);
  motorE.run(FORWARD);
  lcd.backlight();
  while (parar == 1){

    Serial.write(2);
    Serial.print(x);Serial.print(",");
    Serial.print(y);Serial.print(",");
    Serial.print(theta);
    Serial.write(3);

    lcd.setCursor(0, 0);
    lcd.print("Enviou");
    for (int i =0; i<5; i++){
    //envio 
    t0 = micros();
    t = micros()-t0;
    while(t<tvel){
      int s2D = digitalRead(ps2D);
      if(s2D != s1D){
        s1D = s2D;
        countD ++;
      }//if s2D
      int s2E = digitalRead(ps2E);
      if(s2E != s1E){
        s1E = s2E;
        countE ++;
      }// if s2E
      t = micros() - t0;

    }// while tvel
    velD = (countD * 65449.847) / (t*33.5);
    velE = (countE * 65449.847) / (t*33.5);
    countD = 0; countE = 0;

//PID


    InputE = velE; InputD = velD;
    SetpointE = outE; SetpointD = outD;

    myPIDd.Compute(); myPIDe.Compute();

    motorD.setSpeed(EsfControleD); motorE.setSpeed(EsfControleE);

    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(outD);
    lcd.setCursor(0,1);
    lcd.print(parar);

//Odometria 
    x    = x0+r/2*t*cos(theta0)*(velD + velE)/1000000;
    y    = y0+r/2*t*sin(theta0)*(velD + velE)/1000000;
    theta = theta0+r/l*t*(velD - velE)/1000000;

    x0 = x;
    y0 = y;
    theta0 = theta;
    tOP = micros() - t0;
    }
    //leitura
    if(Serial.available()>0){
      recebido = leStringSerial();
      index = recebido.indexOf(',');
      outD_str = recebido.substring(0, index);
      outE_str = recebido.substring(index+1);

      outD = atof(outD_str.c_str());
      outE = atof(outE_str.c_str());
    

    }
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("LEU");



  }
    motorD.run(RELEASE);
    motorE.run(RELEASE);
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("FIM!");
}


String leStringSerial(){
  String conteudo = "";
  char caractere;  
  // Enquanto receber algo pela serial
  while(Serial.available() > 0) {
    // Lê byte da serial
    caractere = Serial.read();
    if (caractere == "$"){
      parar = 2;
      break; 
    }
    // Ignora caractere de quebra de linha
    if (caractere != '\n'){
      // Concatena valores
      conteudo.concat(caractere);
    }
    // Aguarda buffer serial ler próximo caractere
    delay(1);
  }  
  return conteudo;
}

