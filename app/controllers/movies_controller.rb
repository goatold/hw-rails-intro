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
    if !params.has_key? :order_by
      if !session.has_key? :order_by
        session[:order_by] = ''
      end
      need_redir = true
    else
      session[:order_by] = params[:order_by]
    end
    if !params.has_key? :ratings
      if !session.has_key? :ratings
        session[:ratings] = ''
      end
      need_redir = true
    else
      if params[:ratings].class == Array
        session[:ratings] = params[:ratings]
      else
        session[:ratings] = params[:ratings].keys
      end
    end
    if need_redir
      flash.keep
      redirect_to movies_path(ratings: session[:ratings],
                              order_by: session[:order_by])
      return
    end
    @movies = Movie.all
    @all_ratings = Movie.uniq.pluck(:rating)
    if !(session[:order_by].blank?)
      @_order_movies_by = session[:order_by]
      @movies = @movies.order(@_order_movies_by)
    end
    if session[:ratings].empty?
      session[:ratings] = @all_ratings
    end
    @checked_ratings = session[:ratings]
    @movies = @movies.where(:rating => @checked_ratings)
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
