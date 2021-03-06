class Song < ActiveRecord::Base

  has_many :thumbs

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
  
  def self.top(limit=100)
    Song.all.where("score > 0").order("score desc").limit(limit)
  end

  def self.random(n=100)
    return [] if n <= 0
    return Song.all.shuffle if Song.count < n
    
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

  ##############################################################

  def html_score
    if score > 0
      "<span class='green'>+#{score}</span>"
    elsif score < 0
      "<span class='red'>#{score}</span>"
    else
      ""
    end.html_safe
  end

  def compute_score
    counts = thumbs.group(:up).count
    (counts[true] || 0) - (counts[false] || 0)
  end

  def update_score!
    update_attributes(score: compute_score)
  end

  def thumb_for(session_id)
    thumbs.find_by(session_id: session_id)
  end

  def nuke!
    cdg.rm
    mp3.rm
    destroy
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
