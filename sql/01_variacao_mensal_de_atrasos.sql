-- 01_variacao_mensal_de_atrasos.sql
-- Pergunta: como a taxa de atrasos na partida varia de um mês para o outro?
-- Usa a taxa sobre os voos avaliáveis (mesma convenção do OTP), não a contagem absoluta,
-- porque meses com mais voos (como dezembro) teriam mais atrasos só pelo volume.
-- Período: 01/08/2025 a 31/07/2026.
-- Conferência: pct_atrasados = 100 - OTP de partida do gráfico mensal (dez/2025 ≈ 28,0%).

WITH por_mes AS (
    SELECT
        DATE_TRUNC('month', partida_prevista_data)::date          AS mes,
        COUNT(partida_pontual)                                    AS avaliaveis,
        COUNT(*) FILTER (WHERE partida_pontual = false)           AS atrasados
    FROM gold.fato_voos
    WHERE partida_prevista_data BETWEEN DATE '2025-08-01' AND DATE '2026-07-31'
      AND partida_pontual IS NOT NULL
    GROUP BY 1
),
taxa AS (
    SELECT
        mes,
        avaliaveis,
        atrasados,
        ROUND(100.0 * atrasados / avaliaveis, 2) AS pct_atrasados
    FROM por_mes
)
SELECT
    mes,
    avaliaveis,
    atrasados,
    pct_atrasados,
    LAG(pct_atrasados) OVER (ORDER BY mes)                  AS pct_mes_anterior,
    ROUND(pct_atrasados - LAG(pct_atrasados) OVER (ORDER BY mes), 2) AS variacao_pp
FROM taxa
ORDER BY mes;