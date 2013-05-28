window.setRefreshSource(
  "/refresh/ucb",
  {
    success: function(classes) {
      console.log("Great!")
    },
    error: function() {
      console.log("Nope.")
    }
  }
)
