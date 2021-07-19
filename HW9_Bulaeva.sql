-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;

INSERT INTO sample.users VALUES 
SELECT * FROM shop.users 
WHERE id = 1;

DELETE FROM sample.users 
WHERE id = 1;

COMMIT;

-- Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.


CREATE OR REPLACE VIEW name_of_products 
AS
SELECT p.name, c.name 
from products p 
	join catalogs c ON p.catalog_id = c.id
	ORDER BY c.id;


-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;
DELIMITER // -- выставим разделитель

CREATE FUNCTION hello ()
RETURNS TEXT READS SQL DATA
BEGIN 
	DECLARE current_hour int;
	SET current_hour = HOUR(now());
	CASE
		when current_hour BETWEEN 6 and 11 THEN RETURN "Доброе утро";
		when current_hour BETWEEN 12 and 17 THEN RETURN "Добрый день";
		when current_hour BETWEEN 18 and 23 THEN RETURN "Добрый вечер";
		when current_hour BETWEEN 0 and 5 THEN RETURN "Доброй ночи";
	
	END CASE;
	
END//
DELIMITER ;
-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

DROP TRIGGER IF EXISTS check_product_name_or_description;
DELIMITER //

CREATE TRIGGER check_product_name_or_description BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF new.name = NULL and new.description = NULL THEN 
	SIGNAL SQLSTATE '45000'	SET MESSAGE_TEXT = 'Insert Canceled. Name or description should be not null';
	END IF;
END//

DELIMITER ;