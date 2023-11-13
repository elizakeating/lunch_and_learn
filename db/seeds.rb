# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create(
  name: "bob",
  email: "bob@gmail.com",
  password: "1234",
  api_key: "abcdefgh"
)

user_2 = User.create(
  name: "sam",
  email: "sam@gmail.com",
  password: "1234",
  api_key: "ijklmnop"
)

user.favorites.create(
  country: "country 1",
  recipe_link: "https://recipe_link_1.com",
  recipe_title: "recipe 1"
)

user.favorites.create(
  country: "country 2",
  recipe_link: "https://recipe_link_2.com",
  recipe_title: "recipe 2"
)