-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
update users 
set created_at = now()
where created_at is null;

update users 
set updated_at = now()
where updated_at is null;

-- Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

-- приводим таблицу в соответствии с заданием

alter table users modify created_at varchar(255);
update users set created_at = '20.10.2017 8:10';

--решаем проблему

update users set created_at = str_to_date(created_at, '%d.%m.%Y %h:%i');
alter table users modify created_at datetime;

-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.

insert into storehouses_products (value) values (1),(20),(26),(55),(0),(6),(66),(44),(0),(71),(5),(0),(32),(9),(0);
select * from storehouses_products order by value = 0, value;

-- Подсчитайте средний возраст пользователей в таблице users.
select name , round(avg(datediff(now(), birthday_at)/'365,25'),2) from users; 


-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

/*
select name, 

round((datediff(now(), birthday_at)/'365,25'),0) -- определяем возраст

from users;
*/

-- для меня оказалось сложно сделать день недели именно текущего года, выкрутилась сложным способом - вычислением возраста юзера на текущий день и прибавлению его к дате рождения = получился ДР в текущем году, наверняка есть способ проще, но мне не удалось найти.
SELECT  
-- adddate(birthday_at, interval (round((datediff(now(), birthday_at)/'365,25'),0)) year) as DR_v_etom_godu,
weekday(adddate(birthday_at, interval (round((datediff(now(), birthday_at)/'365,25'),0)) year)) as den_nedeli,
count(*), -- делаю подсчет количества записей

case 
	when weekday(adddate(birthday_at, interval (round((datediff(now(), birthday_at)/'365,25'),0)) year)) = 0 then 'понедельник'
	when weekday(adddate(birthday_at, interval (round((datediff(now(), birthday_at)/'365,25'),0)) year)) = 1 then 'вторник'
	when weekday(adddate(birthday_at, interval (round((datediff(now(), birthday_at)/'365,25'),0)) year)) = 2 then 'среда'
	when weekday(adddate(birthday_at, interval (round((datediff(now(), birthday_at)/'365,25'),0)) year)) = 3 then 'четверг'
	when weekday(adddate(birthday_at, interval (round((datediff(now(), birthday_at)/'365,25'),0)) year)) = 4 then 'пятница'
	when weekday(adddate(birthday_at, interval (round((datediff(now(), birthday_at)/'365,25'),0)) year)) = 5 then 'суббота'
	when weekday(adddate(birthday_at, interval (round((datediff(now(), birthday_at)/'365,25'),0)) year)) = 6 then 'воскресение'
end 

from users
group by den_nedeli; -- группирую по днем недели


