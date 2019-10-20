% Estado:
% Estado = [Bombeiro, Extintores, Incendios]
% Estado = [[X, Y, Carga], Extintores, Incendios]

% --- Condições para transição de estado ---
% MOV. HORIZONTAL: continua dentro do prédio, não existe uma parede, entulho ou fogo na posição desejada.
% SALTOS: continua dentro do prédio, tem entulho na posição adjacente, não tem nenhum objeto na posição seguinte. 
% MOV. VERTICAL: continua dentro do prédio, existe uma escada na posição desejada (em [X, Y] para subir e em [X, Y - 1] para descer).
% PEGA EXTINTOR: se a carga esta vazia e tem extintor na posição atual
% APAGAR INCENDIO: se tem carga, e existe fogo na posição adjacente


% Movimento horizontal à direita
s([[X, Y|Carga], Extintores, Incendios], [[X1, Y|Carga], Extintores, Incendios]) :- 
    X1 is X + 1, 
    dentro_predio([X1, Y]), 
    not(ocupado_com([X1, Y], parede)), 
    not(ocupado_com([X1, Y], entulho)), 
    not(pertence([X1, Y], Incendios)).

% Movimento horizontal à esquerda
s([[X, Y|Carga], Extintores, Incendios], [[X1, Y|Carga], Extintores, Incendios]) :- 
    X1 is X - 1, 
    dentro_predio([X1, Y]), 
    not(ocupado_com([X1, Y], parede)), 
    not(ocupado_com([X1, Y], entulho)), 
    not(pertence([X1, Y], Incendios)).

% Salto à direita
s([[X, Y|Carga], Extintores, Incendios], [[X1, Y|Carga], Extintores, Incendios]) :- 
    X1 is X + 2, X2 is X + 1, 
    dentro_predio([X1, Y]), 
    ocupado_com([X2, Y], entulho), 
    not(ocupado_com([X1, Y], _)), 
    not(pertence([X1, Y], Incendios)), 
    not(pertence([X1, Y], Extintores)), 
    not(ocupado_com([X1, Y - 1], escada)).

% Salto à esquerda
s([[X, Y|Carga], Extintores, Incendios], [[X1, Y|Carga], Extintores, Incendios]) :- 
    X1 is X - 2, X2 is X - 1, 
    dentro_predio([X1, Y]), 
    ocupado_com([X2, Y], entulho),
    not(ocupado_com([X1, Y], _)), 
    not(pertence([X1, Y], Incendios)), 
    not(pertence([X1, Y], Extintores)), 
    not(ocupado_com([X1, Y - 1], escada)).

% Movimento vertical para cima
s([[X, Y|Carga], Extintores, Incendios], [[X, Y1|Carga], Extintores, Incendios]) :- 
    Y1 is Y + 1, 
    dentro_predio([X, Y1]), 
    ocupado_com([X, Y], escada).

% Movimento vertical para baixo
s([[X, Y|Carga], Extintores, Incendios], [[X, Y1|Carga], Extintores, Incendios]) :- 
    Y1 is Y - 1, 
    dentro_predio([X, Y1]), 
    ocupado_com([X, Y1], escada).

% Pega extintor
s([[X, Y, Carga|Cauda], Extintores, Incendios], [[X, Y, Carga1|Cauda], Extintores1, Incendios]) :- 
    Carga == 0, 
    pertence([X, Y], Extintores), 
    retirar_elemento([X, Y], Extintores, Extintores1), 
    Carga1 is Carga + 2.

% Apaga Incêndio à direita
s([[X, Y, Carga|Cauda], Extintores, Incendios], [[X, Y, Carga1|Cauda], Extintores, Incendios1]) :- 
    Carga > 0, X1 is X + 1, 
    pertence([X1, Y], Incendios), 
    retirar_elemento([X1, Y], Incendios, Incendios1), 
    Carga1 is Carga - 1.

% Apaga Incêndio à esquerda
s([[X, Y, Carga|Cauda], Extintores, Incendios], [[X, Y, Carga1|Cauda], Extintores, Incendios1]) :- 
    Carga > 0, X1 is X - 1, 
    pertence([X1, Y], Incendios), 
    retirar_elemento([X1, Y], Incendios, Incendios1), 
    Carga1 is Carga - 1.

% Definindo meta(Estado)
% Estado é meta se lista de incendios == []
meta([_, _, []]).


% --- Funções auxiliares para manipulação de listas ---
pertence(Elem, [Elem|_]).
pertence(Elem, [_| Cauda]) :- pertence(Elem, Cauda).

retirar_elemento(Elem, [Elem|Cauda], Cauda).
retirar_elemento(Elem, [Elem1|Cauda], [Elem1|Cauda1]) :- retirar_elemento(Elem, Cauda, Cauda1).

concatena([], L, L).
concatena([Cab|Cauda], L2, [Cab|Resultado]) :- concatena(Cauda, L2, Resultado).

conta([], 0).
conta([_|Cauda], N) :- conta(Cauda, N1), N is N1 + 1.

inverte([], []).
inverte([Elem|Cauda], Inv) :- inverte(Cauda, Cauda1), concatena(Cauda1, [Elem], Inv).

% Função que deixa somente o caminho do bombeiro e o histórico de cargas na resposta final
limpa_sol([], []).
limpa_sol([[Elem|_]|Cauda], [Elem|Cauda1]) :- limpa_sol(Cauda, Cauda1).


% --- BFS ---
% Solucao por busca em largura (bl)
solucao_bl(Inicial, SolucaoInv) :- 
    bl([[Inicial]], Solucao), 
    limpa_sol(Solucao, Solucao1), 
    inverte(Solucao1, SolucaoInv).

% 1. Se o primeiro estado de F for meta, então o retorna com o caminho
bl([[Estado|Caminho]|_], [Estado|Caminho]) :- meta(Estado).

% 2. Falha ao encontrar a meta, então estende o primeiro estado até seus 
% sucessores e os coloca no final da lista de fronteira
bl([Primeiro|Outros], Solucao) :- 
    estende(Primeiro, Sucessores), 
    concatena(Outros, Sucessores, NovaFronteira), 
    bl(NovaFronteira, Solucao).

% 2.1. Metodo que faz a extensao do caminho até os nós filhos do estado
estende([Estado|Caminho], ListaSucessores):- 
    bagof(
        [Sucessor, Estado|Caminho], 
        (s(Estado, Sucessor), not(pertence(Sucessor, [Estado|Caminho]))), 
        ListaSucessores
    ), !.

% 2.2. Se o estado não tiver sucessor, falha e não procura mais (corte)
estende( _ ,[]).


% --- DFS ---
% Solucao por busca em profundidade (bp)
solucao_bp(Inicial, SolucaoInv) :- 
    bp([], Inicial, Solucao), 
    limpa_sol(Solucao, Solucao1), 
    inverte(Solucao1, SolucaoInv).

% 1. Encontra a meta
bp(Caminho, Estado, [Estado|Caminho]) :- meta(Estado).

% 2. Senão, coloca o no caminho e continua a busca
bp(Caminho, Estado, Solucao) :- 
    s(Estado, Sucessor), 
    not(pertence(Sucessor, Caminho)), 
    bp([Estado|Caminho], Sucessor, Solucao).
