;; + function($) {
  "use strict";

  function transitionEnd() {
    var el = document.createElement('bootstrap')
    var transEndEventNames = {
      'WebkitTransition': 'webkitTransitionEnd',
      'MozTransition': 'transitionend',
      'OTransition': 'oTransitionEnd otransitionend',
      'transition': 'transitionend'
    }
    for (var name in transEndEventNames) {
      if (el.style[name] !== undefined) {
        return {
          end: transEndEventNames[name]
        }
      }
    }
  }
  $.fn.emulateTransitionEnd = function(duration) {
    var called = false,
      $el = this
    $(this).one($.support.transition.end, function() {
      called = true
    })
    var callback = function() {
      if (!called) $($el).trigger($.support.transition.end)
    }
    setTimeout(callback, duration)
    return this
  }
  $(function() {
    $.support.transition = transitionEnd()
  })
}(jQuery); + function($) {
  "use strict";
  var Collapse = function(element, options) {
    this.$element = $(element)
    this.options = $.extend({}, Collapse.DEFAULTS, options)
    this.transitioning = null
    if (this.options.parent) this.$parent = $(this.options.parent)
    if (this.options.toggle) this.toggle()
  }
  Collapse.DEFAULTS = {
    toggle: true
  }
  Collapse.prototype.dimension = function() {
    var hasWidth = this.$element.hasClass('width')
    return hasWidth ? 'width' : 'height'
  }
  Collapse.prototype.show = function() {
    if (this.transitioning || this.$element.hasClass('in')) return
    var startEvent = $.Event('show.bs.collapse')
    this.$element.trigger(startEvent)
    if (startEvent.isDefaultPrevented()) return
    var actives = this.$parent && this.$parent.find('> .panel > .in')
    if (actives && actives.length) {
      var hasData = actives.data('bs.collapse')
      if (hasData && hasData.transitioning) return
      actives.collapse('hide')
      hasData || actives.data('bs.collapse', null)
    }
    var dimension = this.dimension()
    this.$element.removeClass('collapse').addClass('collapsing')[dimension](0)
    this.transitioning = 1
    var complete = function() {
      this.$element.removeClass('collapsing').addClass('in')[dimension]('auto')
      this.transitioning = 0
      this.$element.trigger('shown.bs.collapse')
    }
    if (!$.support.transition) return complete.call(this)
    var scrollSize = $.camelCase(['scroll', dimension].join('-'))
    this.$element.one($.support.transition.end, $.proxy(complete, this)).emulateTransitionEnd(350)[dimension](this.$element[0][scrollSize])
  }
  Collapse.prototype.hide = function() {
    if (this.transitioning || !this.$element.hasClass('in')) return
    var startEvent = $.Event('hide.bs.collapse')
    this.$element.trigger(startEvent)
    if (startEvent.isDefaultPrevented()) return
    var dimension = this.dimension()
    this.$element[dimension](this.$element[dimension]())[0].offsetHeight
    this.$element.addClass('collapsing').removeClass('collapse').removeClass('in')
    this.transitioning = 1
    var complete = function() {
      this.transitioning = 0
      this.$element.trigger('hidden.bs.collapse').removeClass('collapsing').addClass('collapse')
    }
    if (!$.support.transition) return complete.call(this)
    this.$element[dimension](0).one($.support.transition.end, $.proxy(complete, this)).emulateTransitionEnd(350)
  }
  Collapse.prototype.toggle = function() {
    this[this.$element.hasClass('in') ? 'hide' : 'show']()
  }
  var old = $.fn.collapse
  $.fn.collapse = function(option) {
    return this.each(function() {
      var $this = $(this)
      var data = $this.data('bs.collapse')
      var options = $.extend({}, Collapse.DEFAULTS, $this.data(), typeof option == 'object' && option)
      if (!data) $this.data('bs.collapse', (data = new Collapse(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }
  $.fn.collapse.Constructor = Collapse
  $.fn.collapse.noConflict = function() {
    $.fn.collapse = old
    return this
  }
  $(document).on('click.bs.collapse.data-api', '[data-toggle=collapse]', function(e) {
    var $this = $(this),
      href
    var target = $this.attr('data-target') || e.preventDefault() || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')
    var $target = $(target)
    var data = $target.data('bs.collapse')
    var option = data ? 'toggle' : $this.data()
    var parent = $this.attr('data-parent')
    var $parent = parent && $(parent)
    if (!data || !data.transitioning) {
      if ($parent) $parent.find('[data-toggle=collapse][data-parent="' + parent + '"]').not($this).addClass('collapsed')
      $this[$target.hasClass('in') ? 'addClass' : 'removeClass']('collapsed')
    }
    $target.collapse(option)
  })
}(jQuery); + function($) {
  "use strict";
  var Modal = function(element, options) {
    this.options = options
    this.$element = $(element)
    this.$backdrop = this.isShown = null
    if (this.options.remote) this.$element.load(this.options.remote)
  }
  Modal.DEFAULTS = {
    backdrop: true,
    keyboard: true,
    show: true
  }
  Modal.prototype.toggle = function(_relatedTarget) {
    return this[!this.isShown ? 'show' : 'hide'](_relatedTarget)
  }
  Modal.prototype.show = function(_relatedTarget) {
    var that = this
    var e = $.Event('show.bs.modal', {
      relatedTarget: _relatedTarget
    })
    this.$element.trigger(e)
    if (this.isShown || e.isDefaultPrevented()) return
    this.isShown = true
    this.escape()
    this.$element.on('click.dismiss.modal', '[data-dismiss="modal"]', $.proxy(this.hide, this))
    this.backdrop(function() {
      var transition = $.support.transition && that.$element.hasClass('fade')
      if (!that.$element.parent().length) {
        that.$element.appendTo(document.body)
      }
      that.$element.show()
      if (transition) {
        that.$element[0].offsetWidth
      }
      that.$element.addClass('in').attr('aria-hidden', false)
      that.enforceFocus()
      var e = $.Event('shown.bs.modal', {
        relatedTarget: _relatedTarget
      })
      transition ? that.$element.find('.modal-dialog').one($.support.transition.end, function() {
        that.$element.focus().trigger(e)
      }).emulateTransitionEnd(300) : that.$element.focus().trigger(e)
    })
  }
  Modal.prototype.hide = function(e) {
    if (e) e.preventDefault()
    e = $.Event('hide.bs.modal')
    this.$element.trigger(e)
    if (!this.isShown || e.isDefaultPrevented()) return
    this.isShown = false
    this.escape()
    $(document).off('focusin.bs.modal')
    this.$element.removeClass('in').attr('aria-hidden', true).off('click.dismiss.modal')
    $.support.transition && this.$element.hasClass('fade') ? this.$element.one($.support.transition.end, $.proxy(this.hideModal, this)).emulateTransitionEnd(300) : this.hideModal()
  }
  Modal.prototype.enforceFocus = function() {
    $(document).off('focusin.bs.modal').on('focusin.bs.modal', $.proxy(function(e) {
      if (this.$element[0] !== e.target && !this.$element.has(e.target).length) {
        this.$element.focus()
      }
    }, this))
  }
  Modal.prototype.escape = function() {
    if (this.isShown && this.options.keyboard) {
      this.$element.on('keyup.dismiss.bs.modal', $.proxy(function(e) {
        e.which == 27 && this.hide()
      }, this))
    } else if (!this.isShown) {
      this.$element.off('keyup.dismiss.bs.modal')
    }
  }
  Modal.prototype.hideModal = function() {
    var that = this
    this.$element.hide()
    this.backdrop(function() {
      that.removeBackdrop()
      that.$element.trigger('hidden.bs.modal')
    })
  }
  Modal.prototype.removeBackdrop = function() {
    this.$backdrop && this.$backdrop.remove()
    this.$backdrop = null
  }
  Modal.prototype.backdrop = function(callback) {
    var that = this
    var animate = this.$element.hasClass('fade') ? 'fade' : ''
    if (this.isShown && this.options.backdrop) {
      var doAnimate = $.support.transition && animate
      this.$backdrop = $('<div class="modal-backdrop ' + animate + '" />').appendTo(document.body)
      this.$element.on('click.dismiss.modal', $.proxy(function(e) {
        if (e.target !== e.currentTarget) return
        this.options.backdrop == 'static' ? this.$element[0].focus.call(this.$element[0]) : this.hide.call(this)
      }, this))
      if (doAnimate) this.$backdrop[0].offsetWidth
      this.$backdrop.addClass('in')
      if (!callback) return
      doAnimate ? this.$backdrop.one($.support.transition.end, callback).emulateTransitionEnd(150) : callback()
    } else if (!this.isShown && this.$backdrop) {
      this.$backdrop.removeClass('in')
      $.support.transition && this.$element.hasClass('fade') ? this.$backdrop.one($.support.transition.end, callback).emulateTransitionEnd(150) : callback()
    } else if (callback) {
      callback()
    }
  }
  var old = $.fn.modal
  $.fn.modal = function(option, _relatedTarget) {
    return this.each(function() {
      var $this = $(this)
      var data = $this.data('bs.modal')
      var options = $.extend({}, Modal.DEFAULTS, $this.data(), typeof option == 'object' && option)
      if (!data) $this.data('bs.modal', (data = new Modal(this, options)))
      if (typeof option == 'string') data[option](_relatedTarget)
      else if (options.show) data.show(_relatedTarget)
    })
  }
  $.fn.modal.Constructor = Modal
  $.fn.modal.noConflict = function() {
    $.fn.modal = old
    return this
  }
  $(document).on('click.bs.modal.data-api', '[data-toggle="modal"]', function(e) {
    var $this = $(this)
    var href = $this.attr('href')
    var $target = $($this.attr('data-target') || (href && href.replace(/.*(?=#[^\s]+$)/, '')))
    var option = $target.data('modal') ? 'toggle' : $.extend({
      remote: !/#/.test(href) && href
    }, $target.data(), $this.data())
    e.preventDefault()
    $target.modal(option, this).one('hide', function() {
      $this.is(':visible') && $this.focus()
    })
  })
  $(document).on('show.bs.modal', '.modal', function() {
    $(document.body).addClass('modal-open')
  }).on('hidden.bs.modal', '.modal', function() {
    $(document.body).removeClass('modal-open')
  })
}(jQuery);
