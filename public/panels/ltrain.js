window.setRefreshSource(
  "/refresh/ltrain",
  {
    success: function(response) {
      document.getElementById("circle").innerText = response.status_text;
    },

    error: function() {
      document.getElementById("circle").innerText = "App Error.";
    }
  }
)
