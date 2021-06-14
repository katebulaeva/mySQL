-- 1.Проанализировать структуру БД vk, которую мы создали на занятии, и внести предложения по усовершенствованию (если такие идеи есть). Напишите пожалуйста, всё-ли понятно по структуре.
-- все понятно,спасибо) на деле оказалось не очень удобно искать весь код относящийся к таблице, предлагаю все изменения (ALTER TABLE) писать после кода самой таблицы
-- могу предложить добавить таблицы:

-- таблица "друзья": список друзей для пользователя. -- 

-- связь M:M --

create table users_friends(
	user_id BIGINT UNSIGNED NOT NULL,
	friend_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, friend_id), -- чтобы не было 2 записей о пользователе и друге
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (friend_id) REFERENCES users(id) 
);

-- таблица "события/мероприятия": --

-- связь 1:M (между events_types и events)--

CREATE TABLE event_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    
);
    
CREATE TABLE events(
	event_id SERIAL PRIMARY KEY,
   	event_type_id BIGINT unsigned,
    	event_owner_id BIGINT UNSIGNED NOT NULL,
    	name VARCHAR(255),
    	created_at DATETIME DEFAULT NOW(),
	start_date DATETIME DEFAULT now(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	event_site VARCHAR(255),
	event_description text,

    FOREIGN KEY (event_owner_id) REFERENCES users(id),
    FOREIGN KEY (event_type_id) REFERENCES event_types(id),
    INDEX events_name_date_idx(name, start_date)
);
	
-- связь M:M (между подписчиками и событиями)--

CREATE TABLE subscribers_event (

	subscriber_id BIGINT UNSIGNED NOT NULL,
	event_id BIGINT UNSIGNED NOT NULL,

	PRIMARY KEY (subscriber_id, event_id), -- чтобы не было 2 записей о подписчике и мероприятии
    FOREIGN KEY (subscriber_id) REFERENCES users(id) ,
    FOREIGN KEY (event_id) REFERENCES events(event_id) 
);

-- 2.Добавить необходимую таблицу/таблицы для того, чтобы можно было использовать лайки для медиафайлов, постов и пользователей.

CREATE TABLE likes_media(
	id SERIAL PRIMARY KEY,
    	user_id BIGINT UNSIGNED NOT NULL,
    	media_id BIGINT UNSIGNED NOT NULL,
    	created_at DATETIME DEFAULT NOW(),

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)

);

CREATE TABLE likes_users(
	id SERIAL PRIMARY KEY,
    	from_user BIGINT UNSIGNED NOT NULL,
    	to_user BIGINT UNSIGNED NOT NULL,
    	created_at DATETIME DEFAULT NOW(),

    FOREIGN KEY (from_user) REFERENCES users(id),
    FOREIGN KEY (to_user) REFERENCES users(id)

);

CREATE TABLE posts(
	id SERIAL PRIMARY KEY,
    	user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    	created_at DATETIME DEFAULT NOW(),
    	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE TABLE likes_posts(
	id SERIAL PRIMARY KEY,
    	user_id BIGINT UNSIGNED NOT NULL,
    	post_id BIGINT UNSIGNED NOT NULL,
    	created_at DATETIME DEFAULT NOW(),

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (post_id) REFERENCES post(id)

);

