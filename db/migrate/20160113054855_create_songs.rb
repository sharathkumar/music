class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
    	t.integer :album_id
    	t.string :title
      t.has_attached_file :audio
      t.timestamps null: false
    end
  end
end
