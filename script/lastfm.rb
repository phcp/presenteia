LastFM.api_key     = "950cc921dfe54a6b8d9e506869a74e1e"
LastFM.client_name = "presenteia.la"

def getTopArtists
  top_artists = LastFM::Geo.get_top_artists(location: "Recife", country: "Brazil")

  top_artists["topartists"]["artist"].each do |artist|
    band = Band.create!(name: artist["name"])
    getTopAlbuns(band)
  end
end

def getTopAlbuns(artist)
  top_albuns = LastFM::Artist.get_top_albums(artist: artist.name, limit: 5)
  top_albuns["topalbums"]["album"].each do |album|
    begin
      cd = Cd.create!(title: album["name"], image: album["image"][2]["#text"], band_id: artist.id)
      cd.link_amazon = getBuyLink(cd)
      cd.save!
    rescue
    end
  end
end

def getBuyLink(album)
  link = LastFM::Album.get_buy_links(artist: album.band.name, album: album.title, country: "Brazil")
  return link["affiliations"]["physicals"]["affiliation"]["buyLink"]
end

def getFacebook
  conn = Faraday.new(:url => 'https://graph.facebook.com/') do |faraday|
    faraday.request  :url_encoded
    faraday.response :logger
    faraday.adapter  Faraday.default_adapter
  end

  friends_response = conn.get "1341886289/friends?fields=id,name,picture&limit=5000&offset=0&access_token=CAACNSFC2zdIBALscifGOU7FzeECGO7aYdELyttj6tgLTJrsMvSlZCgg6rKJZBBmFVykgdUsA9EZBh2oZBZCPpn7CZCbAox8wnz8QAfzU1vfTb7bJ4wkbL5BdRRxSNbAdAc55F4tiNRktaHcV8an3gA0CkYrd3J9awz7oObAHfmIgvl6KRZCChb3"

  hash = JSON.parse(friends_response.body)
  hash["data"].each do |friend|
    friend["name"]
  end
end
