-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.


-- создаем новую таблицу для логов
CREATE TABLE logs (
id BIGINT UNSIGNED,
table_name VARCHAR(150) NOT NULL,
creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
name VARCHAR(150)
);

DROP TRIGGER IF EXISTS log_after_insert_users;
DROP TRIGGER IF EXISTS log_after_insert_catalogs;
DROP TRIGGER IF EXISTS log_after_insert_products;

DELIMITER //

-- триггеры при создании записи в таблицах
CREATE TRIGGER log_after_insert_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (id, table_name, name) 
	VALUES (NEW.id, 'users', NEW.name);
END//

CREATE TRIGGER log_after_insert_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (id, table_name, name) 
	VALUES (NEW.id, 'catalogs', NEW.name);
END//

CREATE TRIGGER log_after_insert_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (id, table_name, name) 
	VALUES (NEW.id, 'products', NEW.name);
END//

DELIMITER ;



-- В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

-- Хэш таблицы (ключ - ip адрес, а в значении число посещений)

--  При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.

-- Создадим две хэш таблицы, первая с поиском email по имени, вторая - наоборот.
hset user_email name email
hset email_user email name

hget user_email "name" 
hget email_user "email" 

-- Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.

shop.products.insert({
    name: "Intel Core i3-8100",
    description: "Процессор для настольных персональных компьютеров, основанных на платформе Intel.",
    price: 7890.00,
    catalog: "Процессоры"
})

