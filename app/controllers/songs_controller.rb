class SongsController < ApplicationController

  def index
    # @songs = Song.order(:name)
    if query = params[:search]
      @songs = Song.search(query)
    else
      @songs = Song.random
    end

    if request.xhr?
      render @songs
    end
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
