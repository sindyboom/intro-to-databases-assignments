create database app_music;

create table genres (
    genre_id serial primary key,
    name varchar(100) not null
);


create table users (
    user_id  serial primary key,
    username  varchar(100) not null,
    email  varchar(255) not null,
    password varchar(255) not null
);


create table user_profiles (
    profile_id   serial primary key,
    user_id  int not null unique,
    display_name varchar(150),
    country varchar(100),
    foreign key (user_id) references users(user_id)
);


create table artists (
    artist_id serial primary key,
    name varchar(200) not null,
    country  varchar(100)
);


create table albums (
    album_id  serial primary key,
    artist_id  int not null,
    title varchar(300) not null,
    release_date date,
    foreign key (artist_id) references artists(artist_id)
);


create table songs (
    song_id  serial primary key,
    album_id  int not null,
    artist_id  int not null,
    title  varchar(300) not null,
    duration_sec int not null,
     foreign key (album_id)  references albums(album_id),
    foreign key (artist_id) references artists(artist_id)
);


create table playlists (
    playlist_id serial primary key,
    user_id int not null,
    title varchar(300) not null,
    foreign key (user_id) references users(user_id)
);


create table playlist_songs (
    playlist_id int not null,
    song_id     int not null,
    primary key (playlist_id, song_id), -- одна пісня не може двічі потрапити в один плейлист
    foreign key (playlist_id) references playlists(playlist_id),
    foreign key (song_id)     references songs(song_id)
);


create table song_genres (
    song_id  int not null,
    genre_id int not null,
    primary key (song_id, genre_id), --один жанр не може бути двічі призначений одній пісні
    foreign key (song_id)  references songs(song_id),
    foreign key (genre_id) references genres(genre_id)
);


create table user_liked_songs (
    user_id int not null,
    song_id int not null,
    primary key (user_id, song_id), --юзер не може лайкнути одну пісню двічі
    foreign key (user_id) references users(user_id),
    foreign key (song_id) references songs(song_id)
);

create table artist_followers (
    user_id   int not null,
    artist_id int not null,
    primary key (user_id, artist_id), --юзер не може підписатись на одного артиста двічі
    foreign key (user_id)   references users(user_id),
    foreign key (artist_id) references artists(artist_id)
);


create table subscription_plans (
    plan_id       serial primary key,
    name          varchar(100) not null,
    price         numeric(10, 2) not null,
    duration_days int not null
);


create table subscriptions (
    subscription_id serial primary key,
    user_id  int not null,
    plan_id  int not null,
    start_date  date not null,
    end_date  date not null,
    foreign key (user_id) references users(user_id),
    foreign key (plan_id) references subscription_plans(plan_id)
);


create table payments (
    payment_id  serial primary key,
    user_id  int not null,
    subscription_id int not null,
    amount  numeric(10, 2) not null,
    payment_date  date not null,
    status varchar(50) not null,
    foreign key (user_id) references users(user_id),
    foreign key (subscription_id) references subscriptions(subscription_id)
);
