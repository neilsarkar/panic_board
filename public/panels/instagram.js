window.setRefreshSource(
  "/refresh/instagram",
  {
    success: function(response) {
      document.getElementById("neil_picture").src = response.neil.image_url;
      document.getElementById("joey_picture").src = response.joey.image_url;
      document.getElementById("cam_picture").src = response.cam.image_url;
    },
  }
)

try{Typekit.load();}catch(e){}
