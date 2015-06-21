FileInfo =
  init: ->
    return if g.VIEW not in ['index', 'thread'] or !Conf['File Info Formatting']

    Post.callbacks.push
      name: 'File Info Formatting'
      cb:   @node

  node: ->
    return if !@file or @isClone

    oldInfo = $.el 'span', {className: 'fileText-original'}
    $.prepend @file.link.parentNode, oldInfo
    $.add oldInfo, [@file.link.previousSibling, @file.link, @file.link.nextSibling]

    info = $.el 'span', {className: 'file-info'}
    FileInfo.format Conf['fileInfo'], @, info
    $.prepend @file.text, info

    if Conf['Remove Original Link'] and not (@board.ID is 'f' and Conf['Enable Native Flash Embedding'])
      {parentNode} = @file.link
      $.rmAll parentNode
      $.add parentNode, info
    else
      @file.link.previousSibling.nodeValue = ''
      @file.link.hidden = true
      {nextSibling} = @file.link
      wrapper = $.el 'span', {hidden: true}
      $.replace nextSibling, wrapper
      $.add wrapper, nextSibling
      $.after wrapper, info

  format: (formatString, post, outputNode) ->
    output = []
    formatString.replace /%(.)|[^%]+/g, (s, c) ->
      output.push if c of FileInfo.formatters
        FileInfo.formatters[c].call post
      else
        <%= html('${s}') %>
      ''
    $.extend outputNode, <%= html('@{output}') %>

  formatters:
    t: -> <%= html('${this.file.url.match(/[^\/]*$/)[0]}') %>
    T: -> <%= html('<a href="${this.file.url}" target="_blank">&{FileInfo.formatters.t.call(this)}</a>') %>
    l: -> <%= html('<a href="${this.file.url}" target="_blank">&{FileInfo.formatters.n.call(this)}</a>') %>
    L: -> <%= html('<a href="${this.file.url}" target="_blank">&{FileInfo.formatters.N.call(this)}</a>') %>
    n: ->
      fullname  = @file.name
      shortname = Build.shortFilename @file.name, @isReply
      if fullname is shortname
        <%= html('${fullname}') %>
      else
        <%= html('<span class="fnswitch"><span class="fntrunc">${shortname}</span><span class="fnfull">${fullname}</span></span>') %>
    N: -> <%= html('${this.file.name}') %>
    p: -> <%= html('?{this.file.isSpoiler}{Spoiler, }') %>
    s: -> <%= html('${this.file.size}') %>
    B: -> <%= html('${Math.round(this.file.sizeInBytes)} Bytes') %>
    K: -> <%= html('${Math.round(this.file.sizeInBytes/1024)} KB') %>
    M: -> <%= html('${Math.round(this.file.sizeInBytes/1048576*100)/100} MB') %>
    r: -> <%= html('${this.file.dimensions || "PDF"}') %>
    g: -> <%= html('?{this.file.tag}{, ${this.file.tag}}{}') %>
    '%': -> <%= html('%') %>
