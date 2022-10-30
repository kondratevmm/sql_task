-- Task 1 Вывести список сотрудников старше 65 лет.
SELECT concat(p.last_name, ' ', p.first_name, ' ', p.middle_name) as fio
	,p.dob
	,date_part('year', age(p.dob)) as years
FROM hr.person as p
INNER JOIN hr.employee as e on p.person_id = e.person_id
WHERE DATE_PART('year', AGE(dob)) > 65

-- Task 2 Вывести количество вакантных должностей. (Таблица с вакансиями может содержать недостоверные данные, решение должно быть без этой таблицы).
select count(*)
from hr.position as p
left join hr.employee as e on p.pos_id = e.pos_id
where e.pos_id isnull

-- Task 3 Вывести список проектов и количество сотрудников, задействованных на этих проектах.
select p.name
	,p.employees_id
	,p.assigned_id
	,count(*)+1 as emp_count -- Добавляем 1 т.к. у каждого проекта есть руководитель, который также является участником проекта
from (
	select *
		,unnest(employees_id)
	from hr.projects) as p
group by p.name, p.employees_id, p.assigned_id

-- Task 5 Вывести среднее значение суммы договора на каждый год, округленное до сотых. (year, avg_ammount)
select date_part('year', created_at) as year
	,round(avg(amount), 2) as avg_amount
from hr.projects
group by 1

-- Task 6 Одним запросом вывести ФИО сотрудников с самым низким и самым высоким окладами за все время. (fio, salary)
select p.fio
	,es.salary
from hr.employee_salary as es 
left join hr.employee as e on e.emp_id = es.emp_id
left join (select person_id, concat_ws(' ', first_name, last_name, middle_name) as fio from hr.person) as p on p.person_id = e.person_id
where salary in (select max(salary) from hr.employee_salary union select min(salary) from hr.employee_salary)