require_relative './artist'
require_relative './database_connection'

class ArtistRepository
  def all
    query = "SELECT id, name, genre FROM artists;"
    result = DatabaseConnection.exec_params(query, [])

    artists = []

    result.each { |record|
      artist = Artist.new
      artist.id = record['id']
      artist.name = record['name']
      artist.genre = record['genre']

      artists << artist
    }

    return artists
  end
  
  def create(artist)
    query = "INSERT INTO artists (name, genre) VALUES ($1, $2);"
    params = [artist.name, artist.genre]
    DatabaseConnection.exec_params(query, params)
  end

  def find(id)
    query = "SELECT * FROM artists WHERE id = $1;"
    param = [id]
    result = DatabaseConnection.exec_params(query, param)[0]
    
    artist = Artist.new
    artist.id = result["id"]
    artist.name = result["name"]
    artist.genre = result["genre"]

    return artist
  end

  def update(artist)
    query = "UPDATE artists SET name = $1, genre = $2 WHERE id = $3;"
    params = [artist.name, artist.genre, artist.id]
    DatabaseConnection.exec_params(query, params)
  end

  def delete(artist)
    query = "DELETE FROM artists WHERE id = $1;"
    params = [artist.id]
    DatabaseConnection.exec_params(query, params)
  end
end