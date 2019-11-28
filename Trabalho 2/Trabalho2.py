import pandas as pd
import numpy as np
from sklearn import preprocessing
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import sigmoid_kernel

# Dataset usado:
# https://www.kaggle.com/tmdb/tmdb-movie-metadata/downloads/tmdb-5000-movie-dataset.zip/2

# Créditos a:
# https://towardsdatascience.com/beginners-recommendation-systems-with-python-ee1b08d2efb6

creditos = pd.read_csv("tmdb_5000_credits.csv") # Abertura do arquivo com os créditos do filme.
filmesIncompleto = pd.read_csv("tmdb_5000_movies.csv") # Abertura com os dados dos filmes.

creditosRenomeado = creditos.rename(index=str, columns={"movie_id": "id"}) # Renomeia campos da tabela créditos.
aFilmes = filmesIncompleto.merge(creditosRenomeado, on='id') # Junta tabelas filmeIncompleto e creditosRenomeado.

filmes = aFilmes.drop(columns=['homepage', 'title_x', 'title_y', 'status','production_countries']) # Remove diversas colunas da tabela aFilmes.

# Preparação dos dados para terem pesos iguais de voto.

V = filmes['vote_count']
R = filmes['vote_average']
C = filmes['vote_average'].mean()
m = filmes['vote_count'].quantile(0.70)

# Fórmula para dar peso as médias.

filmes['Media Ponderada'] = (V/(V+m) * R) + (m/(m+V) * C)

# Pré Processamento dos Dados

valorNormal = preprocessing.MinMaxScaler() # Cria uma escala de valores 0 a 1.
filmesEmEscala = valorNormal.fit_transform(filmes[['Media Ponderada', 'popularity']]) # Ajusta filmes a escala valorNormal.
filmesNormalizados = pd.DataFrame(filmesEmEscala, columns = ['Media Ponderada', 'popularity']) # Transforma os dados em uma matriz.

filmes [['Media Ponderada Normalizada', 'Popularidade Normalizada']] = filmesNormalizados # Dados normalizados são passados para filmes e renomeadas as colunas.

filmes['Pontuacao'] = filmes['Media Ponderada Normalizada'] * 0.5 + filmes['Popularidade Normalizada'] * 0.5 # Pontuação dos filmes é um combinado da sua popularidade e média.
filmesPontuados = filmes.sort_values(['Pontuacao'], ascending = False) # Filmes pontuados recebe os filmes com pontuação decrescente.

pontuacoes = filmes.sort_values('Pontuacao', ascending = False) # Pontuacoes recebe as maiores pontuacões.

tfv = TfidfVectorizer(min_df=3,  max_features=None, strip_accents='unicode', analyzer='word', token_pattern=r'\w{1,}', ngram_range=(1, 3), use_idf=1,smooth_idf=1,sublinear_tf=1, stop_words = 'english') # Padrão para analisar o texto de overview.

filmes['overview'] = filmes['overview'].fillna('') # Substituir ocorrências de NaN por strings vazias.

tfvMatrix = tfv.fit_transform(filmes['overview']) # tfvMatrix vira a matriz de tfv

sig = sigmoid_kernel(tfvMatrix,tfvMatrix) # Achando o valor de sigmoid kernel.

indices = pd.Series(filmes.index, index = filmes['original_title']).drop_duplicates() # Removendo quaisquer indices iguais.

# Função de recomendação

def recomenda(titulo, sig = sig):
	idx = indices[titulo] # Pega o índice do título do filme buscado.
	sig_score = list(enumerate(sig[idx])) # Pega o valor de similaridade par a par.
	sig_score = sorted(sig_score, key = lambda x:x[1], reverse = True) # Ordena a lista de sig_scores.
	sig_score = sig_score[1:11] # Seleciona os 10 filmes mais parecidos.
	
	indicesFilme = [i[0] for i in sig_score] # Selecioa os índices dos filmes mais similares.

	return filmes['original_title'].iloc[indicesFilme]
	


print(recomenda('Batman v Superman: Dawn of Justice'))
print(recomenda('The Avengers'))
print(recomenda('Toy Story 3'))