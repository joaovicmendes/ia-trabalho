% Teste do ambiente 1: solucao_bl([ [1, 1, 0], [[7, 1], [6, 3]], [[5, 1], [2, 3], [8, 5]] ], S).

% Definindo tamanho do prédio
% tam_predio([10, 5]).
dentro_predio([X, Y|_]) :- X > 0, Y > 0, X < 11, Y < 6.

% Mapeando paredes no ambiente
ocupado_com([6, 1], parede).
ocupado_com([5, 3], parede).

% Mapeando entulhos no ambiente
ocupado_com([2, 1], entulho).
ocupado_com([3, 2], entulho).
ocupado_com([10,2], entulho).
ocupado_com([6, 4], entulho).
ocupado_com([2, 5], entulho).
ocupado_com([6, 5], entulho).

% Mapeando escadas no ambiente
% Acho q é possível mapear somente uma escada, para subir, e fazer a verificação de que, se houver uma escada em [X, Y - 1], pode descer.
ocupado_com([4, 1], escada).
ocupado_com([9, 1], escada).
ocupado_com([1, 2], escada).
ocupado_com([7, 3], escada).
ocupado_com([4, 3], escada).
ocupado_com([10,4], escada).
ocupado_com([3, 4], escada).
ocupado_com([9, 4], escada).
