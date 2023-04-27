require 'album_repository'
require 'album'
require 'database_connection'

def reset_music_library
  seed_sql = File.read('./spec/seeds_music_library.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe AlbumRepository do
  before(:each) do 
    reset_music_library
  end

  it "returns all albums" do
    repo = AlbumRepository.new
    albums = repo.all
    expect(albums.length).to eq 2
    expect(albums[0].id).to eq "1"
    expect(albums[0].title).to eq "Rumours"
    expect(albums[0].release_year).to eq "1977"
    expect(albums[0].artist_id).to eq "1"
  end

  it "finds a specific album" do
    repo = AlbumRepository.new
    album = repo.find(1)
    expect(album.title).to eq "Rumours"
    expect(album.release_year).to eq "1977"
    expect(album.artist_id).to eq "1"
    album = repo.find(2)
    expect(album.title).to eq "Dangerous Woman"
    expect(album.release_year).to eq "2016"
    expect(album.artist_id).to eq "2"
  end

  it "creates a new album" do
    tusk = Album.new
    tusk.id = '3'
    tusk.title = 'Tusk'
    tusk.release_year = '1979'
    tusk.artist_id = '1'
    repo = AlbumRepository.new
    repo.create(tusk)
    alb = repo.find(3)
    expect(alb.id).to eq '3'
    expect(alb.title).to eq 'Tusk'
    expect(alb.release_year).to eq '1979'
    expect(alb.artist_id).to eq '1'

    repository = AlbumRepository.new

    album = Album.new
    album.title = 'Trompe le Monde'
    album.release_year = 1991
    album.artist_id = 1
    repository.create(album)
    all_albums = repository.all
    expect(all_albums[-1].title).to eq 'Trompe le Monde'
  end
end