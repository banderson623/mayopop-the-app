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
    }
  },

  showNextStep: function(){
    if(this.at < this.steps.length -1){
      this.at = this.at+ 1;
      this.hideAllSteps();
      this.steps[this.at].classList.remove('hidden');
      callNative('step', this.at);
    }
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
});
