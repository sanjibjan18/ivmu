class TweetPolarityController < ApplicationController
 require 'rubygems'
 require 'stemmer'
 require 'classifier'
 def index
   positive = YAML::load_file("/home/ubuntu/scrap/app/controllers/rt-polarity-pos.yml")
   negative = YAML::load_file("/home/ubuntu/scrap/app/controllers/rt-polarity-neg.yml")
   classifier = Classifier::Bayes.new('Positive','Negative')
   Tweet.each do |tt|
    puts  tt.content
   end 
 end
end
