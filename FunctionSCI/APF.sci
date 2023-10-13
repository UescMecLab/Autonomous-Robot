function [F_t] = APF(x_current, q_g, q_obs, a_max, etta, xi, ro_o, precisao,a_min)
// PROBLEMA: O ROBÔ ESTÁ SENDO REPRESENTADO POR UM PONTO, TEM QUE CONSIDERAR O TAMANHO VARIÁVEL

        tam = size(q_obs); // Calcula quntidade de obstáculos, por enquanto serão sempre dois
        c = tam(1); 
        
        
        // Verifica se o obstáculo identificado é um novo obstáculo ou se é o já conhecido
        if c > 1 then
        
          if  norm(q_obs(1,:) - q_obs(2,:)) < = 2*precisao then // considera como se fosse o mesmo
                c = 1; // ignora o segundo
            end
        
        end
         c =1;
//        F_at = - xi * (x_current-q_g); // força atrativa
        F_at = - xi * (x_current-q_g)/norm(x_current-q_g); // força atrativa
        // Força  repulsiva
        F_rep = [0, 0];
        if c == 0 then
            F_rep = [0, 0];
        else
            for i = 1:c
                if norm(x_current - q_obs(i,:)) < = ro_o then
             F_rep = F_rep + etta * (inv(norm(x_current-q_obs(i,:))) - inv(ro_o))*(x_current-q_obs(i,:))/((norm(x_current-q_obs(i,:)))^3);
                end
            end
            
        end
   
       betha = cos(atan(F_at(2), F_at(1)) - atan(F_rep(2), F_rep(1)));
        sig = sign(sin(atan(F_at(2), F_at(1)) - atan(q_g(2)-q_obs(c,2), q_g(1)-q_obs(c,1)))); // sinal do sentido de giro da força de vórtex    
        F_v=sig*([-F_rep(2), F_rep(1)]); // força de vórtex
        
        if betha > 0 then
            sig = 0;
        end   
        
        F_t = F_at + F_v; // força total
        if norm(F_t)>a_max then // force control
            F_t = (F_t/norm(F_t))*a_max;
        end


        if norm(F_t)<a_min then // force control
            F_t = (F_t/norm(F_t))*a_min;
        end
endfunction
