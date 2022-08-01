show search_path ;
set search_path = test_db, pg_catalog;

SELECT pk, value
	FROM table_a;
	
SELECT pk, value
	FROM table_b;
	
SELECT A.pk,A.value,B.value
	FROM table_a as A
Left join table_b as B on A.pk=B.pk;

SELECT A.pk,A.value,B.value
	FROM table_a as A
Right join table_b as B on B.pk=A.pk;


SELECT B.pk,B.value,A.value
	FROM table_b as B
Left join table_a as A on B.pk=A.pk;

SELECT A.pk,A.value,B.value
	FROM table_a as A
Right join table_b as B on A.pk=B.pk
where A.pk IS NULL

SELECT A.pk,A.value,B.value
	FROM table_a as A
inner join table_b as B on A.pk=B.pk
where B.pk IS NULL

SELECT A.pk,A.value,B.value
	FROM table_a as A
Full outer join table_b as B on A.pk=B.pk;

SELECT A.pk,A.value,B.value
	FROM table_a as A
Full outer join table_b as B on A.pk=B.pk
where A.pk IS NULL Or B.pk IS NULL
