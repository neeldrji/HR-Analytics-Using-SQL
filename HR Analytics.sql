-- View the entire employee trends dataset
SELECT * FROM Emp_Trends;

-- ============================== --
-- QUESTIONS AND QUERIES
-- ============================== --

-- 1. Count the number of employees in each department
SELECT 
    Department, 
    COUNT(*) AS Count_of_Employees 
FROM Emp_Trends
GROUP BY Department;

-- 2. Calculate the average age for each department
SELECT 
    Department, 
    AVG(Age) AS Average_Age 
FROM Emp_Trends
GROUP BY Department;

-- 3. Identify the most common job roles in each department
WITH CTE AS (
    SELECT 
        Department, 
        Job_Role,
        ROW_NUMBER() OVER (
            PARTITION BY Department 
            ORDER BY COUNT(*) DESC
        ) AS RN
    FROM Emp_Trends
    GROUP BY Department, Job_Role
)
SELECT 
    Department, 
    Job_Role 
FROM CTE
WHERE RN = 1;

-- 4. Calculate the average job satisfaction for each education level
SELECT 
    Education, 
    AVG(Job_Satisfaction) AS Avg_Job_Satisfaction 
FROM Emp_Trends
GROUP BY Education;

-- 5. Determine the average age for employees with different levels of job satisfaction
SELECT 
    Job_Satisfaction, 
    AVG(Age) AS Avg_Age_By_Job_Satisfaction 
FROM Emp_Trends
GROUP BY Job_Satisfaction
ORDER BY Job_Satisfaction;

-- 6. Calculate the attrition rate for each age band
SELECT 
    Age_Band, 
    CAST(
        SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) 
        AS DECIMAL(10,2)
    ) AS Attrition_Rate
FROM Emp_Trends
GROUP BY Age_Band;

-- 7. Identify departments with the highest and lowest average job satisfaction
SELECT 
    Department, 
    AVG(Job_Satisfaction) AS Avg_Job_Satisfaction 
FROM Emp_Trends
GROUP BY Department
ORDER BY Avg_Job_Satisfaction DESC;

-- 8. Find the age band with the highest attrition rate among employees with a specific education level
SELECT 
    Education,
    Age_Band,
    CAST(
        SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) 
        AS DECIMAL(10,2)
    ) AS Attrition_Rate
FROM Emp_Trends
GROUP BY Education, Age_Band
ORDER BY Attrition_Rate DESC;

-- 9. Find the education level with the highest job satisfaction among frequent travelers
WITH CTE AS (
    SELECT  
        Education, 
        AVG(Job_Satisfaction) AS Avg_JS, 
        DENSE_RANK() OVER (ORDER BY AVG(Job_Satisfaction) DESC) AS RN
    FROM Emp_Trends
    WHERE Business_Travel = 'Travel_Frequently'
    GROUP BY Education
)
SELECT 
    Education,  
    Avg_JS 
FROM CTE
WHERE RN = 1;

-- 10. Identify the age band with the highest job satisfaction among married employees
WITH CTE AS (
    SELECT  
        Age_Band, 
        AVG(Job_Satisfaction) AS Avg_JS, 
        DENSE_RANK() OVER (ORDER BY AVG(Job_Satisfaction) DESC) AS RN
    FROM Emp_Trends
    WHERE Marital_Status = 'Married'
    GROUP BY Age_Band
)
SELECT 
    Age_Band,  
    Avg_JS 
FROM CTE
WHERE RN = 1;
