-- グループ化してから何らかの集計をする
-- 「性別ごとにメンバーをグループ化して、人数を数える」 など

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

-- 性別ごとにグループ化して、男女別に平均身長を出す
-- SELECT gender, avg(height) FROM members GROUP BY gender;
/*
 gender |         avg
--------+----------------------
 M      | 166.5000000000000000
 F      | 169.0000000000000000
(2 rows)
*/

-- avg() はグループから複数の値を受け取って計算する、集約関数
-- group by を使用時に select 句に使用できるのは、グループ化のキーと集約関数だけ
-- name はグループ化のキーでも集約関数でもないので select には指定できない
-- SELECT gender, to_char(avg(height), '999.99') FROM members GROUP BY gender;

-- グループ化は何らかしかのキーを使って、行をグループにする

-- 様々な集約関数を使用
-- count(*) の * は行そのものを差す(null であろうと数える)
-- group by 句がある SQL では order by 句にも、グループ化のキーか集約関数しかつかない
-- group by 句がある SQL では select, order by の対象が、行ではなくグループになるから
-- SELECT gender, max(height), min(height), sum(height), count(*), to_char(avg(height), '999.99') FROM members GROUP BY gender ORDER BY gender DESC;

-- count(height) は null でない height の数を数える
-- SELECT gender, count(height) FROM members GROUP BY gender;

-- 身長が登録されていない人数を男女別に数える
-- SELECT gender, count(*) - count(height) AS "null height" FROM members GROUP BY gender;

-- having 句を使うとグループに対して選択条件を指定できる
-- 平均身長が 168cm 以上のグループだけを表示
-- SELECT gender, avg(height) FROM members GROUP BY gender HAVING avg(height) >= 168;

/*
 gender |         avg
--------+----------------------
 F      | 169.0000000000000000
(1 row)
*/

-- 人数が3人以上のグループだけを表示
-- SELECT gender, count(*) FROM members GROUP BY gender HAVING count(*) >= 3;

-- where 句はテーブルの行を対象にし、条件に合った行のみが選択される
-- where は group by の前に実行し、グループ化される前に実行されるので、対象は行

-- having 句はグループを対象とし、条件に合ったグループだけが選択される

-- group by でグループ化された後は、グループが操作対象となる
-- SELECT gender, avg(height) FROM members WHERE height >= 165 GROUP BY gender HAVING count(*) >= 2 ORDER BY gender LIMIT 2 OFFSET 0;

-- グループ化のキーではない列を slect で指定する方法
-- グループ化のキーに主キーを使用する
-- 主キーは null ではなく、重複しない値のため、主キーが決まれば行を特定できる
-- テーブル結合の際に主キーによるグループ化は意味を持つ
-- SELECT id, name, height FROM members GROUP BY id;

-- グループ名のキーには式も利用可能
-- 名前の長さでグループ化し、それぞれの人数を数える
-- SELECT length(name), count(*) FROM members GROUP BY length(name);

-- 集計関数は group by がなくても使用可能(すべての行が一つのグループにグループ化されて実行)
-- SELECT max(height), min(height) FROM members;
-- SELECT count(*) FROM members WHERE gender = 'M';

-- 人数と平均身長を男女別に集計
-- SELECT gender, count(*), avg(height) FROM members GROUP BY gender;

-- 最高身長、最低身長とその差を男女別に集計
-- 1行目が男子になるように
-- SELECT gender, max(height), min(height) ,max(height) - min(height) FROM members GROUP BY gender ORDER BY gender DESC;

-- 男子の人数
-- グループ化した後に having によりグループをフィルタ
-- SELECT gender, count(*) FROM members GROUP BY gender HAVING gender = 'M';

-- 女子の人数を集計する必要がない場合は、 where でフィルタする方が高速に実行できる
-- SELECT count(*) FROM members WHERE gender = 'M';

-- 集計関数の結果を where 句で使えないのは、
-- 集計関数を使うには group by によるグループ化が必要だが、 where はグループ化の前に実行されるため
-- select ... from ... where ...(集計関数を使えない) group by ...(ここでグループ化しないと集計関数を使えない) order by ...,

/*
drop table members;
*/
