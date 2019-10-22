# Inteligência Artificial (1001336) – Trabalho 1
Trabalho 1 da disciplina Inteligência Artificial (1001336) - UFSCar 2019/2

# Grupo
O grupo é composto pelos alunos:
- [João Victor Mendes Freire (758943)](https://github.com/joaovicmendes)
- [Guilherme Locca Salomão (758569)](https://github.com/Caotichazard)
- [Luis Felipe Ortolan (759375)](https://github.com/LuisFelipeOrtolan)

# Instruções
- Vá para a pasta `src/` no terminal

Primeira forma:
- Executar no terminal `swipl`
- Executar no prolog `?- [ambX, projeto].`, em que X é o número do ambiente
- Executar no prolog `?- solucao_bl(<estado inicial>).`

Segunda forma:
- Executar no terminal `swipl < X.in`, em que X é o número do ambiente


Se a solução resultante for `false.`, o programa não encontrou uma solução, se encontrou e acabou com `...`, basta apertar `w` para exibir a solução completa.
A solução final é uma lista contendo diversas listas na forma `[X, Y, Cargas]`, onde `X` e `Y` são a posição do bombeiro e `Cargas` é o número de cargas que ele possui naquele momento.
