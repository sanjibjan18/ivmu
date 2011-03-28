# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

if User.where('email = ?', 'admin@muvi.in').first.blank?
  user = User.new(:email => 'admin@muvi.in')
  user.password = user.password_confirmation = 'password'
  user.is_admin = true
  user.confirmed_at = Time.now
  user.build_user_profile(:display_name => 'admin')
  user.save(false)
end


Page.create(:title => "What is Muvi", :reference =>'what-is-muvi' ,:usage =>'',   :content => 'What is Muvi')
Page.create(:title => "How do the reviews work", :reference => 'how-do-the-reviews-work' ,:usage =>'',   :content => 'How do the reviews work')
Page.create(:title => "FAQs", :reference =>'faq' ,:usage =>'faq',   :content => 'faq')
Page.create(:title => "Submit a Question", :reference =>'submit-a-question' ,:usage =>'',   :content => 'Submit a Question')
Page.create(:title => "Advertise With Us", :reference =>'advertise-with-us' ,:usage =>'',   :content => 'Advertise With Us')
Page.create(:title => "Investor Relationships", :reference =>'investor-relationships' ,:usage =>'',   :content => 'Investor Relationships')

