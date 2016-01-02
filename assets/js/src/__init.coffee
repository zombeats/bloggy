'use strict'

window.Bloggy = Bloggy =
  version: '0.0.0'
  is: (property, value) -> this.app.dataset[property] is value
  app: do -> document.body

  context: ->
    # get the context from the first class name of body
    # https://github.com/TryGhost/Ghost/wiki/Context-aware-Filters-and-Helpers
    className = document.body.className.split(' ')[0].split('-')[0]
    if className is '' then 'error' else className

  device: ->
    w = window.innerWidth
    h = window.innerHeight
    return 'mobile' if (w <= 480)
    return 'tablet' if (w <= 1024)
    'desktop'
    
$ ->
  $(feature_one_selector).attr('id', 'feature-one')
  $(feature_two_selector).attr('id', 'feature-two')
