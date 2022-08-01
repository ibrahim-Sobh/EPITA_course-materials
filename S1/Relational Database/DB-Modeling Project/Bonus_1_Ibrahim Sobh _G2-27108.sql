
SET search_path = epita, pg_catalog;

-----------------------------------------------------------------------------
INSERT INTO epita.admins( email, password, ispedagogical, createdon) 
VALUES 
 ('isobh@epita.fr', 'POP@MAC4155', 'FALSE', CURRENT_timestamp + interval '1 day'),
 ('sergio@epita.fr', 'SER@MAC1358', 'FALSE', CURRENT_timestamp + interval '2 day'),
 ('anand@epita.fr', 'ANA@MAC4585', 'FALSE', CURRENT_timestamp + interval '3 day'),
 ('rabih@epita.fr', 'RAB@MAC4525', 'TRUE', CURRENT_timestamp + interval '4 day'),
 ('stephanie@epita.fr', 'STE@MAC3245', 'TRUE', CURRENT_timestamp + interval '5 day');

--select adminID, email, password, ispedagogical, createdon from epita.admins;

-----------------------------------------------------------------------------
INSERT INTO epita.clients (firstname,lastname,status,isinscriptionpaid,ispaymentcompleted,email,address,phonenumber,createdon)
VALUES
  ('Nehru','Mckee','STUDENT','True','TRUE','nulla@hotmai.com','5015 Eu Ave Aruba','937-5245','2020-03-02'),
  ('Maite','David','STUDENT','True','TRUE','eget.massa.suspendisse@hotmai.com','8102 Ultricies Av. Taiwan','1-727-356-2655','2019-11-15'),
  ('Winifred','Mccarthy','STUDENT','True','TRUE','non@outlook.com','Ap #298-4751 Aliquam St. Singapore','827-6445','2020-03-30'),
  ('Ivana','Wolfe','STUDENT','True','TRUE','ligula@google.com','P.O. Box 890, 485 Ipsum Av. Turkey','698-4435','2021-07-07'),
  ('Tobias','Collins','STUDENT','True','TRUE','ac.metus@google.com','Ap #549-4760 Phasellus Street Uzbekistan','1-841-800-2774','2019-06-01'),
  ('Myra','Stuart','STUDENT','True','TRUE','eget@outlook.com','5669 Elit Street Canada','181-2726','2021-01-28'),
  ('Chaim','O''donnell','STUDENT','True','TRUE','duis.a.mi@google.com','Ap #233-8696 Nisi. Rd. Niue','1-411-307-7696','2019-05-17'),
  ('Teagan','Roy','STUDENT','True','TRUE','amet.consectetuer@hotmai.com','P.O. Box 748, 8002 Sed Road Slovakia','1-464-972-5640','2019-06-10'),
  ('Odessa','Slater','STUDENT','True','TRUE','fermentum.convallis@outlook.com','825-4662 Dictum Street Brunei','1-716-644-4875','2020-12-19'),
  ('Hyacinth','Thornton','STUDENT','True','TRUE','magna@outlook.com','Ap #840-6422 Aenean St. Mongolia','537-3862','2019-01-02'),
  ('Prescott','Cotton','STUDENT','True','TRUE','libero.at@outlook.com','643-5872 Blandit Street Togo','1-355-126-8638','2020-09-11'),
  ('Fulton','Roach','STUDENT','True','TRUE','risus.at@hotmai.com','Ap #903-8765 Iaculis, Rd. Dominica','1-258-554-7144','2021-08-09'),
  ('Xenos','O''connor','STUDENT','True','TRUE','mauris.aliquam@outlook.com','P.O. Box 469, 6245 Nibh St. Denmark','1-472-763-5221','2022-01-12'),
  ('Ursa','Cleveland','STUDENT','True','TRUE','malesuada@google.com','P.O. Box 651, 7354 Quisque St. Korea, North','614-6121','2021-08-11'),
  ('Silas','Forbes','STUDENT','True','TRUE','cubilia.curae.donec@hotmai.com','P.O. Box 666, 9467 Vel St. Guam','1-281-855-5114','2021-06-08'),
  ('Brent','Gallegos','STUDENT','True','TRUE','pharetra.quisque.ac@hotmai.com','1178 Lobortis Av. Sierra Leone','797-7438','2020-05-0020'),
  ('Magee','Alston','STUDENT','True','TRUE','duis.elementum@outlook.com','Ap #117-3810 Pede Street Switzerland','1-106-257-1704','2019-08-18'),
  ('Chantale','Livingston','STUDENT','True','TRUE','dui.semper.et@hotmai.com','P.O. Box 554, 6529 Risus Rd. Viet Nam','1-347-292-6490','2020-01-24'),
  ('Eleanor','Mejia','STUDENT','True','TRUE','eleifend.vitae.erat@hotmai.com','Ap #875-1573 Semper Rd. Christmas Island','1-335-425-8136','2021-08-06'),
  ('Victoria','Stephenson','STUDENT','True','TRUE','nec@outlook.com','P.O. Box 992, 7422 Et Ave Zambia','1-718-417-1061','2020-05-0003');

INSERT INTO epita.clients (firstname,lastname,status,isinscriptionpaid,ispaymentcompleted,email,address,phonenumber,createdon)
VALUES
  ('Talon','Dorsey','CANDIDATE','FALSE','FALSE','hymenaeos.ut@outlook.com','121-1181 Eu Street Qatar','634-6351','2021-02-0012'),
  ('Teagan','Snider','CANDIDATE','FALSE','FALSE','ridiculus.mus@outlook.com','Ap #789-2006 Nisl. Street Kazakhstan','356-7811','2019-12-0005'),
  ('Brady','Huffman','CANDIDATE','FALSE','FALSE','ut.pellentesque@google.com','7315 Vitae, St. American Samoa','332-7316','2020-01-0003'),
  ('Oliver','Dunlap','CANDIDATE','FALSE','FALSE','dapibus.ligula@google.com','256-6562 Tincidunt Avenue Morocco','326-0438','2019-09-0030'),
  ('Courtney','Vaughn','CANDIDATE','FALSE','FALSE','in@hotmai.com','778-8635 Non Av. Philippines','407-8638','2020-05-0024');

INSERT INTO epita.clients (firstname,lastname,status,isinscriptionpaid,ispaymentcompleted,email,address,phonenumber,createdon)
VALUES
  ('Reece','Crawford','RECRUITED ','TRUE','FALSE','praesent.eu@outlook.com','4546 Sed St. Niger','1-182-877-8035','2019-05-0006'),
  ('Tucker','Myers','RECRUITED ','TRUE','FALSE','aliquam.arcu@hotmai.com','836-8554 Luctus St. Bhutan','313-7611','2019-09-0023'),
  ('Brock','Leonard','RECRUITED ','TRUE','FALSE','hendrerit.a@hotmai.com','382-6999 Varius. Rd. Burundi','1--222-2572','2021-08-0019'),
  ('Clio','Perez','RECRUITED ','TRUE','FALSE','fringilla.ornare@hotmai.com','Ap #568-9017 Natoque St. Haiti','1-816-673-6119','2020-12-0023'),
  ('Hasad','Wood','RECRUITED ','TRUE','FALSE','nam@google.com','179-1200 Eget Ave Italy','1-7115-3465','2021-10-0005');

--select clientID,firstname, lastname, status, isinscriptionpaid, ispaymentcompleted, email, address, phonenumber, createdon from epita.clients;

-----------------------------------------------------------------------------

INSERT INTO epita.programs(programcode, intake, intakeyear, programname)
VALUES ('AIS21', 'Fall', '2021','Artificial Intelligence Systems'),
 ('AIS21', 'Spring', '2021','Artificial Intelligence Systems'),
 ('SE21', 'Fall', '2021','Software Engineering'),
 ('SE21', 'Spring', '2021','Software Engineering'),
 ('DSA21', 'Fall', '2021','Data Science & Analytics'),
 ('DSA21', 'Spring', '2021','Data Science & Analytics'),
 ('AIS20', 'Fall', '2020','Artificial Intelligence Systems'),
 ('AIS20', 'Spring', '2020','Artificial Intelligence Systems'),
 ('CS21', 'Fall', '2021','Cyber Security'),
 ('CS21', 'Spring', '2021','Cyber Security');

--select programID,programcode, intake, intakeyear, programname from epita.programs;

-----------------------------------------------------------------------------

INSERT INTO epita.students(email, password, clientid, firstname, lastname, address, phonenumber, programid, cohort,
									   personalemail, homecountryaddress, homecountry, hc_phonenumber, createdon)
VALUES
 ('Nehru.Mckee@epita.fr','c663adbc274f4796e15373c','1','Nehru','Mckee','Paris, France','0462823356','1','2021','nulla@hotmai.com','5015 Eu Ave ','Aruba','937-5245','2020-03-02 00:00:00'),
 ('Maite.David@epita.fr','09f2bd5ee862e1479b090ae','2','Maite','David','Paris, France','0662823377','1','2021','eget.massa.suspendisse@hotmai.com','8102 Ultricies Av. ','Taiwan','1-727-356-2655','2019-11-15 00:00:00'),
 ('Winifred.Mccarthy@epita.fr','0c120ddc9010a78480ad704','3','Winifred','Mccarthy','Paris, France','0785124645','1','2021','non@outlook.com','Ap #298-4751 Aliquam St. ','Singapore','827-6445','2020-03-30 00:00:00'),
 ('Ivana.Wolfe@epita.fr','132be0ce2d5f21c7b669d44','4','Ivana','Wolfe','Paris, France','0654874521','2','2021','ligula@google.com','P.O. Box 890 485 Ipsum Av.','Turkey','698-4435','2021-07-07 00:00:00'),
 ('Tobias.Collins@epita.fr','37bcd7aed32f6155a338232','5','Tobias','Collins','Paris, France','0795423652','2','2021','ac.metus@google.com','Ap #549-4760 Phasellus Street ','Uzbekistan','1-841-800-2774','2019-06-01 00:00:00'),
 ('Myra.Stuart@epita.fr','46eaea0aa795a56f2927f5c','6','Myra','Stuart','Paris, France','0654874544','2','2021','eget@outlook.com','5669 Elit Street ','Canada','181-2726','2021-01-28 00:00:00'),
 ('Chaim.Odonnell@epita.fr','8c28c9ed14a9613ad385a73','7','Chaim','Odonnell','Paris, France','0714874521','3','2021','duis.a.mi@google.com','Ap #233-8696 ','Nisi. Rd. Niue','1-411-307-7696','2019-05-17 00:00:00'),
 ('Teagan.Roy@epita.fr','e328a336593fc2bc976c25b','8','Teagan','Roy','Paris, France','0694874521','3','2021','amet.consectetuer@hotmai.com','"P.O. Box 748 8002 Sed Road "','Slovakia','1-464-972-5640','2019-06-10 00:00:00'),
 ('Odessa.Slater@epita.fr','3321a85c76e82cec7080cf1','9','Odessa','Slater','Paris, France','0711945291','3','2021','fermentum.convallis@outlook.com','825-4662 Dictum Street ','Brunei','1-716-644-4875','2020-12-19 00:00:00'),
 ('Hyacinth.Thornton@epita.fr','9b8304ccd2fdc16751e2bda','10','Hyacinth','Thornton','Paris, France','0565464664','4','2021','magna@outlook.com','Ap #840-6422 Aenean St. ','Mongolia','537-3862','2019-01-22 00:00:00'),
 ('Prescott.Cotton@epita.fr','1d2a86ecd6660e037dd47de','11','Prescott','Cotton','Paris, France','0462823356','7','2020','libero.at@outlook.com','643-5872 Blandit Street ','Togo','1-355-126-8638','2020-09-11 00:00:00'),
 ('Fulton.Roach@epita.fr','a74c417b65ebe409df725bc','12','Fulton','Roach','Paris, France','0654874544','4','2021','risus.at@hotmai.com','"Ap #903-8765 Iaculis Rd. "','Dominica','1-258-554-7144','2021-08-09 00:00:00'),
 ('Xenos.Oconnor@epita.fr','dc15ca12204d62325269d25','13','Xenos','Oconnor','Paris, France','0611945291','7','2020','mauris.aliquam@outlook.com','"P.O. Box 469 6245 Nibh St. "','Denmark','1-472-763-5221','2022-01-12 00:00:00'),
 ('Ursa.Cleveland@epita.fr','3fb52640ec41be8576d2de0','14','Ursa','Cleveland','Paris, France','0711942291','5','2021','malesuada@google.com','"P.O. Box 651 7354 Quisque St. "','Korea North','614-6121','2021-08-11 00:00:00'),
 ('Silas.Forbes@epita.fr','50eba43157cf2e951ed35f4','15','Silas','Forbes','Paris, France','0616645291','7','2020','cubilia.curae.donec@hotmai.com','"P.O. Box 666  9467 Vel St. "','Guam','1-281-855-5114','2021-06-08 00:00:00'),
 ('Brent.Gallegos@epita.fr','47eb31d5e8f817d3c9c208e','16','Brent','Gallegos','Paris, France','0654874544','5','2021','pharetra.quisque.ac@hotmai.com','1178 Lobortis Av. ','Sierra Leone','797-7438','2020-05-20 00:00:00'),
 ('Magee.Alston@epita.fr','746963348047099f313d14a','17','Magee','Alston','Paris, France','0462823356','5','2021','duis.elementum@outlook.com','Ap #117-3810 Pede Street ','Swizerland','1-106-257-1704','2019-08-18 00:00:00'),
 ('Chantale.Livingston@epita.fr','bbde075534dad2b33c7999f','18','Chantale','Livingston','Paris, France','0662823377','7','2020','dui.semper.et@hotmai.com','"P.O. Box 554 6529 Risus Rd. "','Viet Nam','1-347-292-6490','2020-01-24 00:00:00'),
 ('Eleanor.Mejia@epita.fr','9f65d8ccfb2f53d8224583d','19','Eleanor','Mejia','Paris, France','0462823356','9','2021','eleifend.vitae.erat@hotmai.com','Ap #875-1573 Semper Rd. ','Christmas Island','1-335-425-8136','2021-08-06 00:00:00'),
 ('Victoria.Stephenson@epita.fr','2ef4e7869a0f6ccde9f5126','20','Victoria','Stephenson','Paris, France','0785124645','7','2020','nec@outlook.com','"P.O. Box 992 7422 Et Ave "','Zambia','1-718-417-1061','2020-05-03 00:00:00');

--select * from epita.students;

-----------------------------------------------------------------------------

INSERT INTO epita.teachers (teacheremail,firstname,lastname,personalemail,iban,Bic,isReferenced,address)
VALUES
  ('reuben_lowe@epita.fr','Reuben','Lowe','reuben@icloud.com','IE85FVMP80036415648128','bic341652','True','Ap #392-5419 Volutpat. Av.'),
  ('a_cannon@epita.fr','Ann','Cannon','ann@icloud.com','PT42870816228136582204233','bic341651','True','536-3755 Nibh Av.'),
  ('cline-emi@epita.fr','Emi','Cline','emi@outlook.com','MU2531118656672135438616463453','bic342654','False','7988 Hendrerit Road'),
  ('haynes-grace5263@epita.fr','Grace','Haynes','grace9879@aol.com','PL86025453991464667225168456','bic3041654','False','Ap #905-9063 Nec, Av.'),
  ('welch.samuel@epita.fr','Samuel','Welch','samuel@outlook.com','TR787756723685723552772929','bic34165334','True','697-8263 Sed Ave'),
  ('connersonya@epita.fr','Sonya','Conner','sonya@icloud.com','HU98277430457847373382137842','bic3410654','True','Ap #162-2449 Tincidunt Avenue'),
  ('p_marquez2848@epita.fr','Pascale','Marquez','pascale1045@icloud.com','HR2933256445448261263','bic3491654','False','694-1995 Duis Rd.'),
  ('celestesummers@epita.fr','Celeste','Summers','celeste1490@hotmail.com','AT258930650167119629','bic3419654','False','Ap #544-9684 Nostra, Rd.'),
  ('h_orla7469@epita.fr','Orla','Haney','orla8693@google.com','SK9762691743770688866544','bic3416504','True','P.O. Box 820, 5236 Lobortis St.'),
  ('a_bell1417@epita.fr','Arden','Bell','arden@google.com','GI72MMYQ652181713454473','bic3416584','True','P.O. Box 428, 9523 Imperdiet St.'),
  ('armstrongjared@epita.fr','Jared','Armstrong','jared@icloud.com','GB10YJNK97302464564135','bic3471654','False','4538 Arcu. St.'),
  ('garner.madeson4809@epita.fr','Madeson','Garner','madeson@hotmail.com','AD7232307233169846878265','bic34781654','False','979-4970 Mauris Avenue'),
  ('h_hu@epita.fr','Hu','Hooper','hu@outlook.com','IE11KILI37164264182886','bic3416564','True','P.O. Box 477, 6449 Dapibus Rd.'),
  ('foster_rylee5994@epita.fr','Rylee','Foster','rylee2091@google.com','CR0842274138951744846','bic3461654','True','897-6052 Luctus St.'),
  ('key.petra@epita.fr','Petra','Key','petra@google.com','MC0301918734422207674722862','bic3416534','False','P.O. Box 185, 3697 Orci. Rd.'),
  ('c.geraldine8143@epita.fr','Geraldine','Cotton','geraldine488@outlook.com','MK60668672748829165','bic3431654','False','822-7456 Diam. Rd.'),
  ('slade-dennis5330@epita.fr','Slade','Dennis','slade@outlook.com','CY40213673948501584736596715','bic3412654','True','Ap #814-3954 Lobortis Street'),
  ('h.hall@epita.fr','Hammett','Hall','hammett6152@aol.com','GB25WMYK31834358725154','bic3416524','True','1300 Eu Av.'),
  ('hill-christopher7143@epita.fr','Christopher','Hill','christopher8236@hotmail.com','CZ4605141862714128226873','bic3411654','False','8865 Mauris Av.'),
  ('s-wyatt3058@epita.fr','Steven','Wyatt','steven@google.com','RS89615171785683140676','bic3416154','False','334-6333 Tincidunt Rd.');

--select * from teachers

-----------------------------------------------------------------------------

INSERT INTO epita.courses (coursecode,coursename,duration,teacherid)
VALUES
  ('CHP','Challenge in python',12,1),
  ('INP','Intro to python',12,1),
  ('KRAIH','Knowledge representation & ai history',14,3),
  ('RDB','Relational databases',14,6),
  ('ADALG','Advanced algorithmic',16,7),
  ('JUML','Java & UML programming',16,8),
  ('FRCH','French language',12,11),
  ('LADS','Linear algebra for Data science',12,12),
  ('MCS','Managing the culture shock',14,14),
  ('CHP','Challenge in python',14,16);
  
--select * from courses

-----------------------------------------------------------------------------
INSERT INTO epita.groupCodes (groupcode,groupdescription)
VALUES
  ('AIS','Artificial Intelligence Systems'),
  ('DSA','Data Science & Analytics'),
  ('CS','Cyber Security'),
  ('SE','Software Engineering'),
  ('G1','Group 1'),
  ('G2','Group 2'),
  ('AIMS','Artificial Intelligence Systems For Marketing Strategies');
 
--select * from groupcodes;
-----------------------------------------------------------------------------

INSERT INTO epita.studentsGroups (groupcode,studentid,createdon)
VALUES
  ('AIS',5,'2021-06-17 09:22:22'),
  ('DSA',10,'2022-05-02 05:46:46'),
  ('CS',8,'2021-12-13 10:49:49'),
  ('SE',3,'2021-04-23 12:45:45'),
  ('G1',14,'2021-03-23 05:21:21'),
  ('G2',3,'2022-01-08 08:43:43'),
  ('AIS',2,'2021-02-05 09:49:49'),
  ('DSA',17,'2020-12-12 05:11:11'),
  ('CS',20,'2020-12-10 10:57:57'),
  ('SE',4,'2022-02-19 11:10:10'),
  ('G1',17,'2021-05-12 07:37:37'),
  ('G2',5,'2021-07-04 04:25:25'),
  ('AIS',11,'2022-05-01 05:02:02'),
  ('DSA',4,'2021-07-19 09:36:36'),
  ('CS',4,'2022-10-30 08:15:15'),
  ('SE',13,'2021-03-31 05:37:37'),
  ('G1',20,'2021-02-10 03:04:04'),
  ('G2',19,'2021-03-24 01:58:58'),
  ('AIS',14,'2021-10-26 06:29:29'),
  ('DSA',11,'2021-05-21 10:58:58'),
  ('CS',9,'2022-10-14 02:43:43'),
  ('SE',20,'2021-05-07 06:16:16'),
  ('G1',11,'2021-10-20 04:53:53'),
  ('G2',6,'2022-11-02 01:03:03'),
  ('AIS',13,'2021-04-23 04:47:47'),
  ('DSA',1,'2021-08-23 11:29:29'),
  ('CS',3,'2022-09-04 05:04:04'),
  ('SE',1,'2022-09-07 07:37:37'),
  ('G1',6,'2021-07-28 05:12:12'),
  ('G2',11,'2022-05-11 11:47:47'),
  ('AIS',1,'2022-11-24 12:26:26'),
  ('DSA',15,'2022-10-20 03:16:16'),
  ('CS',11,'2021-03-17 11:43:43'),
  ('SE',14,'2022-05-23 09:15:15'),
  ('G1',13,'2021-10-07 07:51:51'),
  ('G2',2,'2021-04-18 01:23:23'),
  ('AIS',17,'2021-01-12 06:08:08'),
  ('DSA',16,'2022-04-03 06:46:46'),
  ('CS',7,'2022-09-17 06:48:48'),
  ('SE',19,'2022-05-01 11:07:07'),
  ('G1',18,'2022-01-01 03:08:08'),
  ('G2',9,'2022-04-23 02:31:31'),
  ('AIS',18,'2022-03-18 11:39:39'),
  ('DSA',19,'2021-06-28 02:14:14'),
  ('CS',12,'2022-05-20 11:19:19'),
  ('SE',8,'2022-04-11 03:18:18'),
  ('G1',15,'2022-03-26 08:33:33'),
  ('G2',15,'2022-11-06 05:21:21'),
  ('AIS',8,'2022-05-23 11:09:09'),
  ('DSA',18,'2022-05-12 01:20:20'),
  ('AIS',20,'2022-05-12 01:20:20');

--select * from studentsGroups;
----------------------------------------------------------------------------
INSERT INTO epita.rooms (roomcode,building,capacity)
VALUES
  ('KB101','Voltaire',25),
  ('KB102','Voltaire',25),
  ('KB103','Voltaire',50),
  ('KB104','Voltaire',50),
  ('KB105','Voltaire',60),
  ('KB601','Voltaire',25),
  ('KB602','Voltaire',25),
  ('KB603','Voltaire',50),
  ('KB604','Voltaire',50),
  ('KB605','Voltaire',60),
  ('ONLINE','Virtual',100);
  
 --select * from rooms;
----------------------------------------------------------------------------
INSERT INTO epita.curriculums(programid, courseid, semester, weight)
VALUES 
    (1, 1, 'S1', '1'),
    (1, 2, 'S1','2'),
    (1, 3, 'S1', '5'),
    (1, 4, 'S1', '1'),
    (1, 5, 'S1', '2'),
    (1, 6, 'S1', '3'),
    (2, 1, 'S1', '4'),
    (2, 2, 'S1', '5'),
    (2, 3, 'S1', '2'),
    (2, 4, 'S1', '2'),
    (2, 5, 'S1', '2'),
    (2, 6, 'S1', '2'),
    (3, 1, 'S1','1'),
    (3, 2, 'S1', '2'),
    (3, 3, 'S1', '1'),
    (3, 4, 'S1', '1'),
    (3, 7, 'S1', '2'),
    (3, 8, 'S1', '1'),
    (3, 9, 'S1', '2'),
    (3, 10, 'S1', '2'),
    (4, 3, 'S1', '1'),
    (4, 5, 'S1', '5'),
    (4, 6, 'S1', '1'),
    (4, 9, 'S1', '4'),
    (5, 2, 'S1', '1'),
    (5, 4, 'S1', '3'),
    (5, 6, 'S1','1'),
    (5, 8, 'S1', '1'),
    (5, 10, 'S1','2'),
    (6, 1, 'S1', '1'),
    (6, 3, 'S1', '1'),
    (6, 5, 'S1', '3'),
    (6, 7, 'S1', '2'),
    (6, 9, 'S1', '1');
	
--select * from  epita.curriculums;

----------------------------------------------------------------------------
INSERT INTO epita.sessions(startsat, endsat, teacherid, courseid,
						   roomcode, sessiontype)
VALUES 
      (CURRENT_timestamp + interval '1 day',
	   CURRENT_timestamp + interval '1 day'+interval '2 hour', 1,2, 'KB601', 'Regular on-campus lectures'),
	     (CURRENT_timestamp + interval '3 day',
	   CURRENT_timestamp + interval '3 day'+interval '2 hour', 1,2, 'ONLINE', 'Online lecture'),
	     (CURRENT_timestamp + interval '5 day',
	   CURRENT_timestamp + interval '5 day'+interval '2 hour', 1,2, 'KB605', 'Practical work'),
	     (CURRENT_timestamp + interval '1 day',
	   CURRENT_timestamp + interval '1 day'+interval '2 hour', 6,4, 'KB603', 'Regular on-campus lectures'),
	     (CURRENT_timestamp + interval '3 day',
	   CURRENT_timestamp + interval '3 day'+interval '3 hour', 6,4, 'KB602', 'Exams'),
	     (CURRENT_timestamp + interval '1 day '+ interval '2.5 hour',
	   CURRENT_timestamp + interval '1 day'+ interval '4.5 hour', 7,5, 'KB601', 'Regular on-campus lectures'),
	     (CURRENT_timestamp + interval '3 day '+ interval '2.5 hour',
	   CURRENT_timestamp + interval '3 day'+ interval '4.5 hour', 7,5, 'KB602', 'Regular on-campus lectures');
	   
--select * from  sessions;

----------------------------------------------------------------------------
INSERT INTO epita.groupsessions(groupcode, sessionid)
VALUES
('AIS', '1'),
('AIS', '2'),
('AIS', '3'),
('DSA', '1'),
('DSA', '2'),
('DSA', '3'),
('AIS', '4'),
('AIS', '5'),
('AIS', '6'),
('CS', '7'),
('CS', '6');

-- select * from groupsessions
----------------------------------------------------------------------------
INSERT INTO epita.attendance(sessionid, studentid, ispresent, isabsent, reason)
	VALUES
	(1, 1, 'TRUE', 'FALSE', ''),
	(1, 2, 'TRUE', 'FALSE', ''),
	(1, 5, 'TRUE', 'FALSE', ''),
	(1, 8, 'TRUE', 'FALSE', ''),
	(1, 11, 'TRUE', 'FALSE', ''),
	(1, 13, 'TRUE', 'FALSE', ''),
	(1, 14, 'TRUE', 'FALSE', ''),
	(1, 17, 'TRUE', 'FALSE', ''),
	(1, 18, 'TRUE', 'FALSE', ''),
	(1, 20, 'TRUE', 'FALSE', ''),
	(2, 1, 'FALSE', 'FALSE', ''),
	(2, 2, 'TRUE', 'FALSE', ''),
	(2, 5, 'FALSE', 'FALSE', ''),
	(2, 8, 'TRUE', 'FALSE', ''),
	(2, 11, 'TRUE', 'FALSE', ''),
	(2, 13, 'TRUE', 'FALSE', ''),
	(2, 14, 'TRUE', 'FALSE', ''),
	(2, 17, 'FALSE', 'FALSE', ''),
	(2, 18, 'FALSE', 'FALSE', ''),
	(2, 20, 'TRUE', 'FALSE', '');

-- select * from attendance
----------------------------------------------------------------------------
INSERT INTO epita.exams(courseid, examtype, isgroup, examdate, examduration, weight)
	VALUES
	(2,'exam',false,'2021-12-06','120',3),
	(2,'assignment-1',false,'2021-12-06','30',1),
	(2,'assignment-2',false,'2021-12-06','60',2),
	(4,'exam',true,'2021-12-06','60',2),
	(5,'assignment-1',false,'2021-12-06','60',2);

-- select * from exams;
----------------------------------------------------------------------------	
INSERT INTO epita.examsresults(studentid, examid, grade, createdon)
	VALUES 
	(1, 2,17.7 , CURRENT_timestamp + interval '6 day'),
	(2, 2,19.2, CURRENT_timestamp + interval '6 day'),
	(3, 2,18.2, CURRENT_timestamp + interval '6 day'),
	(4, 2,14.2 , CURRENT_timestamp + interval '6 day'),
	(5, 2,13.2, CURRENT_timestamp + interval '6 day'),
	(6, 2,15.32, CURRENT_timestamp + interval '6 day'),
	(7, 2,16.43, CURRENT_timestamp + interval '6 day'),
	(8, 2,12, CURRENT_timestamp + interval '6 day'),
	(9 ,2, 11, CURRENT_timestamp + interval '6 day'),
	(10, 2,9 , CURRENT_timestamp + interval '6 day'),
	(11, 2,3 , CURRENT_timestamp + interval '6 day'),
	(12, 2,9.8, CURRENT_timestamp + interval '6 day'),
	(13, 2,16.2, CURRENT_timestamp + interval '6 day'),
	(14, 2,12, CURRENT_timestamp + interval '6 day'),
	(15, 2,12, CURRENT_timestamp + interval '6 day'),
	(16, 2,18, CURRENT_timestamp + interval '6 day'),
	(17, 2,18, CURRENT_timestamp + interval '6 day'),
	(18, 2,15, CURRENT_timestamp + interval '6 day'),
	(19, 2,12.4, CURRENT_timestamp + interval '6 day'),
	(20, 2,10.5, CURRENT_timestamp + interval '6 day'),
	(1, 1,14.7 , CURRENT_timestamp + interval '6 day'),
	(2, 1,12.2, CURRENT_timestamp + interval '6 day'),
	(3, 1,13.2, CURRENT_timestamp + interval '6 day'),
	(4, 1,14.5 , CURRENT_timestamp + interval '6 day'),
	(5, 1,12.2, CURRENT_timestamp + interval '6 day'),
	(6, 1,10.32, CURRENT_timestamp + interval '6 day'),
	(7, 1,15.3, CURRENT_timestamp + interval '6 day'),
	(8, 1,11.5, CURRENT_timestamp + interval '6 day'),
	(9 ,1, 17, CURRENT_timestamp + interval '6 day'),
	(10, 1,6.9 , CURRENT_timestamp + interval '6 day'),
	(11, 1,3 , CURRENT_timestamp + interval '6 day'),
	(12, 1,9.8, CURRENT_timestamp + interval '6 day'),
	(13, 1,16.2, CURRENT_timestamp + interval '6 day'),
	(14, 1,12, CURRENT_timestamp + interval '6 day'),
	(15, 1,12, CURRENT_timestamp + interval '6 day'),
	(16, 1,18, CURRENT_timestamp + interval '6 day'),
	(17, 1,18, CURRENT_timestamp + interval '6 day'),
	(18, 1,15, CURRENT_timestamp + interval '6 day'),
	(19, 1,12.4, CURRENT_timestamp + interval '6 day'),
	(20, 1,10.5, CURRENT_timestamp + interval '6 day'),
	(1, 4,15.7 , CURRENT_timestamp + interval '6 day'),
	(2, 4,11.2, CURRENT_timestamp + interval '6 day'),
	(3, 4,16.2, CURRENT_timestamp + interval '6 day');

--select * from examsresults;
----------------------------------------------------------------------------
