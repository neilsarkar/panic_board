// Set a url to refresh from with JSON data
window.setRefreshSource = function(url, options) {
  window.refresh = function() {
    var req = new XMLHttpRequest();

    options.success = options.success || console.log
    options.error = options.error || console.log

    req.onreadystatechange=function() {
      if (req.readyState==4 ) {
        if( 300 > req.status && req.status >= 200 ) {
          try {
            options.success(JSON.parse(req.responseText));
          } catch(parseError) {
            options.success(req.responseText);
          }
        } else {
          options.error(req.responseText, req.status)
        }
      }
    }

    console.log(url)
    req.open("GET", url, true);
    req.send(null);
  }
}

window.refresh = function() {
  console.log("No refresh source set. Please set one with window.setRefreshSource")
}

window.init = function() {
  refresh()
  setInterval(refresh,300000);
}
