# Decisões metodológicas
 
Os números do dashboard dependem de definições: o que é "pontual", o que entra no denominador e o que fica de fora. Este documento registra cada decisão e o motivo.
 
## Convenções de cálculo
 
- Todo percentual é uma **razão de somas** (por exemplo, pontuais ÷ avaliáveis), nunca uma média de percentuais.
- **Pontual** significa atraso de até 15 minutos.
- O OTP de partida e o de chegada usam o **mesmo denominador** (voos avaliáveis).
- Voos sem horário previsto ficam **fora** do denominador do cancelamento e do OTP.
- Nas fórmulas abaixo, o separador de argumentos é `;` (configuração regional pt-BR do Power BI).
## O funil dos registros
 
Nem todo registro é um voo programado e avaliável. Cada registro cai em uma única categoria (consulta em [`sql/funil-registros.sql`](../sql/funil-registros.sql)).
 
Resultado na base completa (antes do filtro de período): 29.145 cancelados, 953.982 avaliáveis, 30.800 sem horário previsto e 778 em quarentena, totalizando 1.014.705.
 
No Power BI, a mesma lógica virou a coluna `categoria_voo` (Power Query):
 
```m
if [voo_cancelado] = true then "1. Cancelado"
else if [partida_pontual] <> null then "2. Avaliável"
else if [partida_prevista] = null then "3. Sem horário previsto (extra/retorno)"
else "4. Quarentena (fora de faixa)"
```
 
Com o filtro de período aplicado, o funil do relatório fecha assim:
 
| Categoria | Voos |
|---|---|
| 1. Cancelado | 29.141 |
| 2. Avaliável | 953.969 |
| 3. Sem horário previsto (extra/retorno) | 30.787 |
| 4. Quarentena (fora de faixa) | 778 |
| **Total (voos registrados)** | **1.014.675** |
 
- **Voos programados** = cancelados + avaliáveis + quarentena = **983.888** (os registros que tinham horário previsto).
- **Sem horário previsto** são etapas operacionais como extra, retorno, inclusão de etapa e etapa não remunerada: aparecem sem horário previsto e, por isso, sem mês, dia, hora e métrica.
- **Quarentena** reúne voos com atraso fora de uma faixa plausível, sinalizados pela regra da camada Gold. Nesses voos os campos de atraso e de pontualidade ficam vazios, então eles não entram no OTP. Exemplos observados na amostra analisada: um voo de carga que partiu cerca de 317 minutos antes do previsto e outro com cerca de 1.610 minutos de atraso.
## Decisões e correções aplicadas
 
| Decisão | Motivo |
|---|---|
| **Janela de 01/08/2025 a 31/07/2026** (filtro por `data_ref` no Power Query) | Havia 30 voos fora da janela (4 em 31/07/2025 e 26 em 01/08/2026), de meses vizinhos incompletos. Foram excluídos e documentados. A base final tem 1.014.675 registros |
| **OTP sobre voos avaliáveis** (com métrica) | Evita subestimar a pontualidade (ver "Validações que sustentam os números") |
| **Cancelamento sobre voos programados** | Etapas sem horário previsto nunca foram programadas; incluí-las diluiria a taxa |
| **País do aeroporto pelo prefixo ICAO** | Aeródromos brasileiros com prefixos diferentes de `SB` (por exemplo, `SD`, `SN`, `SS` e `SW`) estavam classificados como "Exterior". Os prefixos brasileiros são `SB`, `SD`, `SI`, `SJ`, `SN`, `SS` e `SW` |
| **Município e UF de SBCR (Corumbá/MS) e SBIZ (Imperatriz/MA) completados** | Ambos tinham nome, mas não UF na dimensão |
| **Colunas de controle descartadas** | Justificativa, datas de carga, arquivo de origem, código de etapa, hora em texto e rota não tinham uso analítico |
| **`partida_pontual` e `chegada_pontual` como 0/1 inteiro** | Permite somar para obter o OTP |
| **Coluna `tipo_operacao`** (passageiros/mista × cargueira) | Prepara a análise do efeito da carga no internacional (ainda não explorada no relatório) |
 
A regra de classificação do país, aplicada à dimensão de aeroportos:
 
```sql
CASE WHEN LEFT(<codigo_icao>, 2) IN ('SB','SD','SI','SJ','SN','SS','SW')
     THEN 'Brasil' ELSE 'Exterior' END
```
 
## Validações que sustentam os números
 
Consultas de validação sobre a base completa, antes do filtro de período:
 
| Verificação | Resultado |
|---|---|
| Total de voos na `fato_voos` (base completa) | 1.014.705 |
| Voos com métrica de pontualidade | 953.982 |
| Voos cancelados | 29.145 |
| Voos sem mês de referência | 30.800 |
| OTP de partida sobre voos com métrica × sobre o total | 82,48% × 77,54% |
| Voos em que só partida **ou** só chegada tem métrica | 0 (os dois usam o mesmo denominador) |
| Aeroportos dos voos ausentes na `dim_aeroporto` | 0 |
| Escopo (`escopo_voo`) × regra por UF dos aeroportos | 9.406 voos divergem (cerca de 0,9%) |
 
A diferença entre 82,48% e 77,54% mostra por que o denominador importa: calcular o OTP sobre todos os registros subestima a pontualidade, porque inclui voos que nunca tiveram métrica.
 
## Como cada indicador é calculado
 
Todas as razões usam o mesmo princípio: **soma ÷ soma**, nunca média de percentuais. O OTP de partida e o de chegada compartilham o mesmo denominador (voos avaliáveis).
 
| Indicador | Medida | Definição | Onde aparece |
|---|---|---|---|
| Voos Programados | `Voos Programados` | Registros com horário previsto (total menos os sem horário previsto) | Cartão 1 |
| Pontualidade de partida | `OTP Partida %` | Partidas pontuais ÷ voos avaliáveis | Cartão 2, gráficos, cartões Dom/Int |
| Avaliáveis | `Voos Avaliaveis` | Voos com métrica de pontualidade | Cartão 2 (e dica de ferramenta do gráfico por hora) |
| Pontualidade de chegada | `OTP Chegada %` | Chegadas pontuais ÷ voos avaliáveis | Cartão 3 |
| Atrasos > 60 min | `Atrasos > 60 min %` | Voos com atraso superior a 60 min ÷ voos avaliáveis | Cartão 3 |
| Taxa de cancelamento | `Cancelamento %` | Cancelados ÷ voos programados | Cartão 4 e cartões Dom/Int |
| Voos cancelados | `Voos Cancelados` | Contagem de voos cancelados | Cartão 4 |
| Atraso na chegada (min) | `Atraso Médio Chegada (min)` | Média de todos os voos avaliados (adiantamentos contam como valor negativo) | Cartão 5 |
| Mediana | `Atraso Mediano Chegada (min)` | Mediana do atraso na chegada | Cartão 5 |
| Minutos recuperados | `Minutos Recuperados Médio` | Média de (atraso na partida − atraso na chegada) | Cartão 6 |
| Atraso na partida | `Atraso Médio Partida (min)` | Média do atraso na partida | Cartão 6 |
 
**Decisões de cálculo que sustentam os cartões**
 
- **Cartão 1 usa voos *programados*, não o total de registros.** Os 30.787 registros sem horário previsto (etapas extras, retornos e semelhantes) não foram programados e ficam fora.
- **Cartão 4 divide por voos programados**, para que etapas sem horário previsto não diluam a taxa.
- **Cartão 5 mostra a média e a mediana juntas de propósito.** A mediana (−4) descreve o voo típico, que chega adiantado; a média (4,06) é puxada pela cauda de atrasos longos. A distância entre as duas já conta a história do dashboard.
- **Cartão 6 fecha com o 5:** atraso médio na partida (7,63) − atraso médio na chegada (4,06) = 3,57 minutos recuperados.
- **Voos sem horário previsto, cancelados e em quarentena não entram no OTP.** O rodapé mostra quanto fica de fora.
As fórmulas completas estão em [`powerbi/medidas.dax`](../powerbi/medidas.dax).
 
---
 
[← Voltar ao README](../README.md)