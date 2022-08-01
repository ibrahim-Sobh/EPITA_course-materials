--joining the 3 tables (bookings, facilities and members)
SELECT f.name,m.firstname,b.starttime,b.slots FROM bookings as b
left join facilities AS f on b.facid = f.facid
left join members as m on b.memid = m.memid
where m.firstname like 'T%';

--count facilities rows with condition
SELECT count(facid) as cnt FROM facilities
where monthlymaintenance < 200;

--rank example
SELECT NAME,MONTHLYMAINTENANCE,
RANK() OVER(
	ORDER BY NAME DESC
)
FROM facilities ;

--group by example (memid and month)
SELECT members.memid as memberid,extract(month from starttime) as "month", members.firstname, count(bookings.bookid) as cnt FROM bookings
LEFT JOIN members ON members.memid = bookings.memid
GROUP BY members.memid,"month"
order by memberid;

-- sub selects (traditional)
SELECT memberid, cnt, FROM (
	SELECT bookings.memid as memberid, count(bookings.bookid) as cnt FROM bookings
	LEFT JOIN members ON members.memid = bookings.memid
	GROUP BY bookings.memid
	ORDER BY cnt desc
) mem_bookings;

--sub selects (Postgresql)
WITH mem_bookings as (
	SELECT bookings.memid as memberid, count(bookings.bookid) as cnt FROM bookings
	LEFT JOIN members ON members.memid = bookings.memid
	GROUP BY bookings.memid
	ORDER BY cnt desc
)
SELECT memberid, cnt FROM mem_bookings;
