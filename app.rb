require_relative './lib/database_connection'
require_relative './lib/artist_repository'
require_relative './lib/album_repository'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('music_library')

# Perform a SQL query on the database and get the result set.
# sql = 'SELECT * FROM artists;'
# result = DatabaseConnection.exec_params(sql, [])

artist_repository = ArtistRepository.new
album_repository = AlbumRepository.new

# Print out each record from the result set .
artist_repository.all.each do |artist|
  p artist.id + " - " + artist.name + " - " + artist.genre
end

album_repository.all.each do |album|
  p album.id + " - " + album.title + " - " + album.release_year + " - " + album.artist_id
end

p artist_repository.find(1).name
p album_repository.find(2).title