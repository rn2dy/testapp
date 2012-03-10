module ApplicationHelper
  def invitee_opt_field
    return "" unless current_user.topics.count > 0
    res = label_tag 'Invite people from existing topics. Selete topic:'
    current_user.topics.inject(res) do |build, topic|
      build  << (check_box_tag(topic.name, topic.id) + topic.name + "    #{topic.participants.count}")
    end
    res
  end
end
