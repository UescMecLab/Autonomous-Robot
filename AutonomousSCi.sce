
//Primeiro prototipo do AutonomosRobot by João
//Contendo Controle de Velocidade + Comunicação Serial estágio um

//Inicia a comunicação com o arduino
arduino_com = openserial("COM3","115200,n,8,1") // para Windows
//arduino_com = openserial("/dev/ttyACM1","115200,n,8,1") // para Linux "

// Verifica se a comunicaçao está ok
if arduino_com == -1 then
  disp("Erro em Comunicação Serial");
  else
  disp("Comunicação Serial OK");
end

//Variáveis útei 
m = 0 //Contador de ciclo
posicao = ''; //Variável que armazenará a velocidade & Futuramente posicao
loop = 1 //Variável para manter o loop futuramente & Laço será mantido pela distância

potencia = [10 200] // Potencia a ser enviada & Será velocidade 

while loop == 1 then 
    tic()
    
    [q, s] = serialstatus(arduino_com);
    if (q(1)>1) then
    disp("Tem coisa na fila");
end //end if q(1)
    recebido = readserial(arduino_com, 1);
    if ascii(recebido) == 2 then 
        m = m + 1;
        while ascii(recebido) ~= 3 then
            recebido = readserial(arduino_com, 1);
            posicao =  msprintf('%s%s',posicao, recebido);
            
        end //while ~3
        cord = strtod(strsplit(posicao, ","))';
        disp(cord);
        sleep(50);
        potencia_str = strcat(string([potencia(1) potencia(1)]), ",");
        writeserial(arduino_com, potencia_str);
        disp("potencia enviada", potencia_str);
        posicao = "";
        if (potencia(1) <250) then
        potencia(1) = potencia(1) + 10;
        end 
        t = toc();
        disp(t);
        end // end if ==2   
end // end loop
disp("Finish");