This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

ruby 2.7.1p83 (2020-03-31 revision a0c7c23c9c) [x86_64-linux]

* Rails version

Rails 5.2.3

* Configuration

rm Kittens_market/Gemfile.lock

$ gem uninstall rails
(=> 3. All versions)

$ gem uninstall railties
(=> 3. All versions => y, then Y)

$ cd Kittens_market

Kittens_market$ bundle install

Kittens_market$ rails -v
(=> Rails 5.2.3)

1. En ce qui concerne l'environnement de développement :

* Database creation

Kittens_market$ RUBYOPT='-W:no-deprecated -W:no-experimental' rails db:create

Kittens_market$ RUBYOPT='-W:no-deprecated -W:no-experimental' rails db:migrate

* Database initialization

Kittens_market$ RUBYOPT='-W:no-deprecated -W:no-experimental' rails db:seed

* How to run the test suite

Kittens_market$ RUBYOPT='-W:no-deprecated -W:no-experimental' rails server (=> http://localhost:3000 )

Le seed a généré les utilisateurs suivants :

Création de l'admin du site : un utilisateur de password "Anonymous", qui a pour email "anonymous@yopmail.com".

Génération plus aléatoire :

Le password du 2-ième utilisateur - de prénom "Salvador", de nom "Hagenes" et d'email "salvador_hagenes@yopmail.com" - créé par ce seed sera : "IyRhNk20".

Le password du 3-ième utilisateur - de prénom "Harrison", de nom "Towne" et d'email "harrison_towne@yopmail.com" - créé par ce seed sera : "5DjCtEq".

Le password du 4-ième utilisateur - de prénom "Julianne", de nom "Prohaska" et d'email "julianne_prohaska@yopmail.com" - créé par ce seed sera : "EoKkQmA5e".

2. En ce qui concerne l'environnement de production :

* Database creation

Kittens_market$ heroku run rails db:migrate

* Deployment instructions

Kittens_market$ heroku ps:scale web=1

* Database initialization

Kittens_market$ heroku run rails db:seed

* How to run the test suite

Kittens_market$ heroku open (=> https://iziteam-thp-kittens-market.herokuapp.com )