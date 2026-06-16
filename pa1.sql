create database pa01;
create schema hospital;
create table doctors(id serial primary key, first_name varchar, last_name varchar,specialty varchar,department_id int references departments(id));
create table departments(id serial primary key, name_department varchar);
create table patients(id serial primary key, first_name varchar, last_name varchar, phone varchar, birth_date varchar);
create table appointments(id serial primary key, doctor_id int references doctors(id),
patient_id int references patients(id), appoint_date date, status varchar);
create table diagnoses(id serial primary key, appoint_id int references appointments(id), diagnosis_name varchar);
insert into departments(name_department) 
values 
('Психіатрія'),
('Неврологія'),
('Кардіологія');
insert into doctors(first_name, last_name, specialty, department_id) 
values 
('Максим', 'Дуделка', 'Кардіолог', 1),
('Альберт', 'Сопілка', 'Невролог', 2),
('Ізольда', 'Кассандра', 'Психіатр', 3);
insert into patients(first_name, last_name, phone, birth_date) 
values 
('Петя', 'Мотиватор', '0677669767', '2006-06-07'),
('Віктор', 'Дудка', '0677654321', '2007-07-16'),
('Галина', 'Жужа', '0670067067', '1967-05-15'),
('Артем','Котенко','0686767891','2005-08-01');
insert into appointments(doctor_id, patient_id, appoint_date,status)
values
(1, 1, '2026-09-11', 'Завершено'),
(2, 2, '2026-08-12', 'Скасовано'),
(3, 3, '2026-05-02', 'Завершено'),
(2, 4,'2026-01-03','Завершено'),
(1, 2, '2026-06-09', 'Заплановано'),
(1, 3, '2025-03-15', 'Завершено'),
(2, 1, '2025-07-22', 'Завершено'),
(3, 2, '2025-11-10', 'Завершено');
insert into diagnoses(appoint_id, diagnosis_name)
values
(1,'Інфаркт'),
(2, 'Деменція'),
(3, 'Шизофренія'),
(6, 'Аритмія'),
(7, 'Епілепсія'),
(8, 'Параноя');

-- cte з union all об'єднує прийоми за 2025 і 2026 рік
with all_appointments as (
    select * from appointments
    where appoint_date >= '2026-01-01'
    union all
    select * from appointments
    where appoint_date >= '2025-01-01' and appoint_date < '2026-01-01')
--завершені прийоми з усіх 5 таблиць
select d.first_name || ' ' || d.last_name as doctor, dep.name_department, p.first_name || ' ' || p.last_name as patient,
di.diagnosis_name, count(*) as total_appointments
from all_appointments a
join doctors d on a.doctor_id = d.id
join departments dep on d.department_id = dep.id
join patients p on a.patient_id = p.id
join diagnoses di on di.appoint_id = a.id
where a.status = 'Завершено'
group by d.first_name, d.last_name, dep.name_department, p.first_name, p.last_name, di.diagnosis_name
order by doctor;
