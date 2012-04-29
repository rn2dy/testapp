function populate_id(ary, idx){
	var actor = $(ary[idx]).attr('href');
	
	if (actor == '#inviteMore'){
		var topic_id = $(ary[idx]).data('topic-id');
		var participants = $('div.invited-list').data('participants');
		var template = fillEmailListTemplate(participants[topic_id]);
		$(template).prependTo('.invite-more-form');
		$('.invite-more-form').attr('action', '/topics/' + topic_id + '/add_invitees');
	}
	
	if (actor == '#linkNotePopup'){
		var link_id = $(ary[idx]).data('link-id');
		$('.add-notes-form').attr('action', '/links/' + link_id + '/add_notes');
		$('.add-notes-form').data('link-id', link_id);		
		$('.add-notes-form textarea').val($('a[data-link-id='+ link_id +']').next().text());
	}
}

function fillEmailListTemplate(emails) {
	build = ""
	for(var i = 0; i < emails.length; i++) {
		build += "<li><i class='icon user-i'></i>"+ emails[i] +"</li>";
	}
	return "<div>" +
		      "<label>Currently Invited (" + emails.length + ")</label>" +
		      "<ul class='currently-invited-list'>" + build + "</ul>" +
	       "</div>";
}

function clean_up(ary, idx) {
	if ($(ary[idx]).attr('href') == '#inviteMore'){
		$('.invite-more-form div:first-child').remove();
	}
}

function check_emails(form){
	var emails = $(form + ' textarea').val().split(',');	
	var emailRegex = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	for(var i = 0; i <  emails.length; i++ ) {
		if ( !emailRegex.test($.trim(emails[i])) && !/^\s*$/.test(emails[i]) ) { 
			return false;
		}
	}
	return true;
}

function loading(me){
	var p = $(me).parent();
	p.hide();
	p.next().show();
}

function capitalize(word){
	return word[0].toUpperCase() + word.slice(1);
}

function fireNotifications(){
  
  $('#sysNotifications').hover(function(){
    var contentHeight = 0;
    $(this).children().each(function(){
      contentHeight += $(this).height();
    });
    $(this).animate({
      height: contentHeight 
    }, 300);
  },function(){
    $(this).animate({height: '30px'}, 300);
  });

	return setInterval(function(){
		$.ajax('/home/sys_notify.json', {
			type: 'get',
			cache: false,
			success: function(json){
				var result = "";
				for (var i=json.length-1; i >= 0; i--){				
					result += "<li><span>" + json[i].message + "</span><a class='go-nav' href='"+ json[i].link +"'>Go</a></li>";
				}				
				result += "<li style='text-align:center;'><a href=\"#\" onclick=\"$('#sysNotifications').toggle();cancelNotifications();\">Close</a></li>";
				addToNotifications(result, json.length);
			}
		});
	}, 30000);
}

function addToNotifications(records, count){	
	if (count == 0){
		$('#sysNotifications').hide();
	} else {
	    $('#sysNotifications').show();
	    $('#sysNotifications ul li').remove();
	    $(records).hide().prependTo('#sysNotifications ul').slideDown("slow");
  }
}

function update(topic_id){
  setInterval(function(){
    $.post('/topics/' + topic_id + '/refresh.js');
  }, 20000);
}

function cancelNotifications(){
  clearInterval(window.timerId);
  $.post('/home/cancel_notifications');
}

