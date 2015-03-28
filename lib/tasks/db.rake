namespace :db do

  desc "Rescan the directory"
  task rescan: :environment do
    root = Path[Settings.karaoke_dir]
    paths = root/"**/*.cdg"

    paths.each do |path|
      relative_dir = path.dir.gsub(/^#{Regexp.escape(root)}/, '')
      s = Song.find_or_initialize_by(basename: path.basename, dir: relative_dir)
      print '.'

      if s.new_record?
        puts "\n#{path}"
        s.save
      end
    end
  end

  desc "Reimport everything"
  task remigrate: [:drop, :create, :migrate]

end
