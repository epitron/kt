class Song < ActiveRecord::Base

  validates :name, presence: true
  validates :basename, presence: true
  validates :dir, presence: true

  before_validation do
    if name.blank?
      self.name = clean_name
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
  
  if Rails.env.development?
    RAND_FUNC = "RANDOM()"
  else
    RAND_FUNC = "RAND()"
  end

  def self.random(n=150)
    order(RAND_FUNC).take(n)
  end

  def clean_name
    name = basename.
      gsub(/^[A-Z]{2,5}([\d-]{2,15}) - /, '').
      gsub('  ', ' - ').
      gsub(/^\d\d - /, '').
      gsub(/ \[\w+\]$/, '')

    name = name.titlecase if name.upcase == name

    name
  end

  def cdg
    Path[Settings.karaoke_dir]/dir/(basename+".cdg")
  end

  def mp3
    Path[Settings.karaoke_dir]/dir/(basename+".mp3")
  end

end
