require_relative("../db/sql_runner")

class Star

  attr_accessor :first_name, :last_name
  attr_reader :id

  def initialize(star_details)
    @id = star_details['id'].to_i if star_details['id']
    @first_name = star_details['first_name']
    @last_name = star_details['last_name']
  end


  def save()
    sql = "INSERT INTO stars
    (
      first_name,
      last_name
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@first_name, @last_name]
    stars = SqlRunner.run( sql, values ).first
    @id = stars['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM stars"
    values = []
    stars = SqlRunner.run(sql, values)
    result = stars.map { |star| Star.new( star ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM stars"
    values = []
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "
    UPDATE stars SET (
      first_name,
      last_name
    ) =
    (
      $1,$2
    )
    WHERE id = $3"
    values = [@first_name, @last_name, @id]
    SqlRunner.run(sql,values)
  end

  def movies_for_stars()
    sql = "SELECT movies.*
    FROM movies
    INNER JOIN castings
    ON castings.movie_id = movies.id
    WHERE castings.star_id = $1"
    values = [@id]
    movies = SqlRunner.run(sql, values)
  	result = movies.map { |movie| Movie.new( movie ) }
  	return result
  end

  
end
