namespace :db do

  desc "Rescan the directory"
  task rescan: :environment do
    root = Path[Settings.karaoke_dir]
    paths = root/"**/*.{cdg}"

    paths.each do |path|
      p path
      relative_dir = path.dir.gsub(/^#{Regexp.escape(root)}/, '')
      Song.find_or_create_by(basename: path.basename, dir: relative_dir)
    end

  end

  desc "Reimport everything"
  task remigrate: [:drop, :create, :migrate]

end
