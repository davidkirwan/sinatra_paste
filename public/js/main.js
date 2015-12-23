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
    url: "/paste",
    data: data,
    success: function(data){
      var theData = JSON.parse(data);
      console.log(theData);
      var divtoupdate = "result";
      var enablebutton = "post_button";
      $("#"+divtoupdate).html(theData.paste);
      $("#"+enablebutton).addClass("enabled");
      onSuccess(theData.data);
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
  console.log("Edit:" + id);
}

function delete_paste(id){
  console.log("Delete: " + id);
}
