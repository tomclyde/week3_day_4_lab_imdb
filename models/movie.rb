require_relative("../db/sql_runner")

class Movie

  attr_accessor :title, :genre, :budget
  attr_reader :id

  def initialize(movie_details)
    @id = movie_details['id'].to_i if movie_details['id']
    @title = movie_details['title']
    @genre = movie_details['genre']
    @budget = movie_details['budget']
  end


  def save()
    sql = "INSERT INTO movies
    (
      title,
      genre,
      budget
    )
    VALUES
    (
      $1, $2, $3
    )
    RETURNING id"
    values = [@title, @genre, @budget]
    movies = SqlRunner.run( sql, values ).first
    @id = movies['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM movies"
    values = []
    movies = SqlRunner.run(sql, values)
    result = movies.map { |movie| Movie.new( movie ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM movies"
    values = []
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "
    UPDATE movies SET (
      title,
      genre,
      budget
    ) =
    (
      $1,$2,$3
    )
    WHERE id = $4"
    values = [@title, @genre, @budget, @id]
    SqlRunner.run(sql,values)
  end

  def stars_in_movie()
    sql = "SELECT stars.*
    FROM stars
    INNER JOIN castings
    ON castings.star_id = stars.id
    WHERE castings.movie_id = $1"
    values = [@id]
    stars = SqlRunner.run(sql, values)
  	result = stars.map { |star| Star.new( star ) }
  	return result
  end

  def remaining_budget()
    sql = "UPDATE movies
    SET budget = budget - (SELECT fee
    FROM castings
    INNER JOIN movies
    ON castings.movie_id = $1)"
    values = [@id]
    SqlRunner.run(sql, values)
  end


end
