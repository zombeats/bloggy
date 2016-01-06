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

  $(selector).html(i18n[selector]) for selector in selectors

  # forms
  window.fieldEmail.placeholder = i18n.fieldEmail
  window.newsletter_subscribe.value = i18n.newsletter_subscribe

  if Bloggy.is 'page', 'post'
    # read-next inline css
    selector = '.read-next-story .post:before'
    property = "<style>.read-next-story .post:before{ content: '#{i18n[selector]}' }</style>"
    $('head').append(property)
  else
    # pagination
    selector = '.page-number'
    pageNumber = $(selector).html().split(' ')
    pageNumberi18n = window.i18n[selector].split(' ')
    pageNumber[n] = pageNumberi18n[n] for n in [0, 2]
    $(selector).html pageNumber.join(' ')


