$(document).ready ->

  # Initialize the CDG player
  CDG_Player_init 'cdg_audio', 'cdg_canvas', 'cdg_border', 'cdg_status'

  search_field = $('#search-field')

  # Setup the filter-as-you-type search plugin
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

  # The previously clicked song
  last_playing = null

  # Click a song
  $('#search-list').on 'click', 'li', ->
    elem = $(this)
    # Un-highlight the previously playing song
    if last_playing != null
      last_playing.removeClass 'playing'
    # Highlight the currently playing song
    elem.addClass 'playing'
    last_playing = elem
    # Load up the CDG/MP3 in the player
    play_song elem.data('basename')
    # Update the song title
    $('#song-title').text elem.text()
    return



  ## Keyboard shortcuts

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


  $('body').keydown (e) ->
    if e.keyCode == 27
      clear_search()

    if !search_field.is(':focus')
      search_field.focus()

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

