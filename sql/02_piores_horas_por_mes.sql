-- 02_piores_horas_por_mes.sql
-- Pergunta: existe uma hora de partida consistentemente pior, mês a mês?
-- Taxa de atraso sobre os voos avaliáveis, por mês e hora prevista de partida.
-- Combinações com menos de 100 voos avaliáveis são descartadas: uma hora com poucos voos
-- poderia aparecer com taxa extrema e distorcer o ranking.
-- Período: 01/08/2025 a 31/07/2026.

WITH por_hora_mes AS (
    SELECT
        DATE_TRUNC('month', partida_prevista_data)::date AS mes,
        hora_partida_prevista,
        COUNT(partida_pontual)                           AS avaliaveis,
        ROUND(100.0 * COUNT(*) FILTER (WHERE partida_pontual = false)
              / COUNT(partida_pontual), 2)               AS pct_atrasados,
        ROUND(AVG(atraso_partida_min) FILTER (WHERE partida_pontual = false), 1)
                                                         AS media_min_atraso   -- só de quem atrasou
    FROM gold.fato_voos
    WHERE partida_prevista_data BETWEEN DATE '2025-08-01' AND DATE '2026-07-31'
      AND partida_pontual IS NOT NULL
    GROUP BY 1, 2
    HAVING COUNT(partida_pontual) >= 100
),
ranking AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY mes ORDER BY pct_atrasados DESC) AS rank_pior_hora
    FROM por_hora_mes
)
-- A) As 3 piores horas de cada mês
SELECT mes, hora_partida_prevista, pct_atrasados, media_min_atraso, avaliaveis, rank_pior_hora
FROM ranking
WHERE rank_pior_hora <= 3
ORDER BY mes, rank_pior_hora;

-- B) Em quantos meses cada hora aparece entre as 3 piores?
-- Leitura: uma hora que aparece em quase todos os meses indica um horário
-- consistentemente pior, e não apenas um mês ruim isolado.
WITH por_hora_mes AS (
    SELECT
        DATE_TRUNC('month', partida_prevista_data)::date AS mes,
        hora_partida_prevista,
        ROUND(100.0 * COUNT(*) FILTER (WHERE partida_pontual = false)
              / COUNT(partida_pontual), 2)               AS pct_atrasados
    FROM gold.fato_voos
    WHERE partida_prevista_data BETWEEN DATE '2025-08-01' AND DATE '2026-07-31'
      AND partida_pontual IS NOT NULL
    GROUP BY 1, 2
    HAVING COUNT(partida_pontual) >= 100
),
ranking AS (
    SELECT *, RANK() OVER (PARTITION BY mes ORDER BY pct_atrasados DESC) AS rank_pior_hora
    FROM por_hora_mes
)
SELECT hora_partida_prevista, COUNT(*) AS meses_no_top3
FROM ranking
WHERE rank_pior_hora <= 3
GROUP BY hora_partida_prevista
ORDER BY meses_no_top3 DESC, hora_partida_prevista;