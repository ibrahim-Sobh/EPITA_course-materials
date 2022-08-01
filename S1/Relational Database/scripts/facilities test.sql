show search_path ;
set search_path = cd, pg_catalog;

select * from bookings AS B
inner join facilities AS F on B.facid=F.facid
inner join members as M on B.memid= M.memid;

select F.name as facility,M.firstname, M.surname,starttime as "Date", B.slots from bookings AS B
inner join facilities AS F on B.facid=F.facid
inner join members as M on B.memid= M.memid
order by M.firstname,M.surname

select M.surname,M.firstname,count(F.name) from bookings AS B
inner join facilities AS F on B.facid=F.facid
inner join members as M on B.memid= M.memid
group by F.name,M.surname,M.firstname 
order by M.firstname


select name , monthlymaintenance,
Rank() over ( order by monthlymaintenance desc ) as "Rank"
from facilities

select name , monthlymaintenance,
Rank() over ( order by name desc ) as "Rank"
from facilities

SELECT bookings.memid as memberid,members.firstname, count(bookings.bookid) as cnt FROM bookings
LEFT JOIN members ON members.memid = bookings.memid
GROUP BY bookings.memid,members.firstname /* memebers firstname is correct but
not good we should use the key of members.memid*/
ORDER BY cnt desc


SELECT bookings.memid as memberid,members.firstname,extract(month from starttime) as startmonth, count(bookings.bookid) as cnt FROM bookings
LEFT JOIN members ON members.memid = bookings.memid
GROUP BY bookings.memid,members.firstname,startmonth /* memebers firstname is correct but
not good we should use the key of members.memid*/
ORDER BY cnt desc

