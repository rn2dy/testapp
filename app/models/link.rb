require 'open-uri'

class Link
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::Paperclip

  field :url, type: String
  field :title, type: String
  field :notes, type: String
  field :clicks, type: Integer, default: 0
  field :image_src, type: String
  #has_mongoid_attached_file :image

  belongs_to :topic
  belongs_to :user

  validates :url, presence: true, uniqueness: true , format: { with: /.*/ }
  validate :check_url # custom validation

  before_create :extract_title

  private
    def check_url 
      if is_broken? self.url
        errors.add(:url, "Inaccessible URL")
      end
    end

    def extract_title
      open(self.url) do |f|
        f.each_line { |line|
          if line =~ /<title>(.*)<\/title>/i 
            self.title = $1.empty? ? make_title : $1
            break;
          end
        }
      end
    end

    def make_title
      url[/http:\/\/(.*)\.com/, 1] || "Unknown"
    end

    def is_broken?(uri)
      begin
        open(self.url) {}
      rescue
        return true
      end
      false
    end
end
