class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    r = Random.new
    redirect = r.rand(0..4) > 0
    redirect = (params[:sort] != session[:sort] or params[:ratings] != session[:ratings] )
    
    [:checked, :ratings, :sort].each do |i|
      params[i] = session[i] if params[i] == nil
      session[i] = params[i] if params[i] != nil
    end
    params[:checked] = params[:ratings]
    params[:checked] = {} if params[:ratings] == nil
    #
    rates = []
    rates = params[:ratings].keys unless params[:ratings] == nil
    #
    @movies = Movie.find_all_by_rating( rates )# if params[:sort] == nil
    @movies = Movie.find_all_by_rating( rates, :order => 'title') if params[:sort] == 'title'
    @movies = Movie.find_all_by_rating( rates, :order => 'release_date') if params[:sort] == 'date'
    ##
    params[:title_css] = params[:date_css] = 'None'
    params[:title_css] = 'hilite' if params[:sort] == 'title'
    params[:date_css]  = 'hilite' if params[:sort] == 'date'
    redirect_to :action => 'index', :sort => params[:sort], :ratings => params[:ratings] if redirect
    #render :action => 'index', :params => params
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
