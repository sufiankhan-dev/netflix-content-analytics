USE Netflix_Analytics;
GO

-- Confirm that the raw table exists and inspect its columns.
SELECT
    c.column_id,
    c.name AS column_name,
    TYPE_NAME(c.user_type_id) AS data_type,
    c.max_length
FROM sys.columns AS c
WHERE c.object_id = OBJECT_ID('dbo.netflix_raw')
ORDER BY c.column_id;
GO

-- Count imported rows.
SELECT COUNT(*) AS raw_record_count
FROM dbo.netflix_raw;
GO

-- Preview records.
SELECT TOP (20) *
FROM dbo.netflix_raw;
GO

-- Check missing values in important fields.
SELECT
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(id)), '') IS NULL THEN 1 ELSE 0 END) AS missing_id,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(title)), '') IS NULL THEN 1 ELSE 0 END) AS missing_title,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(type)), '') IS NULL THEN 1 ELSE 0 END) AS missing_type,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(release_year)), '') IS NULL THEN 1 ELSE 0 END) AS missing_release_year,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(genres)), '') IS NULL THEN 1 ELSE 0 END) AS missing_genres,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(production_countries)), '') IS NULL THEN 1 ELSE 0 END) AS missing_countries
FROM dbo.netflix_raw;
GO

-- Check duplicate IDs.
SELECT id, COUNT(*) AS duplicate_count
FROM dbo.netflix_raw
GROUP BY id
HAVING COUNT(*) > 1;
GO

-- Check values that cannot be converted to numbers.
SELECT
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(release_year)), '') IS NOT NULL
                  AND TRY_CONVERT(INT, release_year) IS NULL THEN 1 ELSE 0 END) AS invalid_release_year,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(runtime)), '') IS NOT NULL
                  AND TRY_CONVERT(INT, runtime) IS NULL THEN 1 ELSE 0 END) AS invalid_runtime,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(seasons)), '') IS NOT NULL
                  AND TRY_CONVERT(INT, seasons) IS NULL THEN 1 ELSE 0 END) AS invalid_seasons,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(imdb_score)), '') IS NOT NULL
                  AND TRY_CONVERT(DECIMAL(5,2), imdb_score) IS NULL THEN 1 ELSE 0 END) AS invalid_imdb_score,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(imdb_votes)), '') IS NOT NULL
                  AND TRY_CONVERT(BIGINT, REPLACE(imdb_votes, ',', '')) IS NULL THEN 1 ELSE 0 END) AS invalid_imdb_votes,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(tmdb_popularity)), '') IS NOT NULL
                  AND TRY_CONVERT(DECIMAL(18,3), tmdb_popularity) IS NULL THEN 1 ELSE 0 END) AS invalid_tmdb_popularity,
    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(tmdb_score)), '') IS NOT NULL
                  AND TRY_CONVERT(DECIMAL(5,2), tmdb_score) IS NULL THEN 1 ELSE 0 END) AS invalid_tmdb_score
FROM dbo.netflix_raw;
GO
