/*
Netflix Analytics Assignment
04. Create Tableau-friendly SQL views

In Tableau, connect to SQL Server and use these views.
Use separate views for genres and countries to avoid multiplying
records by joining both multi-value mapping tables together.
*/

USE Netflix_Analytics;
GO

CREATE OR ALTER VIEW dbo.vw_netflix_kpis
AS
SELECT
    COUNT(*) AS total_titles,
    SUM(CASE WHEN UPPER(type) = 'MOVIE' THEN 1 ELSE 0 END) AS total_movies,
    SUM(CASE WHEN UPPER(type) IN ('SHOW', 'TV SHOW', 'TV SERIES') THEN 1 ELSE 0 END) AS total_tv_shows,
    AVG(CAST(imdb_score AS DECIMAL(10,2))) AS average_imdb_score,
    AVG(CAST(tmdb_score AS DECIMAL(10,2))) AS average_tmdb_score,
    AVG(CAST(runtime AS DECIMAL(10,2))) AS average_runtime_minutes
FROM dbo.netflix_clean;
GO

CREATE OR ALTER VIEW dbo.vw_netflix_by_release_year
AS
SELECT release_year, type, COUNT(*) AS total_titles
FROM dbo.netflix_clean
WHERE release_year IS NOT NULL
GROUP BY release_year, type;
GO

CREATE OR ALTER VIEW dbo.vw_netflix_by_genre
AS
SELECT genre, COUNT(DISTINCT id) AS total_titles
FROM dbo.netflix_genre
GROUP BY genre;
GO

CREATE OR ALTER VIEW dbo.vw_netflix_by_country
AS
SELECT country, COUNT(DISTINCT id) AS total_titles
FROM dbo.netflix_country
GROUP BY country;
GO

CREATE OR ALTER VIEW dbo.vw_netflix_by_rating
AS
SELECT age_certification, type, COUNT(*) AS total_titles
FROM dbo.netflix_clean
WHERE age_certification IS NOT NULL
GROUP BY age_certification, type;
GO

CREATE OR ALTER VIEW dbo.vw_netflix_by_imdb_score
AS
SELECT
    type,
    CAST(ROUND(imdb_score, 0) AS INT) AS imdb_score_bucket,
    COUNT(*) AS total_titles
FROM dbo.netflix_clean
WHERE imdb_score IS NOT NULL
GROUP BY type, CAST(ROUND(imdb_score, 0) AS INT);
GO

CREATE OR ALTER VIEW dbo.vw_netflix_runtime
AS
SELECT id, title, type, release_year, runtime, seasons, imdb_score, tmdb_score
FROM dbo.netflix_clean;
GO

CREATE OR ALTER VIEW dbo.vw_netflix_details
AS
SELECT
    id, title, type, release_year, age_certification,
    runtime, seasons, imdb_score, imdb_votes,
    tmdb_popularity, tmdb_score
FROM dbo.netflix_clean;
GO

-- Confirm that the views were created.
SELECT name
FROM sys.views
WHERE name LIKE 'vw_netflix%'
ORDER BY name;
GO
