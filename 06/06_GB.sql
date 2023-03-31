-- SOURCE C:\GB\SQL\Homeworks\06\Source\lesson_6.sql;

USE lesson_6;
SHOW TABLES;

/*
1. Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, с помощью которой можно переместить любого
(одного) пользователя из таблицы users в таблицу users_old. (использование транзакции с выбором commit или rollback – обязательно).
*/


CREATE TABLE users_old LIKE users;


DROP PROCEDURE IF EXISTS moveuser;
DELIMITER !!
CREATE PROCEDURE moveuser(IN user_id int)
   BEGIN
-- Здесь откатим, если будет ошибка SQL
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
         BEGIN
             ROLLBACK;
             SELECT 'An error has occurred';
         END;
-- Переменную можно было не использовать, но для тренировки;
    SET @userid := user_id;
-- Проверим условиями, есть ли айдишник, по которому переносить;
     IF  @userid IN (SELECT id FROM users)
       THEN
                START TRANSACTION;
                    INSERT users_old (id, firstname, lastname, email)
                    SELECT id, firstname, lastname, email FROM users WHERE id = @userid;
                    DELETE FROM users WHERE id = @userid;
                    SELECT 'User with has been moved to new table' AS 'Info';
                COMMIT;

       ELSE
                SELECT 'No user with such id in source table' AS 'Info';
     END IF;
END!!
DELIMITER ;


CALL moveuser(5);


/* 2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
   С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
   с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
 */

SET GLOBAL log_bin_trust_function_creators = 1;

-- Вариант 1, через IF ы;
DROP FUNCTION IF EXISTS hello;
DELIMITER @@
CREATE FUNCTION hello()
    RETURNS varchar(50)
    BEGIN
        SET @timenow := curtime();
        IF @timenow BETWEEN '06:00:00' AND '12:00:00'
            THEN
                RETURN 'Доброе утро' ;
        ELSEIF @timenow BETWEEN '12:00:01' AND '18:00:00'
            THEN
                RETURN 'Добрый день';
        ELSEIF @timenow BETWEEN '18:00:01' AND '23:59:59'
            THEN
                RETURN 'Добрый вечер';
        ELSE
                RETURN 'Доброй ночи';
        END IF;
    END@@
DELIMITER ;

-- Вариант 2 - CASE;
DROP FUNCTION IF EXISTS hello1;
DELIMITER ##
CREATE FUNCTION hello1()
    RETURNS varchar(50)
    BEGIN
        SET @timenow = curtime();
         CASE
            WHEN @timenow BETWEEN '06:00:00' AND '12:00:00'
                THEN
                    RETURN 'Доброе утро';
            WHEN @timenow BETWEEN '12:00:01' AND '18:00:00'
                THEN
                    RETURN 'Добрый день';
            WHEN @timenow BETWEEN '18:00:01' AND '23:59:59'
                THEN
                    RETURN 'Добрый вечер';
            ELSE
                    RETURN 'Доброй ночи';
         END CASE ;
    END##
DELIMITER ;


SELECT hello();
SELECT hello1();

/*
 3. (по желанию)* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, communities и
 messages в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа.
 */

CREATE TABLE logs (timedate datetime, name_table varchar(50), id_pk int)
ENGINE = ARCHIVE;

DELIMITER ##
CREATE TRIGGER log_trigger_users AFTER INSERT
    ON users
    FOR EACH ROW
    BEGIN
    INSERT logs (timedate, name_table, id_pk)
    VALUES (now(), 'users', new.id );
    END##


CREATE TRIGGER log_trigger_communities AFTER INSERT
    ON communities
    FOR EACH ROW
    BEGIN
    INSERT logs (timedate, name_table, id_pk)
    VALUES (now(), 'communities', new.id );
    END##


CREATE TRIGGER log_trigger_messages AFTER INSERT
    ON messages
    FOR EACH ROW
    BEGIN
    INSERT logs (timedate, name_table, id_pk)
    VALUES (now(), 'messages', new.id );
    END##

DELIMITER ;


INSERT users (id, firstname, lastname, email)
VALUES (10, 'Ivan', 'Balabay', 'test@test.com');

INSERT communities (id, name)
VALUES (11, 'test');

INSERT messages (id, from_user_id, to_user_id, body, created_at)
VALUES (21,10,1,'Привет!', now());
