class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
##########################################################
  def index
    if params[:sort_by]
      @sort_by = params[:sort_by]
      session[:sort_by] = params[:sort_by]
		elsif session[:sort_by]
			params[:sort_by] = session[:sort_by]
			flash.keep
			redirect_to movies_path(params) and return
		else
		  @sort_by = nil
		end
		@hilite = sort_by = session[:sort_by]
		@all_ratings = Movie.all_ratings
		if params[:ratings]
		  @ratings = params[:ratings]
			session[:ratings] = params[:ratings]
		elsif session[:ratings]
			params[:ratings] = session[:ratings]
			flash.keep
			redirect_to movies_path(params) and return
		end
		@checked_ratings = (session[:ratings].keys if session.key?(:ratings)) || @all_ratings
    @movies = Movie.order(sort_by).where(rating: @checked_ratings)
  end
##########################################
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
