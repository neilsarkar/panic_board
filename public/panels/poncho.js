window.setRefreshSource(
  "/refresh/poncho",
  {
    success: function(response) {
      document.getElementById("headline").innerText = response.subject;
      document.getElementById("human_description").innerText = response.body;
      document.getElementById("current_description").innerText = response.currWeather;
      document.getElementById("current_temperature").innerText = response.currTemp + "º";
    },

    error: function() {
      document.getElementById("headline").innerText = "App Error.";
      document.getElementById("human_description").innerText = "";
    }
  }
)
