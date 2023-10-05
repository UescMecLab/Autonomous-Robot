#include <PID_v1.h>
#include <AFMotor.h>
#include <stdlib.h>


//---Controle de Velocidade

AF_DCMotor motorD(2);             //Seleciona o motor direito na porta 2
AF_DCMotor motorE(1);             //Seleciona o motor esquerdo na porta 1

int ps2D = 32, ps2E = 33;         //Pinos do Arduino conectados ao encoder
int countE = 0, countD = 0;
double velD = 0, velE = 0; // Velocidade em rad/s
int s1D = 0, s1E = 0;          // Primeiros valores lidos pelo encoder

unsigned long tvel = 50000; //Intervalo de amostragem do encoder
unsigned long t0 =0, t =0; //marcador de inicio de tempo e variável de controle do tempo
 //---Comunicação
 String recebido = "";
 String out1_str = "";
 String out2_str = "";
double out1 = 0;
double out2 = 0;
int index=0;

int parar = 1; //variável de saída de laço
void setup() {
  Serial.begin(115200);
  motorD.setSpeed(out1);
  motorE.setSpeed(out2);
}


void loop() {
  motorD.run(FORWARD);
  motorE.run(FORWARD);
  while (parar =1){

    Serial.write(2);
    Serial.print(out1);Serial.print(",");
    Serial.print(out2);
    Serial.write(3);

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

    //leitura
    if(Serial.available()>0){
      recebido = leStringSerial();
      index = recebido.indexOf(',');
      out1_str = recebido.substring(0, index);
      out2_str = recebido.substring(index+1);

      out1 = atof(out1_str.c_str());
      out2 = atof(out2_str.c_str());
      motorD.setSpeed(out1); motorE.setSpeed(out2);

    }



  }
}


String leStringSerial(){
  String conteudo = "";
  char caractere;  
  // Enquanto receber algo pela serial
  while(Serial.available() > 0) {
    // Lê byte da serial
    caractere = Serial.read();
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

