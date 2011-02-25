# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

user = User.create(:email => 'admin@muvi.in')
user.password = user.password_confirmation = 'password'
user.is_admin = true
user.build_user_profile(:display_name => 'admin')
user.save(false)

