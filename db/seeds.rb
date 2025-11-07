# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
require 'json'


URL = "https://tmdb.lewagon.com/movie/top_rated"
POSTER_URL = "https://image.tmdb.org/t/p/original"

puts "Cleaning database"

Bookmark.destroy_all
List.destroy_all
Movie.destroy_all

puts "Fetching movies"

movies_serialized = URI.open(URL).read
movies = JSON.parse(movies_serialized)["results"]

puts "Creating movies"

movies.each do |movie|
  Movie.create(
    title: movie["title"],
    overview: movie["overview"],
    poster_url: "#{POSTER_URL}#{movie["poster_path"]}",
    rating: movie["vote_average"]
  )
end
puts "Created 20 movies."
