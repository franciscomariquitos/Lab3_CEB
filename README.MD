Este projeto lê os dados de entrada e saída de um inversor CMOS (exportados do osciloscópio em scope_0.csv), limpa, organiza e 
desenha a curva de transferência com os pontos especificados: VOL, VOH, VIL e VIH.

1. Leitura e limpeza
    -readmatrix('scope_0.csv')

    -Remove linhas com qualquer NaN

2. Ordenação e agregação
    -Separa canal 1 (vI) e canal 2 (vO)

    -Ordena vI em ordem crescente, realinha vO

    -Agrupa valores repetidos de vI e faz a média de vO para suavizar

3. Interpolação suave
    -Gera 1000 pontos PCHIP entre o mínimo e máximo de vI

    -Permite cálculo da derivada e de um traçado contínuo

4. Cálculo de VOL e VOH
    -Ordena todos os valores de vO

    -VOL = média dos 25% inferiores 

    -VOH = média dos 25% superiores 

5. Cálculo de VIL e VIH
    -Calcula a derivada discreta dy/dx ao longo da curva suavizada

    -Encontra todos os pontos onde a inclinação cruza –1

    -Escolhe o 1º ponto antes do pico de inclinação negativa → VIL

    -Escolhe o 1º ponto depois do pico → VIH

    -Interpola linearmente para obter a abscissa exata

6. Plot e anotações
    -Curva suavizada a azul (vO(vI))

    -Linhas horizontais em VOH e VOL (tracejado)

    -Segmentos vermelhos de slope = –1 em VIL e VIH

    -Círculos azuis nos pontos de “joelho” (slope ≈ –1)

