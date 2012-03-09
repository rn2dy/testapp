class Topic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String, null: false
  field :notes, type: String
  field :is_public, type: Boolean, default: false
  field :starter_id, type: String
  field :starter_name, type: String

  #belongs_to :owner, class_name: 'User', inverse_of: :owned_topics
  #has_and_belongs_to_many :invitees, 
  #                        class_name: 'User', inverse_of: :shared_topics
  has_and_belongs_to_many :participants, class_name: 'User'
  has_many :links                        
  embeds_many :comments

  validates :name, presence: true
  
  ## API 
  def add_comment(commentor, content)
    raise unless participants.include? commentor 
    comments.create content: content
  end

  def add_invitees(invitees)
    rest = invitees - participants 
    rest.each do |invitee|
      participants << invitee
    end
  end

end
