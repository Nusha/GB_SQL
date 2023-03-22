CREATE DATABASE lesson_5;
use lesson_5;

CREATE TABLE Cars (id int AUTO_INCREMENT PRIMARY KEY, Name varchar(40) NOT NULL, Cost decimal(8,2));

INSERT Cars (Name, Cost)
VALUES ('Audi', 52642.00),
       ('Mercedes', 57127.00),
       ('Skoda', 9000.00),
       ('Volvo', 29000.00),
       ('Bentley', 35000.00),
       ('Citroen', 21000.00),
       ('Hummer', 41400.00),
       ('Volkswagen', 21600.00);

SELECT * FROM cars;

/*
WITH Cars25 AS (
    SELECT * FROM cars
WHERE Cost <= 25000.00
)
SELECT * FROM Cars25
;

 */



-- Задача 1:
-- 1. Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов;

CREATE VIEW cars_25 AS
SELECT * FROM cars
WHERE Cost < 25000.00;

SELECT * FROM cars_25;


-- 2. Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW);

ALTER VIEW cars_25 AS
SELECT * FROM cars
WHERE Cost < 30000;

SELECT * FROM cars_25;


-- 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”;

CREATE VIEW cars_by_name AS
SELECT * FROM cars
WHERE Name IN ('Skoda', 'Audi');

SELECT * FROM cars_by_name;


/* Задача 2:

   Добавьте новый столбец под названием «время до следующей станции». Чтобы получить это значение, мы вычитаем время
   станций для пар смежных станций. Мы можем вычислить это значение без использования оконной функции SQL, но это может
   быть очень сложно. Проще это сделать с помощью оконной функции LEAD . Эта функция сравнивает значения из одной строки
   со следующей строкой, чтобы получить результат. В этом случае функция сравнивает значения в столбце «время» для
   станции со станцией сразу после нее.
 */

CREATE TABLE timetable (train_id int NOT NULL, station varchar(20) NOT NULL, station_time time NOT NULL);

INSERT timetable (train_id, station, station_time)
VALUES (110, 'San Francisco', '10:00:00'),
       (110, 'Redwood city', '10:54:00'),
       (110, 'Palo Alto', '11:02:00'),
       (110, 'San Jose', '12:35:00'),
       (120, 'San Francisco', '11:00:00'),
       (120, 'Palo Alto', '12:49:00'),
       (120, 'San Jose', '13:30:00');

SELECT * FROM timetable;


SELECT train_id, station, station_time,
        ifnull(timediff(lead(station_time) OVER (PARTITION BY train_id ORDER BY station_time), station_time), '') AS time_to_next_station
        FROM timetable
ORDER BY train_id, station_time;