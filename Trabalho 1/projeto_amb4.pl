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

% Verificando se existe fogo ou extintor
tem_fogo(Coordenada, Incendios) :- pertence(Coordenada, Incendios).

tem_extintor(Coordenada, Extintores) :- pertence(Coordenada, Extintores).

% Transições de estado
% Estado = [[X, Y, Carga], Extintores, Incendios]

% Movimento horizontal à direita
s([[X, Y|Carga], Extintores, Incendios], [[X1, Y|Carga], Extintores, Incendios]) :- X1 is X + 1, dentro_predio([X1, Y]), not(ocupado_com([X1, Y], parede)), not(ocupado_com([X1, Y], entulho)), not(tem_fogo([X1, Y], Incendios)).

% Movimento horizontal à esquerda
s([[X, Y|Carga], Extintores, Incendios], [[X1, Y|Carga], Extintores, Incendios]) :- X1 is X - 1, dentro_predio([X1, Y]), not(ocupado_com([X1, Y], parede)), not(ocupado_com([X1, Y], entulho)), not(tem_fogo([X1, Y], Incendios)).

% Salto à direita
s([[X, Y|Carga], Extintores, Incendios], [[X1, Y|Carga], Extintores, Incendios]) :- X1 is X + 2, X2 is X + 1, dentro_predio([X1, Y]), ocupado_com([X2, Y], entulho),
not(ocupado_com([X1, Y], _)), not(tem_fogo(Incendios, [X1, Y])), not(tem_extintor([X1, Y], Extintores)).

% Salto à esquerda
s([[X, Y|Carga], Extintores, Incendios], [[X1, Y|Carga], Extintores, Incendios]) :- X1 is X - 2, X2 is X - 1, dentro_predio([X1, Y]), ocupado_com([X2, Y], entulho),
not(ocupado_com([X1, Y], _)), not(tem_fogo(Incendios, [X1, Y])), not(tem_extintor([X1, Y], Extintores)).

% Movimento vertical para cima
s([[X, Y|Carga], Extintores, Incendios], [[X, Y1|Carga], Extintores, Incendios]) :- Y1 is Y + 1, dentro_predio([X, Y1]), ocupado_com([X, Y], escada).

% Movimento vertical para baixo
s([[X, Y|Carga], Extintores, Incendios], [[X, Y1|Carga], Extintores, Incendios]) :- Y1 is Y - 1, dentro_predio([X, Y1]), ocupado_com([X, Y1], escada).

% Pega extintor
s([[X, Y, Carga|Cauda], Extintores, Incendios], [[X, Y, Carga1|Cauda], Extintores1, Incendios]) :- Carga == 0, tem_extintor([X, Y], Extintores), retirar_elemento([X, Y], Extintores, Extintores1), Carga1 is Carga + 2.

% Apaga Incêndio à direita
s([[X, Y, Carga|Cauda], Extintores, Incendios], [[X, Y, Carga1|Cauda], Extintores, Incendios1]) :- Carga > 0, X1 is X + 1, tem_fogo([X1, Y], Incendios), retirar_elemento([X1, Y], Incendios, Incendios1), Carga1 is Carga - 1.

% Apaga Incêndio à esquerda
s([[X, Y, Carga|Cauda], Extintores, Incendios], [[X, Y, Carga1|Cauda], Extintores, Incendios1]) :- Carga > 0, X1 is X - 1, tem_fogo([X1, Y], Incendios), retirar_elemento([X1, Y], Incendios, Incendios1), Carga1 is Carga - 1.

% Definindo meta(Estado)
% Estado é meta se lista de incendios == []
meta([_, _, []]).

% --- BFS ---
% Solucao por busca em largura (bl)
solucao_bl(Inicial, SolucaoInv) :- bl([[Inicial]], Solucao), limpa_sol(Solucao, Solucao1), inverte(Solucao1, SolucaoInv).

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

limpa_sol([], []).
limpa_sol([[Elem|_]|Cauda], [Elem|Cauda1]) :- limpa_sol(Cauda, Cauda1).

inverte([], []).
inverte([Elem|Cauda], Inv) :- inverte(Cauda, Cauda1), concatena(Cauda1, [Elem], Inv).
