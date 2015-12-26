'use strict'

window.Itch = Itch =
  version: '0.0.0'
  is: (property, value) -> this.app.dataset[property] is value
  app: do -> document.body

$ ->
  Itch.context = ->
    # get the context from the first class name of body
    # https://github.com/TryGhost/Ghost/wiki/Context-aware-Filters-and-Helpers
    className = document.body.className.split(' ')[0].split('-')[0]
    if className is '' then 'error' else className

  Itch.device = ->
    w = window.innerWidth
    h = window.innerHeight
    return 'mobile' if (w <= 480)
    return 'tablet' if (w <= 1024)
    'desktop'

# jQuery.smartresize
`!function(n,r){var t;t=function(n,r,t){var i;return i=void 0,function(){var e,u,a;a=this,e=arguments,u=function(){t||n.apply(a,e),i=null},i?clearTimeout(i):t&&n.apply(a,e),i=setTimeout(u,r||100)}},jQuery.fn[r]=function(n){return n?this.bind("resize",t(n)):this.trigger(r)}}(jQuery,"smartresize");`
