require 'open-uri'

class Link
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::Paperclip

  field :url, type: String
  field :title, type: String
  field :notes, type: String
  field :clicks, type: Integer, default: 0
  field :image_src, type: String, default: "p-img-bg.jpg"
  field :creator_name, type: String

  scope :recent, order_by(created_at: :desc)

  belongs_to :topic
  belongs_to :user
  
  
  validates :url, presence: true, format: { with: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \?=.-]*)*\/?$/i }
  validate :check_url

  before_validation :format_url
  before_create :format_url, :extract_title, :extract_image_src

  private
    def check_url 
      if is_broken? self.url
        errors.add(:url, "Inaccessible URL")
      end
    end
    
    def format_url
      if url !~ /https?/i
        self.url = 'http://' + url              
      end         
    end

    def extract_title
      open(self.url, 'User-Agent' => 'ruby') do |f|
        f.each_line do |line|
          if line =~ /<title>(.*)<\/title>/i 
            self.title = $1.empty? ? make_title : $1
            break;
          end
        end
      end
    end

    def extract_image_src
      open(self.url, 'User-Agent' => 'ruby') do |f|
        begin
          srcs = f.grep(/<img(.*?)>/u)
        
          if srcs.empty?
            self.image_src = default_image_src
          else            
            links = srcs.map do |src|
              res = src.match(/src="(.*?)"/u)
              if res
                if res[1] !~ /https?:\/\/.*/i
                  self.url + (src[0] == '/' ? src : '/' + src)
                else
                  res[1]
                end 
              end
            end.compact
            logger.info ">>>>> #{links.inspect}"
            links.take(10).each do |l|                                                        
              size = FastImage.size(l)                                         
              if size[0] > 100 && size[1] > 50
                self.image_src = l
                break;
              end
            end
          end           
        rescue => e
          logger.info e.inspect          
          self.image_src = default_image_src
        end
      end
    end

    def make_title
      url[/http:\/\/(.*)\.com/, 1] || "Unknown"
    end

    def is_broken?(uri)
      begin
        open(self.url, 'User-Agent' => 'ruby') {}
      rescue => e
        logger.info e.inspect
        puts e.inspect
        return true
      end
      false
    end
    
    def default_image_src
      "p-img-bg.jpg"
    end
end
