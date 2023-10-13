function u =controlador(F_t,theta,kr,kl)
    //[F_t(1), F_t(2)] = [Fx, Fy] = F_t
    i=1;
    u1(i+1) = 0.5*kr*(F_t(1)*cos(theta) + F_t(2)*sin(theta(i)) + l*(atan(F_t(2),F_t(1)) - theta));
    u2(i+1) = 0.5*kl*(F_t(1)*cos(theta) + F_t(2)*sin(theta(i)) - l*(atan(F_t(2),F_t(1)) - theta));
    
    
////     //Exclui a zona morta
//    if u1(2) < vel_min & u1(2) > 0.8 then
//        u1(2) = vel_min;
//    end
//    
//    if u2(2) < vel_min & u2(2) > 0.8 then
//        u2(2) = vel_min;
//    end
    
    u = [u1(2), u2(2)];
    
endfunction
