/*
create table members (
    id      integer     primary key
, name    text        not null
, height  integer     not null
, gender  char(1)     not null
);
*/

/*
insert into members(id, name, height, gender)
values (101, 'エレン',   170, 'M')
        , (102, 'ミカサ',   170, 'F')
        , (103, 'アルミン', 163, 'M')
        , (104, 'ジャン',   175, 'M')
        , (105, 'サシャ',   168, 'F')
        , (106, 'コニー',   158, 'M');
*/

-- 列名 as 別名の as は省略可能
-- 大文字を区別するにはダブルクォートで囲む
-- SELECT id AS "ID", name AS 名前, height 身長 FROM members WHERE gender = 'F';

-- テーブルに別名をつけ、列名の接頭辞として使う
-- members m でもよい
-- SELECT m.id, m.name, m.height FROM members AS m WHERE m.gender = 'F';

--  別名をつけずに、テーブル名を接頭辞としてつけることも可能
-- SELECT members.id, members.name, members.height FROM members WHERE members.gender = 'F';

-- 別名を列名の接頭辞とすることで、 SQL の予約語と同じ列にアクセスできる

-- 列名の別名は where では使用できないが、 order by には使用できる
-- SELECT name as 名前, gender as 性別 FROM members WHERE gender = 'F' ORDER BY 名前;

-- テーブルの別名は where で使用できる
-- SELECT m.name, m.gender FROM members m WHERE m.gender = 'F' ORDER BY m.id;

-- select 文が一番最後に実行されるため、 select で指定する列名の別名は where で使用できない

-- 文字列の結合 |
-- SELECT 'hello, ' || 'world' || '!';

-- o で終わる
-- SELECT 'hello' LIKE '%o';

-- h で始まる
-- SELECT 'hello' LIKE 'h%';

-- _ は任意の一文字にマッチ
-- SELECT 'hello' LIKE 'he__o';

-- l が2回含まれる
-- SELECT 'hello' LIKE '%l%l%';

-- ン で終わる名前
-- SELECT name FROM members WHERE name LIKE '%ン';

-- 列挙した中に指定値が含まれるか
-- SELECT 7 in (2,3,6,7);
-- SELECT 'zz' in ('xx', 'yy', 'zz');

-- SELECT 'zz' not in ('xx', 'yy');

-- SELECT name FROM members WHERE name IN('エレン', 'ミカサ', 'アルミン') ORDER BY id;

-- null は等号や > < などで比較できない
-- NullPointerException が発生しないで結果が null になるので注意
-- SELECT 0 = 0, null = null;
/*
 ?column? | ?column?
----------+----------
 t        |
(1 row)
*/

-- null かどうかを調べる
-- SELECT null is null, null is not null;
/*
 ?column? | ?column?
----------+----------
 t        | f
(1 row)
*/

-- 女子の id, 名前、身長を加工して id の小さい順に表示
-- SELECT id, name || 'さん', height || 'cm' FROM members WHERE gender = 'F' ORDER BY id;

-- 170 ~ 180cm の身長
-- SELECT * FROM members WHERE height BETWEEN 170 and 180 ORDER BY id;

-- 名前が四文字( _ が4つ)
-- SELECT name FROM members WHERE name LIKE '____';
-- SELECT name FROM members WHERE length(name) = 4;

/*
drop table members;
*/

/*
create table movies (
  movie_id    integer    primary key
, title       text       not null unique
);

insert into movies (movie_id, title)
values (93, '風の谷のナウシカ')
     , (94, '天空の城ラピュタ')
     , (95, 'となりのトトロ')
     , (96, '崖の上のポニョ')
;

-- キャラクター
create table characters (
  id          integer    primary key
, movie_id    integer    references movies(movie_id)
, name        text       not null
, gender      char(1)    not null
);

insert into characters (id, movie_id, name, gender)
values (401,   93, 'ナウシカ', 'F')
     , (402,   94, 'パズー'  , 'M')
     , (403,   94, 'シータ'  , 'F')
     , (404,   94, 'ムスカ'  , 'M')
     , (405,   95, 'さつき'  , 'F')
     , (406,   95, 'メイ'    , 'F')
     , (407, null, 'クラリス', 'F')
;
*/

-- 出演作が未登録のキャラクター
-- SELECT id, movie_id, name, gender FROM characters WHERE movie_id IS NULL;

-- 出演作が登録済みのキャラクターをID順に表示
-- SELECT id, movie_id, name, gender FROM characters WHERE movie_id IS NOT NULL ORDER BY id;

-- null を未登録に変換(整数型を文字列型に変換)
-- SELECT id,COALESCE(movie_id || '', '未登録') AS movie_id, name, gender FROM characters ORDER BY id;
-- SELECT id,COALESCE(movie_id::text, '未登録') AS movie_id, name, gender FROM characters ORDER BY id;
/*
 id  | movie_id |   name   | gender
-----+----------+----------+--------
 401 | 93       | ナウシカ | F
 402 | 94       | パズー   | M
 403 | 94       | シータ   | F
 404 | 94       | ムスカ   | M
 405 | 95       | さつき   | F
 406 | 95       | メイ     | F
 407 | 未登録   | クラリス | F
(7 rows)
*/
