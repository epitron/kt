class SongsController < ApplicationController

  def index
    # @songs = Song.order(:name)
    if params[:search]
      @query = params[:search].split(/\s+/)
      @songs = Song.search(@query)
    else
      @songs = Song.random
    end

    if request.xhr?
      render @songs
    end
  end

  def show
    @song = Song.find params[:id]

    case params[:format]
    when "mp3"
      xsendfile(@song.mp3)
    when "cdg"
      xsendfile(@song.cdg)
    else
      render
    end
  end

end
