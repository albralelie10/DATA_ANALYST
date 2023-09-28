CREATE DATABASE projects;
USE projects;

-- LIMPIEZA DE DATOS 
		-- ETANDARIZAR FORMATOS DE FECHA
        
ALTER TABLE hr 
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

SET sql_safe_updates = 0;

UPDATE hr 
SET birthdate = CASE
	WHEN birthdate LIKE "%/%"
    THEN date_format(str_to_date(birthdate,"%m/%d/%Y"),"%Y-%m-%d")
    WHEN birthdate LIKE "%-%"
    THEN date_format(str_to_date(birthdate,"%m-%d-%Y"),"%Y-%m-%d")
    ELSE NULL
	END ;
    
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

DESCRIBE hr;

UPDATE hr 
SET hire_date = CASE
	WHEN hire_date LIKE "%/%"
		THEN date_format(str_to_date(hire_date,"%m/%d/%Y"),"%Y-%m-%d")
	WHEN hire_date LIKE "%-%"
		THEN date_format(str_to_date(hire_date,"%m-%d-%Y"),"%Y-%m-%d")
	ELSE NULL
    END;

ALTER TABLE hr 
MODIFY COLUMN hire_date DATE;

UPDATE hr
SET termdate = date(str_to_date(termdate,"%Y-%m-%d %H:%i:%s UTC"))
	WHERE termdate IS NOT NULL AND termdate !='';
    
UPDATE hr
SET termdate = NULL
WHERE termdate IS NULL OR termdate = '';

ALTER TABLE hr 
MODIFY COLUMN termdate DATE;

SELECT termdate from hr;

ALTER TABLE hr
ADD COLUMN age INT NULL;

UPDATE hr
SET age = timestampdiff(YEAR,birthdate, curdate())
WHERE age IS NULL;