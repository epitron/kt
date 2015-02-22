#!/usr/bin/env ruby

#######################################################################################################
# Requires
#######################################################################################################

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/xsendfile'
require 'haml'
require 'epitools' # for the "Path" class

#######################################################################################################
# Configuration
#######################################################################################################

set :server, :thin
set :bind, '0.0.0.0'

configure :production do
  Sinatra::Xsendfile.replace_send_file! # replace Sinatra's send_file with x_send_file
end

#######################################################################################################
# Global variables
#######################################################################################################

$song_directory = Path["~/ktorr/Sunfly Decades Karaoke 70\`s - KaraokeRG"] # Where all the songs come from
$paths          = {}              # A hash of {filename => path}s

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
  time("rescan_files!") do
    $paths = $song_directory.
               ls_r(true).       # List all the files (recursively)
               map { |path| [path.filename, path] if path.file? }. 
               compact.
               to_h
  end          
  puts "===> #{$paths.size} files found"
end

def all_songs
  # TODO: Only refresh the songlist if the directory changed
  rescan_files!
  time("convert to songs") do
    $paths.map { |name, path| Song.new(path.basename) if path.ext == "cdg" }. # convert paths to songs
    compact. # remove "nil" entries from the array
    sort_by { |song| song.name }
  end

end

#######################################################################################################
# Routes
#######################################################################################################

get "/" do
  @songs = all_songs
  haml :index
end

get "/k/*" do
  filename = params["splat"].first

  if path = $paths[filename]
    send_file(path.to_s)
  else
    # status 404
    raise "Error: invalid file"
  end
end
