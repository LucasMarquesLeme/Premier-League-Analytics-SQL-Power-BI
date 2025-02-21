-- Seleciona todos os dados da tabela English Premier League
SELECT * FROM public.english_premier_league;

-- Identifica registros com valores nulos em colunas importantes
SELECT * FROM public.english_premier_league
WHERE league IS NULL
   OR date IS NULL
   OR home_team IS NULL
   OR away_team IS NULL
   OR result IS NULL;

-- Remove registros com valores nulos para garantir a integridade dos dados
DELETE FROM public.english_premier_league
WHERE league IS NULL
   OR date IS NULL
   OR home_team IS NULL
   OR away_team IS NULL
   OR result IS NULL;

-- Calcula o desempenho dos times como mandantes (jogando em casa)
SELECT home_team AS team, 
       COUNT(CASE WHEN result = 'H' THEN 1 END) AS home_wins,  -- Contagem de vitórias em casa
       COUNT(CASE WHEN result = 'D' THEN 1 END) AS home_draws, -- Contagem de empates em casa
       COUNT(CASE WHEN result = 'A' THEN 1 END) AS home_losses -- Contagem de derrotas em casa
FROM english_premier_league
GROUP BY home_team;

-- Calcula o desempenho dos times como visitantes (jogando fora de casa)
SELECT away_team AS team, 
       COUNT(CASE WHEN result = 'A' THEN 1 END) AS away_wins,  -- Contagem de vitórias fora de casa
       COUNT(CASE WHEN result = 'D' THEN 1 END) AS away_draws, -- Contagem de empates fora de casa
       COUNT(CASE WHEN result = 'H' THEN 1 END) AS away_losses -- Contagem de derrotas fora de casa
FROM english_premier_league
GROUP BY away_team;

-- Calcula o total de gols marcados por cada time, somando os gols feitos em casa e fora
SELECT team, SUM(goals_scored) AS total_goals
FROM (
    -- Seleciona gols feitos em casa
    SELECT home_team AS team, SUM(home_goals) AS goals_scored
    FROM public.english_premier_league
    GROUP BY home_team

    UNION ALL

    -- Seleciona gols feitos como visitante
    SELECT away_team AS team, SUM(away_goals) AS goals_scored
    FROM public.english_premier_league
    GROUP BY away_team
) AS combined
GROUP BY team
ORDER BY total_goals DESC;

-- Analisa a quantidade de vitórias, empates e derrotas por mês ao longo da temporada
SELECT EXTRACT(MONTH FROM date) AS month, -- Extrai o mês da data da partida
       COUNT(CASE WHEN result = 'H' THEN 1 END) AS home_wins,  -- Total de vitórias dos mandantes por mês
       COUNT(CASE WHEN result = 'A' THEN 1 END) AS away_wins,  -- Total de vitórias dos visitantes por mês
       COUNT(CASE WHEN result = 'D' THEN 1 END) AS draws       -- Total de empates por mês
FROM public.english_premier_league
GROUP BY EXTRACT(MONTH FROM date)
ORDER BY month;
