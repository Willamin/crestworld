document.querySelectorAll("input[type=radio]").forEach(function(element) {
  element.onchange = function() {
    document.querySelector("#game_form").submit()
  }
})
