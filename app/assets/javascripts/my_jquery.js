$(document).ready(function(){

  $('#submitUrl').click(createLink);
  $('#commSubmit').keypress(createComment);

});
// new comment
function createComment(e) {
  if (e.which == 13) {
    if (!$.trim( $(this).val() )) {
      alert('Empty comment! Try again please.');
    } else {
      var topic_id = $('#topicId').val();
      $.ajax('/topics/'+topic_id+'/add_comments', {
        data: { content: $('#commSubmit').val() }, 
        dataType: 'json',
        type: 'POST',
        beforeSend: function() {
          $('#commSubmit').attr('disabled', true);
          $('#loadingComment').show();
        },
        complete: function() {
          $('#commSubmit').removeAttr('disabled');
          $('#commSubmit').val('');
          $('#loadingComment').hide();
        },
        success: function(json) {
          var new_comment = commentPartial(json); 
          $('section.comments header.l1').append(new_comment);
          updateCounts('#commCount');
        }
      });
    }
  }
}

// new link
function createLink(e){
  if (!$.trim($('#urlBar').val()) || $('#urlBar').val() == 'http://') {
    alert('Enter a address please');
  } else {
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
}

function commentPartial(comment) {
  return "<article>" +
           "<header>" +
             "<span>" + comment.user_name + "</span>" + 
             "<span>" + comment.created_at + "</span>" + 
           "</header>" +
           "<p>" + comment.content + "</p>" +
         "</article>";
}

function linkPartial(link){
  var link_notes = "";
  if(link.notes){
    link_notes += "<p>" + link.notes + "</p>" +
              "<span>Posted by: " + link.creator_name + link.created_at + "</span>";
  }else{
    link_notes += "<p>There is no notes for this link</p>" + "<a href='#'>Add Notes</a>";
  }
  return "<div class='row-fluid'>" +   
            "<div class='span3'>" +
              "<image src='" + link.image_src + "' height='100' width='150' alt='/assets/rails.png'/>" + 
            "</div>" +
            "<div class='span7'>" +
              "<article>" + 
                "<header>" +
                  "<h3><a href='" + link.url + "'>" + link.title + "</a></h3>" + 
                "</header>" +
                "<div class='linkNotes'>" + 
                  link_notes +
                "</div>" + 
              "</article>" +
            "</div>" +
          "</div>";
}

function updateCounts(elm) {
  $(elm).text(parseInt($(elm).text()));
}
