function ajax_post(){
  var disablebutton = "paste_button";
  $("#"+disablebutton).addClass("disabled");

  var tmp = $('#paste_input').val();
  var data = { paste_input : tmp }

  $.ajax({
    type: "POST",
    url: "/paste",
    data: data,
    success: function(data){
      var theData = JSON.parse(data)
      console.log(theData);
      var divtoupdate = "result";
      var enablebutton = "post_button";
      $("#"+divtoupdate).html(theData.paste);
      $("#"+enablebutton).addClass("enabled");
      onSuccess(theData.data);
    }
  });
}

function empty_box(){
  $("#paste_input").val("");
}

function onSuccess(data){
  ;
}
