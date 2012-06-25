window.jsCU = {}
jsCU.wrong_color = "rgb(248, 74, 6)"
jsCU.right_color = "rgb(0, 128, 0)"
jsCU.addJavascript = (jsname,pos) ->
  th = document.getElementsByTagName(pos)[0]
  s = document.createElement('script')
  s.setAttribute('type','text/javascript')
  s.setAttribute('src',jsname)
  th.appendChild(s)
jsCU.addStylesheet = (cssname,pos) ->
  th = document.getElementsByTagName(pos)[0]
  s = document.createElement('link')
  s.setAttribute('type','text/css')
  s.setAttribute('rel','stylesheet')
  s.setAttribute('href',cssname)
  th.appendChild(s)


class ColorSwapper
  constructor: (@conflict_color) ->
    @conflictive_elements = @findByColor(@conflict_color)

  change_with: (new_color) ->
    rgbColor = "#{Color(new_color).rgbString()}"
    @changeColors(rgbColor)

  findByColor: (color)->
    $("*").filter ->
      $(this).css('color') == color

  changeColors: (color) ->
    @conflictive_elements.css('color', color)


class ColorPicker
  constructor: ->
    @addPlaceholder()
    @addJS()
    @addCSS()

  start: (callback)->
    @_startWhenReady(callback)

  _startWhenReady: (callback) ->
    if (typeof $.farbtastic != 'undefined')
      $('#colorpicker').farbtastic(callback)
    else
      tryAgain = => @_startWhenReady(callback)
      setTimeout tryAgain ,100

  addPlaceholder: ->
    div = $("<div id='colorpicker'></div>")
    div.css({position:'absolute', top:'50px', right: '50px'})
    $("body").append(div)

  addJS: ->
    jsCU.addJavascript('../vendor/farbtastic/farbtastic.js',  'body')

  addCSS: ->
    jsCU.addStylesheet('../vendor/farbtastic/farbtastic.css', 'body')




class ColorUnblinder
  constructor: ->
    @addColorLibrary()
    @picker = new ColorPicker()
    @swapper = new ColorSwapper(jsCU.wrong_color)
    @picker.start (color)=> @changer(color)
  
  changer: (color)->
    @swapper.change_with color

  addColorLibrary: ->
    jsCU.addJavascript('../vendor/color-0.4.1.js', 'body')


window.CU = ColorUnblinder
