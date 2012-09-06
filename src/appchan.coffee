Style =
  init: ->
    @addStyle()

  emoji: (position, direction) ->
    css = ''
    for item in Emoji
      name  = item[0]
      image = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAA' + item[1]
      css   = css + '
a.useremail[href*="' + name + '"]:last-of-type::' + position + ',
a.useremail[href*="' + name.toLowerCase() + '"]:last-of-type::' + position + ',
a.useremail[href*="' + name.toUpperCase() + '"]:last-of-type::' + position + ' {
  content: url("' + image + '") " ";
  margin-' + direction + ': 4px !important;
}
'
    return css

  rice: (checkbox)->
    $.addClass checkbox, 'riced'
    div = $.el 'div',
      className: 'rice'
    $.after checkbox, div
    if div.parentElement.tagName.toLowerCase() != 'label'
      $.on div, 'click', ->
        checkbox.click()

  noderice: (post) ->
    if checkbox = $('[type=checkbox]:not(.riced)', post.root)
      Style.rice checkbox

  allrice: ->
    checkboxes = $$('[type=checkbox]:not(.riced)', d.body)
    for checkbox in checkboxes
      Style.rice checkbox

  agent: ->
    switch $.engine
      when 'gecko'
        return '-moz-'
      when 'webkit'
        return '-webkit-'
      when 'presto'
        return '-o-'

  addStyle: ->
    $.off d, 'DOMNodeInserted', Style.addStyle
    theme = Themes[Conf['theme']]
    if d.head
      if existingStyle = $.id 'appchan'
        $.rm existingStyle
      $.addStyle Style.css(theme), 'appchan'
    else # XXX fox
      $.on d, 'DOMNodeInserted', Style.addStyle

  remStyle: ->
    $.off d, 'DOMNodeInserted', @remStyle
    if d.head and d.head.childNodes.length > 10
      headNodes = d.head.childNodes
      headNode = headNodes.length - 1
      for node, index in headNodes
        current = headNodes[headNode - index]
        if current.nodeType == 1
          if (current.rel == 'stylesheet' or current.rel == 'alternate stylesheet' or current.tagName.toLowerCase() == 'style') and current.id != 'appchan'
            $.rm current
    else # XXX fox
      $.on d, 'DOMNodeInserted', @remStyle