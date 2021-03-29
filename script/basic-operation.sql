
-- テーブルの作成
-- CREATE TABLE testtable1 ( id INTEGER PRIMARY KEY, name text not null UNIQUE, age INTEGER );

-- テーブルの一覧(シェルにて実行)
-- # psql -U postgres wakarimi -c '\dt'
--            List of relations
--  Schema |    Name    | Type  |  Owner
-- --------+------------+-------+----------
--  public | testtable1 | table | postgres

-- テーブルの詳細(シェルにて実行)
-- # psql -U postgres wakarimi -c '\d testtable1'
--              Table "public.testtable1"
--  Column |  Type   | Collation | Nullable | Default
-- --------+---------+-----------+----------+---------
--  id     | integer |           | not null |
--  name   | text    |           | not null |
--  age    | integer |           |          |
-- Indexes:
--     "testtable1_pkey" PRIMARY KEY, btree (id)
--     "testtable1_name_key" UNIQUE CONSTRAINT, btree (name)

-- 行(Row)の登録
-- INSERT INTO testtable1(id, name, age) VALUES(101,'Alice',20);
-- INSERT INTO testtable1(id, name, age) VALUES(102,'Bob',25);
-- INSERT INTO testtable1(id, name, age) VALUES(103,'Cathy',22);

-- SELECT * FROM testtable1;

-- 行の削除
-- DELETE FROM "public"."testtable1" WHERE "id"=101 OR "id"=102 OR "id"=103;

-- Bulk insert
-- INSERT INTO testtable1(id, name, age) VALUES(101,'Alice',20),(102,'Bob',25),(103,'Cathy',22);

-- 削除
-- DELETE FROM testtable1 WHERE id IN(101,102,103);

-- 全件更新(条件を指定しなければすべての行が更新される)
-- UPDATE testtable1 SET age = age + 1;
-- SELECT * FROM testtable1;

-- 1件だけ更新
-- UPDATE testtable1 SET age = 27 WHERE name = 'Bob';

-- 行の並び順は保持されない(RDBではテーブルは行の集合であり、リストではないため)
-- リストは順番を保持し、重複を許す
-- 集合は順番を保持せず、重複を許さない
-- SELECT * FROM testtable1;

-- 検索する時に行の並び方を指定する
-- SELECT * FROM testtable1 ORDER BY name;

-- 複数の列(Column)を更新
-- UPDATE testtable1 SET age = 28, name='Bill' WHERE name = 'Bob';

-- 行を1件削除
-- DELETE FROM testtable1 WHERE name = 'Bill';
-- SELECT count(*) FROM testtable1;

-- 行を全削除
-- DELETE FROM testtable1;
-- SELECT count(*) FROM testtable1;

-- テーブルを削除
-- DROP TABLE testtable1;

-- テーブルの一覧(シェルにて実行)
-- # psql -U postgres wakarimi -c '\dt'
-- Did not find any relations.
