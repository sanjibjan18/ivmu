require 'open-uri'
class UserProfile < ActiveRecord::Base
  belongs_to :user
  #validates_uniqueness_of :display_name

  has_attached_file :profile_image, :styles => { :thumb=> "100x100#", :small  => "150x150>" }
  attr_accessor :profile_image_url

  before_validation :download_remote_image, :if => :image_url_provided?

  def image_url_provided?
    !self.profile_image_url.blank?
  end

  def download_remote_image
    self.profile_image = do_download_remote_image
  end

  def do_download_remote_image
    io = open(URI.parse(profile_image_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

end

