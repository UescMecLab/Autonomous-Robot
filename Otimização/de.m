function [Fbest, gbest, it, x] = de(costf, limites, x0,NP, itMax, tempoMax, info)

it = 1;
tempoInicial = tic;



D = size(limites,2);

xMax = limites(1,:);
xMin = limites(2,:);


% calcula posicao iniciais e inicializa vetor candidato
x = inicializaPopulacao(xMin,xMax,x0,NP,D);


% calcula o funcional custo
for n = 1:NP
    F(n) = costf(x(n, :));
end
tempoIt = toc(tempoInicial);

Fp = 0.8*ones(NP,1);
cr = 0.3*ones(NP,1);

%Fl = 0.9;
%Fu = 0.1;
%tal1 = 0.1;
%tal2 = 0.1;
while(1)
    % determina Fbest e gbest
    [C, I] = min(F);
    Fbest = C;
    gbest = x(I, :);


    %verifica criteiro de parada
    if ( it >= itMax )||( toc(tempoInicial)+tempoIt > tempoMax ) 
        infoOtm(it,Fbest,gbest);
        fprintf('\t Tempo %9.4g',(toc(tempoInicial)));
        break;
    end

    if info
        infoOtm(it,Fbest,gbest);
    end

    v = multacaoRand1(x,NP,Fp);



    v = max(xMin, min(xMax, v));

    u = cruzamento(x,v,NP,D,cr);


    [x,F] = selecao(x,F,u,costf,NP);


    it = it+1;
end

end


function infoOtm(it,Fbest,gbest)
%Funcao com objetivo de mostar no console e salvar em um arquivo csv o
%resultado da otimizacao
fprintf("\n\n==============================================================================================================")
fprintf('\niter %3.0f; \t fbest  %9.5g; \t gbest ',it,Fbest);
fprintf('%9.5g,   ', gbest);
writematrix([it, Fbest, gbest],"savede.csv","WriteMode","append");
end

function x = inicializaPopulacao(xMin,xMax,x0,NP,D)
for d = 1:D
    x(1:NP,d) = xMin(d) + rand(NP,1)*( xMax(d) - xMin(d) );
end

if ~isempty(x0)
    x(1:size(x0,1),:) = max(min(x0,xMax),xMin);
end
end

% function v = multacaoBest1(x,gbest,NP,Fp)
% v = gbest + Fp.*(x(randperm(NP),:) - x(randperm(NP),:) );
% end

function v = multacaoRand1(x,NP,Fp)
v = x(randperm(NP),:) + Fp.*(x(randperm(NP),:) - x(randperm(NP),:) );
end

%function v = multacaoCurToBest1(x,gbest,NP,Fp)
%v = x + Fp.*( gbest-x + x(randperm(NP),:) - x(randperm(NP),:) );
%end

function u = cruzamento(x,v,NP,D,cr)
i = rand(NP,D)<=cr;

u = x;
u(i) = v(i);
end


function [x,F] = selecao(x,F,u,costf,NP)
    % calcula o funcional custo dos vetores canditatos
    for n = 1:NP
        Fu(n) = costf(u(n, :));
    end
    % atualiza o vetor de custos
    for n = 1:NP
        if Fu(n) < F(n)
            x(n,:) = u(n,:);
            F(n) = Fu(n);
        end
    end
end

% function [Fp, cr] = attConstantesjDE(Fp,cr,Fl,Fu,tal1,tal2,NP)
% Fpnew = rand(NP,1)*Fu+Fl;
% crnew = rand(NP,1);
% 
% indiceFp = rand(NP,1)<tal1;
% Fp(indiceFp) = Fpnew(indiceFp);
% 
% indicecr = rand(NP,1)<tal2;
% cr(indicecr) = crnew(indicecr);
% 
% end

