-- Data cleaning project --

-- Removing Duplicates
-- Standardizing data
-- Null values or Blank Values
-- Remove any column or Rows


SELECT *
FROM layoffs;

-- Removing duplicates --

CREATE TABLE layoff_staging
LIKE layoffs;

SELECT *
FROM layoff_staging;

INSERT layoff_staging
SELECT *
FROM layoffs;


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, fund_raised_millions)
FROM layoff_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, fund_raised_millions)
FROM layoff_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num>1;

SELECT *
FROM layoff_staging
WHERE company = 'Casper';

SELECT *
FROM layoff_staging2
WHERE row_num>1;

DELETE
FROM layoff_staging2
WHERE row_num>1;

SELECT *
FROM layoff_staging2;


-- Standardizing Data --

SELECT company, TRIM(company)
FROM layoff_staging2;

UPDATE layoff_staging2
SET company = TRIM(company);


SELECT DISTINCT industry
FROM layoff_staging2
ORDER BY 1;

SELECT*
FROM layoff_staging2
WHERE industry LIKE 'Crypto%';


UPDATE layoff_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT country
FROM layoff_staging2
WHERE country LIKE 'United State%';


SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoff_staging2
ORDER BY 1;

UPDATE layoff_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United State%';

-- Changing date format --

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoff_staging2;	

UPDATE layoff_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;


-- Dealing with Nulls in a column --

SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


UPDATE layoff_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoff_staging2
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry
FROM layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1. company = t2.company
WHERE (t1. industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1. company = t2.company
SET t1.industry = t2.industry
WHERE t1. industry IS NULL
AND t2.industry IS NOT NULL;


-- Removing column or Rows

ALTER TABLE layoff_staging2
DROP COLUMN row_num;

SELECT *
FROM layoff_staging2;

