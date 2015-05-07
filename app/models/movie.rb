class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date

  #hw 2 part 2
  #method for sorting ratings 
  def Movie.all_ratings
  	Movie.all.map{|movie| movie.rating}.uniq
  end
  
end
