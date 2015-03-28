require 'set'
require 'epitools/zopen'

unless defined? Rails
  require 'pathname'
  class Rails; def self.root; Pathname.new("."); end; end
end

class ArtistDetector

  def [](artist)
    @slugs.include? slugize(artist)
  end

  def slugize(str)
    str.gsub(/[^[:alpha:]\d]+/, '').downcase
  end

  ARTIST_FILE = Rails.root / "data/mb_artists.tsv.xz"
  SLUG_FILE   = Rails.root / "data/artist_slugs.txt"

  attr_accessor :slugs

  def initialize
    generate_slugs! unless SLUG_FILE.file?
    @slugs = Set.new(File.read(SLUG_FILE.to_s).split("\n"))
  end

  def generate_slugs!
    puts "Generating slugs..."
    open(SLUG_FILE.to_s, "w") do |f|
      all_artists.map { |a| slugize(a) }.uniq.each { |a| f.puts a }
    end
  end

  def all_artists
    Enumerator.new do |y|
      zopen(ARTIST_FILE.to_s).each_line do |line|
        a,b = line.split("\t")[2..3]
        y << a
        y << b unless a == b
      end
    end
  end

end


if __FILE__ == $0
  a = ArtistDetector.new
  p a["Weird Al Yankovic"]
end