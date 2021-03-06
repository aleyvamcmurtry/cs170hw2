class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  #hw2 part 2
  #if the user sets new rating parameters, sort into a hash and place 
  #into an array
  #if there already exists rating parameters, leave them
  #if there is no rating parameters, show all movies with all ratings
  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings]
	    @ratings_hash = params[:ratings]
	    @ratings_array = params[:ratings].keys
	    session[:ratings] = @ratings_hash
    elsif session[:ratings] 
	    flash.keep
	    redirect_to params.merge(:ratings => session[:ratings])
    else
	    @ratings_hash = {}
	    @ratings_array = @all_ratings
    end 
    #hw2 part 1.b 
    #if someone clicks on title, sorts and highlights
    #if someone clicks on release date, sorts and hightlights
    if params[:sort_param]
	session[:sort_param] = params[:sort_param]
	if (params[:sort_param] == "title")
		@title_header_class = 'hilite'
	elsif (params[:sort_param] == "release_date")
		@release_date_header_class = 'hilite'
	end
    elsif session[:sort_param] && params[:ratings]
	    flash.keep
      redirect_to params.merge(:sort_param => session[:sort_param])
    end

   @movies = Movie.find_all_by_rating(@ratings_array, :order => session[:sort_param])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
