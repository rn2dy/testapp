(function($) {
  var timer;

  $.fn.src = function(url, onLoad, options) {
    setIFrames($(this), onLoad, options, function() {
      this.src = url;
    });
    return $(this);
  }

  $.fn.squirt = function(content, onLoad, options) {

    setIFrames($(this), onLoad, options, function() {
      var doc = this.contentDocument || this.contentWindow.document;
      doc.open();
      doc.writeln(content);
      doc.close();
    });
    return this;

  }

  function setIFrames(iframes, onLoad, options, iFrameSetter) {
    iframes.each(function() {
      if (this.tagName=="IFRAME") setIFrame(this, onLoad, options, iFrameSetter);
    });
  }

  function setIFrame(iframe, onLoad, options, iFrameSetter) {

    var iframe;
    iframe.onload = null;
    if (timer) clearTimeout(timer);

    var defaults = {
      timeoutDuration: 0,
      timeout: null
    }
    var opts = $.extend(defaults, options);
    if (opts.timeout && !opts.timeoutDuration) opts.timeoutDuration = 60000;

    opts.frameactive = true;
    var startTime = (new Date()).getTime();
    if (opts.timeout) {
      var timer = setTimeout(function() {
        opts.frameactive=false; 
        iframe.onload=null;
        if (opts.timeout) opts.timeout(iframe, opts.timeout);
      }, opts.timeoutDuration);
    };

    var onloadHandler = function() {
      var duration=(new Date()).getTime()-startTime;
      if (timer) clearTimeout(timer);
      if (onLoad && opts.frameactive) onLoad.apply(iframe,[duration]);
      opts.frameactive=false;
    }
    iFrameSetter.apply(iframe);
    iframe.onload = onloadHandler;
    opts.completeReadyStateChanges=0;
    iframe.onreadystatechange = function() { // IE ftw
	    if (++(opts.completeReadyStateChanges)==3) onloadHandler();
    }

    return iframe;

  };

})(jQuery);
