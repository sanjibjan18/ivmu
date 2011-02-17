class Movie < ActiveRecord::Base
  #TODO: setting-up external database. This works but doesn't look nice. try using some plugin.
  $config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
  self.establish_connection  $config["muvi_extract"]
  set_primary_key 'name'
  set_table_name 'films'
   
  acts_as_commentable 
end
