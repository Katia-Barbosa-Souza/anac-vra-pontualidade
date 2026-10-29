-- ATENÇÃO: este script ALTERA dados. Executar uma vez, na ordem, dentro da transação.
-- Já aplicado neste projeto; as atualizações são idempotentes (rodar de novo não muda o resultado).
-- A correção foi feita na cópia do PostgreSQL, não na Gold do Databricks.

BEGIN;

-- 1) País pelo prefixo ICAO (sem WHERE: atualiza todos os aeroportos da dimensão)
-- Aeródromos brasileiros com prefixo diferente de SB (SD, SN, SS, SW...) estavam como "Exterior".
UPDATE gold.dim_aeroporto
SET pais_aeroporto = CASE
        WHEN LEFT(icao_aeroporto, 2) IN ('SB', 'SD', 'SI', 'SJ', 'SN', 'SS', 'SW') THEN 'Brasil'
        ELSE 'Exterior'
    END;

-- 2) Município e UF faltantes (tinham nome, mas não UF)
UPDATE gold.dim_aeroporto
SET municipio_aeroporto = 'CORUMBÁ', uf_aeroporto = 'Mato Grosso do Sul'
WHERE icao_aeroporto = 'SBCR';

UPDATE gold.dim_aeroporto
SET municipio_aeroporto = 'IMPERATRIZ', uf_aeroporto = 'Maranhão'
WHERE icao_aeroporto = 'SBIZ';

-- 3) Verificação antes de confirmar
SELECT icao_aeroporto, municipio_aeroporto, uf_aeroporto, pais_aeroporto
FROM gold.dim_aeroporto
WHERE icao_aeroporto IN ('SBCR', 'SBIZ');

SELECT pais_aeroporto, COUNT(*) AS aeroportos
FROM gold.dim_aeroporto
GROUP BY 1
ORDER BY 1;

COMMIT;  -- se algo estiver errado, use ROLLBACK; no lugar