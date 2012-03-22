class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :message, type: String
  field :link, type: String

  default_scope order_by("created_at desc")
  validates_presence_of :message
  
  belongs_to :user
  
end