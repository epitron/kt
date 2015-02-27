namespace :db do

  desc "Rescan the directory"
  task rescan: :environment do
    root = Path[Settings.karaoke_dir]
    paths = root/"**/*.{cdg,mp3}"

    hashes = paths.map do |path|
      p path
      relative_dir = path.dir.gsub(/^#{Regexp.escape(root)}/, '')
      # Song.find_or_create_by()
      {basename: path.basename, dir: relative_dir}
    end

    puts "Creating songs.."

    Song.create(hashes)
  end

  desc "Reimport everything"
  task remigrate: [:drop, :create, :migrate]

end