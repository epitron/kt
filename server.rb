#!/usr/bin/env ruby

#######################################################################################################
# Requires
#######################################################################################################

require 'sinatra'
require 'sinatra/xsendfile'
require 'haml'
require 'epitools' # for the "Path" class

#######################################################################################################
# Configuration
#######################################################################################################

# if development?
configure :development do
  require 'sinatra/reloader'  # autoreload this file

  set :server, :thin          # use the "thin" webserver
  set :bind,   '0.0.0.0'      # listen on all addresses
end

configure :production do
  Sinatra::Xsendfile.replace_send_file! # replace Sinatra's send_file with x_send_file
end

#######################################################################################################
# Global variables
#######################################################################################################

$song_directory = Path[ ENV["KARAOKE"] || "~/karaoke" ] # Where all the songs come from
$paths          = {}                                    # A hash of {filename => path}s

#######################################################################################################
# "Models" :)
#######################################################################################################

class Song

  attr_accessor :basename

  def initialize(basename)
    @basename = basename
  end

  # 
  # Clean up the song name (ie: remove the "SFD0901-01" codes from each title)
  #
  def name
    @name ||= begin
      basename.
        gsub(/^[A-Z]{2,5}([\d-]{2,15}) - /, '').
        gsub(/ \[\w+\]$/, '')
    end
  end

  def cdgfile
    basename + ".cdg"
  end

  def audiofile
    basename + ".mp3"
  end

end

#######################################################################################################
# Utility functions
#######################################################################################################

#
# Update the hash of filenames
#
def rescan_files!
  time("rescan files") do
    $paths = $song_directory.
               ls_r(true).       # List all the files (recursively)
               map { |path| [path.filename, path] if path.file? }. 
               compact.
               to_h
  end          
  puts "   ===> #{$paths.size} files found"
end

def all_songs
  # TODO: Only refresh the songlist if the directory changed
  rescan_files!

  # Create Song objects for all the .cdg files
  songs = $paths.map { |name, path| Song.new(path.basename) if path.ext == "cdg" }.compact
  
  songs.sort_by { |song| song.name } # return songs (sorted by their cleaned-up names)
end

#######################################################################################################
# Routes
#######################################################################################################

#
# Render the main page
#
get "/" do
  @songs = all_songs
  haml :index
end

#
# Send an .mp3 or .cdg file to the client
#
get "/k/*" do
  filename = params["splat"].first

  if path = $paths[filename]
    send_file(path.to_s)
  else
    status 404
    "Error: couldn't locate #{filename.inspect}\n"
  end
end

get '/songs.json' do
  content_type :json

  results = all_songs.map do |song|
    {
      name: song.name,
      cdg: "/k/#{song.basename}.cdg",
      mp3: "/k/#{song.basename}.mp3"
    }
  end

  results.to_json
end


rescan_files!
