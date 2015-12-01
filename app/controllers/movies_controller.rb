class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @order_by = params[:order_by] || session[:order_by]
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    @all_ratings = Movie.uniq.pluck(:rating).select {|r| !(r.nil? or r.blank?)}
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    if params[:order_by] != session[:order_by] or params[:ratings] != session[:ratings]
      session[:order_by] = @order_by
      session[:ratings] = @selected_ratings
      flash.keep
      redirect_to movies_path(ratings: @selected_ratings,
                              order_by: @order_by) and return
    end
    ordering = {@order_by => :asc} if @order_by and !@order_by.blank?
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
  end

  def similar
    @movie = Movie.find(params[:id])
    @movies = @movie.similar
    if @movies.nil?
      flash[:warning] = "'#{@movie.title}' has no director info"
      redirect_to movies_path and return
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
