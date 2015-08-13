//= require_tree .

// emulate jquery for selecting things
$ = function(q){return document.querySelectorAll(q);};

// Returns true if in an iOS / OS X Webview
inWebview = function(){
  var isInUIwebview = /(iPhone|iPod|iPad).*AppleWebKit(?!.*Safari)/i.test(navigator.userAgent);
  return isInUIwebview;
};

// When in a webview this will trigger a native call
callNative = function(func){
  var args = Array.prototype.slice.call(arguments);

  var url = 'ios:' + func + ':' + args.slice(1).join(':');
  if(inWebview()){
    window.location  = url;
  } else {
    console.log("calling ios native code:" + url);
  }
};

// proxy console if in native
if(inWebview()){
  window.console.log = function(){
    callNative('log', Array.prototype.slice.call(arguments));
  };
}

// Prevent scrolling on the document
window.addEventListener("touchmove", function(event) {
  if (!event.target.classList.contains('scrollable')) {
    event.preventDefault();
  }
}, false);

// var fireCustomEvent = function (name){
//   var data = arguments[1] || [];
//   var event = new Event(name);
//   document.dispatchEvent(event);
// };

// document.addEventListener('test', function (e){
//   console.log("got test", e);
// });


// setTimeout(function(){
//   fireCustomEvent('test');
// },1000);
