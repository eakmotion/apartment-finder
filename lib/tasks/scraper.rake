namespace :scraper do
  desc "Fetch Craigslist posts via 3taps API"
  task scrape: :environment do
    require 'open-uri'
    require 'JSON'

    # set API token and URL
    auth_token = "caee576a0ddc5613c14a8ccd7c96c5e0"
    polling_url = "http://polling.3taps.com/poll"

    # Specify request parameters
    params = {
      auth_token: auth_token,
      anchor: 1906178340,
      source: "CRAIG",
      category_group: "RRRR",
      category: "RHFR",
      'location.city' => "USA-NYM-NEY",
      retvals: "location,external_url,heading,body,timestamp,price,images,annotations"
    }

    # Prepare API request
    uri = URI.parse(polling_url)
    uri.query = URI.encode_www_form(params)

    # Submit request
    result = JSON.parse(open(uri).read)

    result["postings"].each do |posting|
      # Create new Post
      @post = Post.new
      @post.heading = posting["heading"]
      @post.body = posting["body"]
      @post.price = posting["price"]
      @post.neighborhood = posting["location"]["locality"]
      @post.external_url = posting["external_url"]
      @post.timestamp = posting["timestamp"]
      @post.bedrooms = posting["annotations"]["bedrooms"] if posting["annotations"]["bedrooms"].present?
      @post.bathrooms = posting["annotations"]["bathrooms"] if posting["annotations"]["bathrooms"].present?
      @post.sqft = posting["annotations"]["sqft"] if posting["annotations"]["sqft"].present?
      @post.parking = posting["annotations"]["street_parking"] if posting["annotations"]["street_parking"].present?
      # Save Post
      @post.save

      # Loop over images
      posting["images"].each do |image|
        @image = Image.new
        @image.url = image["full"]
        @image.post_id = @post.id 
        @image.save
      end 
    end
  end

  desc "Save neighborhood short name"
  task scrape_neighborhoods: :environment do
    require 'open-uri'
    require 'json'

    # Set API token and URL
    auth_token = "caee576a0ddc5613c14a8ccd7c96c5e0"
    location_url = "http://reference.3taps.com/locations"

    # Specify request parameters
    params = {
     auth_token: auth_token,
     level: "locality",
     city: "USA-NYM-NEY"
    }

    # Prepare API request
    uri = URI.parse(location_url)
    uri.query = URI.encode_www_form(params)

    # Submit request
    result = JSON.parse(open(uri).read)

    # Store results in database
    result["locations"].each do |location|
      @location = Location.new
      @location.code = location["code"]
      @location.name = location["short_name"]
      @location.save
    end
  end

  desc "Destroy all posts"
  task destroy_all_posts: :environment do
    Post.all.each do |post|
      post.destroy
    end
  end

end
