function Custo = RMSE(H,posicao, tempo, U, X, X0)

sim = Integracao(H, tempo, U, X);

Erro = (posicao - sim).^2;
SumErro = sum(sum(Erro,1),2);
EM = SumErro/size(posicao,1);
Custo = sqrt(EM);
disp(Custo);

end

