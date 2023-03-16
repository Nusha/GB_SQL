CREATE TABLE `shops` (
	`id` INT,
    `shopname` VARCHAR (100),
    PRIMARY KEY (id)
);

INSERT INTO `shops`
VALUES
		(1, 'Четыре лапы'),
        (2, 'Мистер Зоо'),
        (3, 'МурзиЛЛа'),
        (4, 'Кошки и собаки');

SELECT * FROM shops;

CREATE TABLE `cats` (
	`name` VARCHAR (100),
    `id` INT,
    PRIMARY KEY (id),
    shops_id INT,
    CONSTRAINT fk_cats_shops_id FOREIGN KEY (shops_id)
        REFERENCES `shops` (id)
);

INSERT INTO `cats`
VALUES
		('Murzik',1,1),
        ('Nemo',2,2),
        ('Vicont',3,1),
        ('Zuza',4,3);

SELECT * FROM cats;

SELECT * FROM shops
JOIN cats C ON shops.id = C.shops_id;

-- Задание 1:

-- 1.1 Вывести всех котиков по магазинам по id (условие соединения shops.id = cats.shops_id);
SELECT shops.id AS 'ID маг.', shopname AS 'Магазин', name AS 'Котик' FROM shops
JOIN cats C ON shops.id = C.shops_id;

-- 1.2 Вывести магазин, в котором продается кот “Мурзик” (попробуйте выполнить 2 способами);
-- 1 способ;
SELECT shops.id AS 'ID маг.', shopname AS 'Мурзик_продается_в_магазине_решение_1' FROM shops
JOIN cats C ON shops.id = C.shops_id
WHERE name = 'Murzik';

-- 2 способ;
SELECT shops.id AS 'ID маг.', shopname AS 'Мурзик_продается_в_магазине_решение_2' FROM shops
JOIN cats C ON shops.id = C.shops_id
WHERE name IN ('Murzik');

-- 3 способ;
SELECT shops.id AS 'ID маг.', shopname AS 'Мурзик_продается_в_магазине_решение_3' FROM shops
JOIN cats C ON shops.id = C.shops_id
WHERE name LIKE 'Murzik';

-- 1.3 Вывести магазины, в котором НЕ продаются коты “Мурзик” и “Zuza”
-- 1 способ;
SELECT shopname AS 'Мурзик_и_Zuza_не_продаются_в_магазинах_1' FROM shops
LEFT JOIN cats C ON shops.id = C.shops_id AND name IN ('Murzik', 'Zuza')
where name IS NULL;

-- 2 способ, возможно перегруженный;
SELECT DISTINCT shopname AS 'Мурзик_и_Zuza_не_продаются_в_магазинах_2' FROM shops
LEFT JOIN cats C ON shops.id = C.shops_id
WHERE name NOT IN ('Murzik', 'Zuza') AND shopname NOT IN (SELECT DISTINCT shopname FROM shops LEFT JOIN cats C2
    ON shops.id = C2.shops_id WHERE name ='Murzik' OR name = 'Zuza') OR name IS NULL;

-- Задание 2.

CREATE DATABASE homework_4;
USE homework_4;

CREATE TABLE analysis
(
	an_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	an_name varchar(50),
	an_cost INT,
	an_price INT,
	an_group INT
);

INSERT INTO analysis (an_name, an_cost, an_price, an_group)
VALUES
	('Общий анализ крови', 30, 50, 1),
	('Биохимия крови', 150, 210, 1),
	('Анализ крови на глюкозу', 110, 130, 1),
	('Общий анализ мочи', 25, 40, 2),
	('Общий анализ кала', 35, 50, 2),
	('Общий анализ мочи', 25, 40, 2),
	('Тест на COVID-19', 160, 210, 3);

CREATE TABLE groupsan
(
	gr_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	gr_name varchar(50),
	gr_temp FLOAT(5,1),
	FOREIGN KEY (gr_id) REFERENCES Analysis (an_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO groupsan (gr_name, gr_temp)
VALUES
	('Анализы крови', -12.2),
	('Общие анализы', -20.0),
	('ПЦР-диагностика', -20.5);

CREATE TABLE orders
(
	ord_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	ord_datetime DATETIME,	-- 'YYYY-MM-DD hh:mm:ss'
	ord_an INT,
	FOREIGN KEY (ord_an) REFERENCES analysis (an_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO orders (ord_datetime, ord_an)
VALUES
	('2020-02-04 07:15:25', 1),
	('2020-02-04 07:20:50', 2),
	('2020-02-04 07:30:04', 1),
	('2020-02-04 07:40:57', 1),
	('2020-02-05 07:05:14', 1),
	('2020-02-05 07:15:15', 3),
	('2020-02-05 07:30:49', 3),
	('2020-02-06 07:10:10', 2),
	('2020-02-06 07:20:38', 2),
	('2020-02-06 11:35:38', 4), -- **************
    ('2020-02-06 11:36:38', 5), -- здесь я добавил анализы, которые отличаются по группе
    ('2020-02-06 12:37:38', 6), -- т.к. по предоставленной таблице отображаются только
    ('2020-02-06 13:38:38', 7), -- 3 анализа крови, относящиеся к одной группе;
    ('2020-02-06 14:39:38', 5),
    ('2020-02-06 15:40:38', 7),
    ('2020-02-06 15:41:38', 6), -- **************
	('2020-02-07 07:05:09', 1),
	('2020-02-07 07:10:54', 1),
	('2020-02-07 07:15:25', 1),
	('2020-02-08 07:05:44', 1),
	('2020-02-08 07:10:39', 2),
	('2020-02-08 07:20:36', 1),
	('2020-02-08 07:25:26', 3),
	('2020-02-09 07:05:06', 1),
	('2020-02-09 07:10:34', 1),
	('2020-02-09 07:20:19', 2),
	('2020-02-10 07:05:55', 3),
	('2020-02-10 07:15:08', 3),
	('2020-02-10 07:25:07', 1),
	('2020-02-11 07:05:33', 1),
	('2020-02-11 07:10:32', 2),
	('2020-02-11 07:20:17', 3),
	('2020-02-12 07:05:36', 1),
	('2020-02-12 07:10:54', 2),
	('2020-02-12 07:20:19', 3),
	('2020-02-12 07:35:38', 1);


SELECT ord_id AS 'Номер заказа', ord_datetime AS 'Дата / время', an_name AS 'Название анализа', an_cost AS 'Себестоимость',
an_price AS 'Розничная цена', gr_name AS 'Группа анализов', gr_temp AS 'Температура хранения'
FROM orders
LEFT JOIN analysis A ON A.an_id = orders.ord_an
LEFT JOIN groupsan on an_group = gr_id
WHERE ord_datetime BETWEEN '2020-02-05' AND date_add('2020-02-05', INTERVAL 7 DAY);

-- А здесь посчитали сколько заработали;
SELECT ord_id AS 'Номер заказа', ord_datetime AS 'Дата / время', an_name AS 'Название анализа', an_cost AS 'Себестоимость',
an_price AS 'Розничная цена', an_price - an_cost AS 'Прибыль', gr_name AS 'Группа анализов', gr_temp AS 'Температура хранения'
FROM orders
LEFT JOIN analysis A ON A.an_id = orders.ord_an
LEFT JOIN groupsan on an_group = gr_id
WHERE ord_datetime BETWEEN '2020-02-05' AND date_add('2020-02-05', INTERVAL 7 DAY);