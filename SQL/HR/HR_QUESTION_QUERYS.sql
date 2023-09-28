-- QUESTIONS

-- What is the gender breakdown of employees in the company?

SELECT gender, count(*) AS count FROM hr
	WHERE age >=18 AND termdate IS NULL
    GROUP BY gender;

 -- What is the race/ethnicity breakdown of employees in the company?
 SELECT race, count(*) AS count FROM hr
	WHERE age >=18 AND termdate is NULL
		GROUP BY race ;
        
-- What is the age distribution of employees in the company?
SELECT
	min(age),
    max(age)
    FROM hr 
		WHERE age >= 18 AND termdate IS NULL;

SELECT CASE 
	WHEN age >=18 AND age <=24 THEN '18-24'
    WHEN age >=25 AND age <=34 THEN '25-34'
    WHEN age >=35 AND age <=44 THEN '25-44'
    WHEN age >=45 AND age <=54 THEN '45-54'
    WHEN age >=55 AND age <=64 THEN '55-64'
    ELSE '65+'
    END AS age_group,gender,
    count(*) AS count
FROM hr
	WHERE age >=18 AND termdate IS NULL
		GROUP BY age_group,gender
        ORDER BY age_group,gender;
    
-- How many employees work at headquarters versus remote locations?
	SELECT location,count(*)
	FROM hr 
	WHERE age>=18 AND termdate IS NULL
	GROUP BY location;
                
	
-- What is the average length of employment for employees who have been terminated?
	SELECT
    round(avg(datediff(termdate,hire_date))/365,0) AS avg_length_employment
    FROM hr
    WHERE termdate <= curdate() AND termdate IS NOT NULL AND age >= 18;
    
    
-- How does the gender distribution vary across departments and job titles?
	SELECT gender,department,count(*) AS count
    FROM hr
    WHERE age>=18 AND termdate IS NULL 
    GROUP BY department,gender 
    ORDER BY department;
-- What is the distribution of job titles across the company?	
	SELECT jobtitle,count(*)
    FROM hr 
	WHERE age>=18 AND termdate IS NULL
    GROUP BY jobtitle
    ORDER BY jobtitle ASC;
-- Which department has the highest turnover rate?
	SELECT department,
    total_count,
    terminated_count,
    terminated_count/total_count as terminated_rate
	FROM (
    SELECT department,
    count(*) as total_count,
    sum(CASE WHEN termdate IS NOT NULL AND termdate < curdate() THEN 1 ELSE 0 END) as terminated_count
    FROM hr
	WHERE age >=18 
	GROUP BY department
    ) AS subquery
    ORDER BY terminated_rate DESC;
    
-- What is the distribution of employees across locations by state?
	SELECT location_state, count(*) as count 
    FROM hr 
    WHERE age>=18 AND termdate IS NULL 
    GROUP BY location_state
    ORDER BY count DESC;
    
-- How has the company's employee count changed over time based on hire and term dates?

	SELECT
		year,
		SUM(hires) AS hires,
		SUM(terminations) AS terminations,
		SUM(hires) - SUM(terminations) AS net_change,
		ROUND((SUM(hires) - SUM(terminations)) / SUM(hires) * 100, 2) AS net_change_percent
	FROM (
		SELECT
			YEAR(hire_date) AS year,
			COUNT(*) AS hires,
			SUM(CASE WHEN termdate IS NOT NULL AND termdate < CURDATE() THEN 1 ELSE 0 END) AS terminations
		FROM hr
		WHERE age >= 18
		GROUP BY YEAR(hire_date)
	) AS subquery
	GROUP BY year
	ORDER BY year ASC;
    
-- What is the tenure distribution for each department?
	SELECT department,round(avg(datediff(termdate,hire_date)/365),0) AS avg_ternure
	FROM hr 
    WHERE termdate IS NOT NULL AND termdate < curdate() AND age >= 18
    GROUP BY department
    ORDER BY avg_ternure DESC;
    
