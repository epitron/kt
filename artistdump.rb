#
# NOTE: Using lazy parser version: https://github.com/ezkl/sax-machine
#
require 'lazy-sax-machine'

class Name
  include SAXMachine

  element :name

  def to_h
    name
  end
end

class Artist
  include SAXMachine

  QUALITY = {
      "Complete and Correct" => 1,
      "Correct"              => 2,
      "Needs Vote"           => 3,
      "Needs Minor Changes"  => 4,
      "Needs Major Changes"  => 5,
      "Entirely Incorrect"   => 6,
  }  

  element :name
  element :data_quality

  def data_quality=(val)
    @data_quality = QUALITY[val]
  end

  elements :aliases, :class => Name
  elements :namevariations, :as => :variations, :class => Name
end

class Doc
  include SAXMachine
  elements :artist, :lazy => true, :as => :artists, :class => Artist
end

doc = Doc.parse(open("discogs_20150301_artists.xml"), :lazy => true)
# p doc.artists.take(10000).map(&:data_quality).uniq

doc.artists.each do |a|
  p a.to_h
end

