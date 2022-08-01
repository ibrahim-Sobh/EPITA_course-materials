SET search_path = epita, pg_catalog;
DROP SCHEMA IF EXISTS epita CASCADE;
-----------------------------------------------------------------------------
CREATE SCHEMA epita;

SET search_path = epita, pg_catalog;

-----------------------------------------------------------------------------
CREATE TABLE admins (
	adminID SERIAL, /*Primary*/
    email character varying(35) NOT NULL,
    password character varying(30) NOT NULL,
    isPedagogical boolean NOT NULL,
    createdOn timestamp without time zone NOT NULL,
	CONSTRAINT admins_pk PRIMARY KEY (adminID)
);

COMMENT ON TABLE admins IS  'Admins credentials table, an admin can be
a system admin or a pedagogical admin.';
-----------------------------------------------------------------------------
CREATE Table clients
 (  clientID SERIAL,  /*Primary*/
    firstName character varying(20) NOT NULL,
    lastName character varying(20) NOT NULL,
    status character varying(15) NOT NULL,
  	isInscriptionPaid boolean NOT NULL,
    isPaymentCompleted boolean NOT NULL,
    email character varying(35) NOT NULL,
    address character varying(100) NOT NULL,
    phonenumber character varying(20) NOT NULL,
	createdOn timestamp without time zone NOT NULL,
    CONSTRAINT client_pk PRIMARY KEY (clientID)
 );

COMMENT ON TABLE clients IS 'Clients details table, a client is a possible
future student in the process of enrolment, once he is promoted to a student,
his details of pre-enrolment will be in this table.';
-----------------------------------------------------------------------------
CREATE TABLE programs (
	programID SERIAL, 
    programcode character varying(10) NOT NULL,/*Primary*/
	intake character varying(10) NOT NULL,   /*Primary*/
	intakeYear character varying(4) NOT NULL,/*Primary*/
    programname character varying(40) NOT NULL,
    CONSTRAINT program_intake_pk PRIMARY KEY (programID)
);

COMMENT ON TABLE programs IS 'All Available Programs table, contains all the 
information about each program details, a program is defined by its code, Intake,
Intake year.';
----------------------------------------------------------------------------- 
CREATE TABLE students (
    studentID SERIAL,  /*Primary*/
    email character varying(35) NOT NULL,
    password character varying(30) NOT NULL,
    clientID integer NOT NULL,
    firstName character varying(20) NOT NULL,
    lastName character varying(20) NOT NULL,
    address character varying(100) NOT NULL,
    phonenumber character varying(20) NOT NULL,
	programID integer NOT NULL,
	cohort character varying(10) NOT NULL,
	personalEmail character varying(35) NOT NULL,
	homeCountryAddress character varying(100) NOT NULL,
	homeCountry character varying(30) NOT NULL,
	hc_phonenumber character varying(20) NOT NULL,
	createdOn timestamp without time zone NOT NULL,
	CONSTRAINT students_pk PRIMARY KEY (studentID),
	CONSTRAINT fk_clientstatus FOREIGN KEY(clientID) REFERENCES clients(clientID),
	CONSTRAINT fk_program FOREIGN KEY(programID) REFERENCES programs(programID)
);

COMMENT ON TABLE students IS 'All Enrolled Students table, contains all the 
information about each student intake-year, program and a unique student-ID,
personal info, in addition to a new student-ID and credentials.';
-----------------------------------------------------------------------------
CREATE TABLE teachers (
    teacherID SERIAL,  /*Primary*/
	teacheremail character varying(30) NOT NULL,
	firstName character varying(20) NOT NULL,
    lastName character varying(20) NOT NULL,
	personalemail character varying(30) NOT NULL,
	iban character varying(35) NOT NULL UNIQUE,
	bic character varying(11) NOT NULL UNIQUE,
	isReferenced boolean Not NULL,
    address character varying(100) NOT NULL,
	CONSTRAINT teacher_pk PRIMARY KEY (teacherID)
);

COMMENT ON TABLE teachers IS 'All Registered Teachers table, contains all the 
information about each teacher personal info, payment info.';
-----------------------------------------------------------------------------
CREATE TABLE courses (
	courseID SERIAL, /*Primary*/
	coursecode character varying(10) NOT NULL,
	coursename character varying(40) NOT NULL,
    duration integer Not NULL,
	teacherID integer NOT NULL,
    CONSTRAINT courses_pk PRIMARY KEY (courseID),
	CONSTRAINT fk_teachedby FOREIGN KEY(teacherID) REFERENCES teachers(teacherID)
);

COMMENT ON TABLE courses IS 'All Available Courses table, contains all the 
information about each course code,name duration,and the possible teachers.';
----------------------------------------------------------------------------
CREATE TABLE curriculums (
    curriculumID SERIAL,
	programID integer NOT NULL,/*Primary*/ 
	courseID integer NOT NULL,/*Primary*/ 
	semester character varying(10) NOT NULL,
    weight integer Not NULL,
    CONSTRAINT curriculum_pk PRIMARY KEY (programID,courseID),
	CONSTRAINT fk_courses FOREIGN KEY(courseID) REFERENCES courses(courseID),
	CONSTRAINT fk_programs FOREIGN KEY(programID) REFERENCES programs(programID)
);

COMMENT ON TABLE curriculums IS 'All Curriculums table, contains all the 
information about each curriculum, a curriculume is defined by several semesters
and each semster is defined by several courses for one program.';
----------------------------------------------------------------------------
CREATE TABLE groupCodes (
    groupcode character varying(5),/*Primary*/
	groupdescription character varying(60) NOT NULL,
    CONSTRAINT groupsCodes_pk PRIMARY KEY (groupcode)
);

COMMENT ON TABLE groupCodes IS 'All the defined groups codes, contains all the 
information about a group, a group code and group description';
----------------------------------------------------------------------------
CREATE TABLE studentsGroups (
    studentgroupID SERIAL,/*Primary*/
	groupcode character varying(5) NOT NULL,
	studentID integer NOT NULL,  
	createdOn timestamp without time zone NOT NULL,
    CONSTRAINT studentsgroups_pk PRIMARY KEY (studentgroupID),
	CONSTRAINT fk_student_in_group FOREIGN KEY(studentID) REFERENCES students(studentID),
	CONSTRAINT fk_student_groupcode FOREIGN KEY(groupcode) REFERENCES groupCodes(groupcode)
);

COMMENT ON TABLE studentsGroups IS 'All the defined groups of students, contains all the 
information about each group, a group is defined by several members of the same or 
different formations.';
----------------------------------------------------------------------------
CREATE TABLE exams (
    examID SERIAL,/*Primary*/
	courseID integer NOT NULL,  
	examtype character varying(15) NOT NULL,
    isGroup  boolean NOT NULL,
	examDate timestamp without time zone NOT NULL,
	examDuration integer NOT NULL,
	weight double precision not NULL,
    CONSTRAINT exams_pk PRIMARY KEY (examID),
	CONSTRAINT fk_course_exams FOREIGN KEY(courseID) REFERENCES courses(courseID)
);

COMMENT ON TABLE exams IS 'All the defined Exams for courses, contains all the 
information about all the exams for each course, an exam is defined by several members of the same or 
different formations.';
----------------------------------------------------------------------------
CREATE TABLE examsResults (
    resultID SERIAL,
	studentID integer NOT NULL, /*Primary*/ 
	examID integer NOT NULL,  /*Primary*/
	grade double precision NOT NULL,
	createdOn timestamp without time zone NOT NULL,
    CONSTRAINT examsResults_pk PRIMARY KEY (studentID,examID),
	CONSTRAINT fk_exams_taken FOREIGN KEY(examID) REFERENCES exams(examID),
	CONSTRAINT fk_student_result FOREIGN KEY(studentID) REFERENCES students(studentID)

);

COMMENT ON TABLE examsResults IS 'All the defined Exams Results, contains all the 
information about all the exams results for each student, an exam result is unique 
for one student and for one exam we have one grade.';
----------------------------------------------------------------------------
CREATE TABLE rooms (
	roomCode character varying(10) NOT NULL,/*Primary*/ 
	building character varying(20) NOT NULL,  
    capacity integer NOT NULL,
    CONSTRAINT rooms_pk PRIMARY KEY (roomCode)
);

COMMENT ON TABLE rooms IS 'All the Existing Rooms, contains all the 
information about each room capacity and building name.';
----------------------------------------------------------------------------
CREATE TABLE sessions (
    sessionID SERIAL,  /*Primary*/ 
	startsAt timestamp without time zone NOT NULL, 
	endsAt timestamp without time zone NOT NULL,  
	teacherID integer NOT NULL,
	courseID integer NOT NULL,
	roomCode character varying(6) NOT NULL,
	sessionType character varying(35) NOT NULL,
	
    CONSTRAINT session_pk PRIMARY KEY (sessionID),
	CONSTRAINT fk_session_teacher FOREIGN KEY(teacherID) REFERENCES teachers(teacherID),
	CONSTRAINT fk_session_course FOREIGN KEY(courseID) REFERENCES courses(courseID),
	CONSTRAINT fk_session_room FOREIGN KEY(roomCode) REFERENCES rooms(roomCode)
);

COMMENT ON TABLE sessions IS 'Sessions table contains details about the courses sessions 
and audience, one session can be attended by one or many groups of students at the same 
time. A session has a unique secondary key a combination of start and ending Date, teacher,
course, room and audience (groups of students.';
----------------------------------------------------------------------------
CREATE TABLE attendance (
    attendeeID SERIAL,
	sessionID integer NOT NULL,
	studentID integer NOT NULL,
    isPresent boolean NOT NULL,
	isAbsent boolean NOT NULL,
	Reason bytea Not NULL,
    CONSTRAINT schedule_pk PRIMARY KEY (sessionID,studentID),
	CONSTRAINT fk_student_session FOREIGN KEY(sessionID) REFERENCES sessions(sessionID),
	CONSTRAINT fk_student_attendance FOREIGN KEY(studentID) REFERENCES students(studentID)
);

COMMENT ON TABLE attendance IS 'Attendance Table, Store attendance records for each student
per session an absent student can submit a file with the reason of his absence.';
----------------------------------------------------------------------------
CREATE TABLE groupSessions (
	groupsessionID SERIAL,
	groupcode character varying(5),
	sessionID  integer,
    CONSTRAINT groupsSessions_pk PRIMARY KEY (groupsessionID),
	CONSTRAINT fk_group_sessions FOREIGN KEY(sessionID) REFERENCES sessions(sessionID),
	CONSTRAINT fk_groups_in_session FOREIGN KEY(groupcode) REFERENCES groupCodes(groupcode)
);

COMMENT ON TABLE groupSessions IS 'All the defined groups sessions, contains all the 
information about a group sessions or the attending groups for one session.';
----------------------------------------------------------------------------

