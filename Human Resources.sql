Create database Human_Resources;
Use Human_Resources;
drop database  Human_Resources;

SELECT 
    *
FROM
    human_r;

desc human_r;

alter table human_r
change column ï»¿id Emp_Id varchar(20);

alter  table human_r
modify column birthdate date;





UPDATE human_r 
SET 
    birthdate = CASE
        WHEN
            birthdate LIKE '%/%'
        THEN
            DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'),
                    '%Y-%m-%d')
        WHEN
            birthdate LIKE '%-%'
        THEN
            DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'),
                    '%Y-%m-%d')
        ELSE NULL
    END;
   
   
   SELECT 
    *
FROM
    human_r;
   
   set sql_safe_updates = 0;
   
   
   
   
   UPDATE human_r 
SET 
    hire_date = CASE
        WHEN
            hire_date LIKE '%/%'
        THEN
            DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'),
                    '%Y-%m-%d')
        WHEN
            hire_date LIKE '%-%'
        THEN
            DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%Y'),
                    '%Y-%m-%d')
        ELSE NULL
    END;
   
   
   
UPDATE human_r 
SET 
    termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE
    termdate IS NOT NULL AND termdate != '';
   
   
   alter  table human_r
modify column hire_date date;

desc human_r;



set Sql_safe_updates = 0;

update human_r
set age = timestampdiff(year, birthdate, curdate());

select birthdate, age, gender from human_r;


select max(age), min(age)
from human_r;


### 1. what is the gender breakdown of employees in the company?##

SELECT 
    gender, COUNT(*) AS count
FROM
    human_r
WHERE
    age >= 18 AND termdate = ''
GROUP BY gender;


##2. what is the race/ethnicity breakdown of employees in the company?

SELECT 
    race, COUNT(*) AS Race_Count
FROM
    human_r
WHERE
    age >= 18 AND termdate = ''
GROUP BY race
ORDER BY COUNT(*) DESC;


###3.  what is the age distribution of employees in the company?

select min(age) Youngest, max(age) Oldest
from human_r
where age>=18 and termdate= '';


select
 case 
 when age >=18 and age<=24 then '18-24'
 when age >=25 and age<=34 then '25-34'
 when age >=35 and age<=44 then '35-44'
 when age >=45 and age<=54 then '45-54'
 when age >=55 and age<=64 then '55-64'
 else '65+'
 end as age_cat,
 count(*) as Count
 from human_r
 where age>=18 and termdate = ''
 group by age_cat
 order by age_cat;
 

 select
 case 
 when age >=18 and age<=24 then '18-24'
 when age >=25 and age<=34 then '25-34'
 when age >=35 and age<=44 then '35-44'
 when age >=45 and age<=54 then '45-54'
 when age >=55 and age<=64 then '55-64'
 else '65+'
 end as age_cat,  gender,
 count(*) as Count
 from human_r
 where age>=18 and termdate = ''
 group by age_cat,  gender
 order by age_cat,  gender;
 
 select
 case 
 when age >=18 and age<=24 then 'Young_Youths'
 when age >=25 and age<=34 then 'Youths'
 when age >=35 and age<=44 then 'Young_Adults'
 when age >=45 and age<=54 then 'Adults'
 when age >=55 and age<=64 then 'Young_Elderly'
 else 'Elderly'
 end as age_categories,  gender,
 count(*) as Count
 from human_r
 where age>=18 and termdate = ''
 group by age_categories,  gender
 order by age_categories,  gender;
 
 
 
 select first_name, last_name, department, emp_id, count(emp_id) over(partition by department order by last_name asc) from human_r;
 
 select first_name, last_name, department, emp_id, row_number() over(partition by emp_id ), rank() over(partition by emp_id ),
 dense_rank() over(partition by emp_id)from human_r;
 
 -- 4. how many employees work at headquarters versus remote locations?
 select location, count(*) as count
 from human_r
 where age>=18 and termdate = ''
 group by location;
 
 
 ##5. what is the average length of employment for employees who have been terminated?
 
 select 
avg(datediff(termdate, hire_date))/365 as avg_length_employment
 from human_r
 where termdate <= curdate() and termdate <> '' and age>=18;
 
 
 -- 6. how does the gender distribution vary across department and job titles?
 select department, gender, count(*) as count
 from human_r
 where age>=18 and termdate=''
 group by department, gender
 order by department;
 
 
 -- 7. what is the distribution of job titles across the company?
 
 select jobtitle, count(*) as count
 from human_r
 where age >=18 and termdate=''
 group by jobtitle
 order by jobtitle desc;
 
 
 
 -- 8. which department has the highest turnover rate?
 
 select department,
 total_count,
 terminated_count,
 terminated_count/total_count as termination_rate
 from (
   select department,
   count(*) as total_count,
   sum(case when termdate <> '' and termdate <= curdate() then 1 else 0 end) as terminated_count
   from human_r
   where age>=18
   Group by department
   ) as subquery
   order by termination_rate desc;
   
 
 
   -- 9. what is the distribution of employees across locations by city and state?
   
   select location_state, count(*) as count
   from human_r
   where age>=18 and termdate = ''
   group by location_state
   order by count desc;
   
   
   -- 10. how has the company's employee count changed over time based on hire and term dates?
   
  select
  year, 
  hires,
  terminations,
  hires - terminations as net_change,
  round((hires - terminations)/hires * 100, 2) as net_change_percent
  from(
   select year(hire_date) as year, 
   count(*) as hires,
   sum(case when termdate <>'' and termdate <= curdate() then 1 else 0 end) as terminations
   from human_r
   where age>18
   group by year(hire_date)
   ) as subquery
   order by year;
   
   
 
 -- 11. what is the tenure distribution for each department?
 select department, round(avg(datediff(termdate, hire_date)/365),0) as avg_tenure
 from human_r
where termdate<= curdate() and termdate<>'' and age>=18
group by department;

 

