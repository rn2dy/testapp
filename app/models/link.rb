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
  
  attr_accessor :skip
  
  scope :recent, order_by(created_at: :desc)
  scope :check_new, ->(user_id, since) { excludes(user_id: user_id).where(:created_at.gt => since) } 

  belongs_to :topic
  belongs_to :user
  
  before_validation :format_url
  validates :url, presence: true, format: { with: /^https?:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?$/i }
  validate :preprocess_url # which was :check_url

  before_create :extract_title, :extract_image_src, unless: :skip_callbacks

  private
  
    #def check_url 
    #  if is_broken? self.url
    #    errors.add(:url, "Inaccessible URL")
    #  end
    #end
    
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

    # check if the url is inaccessible if yes, skip image and tilte extraction!
    def preprocess_url
      self.skip = false
      begin
        open(self.url) {}
      rescue => e
        logger.info ">>>>> #{e.inspect}"
        self.image_src = default_image_src
        self.title = self.url
        self.skip = true
      end
    end
    
    def extract_domain
      URI.parse(self.url).host
    end

    def default_image_src
      "p-img-bg.jpg"
    end
    
    def skip_callbacks
      skip
    end
end
