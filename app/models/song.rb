class Song < ActiveRecord::Base

  validates :name,      presence: true
  validates :basename,  presence: true
  validates :dir,       presence: true

  before_validation do
    if name.blank?
      self.name = cleaned_name
    end
  end

  ##############################################################

  def self.search(words, limit=100)
    words = [words].flatten
    result = limit(limit)

    words.each do |word|
      result = result.where("LOWER(name) LIKE LOWER(?)", "%#{word}%")
    end

    result
  end
  
  def self.random(n=100)
    return Song.all if Song.count < n
    
    max = Song.maximum(:id)

    remaining = n

    results = []
    used_ids = Set.new

    while remaining > 0
      ids = []
      (remaining*1.2).to_i.times do
        r = rand(max)
        ids << r unless used_ids.include? r
      end

      results += Song.where(id: ids)

      remaining = n - results.size

      used_ids.merge(ids)
    end

    results.take(n).shuffle
  end


  def self.normalize_dir(songs)
    #
    # Steps:
    # 1. Remove known prefixes
    # 2. Remove numeric prefixes that are common between songs
    # 3. Split the records into artist/title
    # 4. Detect which field is the artist
    #

    split_songs = songs.map { |s| s.basename.split(/ - /) }
    require 'artist_detector'
    $ad ||= ArtistDetector.new

    detected = split_songs.map do |chunks|
      chunks.map { |c| $ad[c] }
    end
    
    split_songs.zip(detected).map {|s,d| s.zip(d) }
  end

  def self.clean_names!
    Song.all.group_by(&:dir).each do |dir, songs|
      p normalize_dir(songs)
    end

    nil
  end

  ##############################################################

  def path
    "#{dir} / #{basename}"
  end

  def cdg
    Path[Settings.karaoke_dir]/dir/(basename+".cdg")
  end

  def mp3
    Path[Settings.karaoke_dir]/dir/(basename+".mp3")
  end

  ##############################################################

  def cleaned_name
    name = basename.
      gsub(/^[A-Z]{2,5}([\d-]{2,15})\.?( - )?/i, '').
      gsub(/^Karaoke Hits \d\d\d - \d\d /, '').
      gsub(/^Track \d\d /, '').
      gsub('  ', ' - ').
      gsub(/^\d\d - /, '').
      gsub(/ \[\w+\]$/, '')

    name = name.titlecase if name.upcase == name or name.downcase == name

    name
  end

end
