class StaticController < ApplicationController
  
  before_action :instaurl_set
  
  def home
    
  end
  
  def error
    reset_session
  end
  
  def issue
    
  end
  
  def signout
    reset_session
    redirect_to root_path
  end
  
  private
  
  def instaurl_set
     @InstaURL = 'https://api.instagram.com/oauth/authorize/?client_id=' + ENV['IG_CID'] + '&redirect_uri=' + ENV['IG_REDIR'] + '&response_type=code'
  end
  
end
