function getCookies() {
  Shiny.setInputValue('cookies', Cookies.get());
}

Shiny.addCustomMessageHandler('cookie-set', function(msg) {
  Cookies.set(msg.name, msg.value);
  getCookies();
});

Shiny.addCustomMessageHandler('cookie-remove', function(msg) {
  Cookies.remove(msg.name);
  getCookies();
});

$(document).on('shiny:connected', function(event) {
  Shiny.setInputValue('cookies', Cookies.get());
});
