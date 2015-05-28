$(document).ready ->

  # Initialize the CDG player
  CDG_Player_init 'cdg_audio', 'cdg_canvas', 'cdg_border', 'cdg_status'

  #################################################
  # Animated "Karaoke Time!" banner
  #################################################

  canvas   = $("#cdg_canvas")[0]
  ctx      = canvas.getContext("2d")
  ctx.font = "italic 70px Comic Sans MS"

  gradient_colors = [
    {hex: "#FF0000", percent: 0},
    {hex: "#FFFF00", percent: 1/6},
    {hex: "#00FF00", percent: 2/6},
    {hex: "#2222FF", percent: 3/6},
    {hex: "#00FFFF", percent: 4/6},
    {hex: "#FF00FF", percent: 5/6},
    {hex: "#FF0000", percent: 1}
  ]

  banner_visible = true

  animate_banner = ->
    ctx.fillStyle = "#000000"
    ctx.fillRect(0, 0, canvas.width, canvas.height)

    gradient = ctx.createLinearGradient(canvas.width/2, 0, canvas.width/2, canvas.height)

    for color in gradient_colors
      gradient.addColorStop(color.percent, color.hex)
      color.percent += 0.015
      color.percent -= 1 if color.percent > 1

    ctx.fillStyle = gradient
    ctx.fillText("Karaoke", 20, 70)
    ctx.fillText("Time!", 50, 160)

    window.setTimeout(animate_banner, 40) if banner_visible

  animate_banner()


  #################################################
  # Play a song
  #################################################

  set_title = (title, alt)->
    $('#song-title').text(title).attr("title", alt)

  play = (id, title, alt)->
    banner_visible = false

    # history.pushState({}, '', "/songs/#{id}")
    location.hash = id

    # if title?
    #   set_title title, alt
    # else
    #   $.getJSON "/songs/#{id}.json", (song)->
    #     set_title song.name, "#{song.dir} / #{song.basename}"

    $.get "/songs/#{id}", (data)->
      $("#caption").html(data)


    # Load up the CDG/MP3 in the player
    CDG_play_song(id)


  if location.hash.match /^#\d+/
    play(location.hash.slice(1))

  #################################################
  # Search
  #################################################

  search_field = $('#search-field')
  search_field.focus()

  #
  # Search-as-you-type
  #
  search_field.on 'input', $.throttle 200, ->
    query = $(this).val()

    url = "/songs"

    if query.length > 0
      url += "?search=#{query}"

    $.get url, (data)->
      $("#search-list").html(data)


  clear_search = ->
    search_field.val('')
    search_field.trigger('input')

  $("#clear-search").click(clear_search)

  #
  # Pick a song from the results
  #
  $('#search-list').on 'click', 'li', ->
    elem = $(this)
    # # Un-highlight the previously playing song
    # if last_playing != null
    #   last_playing.removeClass 'playing'

    # # Highlight the currently playing song
    $("#search-list li").removeClass 'playing'
    elem.addClass 'playing'

    play elem.attr('song_id'), elem.text(), elem.data("path")


  #################################################
  # Thumbs
  #################################################

  thumb_clicked = (e)-> 
    e.preventDefault()
    url = $(this).attr("href") 

    console.log("thumb: #{url}")

    $.get url, (data)->
      $("#thumbs").html(data)

  $(document).on 'click', '#thumbs .up a',   thumb_clicked
  $(document).on 'click', '#thumbs .down a', thumb_clicked

  #################################################
  # Keyboard stuff
  #################################################

  $('body').keydown (e) ->
    if e.keyCode == 27
      clear_search()

    if !search_field.is(':focus')
      search_field.focus()

  # selected = null

  # results = ->
  #   $ '#search-list li:visible'

  # select_next = ->
  #   if selected and selected.is(':visible')
  #     n = selected.next(':visible')
  #     if n.length and n.length > 0
  #       selected.removeClass 'selected'
  #       n.addClass 'selected'
  #       selected = n
  #   else
  #     selected = results().first()
  #     selected.addClass 'selected'

  # select_prev = ->
  #   if selected and selected.is(':visible')
  #     n = selected.prev(':visible')
  #     if n.length and n.length > 0
  #       selected.removeClass 'selected'
  #       n.addClass 'selected'
  #       selected = n
  #   else
  #     selected = results().first()
  #     selected.addClass 'selected'

  # search_field.keydown (e) ->
  #   # console.log(e, event.keyIdentifier);
  #   # arrow:
  #   #
  #   switch event.keyIdentifier
  #     when 'Down'
  #       e.preventDefault()
  #       console.log 'down'
  #       select_next()
  #     when 'Up'
  #       e.preventDefault()
  #       console.log 'up'
  #       select_prev()
  #     when 'Enter'
  #       e.preventDefault()
  #       console.log 'enter'
  #       if selected
  #         selected.click()
  #         selected = null
  #     when 'U+001B'
  #       # ESC
  #       e.preventDefault()
  #       console.log 'esc'
  #       clear_search()
  #     else
  #       return
  #     # Quit when this doesn't handle the key event.
  #   return
  # return

