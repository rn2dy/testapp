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
