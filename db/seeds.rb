require 'faker'
require 'bcrypt'

ActiveRecord::Base.connection.tables.each do |table|
  if table != "ar_internal_metadata" && table != "schema_migrations"
    puts "Resetting auto increment ID for #{table} to 1"
    ActiveRecord::Base.connection.execute("ALTER SEQUENCE #{table}_id_seq RESTART WITH 1")
  end
end
Order.destroy_all
Cart.destroy_all
Item.destroy_all
User.destroy_all

users_array = []
items_array = []
carts_array = []
orders_array = []

Faker::Config.locale = 'en-US'

puts "\nCréation de l'admin du site : un utilisateur de password \"Anonymous\", qui a pour email \"anonymous@yopmail.com\"."

anonymous_user = User.new(email: "anonymous@yopmail.com",
                          encrypted_password: BCrypt::Password.create("Anonymous")
                         )
anonymous_user.save!(:validate => false)
users_array << anonymous_user

puts "\nGénération plus aléatoire :"

n = 3

n.times do |index|
  first_name = Faker::Name.unique.first_name
  last_name = Faker::Name.unique.last_name
  email = "#{first_name.gsub(' ', '').downcase}_#{last_name.gsub(' ', '').downcase}@yopmail.com"
  password = Faker::Internet.password(min_length: 6, max_length: 10)
  puts "\nLe password du #{index + 2}-ième utilisateur - de prénom \"#{first_name.capitalize}\", de nom \"#{last_name.capitalize}\" et d'email \"#{email}\" - créé par ce seed sera : \"#{password}\"."
  user = User.new(email: "#{email}",
                  encrypted_password: BCrypt::Password.create(password)
                 )
  user.save!(:validate => false)
  users_array << user

  item = Item.create( title: "Photo n°#{index + 1}",
                      description: "Photo de chaton(s) fictive créée par seed.",
                      price: Faker::Number.between(from: 1.0, to: 1000.0).round(2),
                      image_url: Faker::Internet.url
                    )
  items_array << item

  order = Order.new()
  order.user_id = users_array[index+1].id
  order.item_id = items_array[index].id
  order.save

  orders_array << order
end

require 'table_print'

tp.set User, :id, :email, :encrypted_password
puts "#{users_array.length} users créés :\n"
tp User.all

tp.set Item, :id,
                {title: {:width => 13}},
                {description: {:width => 70}},
                {price: {:width => 7}},
                {image_url: {:width => 170}}
puts "\n#{items_array.length} photos créées :\n"
tp Item.all

puts "\n#{orders_array.length} orders créées :\n"
tp Order.all