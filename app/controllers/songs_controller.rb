class SongsController < ApplicationController

  def index
    # @songs = Song.order(:name)
    @songs = Song.order("RANDOM()").take(50)
  end

  def show
  end

  def get
    basename = params[:basename]
    ext = params[:ext]

    raise unless ext =~ /^(cdg|mp3)$/

    if song = Song.find_by(basename: basename)
      xsendfile(song.send(ext).to_s)
    end
  end

end
