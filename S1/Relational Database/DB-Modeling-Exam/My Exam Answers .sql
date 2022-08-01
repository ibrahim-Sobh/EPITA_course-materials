-- 1 

SELECT contact_email, contact_first_name,contact_city
FROM contacts
order by contact_city asc;

-- 2

SELECT contact_email, contact_first_name,contact_city
FROM contacts
where contact_city ilike 'New York'
order by contact_first_name asc;

--3 

Select c.contact_email,c.contact_birthdate,s.student_epita_email 
From contacts c
left join students s on s.student_contact_ref=c.contact_email
order by c.contact_birthdate desc;

--4

Select c.contact_email,c.contact_birthdate,s.student_epita_email,
date_part('year',age(contact_birthdate)) as age
From contacts c
left join students s on s.student_contact_ref=c.contact_email
order by c.contact_birthdate desc
limit 5;

--5 

Select student_population_year_ref, count(*) from students
where student_enrollment_status in ('completed','confirmed')
group by student_population_year_ref
order by student_population_year_ref desc;

--6 

select teacher_epita_email from teachers
where teacher_epita_email not in (select distinct session_prof_ref from sessions)
order by teacher_epita_email asc;


--7 

select teacher_epita_email,count(*) as cnt from sessions s
left join teachers t on t.teacher_epita_email=s.session_prof_ref
group by teacher_epita_email
order by cnt desc
limit 2


--8
select student_epita_email,grade_score,course_description FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join courses c on g.grade_course_code_ref=c.course_code
where s.student_enrollment_status ilike 'selected'
order by student_contact_ref asc,grade_course_code_ref desc;


--9 
select student_epita_email,
AVG(grade_score) as average
FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
where s.student_enrollment_status in ('completed','confirmed')
group by student_epita_email
order by average desc


--10

select student_epita_email,
sum(grade_score* e.exam_weight) /sum(e.exam_weight) as grade FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join exams e on e.exam_course_code =g.grade_course_code_ref and e.exam_course_rev =g.grade_course_rev_ref 
where s.student_enrollment_status in ('completed','confirmed')
group by student_epita_email
order by grade desc,student_epita_email asc;

--11


select student_epita_email,grade-to_be_dedectued as corrected_average from (
select student_epita_email,
sum(grade_score* e.exam_weight) /sum(e.exam_weight) as grade FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join exams e on e.exam_course_code =g.grade_course_code_ref and e.exam_course_rev =g.grade_course_rev_ref 
where s.student_enrollment_status in ('completed','confirmed')
group by student_epita_email) as k
left join(
select attendance_student_ref ,
cast(sum(case when attendance_presence='0' then 1 else 0 end) *0.1 as decimal(10,1)) as to_be_dedectued
from attendance a 
group by attendance_student_ref 
order by attendance_student_ref asc ) as t
on t.attendance_student_ref=k.student_epita_email
order by corrected_average desc;

--12 

select * from (
select student_epita_email,grade-to_be_dedectued as corrected_average from (
select student_epita_email,
sum(grade_score* e.exam_weight) /sum(e.exam_weight) as grade FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join exams e on e.exam_course_code =g.grade_course_code_ref and e.exam_course_rev =g.grade_course_rev_ref 
where s.student_enrollment_status in ('completed','confirmed')
group by student_epita_email) as k
left join(
select attendance_student_ref ,
cast(sum(case when attendance_presence='0' then 1 else 0 end) *0.1 as decimal(10,1)) as to_be_dedectued
from attendance a 
group by attendance_student_ref 
order by attendance_student_ref asc ) as t
on t.attendance_student_ref=k.student_epita_email
order by corrected_average desc ) as f 
where f.corrected_average<8
order by f.corrected_average desc;

--13

select attendance_course_ref ,sum(case when attendance_presence='0' then 1 else 0 end) as missing_attendance
from attendance a 
group by attendance_course_ref 
order by missing_attendance desc

--14

select k.session_course_ref,
cast(cast(missing_attendance as decimal(10,4))/session_count as decimal(10,4)) as rate from (
select attendance_course_ref ,
sum(case when attendance_presence='0' then 1 else 0 end) missing_attendance
from attendance a 
group by attendance_course_ref ) as t
left join (
select session_course_ref ,count(*) as session_count from sessions a 
group by session_course_ref 
) as k
on k.session_course_ref =t.attendance_course_ref
order by rate desc




--15
insert into populations (population_code, population_year, population_period)
(select distinct s.student_population_code_ref ,s.student_population_year_ref ,s.student_population_period_ref 
from  students s
left join populations p on p.population_code =s.student_population_code_ref  and 
p.population_year =s.student_population_year_ref  and 
p.population_period = s.student_population_period_ref 
where p.population_code is null and 
p.population_year is null  and 
p.population_period is null);

ALTER TABLE students
ADD CONSTRAINT fk_student_population FOREIGN KEY(student_population_code_ref, student_population_year_ref,student_population_period_ref) 
REFERENCES populations(population_code, population_year, population_period);

ALTER TABLE exams 
ADD CONSTRAINT fk_exams_for_courses FOREIGN KEY(exam_course_code, exam_course_rev) 
REFERENCES courses(course_code, course_rev);

ALTER TABLE grades 
ADD CONSTRAINT fk_exams_grades FOREIGN KEY(grade_course_code_ref, grade_course_rev_ref,grade_exam_type_ref) 
REFERENCES exams(exam_course_code, exam_course_rev,exam_type);

ALTER TABLE sessions 
ADD CONSTRAINT fk_session_course FOREIGN KEY(session_course_ref,session_course_rev_ref) 
REFERENCES courses(course_code,course_rev);

ALTER TABLE sessions 
ADD CONSTRAINT fk_session_proffesor FOREIGN KEY(session_prof_ref) 
REFERENCES teachers(teacher_epita_email);


ALTER TABLE attendance
ADD CONSTRAINT attendance_pk PRIMARY KEY(attendance_student_ref,
									attendance_course_ref,
									attendance_session_date_ref,
									attendance_session_start_time,
									attendance_session_end_time) ;


ALTER TABLE attendance
ALTER COLUMN attendance_session_date_ref TYPE date using ("attendance_session_date_ref"::text::date);

insert into sessions (session_course_ref,session_course_rev_ref,session_date, session_start_time, session_end_time)
(select distinct a.attendance_course_ref,a.attendance_course_rev ,
                a.attendance_session_date_ref ,a.attendance_session_start_time ,
                a.attendance_session_end_time
from  attendance a 
left join sessions s on s.session_course_ref =a.attendance_course_ref  and 
s.session_date =a.attendance_session_date_ref  and s.session_start_time =a.attendance_session_start_time 
and s.session_end_time =a.attendance_session_end_time 
where s.session_course_ref is null and s.session_date is null and s.session_start_time is null and s.session_end_time is null );


ALTER TABLE attendance 
ADD CONSTRAINT fk_attendance_student FOREIGN KEY(attendance_student_ref) 
REFERENCES students(student_epita_email);

ALTER TABLE attendance
ADD CONSTRAINT fk_attendance_session FOREIGN KEY(attendance_course_ref,
 										attendance_session_date_ref,
 										attendance_session_start_time,
 										attendance_session_end_time) REFERENCES sessions(session_course_ref,
 										session_date ,
 										session_start_time ,
 									    session_end_time );

delete from 