require 'rails_helper'

RSpec.describe AlbumsController, type: :controller do
  let(:user_credentials) {
    {email: "test@email.com", password: "testpassword"}
  }

  let(:valid_attributes) {
    {name: "album1"}
  }

  let(:invalid_attributes) {
    { name: nil}
  }
  
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = User.create! user_credentials
    sign_in user
  end

  describe "GET #index" do
    it "assigns all albums as @albums" do
      album = Album.create! valid_attributes
      get :index
      expect(assigns(:albums)).to eq([album])
    end
  end

  describe "GET #show" do
    it "assigns the requested album as @album" do
      album = Album.create! valid_attributes
      get :show, {:id => album.to_param}
      expect(assigns(:album)).to eq(album)
    end
  end

  describe "GET #new" do
    it "assigns a new album as @album" do
      get :new, {}
      expect(assigns(:album)).to be_a_new(Album)
    end
  end

  describe "GET #edit" do
    it "assigns the requested album as @album" do
      album = Album.create! valid_attributes
      get :edit, {:id => album.to_param}
      expect(assigns(:album)).to eq(album)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Album" do
        expect {
          post :create, {:album => valid_attributes}
        }.to change(Album, :count).by(1)
      end

      it "assigns a newly created album as @album" do
        post :create, {:album => valid_attributes}
        expect(assigns(:album)).to be_a(Album)
        expect(assigns(:album)).to be_persisted
      end

      it "redirects to the created album" do
        post :create, {:album => valid_attributes}
        expect(response).to redirect_to(Album.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved album as @album" do
        post :create, {:album => invalid_attributes}
        expect(assigns(:album)).to be_a_new(Album)
      end

      it "re-renders the 'new' template" do
        post :create, {:album => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "Album name edited"}
      }

      it "updates the requested album" do
        album = Album.create! valid_attributes
        put :update, {:id => album.to_param, :album => new_attributes}
        album.reload
        expect(album.name).to eq(new_attributes[:name])
      end

      it "assigns the requested album as @album" do
        album = Album.create! valid_attributes
        put :update, {:id => album.to_param, :album => valid_attributes}
        expect(assigns(:album)).to eq(album)
      end

      it "redirects to the album" do
        album = Album.create! valid_attributes
        put :update, {:id => album.to_param, :album => valid_attributes}
        expect(response).to redirect_to(album)
      end
    end

    context "with invalid params" do
      it "assigns the album as @album" do
        album = Album.create! valid_attributes
        put :update, {:id => album.to_param, :album => invalid_attributes}
        expect(assigns(:album)).to eq(album)
      end

      it "re-renders the 'edit' template" do
        album = Album.create! valid_attributes
        put :update, {:id => album.to_param, :album => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested album" do
      album = Album.create! valid_attributes
      expect {
        delete :destroy, {:id => album.to_param}
      }.to change(Album, :count).by(-1)
    end

    it "redirects to the albums list" do
      album = Album.create! valid_attributes
      delete :destroy, {:id => album.to_param}
      expect(response).to redirect_to(albums_url)
    end
  end

end
