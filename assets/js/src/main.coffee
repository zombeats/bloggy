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

$ ->
  $('.post-content').fitVids()
  FastClick.attach Bloggy.app unless Bloggy.is 'device', 'desktop'
