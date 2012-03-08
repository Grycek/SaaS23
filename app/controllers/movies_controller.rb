class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    params[:checked] = params[:ratings]
    params[:checked] = {} if params[:ratings] == nil
    
    rates = []
    rates = params[:ratings].keys unless params[:ratings] == nil
    ##
    @movies = Movie.find_all_by_rating( rates )# if params[:sort] == nil
    @movies = Movie.find_all_by_rating( rates, :order => 'title') if params[:sort] == 'title'
    @movies = Movie.find_all_by_rating( rates, :order => 'release_date') if params[:sort] == 'date'
    ##
    
    
    params[:title_css] = params[:date_css] = 'None'
    params[:title_css] = 'hilite' if params[:sort] == 'title'
    params[:date_css]  = 'hilite' if params[:sort] == 'date'
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
