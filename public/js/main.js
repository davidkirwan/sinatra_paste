function ajax_post(){
  var disablebutton = "paste_button";
  $("#"+disablebutton).addClass("disabled");

  var title = $('#paste_title').val();
  var language = $('#paste_language').val();
  var paste = $('#paste_input').val();
  var data = { paste_input : paste,
               paste_language : language,
               paste_title : title };

  $.ajax({
    type: "POST",
    url: "/pastes",
    data: data,
    success: function(data){
      var theData = JSON.parse(data);
      var divtoupdate = "result";
      var enablebutton = "post_button";
      $("#"+divtoupdate).html(data);
      $("#"+enablebutton).addClass("enabled");
      onSuccess(theData);
    },
    error: function(XMLHttpRequest, textStatus, errorThrown){
      var divtoupdate = "result";
      $("#"+divtoupdate).html(XMLHttpRequest.responseText);
    }
  });
}

function empty_title(){
  var title = $('#paste_title').val();
  
  if(title === "Enter title"){
    $("#paste_title").val("");
  }
  else{
    ;
  }
}

function empty_box(){
  var text = $('#paste_input').val();

  if(text === "Enter text"){
    $("#paste_input").val("");
  }
  else{
    ;
  }
}

function onSuccess(data){
  ;
}

function edit_paste(id){
  var title = $('#paste_title').val();
  var language = $('#paste_language').val();
  var paste = $('#paste_input').val();
  var data = { paste_input : paste,
               paste_language : language,
               paste_title : title };

  $.ajax({
    type: "PUT",
    url: "/pastes/" + id,
    data: data,
    success: function(data){
      window.location = "/";
    },
    error: function(XMLHttpRequest, textStatus, errorThrown){
      window.location = "/";
      var divtoupdate = "result";
      $("#"+divtoupdate).html(XMLHttpRequest.responseText);
    }
  });
}

function delete_paste(id){
  $.ajax({
    type: "DELETE",
    url: "/pastes/"+id.toString(),
    success: function(result){
      var divtoupdate = "result";
      $("#"+divtoupdate).html(result);
    }
  });
}

function clear_fields(){
  var text = $('#paste_input').val();
  var title = $('#paste_title').val();
  $("#paste_input").val("");
  $("#paste_title").val("");
}

function cancel_edit() {
  window.location = "/";
}
