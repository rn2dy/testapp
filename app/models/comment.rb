class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :user_name, type: String
  field :user_id, type: String
  
  scope :recent, order_by(created_at: :desc)
  
  embedded_in :topic
  validates :content, presence: true

end
