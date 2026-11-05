USE Netflix_Analytics;
GO

IF OBJECT_ID('dbo.netflix_clean', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.netflix_clean
    (
        id NVARCHAR(50) NOT NULL PRIMARY KEY,
        title NVARCHAR(500) NULL,
        type NVARCHAR(20) NULL,
        description NVARCHAR(MAX) NULL,
        release_year SMALLINT NULL,
        age_certification NVARCHAR(20) NULL,
        runtime SMALLINT NULL,
        seasons SMALLINT NULL,
        imdb_id NVARCHAR(30) NULL,
        imdb_score DECIMAL(5,2) NULL,
        imdb_votes BIGINT NULL,
        tmdb_popularity DECIMAL(18,3) NULL,
        tmdb_score DECIMAL(5,2) NULL
    );
END;
GO

IF OBJECT_ID('dbo.netflix_genre', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.netflix_genre
    (
        id NVARCHAR(50) NOT NULL,
        genre NVARCHAR(150) NOT NULL
    );
END;
GO

IF OBJECT_ID('dbo.netflix_country', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.netflix_country
    (
        id NVARCHAR(50) NOT NULL,
        country NVARCHAR(100) NOT NULL
    );
END;
GO

-- Clear previous results so rerunning this script does not duplicate rows.
DELETE FROM dbo.netflix_genre;
DELETE FROM dbo.netflix_country;
DELETE FROM dbo.netflix_clean;
GO

-- Clean the main title records.
;WITH ranked AS
(
    SELECT *,
        ROW_NUMBER() OVER
        (
            PARTITION BY LTRIM(RTRIM(id))
            ORDER BY LTRIM(RTRIM(title))
        ) AS rn
    FROM dbo.netflix_raw
    WHERE NULLIF(LTRIM(RTRIM(id)), '') IS NOT NULL
)
INSERT INTO dbo.netflix_clean
(
    id, title, type, description, release_year, age_certification,
    runtime, seasons, imdb_id, imdb_score, imdb_votes,
    tmdb_popularity, tmdb_score
)
SELECT
    LTRIM(RTRIM(id)),
    NULLIF(LTRIM(RTRIM(title)), ''),
    NULLIF(LTRIM(RTRIM(type)), ''),
    description,
    TRY_CONVERT(SMALLINT, NULLIF(LTRIM(RTRIM(release_year)), '')),
    NULLIF(LTRIM(RTRIM(age_certification)), ''),
    TRY_CONVERT(SMALLINT, NULLIF(LTRIM(RTRIM(runtime)), '')),
    TRY_CONVERT(SMALLINT, NULLIF(LTRIM(RTRIM(seasons)), '')),
    NULLIF(LTRIM(RTRIM(imdb_id)), ''),
    TRY_CONVERT(DECIMAL(5,2), NULLIF(LTRIM(RTRIM(imdb_score)), '')),
    TRY_CONVERT(BIGINT, REPLACE(NULLIF(LTRIM(RTRIM(imdb_votes)), ''), ',', '')),
    TRY_CONVERT(DECIMAL(18,3), NULLIF(LTRIM(RTRIM(tmdb_popularity)), '')),
    TRY_CONVERT(DECIMAL(5,2), NULLIF(LTRIM(RTRIM(tmdb_score)), ''))
FROM ranked
WHERE rn = 1;
GO

-- Split genre values. This handles common list formats such as:
-- comedy, drama OR ['comedy', 'drama'].
INSERT INTO dbo.netflix_genre (id, genre)
SELECT DISTINCT
    n.id,
    LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(s.value, '[', ''), ']', ''), '''', ''), '"', '')))
FROM dbo.netflix_raw AS n
CROSS APPLY STRING_SPLIT(
    REPLACE(REPLACE(REPLACE(REPLACE(COALESCE(n.genres, ''), '[', ''), ']', ''), '''', ''), '"', ''),
    ','
) AS s
WHERE NULLIF(LTRIM(RTRIM(n.id)), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(s.value)), '') IS NOT NULL;
GO

-- Split production countries.
INSERT INTO dbo.netflix_country (id, country)
SELECT DISTINCT
    n.id,
    LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(s.value, '[', ''), ']', ''), '''', ''), '"', '')))
FROM dbo.netflix_raw AS n
CROSS APPLY STRING_SPLIT(
    REPLACE(REPLACE(REPLACE(REPLACE(COALESCE(n.production_countries, ''), '[', ''), ']', ''), '''', ''), '"', ''),
    ','
) AS s
WHERE NULLIF(LTRIM(RTRIM(n.id)), '') IS NOT NULL
  AND NULLIF(LTRIM(RTRIM(s.value)), '') IS NOT NULL;
GO

-- Validation counts.
SELECT 'Raw titles' AS table_name, COUNT(*) AS record_count FROM dbo.netflix_raw
UNION ALL
SELECT 'Clean titles', COUNT(*) FROM dbo.netflix_clean
UNION ALL
SELECT 'Genre mappings', COUNT(*) FROM dbo.netflix_genre
UNION ALL
SELECT 'Country mappings', COUNT(*) FROM dbo.netflix_country;
GO
