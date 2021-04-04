/*
-- 生徒
create table students (
  id        integer    primary key
, name      text       not null
, gender    char(1)    not null
, class     text       not null
);

insert into students (id, name, gender, class)
values (201, 'さくら ももこ'  , 'F', '3-4')
     , (202, 'はなわ かずひこ', 'M', '3-4')
     , (203, 'ほなみ たまえ'  , 'F', '3-4')
     , (204, 'まるお すえお'  , 'M', '3-4')
;

-- テストの点数
create table test_scores (
  student_id  integer  not null references students(id)
, subject     text     not null  -- 教科（国語、算数、理科、社会）
, score       integer  not null  -- 点数
, primary key (student_id, subject)
);

insert into test_scores (student_id, subject, score)
values -- まるこ
       (201, '国語',  60)
     , (201, '算数',  40)
     , (201, '理科',  40)
     , (201, '社会',  50)
       -- はなわくん
     , (202, '国語',  60)
     , (202, '算数',  70)
     , (202, '理科',  50)
     , (202, '社会',  70)
       -- たまちゃん
     , (203, '国語',  80)
     , (203, '算数',  80)
     , (203, '理科',  70)
     , (203, '社会', 100)
       -- まるおくん
     , (204, '国語',  80)
     , (204, '算数',  90)
     , (204, '理科', 100)
     , (204, '社会', 100)
;
*/

-- サブクエリは SQL を別の SQL の一部として使う機能
-- select * from members where height > (select avg(height) from members) order by id;

-- 単一値(スカラー値)のかわりとなるサブクエリ
-- 国語の最高点
-- select max(score) from test_scores where subject = '国語'; -- 80

-- 国語の最高点を取った生徒のIDと点数
-- select t.student_id, t.score from test_scores t where t.subject = '国語' and t.score = (select max(score) from test_scores where subject = '国語') order by t.student_id;
/*
 student_id | score
------------+-------
        203 |    80
        204 |    80
(2 rows)
*/

-- 複合値のかわりのサブクエリ
-- select subject,max(score) from test_scores where subject = '国語' group by subject;
/*
 subject | max
---------+-----
 国語    |  80
(1 row)
*/

-- 国語の最高点を取った生徒のIDと点数
-- subject = '国語' and score = 80 のかわりに (subject, score) = ('国語', 80) の複合値を使用
-- select t.student_id, t.score from test_scores t where (t.subject, t.score) = (select subject, max(score) from test_scores where subject = '国語' group by subject) order by t.student_id;
/*
 student_id | score
------------+-------
        203 |    80
        204 |    80
(2 rows)
*/

-- このケースだとサブクエリを使わない書き方の方が簡潔
-- select '国語', max(score) from  test_scores where  subject = '国語';

-- 単一列複数行の実行結果を in 演算子に指定するサブクエリ
-- select student_id from test_scores where  score = 100;
/*
 student_id
------------
        203
        204
        204
(3 rows)
*/

-- どれかの教科で100点を取った生徒をすべて表示
-- select s.* from students s where s.id in (select student_id from test_scores where  score = 100) order by s.id;
/*
 id  |     name      | gender | class
-----+---------------+--------+-------
 203 | ほなみ たまえ | F      | 3-4
 204 | まるお すえお | M      | 3-4
(2 rows)
*/

-- 複数行複数列の実行結果をテーブル代わりのサブクエリとして使用
-- select subject, avg(score) as avg_score from test_scores group by subject;
/*
 subject |      avg_score
---------+---------------------
 理科    | 65.0000000000000000
 国語    | 70.0000000000000000
 社会    | 80.0000000000000000
 算数    | 70.0000000000000000
(4 rows)
*/

-- 平均点が70点に満たない教科とその平均点を検索
-- サブクエリに別名が必要(今回だと x)
-- 複数行複数列を返すサブクエリはテーブルの代わりとして使える、このように扱うサブクエリは「導出テーブル(Derived table)」という
-- select x.subject, x.avg_score from (select subject, avg(score) as avg_score from test_scores group by subject) x where x.avg_score < 70;
/*
 subject |      avg_score
---------+---------------------
 理科    | 65.0000000000000000
(1 row)
*/

-- 今回のケースだと having でも同じことが実現できる
-- select subject, avg(score) avg_score from test_scores group by subject having avg(score) < 70;
/*
 subject |      avg_score
---------+---------------------
 理科    | 65.0000000000000000
(1 row)
*/

-- サブクエリを入れ子にすることも可能
-- 国語で最高点を取った生徒をすべて検索
-- select max(score) from test_scores where subject = '国語'; -- 80
-- select student_id from test_scores where subject = '国語' and score = 80; -- 203,204
-- select * from students where id in (203,204) order by id;

/*
select *
from students
where id in (
    select student_id
    from test_scores
    where subject = '国語'
      and score = (
        select max(score)
        from test_scores
        where subject = '国語'
    )
)
order by id;
*/

-- exists 演算子は受け取ったサブクエリに結果があるかを確認する
-- 条件に合う行があるかを調べるケースはかなりある
-- ex.) この顧客は過去に商品を購入したことがあるか、一ヶ月以内にログインしたか など
-- select * from test_scores where subject = '社会' and score = 100;
/*
 student_id | subject | score
------------+---------+-------
        203 | 社会    |   100
        204 | 社会    |   100
(2 rows)
*/

-- select exists (select * from test_scores where subject = '社会' and score = 100);
/*
 exists
--------
 t
(1 row)
*/

-- count で調べると、行の数が0であるかを調べるために、全ての行を調べるため実行効率が悪い
-- exists の場合、一行でも見つかればそこで検索を終了し、 true を返す
-- select count(*) from test_scores where subject = '社会' and score = 100;

-- exists 演算子はサブクエリの返す行の中身を見ずに、行が返されたかしかみないため、 * でも 1 でも実行結果は同じ
-- 1 はサブクエリの中身が使われないことを示唆する書き方の慣習
-- select exists (select 1 from test_scores where subject = '社会' and score = 100);

-- all 演算子は、サブクエリが返した値が全て条件に合っているかを確認
-- 算数の点数が全員 40点以上なら true
-- select 40 <= all (select score from test_scores where subject = '算数');
/*
 ?column?
----------
 t
(1 row)
*/

-- any は条件に合うものがサブクエリ内にあるか調べる
-- select 100 <= any (select score from test_scores where subject = '算数');
/*
 ?column?
----------
 f
(1 row)
*/

-- 算数で100点をとっている人はいない
-- select * from test_scores where subject = '算数';
/*
 student_id | subject | score
------------+---------+-------
        201 | 算数    |    40
        202 | 算数    |    70
        203 | 算数    |    80
        204 | 算数    |    90
(4 rows)
*/

-- exists でも書ける
-- select exists(select 1 from test_scores where subject = '算数' and score = 100);

-- with 句(Common Table Expression,CTE) を使うと、サブクエリに別名をつけられる
-- 平均点が70点に満たない教科とその平均点を検索
/*
select x.subject, x.avg_score
from (
         select subject, avg(score) as avg_score
         from test_scores
         group by subject
     ) x
where x.avg_score < 70;
*/

/*
-- with を使ってサブクエリに別名を設定
with x as (select subject, avg(score) as avg_score
from test_scores
group by subject)
select x.subject, x.avg_score from x where x.avg_score < 70;
*/

-- 列名にも別名をつけることで、with 句の先頭行を見るだけで列名がわかる
/*
with x(subject, avg_score) as (
    select subject, avg(score)
    from test_scores
    group by subject
)
select x.subject, x.avg_score
from x
where x.avg_score < 70;
*/

-- 国語で最高点を取った生徒のIDと点数を検索
/*
with x(max_score) as (
    select max(score)
    from test_scores
    where subject = '国語'
)

select t.student_id, t.score
from test_scores t
where t.subject = '国語'
  -- with はサブクエリに別名をつける機能なので、 t.score = x.max_score のように代入は不可
  and t.score = (select x.max_score from x)
order by t.student_id;
*/

-- 多段のサブクエリを with によりリファクタリング(機能は同じままにコードを書き換えること)する
-- 国語で最高点を取った生徒を全て検索
/*
select *
from students
where id in (
    select student_id
    from test_scores
    where subject = '国語'
      and score = (
        select max(score)
        from test_scores
        where subject = '国語'
    )
);
*/

-- 前のサブクエリの結果を後ろのサブクエリで利用できる
-- サブクエリに名前がついており、SQL の入れ子がなくなったため理解しやすい
/*
with max_score(value) as (
    select max(score)
    from test_scores
    where subject = '国語'
),
     targets(student_id) as (
         select student_id
         from test_scores
         where subject = '国語'
           and score = (select value from max_score)
     )
select * from students where id in (select student_id from targets) order by id;
*/

-- サブクエリを一時テーブルとみなす
-- with 句はサブクエリの結果を一時テーブルに格納する(=実体化,Materialize)
-- 平均点が一番低い教科を平均点付きで表示
/*
with avg_scores(subject, avg_score) as (
    select subject, avg(score)
    from test_scores
    group by subject
)

-- from と where で二回、サブクエリ avg_scores が登場する
-- with 句を使わない場合、同じサブクエリを2回書かないといけない
select subject, avg_score
from avg_scores
where avg_score = (select min(x.avg_score) from avg_scores x
);
*/

-- with 句のサブクエリはサブクエリ外にある条件式に影響を受けない
-- = with 句のサブクエリの外にある条件式によりサブクエリが最適化されることはない
-- with を使用しない場合は最適化が行われる
/*
-- 2. サブクエリの結果をそのまま出力していることになるので、サブクエリにしないよう最適化される
-- select t.student_id, t.max_score from (
    slect student_id, max(score) as max_score
    from test_scores
    where student_id = 201;
    group by student_id
-- ) t;
-- 1. サブクエリ外の条件式がサブクエリの最適化に使われる
-- where student_id = 201;
*/

-- with 句の有り無しでパフォーマンスを試してみて、最適化が効かない場合は with 句を外す
-- 基本的には with 句を使っている方がわかりやすい



/*
drop table test_scores;
drop table students;
*/
