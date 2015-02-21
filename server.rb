require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'epitools/path'

set :server, :thin

$songroot = Path["~/ktorr"]
$songs = {} # filename => fullpath mapping

def rescan
  $songs = $songroot.ls_r(true).select {|song| song.file? }.map { |song| [song.filename, song] }.to_h
  puts "===> #{$songs.size} songs found"
end

def all_songs
  rescan
  $songs.select { |k,v| k[/\.cdg$/] }.map { |k,v| v.basename }
end

get "/" do
  @song_names = all_songs
  haml :index
end

get "/k/*" do
  filename = params["splat"].first

  if path = $songs[filename]
    stream do |out|
      path.each_chunk do |chunk|
        out << chunk
      end
    end
  else
    status 404
  end
end