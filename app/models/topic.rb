class Topic
  include Mongoid::Document
  field :name, :type => String
  field :notes, :type => String
  field :is_public, :type => Boolean, null: false, default: false

  belongs_to :owner, class_name: 'User', inverse_of: :owned_topics
  has_and_belongs_to_many :invitees, 
                          class_name: 'User', inverse_of: :shared_topics
  has_many :links                        
  embeds_many :comments

  validates :name, presence: true


  ## API 
  def add_comment(user, content)
    raise unless [owner, invitees].flatten.include? user 
    comments.create content: content
  end

  def add_link(user, link)
  end

end
