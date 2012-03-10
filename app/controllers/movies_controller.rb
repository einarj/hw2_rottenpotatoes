class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def sort_by
    if session[:sort_by].nil?
      session[:sort_by] = 'id'
    end

    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
    end

    session[:sort_by]
  end

  def ratings_filter

    if params[:ratings]
       session[:ratings_filter] = params[:ratings]
    end

    session[:ratings_filter]
  end

  def index
    sort_by()
    ratings_filter()

    # Restful redirect if needed
    if ((params[:sort_by].nil? and session[:sort_by] != nil) or
        (params[:ratings].nil? and session[:ratings_filter] != nil) )
      red_map = Hash.new
      red_map[:action] = "index"
      red_map[:sort_by] = session[:sort_by]
      red_map[:ratings] = session[:ratings_filter]
      redirect_to red_map
    end

    # Highlight the sort column
    if params[:sort_by] == 'title'
      @title_class = 'hilite'
    elsif params[:sort_by] == 'release_date'
      @release_date_class = 'hilite'
    end

    @all_ratings = Movie.all_ratings

    @ratings = session[:ratings_filter] ? session[:ratings_filter].keys : []
    rate_set = @ratings.empty? ? @all_ratings : @ratings

    @movies = Movie.all(:conditions => [
      "rating IN (:ratings)", {
        :ratings => rate_set
      }
    ],
      :order => session[:sort_by]
    )


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
