# Resultados e limitações

## Principais achados

Valores do período inteiro, sem filtros.

**Cenário**
- **82,5%** das partidas e **82,9%** das chegadas foram pontuais (atraso ≤ 15 min).
- A **mediana do atraso na chegada é −4 minutos**: o voo típico chega adiantado. A média de todos os voos é de 4,06 min, puxada pela cauda.
- Os voos recuperam em média **3,57 min** entre a partida (atraso médio de 7,63 min) e a chegada.
- Quando o atraso acontece, ele pesa: a média dos voos atrasados é de **29,33 min**, e **3,8%** dos voos avaliados têm atraso superior a 60 min.
- **3,0%** dos voos programados foram cancelados (29.141 voos).
**Quando**
- **Dezembro/2025** foi o pior mês: **72,0%** de pontualidade de partida, **10,5 p.p.** abaixo da média. Os demais meses ficaram entre 81% e 86%.
- Pelo dia da semana, **quarta, quinta e sexta** ficam abaixo da média; **sexta (80,5%)** é o pior dia e **sábado (84,5%)**, o melhor.
- Pela hora prevista, a pontualidade fica abaixo da média **a partir das 13h** (a hora 0 também aparece abaixo da média).
**Onde e quem**
- Entre os 8 aeroportos exibidos, **Guarulhos (SBGR)** tem a menor pontualidade (**72,9%**), seguido por **Congonhas (SBSP)**, com 80,6%. O melhor é Brasília (SBBR), com 88,7%.
- **Internacional: 74,6%** de pontualidade contra **84,1%** do doméstico; o cancelamento é de **8,3%** contra **1,8%** (cerca de 4,6 vezes mais).
- No gráfico por companhia, **TAM** e **LATAM Airlines Group** ficam abaixo da média; Gol, Azul e Azul Conecta ficam acima.
**Hipóteses a investigar (ainda não testadas)**
- Se dezembro reflete sazonalidade (período de festas e clima) ou algo específico daquele ano; a base cobre apenas um dezembro.
- Se o desempenho de Guarulhos e de dezembro se repete para cada companhia ao filtrar uma por vez.
- Quanto do atraso do tráfego internacional vem de voos **cargueiros** (a coluna `tipo_operacao` já existe para essa análise).

## Análise detalhada dos atrasos

Valores do período inteiro, sem filtros.

### Panorama: a cauda de atrasos

| Indicador | Valor |
|---|---|
| Mediana do atraso na chegada | −4 min |
| Média do atraso na chegada (todos os voos) | 4,06 min |
| Média do atraso na chegada **só dos voos atrasados** | 29,33 min |
| Chegadas com atraso acima de 60 min | 3,8% |
| Atraso médio na partida → chegada | 7,63 min → 4,06 min (3,57 min recuperados) |

### Mês

| ago/25 | set | out | nov | **dez** | jan/26 | fev | mar | abr | mai | jun | jul |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 86,0% | 85,7% | 83,6% | 81,9% | **72,0%** | 81,5% | 82,3% | 85,0% | 82,4% | 85,0% | 81,4% | 83,2% |

**Dezembro/2025 é o pior mês**, 10,5 p.p. abaixo da média; nos demais, o OTP fica entre 81,4% e 86,0%.

### Dia da semana

| seg | ter | qua | qui | **sex** | sáb | dom |
|---|---|---|---|---|---|---|
| 82,8% | 83,0% | 81,8% | 80,8% | **80,5%** | 84,5% | 84,3% |

Quarta, quinta e sexta ficam abaixo da média; **sexta (80,5%) é o dia menos pontual**, e o fim de semana, o mais pontual.

### Hora prevista de partida

- As barras mais altas (maior pontualidade) estão na **madrugada e no início da manhã**, por volta das 4h às 6h.
- A pontualidade **decresce ao longo do dia**: a partir das **13h**, todas as barras ficam abaixo da média. A hora 0 também aparece abaixo da média.
- A dica de ferramenta mostra o número de voos avaliáveis de cada hora, o que evita superinterpretar horas de baixo volume.
### Aeroportos

Os 8 aeroportos exibidos, do melhor ao pior:

| Aeroporto | OTP de partida |
|---|---|
| SBBR Brasília | 88,7% |
| SBSV Salvador | 87,7% |
| SBRF Recife | 86,3% |
| SBGL Rio de Janeiro (Galeão) | 85,7% |
| SBCF Confins | 85,3% |
| SBKP Campinas | 82,3% |
| SBSP São Paulo (Congonhas) | 80,6% |
| **SBGR Guarulhos** | **72,9%** |

**Guarulhos é o pior aeroporto**, quase 10 p.p. abaixo da média geral (82,5% − 72,9% = 9,6 p.p.), e Congonhas vem em seguida. O recorte de 8 aeroportos se ajusta ao filtro: com outra companhia selecionada, a lista pode mudar (por exemplo, com a TAM entram Fortaleza e Curitiba).

### Doméstico × Internacional

| | OTP de partida | Cancelamento |
|---|---|---|
| Doméstico | 84,1% | 1,8% |
| Internacional | 74,6% | 8,3% (cerca de 4,6 vezes o doméstico) |

## Escolhendo uma companhia: o exemplo de Gol e TAM

Ao escolher uma companhia na lista **Companhia**, todos os cartões e gráficos são recalculados para ela, inclusive o pior mês, o pior aeroporto, os horários e os dias. O mesmo vale para os demais filtros (mês, escopo e UF de origem), que podem ser combinados.

Como exemplo, o panorama geral comparado com **Gol** e **TAM** (valores lidos no relatório com cada filtro aplicado):

| Indicador | Todas as companhias | Gol | TAM |
|---|---|---|---|
| Voos programados | 983.888 | 254.526 | 297.591 |
| OTP de partida | 82,5% | 86,1% | 80,4% |
| OTP de chegada | 82,9% | 87,0% | 80,9% |
| Atrasos > 60 min | 3,8% | 2,5% | 2,8% |
| Cancelamento | 3,0% | 1,2% | 1,5% |
| Atraso médio na chegada (min) | 4,06 | 0,18 | 3,39 |
| Mediana do atraso na chegada (min) | −4 | −6 | −2 |
| Minutos recuperados (média) | 3,57 | 4,54 | 3,19 |
| **Pior mês** | dez/25 (72,0%) | dez/25 (74,2%) | dez/25 (69,0%) |
| **Pior aeroporto** | Guarulhos (72,9%) | Guarulhos (76,6%) | Guarulhos (68,5%) |
| **Dia menos pontual** | sexta (80,5%) | sexta (84,2%) | sexta (76,9%) |
| **Dia mais pontual** | sábado (84,5%) | sábado (87,7%) | sábado (84,4%) |
| Doméstico: OTP e cancelamento | 84,1% e 1,8% | 86,0% e 1,2% | 80,9% e 1,6% |
| Internacional: OTP e cancelamento | 74,6% e 8,3% | 86,5% e 1,0% | 74,9% e 0,8% |

**O que essa comparação mostra**

- **A Gol fica acima da média geral** (86,1% × 82,5%) e a **TAM abaixo** (80,4%), com a TAM mais exposta ao pior dia: sexta tem 76,9%, contra 84,2% da Gol.
- **O padrão de época, lugar e dia se repete nas duas companhias:** dezembro, Guarulhos e sexta-feira são os piores pontos tanto para a Gol quanto para a TAM, apesar do nível geral diferente. Isso sugere que a causa está mais no contexto (época e aeroporto) do que em uma companhia específica, mas é uma hipótese que ainda precisa ser testada nas demais companhias.
- **A diferença entre doméstico e internacional não aparece em todas as companhias.** Na Gol, o internacional (86,5%) tem pontualidade parecida com a do doméstico (86,0%); na TAM, é menor (74,9% × 80,9%). A diferença do total (74,6% × 84,1%) depende, portanto, do conjunto de companhias e de tipos de operação, e é aí que a coluna `tipo_operacao` (passageiros × cargueira) pode ajudar em uma próxima análise.
- **O dia menos pontual muda de forma quando se filtra:** na Gol, segunda, quinta e sexta ficam abaixo da média da companhia; na TAM, quarta, quinta e sexta.
O mesmo procedimento vale para qualquer outra companhia (Azul, Azul Conecta, LATAM Airlines Group etc.): basta escolhê-la na lista e ler o pior mês, o pior aeroporto, o dia e a hora em que ela fica abaixo da média.

## Como interpretar: limitações e cuidados

- **Os dados mostram *quando* e *onde*, não *por quê*.** As colunas de justificativa foram descartadas e a base não traz a causa dos atrasos. Os achados são padrões, não explicações.
- **Doze meses não bastam para falar de sazonalidade.** Dezembro aparece uma única vez.
- **O OTP não conta tudo.** Cancelados, etapas sem horário previsto (30.787) e voos em quarentena (778) ficam fora do denominador. O rodapé mostra exatamente quanto.
- **A quarentena é uma regra de negócio da camada Gold.** Voos com atrasos extremos ficam fora do OTP; vale conhecer a regra antes de comparar com outras fontes.
- **O escopo (doméstico/internacional) segue o tipo de linha da ANAC, não a geografia.** Cerca de 0,9% dos voos divergem da regra por UF. Rotas entre aeroportos brasileiros podem ser classificadas como internacionais quando são linhas internacionais (mistas ou cargueiras).
- **O internacional inclui cargueiros.** O OTP internacional mistura voos de passageiros e de carga, e o efeito disso ainda não foi medido.
- **Os gráficos de aeroporto e de companhia exibem um recorte** (8 aeroportos e 5 companhias). Os demais entram nos totais dos cartões, mas não aparecem nesses gráficos.
- **TAM e LATAM Airlines Group aparecem separadas**, conforme o cadastro do VRA, embora pertençam ao mesmo grupo. Não foram consolidadas.
- **O eixo do gráfico mensal começa em 70%**, o que acentua visualmente as diferenças. Os rótulos mostram os valores exatos.
- **Cores são relativas.** O laranja indica "abaixo da média dos filtros selecionados", não "ruim" em termos absolutos.
- **O gráfico de aeroportos usa como referência a média dos 8 aeroportos exibidos** (cerca de 81,5% sem filtros), e não a média geral (82,5%). Por isso Campinas (82,3%) aparece em azul, embora esteja 0,2 p.p. abaixo da média geral, e o valor em p.p. do subtítulo (−8,6) difere da distância para a média geral (9,6 p.p.).
- **Comparar companhias exige olhar o volume.** Os valores são razões de somas e dependem do tamanho de cada recorte; a dica de ferramenta mostra os voos avaliáveis.

## Aprendizados

- **Definir antes de calcular.** Boa parte do trabalho foi decidir *o que conta* em cada indicador (denominador do OTP, universo do cancelamento, tratamento de outliers) e deixar isso visível no relatório.
- **Reconciliar com a fonte.** Fechar o funil (1.014.705 → 30 fora do período → 1.014.675) e conferir os cartões contra consultas SQL evitou números inconsistentes.
- **Qualidade de dados é parte da análise.** A correção do país dos aeroportos e a descoberta dos registros sem horário previsto mudaram a taxa de cancelamento e a leitura de "voos programados".
- **Storytelling guia o design.** O relatório passou de uma versão com tema visual, imagem de fundo e várias páginas para uma **página única**, ordenada em cenário, quando e onde, com títulos dinâmicos e rodapé de auditoria, após feedback de um analista de BI sênior.

## Próximos passos

- Página de dica de ferramenta para o cartão de atraso, com mediana, média dos voos atrasados e P90.
- Filtro por tipo de operação (passageiros/mista × cargueira) e análise do efeito da carga no internacional.
- Verificar se os padrões de época e de aeroporto se repetem ao filtrar cada companhia.
- Agrupar companhias do mesmo grupo (por exemplo, TAM e LATAM Airlines Group).
- Documentar o limite numérico da quarentena diretamente neste repositório.

---

[← Voltar ao README](../README.md)
