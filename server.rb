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

def getsongs
  rescan
  $songs.select { |k,v| k[/\.cdg$/] }.map { |k,v| v.basename }
end

get "/" do
  @song_names = getsongs
  haml :index
end

get "/k/*" do
  # stream do |out|
  #   out << "It's gonna be legen -\n"
  #   sleep 0.5
  #   out << " (wait for it) \n"
  #   sleep 1
  #   out << "- dary!\n"
  # end
  rescan
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