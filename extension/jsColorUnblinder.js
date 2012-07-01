// Generated by CoffeeScript 1.3.3

/*
$("*").mouseover(function(e){$(this).css('outline', '4px solid red');e.stopPropagation()})
$("*").mouseout(function(e){$(this).css('outline', '0px');})
$("*").click(function(e){e.preventDefault(); console.log($(this).css('color')); return false;})
*/


(function() {
  var ColorPicker, ColorSwapper, ColorUnblinder, ControlPanel, Pointer, PointerPanel;

  window.jsCU = {};

  jsCU.wrong_color = "rgb(248, 74, 6)";

  jsCU.right_color = "rgb(0, 128, 0)";

  jsCU.addJavascript = function(jsname, pos) {
    var s, th;
    th = document.getElementsByTagName(pos)[0];
    s = document.createElement('script');
    s.setAttribute('type', 'text/javascript');
    s.setAttribute('src', jsname);
    return th.appendChild(s);
  };

  jsCU.addStylesheet = function(cssname, pos) {
    var s, th;
    th = document.getElementsByTagName(pos)[0];
    s = document.createElement('link');
    s.setAttribute('type', 'text/css');
    s.setAttribute('rel', 'stylesheet');
    s.setAttribute('href', cssname);
    return th.appendChild(s);
  };

  ColorSwapper = (function() {

    function ColorSwapper(conflict_color) {
      this.conflict_color = conflict_color;
      this.conflictive_elements = this.findByColor(this.conflict_color);
    }

    ColorSwapper.prototype.change_with = function(new_color) {
      var rgbColor;
      rgbColor = "" + (Color(new_color).rgbString());
      return this.changeColors(rgbColor);
    };

    ColorSwapper.prototype.findByColor = function(color) {
      return $("*").filter(function() {
        return $(this).css('color') === color;
      });
    };

    ColorSwapper.prototype.changeColors = function(color) {
      return this.conflictive_elements.css('color', color);
    };

    return ColorSwapper;

  })();

  ColorPicker = (function() {

    function ColorPicker() {
      this.addPlaceholder();
    }

    ColorPicker.prototype.start = function(callback) {
      return this._startWhenReady(callback);
    };

    ColorPicker.prototype._startWhenReady = function(callback) {
      var tryAgain,
        _this = this;
      if (typeof $.farbtastic !== 'undefined') {
        return $('#colorpicker').farbtastic(callback);
      } else {
        tryAgain = function() {
          return _this._startWhenReady(callback);
        };
        return setTimeout(tryAgain, 100);
      }
    };

    ColorPicker.prototype.addPlaceholder = function() {
      var div;
      div = $("<div><div id='colorpicker'></div><input type='submit' value='done' class='x_done'></div>");
      div.css({
        position: 'fixed',
        top: '50px',
        right: '50px'
      });
      $("body").append(div);
      return div.find('.x_done').click(function() {
        return $("body").trigger("ColorUblinder:doneChanging");
      });
    };

    ColorPicker.prototype.addJS = function() {
      return jsCU.addJavascript('../vendor/farbtastic/farbtastic.js', 'body');
    };

    ColorPicker.prototype.addCSS = function() {
      return jsCU.addStylesheet('../vendor/farbtastic/farbtastic.css', 'body');
    };

    ColorPicker.prototype.destroy = function() {
      return $("#colorpicker").parent().remove();
    };

    return ColorPicker;

  })();

  Pointer = (function() {

    function Pointer() {
      var _choseColor,
        _this = this;
      this.pointerPanel = new PointerPanel();
      $("*").mouseover(this.colorOutline);
      $("*").mouseout(this.removeOutline);
      _choseColor = function(e) {
        return _this.choseColor(e);
      };
      $("*").click(_choseColor);
      $("body").bind('ColorUnblinder:destroyPointer', function() {
        return $("*").unbind('click', _choseColor);
      });
    }

    Pointer.prototype.colorOutline = function(e) {
      $(this).css('outline', '4px solid red');
      return e.stopPropagation();
    };

    Pointer.prototype.removeOutline = function(e) {
      return $(this).css('outline', '0px');
    };

    Pointer.prototype.choseColor = function(e) {
      var color;
      if ($(e.target).hasClass('x_choose')) {
        $("body").trigger('ColorUnblinder:colorChosen', this.pointerPanel.color());
        return false;
      }
      e.preventDefault();
      color = $(e.target).css('color');
      console.log(color);
      this.pointerPanel.setColor(color);
      return false;
    };

    Pointer.prototype.destroy = function() {
      this.pointerPanel.destroy();
      $("*").unbind('mouseover', this.colorOutline);
      $("*").unbind('mouseout', this.removeOutline);
      $("body").trigger('ColorUnblinder:destroyPointer');
      return this.pointerPanel = null;
    };

    return Pointer;

  })();

  ControlPanel = (function() {

    function ControlPanel(content) {
      this.content = content;
      $("body").append(this.css);
      this.className = "CU_control_panel";
    }

    ControlPanel.prototype.template = function() {
      return "<div class=\"" + this.className + "\"></div>";
    };

    ControlPanel.prototype.css = function() {
      return "<style rel='stylesheet' type='text/css'>\n.CU_control_panel{position:fixed; top:50px; right:50px; width:100px; height:100px; background-color:rgba(0,0,0,0.3)}\n.CU_control_panel .colorwell {width:90px}\n</style>";
    };

    ControlPanel.prototype.render = function() {
      var $html;
      $html = $(this.template()).html(this.content.$el);
      $("body ." + this.className).remove();
      return $("body").append($html);
    };

    ControlPanel.prototype.destroy = function() {
      return $("body ." + this.className).remove();
    };

    return ControlPanel;

  })();

  PointerPanel = (function() {

    function PointerPanel() {
      this.controlPanel = new ControlPanel(this);
      this.hexColor = '#000';
      this.render();
    }

    PointerPanel.prototype.el = "<div></div>";

    PointerPanel.prototype.color = function() {
      return Color(this.hexColor);
    };

    PointerPanel.prototype.setColor = function(color) {
      this.hexColor = Color(color).hexString();
      return this.render();
    };

    PointerPanel.prototype.template = function() {
      return "<input type=\"text\" value=\"" + this.hexColor + "\" class=\"colorwell\"\n       style=\"background-color:" + this.hexColor + "; color:#FFF\">\n<input type=\"submit\" value=\"choose\" class=\"x_choose\">";
    };

    PointerPanel.prototype.render = function() {
      this.$el = $(this.el).html(this.template());
      return this.controlPanel.render();
    };

    PointerPanel.prototype.destroy = function() {
      this.$el.remove();
      return this.controlPanel.destroy();
    };

    return PointerPanel;

  })();

  ColorUnblinder = (function() {

    function ColorUnblinder() {
      var _this = this;
      this.startChoser();
      $("body").bind("ColorUblinder:doneChanging", function() {
        _this.startChoser();
        _this.picker.destroy();
        return _this.swapper = null;
      });
      $("body").bind('ColorUnblinder:colorChosen', function(e, color) {
        _this.startChanger(color);
        return _this.pointer.destroy();
      });
    }

    ColorUnblinder.prototype.startChoser = function() {
      return this.pointer = new Pointer();
    };

    ColorUnblinder.prototype.startChanger = function(color) {
      var _this = this;
      this.picker = new ColorPicker();
      this.swapper = new ColorSwapper(color.rgbString());
      return this.picker.start(function(color) {
        return _this.changer(color);
      });
    };

    ColorUnblinder.prototype.changer = function(color) {
      return this.swapper.change_with(color);
    };

    ColorUnblinder.prototype.addColorLibrary = function() {
      return jsCU.addJavascript('../vendor/color-0.4.1.js', 'body');
    };

    return ColorUnblinder;

  })();

  window.Pointer = Pointer;

  window.ControlPanel = ControlPanel;

  window.PointerPanel = PointerPanel;

  window.CU = ColorUnblinder;

  console.log("parece que ta todo cargadico");

  new CU();

}).call(this);