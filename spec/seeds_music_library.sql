TRUNCATE TABLE artists RESTART IDENTITY;
TRUNCATE TABLE albums RESTART IDENTITY;

INSERT INTO artists (name, genre) VALUES ('Fleetwood Mac', 'Rock');
INSERT INTO artists (name, genre) VALUES ('Ariana Grande', 'Pop');

INSERT INTO albums (title, release_year, artist_id) VALUES ('Rumours', '1977', '1');
INSERT INTO albums (title, release_year, artist_id) VALUES ('Dangerous Woman', '2016', '2');