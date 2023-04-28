require_relative '../app'
require 'database_connection'

def reset_music_library
  seed_sql = File.read('./spec/seeds_music_library.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do 
    reset_music_library
  end

  it "Returns an ordered list of all ids and albums when selecting 1" do
    albums = AlbumRepository.new
    artists = ArtistRepository.new
    io = double :io
    expect(io).to receive(:puts).with("Welcome to the music library manager!").ordered
    expect(io).to receive(:puts).with("").ordered
    expect(io).to receive(:puts).with("What would you like to do?").ordered
    expect(io).to receive(:puts).with(" 1 - List all albums").ordered
    expect(io).to receive(:puts).with(" 2 - List all artists").ordered
    expect(io).to receive(:puts).with("").ordered
    expect(io).to receive(:puts).with("Enter you choice:").ordered
    expect(io).to receive(:gets).and_return("1").ordered
    expect(io).to receive(:puts).with("* 1 - Rumours").ordered
    expect(io).to receive(:puts).with("* 2 - Dangerous Woman").ordered

    app = Application.new('music_library_test', io, albums, artists)
    app.run
  end

end


# $ ruby app.rb

# Welcome to the music library manager!

# What would you like to do?
#  1 - List all albums
#  2 - List all artists

# Enter your choice: 1
# [ENTER]

# Here is the list of albums:
#  * 1 - Doolittle
#  * 2 - Surfer Rosa
#  * 3 - Waterloo
#  * 4 - Super Trouper
#  * 5 - Bossanova
#  * 6 - Lover
#  * 7 - Folklore
#  * 8 - I Put a Spell on You
#  * 9 - Baltimore
#  * 10 -	Here Comes the Sun
#  * 11 - Fodder on My Wings
#  * 12 -	Ring Ring