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
images_array = ["https://icatcare.org/app/uploads/2018/07/Thinking-of-getting-a-cat.png", "https://cdn.wallpapersafari.com/67/3/NWidYm.jpg", "https://undark.org/wp-content/uploads/2020/02/GettyImages-1199242002-1-scaled.jpg", "https://www.pets4homes.co.uk/images/articles/1232/large/what-a-cats-normal-temperature-should-be-5293ea1039480.jpg", "https://media.istockphoto.com/photos/cute-pedigreed-cat-showing-tenderness-picture-id954622524?k=6&m=954622524&s=612x612&w=0&h=2Ok4zf70WF8yEUv-b20BK3iU-VtNClvc4GiS9OhOtgw=", "https://media.istockphoto.com/photos/cute-newborn-orphaned-kitten-sleeping-in-womans-hand-picture-id1028639650?k=6&m=1028639650&s=612x612&w=0&h=qJuqyMMY4pdbSZARtqhRDwFkvvgLoRBS8iH1CDXcTFc=", "https://media.istockphoto.com/photos/red-kitty-and-bunny-picture-id1164978839?k=6&m=1164978839&s=612x612&w=0&h=__74OMAjoXF8Ruu2K4I8brE7q9-5QdHgLip_MjTjGUY=", "https://media.istockphoto.com/photos/beautiful-cute-striped-kitten-in-hands-on-gray-background-picture-id1167524379?k=6&m=1167524379&s=612x612&w=0&h=KkEiTKegd5NE31_CxkCCj6cCL6BGxeeYWA2J0x8KjvY=", "https://media.istockphoto.com/photos/one-brown-kitten-picture-id1011734362?k=6&m=1011734362&s=612x612&w=0&h=ifuiaQG49YH15nCVfZeYYVUH4WCmDeGf4vbzXkKjDaA=", "https://media.istockphoto.com/photos/little-kitten-in-winter-picture-id1010831222?k=6&m=1010831222&s=612x612&w=0&h=CecaElZKOT7hHX0p9Dfz4FXPBVinI4xIuPoXRu7sVUo=", "https://media.istockphoto.com/photos/row-of-four-maine-coon-cats-kittens-sitting-and-standing-while-in-picture-id947216862?k=6&m=947216862&s=612x612&w=0&h=5aQIx6ziyYnnbWKevutZz-Zmy7HkctfnkA9tN8UgeDI=", "https://media.istockphoto.com/photos/beautiful-gray-kitty-lying-gracefully-on-the-floor-contrast-light-picture-id1153837568?k=6&m=1153837568&s=612x612&w=0&h=GFgtNJ7V7g-RaQ7ucsEH2DrepyZvUlZ5zQRa5LCQTSU=", "https://media.istockphoto.com/photos/adorable-little-kitten-sitting-in-a-wicker-basket-picture-id872973348?k=6&m=872973348&s=612x612&w=0&h=rs1ejFEdH9tMKWKwzjti4kUYAKAV1DJyZ-NeNyKizIE=", "https://media.istockphoto.com/photos/cute-little-kitten-in-orange-daisy-flowers-picture-id859756616?k=6&m=859756616&s=612x612&w=0&h=hKTvx00hSm3M2fA45qAdOoTjW0TB4mFcuX9GEcBepmY=", "https://media.istockphoto.com/photos/redhaired-kitten-look-up-sit-in-the-cupboard-box-picture-id874965784?k=6&m=874965784&s=612x612&w=0&h=hkhA87dB1nFODWNFn5npVjmuUAmLgTIy8DmuYXS-sLs=", "https://media.istockphoto.com/photos/close-up-of-four-kittens-picture-id1197608988?k=6&m=1197608988&s=612x612&w=0&h=40fzT4XyxIlHhMz78ntu3NdNeXfjt3Mji6s2PQGA3VM=", "https://media.istockphoto.com/photos/red-kitten-on-green-grass-picture-id479235264?k=6&m=479235264&s=612x612&w=0&h=LkGEzaTcNrndvD3uD_3KFOAa0QDm22SGpt5iMGpW4NE=", "https://media.istockphoto.com/photos/ginger-red-kitten-on-grass-picture-id1163994198?k=6&m=1163994198&s=612x612&w=0&h=0ZooRdGr2qtYu_0QdxF5WXBl4sXYPKL6Z_BXJdpQtsc=", "https://media.istockphoto.com/photos/bengal-kitten-picture-id890819618?k=6&m=890819618&s=612x612&w=0&h=_F3AxnQLjP42loagqIhUYxT1ixnFLyW6wcbp2Vgp6io=", "https://media.istockphoto.com/photos/kitten-tortoiseshell-color-on-a-clearing-in-the-grass-among-the-picture-id814068520?k=6&m=814068520&s=612x612&w=0&h=2lpw6DFNxrZ3D7dxSXCkVgZplBbfENVnPLuXHW7nWn0=", "https://media.istockphoto.com/photos/little-kittens-are-gray-and-red-selective-focus-picture-id1160365516?k=6&m=1160365516&s=612x612&w=0&h=v25qKB9C8y-DEsm3KVy3E3m8_1dQT_rh-nzArHOWB_E=", "https://media.istockphoto.com/photos/people-feeding-newborn-cute-kitten-cat-by-bottle-of-milk-over-white-picture-id1164719613?k=6&m=1164719613&s=612x612&w=0&h=xJ_QmiYBkdp-lh1FiP3DJY0C6Ben0JujQrfPEPyR_cE=", "https://media.istockphoto.com/photos/cute-kitten-sitting-on-white-fabric-under-sunlight-picture-id929479878?k=6&m=929479878&s=612x612&w=0&h=yB__AV6etUq9cpyO4TVu2H9YQFnjosjsUULWj0U1DjI=", "https://media.istockphoto.com/photos/kitten-in-the-garden-with-flowers-on-background-picture-id825853002?k=6&m=825853002&s=612x612&w=0&h=jGdlctIEvj7j1Eq0BYsoIvEw3WIYnF8-xJH-B1Mmalw=", "https://media.istockphoto.com/photos/kitten-of-red-color-in-a-clearing-in-the-grass-among-yellow-flowers-picture-id810296678?k=6&m=810296678&s=612x612&w=0&h=OCuBAtxtBIVzzx3N3_Tw-LnByKB3s9EABLL05LjSnjM=", "https://media.istockphoto.com/photos/little-kitten-is-lying-on-the-lap-picture-id667340968?k=6&m=667340968&s=612x612&w=0&h=NLkZAHDKdX7XynWMMVCwBD1hbOoTc6i-0jbJt24pNy8=", "https://media.istockphoto.com/photos/little-kitten-plays-under-a-christmas-tree-with-garlands-picture-id899639540?k=6&m=899639540&s=612x612&w=0&h=MMROJemIg_FRnOcQ8CSBcft9Mgm9bo20_HloL6vyWZU=", "https://media.istockphoto.com/photos/small-kitten-with-blue-ayes-on-tree-picture-id920645828?k=6&m=920645828&s=612x612&w=0&h=cwRmhEp3ZnBCnyFbWX-TZooMJZJpfSG6kPxwTFw0vGc="]

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
end

n = images_array.length

n.times do |index|
  item = Item.create(title: "Photo n°#{index + 1}",
                     description: "Photo de chaton(s) fictive créée par seed.",
                     price: Faker::Number.between(from: 1.0, to: 1000.0).round(2),
                     image_url: images_array[index]
                    )
  items_array << item

  #order = Order.new()
  #order.user_id = users_array[index+1].id
  #order.item_id = items_array[index].id
  #order.save
  #orders_array << order
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

#puts "\n#{orders_array.length} orders créées :\n"
#tp Order.all
