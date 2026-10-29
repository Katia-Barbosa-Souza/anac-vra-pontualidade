-- Compara o escopo da ANAC (escopo_voo, pelo tipo de linha) com uma regra geográfica por UF.
-- Regra testada (não adotada): doméstico quando origem E destino têm UF na dimensão.
--   CASE WHEN o.uf_aeroporto IS NOT NULL AND d.uf_aeroporto IS NOT NULL
--        THEN 'Doméstico' ELSE 'Internacional' END
-- Executar depois de 03_correcoes_dim_aeroporto.sql (a regra por UF depende da UF completa).

-- 0) Como o escopo está gravado? (confira o valor antes de filtrar por ele)
SELECT escopo_voo, COUNT(*) AS voos
FROM gold.fato_voos
GROUP BY 1
ORDER BY 1;

-- 1) Tipos de linha da ANAC entre aeroportos que têm UF
SELECT f.descricao_di, COUNT(*) AS voos
FROM gold.fato_voos f
JOIN gold.dim_aeroporto o ON o.icao_aeroporto = f.icao_origem
JOIN gold.dim_aeroporto d ON d.icao_aeroporto = f.icao_destino
WHERE o.uf_aeroporto IS NOT NULL
  AND d.uf_aeroporto IS NOT NULL
GROUP BY f.descricao_di
ORDER BY voos DESC;

-- 2) Escopo da ANAC x regra por UF
-- Esperado: as combinações divergentes somam cerca de 0,9% dos voos
-- (9.406 voos, valor registrado em docs/decisoes-metodologicas.md)
SELECT
    f.escopo_voo,
    (o.uf_aeroporto IS NOT NULL AND d.uf_aeroporto IS NOT NULL) AS origem_e_destino_com_uf,
    COUNT(*) AS voos
FROM gold.fato_voos f
LEFT JOIN gold.dim_aeroporto o ON o.icao_aeroporto = f.icao_origem
LEFT JOIN gold.dim_aeroporto d ON d.icao_aeroporto = f.icao_destino
GROUP BY 1, 2
ORDER BY 1, 2;

-- 3) Onde estão as divergências (prefixos ICAO de origem e destino)
-- ILIKE 'dom_stico' casa com "Doméstico" e "Domestico", conforme estiver gravado.
SELECT
    f.escopo_voo,
    LEFT(f.icao_origem, 2)  AS prefixo_origem,
    LEFT(f.icao_destino, 2) AS prefixo_destino,
    COUNT(*) AS voos
FROM gold.fato_voos f
LEFT JOIN gold.dim_aeroporto o ON o.icao_aeroporto = f.icao_origem
LEFT JOIN gold.dim_aeroporto d ON d.icao_aeroporto = f.icao_destino
WHERE (f.escopo_voo ILIKE 'dom_stico')
   <> (o.uf_aeroporto IS NOT NULL AND d.uf_aeroporto IS NOT NULL)
GROUP BY 1, 2, 3
ORDER BY voos DESC
LIMIT 20;

-- 4) Rotas entre aeroportos com UF que a ANAC classifica como internacionais
SELECT f.icao_origem, f.icao_destino, f.descricao_tipo_linha, COUNT(*) AS voos
FROM gold.fato_voos f
JOIN gold.dim_aeroporto o ON o.icao_aeroporto = f.icao_origem
JOIN gold.dim_aeroporto d ON d.icao_aeroporto = f.icao_destino
WHERE f.escopo_voo NOT ILIKE 'dom_stico'
  AND o.uf_aeroporto IS NOT NULL
  AND d.uf_aeroporto IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY voos DESC
LIMIT 15;

-- 5) Aeroportos da dimensão sem UF
SELECT icao_aeroporto, nome_aeroporto, municipio_aeroporto, uf_aeroporto, pais_aeroporto
FROM gold.dim_aeroporto
WHERE uf_aeroporto IS NULL
ORDER BY icao_aeroporto;