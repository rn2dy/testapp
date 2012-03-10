$(document).ready(function(){

  $('#submitUrl').click(createLink);

});


function createLink(e){
  $(this).attr('disabled', true);
  var link = $('#urlBar').val(); 
  var topic_id = $('#topicId').val();

  $.ajax('/links', {
    data: { link : {url: link}, topic_id : topic_id  },
    dataType: 'json',
    type: 'POST',
    beforeSend: function() { 
      $('#urlBar').attr('disabled', true);
      $('#loading').show();
    },
    complete: function() {
      $('#submitUrl').removeAttr('disabled');
      $('#urlBar').removeAttr('disabled');
      $('#urlBar').val("");
      $('#loading').hide();

    },
    success: function(json) { 
      var new_link = linkPartial(json); 
      $(new_link).prependTo('section.links');
    }
  });
}

function linkPartial(json){
  var link_notes = "";
  if(json.notes){
    link_notes += "<p>" + json.notes + "</p>" +
              "<span>Posted by: " + json.creator_name + json.created_at + "</span>";
  }else{
    link_notes += "<p>There is no notes for this link</p>" + "<a href='#'>Add Notes</a>";
  }
  return "<div class='row-fluid'>" +   
            "<div class='span3'>" +
              "<image src='" + json.image_src + "' height='100' width='150' alt='/assets/rails.png'/>" + 
            "</div>" +
            "<div class='span7'>" +
              "<article>" + 
                "<header>" +
                  "<h3><a href='" + json.url + "'>" + json.title + "</a></h3>" + 
                "</header>" +
                "<div class='linkNotes'>" + 
                  link_notes +
                "</div>" + 
              "</article>" +
            "</div>" +
          "</div>";
}

