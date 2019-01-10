require_relative('models/star')
require_relative('models/casting')
require_relative('models/movie')

require('pry')

Casting.delete_all()
Star.delete_all()
Movie.delete_all()


star1 = Star.new({'first_name' => 'Drew', 'last_name' => 'Barrymore' })
star1.save()
star1.first_name = 'John'
star1.update()

movie1 = Movie.new({'title' => 'Charlies Angels', 'genre' => 'Action Comedy', 'budget' => 50000000})
movie1.save()
movie1.genre = 'comedy'
movie1.update()

casting1 = Casting.new({'movie_id' => movie1.id, 'star_id' => star1.id, 'fee' => 1000000})
casting1.save()
casting1.fee = 5000
casting1.update()

binding.pry
nil
