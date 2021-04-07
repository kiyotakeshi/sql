-- Foregin key(外部キー) は他テーブルの主キーを参照している列のこと
-- 参照先のテーブルにない値を外部キーに入れようとした時、すでに外から参照されている主キーを変更しようとした時エラーになる
/*
create table characters (
  id          integer    primary key
, movie_id    integer    references movies(movie_id)
, name        text       not null
, gender      char(1)    not null
);
*/

-- テーブル定義の確認
/*
wakarimi=# \d characters
                Table "public.characters"
  Column  |     Type     | Collation | Nullable | Default
----------+--------------+-----------+----------+---------
 id       | integer      |           | not null |
 movie_id | integer      |           |          |
 name     | text         |           | not null |
 gender   | character(1) |           | not null |
Indexes:
    "characters_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "characters_movie_id_fkey" FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
*/

-- 複数の列から構成された主キーは、複合主キー(Composite primary key) という
-- それを参照する外部キーは、複合外部キーという

-- NOT NULL 制約とは
-- => ある列に対して null が入ることを禁止する制約

-- 一意制約とは
-- => ある列の値が重複することを禁止する制約(アカウント名、都道府県名など)

-- 主キーとは
-- => あるテーブルにおいて、行を特定するための列のこと、 null でなく、重複せず、値が変わらないことが特徴

-- 外部キーとは
-- => 他のテーブルの主キーを参照するための列、参照先にある値しか入れられず、参照している値は変更できない
