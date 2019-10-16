% Definindo tamanho do prédio
% tam_predio([10, 5]).
dentro_predio([X, Y|_]) :- X > 0, Y > 0, X <= 10, Y <= 5.

% Mapeando paredes no ambiente
ocupado_com([3, 3], parede).
ocupado_com([7, 5], parede).

% Mapeando entulhos no ambiente
ocupado_com([4, 2], entulho).
ocupado_com([7, 2], entulho).
ocupado_com([4, 4], entulho).
ocupado_com([7, 4], entulho).
ocupado_com([6, 5], entulho).

% Mapeando escadas no ambiente
% Acho q é possível mapear somente uma escada, para subir, e fazer a verificação de que, se houver uma escada em [X, Y - 1], pode descer.
ocupado_com([5, 1], escada).
ocupado_com([9, 2], escada).
ocupado_com([1, 3], escada).
ocupado_com([10,3], escada).
ocupado_com([3, 4], escada).
ocupado_com([5, 4], escada).
ocupado_com([9, 4], escada).

% Estado = [[X, Y, Cargas], Extintores, Incendios]
% Estado é meta se lista de incendios == []
meta([_, _, []|_]).

% mov_hor_dir: se for ficar dentro do prédio e not(ocupado_com([X + 1, Y], parede); ocupado_com([X + 1, Y], entulho))
% mov_hor_esq: se for ficar dentro do prédio e not(ocupado_com([X - 1, Y], parede); ocupado_com([X - 1, Y], entulho))

% salto_dir: se for ficar dentro do prédio e ocupado([X + 1, Y], entulho) not(ocupado_com([X + 2, Y], _); tem_fogo(Incendios, [X + 2, Y]))
% salto_esq se for ficar dentro do prédio e ocupado([X - 1, Y], entulho) not(ocupado_com([X - 2, Y], _); tem_fogo(Incendios, [X - 2, Y]))

% mov_ver_sobe: se for ficar dentro do prédio e ocupado([X, Y], escada)
% mov_ver_desce: se for ficar dentro do prédio e ocupado([X, Y - 1], escada)

% pega_extintor: se cargas == 0 e tem_extintor(Extintores, [X, Y])
% apaga_incendio: se cargas > 0 e tem_fogo(Incendios, [X, Y])


% --- BFS ---
% Solucao por busca em largura (bl)
solucao_bl(Inicial, Solucao) :- bl([[Inicial]], Solucao).

% 1. Se o primeiro estado de F for meta, então o retorna com o caminho
bl([[Estado|Caminho]|_], [Estado|Caminho]) :- meta(Estado).

% 2. Falha ao encontrar a meta, então estende o primeiro estado até seus 
% sucessores e os coloca no final da lista de fronteira
bl([Primeiro|Outros], Solucao) :- estende(Primeiro,Sucessores), concatena(Outros, Sucessores, NovaFronteira), bl(NovaFronteira, Solucao).

% 2.1. Metodo que faz a extensao do caminho até os nós filhos do estado
estende([Estado|Caminho], ListaSucessores):- bagof([Sucessor, Estado|Caminho], (s(Estado, Sucessor), not(pertence(Sucessor, [Estado|Caminho]))), ListaSucessores), !.

% 2.2. Se o estado não tiver sucessor, falha e não procura mais (corte)
estende( _ ,[]).

% --- Funções auxiliares para manipulação de listas ---
pertence(Elem,[Elem|_ ]).
pertence(Elem,[ _| Cauda]) :- pertence(Elem,Cauda).

retirar_elemento(Elem, [Elem|Cauda], Cauda).
retirar_elemento(Elem, [Elem1|Cauda], [Elem1|Cauda1]) :- retirar_elemento(Elem, Cauda, Cauda1).

concatena([], L, L).
concatena([Cab|Cauda], L2, [Cab|Resultado]) :- concatena(Cauda, L2, Resultado).

conta([ ],0).
conta([ _|Cauda], N) :- conta(Cauda, N1), N is N1 + 1.
