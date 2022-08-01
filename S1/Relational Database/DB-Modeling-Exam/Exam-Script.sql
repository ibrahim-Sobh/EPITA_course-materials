-- DROP SCHEMA public CASCADE;
-- CREATE SCHEMA public;

SET search_path = public, pg_catalog;

--"Before Relatonships"----------------------------------------------------------------------------------------------------------------------------------------------

---------------------
-- order of INSERTS : contacts, students, grades // courses, programs // populations , teachers, exams, sessions , attendances
---------------------

---------------------------------
--Section contact-student-grades
---------------------------------

-- Get all enrolled students for a specific period,program,year
select student_epita_email, student_contact_ref, student_enrollment_status,
student_population_period_ref, student_population_year_ref, student_population_code_ref from students 
where student_population_period_ref ilike 'FALL'
        and student_population_year_ref='2020'
        and student_population_code_ref ilike 'DSA'
        and student_enrollment_status ilike 'completed'--selected for not enrolled
order by student_epita_email;
        
-- Get number of enrolled students for a specific period,program,year 
select student_population_code_ref,student_population_period_ref, student_population_year_ref,
count(student_epita_email) as enrolled
from (
select student_epita_email, student_contact_ref, student_enrollment_status,
student_population_period_ref, student_population_year_ref, 
student_population_code_ref from students 
where student_enrollment_status ilike 'completed' ) as t
group by student_population_period_ref, student_population_year_ref, 
student_population_code_ref
order by t.student_population_code_ref,t.student_population_period_ref,t.student_population_year_ref;
        
-- Get All defined exams for a course from grades table
select grade_course_code_ref,grade_exam_type_ref FROM grades g
group by  grade_course_code_ref,grade_exam_type_ref 
order by  grade_course_code_ref,grade_exam_type_ref;
   
-- Get all grades for a student
select ct.contact_first_name ,ct.contact_last_name ,
grade_course_code_ref, grade_exam_type_ref as type, grade_score FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join contacts ct on ct.contact_email =s.student_contact_ref 
where g.grade_student_epita_email_ref ilike 'delmy.ahle@epita.fr'
order by grade_course_code_ref,grade_exam_type_ref,grade_score desc;

    
-- Get all grades for a specific Exam 
select ct.contact_first_name ,ct.contact_last_name ,
grade_course_code_ref, grade_exam_type_ref as type, grade_score FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join contacts ct on ct.contact_email =s.student_contact_ref 
where grade_course_code_ref ilike 'DT_RDBMS' and g.grade_exam_type_ref  ilike 'Project'
order by grade_score desc;
        
-- Get students Ranks in an Exam for a course 
select distinct ct.contact_first_name ,ct.contact_last_name ,
grade_course_code_ref,grade_exam_type_ref,grade_score,rank() over (order by grade_score desc)  as ranks FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join contacts ct on ct.contact_email =s.student_contact_ref 
where grade_course_code_ref ilike 'DT_RDBMS' and grade_exam_type_ref ilike 'Project'
order by ranks;

-- Get students Ranks in all exams for a course
select distinct ct.contact_first_name ,ct.contact_last_name ,
grade_course_code_ref,grade_exam_type_ref,grade_score,rank() over (partition by grade_exam_type_ref order by grade_score desc)  as ranks FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join contacts ct on ct.contact_email =s.student_contact_ref 
where grade_course_code_ref ilike 'DT_RDBMS'
order by grade_exam_type_ref,ranks;

-- Get students Rank in all exams in all courses
select distinct ct.contact_first_name ,ct.contact_last_name ,
grade_course_code_ref,grade_exam_type_ref,grade_score,rank() over (partition by grade_course_code_ref,grade_exam_type_ref order by grade_score desc)  as ranks FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join contacts ct on ct.contact_email =s.student_contact_ref 
order by grade_course_code_ref,grade_exam_type_ref,ranks;

---------------------------------
--Section programs-courses 
---------------------------------

-- Get all courses for one program
select c.course_name ,c.course_description,c.duration,p.program_course_code_ref,c.course_last_rev FROM programs p
left join courses c on c.course_code= p.program_course_code_ref and c.course_rev = p.program_course_rev_ref 
where p.program_assignment ilike 'DSA';

-- Get courses in common between 2 programs
select c.course_name ,c.course_description,c.duration,p.program_course_code_ref,c.course_last_rev FROM programs p
left join courses c on c.course_code= p.program_course_code_ref and c.course_rev = p.program_course_rev_ref 
where p.program_assignment ilike'ais'
intersect
select c.course_name ,c.course_description,c.duration,p.program_course_code_ref,c.course_last_rev FROM programs p
left join courses c on c.course_code= p.program_course_code_ref and c.course_rev = p.program_course_rev_ref 
where p.program_assignment ilike 'se';

-- Get all programs following a certain course
select p.program_assignment from courses c 
left join programs p on p.program_course_code_ref =c.course_code  and p.program_course_rev_ref =c.course_rev 
where c.course_code ='AI_DATA_PREP';

-- get course with the bigges duration
select course_code,duration, rank() over (order by duration desc ) as r from courses c 
where duration =( select max(duration) from courses c2 );

-- get courses with the same duration
select c.course_code,c.duration,c2.course_code from courses c 
inner join courses c2 on c.duration =c2.duration and c.course_code != c2.course_code ;


---------------------------------
-- Section sessions 
---------------------------------

-- Get all sessions for a specific course 
SELECT session_course_ref, session_course_rev_ref, session_prof_ref, session_date, session_start_time, session_end_time, session_type, 
       session_population_year, session_population_period, session_room
FROM public.sessions
where session_course_ref='DT_RDBMS';

-- Get all session for a certain period
SELECT session_course_ref, session_course_rev_ref, session_prof_ref, session_date, session_start_time, session_end_time, session_type, 
       session_population_year, session_population_period, session_room
FROM public.sessions
where session_date>='2021-01-01' and session_date<='2021-01-07';

---------------------------------
-- Section attendance
---------------------------------

-- Get one student attendance sheet

SELECT attendance_student_ref, attendance_population_year_ref, attendance_course_ref, attendance_course_rev, 
        attendance_session_date_ref, attendance_session_start_time, attendance_session_end_time, case when attendance_presence=1 then 'Present' else 'Absent' end status
FROM public.attendance
where attendance_student_ref='delmy.ahle@epita.fr'
order by attendance_course_ref,attendance_session_date_ref ;

-- Get one student summary of attendance
select attendance_student_ref,attendance_population_year_ref,attendance_course_ref,attendance_course_rev, sum(case when status='Present' then 1 else 0 end) as present,
 sum(case when status='Absent' then 1 else 0 end) as absent from (
SELECT attendance_student_ref, attendance_population_year_ref, attendance_course_ref, attendance_course_rev, 
        attendance_session_date_ref, attendance_session_start_time, attendance_session_end_time, case when attendance_presence=1 then 'Present' else 'Absent' end status
FROM public.attendance
where attendance_student_ref='delmy.ahle@epita.fr') as t
group by attendance_student_ref,attendance_population_year_ref,attendance_course_ref,attendance_course_rev;

-- Get student with most absences
select attendance_student_ref,attendance_population_year_ref,attendance_course_ref,attendance_course_rev, sum(case when status='Present' then 1 else 0 end) as present,
 sum(case when status='Absent' then 1 else 0 end) as absense from (
SELECT attendance_student_ref, attendance_population_year_ref, attendance_course_ref, attendance_course_rev, 
        attendance_session_date_ref, attendance_session_start_time, attendance_session_end_time, case when attendance_presence=1 then 'Present' else 'Absent' end status
FROM public.attendance) as t
group by attendance_student_ref,attendance_population_year_ref,attendance_course_ref,attendance_course_rev
order by attendance_course_ref,absense desc;

--"Relationships & constraints To be Added"--------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------
-- Section Relations 
---------------------------------

---------------------
-- order of INSERTS : contacts, populations, students,courses, exams, grades, programs, teachers, sessions , attendances
---------------------

select * from populations p ;

-- This values will prevent the foreign key (fk_student_population )from being invalid
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


-- One student can have one attendance record per session and one only
  ALTER TABLE attendance
  ADD CONSTRAINT attendance_pk PRIMARY KEY(attendance_student_ref,
  										attendance_course_ref,
 										attendance_session_date_ref,
 										attendance_session_start_time,
 										attendance_session_end_time) ;

-- This values will prevent the foreign key (fk_attendance_student )from being invalid
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
				   


---------------------------------
-- section special queries								   
---------------------------------
 									   
-- Get all exams for a specific Course
select exam_course_code , course_name ,exam_type, exam_weight from exams e
left join courses c on c.course_code = e.exam_course_code and 
c.course_rev =e.exam_course_rev 
where exam_course_code ='SE_ADV_JAVA';

-- Get all Grades for a specific Student
select ct.contact_first_name ,ct.contact_last_name ,
grade_course_code_ref, grade_exam_type_ref as type, grade_score FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join contacts ct on ct.contact_email =s.student_contact_ref 
where grade_student_epita_email_ref='delmy.ahle@epita.fr'
order by grade_course_code_ref,grade_score desc;

-- Get the final grades for a student on a specifique course or all courses
select distinct ct.contact_first_name ,ct.contact_last_name ,
grade_course_code_ref,
cast(Sum(grade_score* e.exam_weight) over (partition by grade_course_code_ref)/
cast(sum(exam_weight)over (partition by grade_course_code_ref) as decimal(10,2)) as decimal(10,2)) as grade FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join contacts ct on ct.contact_email =s.student_contact_ref 
left join exams e on e.exam_course_code =g.grade_course_code_ref and e.exam_course_rev =g.grade_course_rev_ref and grade_exam_type_ref =e.exam_type 
where grade_student_epita_email_ref='delmy.ahle@epita.fr' -- where g.grade_course_code_ref =''
order by grade desc;

--Get the students with the top 5 scores for specific course

select distinct ct.contact_first_name ,ct.contact_last_name ,student_epita_email,
grade_course_code_ref,
cast(Sum(grade_score* e.exam_weight) over (partition by grade_course_code_ref,s.student_epita_email)/
cast(sum(exam_weight)over (partition by grade_course_code_ref,s.student_epita_email) as decimal(10,2)) as decimal(10,2)) as grade
FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join contacts ct on ct.contact_email =s.student_contact_ref 
left join exams e on e.exam_course_code =g.grade_course_code_ref and e.exam_course_rev =g.grade_course_rev_ref and grade_exam_type_ref =e.exam_type 
where grade_course_code_ref ='CS_SOFTWARE_SECURITY'
group by ct.contact_first_name ,ct.contact_last_name ,grade_course_code_ref,g.grade_score,e.exam_weight ,s.student_epita_email
order by grade desc
limit 5;
--

--Get the students with the top 5 scores per rank for specific course
select * from (
select contact_first_name ,contact_last_name ,student_epita_email,
grade_course_code_ref,grade, rank() over ( order by grade desc ) as rnk from (
select distinct ct.contact_first_name ,ct.contact_last_name ,student_epita_email,
grade_course_code_ref,
cast(Sum(grade_score* e.exam_weight) over (partition by grade_course_code_ref,s.student_epita_email)/
cast(sum(exam_weight)over (partition by grade_course_code_ref,s.student_epita_email) as decimal(10,2)) as decimal(10,2)) as grade
FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join contacts ct on ct.contact_email =s.student_contact_ref 
left join exams e on e.exam_course_code =g.grade_course_code_ref and e.exam_course_rev =g.grade_course_rev_ref and grade_exam_type_ref =e.exam_type 
where grade_course_code_ref ='CS_SOFTWARE_SECURITY'
group by ct.contact_first_name ,ct.contact_last_name ,grade_course_code_ref,g.grade_score,e.exam_weight ,s.student_epita_email) as t ) k
where rnk <=5;

--Get the Class average for a course
select grade_course_code_ref,cast(avg(t.grade)as decimal(10,2)) as classAverage from
(select distinct ct.contact_first_name ,ct.contact_last_name ,student_epita_email,
g.grade_course_code_ref ,
cast(Sum(grade_score* e.exam_weight) over (partition by grade_course_code_ref,s.student_epita_email)/
cast(sum(exam_weight)over (partition by grade_course_code_ref,s.student_epita_email) as decimal(10,2)) as decimal(10,2)) as grade FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join contacts ct on ct.contact_email =s.student_contact_ref 
left join exams e on e.exam_course_code =g.grade_course_code_ref and e.exam_course_rev =g.grade_course_rev_ref and grade_exam_type_ref =e.exam_type 
where grade_course_code_ref ='CS_SOFTWARE_SECURITY'
group by ct.contact_first_name ,ct.contact_last_name ,grade_course_code_ref,g.grade_score,e.exam_weight ,s.student_epita_email )as t
group by grade_course_code_ref;

-- Get a student full report of grades and attendances

select attendance_student_ref,contact_first_name ,contact_last_name,grade_course_code_ref,grade as finalGrade,present ,absent from (select distinct ct.contact_first_name ,ct.contact_last_name ,
grade_course_code_ref,
cast(Sum(grade_score* e.exam_weight) over (partition by grade_course_code_ref)/
cast(sum(exam_weight)over (partition by grade_course_code_ref) as decimal(10,2)) as decimal(10,2)) as grade
FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join contacts ct on ct.contact_email =s.student_contact_ref 
left join exams e on e.exam_course_code =g.grade_course_code_ref and e.exam_course_rev =g.grade_course_rev_ref and grade_exam_type_ref =e.exam_type 
where grade_student_epita_email_ref='delmy.ahle@epita.fr') as gr
left join 
(select attendance_student_ref,attendance_population_year_ref,attendance_course_ref,attendance_course_rev, sum(case when status='Present' then 1 else 0 end) as present,
 sum(case when status='Absent' then 1 else 0 end) as absent from (
SELECT attendance_student_ref, attendance_population_year_ref, attendance_course_ref, attendance_course_rev, 
        attendance_session_date_ref, attendance_session_start_time, attendance_session_end_time, case when attendance_presence=1 then 'Present' else 'Absent' end status
FROM public.attendance
where attendance_student_ref='delmy.ahle@epita.fr') as k
group by attendance_student_ref,attendance_population_year_ref,attendance_course_ref,attendance_course_rev) as t
on t.attendance_course_ref=gr.grade_course_code_ref;


-- Get a student full report of grades ,ranks per course  and attendances
select concat(contact_first_name,' ', contact_last_name),grade_course_code_ref,student_epita_email,grade,rnk as classrank,present,absence from (
select * from (
select contact_first_name ,contact_last_name ,student_epita_email,grade_course_code_ref,grade, rank() over (partition by grade_course_code_ref order by grade desc) as rnk 
from ( select distinct ct.contact_first_name ,ct.contact_last_name ,student_epita_email,grade_course_code_ref,
cast(Sum(grade_score* e.exam_weight) over (partition by grade_course_code_ref,s.student_epita_email)/
cast(sum(exam_weight)over (partition by grade_course_code_ref,s.student_epita_email) as decimal(10,2)) as decimal(10,2)) as grade
FROM grades g
left join students s on s.student_epita_email = g.grade_student_epita_email_ref
left join contacts ct on ct.contact_email =s.student_contact_ref 
left join exams e on e.exam_course_code =g.grade_course_code_ref and e.exam_course_rev =g.grade_course_rev_ref and grade_exam_type_ref =e.exam_type 
group by ct.contact_first_name ,ct.contact_last_name ,grade_course_code_ref,g.grade_score,e.exam_weight ,s.student_epita_email ) as t ) k
where k.student_epita_email='delmy.ahle@epita.fr') as gr
left join 
(select attendance_student_ref,attendance_population_year_ref,attendance_course_ref,attendance_course_rev, sum(case when status='Present' then 1 else 0 end) as present,
 sum(case when status='Absent' then 1 else 0 end) as absence from (
SELECT attendance_student_ref, attendance_population_year_ref, attendance_course_ref, attendance_course_rev, 
        attendance_session_date_ref, attendance_session_start_time, attendance_session_end_time, case when attendance_presence=1 then 'Present' else 'Absent' end status
FROM public.attendance
where attendance_student_ref='delmy.ahle@epita.fr') as k
group by attendance_student_ref,attendance_population_year_ref,attendance_course_ref,attendance_course_rev) as t
on t.attendance_course_ref=gr.grade_course_code_ref
order by grade desc;



--Question 1 : simple query : get all the contacts from Anchorage, display the columns contact email, firstname and city ordered by contact_firstname
select * from contacts where contact_city ilike 'Anchorage';


--Question 2 : intermediate query : find all the teachers who haven't taught at all, return the teacher email addresses, in ascending order
select teacher_epita_email from teachers 
where teacher_epita_email not in (select distinct session_prof_ref from sessions)
order by teacher_epita_email asc;


-- Question 3 : harder query : compute the absence rate per student and per course, ordered by student epita_email ascending, course name ascending and absence rate descending
select attendance_student_ref,attendance_course_ref,cast(round(cast(absent as decimal)*100/ totalAttendance,2) as varchar)|| '%' as absence_ratio From (
select attendance_student_ref,attendance_population_year_ref,attendance_course_ref,attendance_course_rev, sum(case when status='Present' then 1 else 0 end) as present,
 sum(case when status='Absent' then 1 else 0 end) as absent,count(*) as totalAttendance from (
SELECT attendance_student_ref, attendance_population_year_ref, attendance_course_ref, attendance_course_rev, 
        attendance_session_date_ref, attendance_session_start_time, attendance_session_end_time, case when attendance_presence=1 then 'Present' else 'Absent' end status
FROM public.attendance) as t
group by attendance_student_ref,attendance_population_year_ref,attendance_course_ref,attendance_course_rev
order by attendance_student_ref,attendance_population_year_ref,attendance_course_ref) as R

-- Question 3 version 2 
select attendance_student_ref,attendance_course_ref,cast(round(cast(absent as decimal)*100/ totalAttendance,2) as varchar)|| '%' as absence_ratio From (
select attendance_student_ref,attendance_population_year_ref,attendance_course_ref,attendance_course_rev, sum(case when attendance_presence='1' then 1 else 0 end) as present,
sum(case when attendance_presence='0' then 1 else 0 end) as absent,count(*) as totalAttendance from attendance
group by attendance_student_ref,attendance_population_year_ref,attendance_course_ref,attendance_course_rev
order by attendance_student_ref,attendance_population_year_ref,attendance_course_ref) as R


---------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------Attendance----------------------------------------------------------------------------------------------
SELECT attendance_student_ref, attendance_population_year_ref, attendance_course_ref, attendance_course_rev, 
        attendance_session_date_ref, attendance_session_start_time, attendance_session_end_time, attendance_presence
FROM public.attendance;

--Contacts-----------------------------------------------------------------------------------------------------------------------------------------

SELECT contact_email, contact_first_name, contact_last_name, contact_address, contact_city, contact_country, contact_birthdate 
FROM public.contacts;

--Courses-------------------------------------------------------------------------------------------------------------------------------------------

SELECT course_code, course_rev, duration, course_last_rev, course_name, course_description FROM public.courses;

--Exams---------------------------------------------------------------------------------------------------------------------------------------------

SELECT exam_course_code, exam_course_rev, exam_weight, exam_type FROM public.exams;

--Grades-------------------------------------------------------------------------------------------------------------------------------------------

SELECT grade_student_epita_email_ref, grade_course_code_ref, grade_course_rev_ref, grade_exam_type_ref, grade_score FROM public.grades;

--Populations------------------------------------------------------------------------------------------------------------------------------------------

SELECT population_code, population_year, population_period  FROM public.populations;

--Programs------------------------------------------------------------------------------------------------------------------------------------------

SELECT program_course_code_ref, program_course_rev_ref, program_assignment FROM public.programs;

--Sessions------------------------------------------------------------------------------------------------------------------------------------------

SELECT session_course_ref, session_course_rev_ref, session_prof_ref, session_date, session_start_time, session_end_time, session_type, 
       session_population_year, session_population_period, session_room
FROM public.sessions;

--Students------------------------------------------------------------------------------------------------------------------------------------------

SELECT student_epita_email, student_contact_ref, student_enrollment_status, student_population_period_ref, student_population_year_ref, student_population_code_ref
FROM public.students;

--Teachers------------------------------------------------------------------------------------------------------------------------------------------

SELECT teacher_contact_ref, teacher_epita_email, teacher_study_level
FROM public.teachers;





