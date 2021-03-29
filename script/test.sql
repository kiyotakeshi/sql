SELECT  current_date;

-- CREATE TABLE testtable1 ( id INTEGER PRIMARY KEY, name text not null UNIQUE, age INTEGER );

-- INSERT INTO testtable1(id, name, age) VALUES(101,'Alice',20);
-- INSERT INTO testtable1(id, name, age) VALUES(102,'Bob',25);
-- INSERT INTO testtable1(id, name, age) VALUES(103,'Cathy',22);

-- DELETE FROM "public"."testtable1" WHERE "id"=101 OR "id"=102 OR "id"=103;

-- Bulk insert
-- INSERT INTO testtable1(id, name, age) VALUES(101,'Alice',20),(102,'Bob',25),(103,'Cathy',22);

-- DELETE FROM testtable1 WHERE id IN(101,102,103);
