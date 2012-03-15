require 'open-uri'

class Link
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::Paperclip

  field :url, type: String
  field :title, type: String
  field :notes, type: String
  field :clicks, type: Integer, default: 0
  field :image_src, type: String, default: "example-img.jpg"
  field :creator_name, type: String

  scope :recent, order_by(created_at: :desc)

  belongs_to :topic
  belongs_to :user
  
  validates :url, presence: true, format: { with: /.*/ }
  validate :check_url # custom validation

  before_create :extract_title, :extract_image_src

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

    def extract_image_src
      open(self.url) do |f|
        begin
          srcs = f.grep(/<img(.*?)>/)
        
          if srcs.empty?
            self.image_src = 'rails.png'
          else
            src = srcs.first.match(/src="(.*?)"/)[1]
            if src =~ /http:\/\/.*/
              self.image_src = src 
            else
              self.image_src = self.url + (src[0] == '/' ? src : '/' + src)
            end
          end
        rescue
          self.image_src = default_image_src
        end
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
    
    def default_image_src
      "example-img.jpg"
    end
end
