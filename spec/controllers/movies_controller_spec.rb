require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe MoviesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Movie. As you add validations to Movie, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {title: "mt", 
     rating: "R",
     description: "some",
     release_date: "1999-03-01",
     director: "d1"}
  }

  let(:invalid_attributes) {
    {title: ""}

  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MoviesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all movies as @movies" do
      movie = Movie.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:movies)).to eq([movie])
    end
    it "orders all movies as @movies" do
      m1 = Movie.create!(title: "t2", rating: "PG", director: "d2")
      m2 = Movie.create!(title: "t5", rating: "R", director: "d2")
      m3 = Movie.create!(title: "t4", rating: "PG", director: "d3")
      get :index, {order_by: 'title'}, valid_session
      expect(response).to redirect_to(movies_path(order_by: :title, ratings: Hash[Movie.uniq.pluck(:rating).map {|r| [r,r]}]))
    end
  end

  describe "GET #similar" do
    it "assigns all movies of the same director as @movies" do
      Movie.create! valid_attributes
      Movie.create!(title: "t2", rating: "PG", director: "d2")
      Movie.create!(title: "t3", rating: "R", director: "d2")
      Movie.create!(title: "t4", rating: "PG", director: "d3")
      dmovies = Movie.where(director: "d2")
      get :similar, {:id => 2}, valid_session
      expect(assigns(:movies)).to eq(dmovies)
    end
    it "redirect_to index page when director is nil" do
      movie = Movie.create!(title: "t2", rating: "PG")
      get :similar, {:id => movie.to_param}
      expect(response).to redirect_to(movies_path)
    end
  end

  describe "GET #show" do
    it "assigns the requested movie as @movie" do
      movie = Movie.create! valid_attributes
      get :show, {:id => movie.to_param}, valid_session
      expect(assigns(:movie)).to eq(movie)
    end
  end

  describe "GET #new" do
    it "response empty" do
      get :new, {}, valid_session
      expect(response.body).to be_empty
    end
  end

  describe "GET #edit" do
    it "assigns the requested movie as @movie" do
      movie = Movie.create! valid_attributes
      get :edit, {:id => movie.to_param}, valid_session
      expect(assigns(:movie)).to eq(movie)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Movie" do
        expect {
          post :create, {:movie => valid_attributes}, valid_session
        }.to change(Movie, :count).by(1)
      end

      it "assigns a newly created movie as @movie" do
        post :create, {:movie => valid_attributes}, valid_session
        expect(assigns(:movie)).to be_a(Movie)
        expect(assigns(:movie)).to be_persisted
      end

      it "redirects to the created movie" do
        post :create, {:movie => valid_attributes}, valid_session
        expect(response).to redirect_to(movies_path)
      end
    end

#    context "with invalid params" do
#      it "assigns a newly created but unsaved movie as @movie" do
#        post :create, {:movie => invalid_attributes}, valid_session
#        expect(assigns(:movie)).to be_a_new(Movie)
#      end

#      it "re-renders the 'new' template" do
#        post :create, {:movie => invalid_attributes}, valid_session
#        expect(response).to render_template("new")
#      end
#    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {title: "new mt", 
         rating: "R",
         description: "some",
         release_date: "1999-03-01",
         director: "d1"}
      }

      it "updates the requested movie" do
        movie = Movie.create! valid_attributes
        put :update, {:id => movie.to_param, :movie => new_attributes}, valid_session
        movie.reload
        expect(movie.title).to eq(new_attributes[:title])
      end

      it "assigns the requested movie as @movie" do
        movie = Movie.create! valid_attributes
        put :update, {:id => movie.to_param, :movie => valid_attributes}, valid_session
        expect(assigns(:movie)).to eq(movie)
      end

      it "redirects to the movie" do
        movie = Movie.create! valid_attributes
        put :update, {:id => movie.to_param, :movie => valid_attributes}, valid_session
        expect(response).to redirect_to(movie)
      end
    end

#    context "with invalid params" do
#      it "assigns the movie as @movie" do
#        movie = Movie.create! valid_attributes
#        put :update, {:id => movie.to_param, :movie => invalid_attributes}, valid_session
#        expect(assigns(:movie)).to eq(movie)
#      end

#      it "re-renders the 'edit' template" do
#        movie = Movie.create! valid_attributes
#        put :update, {:id => movie.to_param, :movie => invalid_attributes}, valid_session
#        expect(response).to render_template("edit")
#      end
#    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested movie" do
      movie = Movie.create! valid_attributes
      expect {
        delete :destroy, {:id => movie.to_param}, valid_session
      }.to change(Movie, :count).by(-1)
    end

    it "redirects to the movies list" do
      movie = Movie.create! valid_attributes
      delete :destroy, {:id => movie.to_param}, valid_session
      expect(response).to redirect_to(movies_url)
    end
  end

end
