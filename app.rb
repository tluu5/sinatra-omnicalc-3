require "sinatra"
require "sinatra/reloader"
require "http"
require "sinatra/cookies"

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "
end

get ("/umbrella") do
  erb(:umbrella_form)
end

post("/process_umbrella") do
  @user_location = params.fetch("user_loc")
  url_encoded_string = @user_location.gsub(" ", "+")
  gmaps_url = ""
  @raw_response = HTTP.get(gmaps_url).to_s
  @parsed_response = JSON.parse(@raw_response)
  @loc_hash = @parsed_response.dig("results", 0, "geometry", "location")
  @latitude = @loc_hash.fetch("lat")
  @longitude = @loc_hash.fetch("lng")
  cookies["last_location"] = @user_location
  cookies["last_lat"] = @latitude
  cookies["last_lng"] = @longitude
  erb(:umbrella_results)
end
