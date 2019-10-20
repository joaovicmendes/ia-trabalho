% Teste do ambiente 8: 
% solucao_bl([ Bombeiro, Extintores, Incendios ])
% solucao_bl([ [1, 3, 0], [ [8, 1], [1, 2], [1, 5] ], [ [2, 1], [9, 2], [10, 3], [1, 4], [9, 4], [10, 5] ] ], S).

% Definindo tamanho do prédio
% tam_predio([10, 5]).
dentro_predio([X, Y|_]) :- X > 0, Y > 0, X < 11, Y < 6.

% Mapeando paredes no ambiente
ocupado_com([1, 1], parede).
ocupado_com([7, 1], parede).
ocupado_com([6, 5], parede).

% Mapeando entulhos no ambiente
ocupado_com([4, 1], entulho).
ocupado_com([3, 3], entulho).
ocupado_com([8, 3], entulho).

% Mapeando escadas no ambiente (é apenas a parte de baixo, para descer é preciso
% verificar se existe uma escada em [X, Y-1])
ocupado_com([6, 1], escada).
ocupado_com([10,1], escada).
ocupado_com([4, 2], escada).
ocupado_com([6, 3], escada).
ocupado_com([2, 4], escada).
ocupado_com([7, 4], escada).
