require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "5232f11fd292d9a6451730121573742a"

# News
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=3fb5a0c1f4e74dee9def689f46ebf1c2"


get "/" do
  view "ask"
end

get "/weather" do
   results = Geocoder.search(params["location"])
   lat_long = results.first.coordinates # => [lat, long]
  
   @forecast = ForecastIO.forecast("#{lat_long[0]}","#{lat_long[1]}").to_hash
   @current_temperature = @forecast["currently"]["temperature"]
   @conditions = @forecast["currently"]["summary"]

  view "app"   
 
end

get "/news" do

   @news = HTTParty.get(url).parsed_response.to_hash
   @first_news_title = @news["articles"][0]["title"]
   @first_news_url = @news["articles"][0]["url"]
 
   view "news"

end 
  