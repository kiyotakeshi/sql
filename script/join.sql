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

-- from 句に複数のテーブルを指定すると、すべての行の組み合わせが得られる
-- movie table, characters table の行数を掛け算した組み合わせの件数が出力される
-- select movies.*, characters.* from movies, characters;
/*
 movie_id |      title       | id  | movie_id |   name   | gender
----------+------------------+-----+----------+----------+--------
       93 | 風の谷のナウシカ | 401 |       93 | ナウシカ | F
       93 | 風の谷のナウシカ | 402 |       94 | パズー   | M
       93 | 風の谷のナウシカ | 403 |       94 | シータ   | F
       93 | 風の谷のナウシカ | 404 |       94 | ムスカ   | M
       93 | 風の谷のナウシカ | 405 |       95 | さつき   | F
       93 | 風の谷のナウシカ | 406 |       95 | メイ     | F
       93 | 風の谷のナウシカ | 407 |          | クラリス | F
       94 | 天空の城ラピュタ | 401 |       93 | ナウシカ | F
       94 | 天空の城ラピュタ | 402 |       94 | パズー   | M
       94 | 天空の城ラピュタ | 403 |       94 | シータ   | F
       94 | 天空の城ラピュタ | 404 |       94 | ムスカ   | M
       94 | 天空の城ラピュタ | 405 |       95 | さつき   | F
       94 | 天空の城ラピュタ | 406 |       95 | メイ     | F
       94 | 天空の城ラピュタ | 407 |          | クラリス | F
       95 | となりのトトロ   | 401 |       93 | ナウシカ | F
       95 | となりのトトロ   | 402 |       94 | パズー   | M
       95 | となりのトトロ   | 403 |       94 | シータ   | F
       95 | となりのトトロ   | 404 |       94 | ムスカ   | M
       95 | となりのトトロ   | 405 |       95 | さつき   | F
       95 | となりのトトロ   | 406 |       95 | メイ     | F
       95 | となりのトトロ   | 407 |          | クラリス | F
       96 | 崖の上のポニョ   | 401 |       93 | ナウシカ | F
       96 | 崖の上のポニョ   | 402 |       94 | パズー   | M
       96 | 崖の上のポニョ   | 403 |       94 | シータ   | F
       96 | 崖の上のポニョ   | 404 |       94 | ムスカ   | M
       96 | 崖の上のポニョ   | 405 |       95 | さつき   | F
       96 | 崖の上のポニョ   | 406 |       95 | メイ     | F
       96 | 崖の上のポニョ   | 407 |          | クラリス | F
(28 rows)
*/

-- すべての組み合わせから movie_id が一致する組み合わせだけを選ぶと、映画とキャラクターの正しい組み合わせが得られる
-- これが SQL での結合
-- select movies.*, characters.* from movies, characters where movies.movie_id = characters.movie_id;
/*
 movie_id |      title       | id  | movie_id |   name   | gender
----------+------------------+-----+----------+----------+--------
       93 | 風の谷のナウシカ | 401 |       93 | ナウシカ | F
       94 | 天空の城ラピュタ | 402 |       94 | パズー   | M
       94 | 天空の城ラピュタ | 403 |       94 | シータ   | F
       94 | 天空の城ラピュタ | 404 |       94 | ムスカ   | M
       95 | となりのトトロ   | 405 |       95 | さつき   | F
       95 | となりのトトロ   | 406 |       95 | メイ     | F
(6 rows)
*/

-- 複数のテーブルを結合する際は、テーブル名に短い別名をつけると読み書きしやすい
-- select m.*, c.* from movies m, characters c where m.movie_id = c.movie_id;

-- SQL での結合は二つの操作に分けられる
-- 1. すべての組み合わせを生成
-- 2. 条件に合った組み合わせだけを選ぶ


-- 映画テーブルとキャラクターテーブルを結合し、女性キャラクターのみ選ぶ
-- where 句にテーブルの結合条件と行の選択条件が入っている(内部の仕組みとしてはどちらも行の選択)
-- select m.*, c.* from movies m, characters c where m.movie_id = c.movie_id and c.gender = 'F';

-- where 句の複数の条件の中からテーブルの結合条件を探すのは面倒
-- テーブルの結合条件を where 句から分離できる join 演算子がある
-- from と where に散りばめられていた、テーブル結合の指定が join 演算子にまとめられた
-- join は演算子なので、 from A join B は A join B の結果を from 句に指定している
/*
select *
from movies m
         join characters c -- 結合するテーブル
              on m.movie_id = c.movie_id -- テーブルの結合条件を指定
where c.gender = 'F';
*/

/*
 movie_id |      title       | id  | movie_id |   name   | gender
----------+------------------+-----+----------+----------+--------
       93 | 風の谷のナウシカ | 401 |       93 | ナウシカ | F
       94 | 天空の城ラピュタ | 403 |       94 | シータ   | F
       95 | となりのトトロ   | 405 |       95 | さつき   | F
       95 | となりのトトロ   | 406 |       95 | メイ     | F
(4 rows)
*/


-- 映画の一覧を、キャラクター名付きで表示する場合、映画の一覧が主役で、キャラクター名はその補助
/*
select c.*, m.*
from characters c -- 主役となるテーブルを指定
         join movies m on c.movie_id = m.movie_id
where m.title = 'となりのトトロ' -- 結合することで別のテーブル(movies)を検索条件として利用できる
order by c.id;
*/

-- キャラクターの一覧を映画のタイトルとともに表示する
/*
select c.*, m.title
from characters c -- キャラクターの一覧が主役
         join movies m on c.movie_id = m.movie_id
order by c.id;
*/

-- 以下のように from を映画にしても結果は変わらないが、
-- テーブルの役割がわかった方が人間が読みやすいので、主役と補助の関係を意識する
/*
select c.*, m.title
from movies m
         join characters c on m.movie_id = c.movie_id
order by m.movie_id;
*/

-- 「別のテーブルを検索に利用する」結合の使い方はサブクエリを使用しても可能
/*
select c.*, m.*
from characters c
         join movies m on c.movie_id = m.movie_id
where m.title = 'となりのトトロ' 
order by c.id;
*/

/*
select c.*
from characters c
where c.movie_id in (
    select m.movie_id
    from movies m
    where m.title = 'となりのトトロ'
)
order by c.id;
*/

-- using を使用すると join の on を書き換え可能
/*
select c.*, m.*
from characters c
         join movies m
              -- on c.movie_id = m.movie_id
              using (movie_id)
order by c.id;
*/

-- 複数の列名を使って結合する時はより簡潔にかけるため using をつかう
/*
select e.*, d.* from employee e
       join departments d using (companny_id, department_id)
order by e.id;
*/

-- テーブルには存在するのに、結合すると表示されないデータが出てくる
-- select * from movies order by movie_id;
/*
 movie_id |      title
----------+------------------
       93 | 風の谷のナウシカ
       94 | 天空の城ラピュタ
       95 | となりのトトロ
       96 | 崖の上のポニョ
(4 rows)
*/

-- select * from characters order by id;
/*
 id  | movie_id |   name   | gender
-----+----------+----------+--------
 401 |       93 | ナウシカ | F
 402 |       94 | パズー   | M
 403 |       94 | シータ   | F
 404 |       94 | ムスカ   | M
 405 |       95 | さつき   | F
 406 |       95 | メイ     | F
 407 |          | クラリス | F
(7 rows)
*/

-- 崖の上のポニュ(96) と クラリス(407) が表示されていない
-- characters table にポニュのキャラが登録されていない、クラリスが出演した映画の情報が登録されていない
-- inner join を省略
-- select m.*, c.* from movies m join characters c using(movie_id) order by m.movie_id, c.id;
/*
 movie_id |      title       | id  | movie_id |   name   | gender
----------+------------------+-----+----------+----------+--------
       93 | 風の谷のナウシカ | 401 |       93 | ナウシカ | F
       94 | 天空の城ラピュタ | 402 |       94 | パズー   | M
       94 | 天空の城ラピュタ | 403 |       94 | シータ   | F
       94 | 天空の城ラピュタ | 404 |       94 | ムスカ   | M
       95 | となりのトトロ   | 405 |       95 | さつき   | F
       95 | となりのトトロ   | 406 |       95 | メイ     | F
(6 rows)
*/

-- 「映画の一覧を表示」したいから、キャラクターが登録されていない映画も表示する
-- left outer join を省略
-- select m.*, c.* from movies m left join characters c using(movie_id) order by m.movie_id, c.id;
/*
 movie_id |      title       | id  | movie_id |   name   | gender
----------+------------------+-----+----------+----------+--------
       93 | 風の谷のナウシカ | 401 |       93 | ナウシカ | F
       94 | 天空の城ラピュタ | 402 |       94 | パズー   | M
       94 | 天空の城ラピュタ | 403 |       94 | シータ   | F
       94 | 天空の城ラピュタ | 404 |       94 | ムスカ   | M
       95 | となりのトトロ   | 405 |       95 | さつき   | F
       95 | となりのトトロ   | 406 |       95 | メイ     | F
       96 | 崖の上のポニョ   |     |          |          |
(7 rows)
*/

-- キャラクターの一覧を映画付きで表示(キャラクターが登録されていない映画も表示)
-- select c.*, m.title from characters c right join movies m using(movie_id) order by c.id;
/*
 id  | movie_id |   name   | gender |      title
-----+----------+----------+--------+------------------
 401 |       93 | ナウシカ | F      | 風の谷のナウシカ
 402 |       94 | パズー   | M      | 天空の城ラピュタ
 403 |       94 | シータ   | F      | 天空の城ラピュタ
 404 |       94 | ムスカ   | M      | 天空の城ラピュタ
 405 |       95 | さつき   | F      | となりのトトロ
 406 |       95 | メイ     | F      | となりのトトロ
     |          |          |        | 崖の上のポニョ
(7 rows)
*/
 
-- 右側のテーブルから、クラリスが結合されている
-- select m.*, c.* from movies m right join characters c using(movie_id) order by m.movie_id, c.id;
/*
 movie_id |      title       | id  | movie_id |   name   | gender
----------+------------------+-----+----------+----------+--------
       93 | 風の谷のナウシカ | 401 |       93 | ナウシカ | F
       94 | 天空の城ラピュタ | 402 |       94 | パズー   | M
       94 | 天空の城ラピュタ | 403 |       94 | シータ   | F
       94 | 天空の城ラピュタ | 404 |       94 | ムスカ   | M
       95 | となりのトトロ   | 405 |       95 | さつき   | F
       95 | となりのトトロ   | 406 |       95 | メイ     | F
          |                  | 407 |          | クラリス | F
*/

-- 内部結合(inner join) は左右のテーブルから対応する組み合わせだけを表示
-- 左外部結合(left outer join) は対応する組み合わせに加え、対応しない行を左側のテーブルから取り出す
-- 右外部結合(right outer join) は対応する組み合わせに加え、対応しない行を右側のテーブルから取り出す
-- 完全外部結合(full outer join) は対応する組み合わせに加え、対応しない行を左右のテーブルから取り出す

-- テーブルの結合は「集合の重なり」と考えられ、重なった領域を取り出すのが、内部結合

-- 完全外部結合
/*
select m.*, c.* from movies m full outer join characters c using(movie_id) order by m.movie_id, c.id;
 movie_id |      title       | id  | movie_id |   name   | gender
----------+------------------+-----+----------+----------+--------
       93 | 風の谷のナウシカ | 401 |       93 | ナウシカ | F
       94 | 天空の城ラピュタ | 402 |       94 | パズー   | M
       94 | 天空の城ラピュタ | 403 |       94 | シータ   | F
       94 | 天空の城ラピュタ | 404 |       94 | ムスカ   | M
       95 | となりのトトロ   | 405 |       95 | さつき   | F
       95 | となりのトトロ   | 406 |       95 | メイ     | F
       96 | 崖の上のポニョ   |     |          |          |
          |                  | 407 |          | クラリス | F
(8 rows)
*/

-- クロス結合
-- 結合条件のないテーブル結合、一行だけのテーブルとの結合で使われる

/*
create table current_production (
  name        varchar(255)     primary key
, short_name  varchar(255)     not null
);

insert into current_production (name, short_name)
values ('スタジオジブリ', 'ジブリ')
;
(1 row)
*/

-- select * from current_production;
/*
      name      | short_name
----------------+------------
 スタジオジブリ | ジブリ
(1 row)
*/

-- 1行しかないテーブルのデータがすべての行につく
/*
select m.movie_id, m.title, p.name as production
from movies m
         cross join current_production p
order by m.movie_id;
*/

/*
 movie_id |      title       |   production
----------+------------------+----------------
       93 | 風の谷のナウシカ | スタジオジブリ
       94 | 天空の城ラピュタ | スタジオジブリ
       95 | となりのトトロ   | スタジオジブリ
       96 | 崖の上のポニョ   | スタジオジブリ
(4 rows)
*/

-- 内部結合を使ったフィルター
-- キャラクターが登録されている映画だけ選ぶ、映画が登録されているキャラクターを選ぶ、など

-- キャラクターの内容を表示しないことで、キャラクターが登録されている映画だけを選んでいる
-- select m.* from movies m join characters c using(movie_id) order by m.movie_id;
/*
 movie_id |      title
----------+------------------
       93 | 風の谷のナウシカ
       94 | 天空の城ラピュタ
       94 | 天空の城ラピュタ
       94 | 天空の城ラピュタ
       95 | となりのトトロ
       95 | となりのトトロ
(6 rows)
*/

-- 重複させないように、 group by を追加
-- select m.* from movies m join characters c using (movie_id) group by m.movie_id, m.title order by m.movie_id;
/*
 movie_id |      title
----------+------------------
       93 | 風の谷のナウシカ
       94 | 天空の城ラピュタ
       95 | となりのトトロ
(3 rows)
*/

-- 外部結合によるフィルター
-- 対応するものがない行だけを選べる = 対応するものがある行を取り除ける
-- 出演キャラクターのない映画だけ選ぶ
-- select m.* from movies m left join characters c using(movie_id) where c.id is null order by m.movie_id, c.id;
/*
 movie_id |     title
----------+----------------
       96 | 崖の上のポニョ
(1 row)
*/

-- 出演作が登録されていないキャラクター
-- 結合する必要はなし -- select c.id, c.name, c.gender from characters c left join movies m using (movie_id) where m.movie_id is null order by c.id;
-- select c.id, c.name, c.gender from characters c where c.movie_id is null order by c.id;

-- 映画ごとの出演キャラクター数
-- select m.movie_id, m.title, count(c.id) from movies m left join characters c using (movie_id) group by m.movie_id, m.title order by m.movie_id;

/*
 movie_id |      title       | count
----------+------------------+-------
       93 | 風の谷のナウシカ |     1
       94 | 天空の城ラピュタ |     3
       95 | となりのトトロ   |     2
       96 | 崖の上のポニョ   |     0
(4 rows)
*/
