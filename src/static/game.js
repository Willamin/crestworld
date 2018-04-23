document.addEventListener("turbolinks:load", function() {
  document.querySelectorAll("input[type=radio]").forEach(function(element) {
    element.onchange = function() {
      postData(document.querySelector("#game_form").action, {choice: element.value})
    }

    element.classList.add("hidden")
  })
})

function postData(url, data) {
  // Default options are marked with *
  return fetch(url, {
    body: JSON.stringify(data), // must match 'Content-Type' header
    cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
    credentials: 'same-origin', // include, same-origin, *omit
    headers: {
      'user-agent': 'Mozilla/4.0 MDN Example',
      'content-type': 'application/json'
    },
    method: 'POST', // *GET, POST, PUT, DELETE, etc.
    mode: 'cors', // no-cors, cors, *same-origin
    redirect: 'manual', // manual, *follow, error
    referrer: 'no-referrer', // *client, no-referrer
  })
  .then(response => Turbolinks.visit(url)) // parses response to JSON
}
