require 'artist_repository'
require 'database_connection'
require 'artist'

def reset_music_library
  seed_sql = File.read('./spec/seeds_music_library.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe ArtistRepository do
  before(:each) do 
    reset_music_library
  end

  it "returns all the artists" do
    repo = ArtistRepository.new
    artists = repo.all
    expect(artists.length).to eq 2
    expect(artists[0].id).to eq "1"
    expect(artists[0].name).to eq "Fleetwood Mac"
    expect(artists[0].genre).to eq "Rock"
  end

  it "Creates" do
    miley_cyrus = Artist.new
    miley_cyrus.name = "Miley Cyrus"
    miley_cyrus.genre = "Pop"
    repo = ArtistRepository.new
    repo.create(miley_cyrus)
    artists = repo.all
    expect(artists.last.id).to eq "3"
    expect(artists.last.name).to eq "Miley Cyrus"
    expect(artists.last.genre).to eq "Pop"
  end

  it "Finds/Reads" do
    repo = ArtistRepository.new
    artist = repo.find(1)
    expect(artist.name).to eq "Fleetwood Mac"
    expect(artist.genre).to eq "Rock"
    artist = repo.find(2)
    expect(artist.name).to eq "Ariana Grande"
    expect(artist.genre).to eq "Pop"
  end

  it "Updates" do
    miley_cyrus = Artist.new
    miley_cyrus.id = "2"
    miley_cyrus.name = "Miley Cyrus"
    miley_cyrus.genre = "Pop"
    repo = ArtistRepository.new
    repo.update(miley_cyrus)
    artist = repo.find(2)
    expect(artist.id).to eq "2"
    expect(artist.name).to eq "Miley Cyrus"
    expect(artist.genre).to eq "Pop"
  end

  it "Deletes" do
    miley_cyrus = Artist.new
    miley_cyrus.id = "2"
    miley_cyrus.name = "Miley Cyrus"
    miley_cyrus.genre = "Pop"
    repo = ArtistRepository.new
    artist = repo.create(miley_cyrus)
    artists = repo.all
    expect(artists.length).to eq 3
    artist = repo.delete(miley_cyrus)
    artists = repo.all
    expect(artists.length).to eq 2
  end
end