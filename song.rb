require 'mongoid'
Mongoid.load!("mongoid.yml")

class Song
  include Mongoid::Document
  field :name, type: String
  field :cdg, type: String
  field :mp3, type: String
  # embedded_in :artist
end
