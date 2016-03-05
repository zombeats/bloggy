'use strict'

window.Bloggy = Bloggy =
  version: '1.1.0'
  is: (k, v=!'undefined') -> this.app.dataset[k] is v
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

Bloggy.app.dataset.page = Bloggy.context()
Bloggy.app.dataset.device = Bloggy.device()

$('#newsletter_form').attr('action', window.newsletter_form) if (window.newsletter_form)
