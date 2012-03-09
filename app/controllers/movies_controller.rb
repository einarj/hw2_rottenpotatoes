class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.all_ratings
    ratings_filter = params[:ratings].keys unless params[:ratings].nil?
    @ratings = params[:ratings] ? params[:ratings] : []

    @movies = Movie.all(:conditions => [
      "rating IN (:ratings)", {
        :ratings => ratings_filter ? ratings_filter : @all_ratings
      }
    ])

    if params[:sort_by]
      if params[:sort_by] == 'title'
        @title_class = 'hilite'
      elsif params[:sort_by] == 'release_date'
        @release_date_class = 'hilite'
      end
      @movies = @movies.order(params[:sort_by])
    end

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
