-- Cleaning World Life Expectancy Data

SELECT * 
FROM world_life_expectancy;

-- Finding Duplicates in the Data

SELECT country, year, CONCAT(country, year), COUNT(CONCAT(country, year))
FROM world_life_expectancy
GROUP BY country, year, CONCAT(country, year)
HAVING COUNT(CONCAT(country, year)) > 1;


SELECT *
FROM (SELECT row_id, 
CONCAT(country, year),
ROW_NUMBER() OVER( PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS row_num
FROM world_life_expectancy) AS row_table
WHERE row_num > 1;

-- Deleting the duplicate data from the dataset

DELETE FROM world_life_expectancy
WHERE row_id IN (
	SELECT row_id
FROM (SELECT row_id, 
CONCAT(country, year),
ROW_NUMBER() OVER( PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS row_num
FROM world_life_expectancy) AS row_table
WHERE row_num > 1 );

-- Finding missing data within the dataset

SELECT *
FROM world_life_expectancy
WHERE status = '';


SELECT DISTINCT(status)
FROM world_life_expectancy
WHERE status != '';


SELECT DISTINCT(country)
FROM world_life_expectancy
WHERE status = 'Developing';

-- Populating the missing data based off data within the table

UPDATE world_life_expectancy
SET status = 'Developing'
WHERE country IN (SELECT DISTINCT(country)
					FROM world_life_expectancy
					WHERE status = 'Developing');
                    

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.status = 'Developing'
WHERE t1.status = ''
AND t2.status != ''
AND t2.status = 'Developing';


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.status = 'Developed'
WHERE t1.status = ''
AND t2.status != ''
AND t2.status = 'Developed';

-- Finding missing data within the dataset

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';


SELECT t1.country, t1.year, t1.`Life expectancy`, 
t2.country, t2.year, t2.`Life expectancy`,
t3.country, t3.year, t3.`Life expectancy`,
ROUND(((t2.`Life expectancy` + t3.`Life expectancy`) / 2), 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
	AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country
	AND t1.year = t3.year + 1
WHERE t1.`Life expectancy` = ''
;

-- Populating the missing data based off data within the table

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
	AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country
	AND t1.year = t3.year + 1
SET t1.`Life expectancy` = ROUND(((t2.`Life expectancy` + t3.`Life expectancy`) / 2), 1)
WHERE t1.`Life expectancy` = ''
;
