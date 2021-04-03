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

-- SELECT * FROM members;

-- 文字列を出力
-- SELECT 'Hello';
-- SELECT 123, '123', 'ABC';

-- 計算式を指定
-- SELECT 1 + 2 + 3 + 4;

-- 列(Column)名を指定
-- SELECT gender, name FROM members;
-- SELECT gender, name FROM members WHERE name = 'ミカサ';
-- SELECT * FROM members WHERE height >= 170;

-- and(かつ)
-- SELECT * FROM members WHERE gender = 'M' and height >= 170;

-- or(または)
-- 性別が男か、身長が170cm以上の行がヒット
-- SELECT * FROM members WHERE gender = 'M' or height >= 170;

-- and で繋げた条件式を or で組み合わせる　
-- SELECT * FROM members WHERE (gender = 'M' and height >= 170) or (gender = 'F' and height < 170);

-- id が小さい順に整列
-- テーブルには行の順番がない(集合のため)ので、 SELECT には必ず order by をつける
-- SELECT * FROM members ORDER BY id;

-- 順番を逆にする時は desc(desending=下降する)
-- id が大きい順に並べる
-- SELECT * FROM members ORDER BY id DESC;

-- 身長が同じ場合はそれらの行はどちらが上に来るかは確定しないため、複数の条件を使う
-- 身長の高い順に並べ、同じ身長であれば id の小さい順に並べる(ASC=ascending は省略可能)
-- SELECT * FROM members ORDER BY height DESC, id ASC;

-- 先頭から2件
-- 並び替える時は重複しない値を使う！！！
-- SELECT * FROM members ORDER BY id LIMIT 2;

-- 先頭からの4行は出力しない
-- SELECT * FROM members ORDER BY id OFFSET 4;

-- offset でスキップしてから、 limit で限定
-- SELECT * FROM members ORDER BY id LIMIT 1 OFFSET 3;

-- 男子の背の低い順で2,3番目のメンバー
-- SELECT id, name, height FROM members WHERE gender = 'M' ORDER BY height LIMIT 2 OFFSET 1;

-- データベースエンジン内での SQL の実行順序
-- select 句は最後に実行され、それ以外は上から順に実行されるイメージ
-- ※実際は、 select は order by より前に実行されるが、一旦は上記のイメージ
-- select id, name from members order by height; が実行できることの説明を容易にするため
/*
SELECT id, name, height     <- 最後
    FROM members            <- 1番目 
    WHERE gender = 'M'      <- 2番目
    ORDER BY height         <- 3番目 
    LIMIT 2 OFFSET 1;       <- 4番目
*/

-- SQL は集合への操作、データの加工や変形を行っている

-- 身長の高い順に3件
-- SELECT height, name FROM members WHERE gender = 'M' ORDER BY height DESC LIMIT 3;

-- 一番身長が低い
-- SELECT * FROM members ORDER BY height LIMIT 1;

-- 2番目に身長が低い
-- SELECT * FROM members ORDER BY height LIMIT 1 OFFSET 1;

-- 男女に分けて(男が先)、ID順に並び替える
-- まず男女に分けて、それをID順に並び替える
-- F,M だと F が先に来るので、 DESC
-- 男女に分ける = 性別で並び替える と業務用件の言葉を実装技術の言葉に置き換えられるかが重要
-- SELECT * FROM members ORDER BY gender DESC, id;
/*
 id  |   name   | height | gender
-----+----------+--------+--------
 101 | エレン   |    170 | M
 103 | アルミン |    163 | M
 104 | ジャン   |    175 | M
 106 | コニー   |    158 | M
 102 | ミカサ   |    170 | F
 105 | サシャ   |    168 | F
(6 rows)
*/

-- 身長を高い順に並べ、1ページ目に10名表示する
-- OFFSET 1 とすると先頭から一行をスキップし、一番背が高い列をスキップしてしまう(OFFSET 自体省略可能)
-- 身長が同じレコードがあった場合、並び替えの順番が不安定になるため、値が重複しない列を order by 句に追加する必要があるため、 id も追加
-- SELECT * FROM members ORDER BY height DESC, id LIMIT 10 OFFSET 0;

-- 11 ~ 20 件目を表示
-- SELECT * FROM members ORDER BY height DESC, id LIMIT 10 OFFSET 10;

/*
drop table members;
*/