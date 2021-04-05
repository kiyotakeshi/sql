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