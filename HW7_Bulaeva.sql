-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

SELECT u.id , u.name 
	from users u 
	join orders o 
	on u.id = o.user_id 
group by u.id;



-- Выведите список товаров products и разделов catalogs, который соответствует товару.

select p.id , p.name, c.name 
	from products p 
	join catalogs c 
	on p.catalog_id = c.id 


-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

	CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  fro VARCHAR(255),
  too VARCHAR(255)
);
	CREATE TABLE cities (
  label VARCHAR(255),
  name VARCHAR(255)
);

insert into flights VALUES
  (1, 'moscow', 'omsk'),
   (2, 'novgorod', 'kazan'),
    (3, 'irkutsk', 'moscow'),
     (4, 'omsk', 'irkutsk'),
     (5, 'moscow', 'kazan');
    
    
insert into cities VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');
    
    
    
select f.id, c.name, c2.name 
	from flights f 
	join cities c 
	on f.fro = c.label
	join cities c2 
	on f.too = c2.label
order by f.id ;
     
