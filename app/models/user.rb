class User
  include Mongoid::Document
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name,               :type => String, :default => ""
  field :email,              :type => String, :null => false, :default => ""
  field :encrypted_password, :type => String, :null => false, :default => ""

  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  field :remember_created_at, :type => Time

  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  
  has_and_belongs_to_many :topics, inverse_of: :participants, dependent: :nullify
  has_many :links      
  has_many :notifications  
  
  
  validates_uniqueness_of :name, :email, :case_sensitive => false
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  before_create :make_default_name
  after_create :accept_invitations

  def accept_invitations
    Topic.all.each do |topic|
      if topic.unavailable_users.include? email
        self.topics << topic
        topic.unavailable_users.delete(email)
        topic.save!
      else
        next
      end
    end
    self.save!
  end
  
  def make_default_name
    if name.empty?
      self.name = email[/(.+?)@/, 1]
    end
  end
  
end

