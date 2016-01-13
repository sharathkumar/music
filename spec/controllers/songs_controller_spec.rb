require 'rails_helper'

RSpec.describe SongsController, type: :controller do

  let(:album) { Album.create!( name: "album1") }

  let(:valid_audio) { 
    Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/audio.mp3')), 'audio/mp3')
  }
  let(:invalid_audio) { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg'))) }

  let(:user_credentials) {
    {email: "test@email.com", password: "testpassword"}
  }

  let(:valid_attributes) {
    { title: "song 1", audio: valid_audio, album_id: album.id }
  }

  let(:invalid_attributes) {
    { title: "song 1", audio: invalid_audio }
  }
  
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = User.create! user_credentials
    sign_in user
  end

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all songs as @songs" do
      song = Song.create! valid_attributes
      get :index, {}
      expect(assigns(:songs)).to eq([song])
    end

    it "search songs by album name" do
      song = Song.create! valid_attributes
      get :index, { search: "album1" }
      expect(assigns(:songs)).to eq([song])
    end

    it "search songs by song name" do
      song = Song.create! valid_attributes
      get :index, { search: "song 1" }
      expect(assigns(:songs)).to eq([song])
    end

    it "invalid search" do
      song = Song.create! valid_attributes
      get :index, { search: "test" }
      expect(assigns(:songs)).to eq([])
    end
    
  end

  describe "GET #show" do
    it "assigns the requested song as @song" do
      song = Song.create! valid_attributes
      get :show, {:id => song.to_param}
      expect(assigns(:song)).to eq(song)
    end
  end

  describe "GET #new" do
    it "assigns a new song as @song" do
      get :new, {}
      expect(assigns(:song)).to be_a_new(Song)
    end
  end

  describe "GET #edit" do
    it "assigns the requested song as @song" do
      song = Song.create! valid_attributes
      get :edit, {:id => song.to_param}
      expect(assigns(:song)).to eq(song)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Song" do
        expect {
          post :create, {:song => valid_attributes}
        }.to change(Song, :count).by(1)
      end

      it "assigns a newly created song as @song" do
        post :create, {:song => valid_attributes}
        expect(assigns(:song)).to be_a(Song)
        expect(assigns(:song)).to be_persisted
      end

      it "redirects to the created song" do
        post :create, {:song => valid_attributes}
        expect(response).to redirect_to(Song.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved song as @song" do
        post :create, {:song => invalid_attributes}
        expect(assigns(:song)).to be_a_new(Song)
      end

      it "re-renders the 'new' template" do
        post :create, {:song => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { title: "song name edited", audio: valid_audio, album_id: album.id }
      }

      it "updates the requested song" do
        song = Song.create! valid_attributes
        put :update, {:id => song.to_param, :song => new_attributes}
        song.reload
        expect(song.title).to eq(new_attributes[:title])
      end

      it "assigns the requested song as @song" do
        song = Song.create! valid_attributes
        put :update, {:id => song.to_param, :song => valid_attributes}
        expect(assigns(:song)).to eq(song)
      end

      it "redirects to the song" do
        song = Song.create! valid_attributes
        put :update, {:id => song.to_param, :song => valid_attributes}
        expect(response).to redirect_to(song)
      end
    end

    context "with invalid params" do
      it "assigns the song as @song" do
        song = Song.create! valid_attributes
        put :update, {:id => song.to_param, :song => invalid_attributes}
        expect(assigns(:song)).to eq(song)
      end

      it "re-renders the 'edit' template" do
        song = Song.create! valid_attributes
        put :update, {:id => song.to_param, :song => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested song" do
      song = Song.create! valid_attributes
      expect {
        delete :destroy, {:id => song.to_param}
      }.to change(Song, :count).by(-1)
    end

    it "redirects to the songs list" do
      song = Song.create! valid_attributes
      delete :destroy, {:id => song.to_param}
      expect(response).to redirect_to(songs_url)
    end
  end

end
