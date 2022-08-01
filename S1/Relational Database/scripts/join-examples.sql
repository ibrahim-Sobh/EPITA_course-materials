--left join
select * from table_a as a
left join table_b as b on a.pk = b.pk;

--left join exclusive
select * from table_a as a
left join table_b as b on a.pk = b.pk
where b.pk is NULL;

--right join
select * from table_a as a
right join table_b as b on a.pk = b.pk;

--right join exclusive
select * from table_a as a
right join table_b as b on a.pk = b.pk
where a.pk is NULL;

--inner join
select * from table_a as a
join table_b as b on a.pk = b.pk;

--full outer join
select * from table_a as a
full outer join table_b as b on a.pk = b.pk;

--full outer join exclusive
select * from table_a as a
full outer join table_b as b on a.pk = b.pk
WHERE A.PK IS NULL OR B.PK IS NULL;