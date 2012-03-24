require 'open-uri'

class Link
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String
  field :title, type: String
  field :notes, type: String
  field :clicks, type: Integer, default: 0
  field :image_src, type: String, default: "p-img-bg.jpg"
  field :creator_name, type: String
  
  scope :recent, order_by(created_at: :desc)
  scope :check_new, ->(user_id, since) { excludes(user_id: user_id).where(:created_at.gt => since) } 

  belongs_to :topic
  belongs_to :user
  
  before_validation :format_url
  validates :url, presence: true, format: { with: /^https?:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?$/i }
  
  before_create :do_extraction
  
  private
  
    def do_extraction
      if skip_extract_title
        extract_image_src
      else
        if is_ugly_url?
          lazy_extraction
        else
          extract_title
          extract_image_src
        end
      end
    end
    
    def format_url
      if url !~ /https?/i
        self.url = 'http://' + url              
      end         
    end

    def extract_title
      open(self.url) do |f|
        f.each_line do |line|
          if line.force_encoding('UTF-8') =~ /<title>(.*)<\/title>/u 
            self.title = $1.empty? ? make_title : $1
            break;
          end
        end
      end
    end

    def extract_image_src
      open(self.url) do |f|
        begin
          srcs = f.each_line.select do |s|
            s.force_encoding('UTF-8') =~ /<img(.*?)>/u
          end
        
          if srcs.empty?
            self.image_src = default_image_src
          else            
            links = srcs.map do |src|
              res = src.match /src="(.*?)"/u
              if res
                img_url = res[1]
                if img_url !~ /https?:\/\//u
                  'http://' + extract_domain + (img_url[0] == '/' ? img_url : '/' + img_url)
                else
                  img_url
                end
              else
                nil
              end              
            end.compact

            links.take(10).each do |l|                                                        
              size = FastImage.size l
              if size && size[0] > 100 && size[1] > 50
                self.image_src = l
                break;
              end
            end
          end           
        rescue => e
          logger.info e.inspect
          logger.info e.backtrace
          self.image_src = default_image_src
        ensure          
          self.image_src ||= default_image_src  
        end
      end
    end

    def make_title
      extract_domain || "Unknown"
    end

    def is_ugly_url?      
      begin
        open(self.url) {}
      rescue => e
        logger.info "<UNEXPECTED IS_UGLY_URL> #{e.inspect}"        
        return true
      else
        return false            
      end
    end
    
    def lazy_extraction
      self.image_src = default_image_src
      self.title = self.url
    end
    
    def extract_domain
      URI.parse(self.url).host
    end

    def default_image_src
      "p-img-bg.jpg"
    end
    
    def skip_extract_title
      return self.title.present? ? true : false        
    end
end
