-- Base dos indicadores: visão geral, denominador do OTP, janela de período e funil.
-- Base: gold.fato_voos completa (antes do filtro de período aplicado no Power BI).

-- 1) Visão geral
SELECT
    COUNT(*)                                  AS total,
    COUNT(partida_pontual)                    AS com_metrica,
    COUNT(*) FILTER (WHERE voo_cancelado)     AS cancelados,
    COUNT(*) FILTER (WHERE mes_referencia IS NULL) AS sem_mes
FROM gold.fato_voos;
-- Esperado: total = 1.014.705 | com_metrica = 953.982 | cancelados = 29.145 | sem_mes = 30.800


-- 2) Por que o denominador importa: OTP de partida sobre voos com métrica x sobre todos os registros
SELECT
    ROUND(100.0 * SUM(CASE WHEN partida_pontual THEN 1 ELSE 0 END) / COUNT(partida_pontual), 2) AS otp_sobre_com_metrica,
    ROUND(100.0 * SUM(CASE WHEN partida_pontual THEN 1 ELSE 0 END) / COUNT(*), 2)               AS otp_sobre_total
FROM gold.fato_voos;
-- Esperado: 82,48 x 77,54


-- 3) Partida e chegada usam o mesmo denominador?
SELECT
    COUNT(*) FILTER (WHERE partida_pontual IS NOT NULL AND chegada_pontual IS NULL)     AS so_partida,
    COUNT(*) FILTER (WHERE partida_pontual IS NULL     AND chegada_pontual IS NOT NULL) AS so_chegada,
    COUNT(*) FILTER (WHERE partida_pontual IS NOT NULL AND chegada_pontual IS NOT NULL) AS ambos
FROM gold.fato_voos;
-- Esperado: so_partida = 0 e so_chegada = 0


-- 4) Registros fora da janela do projeto (01/08/2025 a 31/07/2026)
SELECT
    COALESCE(partida_prevista_data, partida_real::date) AS data_ref,
    (partida_prevista_data IS NULL)                     AS sem_data_prevista,
    descricao_di,
    COUNT(*)                                            AS voos
FROM gold.fato_voos
WHERE COALESCE(partida_prevista_data, partida_real::date) < DATE '2025-08-01'
   OR COALESCE(partida_prevista_data, partida_real::date) > DATE '2026-07-31'
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;
-- Esperado: 30 voos no total (4 em 31/07/2025 e 26 em 01/08/2026)


-- 5) Funil dos registros: cada registro cai em uma única categoria
SELECT CASE
         WHEN voo_cancelado               THEN '1. Cancelado'
         WHEN partida_pontual IS NOT NULL THEN '2. Avaliável'
         WHEN partida_prevista IS NULL    THEN '3. Sem horário previsto (extra/retorno)'
         ELSE                                  '4. Quarentena (fora de faixa)'
       END AS categoria,
       COUNT(*) AS voos
FROM gold.fato_voos
GROUP BY 1
ORDER BY 1;
-- Esperado: 1. Cancelado = 29.145 | 2. Avaliável = 953.982
--           3. Sem horário previsto = 30.800 | 4. Quarentena = 778


-- 6) Faixa de atraso dos voos avaliáveis
SELECT
    MIN(atraso_partida_min) AS min_atraso_partida,
    MAX(atraso_partida_min) AS max_atraso_partida,
    MIN(atraso_chegada_min) AS min_atraso_chegada,
    MAX(atraso_chegada_min) AS max_atraso_chegada
FROM gold.fato_voos
WHERE partida_pontual IS NOT NULL;
-- Os voos em quarentena têm os campos de atraso vazios; o limite numérico da quarentena
-- está definido na camada Gold (Databricks). Esta consulta mostra a faixa que ficou no OTP.