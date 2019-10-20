% Teste do ambiente 3: 
% solucao_bl([ Bombeiro, Extintores, Incendios ])
% solucao_bl([ [1, 1, 0], [ [6, 3], [1, 4] ],[ [10, 1], [2, 5], [8, 5], [10, 5] ] ], S).

% Definindo tamanho do prédio
% tam_predio([10, 5]).
dentro_predio([X, Y|_]) :- X > 0, Y > 0, X < 11, Y < 6.

% Mapeando paredes no ambiente
ocupado_com([6, 1], parede).
ocupado_com([5, 3], parede).

% Mapeando entulhos no ambiente
ocupado_com([3, 1], entulho).
ocupado_com([3, 2], entulho).
ocupado_com([6, 2], entulho).
ocupado_com([7, 2], entulho).
ocupado_com([6, 4], entulho).
ocupado_com([6, 5], entulho).

% Mapeando escadas no ambiente (é apenas a parte de baixo, para descer é preciso
% verificar se existe uma escada em [X, Y-1])
ocupado_com([5, 1], escada).
ocupado_com([9, 1], escada).
ocupado_com([1, 2], escada).
ocupado_com([8, 2], escada).
ocupado_com([4, 3], escada).
ocupado_com([10,3], escada).
ocupado_com([3, 4], escada).
ocupado_com([9, 4], escada).
