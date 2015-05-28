class SongsController < ApplicationController

  def index
    # @songs = Song.order(:name)
    if params[:search]
      @query = params[:search].split(/\s+/)
      @songs = Song.search(@query).order("score desc")
    else
      @songs = Song.random.sort_by { |s| -(s.score || 0) }
    end

    render @songs if request.xhr?
  end


  def show
    @song = Song.find params[:id]

    respond_to do |format|
      format.html { render partial: "caption" if request.xhr? }
      format.mp3  { xsendfile(@song.mp3) }
      format.cdg  { xsendfile(@song.cdg) }
      format.json { render json: @song}
    end
  end

  def thumbs
    @song = Song.find params[:id]

    up = (params[:direction] == "up")

    if thumb = @song.thumb_for(session.id)
      if thumb.up == up
        thumb.destroy
      else
        thumb.update_attributes(up: up)
      end
    else
      @song.thumbs.create(session_id: session.id, up: up)
    end

    @song.update_score!

    if request.xhr?
      render partial: "thumbs"
    else
      redirect_to "/##{@song.id}"
    end
  end

end
