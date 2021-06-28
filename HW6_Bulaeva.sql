use vk2;


-- Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять).



-- Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

 -- (потом уже нашла, как можно делать без создания промежуточных таблиц (НИЖЕ))
	-- создаем новую таблицу для вычисления пользователя с максимульным числом сообщений для дальнейшего анализа
drop table HW6_1 if exist;
create table HW6_1 select count(*) as count, to_user_id from messages group by to_user_id order by count desc limit 1;

	-- задаем этого юзера в значение @user
set @user := (select to_user_id from hw6_1);
select @user;

	-- находим пользователя который отправил ему больше всего сообщений
create table HW6_2
select from_user_id, count(*) from messages 
	where to_user_id = @user group by from_user_id order by count(*) desc limit 1
	;

	-- выводим имя этого пользователя 
SELECT CONCAT(first_name, ' ', last_name) as name FROM users WHERE id = (select from_user_id from hw6_2)
;

	-- удаляем временные таблицы (потом уже нашла, как можно делать без создания промежуточных таблиц (НИЖЕ))
drop table HW6_1, hw6_2 

-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
	-- находим 10 самых млодых пользователей:
select user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) as age from profiles order by age limit 10;
select user_id from (select user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) as age from profiles order by age limit 10) t;
	-- считаем количесво лайков этими пользователями:
(select count(*) FROM likes_media WHERE user_id IN (
select user_id from (select user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) as age from profiles order by age limit 10) t
)); 
(select count(*) FROM likes_posts WHERE user_id IN (
select user_id from (select user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) as age from profiles order by age limit 10) t
));

	-- объединяем в одну таблицу
select count(*) likes_users, 
(select count(*) FROM likes_media WHERE user_id IN (
select user_id from (select user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) as age from profiles order by age limit 10) t
)) likes_media,
(select count(*) FROM likes_posts WHERE user_id IN (
select user_id from (select user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) as age from profiles order by age limit 10) t
)) likes_posts 
FROM likes_users WHERE from_user IN (
select user_id from (select user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) as age from profiles order by age limit 10) t
);

	-- суммируем данные
select 
sum(likes_users) +
sum(likes_media) +
sum(likes_posts)
from (select count(*) likes_users, 
(select count(*) FROM likes_media WHERE user_id IN (
select user_id from (select user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) as age from profiles order by age limit 10) t
)) likes_media,
(select count(*) FROM likes_posts WHERE user_id IN (
select user_id from (select user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) as age from profiles order by age limit 10) t
)) likes_posts 
FROM likes_users WHERE from_user IN (
select user_id from (select user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) as age from profiles order by age limit 10) t
)) t; 


-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

	-- 	опредеяем список Id мужчин и id женщин
select user_id from profiles where gender = 'f';

select user_id from profiles where gender = 'm';

	-- считаем лайки от женщин

select 
sum(likes_users) +
sum(likes_media) +
sum(likes_posts) as women_likes
from (select count(*) likes_users, 
(select count(*) FROM likes_media WHERE user_id IN (select user_id from profiles where gender = 'f')) likes_media,
(select count(*) FROM likes_posts WHERE user_id IN (select user_id from profiles where gender = 'f')) likes_posts 
FROM likes_users WHERE from_user IN (select user_id from profiles where gender = 'f')) t;

	-- считаем лайки от мужчин

select 
sum(likes_users) +
sum(likes_media) +
sum(likes_posts) as men_likes
from (select count(*) likes_users, 
(select count(*) FROM likes_media WHERE user_id IN (select user_id from profiles where gender = 'm')) likes_media,
(select count(*) FROM likes_posts WHERE user_id IN (select user_id from profiles where gender = 'm')) likes_posts 
FROM likes_users WHERE from_user IN (select user_id from profiles where gender = 'm')) t;

	-- сравниваем и выводим результат

select 'result is' ,
if (women_likes > men_likes, 'больше лайков от женщин', 
if (women_likes < men_likes, 'больше лайков от мужчин', 
if (women_likes = men_likes, 'одинаковое количество лайков у мужчин и женщин', 'ошибка'
))
) as 'total'
from ((
select sum(likes_users) + sum(likes_media) + sum(likes_posts) as women_likes, 
(select sum(likes_users) + sum(likes_media) + sum(likes_posts) as men_likes from (select count(*) likes_users, (select count(*) FROM likes_media WHERE user_id IN (select user_id from profiles where gender = 'm')) likes_media, (select count(*) FROM likes_posts WHERE user_id IN (select user_id from profiles where gender = 'm')) likes_posts FROM likes_users WHERE from_user IN (select user_id from profiles where gender = 'm')) m) as men_likes
from ((select count(*) likes_users, (select count(*) FROM likes_media WHERE user_id IN (select user_id from profiles where gender = 'f')) likes_media, (select count(*) FROM likes_posts WHERE user_id IN (select user_id from profiles where gender = 'f')) likes_posts FROM likes_users WHERE from_user IN (select user_id from profiles where gender = 'f')) f)
) t);


-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

	-- делаем общую таблицу по лайкам, сообщениям, запросам в друзья
	
select id, 
(select count(*) FROM likes_media WHERE user_id = users.id ) as likes_media,
(select count(*) FROM likes_posts WHERE user_id = users.id ) as likes_posts,
(select count(*) FROM likes_users WHERE from_user = users.id ) as likes_users,
(select count(*) FROM messages WHERE from_user_id = users.id ) as messages,
(select count(*) FROM friend_requests WHERE from_user_id = users.id ) as requests,
from users;

 -- суммируем поля в полученной таблице, делаем сортировку и устанавливаем лимит
create table Low_activity_users
select id, name, (likes_media + likes_posts + likes_users + messages + requests) as activity
from ((select id, CONCAT(first_name, ' ', last_name) as name,
(select count(*) FROM likes_media WHERE user_id = users.id ) as likes_media,
(select count(*) FROM likes_posts WHERE user_id = users.id ) as likes_posts,
(select count(*) FROM likes_users WHERE from_user = users.id ) as likes_users,
(select count(*) FROM messages WHERE from_user_id = users.id ) as messages,
(select count(*) FROM friend_requests WHERE from_user_id = users.id ) as requests from users) t)
order by activity limit 10;




























