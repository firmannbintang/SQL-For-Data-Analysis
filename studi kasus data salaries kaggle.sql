SELECT * FROM ds_salaries;

-- 1. Apakah ada data yang NULL?
SELECT * 
FROM ds_salaries
WHERE work_year IS NULL;

-- 2. Melihat ada job title apa aja
SELECT DISTINCT job_title 
FROM ds_salaries
ORDER BY job_title;

-- 3. Job title apa saja yang berkaitan dengan data analyst?
SELECT DISTINCT job_title 
FROM ds_salaries
WHERE job_title LIKE '%data analyst%'
ORDER BY job_title;

-- 4. Rata rata gaji data analyst berapa sih?
SELECT (AVG(salary_in_usd) * 15000) /12 AS avg_salaries_rp_montly FROM ds_salaries;

-- 5. Berapa rata rata gaji data analyst berdasarkan experience levelnya?
SELECT experience_level,
	(AVG(salary_in_usd) * 15000) /12 AS avg_salaries_rp_montly
    FROM ds_salaries 
    GROUP BY experience_level;

-- 5.2
SELECT experience_level, employment_type,
	(AVG(salary_in_usd) * 15000) /12 AS avg_salaries_rp_montly
    FROM ds_salaries 
    GROUP BY experience_level, employment_type
    ORDER BY experience_level, employment_type;
    
-- 5.3 Di kategorikan per negara
SELECT experience_level, employment_type, company_location,
	(AVG(salary_in_usd) * 15000) /12 AS avg_salaries_rp_montly
    FROM ds_salaries 
    GROUP BY experience_level, employment_type, company_location
    ORDER BY experience_level, employment_type, company_location;
    
-- 6.Negara mana sih yang gajinya paling tinggi untuk posisi data analyst? (Full time, entry level dan mid level)
SELECT company_location,
	AVG(salary_in_usd) AS avg_sal_in_usd
FROM ds_salaries
WHERE job_title LIKE '%data analyst%'
	AND employment_type ='FT'
    AND experience_level IN ('EN', 'MI')
GROUP BY company_location
HAVING avg_sal_in_usd >= 20000;

-- 7. Di tahun berapa kenaikan gaji dari mid ke senior itu memiliki kenaikan yang tertinggi?
-- (Untuk pekerjaan yang berkaitan dengan data analyst dan full time)

WITH ds_1 AS (
	SELECT work_year,
    AVG(salary_in_usd) AS sal_in_usd_ex
    FROM ds_salaries
    WHERE
    	employment_type = 'FT'
    	AND experience_level = 'EX'
    	AND job_title LIKE '%data analyst%'
    GROUP BY work_year
), ds_2 AS (
	SELECT work_year,
    AVG(salary_in_usd) AS sal_in_usd_mi
    FROM ds_salaries
    WHERE
    	employment_type = 'FT'
    	AND experience_level = 'MI'
    	AND job_title LIKE '%data analyst%'
    GROUP BY work_year
) SELECT ds_1.work_year, 
	ds_1.sal_in_usd_ex,
    ds_2.sal_in_usd_mi,
    ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi AS differences
FROM ds_1 
LEFT OUTER JOIN ds_2 ON ds_1.work_year = ds_2.work_year;

-- 7. Di tahun berapa kenaikan gaji dari mid ke senior itu memiliki kenaikan yang tertinggi?
-- (Untuk pekerjaan yang berkaitan dengan data analyst dan full time)

WITH ds_1 AS (
	SELECT work_year,
    AVG(salary_in_usd) AS sal_in_usd_ex
    FROM ds_salaries
    WHERE
    	employment_type = 'FT'
    	AND experience_level = 'EX'
    	AND job_title LIKE '%data analyst%'
    GROUP BY work_year
), ds_2 AS (
	SELECT work_year,
    AVG(salary_in_usd) AS sal_in_usd_mi
    FROM ds_salaries
    WHERE
    	employment_type = 'FT'
    	AND experience_level = 'MI'
    	AND job_title LIKE '%data analyst%'
    GROUP BY work_year
), t_year AS (
	SELECT DISTINCT work_year
    FROM ds_salaries
)SELECT t_year.work_year,
	ds_1.sal_in_usd_ex,
    ds_2.sal_in_usd_mi,
    ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi AS differences
FROM t_year 
LEFT JOIN ds_1 ON ds_1.work_year = t_year.work_year
LEFT JOIN ds_2 ON ds_2.work_year = t_year.work_year;