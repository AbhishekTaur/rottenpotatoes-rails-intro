class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # Part 3
    if params.has_key?(:ratings)
      session[:ratings] = params[:ratings] 
    end
    if params.has_key?(:sort_by)
      session[:sort_by] = params[:sort_by] 
    end
    
    # Part 3
    if session[:sort_by] == "title"
      @title_header = 'hilite' 
    end
    if session[:sort_by] == 'release_date'
      @release_date_header = 'hilite' 
    end
    
    # Part 1
    # @movies = Movie.all.order(params[:sort_by])
    
    # Part 2
    
    @list_ratings = Movie.get_ratings
    
    # @ratings = params[:ratings] ? params[:ratings].keys : Movie.get_ratings
    # @movies      = Movie.where(rating: @ratings).order(params[:sort_by])
    
    # Part 3
    @ratings = session[:ratings] ? session[:ratings].keys : Movie.get_ratings
    @movies      = Movie.where(rating: @ratings).order(session[:sort_by])
    
    
    # Part 3 - If session changes, redirecting the page by calling the movies_path
    unless session[:sort_by] == params[:sort_by] && session[:ratings] == params[:ratings]
      flash.keep
      redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
