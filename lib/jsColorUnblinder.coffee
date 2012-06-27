###
$("*").mouseover(function(e){$(this).css('outline', '4px solid red');e.stopPropagation()})
$("*").mouseout(function(e){$(this).css('outline', '0px');})
$("*").click(function(e){e.preventDefault(); console.log($(this).css('color')); return false;})
###


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
    div = $("<div><div id='colorpicker'></div><input type='submit' value='done' class='x_done'></div>")
    div.css({position:'fixed', top:'50px', right: '50px'})
    $("body").append(div)
    div.find('.x_done').click ->
      $("body").trigger("ColorUblinder:doneChanging")

  addJS: ->
    jsCU.addJavascript('../vendor/farbtastic/farbtastic.js',  'body')

  addCSS: ->
    jsCU.addStylesheet('../vendor/farbtastic/farbtastic.css', 'body')
  destroy: ->
    $("#colorpicker").parent().remove()


class Pointer
  constructor: ->
    @pointerPanel = new PointerPanel()
    $("*").mouseover @colorOutline
    $("*").mouseout @removeOutline
    _choseColor = (e) => @choseColor(e)
    $("*").click _choseColor
    $("body").bind('ColorUnblinder:destroyPointer', ->
      $("*").unbind('click', _choseColor)
    )
  colorOutline: (e)->
    $(this).css('outline', '4px solid red')
    e.stopPropagation()
  removeOutline: (e)->
    $(this).css('outline', '0px')
  choseColor: (e)->
      if $(e.target).hasClass('x_choose')
        $("body").trigger('ColorUnblinder:colorChosen', @pointerPanel.color())
        return false
      e.preventDefault()
      color = $(e.target).css('color')
      console.log(color)
      @pointerPanel.setColor(color)
      false
  destroy: ->
    @pointerPanel.destroy()
    $("*").unbind('mouseover', @colorOutline)
    $("*").unbind('mouseout',  @removeOutline)
    $("body").trigger('ColorUnblinder:destroyPointer')
    @pointerPanel = null

  

class ControlPanel
  constructor: (@content)->
    $("body").append(@css)
    @className = "CU_control_panel"
  template: ->
    """
    <div class="#{@className}"></div>
    """
  css: ->
    """
    <style rel='stylesheet' type='text/css'>
    .CU_control_panel{position:fixed; top:50px; right:50px; width:100px; height:100px; background-color:rgba(0,0,0,0.3)}
    .CU_control_panel .colorwell {width:90px}
    </style>
    """
  render: ->
    $html = $(@template()).html @content.$el
    $("body .#{@className}").remove()
    $("body").append($html)
  destroy: ->
    $("body .#{@className}").remove()

class PointerPanel
  constructor: ->
    @controlPanel = new ControlPanel(@)
    @hexColor= '#000'
    @render()
  el: "<div></div>"
  color: -> Color(@hexColor)
  setColor: (color) ->
    @hexColor = Color(color).hexString()
    @render()
  template: ->
    """
    <input type="text" value="#{@hexColor}" class="colorwell"
           style="background-color:#{@hexColor}; color:#FFF">
    <input type="submit" value="choose" class="x_choose">
    """
  render: ->
    @$el = $(@el).html @template()
    @controlPanel.render()
  destroy: ->
    @$el.remove()
    @controlPanel.destroy()
    

class ColorUnblinder
  constructor: ->
    @addColorLibrary()
    @startChoser()
    $("body").bind "ColorUblinder:doneChanging", =>
      @startChoser()
      @picker.destroy()
      @swapper = null
    
    $("body").bind 'ColorUnblinder:colorChosen', (e, color)=>
      @startChanger(color)
      @pointer.destroy()
    
  startChoser: ->
    @pointer = new Pointer()
  startChanger: (color)->
    @picker = new ColorPicker()
    @swapper = new ColorSwapper(color.rgbString())
    @picker.start (color)=> @changer(color)
  
  changer: (color)->
    @swapper.change_with color

  addColorLibrary: ->
    jsCU.addJavascript('../vendor/color-0.4.1.js', 'body')

window.Pointer = Pointer
window.ControlPanel = ControlPanel
window.PointerPanel = PointerPanel
window.CU = ColorUnblinder
