SET search_path = epita, pg_catalog;
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- An Exam Results for one students.
-----------------------------------------------------------------------------
select s.firstname,s.lastname ,c.coursename, e.examtype, er.grade from examsresults er
left join exams e on e.examid=er.examid
left join courses c on c.courseid= e.courseid
left join students s on s.studentid=er.studentid
where er.studentid=1;

-----------------------------------------------------------------------------
--All Attendances for one students .
-----------------------------------------------------------------------------
select st.firstname,st.lastname ,c.coursename,s.sessiontype,
to_char(s.startsat, 'YYYY-MM-DD HH24:MI'),to_char(s.endsat, 'YYYY-MM-DD HH24:MI'),
case when a.isPresent then 'Present' else 'Absent' end presence 
from attendance a
left join students st on st.studentid=a.studentid
left join sessions s on s.sessionid= a.sessionid
left join courses c on c.courseid=s.courseid
where a.studentid=1
order by st.studentid;

-----------------------------------------------------------------------------
--Get all scheduled sessions one group.
-----------------------------------------------------------------------------
select gs.groupcode, to_char(s.startsat, 'YYYY-MM-DD HH24:MI'),
to_char(s.endsat, 'YYYY-MM-DD HH24:MI'),concat(t.firstname,' ',t.lastname) as teacher,
c.coursename,roomcode as room, sessiontype from sessions s
left join teachers t on t.teacherid=s.teacherid
left join courses c on c.courseid= s.courseid
left join groupsessions gs on gs.sessionid=s.sessionid
where gs.groupcode='AIS'
order by s.startsat,s.endsat;

-----------------------------------------------------------------------------
--Get all students of a specific group.
-----------------------------------------------------------------------------
select s.firstname,s.lastname from studentsgroups sg  
left join students s on s.studentid=sg.studentid
where sg.groupcode='AIS'
order by sg.studentid;

-----------------------------------------------------------------------------
--Get all students attending one session regardless of their group.
-----------------------------------------------------------------------------
select distinct st.firstname,st.lastname,gs.groupcode from groupsessions gs
left join sessions s on s.sessionid=gs.sessionid
left join studentsgroups sg on sg.groupcode=gs.groupcode
left join students st on st.studentid=sg.studentid
where s.sessionid=2
order by gs.groupcode,st.firstname, st.lastname;

-----------------------------------------------------------------------------
--Get curriculum for a specfic program
-----------------------------------------------------------------------------
select p.programcode,p.intake,c1.coursename from curriculums c
left join programs p on p.programid= c.programid
left join courses c1 on c.courseid= c1.courseid
where p.intakeyear='2021' and p.intake ilike 'fall' and p.programcode ='AIS21'
order by p.programcode;




