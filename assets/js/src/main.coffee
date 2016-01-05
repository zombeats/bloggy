'use strict'

$(window).load ->

  casperFullImg = do ->
    $('img').each ->
      contentWidth = $('.post-content').outerWidth()
      # Width of the content
      imageWidth = $(this)[0].naturalWidth
      # Original image resolution
      method = if imageWidth >= contentWidth then 'addClass' else 'removeClass'
      $(this)[method] 'full-img'

    $(this).smartresize casperFullImg
    $('#newsletter_form').attr('action', window.newsletter_form) if (window.newsletter_form)

$ ->
  el = Bloggy.app
  el.dataset.page = Bloggy.context()
  el.dataset.device = Bloggy.device()

  $('.post-content').fitVids()

  FastClick.attach el unless Bloggy.is 'device', 'desktop'
