%% Origem dos Dados
%http://www.ipeadata.gov.br/exibeserie.aspx?serid=38401
%http://dados.gov.br/dataset/sistema-nacional-de-estatisticas-de-seguranca-publica/resource/565f55fc-87ea-4826-897c-0597aa69b7f9?inner_span=True

%% Inicialização
clc;
clear all;

%% Configuração
percentual_teste = 0.3;

%% Carregar CSV

d = sortrows(table2array(readtable("desCrimIpeaMJ0315.xls")));
dNorm = normalize(d,'range');
x = d(:,1);
y = d(:,2);
xNorm = dNorm(:,1);
yNorm = dNorm(:,2);

%% Correlação

c = correlacao(xNorm,yNorm);

%% Gráfico de dispersão

scatter(xNorm,yNorm,'+','r');
hold on;
grid on;
xlabel('Taxa de desemprego');
ylabel('Total de crimes');
t = sprintf('Correlação: %f', c)
title(t);

%% Regressão linear
[yy,b0,b1] = regressao(xNorm,yNorm);
plot(xNorm,yy,'color',[0.9100    0.4100    0.1700]);

%% Regressão Polinomial
% 2 pontos
p = polyfit(xNorm,yNorm,2);
y2 = polyval(p,xNorm);
plot(xNorm,y2,'g');
hold on;
% 3 pontos
p = polyfit(xNorm,yNorm,3);
y3 = polyval(p,xNorm);
plot(xNorm,y3,'b');
% 5 pontos
p = polyfit(xNorm,yNorm,5);
y5 = polyval(p,xNorm);
plot(xNorm,y5,'c');
% 7 pontos
p = polyfit(xNorm,yNorm,7);
y7 = polyval(p,xNorm);
plot(xNorm,y7,'k');
% 9 pontos
p = polyfit(xNorm,yNorm,9);
y9 = polyval(p,xNorm);
plot(xNorm,y9,'m');
% 16 pontos
p = polyfit(xNorm,yNorm,16);
y16 = polyval(p,xNorm);
plot(xNorm,y16,'color',[0.7100    0.7100    0.7100]);

%% Legendas Gráfico

legend('Dados','Linear','Poli 2','Poli 3','Poli 5','Poli 7','Poli 9','Poli 16', 'southeast');

%% EQM
% 3 Calcular EQM
[eqm2] = calcula_eqm(yNorm, y2);
[eqm3] = calcula_eqm(yNorm, y3);
[eqm5] = calcula_eqm(yNorm, y5);
[eqm7] = calcula_eqm(yNorm, y7);
[eqm9] = calcula_eqm(yNorm, y9);
[eqm16] = calcula_eqm(yNorm, y16);

%% Aprendizado
% 4 Separar os dados 90%/10%
qtd_teste = round(length(xNorm) * percentual_teste);
sorteados = randperm(length(xNorm),qtd_teste);
x_teste = xNorm(sorteados);
y_teste = yNorm(sorteados);
x_aprend = xNorm;
y_aprend = yNorm;
x_aprend(sorteados,:) = [];
y_aprend(sorteados,:) = [];

%% Calcular regressão da base de aprendizado
% 5 Calcular o B e regressao 90%
BA2 = polyfit(x_aprend, y_aprend, 2);
ya2 = calcula_y(BA2, x_aprend);
BA3 = polyfit(x_aprend, y_aprend, 3);
ya3 = calcula_y(BA3, x_aprend);
BA5 = polyfit(x_aprend, y_aprend, 5);
ya5 = calcula_y(BA5, x_aprend);
BA7 = polyfit(x_aprend, y_aprend, 7);
ya7 = calcula_y(BA7, x_aprend);
BA9 = polyfit(x_aprend, y_aprend, 9);
ya9 = calcula_y(BA9, x_aprend);
BA16 = polyfit(x_aprend, y_aprend, 16);
ya16 = calcula_y(BA16, x_aprend);

%% Calcular regressao da base de teste usando B do treinamento
% 6 Calcular A regressao EQM teste (com B do treinamento)
yt2 = calcula_y(BA2, x_teste);
yt3 = calcula_y(BA3, x_teste);
yt5 = calcula_y(BA5, x_teste);
yt7 = calcula_y(BA7, x_teste);
yt9 = calcula_y(BA9, x_teste);
yt16 = calcula_y(BA16, x_teste);

% calcular o EQM utilizando os 5 selecionados e o y calculado dos valores
% de teste
[eqmt2] = calcula_eqm(y_aprend,ya2);
[eqmt3] = calcula_eqm(y_aprend,ya3);
[eqmt5] = calcula_eqm(y_aprend,ya5);
[eqmt7] = calcula_eqm(y_aprend,ya7);
[eqmt9] = calcula_eqm(y_aprend,ya9);
[eqmt16] = calcula_eqm(y_aprend,ya16)


%% Display dos EQM para comparação
disp("----- Erro Quadrático Médio Total -----");
disp(sprintf('EQM 2 pontos: %f', eqm2));
disp(sprintf('EQM 3 pontos: %f', eqm3));
disp(sprintf('EQM 5 pontos: %f', eqm5));
disp(sprintf('EQM 7 pontos: %f', eqm7));
disp(sprintf('EQM 9 pontos: %f', eqm9));
disp(sprintf('EQM 16 pontos: %f', eqm16));
disp("");disp("----- Erro Quadrático Médio Teste -----");
disp(sprintf('EQM 2 pontos: %f', eqmt2));
disp(sprintf('EQM 3 pontos: %f', eqmt3));
disp(sprintf('EQM 5 pontos: %f', eqmt5));
disp(sprintf('EQM 7 pontos: %f', eqmt7));
disp(sprintf('EQM 9 pontos: %f', eqmt9));
disp(sprintf('EQM 16 pontos: %f', eqmt16));