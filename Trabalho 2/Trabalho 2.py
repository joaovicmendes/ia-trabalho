# Créditos a https://itnext.io/facebook-stock-prediction-bcfc676bc611

# Importando os Pacotes
import pandas as pd
import numpy as np
from sklearn.svm import SVR
import matplotlib.pyplot as plt

df = pd.read_csv('FB.csv')

# Criando as listas / Dataset X e Y
dates  = []
prices = []

# Pega todas as informações, com excessão da última linha.
df = df.head(len(df)-1)

df_dates = df.loc[:,'Date']
df_open  = df.loc[:,'Open']

# Cria o dataset independente 'X' como dates.
for date in df_dates:
  dates.append( [int(date.split('-')[2])] )
  
# Cria o dataset dependente 'Y' como prices.  
for open_price in df_open:
  prices.append(float(open_price))

# Função para fazer predições usando 3 diferentes modelos de SVR com três kernals diferentes.
def predict_prices(dates, prices, x):
  # Cria 3 modelos SVR
  svr_lin = SVR(kernel='linear', C=1e3)
  svr_pol = SVR(kernel='poly', C=1e3, degree=2)
  svr_rbf = SVR(kernel='rbf', C=1e3, gamma=0.1)
  
  # Treina os modelos com dates e prices.
  svr_lin.fit(dates,prices)
  svr_pol.fit(dates,prices)
  svr_rbf.fit(dates, prices)

  plt.scatter(dates, prices, color = 'black', label='Data')
  plt.plot(dates, svr_rbf.predict(dates), color = 'red', label='Base Radial')
  plt.plot(dates, svr_pol.predict(dates), color = 'blue', label = 'Polinomial')
  plt.plot(dates, svr_lin.predict(dates), color = 'green', label='Linear')	
  plt.xlabel('Data')
  plt.ylabel('Valor')
  plt.title('Support Vector Regression')
  plt.legend()
  plt.show()
  
  #Retorne os três modelos de predição
  return svr_rbf.predict(x)[0], svr_pol.predict(x)[0], svr_lin.predict(x)[0]

print(predict_prices(dates, prices, [[29]]))
