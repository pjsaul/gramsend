class AdminController < ApplicationController
  before_action :check_admin, except: :api
  
  def dashboard
    @user_onecard = 0
    User.all.each do |user|
      if user.postcards.count > 0
        @user_onecard = @user_onecard + 1
      end
    end
    
    if params.has_key?(:start)
      start = params[:start].to_i
    else
      start = 0
    end
    
    @sentpostcards = Postcard.all.order(id: :desc)
    @sentpostcardspage_limit = 20
    @sentpostcardspage = @sentpostcards.limit(@sentpostcardspage_limit).offset(start)
    @sentpostcardspage_nextstart = start + @sentpostcardspage_limit
    
    if start + @sentpostcardspage_limit + 1 > @sentpostcards.count
      @sentpostcardspage_max = 1
    else
      @sentpostcardspage_max = 0
    end
  end
  
  def users
    @users = User.all.order(last_activity: :desc).limit(100)
  end
  
  def api
    if params[:conf] == Time.zone.now.strftime("%d") + "zzHos1"
      now = Time.zone.now.strftime("%c")
      user_all = User.count
      user_last24_new = User.where(created_at: (Time.now - 24.hours)..Time.now).count
      user_last24_active = User.where(last_activity: (Time.now - 24.hours)..Time.now).count
      card_all = Postcard.where(error: 0).count
      card_last24 = Postcard.where(error: 0, created_at: (Time.now - 24.hours)..Time.now).count
      card_max = ENV['MAX_CARDS']
      render plain: "STATUS UPDATE GramSend #{now} ... User all/last_day_new/last_day_active #{user_all}/#{user_last24_new}/#{user_last24_active} ... Card all/last_day/max #{card_all}/#{card_last24}/#{card_max}"
    else
      render plain: "Access denied", status: 403
    end
  end
  
  private
  
  def check_admin
     if session[:current_access_local].nil?
       redirect_to root_path
     end
     
     active_user = User.find(session[:gramsend_user_id])
     
     if active_user.admin != 1
       redirect_to error_path
     end
  end
  
end
