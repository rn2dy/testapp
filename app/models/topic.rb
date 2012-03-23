class Topic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String, null: false
  field :notes, type: String
  field :is_public, type: Boolean, default: false
  field :starter_id, type: String
  field :starter_name, type: String
  field :unavailable_users, type: Array, default: []

  default_scope :order => "created_at DESC"
  has_and_belongs_to_many :participants, class_name: 'User'
  has_many :links                        
  embeds_many :comments

  validates :name, presence: true
  
  ## API 
  def add_links(author, url, the_title="", the_note="")
    link = links.build url: url, creator_name: author.name, title: the_title, notes: the_note 
    link.user = author
    if link.save
      bundle_notify author, "#{author.name} created a link on topic #{self.name}", :new_link
    end
    return link 
  end
  
  def add_comments(commentor, content)
    raise unless participants.include? commentor
    if res = comments.create!(content: content, user_name: commentor.name, user_id: commentor.id)
      bundle_notify commentor, "#{commentor.name} commented on topic #{self.name}", :new_comment
    end
    return res
  end
  
  def bundle_notify author, message, type 
    recievers = participants.excludes(id: author.id)
    if recievers.count > 0
      recievers.each do |reciever|
        reciever.notifications.create message: message, link: "/topics/#{self.id}"
      end
      case type
      when :new_comment
        Notifier.new_comment(recievers, author.name, self).deliver
      when :new_link
        Notifier.new_link(recievers, author.name, self).deliver
      end
    end
  end
  
  def add_invitees(invitor, invitees_emails)
    emails = invitees_emails.gsub(/\s+/, "").split(',')
    emails.delete("")
    emails.each do |e|
      candidate = User.where(email: e).first
      if candidate
        next if participants.include?(candidate)
        candidate.notifications.create message: "#{invitor.name} invited you to the topic #{self.name}", link: "/topics/#{self.id}"        
        Notifier.invited(invitor, candidate, self).deliver        
        participants << candidate
      else
        Notifier.unknown_user_invited(invitor, e, self).deliver
        unavailable_users << e
      end
    end
  end
  
  def find_image_src
    res = links.select do |link|
      link.image_src != 'p-img-bg.jpg'
    end
    if res.empty?
      return false
    else
      return res.first.image_src
    end
  end

  def latest_link_date
    if links.empty?
      Time.now
    else
      links.desc(:created_at).first.created_at
    end
  end

  def latest_comt_date
    if comments.empty?
      Time.now
    else
      comments.desc(:created_at).first.created_at 
    end
  end

end
