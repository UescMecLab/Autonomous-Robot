#include <digitalWriteFast.h>
#include <PID_v1.h>
#include <AFMotor.h>
#include <stdio.h>
#include <Utility.h>

// -*- Controle de Velocidade -*-
AF_DCMotor motorD(2);             //Seleciona o motor direito na porta 2
AF_DCMotor motorE(1);             //Seleciona o motor esquerdo na porta 1


int SGD = 32, SGE = 33;         //Pinos do Arduino conectados ao encoder
int contE = 0, contD = 0;
double RadD = 0, RadE = 0; // Velocidade em rad/s
int RD1 = 0, RE1 = 0;         // Primeiros valores lidos pelo encoder
int RD2 = 0, RE2 = 0;

unsigned long t0 =0, treal = 0;
unsigned long t = 0; unsigned long told = 0;  // Tempo real 
unsigned long tnew = 0, tRPI = 350000, espera = 0; // em us
double tvel = 50000;
double tPID = 100000;      // Periodo de amostragem tPID em us
int constLoop = 10; // constLoop = tRPI/tPID - tempo de comunicaçao
unsigned long tserial = tRPI - tPID*constLoop;
unsigned long esperaTot = 0, toldTot = 0;

// -*- PID -*-
double Kpe = 3, Kie = 8.5, Kde = 0;   // Ganhos da roda esquerda
double Kpd = 3, Kid = 8.3, Kdd = 0;   // Ganhos da roda direita
double SetpointD = 0, InputD = 0, EsfControleD=0,  SetpointE = 0, InputE = 0, EsfControleE=0; //  Variaveis relacionadas ao PID
double EsfControleD2 = 0, EsfControleE2 =0;

double EsfMinOND = 120, EsfMinOFFD = 200,EsfMinONE =120, EsfMinOFFE =180, velMinD = 0.8, velMinE = 0.8; // Valores minimos para que o robo nao pare
double fatorD = 1, fatorE = 1 ;

PID myPIDe(&InputE, &EsfControleE, &SetpointE, Kpe, Kie, Kde, DIRECT); // Declaraçao do PID esquerdo
PID myPIDd(&InputD, &EsfControleD, &SetpointD, Kpd, Kid, Kdd, DIRECT); // Declaraçao do PID direito


int para = 1;
void setup() {
   Serial.begin(9600);
   //Serial.setTimeout(20000);

  motorD.setSpeed(0);
  motorE.setSpeed(0);
  
  // Parametros PID
  myPIDd.SetOutputLimits(-255, 255); myPIDe.SetOutputLimits(-255, 255);
  myPIDd.SetSampleTime(100); myPIDe.SetSampleTime(100);
  myPIDd.SetMode(AUTOMATIC); myPIDe.SetMode(AUTOMATIC);
  SetpointE = 0; SetpointD = 0;
  
  // Limpa buffer
  //Serial.flush();
  
}

void loop() {

  SetpointD = 8;
  SetpointE = 8;
  motorD.run(FORWARD);
  motorE.run(FORWARD);
    while (para == 1){

    t0 = micros();
    treal = (micros() - t0);
    while (treal <50000){
      RE1 = digitalRead(SGE);
      if(RE1 != RE2){
        RE2 = RE1;
        contE ++;
      }
      RD1 = digitalRead(SGD);
      if(RD1 != RD2){
        RD2 = RD1;
        contD ++;
      }
      treal = (micros() - t0);
    }//while t < 5000
   
   RadE =(contE * 65449.847) / (treal*33.5);
   RadD =(contD * 65449.847) / (treal*33.5);

  contD = 0;
  contE = 0;

     // -*- PID -*-
     InputD = RadD;
     InputE = RadE;
     
     //Serial.println("DADOS DE ENTRADA");
     //Serial.println("InputD = "+String(InputD));
     //Serial.println("InputE = "+String(InputE));

     //Serial.println("PID PROCESSANDO");
     myPIDd.Compute(); myPIDe.Compute();
     //Serial.println("PID computado");
    //Serial.println("EsfControleE2 = "+String(EsfControleE2));
    //Serial.println("EsfControleD2 = "+String(EsfControleE2));

    //Serial.println("EsfControleE  ="+String(EsfControleE));
    //Serial.println("EsfControleD = "+String(EsfControleD));
    
     //Escreve nos motores
    Serial.println(RadD);
    motorD.setSpeed(EsfControleD); motorE.setSpeed(EsfControleE);
}

}
