var Steps = {
  steps: [],
  at: -1,

  init: function(){
    this.steps = $('.step');
    this.showNextStep();
  },

  hideAllSteps: function(){
    for(var i = 0; i < this.steps.length; i++){
      this.steps[i].classList.add('hidden');
      this.steps[i].classList.remove('active');
    }
  },

  showNextStep: function(){
    if(this.at < this.steps.length -1){
      this.at = this.at+ 1;
      this.hideAllSteps();
      this.steps[this.at].classList.remove('hidden');
      this.steps[this.at].classList.add('active');
      callNative('step', this.at);
    }
  }

};

// Get the text on the page to speak
var Speaker = {
  isSpeaking: false,

  speak: function(){
    var allParagraphs = $('.step.active p');
    var textToSay = '';
    for(var i = 0; i < allParagraphs.length; i++){
      textToSay += allParagraphs[i].innerHTML.replace(/[^A-Za-z0-9\.,\ ]/g,'') + "\n";
    }
    callNative('say',textToSay);
  }
};

document.addEventListener("DOMContentLoaded", function(event) {
  Steps.init();

  console.log("initializing!");
  var nextButtons = $('button.next');
  for(var i = 0; i < nextButtons.length; i++){
    var button = nextButtons[i];
    button.addEventListener("click", function(event) {
      Steps.showNextStep();
    });
  }

  var speakButton = $('#speak-directions')[0];
  speakButton.addEventListener('click', function(e){
    Speaker.speak();
  });
});
