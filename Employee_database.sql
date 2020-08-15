-- Sample Data View
select * from staff limit (10);

-- Number of employees in per department by gender
select department as "dept", gender as " gender", count (*) as " Employee Count" from staff
group by gender, department
ordselect s2.last_name, s2.department, max(s2.salary) from staff s2
where s2.department =
(select department from (select department, min(avg(salary)) from staff group by department)a)erselect s1.department, max(salary) from 
(select department,round(avg(salary),2) avg_sal from staff
group by department
order by avg_sal
limit 1)s1 by department;

--- What is max and min salary per department by gender?
select department as "Dept", gender as "Gender", max(salary) as " Max Sal", min (salary) as "Min Sal" from staff
group by department, gender
order by department, gender desc;

-- How much each department is spending on salary and what is the avrage salary per department?
select department as "Dept", sum(salary)as "Sal", round (avg(salary),2) as "Avg Sal" from staff
group by department
order by department;

-- What is variance and Standard deviation on speding on salaries per department

select department as "Dept", round (avg (salary),2) as "Avg Sal", round ( var_pop(salary),2) as "Variance",  round (stddev_pop(salary),2) as "Standard Deviation"
from staff
group by department
order by department;

--- Print the list of departments in upper case
select distinct upper (department) as "Dept" from staff;

--- Print title followed by department
select job_title ||  ' - ' || department "Title_dept" from staff;

--- List all employees whose title begins with " Assistant"
select last_name "Name",department "Dept", job_title from staff
where job_title like 'Assistant%';

--- Ceate a columm which will give True or False if name assistant is in the job_title

select job_title, (job_title like 'Assistant %') is_asst
from staff;

--- resturn first four letters of the Job titles for employees in the Automotive department

select last_name as "Name", substring(job_title from 0 for 5) "Job_Title" from staff
where department='Automotive';

--- resturn last four letters of the Employees in the Automotive department

select last_name "Actual Name",substring (last_name from length (last_name)- 3 for length (last_name) ) "Name" from staff
where department='Automotive';
	
-- how many categories of Assistants do we have?
select substring (job_title from 10) "Category", count(*)  from staff
where job_title like 'Assistant%'
group by "Category"
order by "Category";

--Replace word Assistant with Assist. in all job titles sql uses REPLACE PostGre uses Overlay

select overlay( job_title placing 'Assist.' from 1 for 9) as "Title" from staff
where job_title like 'Assistant%'
order by "Title"
limit 10;

--- Select job titles having III or IV in Assistant

select job_title from staff
where job_title similar to '%Assistant%(III | IV)';

--- Display name,salary, department and abg salary of the corrosponding department of employee

select last_name, salary, department, round (avg (salary),2) from staff
group by last_name, salary,department;
-- above query is not displaying correct answer thus we need to use subquery

select s1.last_name, s1.department, s1.salary,
(select round(avg(salary),2) from staff s2 where s1.department= s2.department)
from staff s1;

--- Select Find department wise average salaries for the employees having salary more than 100000

select s1.department, round (avg(s1.salary),2)
from
	(select department, salary
	from staff
	where salary>100000) s1
group by s1.department;

---find the person and department of the person having highest salary

select last_name, department from staff
where salary=(select max(salary) from staff);

--find second largest salary

with result as 
(select last_name, department, salary, dense_rank () over ( order by salary desc) as ranks from staff )
select last_name, department,salary 
from result
where result.ranks=2
limit 1;

select s1.last_name, s1.department, s1.salary
from
(select last_name, department, salary, dense_rank () over (order by salary desc) as ranks from staff)s1
where s1.ranks=2
limit 1;

-- Find Second smallest salary replace desc by asc

--- find max salry from the department having lowest avg salary

select s2.last_name, max(s2.salary), s2.department from staff s2 where

s2.department in
			(select s1.department from (
							select department, avg(salary) from staff
							group by department
							order by avg(salary)
							limit 1)s1)
group by s2.department, s2.last_name
order by max(s2.salary) desc
limit 1;

-- find maximum salary from department having second lowest average salary

select s2.last_name, s2.department, max(s2.salary) from staff s2
where s2.department in
						(select s1.department from
								(select department, avg(salary), dense_rank() over (order by avg(salary) asc) as ranks from staff
									group by department)s1
									where s1.ranks=2)
group by s2.last_name,s2.department
limit 2;

--- Create View of tables staff and left join with company division and region
create view staff_div_reg as
select s.*, cd.company_division, cr.company_regions
from staff s
left join company_divisions cd on s.department=cd.department
left join company_regions cr on s.region_id=cr.region_id;

--- use view to coint number of emoloyee in each region
select * from staff_div_reg;
select  company_regions as "Region",count (*) from staff_div_reg
group by company_regions
order by company_regions;

--- Use  count employees by region and division

select company_regions, company_division, count (*) from staff_div_reg
group by company_regions , company_division
order by company_division;

--- Create saperate columsn for count by divisions, region and gender using grouping sets
select company_regions, gender, company_division, count(*) from staff_div_reg
group by grouping sets (company_regions, gender, company_division)
order by company_regions, gender, company_division;

--- Add counyty_id in the staff_div_reg view
create or replace view staff_div_reg_country as 
select s.*, cd.company_division, cr.company_regions, cr.country from staff s
left join company_divisions cd on s.department=cd.department
left join company_regions cr on s.region_id=cr.region_id;

select * from staff_div_reg_country;

-- create subtotals of total number of employees by country and region both, and need to show number of employees by countries saperately

select company_regions, country, count (*) from staff_div_reg_country
group by rollup (company_regions), country
order by country, company_regions

--- Create subtotals of total number of employees by regions and both, show total count by each country and total number of employees
select company_regions, country, count (*) from staff_div_reg_country
group by rollup (country, company_regions)
order by country, company_regions;

--- Use cube for the same query, cube will crete all combinations of subtotals
select company_regions, country, count (*) from staff_div_reg_country
group by cube (country, company_regions)
order by country, company_regions;

--- Find top 10 salaraies using Fetch first clause
-- Find what is the difference between fetch first and limit
--Limits first limits the rows then performs query and fetch first executes the query and then limits the result

select last_name, job_title, salary from staff
order by salary desc
fetch first 10 rows only;

------ Show Employee, department and average of particular department

select last_name, department, salary,
avg(salary) over (partition by department)
from staff;

-- Show Employee salary and max salary from each department
select last_name, department, salary,
max (salary) over (partition by department)
from staff;

-- comapare  department wise employee salary by salary of the first employee of the each department
-- read partition by as group by
select last_name, department, salary,
first_value(salary) over (partition by department order by last_name ) as first_salary
from staff;

-- use rank function to group departments
-- Rank will be based on partition i.e department and salary
select last_name, department, salary,
rank()over(partition  by department order by salary desc) as Ranks
from staff;

-- Use lag function to process salary
select department, last_name, salary,
lag(salary) over (partition by department order by salary desc) from staff;

select department, last_name, salary,
lag(last_name) over (partition by department order by salary desc)from staff;

--- Use lead function

select department ,last_name, salary,
lead(salary) over (partition by department order by salary desc) from staff;

--- Divide employees into 4 groups based on highest to lowest based on their salaries and departments

select last_name, department, salary,
ntile(4) over (partition by department order by salary desc) "Groups" from staff;

-- How manu employees are catogarised in the category 4?
select count(*) from
(select last_name, department, salary,
ntile(4)over(partition by department order by salary desc) "groups" from staff)s
where s."groups"=4;

-- who has the min salary in group 1?
select last_name, department, salary from
(select last_name, department, salary,
ntile(4) over (partition by department order by salary desc) as "groups" from staff )s
where s."groups"=4
and
salary=(select min(s.salary) from staff s)





