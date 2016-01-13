class Song < ActiveRecord::Base
	belongs_to :album
	validates :album, :presence => true	
	has_attached_file :audio
	validates_attachment_presence :audio
	validates_attachment_content_type :audio, :content_type => [ 'audio/mp3','audio/mpeg']
	validates_attachment_size :audio, :less_than => 20.megabytes
	
	def self.search(query)
	  joins(:album)
	  .includes(:album)
	  .where(	"lower(title) ilike ? or lower(audio_file_name) ilike ? or lower(albums.name) ilike ?", 
	  				"%#{query.downcase}%", "%#{query.downcase}%", "%#{query.downcase}%")
	end
end
