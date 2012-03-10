class Topic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String, null: false
  field :notes, type: String
  field :is_public, type: Boolean, default: false
  field :starter_id, type: String
  field :starter_name, type: String
  field :unavailable_users, type: Array, default: []

  #belongs_to :owner, class_name: 'User', inverse_of: :owned_topics
  #has_and_belongs_to_many :invitees, 
  #                        class_name: 'User', inverse_of: :shared_topics
  has_and_belongs_to_many :participants, class_name: 'User'
  has_many :links                        
  embeds_many :comments

  validates :name, presence: true
  
  ## API 
  def add_comments(commentor, content)
    raise unless participants.include? commentor 
    comments.create!(content: content, user_name: commentor.name, user_id: commentor.id)
  end

  def add_invitees(invitees_emails)
    emails = invitees_emails.gsub(/\s+/, "").split(',')
    emails.each do |e|
      candidate = User.where(email: e).first
      if candidate
        next if participants.include?(candidate)
        participants << candidate
      else
        unavailable_users << e
      end
    end
  end

end
