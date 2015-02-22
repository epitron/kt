require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'epitools/path'

set :server, :thin
set :bind, '0.0.0.0'

$songroot = Path["~/ktorr"]
$files = {} # filename => fullpath mapping

Song = Struct.new(:path)

class Song

  def name
    @name ||= begin
      name = path.basename.dup
      name.gsub!(/^[A-Z]{2,5}\d{2,5}-\d{1,4} - /, '')
      name.gsub!(/ \[\w+\]$/, '')
      name.gsub!(/ Wvocal /, ' ')

      name
    end
  end

  def basename
    path.basename
  end

end

def rescan
  $files = $songroot.ls_r(true).map { |path| [path.filename, path] if path.file? }.compact.to_h
  puts "===> #{$files.size} songs found"
end

def all_songs
  rescan
  $files.map { |name, path| Song.new(path) if path.ext == "cdg" }.compact.sort_by(&:name)
end

get "/" do
  @songs = all_songs
  haml :index
end

get "/k/*" do
  filename = params["splat"].first

  if path = $files[filename]
    stream do |out|
      path.each_chunk do |chunk|
        out << chunk
      end
    end
  else
    status 404
  end
end
