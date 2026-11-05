# Netflix Content Analytics

An end to end data analytics project exploring Netflix movies and TV shows using **Microsoft SQL Server** and **Tableau Cloud**.

The project focuses on cleaning and transforming Netflix data, performing SQL based analysis, and building an interactive dashboard to explore content distribution, release trends, genres, countries, age certifications, and IMDb ratings.

## Dashboard Preview

**[View Interactive Netflix Analytics Dashboard](https://prod-in-a.online.tableau.com/t/sufiancoding-3569740d70/views/NetflixAnalyticsProject/NetflixAnalyticsDashboard)**

<img width="2479" height="1171" alt="image" src="https://github.com/user-attachments/assets/d39bea7d-5ec7-4fa2-8082-166f229428d4" />


## Dataset

The project uses the Netflix Movies and TV Shows dataset from Kaggle.

**[Download the Sample Dataset](https://www.kaggle.com/datasets/victorsoeiro/netflix-tv-shows-and-movies?select=titles.csv)**

The dataset includes information such as:

- Title and content type
- Description and release year
- Age certification
- Runtime and number of seasons
- Genres and production countries
- IMDb score and votes
- TMDB popularity and score

## Technologies Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Tableau Cloud
- SQL
- CSV

## Project Workflow

1. **Data Import:** Imported the Netflix dataset into SQL Server.
2. **Data Cleaning:** Handled missing values, converted data types, and prepared the dataset for analysis.
3. **Data Transformation:** Separated genre and country information into normalized tables.
4. **SQL Analysis:** Used SQL queries to explore content trends and generate analytical insights.
5. **Data Visualization:** Connected the analysis results to Tableau Cloud and created an interactive dashboard.

## Dashboard Insights

The dashboard includes the following visualizations:

| Visualization | Description |
|---|---|
| Total Titles | Displays the total number of Netflix titles |
| Movies vs TV Shows | Compares movies and TV shows |
| Content by Release Year | Shows content distribution over release years |
| Top 10 Genres | Identifies the most common genres |
| Top 10 Countries | Highlights countries with the highest content counts |
| Age Certification | Explores content distribution by age rating |
| IMDb Score Distribution | Compares titles across IMDb score ranges |

## Repository Structure

```text
netflix-content-analytics/
│
├── sql/
│   ├── 01_validate_raw_data.sql
│   ├── 02_clean_and_normalize.sql
│   ├── 03_analysis_queries.sql
│   └── 04_tableau_views.sql
│
├── README.md
└── dataset/
    └── Download dataset from Kaggle
```

## How to Run the Project

1. Download the dataset from Kaggle.
2. Create a database named `Netflix_Analytics` in SQL Server.
3. Import the CSV file into a table named `dbo.netflix_raw`.
4. Execute the SQL scripts in the following order:

   - `01_validate_raw_data.sql`
   - `02_clean_and_normalize.sql`
   - `03_analysis_queries.sql`
   - `04_tableau_views.sql`

5. Export the required SQL views as CSV files.
6. Upload the CSV files to Tableau Cloud.
7. Open the published dashboard using the link above.

## Project Goals

- Practice SQL data cleaning and transformation.
- Develop skills in data analysis and querying.
- Understand data normalization.
- Build meaningful data visualizations.
- Create an interactive business intelligence dashboard.
