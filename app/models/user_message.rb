class UserMessage < ActiveRecord::Base
  validates :message, :presence => true
  validates :email,:presence => true, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

  after_create :send_notification

  def send_notification
    ContactUsMailer.send_contact_us(self).deliver
  end

end

