class Song < ActiveRecord::Base

  before_validation do
    if name.blank?
      self.name = clean_name
    end
  end

  # validates :name, :basename, :dir, presence: true

  def self.search
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
