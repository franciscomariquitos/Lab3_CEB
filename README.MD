Este projeto lê os dados de entrada e saída de um inversor CMOS (exportados do osciloscópio em scope_0.csv), limpa, organiza e 
desenha a curva de transferência com os pontos especificados: VOL, VOH, VIL e VIH.

1. Leitura e limpeza
readmatrix('scope_0.csv')

Remove linhas com qualquer NaN

2. Ordenação e agregação
Separa canal 1 (vI) e canal 2 (vO)

Ordena vI em ordem crescente, realinha vO

Agrupa valores repetidos de vI e faz a média de vO para suavizar

3. Interpolação suave
Gera 1000 pontos PCHIP entre o mínimo e máximo de vI

Permite cálculo de derivada e traçado contínuo

4. Cálculo de VOL e VOH
Ordena todos os valores de vO

VOL = média dos 25% inferiores (plateau baixo)

VOH = média dos 25% superiores (plateau alto)

5. Cálculo de VIL e VIH
Calcula derivada discreta dy/dx ao longo da curva suave

Encontra todas as travessias onde a inclinação cruza –1

Escolhe a travessia antes do pico de inclinação negativa → VIL

Escolhe a travessia depois do pico → VIH

Interpola linearmente para obter a abscissa exata

6. Plotagem e anotações
Curva suave em azul (vO(vI))

Linhas horizontais em VOH e VOL (tracejado)

Segmentos vermelhos de slope = –1 em VIL e VIH

Círculos azuis nos pontos de “joelho” (slope ≈ –1)

Textos LaTeX com os valores de VOL, VOH, VIL e VIH posicionados próximos
