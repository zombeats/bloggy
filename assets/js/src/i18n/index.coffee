$ ->
  selectors = [
    # newsletter modal
    '.subscribe-banner'
    '.modal-title'
    '.modal-body p'
    '.modal-body .button-add.wide'
    # default view
    '.read-more'
    '.older-posts'
    '.newer-posts'
    '.poweredby'
    # post view
    'footer .button-add.large.wide'
    'a.post-meta'
    '.prefix-date'
  ]

  for selector in selectors when i18n[selector]
    $(selector).html(i18n[selector])

  # inline css

  css_selector = '.read-next-story .post:before'
  property = "<style>.read-next-story .post:before{ content: '#{i18n[css_selector]}' }</style>"
  $('head').append(property)

  # pagination

  selector = '.page-number'
  pageNumber = $(selector).html().split(' ')
  pageNumberi18n = i18n[selector].split(' ')
  pageNumber[n] = pageNumberi18n[n] for n in [0, 2]
  $(selector).html(pageNumber.join(' '))

  # forms

  selector = 'fieldEmail'
  window[selector].placeholder = i18n[selector]
