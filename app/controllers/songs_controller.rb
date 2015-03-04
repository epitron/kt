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

    respond_to do |format|
      format.mp3  { xsendfile(@song.mp3) }
      format.cdg  { xsendfile(@song.cdg) }
      format.json { render json: @song}
      format.html 
    end
  end

end
