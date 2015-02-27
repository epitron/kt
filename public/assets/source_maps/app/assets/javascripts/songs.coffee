$(document).ready ->
  # Initialize the CDG player

  results = ->
    $ '#search-list li:visible'

  select_next = ->
    if selected and selected.is(':visible')
      n = selected.next(':visible')
      if n.length and n.length > 0
        selected.removeClass 'selected'
        n.addClass 'selected'
        selected = n
    else
      selected = results().first()
      selected.addClass 'selected'
    return

  select_prev = ->
    if selected and selected.is(':visible')
      n = selected.prev(':visible')
      if n.length and n.length > 0
        selected.removeClass 'selected'
        n.addClass 'selected'
        selected = n
    else
      selected = results().first()
      selected.addClass 'selected'
    return


  CDG_Player_init 'cdg_audio', 'cdg_canvas', 'cdg_border', 'cdg_status'


  # Setup the filter-as-you-type search plugin
  $('#search-field').on 'input', $.throttle 200, ->
    query = $(this).val()

    url = "/songs"

    if query.length > 0
      url += "?search=#{query}"

    $.get url, (data)->
      $("#search-list").html(data)


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

  search_field = $('#search-field')

  $('body').keydown (e) ->
    if !search_field.is(':focus')
      search_field.focus()
    return

  selected = null

  search_field.keydown (e) ->
    # console.log(e, event.keyIdentifier);
    # arrow:
    #
    switch event.keyIdentifier
      when 'Down'
        e.preventDefault()
        console.log 'down'
        select_next()
      when 'Up'
        e.preventDefault()
        console.log 'up'
        select_prev()
      when 'Enter'
        e.preventDefault()
        console.log 'enter'
        if selected
          selected.click()
          selected = null
      when 'U+001B'
        # ESC
        e.preventDefault()
        console.log 'esc'
        search_field.val ''
      else
        return
      # Quit when this doesn't handle the key event.
    return
  return

# function init()
# {
#     // Initialize the CDG player
#     CDG_Player_init("cdg_audio", "cdg_canvas", "cdg_border", "cdg_status");

#     // Setup the filter-as-you-type search plugin
#     $('#search-field').fastLiveFilter('#search-list', {callback: function(total) { $("#total").text(total); }});

#     // The previously clicked song
#     last_playing = null;

#     // Click a song
#     $('#search-list li').click(function() { 
#       var elem = $(this);

#       // Un-highlight the previously playing song
#       if (last_playing !== null)
#         last_playing.removeClass("playing");

#       // Highlight the currently playing song
#       elem.addClass("playing");
#       last_playing = elem;

#       // Load up the CDG/MP3 in the player
#       play_song(elem.data("basename"));

#       // Update the song title
#       $("#song-title").text(elem.text());
#     });

#     var search_field = $('#search-field');

#     $('body').keydown(function(e) {
#       if (!search_field.is(":focus")) {
#         search_field.focus();
#       }
#     });

#     selected = null;

#     function results() {
#       return $("#search-list li:visible");
#     }

#     function select_next() {
#       if (selected && selected.is(":visible")) {
#         var n = selected.next(":visible");
#         if (n.length && n.length > 0) {
#           selected.removeClass("selected");
#           n.addClass("selected");
#           selected = n;
#         }
#       } else {
#         selected = results().first();
#         selected.addClass("selected");
#       }
#     }

#     function select_prev() {
#       if (selected && selected.is(":visible")) {
#         var n = selected.prev(":visible");
#         if (n.length && n.length > 0) {
#           selected.removeClass("selected");
#           n.addClass("selected");
#           selected = n;
#         }
#       } else {
#         selected = results().first();
#         selected.addClass("selected");
#       }
#     }

#     search_field.keydown(function(e) {
#       // console.log(e, event.keyIdentifier);

#       // arrow:
#       // 
#       switch (event.keyIdentifier) {
#         case "Down":
#           e.preventDefault();
#           console.log("down");
#           select_next();
#           break;
#         case "Up":
#           e.preventDefault();
#           console.log("up");
#           select_prev();
#           break;
#         case "Enter":
#           e.preventDefault();
#           console.log("enter");
#           if (selected) {
#             selected.click();
#             selected = null;
#           }
#           break;
#         case "U+001B":
#           // ESC
#           e.preventDefault();
#           console.log("esc");
#           search_field.val('');
#           break;
#         default:
#           return; // Quit when this doesn't handle the key event.
#       }

#     });


# };

