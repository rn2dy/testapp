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
  def add_comments(commentor, content)
    raise unless participants.include? commentor 
    comments.create!(content: content, user_name: commentor.name, user_id: commentor.id)
  end

  def add_invitees(current_user, invitees_emails)
    emails = invitees_emails.gsub(/\s+/, "").split(',')
    emails.delete("") # remove empty element
    emails.each do |e|
      candidate = User.where(email: e).first
      if candidate
        Notifier.invited(current_user, candidate, self).deliver
        next if participants.include?(candidate)
        participants << candidate
      else
        Notifier.unknown_user_invited(current_user, e, self).deliver
        unavailable_users << e
      end
    end
  end
  
  def find_image_src
    res = links.select do |link|
      link.image_src != 'example-img.jpg'
    end
    if res.empty?
      "example-img.jpg"
    else
      res.first.image_src
    end
  end

end
