module IgresponseHelper
  
  def cleanup(str)
    str.to_s.gsub(/[^\u0000-\u007F\u0080-\u00FF\u0100-\u017F\u0180-\u024F]/, '')
  end
  
end