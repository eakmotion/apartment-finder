namespace :scraper do
  desc "TODO"
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
      retvals: "location,external_url,heading,body,timestamp,price"
    }

    # Prepare API request
    uri = URI.parse(polling_url)
    uri.query = URI.encode_www_form(params)

    # Submit request
    result = JSON.parse(open(uri).read)
    puts result
  end

  desc "TODO"
  task destroy_all_posts: :environment do
  end

end
