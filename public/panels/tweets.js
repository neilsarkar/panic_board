window.setRefreshSource(
  "/refresh/tweets",
  {
    success: function(response) {
      document.getElementById("cam_text").innerText = response.cam.text;
      document.getElementById("cam_avatar_url").src = response.cam.avatar_url;
      document.getElementById("joey_text").innerText = response.joey.text;
      document.getElementById("joey_avatar_url").src = response.joey.avatar_url;
      document.getElementById("neil_text").innerText = response.neil.text;
      document.getElementById("neil_avatar_url").src = response.neil.avatar_url;
    },
  }
)

try{Typekit.load();}catch(e){}