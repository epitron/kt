# TODOs:

## Pending:

* Karaoke "Rooms"
  - each room has a playlist
* Turn search into a modal that only pops up when you start typing, and disappears when you pick a song
* Song identifier
  - Chop filename into pieces
  - Run bloom filter over it to identify titles/artists (artists take priority)
  - Put a SHA1 on the xattrs
* Queue/browser interface
* Group songs by subdirectory
* Ratings
  - simple version: a button below the song title
  - song rating vs. music production rating
  - flag as shitty
* Database
  - consistency through never renaming files, or xattr id's (SHA1's?)
  - ratings, fixed titles, collection, producer (sunfly, etc.)
* Duplicate titles (add a suffix?)
* Synchronize karaoke sessions between multiple devices (for a singer display and an audience display)
* Fullscreen
* Fix mobile bugs
  - song doesn't autostart on android
* Update URL with current song, so users can paste links to each other
* Keep the search field focussed (or use "/" to focus it)
* Smooth image scaler
  - https://en.wikipedia.org/wiki/Image_scaling#Pixel_art_scaling_algorithms
  - https://github.com/yjh0502/hqx-js
  - https://github.com/LeoDutra/js-xBRZ
  - http://sourceforge.net/projects/xbrz/
  - http://www.zachstronaut.com/posts/2012/08/17/webgl-fake-crt-html5.html
  
## Done:
* "Refresh" updates directory listings
