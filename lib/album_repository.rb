require_relative './album'
require_relative './database_connection'

class AlbumRepository
  def all
    query = "SELECT * FROM albums;"
    result = DatabaseConnection.exec_params(query, [])

    albums = []

    result.each { |record|
      album = Album.new
      album.id = record["id"]
      album.title = record["title"]
      album.release_year = record["release_year"]
      album.artist_id = record["artist_id"]

      albums << album
    }

    return albums # returns array of hashes, and in each hash is an object
  end

  def find(id)
    query = "SELECT * FROM albums WHERE id = $1;"
    param = [id]
    result = DatabaseConnection.exec_params(query, param)[0] # returns first object

    album = Album.new
    album.id = result["id"]
    album.title = result["title"]
    album.release_year = result["release_year"]
    album.artist_id = result["artist_id"]

    return album
  end

  def create(album)
    query = 'INSERT INTO albums (title, release_year, artist_id) VALUES ($1, $2, $3);'
    params = [album.title, album.release_year, album.artist_id]
    DatabaseConnection.exec_params(query, params)
    # Creates a single Album object.
  end
end