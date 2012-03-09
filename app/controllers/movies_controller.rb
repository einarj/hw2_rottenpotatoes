class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    debugger

    # Restful redirect if needed
    red_map = Hash.new
    if params[:sort_by].nil? and session[:sort_by].nil? == false
      red_map[:sort_by] = session[:sort_by]
    end
    #if params[:ratings].nil? and session[:ratings_filter].nil? == false and session[:ratings_filter].empty? == false
    
      #filt = session[:ratings_filter]
      #filt_map = Hash[*filt.collect { |v| [v, '1'].flatten } ]
      #red_map[:ratings] =  filt_map
    #end

    unless red_map.empty?
      red_map[:action] = "index"
      redirect_to red_map
    end

    # Highlight the sort column
    if params[:sort_by]
      if params[:sort_by] == 'title'
        @title_class = 'hilite'
      elsif params[:sort_by] == 'release_date'
        @release_date_class = 'hilite'
      end

      session[:sort_by] = params[:sort_by]
    end

    @all_ratings = Movie.all_ratings

    if params[:ratings]
      ratings_filter = params[:ratings].keys
      session[:ratings_filter] = ratings_filter
    end
    @ratings = session[:ratings_filter] ? session[:ratings_filter] : []
    rate_set = @ratings.empty? ? @all_ratings : @ratings

    debugger
    @movies = Movie.all(:conditions => [
      "rating IN (:ratings)", {
        #:ratings => @ratings ? @ratings : @all_ratings
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
