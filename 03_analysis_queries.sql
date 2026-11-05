USE Netflix_Analytics;
GO

-- Analysis 1: Total titles, movies and TV shows.
SELECT
    COUNT(*) AS total_titles,
    SUM(CASE WHEN type = 'MOVIE' THEN 1 ELSE 0 END) AS total_movies,
    SUM(CASE WHEN type IN ('SHOW', 'TV SHOW', 'TV SERIES') THEN 1 ELSE 0 END) AS total_tv_shows
FROM dbo.netflix_clean;
GO

-- Analysis 2: Movies versus TV shows.
SELECT type, COUNT(*) AS total_titles
FROM dbo.netflix_clean
GROUP BY type
ORDER BY total_titles DESC;
GO

-- Analysis 3: Titles by release year.
SELECT release_year, COUNT(*) AS total_titles
FROM dbo.netflix_clean
WHERE release_year IS NOT NULL
GROUP BY release_year
ORDER BY release_year;
GO

-- Analysis 4: Top 10 genres.
SELECT TOP (10)
    genre,
    COUNT(DISTINCT id) AS total_titles
FROM dbo.netflix_genre
GROUP BY genre
ORDER BY total_titles DESC, genre;
GO

-- Analysis 5: Top 10 production countries.
SELECT TOP (10)
    country,
    COUNT(DISTINCT id) AS total_titles
FROM dbo.netflix_country
GROUP BY country
ORDER BY total_titles DESC, country;
GO

-- Analysis 6: Average IMDb and TMDB scores by content type.
SELECT
    type,
    AVG(imdb_score) AS average_imdb_score,
    AVG(tmdb_score) AS average_tmdb_score
FROM dbo.netflix_clean
GROUP BY type;
GO

-- Analysis 7: Average runtime by content type.
SELECT
    type,
    AVG(CAST(runtime AS DECIMAL(10,2))) AS average_runtime_minutes,
    MIN(runtime) AS minimum_runtime,
    MAX(runtime) AS maximum_runtime
FROM dbo.netflix_clean
WHERE runtime IS NOT NULL
GROUP BY type;
GO

-- Analysis 8: TV shows by number of seasons.
SELECT
    seasons,
    COUNT(*) AS total_shows
FROM dbo.netflix_clean
WHERE seasons IS NOT NULL
GROUP BY seasons
ORDER BY seasons;
GO

-- Analysis 9: Age certification distribution.
SELECT
    age_certification,
    COUNT(*) AS total_titles
FROM dbo.netflix_clean
WHERE age_certification IS NOT NULL
GROUP BY age_certification
ORDER BY total_titles DESC;
GO

-- Analysis 10: Most voted titles.
SELECT TOP (10)
    title, type, release_year, imdb_score, imdb_votes
FROM dbo.netflix_clean
WHERE imdb_votes IS NOT NULL
ORDER BY imdb_votes DESC;
GO

-- Analysis 11: Highest rated titles with a minimum of 1,000 IMDb votes.
SELECT TOP (10)
    title, type, release_year, imdb_score, imdb_votes
FROM dbo.netflix_clean
WHERE imdb_score IS NOT NULL
  AND imdb_votes >= 1000
ORDER BY imdb_score DESC, imdb_votes DESC;
GO

-- Analysis 12: Titles by release decade.
SELECT
    (release_year / 10) * 10 AS release_decade,
    COUNT(*) AS total_titles
FROM dbo.netflix_clean
WHERE release_year IS NOT NULL
GROUP BY (release_year / 10) * 10
ORDER BY release_decade;
GO
