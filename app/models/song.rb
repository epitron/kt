class Song < ActiveRecord::Base

  validates :name, presence: true
  validates :basename, presence: true
  validates :dir, presence: true

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

    results.take(n)
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
      gsub(/^[A-Z]{2,5}([\d-]{2,15}) - /, '').
      gsub(/^Karaoke Hits \d\d\d - \d\d /, '').
      gsub('  ', ' - ').
      gsub(/^\d\d - /, '').
      gsub(/ \[\w+\]$/, '')

    name = name.titlecase if name.upcase == name

    name
  end

end
