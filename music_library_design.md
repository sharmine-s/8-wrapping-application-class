2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here.

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE artists RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO artists (name, cohort_name) VALUES ('David', 'April 2022');
INSERT INTO artists (name, cohort_name) VALUES ('Anna', 'May 2022');

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql

3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by Repository for the Repository class name.

Table name: artists

Model class
(in lib/artist.rb)
class Artist
end

# Repository class

# (in lib/artist_repository.rb)

class ArtistRepository
end

# Table name: albums

# Model class

# (in lib/album.rb)

class Album
end

# Repository class

# (in lib/album_repository.rb)

class AlbumRepository
end

4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

# Table name: artists

# Model class

# (in lib/artist.rb)

class Artist

  attr_accessor :id, :name, :genre
end

# Table name: albums

# Model class

# (in lib/album.rb)

class Album

  attr_accessor :id, :title, :release_year, :artist_id
end

# The keyword attr_accessor is a special Ruby feature

# which allows us to set and get attributes on an object

# here's an example

#

# artist = artist.new

# artist.name = 'Jo'

# artist.name

5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

# Table name: artists

# Repository class

# (in lib/artist_repository.rb)

class ArtistRepository

# Selecting all records

# No arguments

  def all
    # Executes the SQL query:
    # SELECT id, name, genre FROM artists;

    # Returns an array of Artist objects.
  end

# Gets a single record by its ID

# One argument: the id (number)

  def find(id)
    # Executes the SQL query:
    # SELECT id, name, genre FROM artists WHERE id = $1;

    # Returns a single Artist object.
  end

# Add more methods below for each operation you'd like to implement

  def create(artist)
    # Executes the SQL query:
    # INSERT INTO artists (name, genre) VALUES (artist.name, artist.genre);

    # Creates a single Artist object.
  end

  def update(artist)
    UPDATE artists SET name = artist.name, genre = artist.genre WHERE id = artist.id;

    # Updates a single Artist object.
  end

  def delete(artist)
    DELETE FROM artists WHERE id = artist.id;

    # Deletes a single Artist object.
  end
end

# Table name: albums

# Repository class

# (in lib/album_repository.rb)

class AlbumRepository

# Selecting all records

# No arguments

  def all
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums;

    # Returns an array of Album objects.
  end

# Gets a single record by its ID

# One argument: the id (number)

  def find(id)
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;

    # Returns a single Album object.
  end

# Add more methods below for each operation you'd like to implement

  def create(album)
    # Executes the SQL query:
    # INSERT INTO albums (title, release_year, artist_id) VALUES (album.title, album.release_year, album.artist_id);

    # Creates a single Album object.
  end

  def update(album)
    UPDATE artists SET title = album.name, release_year = album.release_year , artist_id = album.artist_id WHERE id = album.id;

    # Updates a single Album object.
  end

  def delete(album)
    DELETE FROM albums WHERE id = album.id;

    # Deletes a single Album object.
  end
end

6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

# Artists

# 1

# Get all artists

repo = ArtistRepository.new

artists = repo.all

artists.length # =>  2

artists[0].id # =>  '1'
artists[0].name # =>  'Fleetwood Mac'
artists[0].genre # =>  'Rock'

## these methods are the accessors from the Artist class

artists[1].id # =>  '2'
artists[1].name # =>  'Ariana Grande'
artists[1].genre # =>  'Pop'

# 2

# Get a single artist

repo = ArtistRepository.new

artist = repo.find(1)

artist.id # => 1
artist.name # => 'Fleetwood Mac'
artist.genre # => 'Rock'

# 3

# Create a single artist

miley_cyrus = double(:artist, name: "Miley Cyrus", genre: "Pop")

repo = ArtistRepository.new

artist = repo.create(miley_cyrus)

artist.id # => 3
artist.name # => 'Miley Cyrus'
artist.genre # => 'Pop'

# 4

# Update a single artist

miley_cyrus = double(:artist, id: "3", name: "Miley Cyrus", genre: "Rock")

repo = ArtistRepository.new

artist = repo.update(miley_cyrus)

artist.id # => 3
artist.name # => 'Miley Cyrus'
artist.genre # => 'Rock'

# 5

# Deletes a single artist

miley_cyrus = double(:artist, id: "3")

repo = ArtistRepository.new

artist = repo.delete(miley_cyrus)

artists = repo.all

artists.length # =>  2

# Albums

# 1

# Get all albums

repo = AlbumRepository.new

albums = repo.all

albums.length # =>  2

albums[0].id # =>  1
albums[0].title # =>  'Rumours'
albums[0].release_year # =>  '1977'
albums[0].artist_id # =>  '1'

albums[1].id # =>  2
albums[1].title # =>  'Dangerous Woman'
albums[1].release_year # =>  '2016'
albums[1].artist_id # =>  '2'

# 2

# Get a single album

repo = AlbumRepository.new

album = repo.find(1)

album.id # => 1
album.title # => 'Rumous'
album.release_year # => '1977'
album.artist_id # => '1'

# 3

# Create a single album

tusk = double(:artist, title: "Tusk", release_year: "1979", artist_id: "1")

repo = AlbumRepository.new

album = repo.create(tusk)

album.id # => 3
album.title # => 'Tusk'
album.release_year # => '1979'
album.artist_id # => '1'

# 4

# Update a single album

tusk = double(:artist, id: "3", title: "Another Album Name", release_year: "1979", artist_id: "1")

repo = ArtistRepository.new

album = repo.update(tusk)

album.title # => 'Another Album Name'

# 5

# Deletes a single album

tusk = double(:artist, id: "3")

repo = ArtistRepository.new

album = repo.delete(tusk)

albums = repo.all

albums.length # =>  2

7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

# file: spec/artist_repository_spec.rb

def reset_artists_table
  seed_sql = File.read('spec/seeds_music_library.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library' })
  connection.exec(seed_sql)
end

describe ArtistRepository do
  before(:each) do
    reset_artist_table
  end

# (your tests will go here)

end
