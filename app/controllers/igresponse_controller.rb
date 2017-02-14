class IgresponseController < ApplicationController
  
  before_action :known_user, except: :incoming
  before_action :error_catch
  after_action :update_activity, except: :incoming
  
  def incoming
    client_id = ENV['IG_CID']
    client_secret = ENV['IG_SEC']
    redirect_uri = ENV['IG_REDIR']
    grant_type = 'authorization_code'
    code = params[:code]
    
    instaresponse = RestClient.post 'https://api.instagram.com/oauth/access_token', {'client_id' => client_id, 'client_secret' => client_secret, 'redirect_uri' => redirect_uri, 'grant_type' => grant_type, 'code' => code}
    json_insta = JSON.parse(instaresponse)
    access_local = json_insta["access_token"]
    userid = json_insta["user"]["id"]
    useriname = json_insta["user"]["username"]
    
    session[:current_access_local] = access_local
    session[:insta_user_id] = userid
    session[:insta_user_name] = useriname
    
    gramsend_user = User.find_by insta_id: userid
    
    if gramsend_user.nil?
      newuser = User.new
      newuser.insta_id = userid
      newuser.insta_name = useriname
      newuser.admin = 0
      newuser.pageviews = 0
      newuser.save
      gramsend_user = User.find_by insta_id: userid
    end
    
    session[:gramsend_user_id] = gramsend_user.id
    redirect_to ighome_path(:login => 'yes')
  end
  
  def ighome
    feedurl = 'https://api.instagram.com/v1/users/' + session[:insta_user_id] + '?access_token=' + session[:current_access_local]
    instafeed = begin
      RestClient.get feedurl
    rescue => e
      e.response
    end
    json_feed = JSON.parse(instafeed)
    auth_confirm(json_feed)
    @gramsenduser = User.find(session[:gramsend_user_id])
    @instauser = json_feed["data"]
    
    @gramsenduser.update(:followers_count => @instauser["counts"]["followed_by"])
    @gramsenduser.update(:following_count => @instauser["counts"]["follows"])
    
    if params.has_key?(:start)
      start = params[:start].to_i
    else
      start = 0
    end
    
    @sentpostcards = @gramsenduser.postcards.where(error: 0).order(id: :desc)
    @sentpostcardspage_limit = 20
    @sentpostcardspage = @sentpostcards.limit(@sentpostcardspage_limit).offset(start)
    @sentpostcardspage_nextstart = start + @sentpostcardspage_limit
    
    if start + @sentpostcardspage_limit + 1 > @sentpostcards.count
      @sentpostcardspage_max = 1
    else
      @sentpostcardspage_max = 0
    end
  end
  
  def selffeed
    feedurl = 'https://api.instagram.com/v1/users/' + session[:insta_user_id] + '/media/recent/?access_token=' + session[:current_access_local]
    if params.has_key?(:max_id)
      feedurl << '&max_id=' + params[:max_id]
    end
    instafeed = begin
      RestClient.get feedurl
    rescue => e
      e.response
    end
    json_feed = JSON.parse(instafeed)
    auth_confirm(json_feed)
    @pictures = json_feed["data"]
    @pagination = json_feed["pagination"]
  end
  
  def mainfeed
    feedurl = 'https://api.instagram.com/v1/users/self/feed?access_token=' + session[:current_access_local]
    if params.has_key?(:max_id)
      feedurl << '&max_id=' + params[:max_id]
    end
    instafeed = begin
      RestClient.get feedurl
    rescue => e
      e.response
    end
    json_feed = JSON.parse(instafeed)
    auth_confirm(json_feed)
    @pictures = json_feed["data"]
    @pagination = json_feed["pagination"]
  end
  
  def friendfeed
    feedurl = 'https://api.instagram.com/v1/users/' + params[:id] + '/media/recent/?access_token=' + session[:current_access_local]
    if params.has_key?(:max_id)
      feedurl << '&max_id=' + params[:max_id]
    end
    instafeed = begin
      RestClient.get feedurl
    rescue => e
      e.response
    end
    json_feed = JSON.parse(instafeed)
    if json_feed["meta"]["code"] == 400
      redirect_to igresponse_privatefriend_path and return
    end
    auth_confirm(json_feed)
    @pictures = json_feed["data"]
    @pagination = json_feed["pagination"]
  end
  
  def privatefriend
  end
  
  def friendlist
    if params.has_key?(:q) and params[:q] != ''
      @q_val = params[:q]
      feedurl = 'https://api.instagram.com/v1/users/search?q=' + params[:q] + '&access_token=' + session[:current_access_local]
      instafeed = begin
        RestClient.get feedurl
      rescue => e
        redirect_to igresponse_friendlist_path and return
      end
    else
      @q_val = nil
      feedurl = 'https://api.instagram.com/v1/users/' + session[:insta_user_id] + '/follows?access_token=' + session[:current_access_local]
      if params.has_key?(:cursor)
        feedurl << '&cursor=' + params[:cursor]
      end
      instafeed = begin
        RestClient.get feedurl
      rescue => e
        e.response
      end
    end
    json_feed = JSON.parse(instafeed)
    auth_confirm(json_feed)
    @friends = json_feed["data"]
    @pagination = json_feed["pagination"]
  end
  
  def instapic
    feedurl = 'https://api.instagram.com/v1/media/' + params[:id] + '?access_token=' + session[:current_access_local]
    instafeed = begin
      RestClient.get feedurl
    rescue => e
      e.response
    end
    json_feed = JSON.parse(instafeed)
    auth_confirm(json_feed)
    @instapic = json_feed["data"]
    
    @newcard = Postcard.new
    active_user = User.find(session[:gramsend_user_id])
    active_user.increment(:formviews)
    active_user.save
    @newcard.insta_id = params[:id]
    @newcard.from_name = active_user.addr_name
    @newcard.from_name ||= '@' + session[:insta_user_name]
    @newcard.from_address_one = active_user.addr_address_one
    @newcard.from_address_two = active_user.addr_address_two
    @newcard.from_city = active_user.addr_city
    @newcard.from_state = active_user.addr_state
    @newcard.from_zip = active_user.addr_zip
  end
  
  def createpostcard
    @newcard = Postcard.new(postcard_params)
    @newcard.user_id = session[:gramsend_user_id]
    @newcard.insta_fromusername = session[:insta_user_name]
    @newcard.to_state.upcase!
    @newcard.to_country = 'US'
    @newcard.from_state.upcase!
    @newcard.from_country = 'US'
    @newcard.error = 0
    
    if @newcard.save
      active_user = User.find(session[:gramsend_user_id])
      @newcard = active_user.postcards.last
      active_user.addr_name = @newcard.from_name
      active_user.addr_address_one = @newcard.from_address_one
      active_user.addr_address_two = @newcard.from_address_two
      active_user.addr_city = @newcard.from_city
      active_user.addr_state = @newcard.from_state
      active_user.addr_zip = @newcard.from_zip
      active_user.save
      
      writeinsta(@newcard.insta_id)
      
      @newcard = active_user.postcards.last
      
      if Postcard.where(error: 0).count > ENV['MAX_CARDS'].to_i # prevent overuse
        @newcard.update(error: 2)
        flash[:danger] = "<h4>There was a problem!</h4><p>GramSend has reached its maximum capacity - these postcards aren't free! Contact us to tell us you saw this, and we will work on increasing the limit.</p>"
      else
        sendlob(@newcard)
      end
      
      if @newcard.error == 1
        flash[:danger] = "<h4>There was a problem!</h4><p>There was an issue in submitting your postcard, and it was not created succesfully. We will investigate this error. In the meantime, try again.</p>"
      elsif @newcard.error == 0
        newcarddate = @newcard.expected_delivery_date.strftime("%B %-d, %Y")
        newcardinstapostname = ERB::Util.html_escape(@newcard.insta_postusername)
        newcardtoname = ERB::Util.html_escape(@newcard.to_name)
        flash[:info] = "<h4>GramSend created!</h4><p>Your GramSend from @#{newcardinstapostname} was sent to #{newcardtoname}. It should arrive on <strong>#{newcarddate}</strong>.</p><p><img src=\"#{@newcard.thumbnail_front_url}\" class=\"img-thumbnail listthumb\"> <img src=\"#{@newcard.thumbnail_back_url}\" class=\"img-thumbnail listthumb\"></p>"
      end
      
      sleep(5) # this gives time for the Lob thumbnail images to populate
      redirect_to ighome_path(:card => 'created')
    else
      feedurl = 'https://api.instagram.com/v1/media/' + @newcard.insta_id + '?access_token=' + session[:current_access_local]
      instafeed = begin
        RestClient.get feedurl
      rescue => e
        e.response
      end
      json_feed = JSON.parse(instafeed)
      auth_confirm(json_feed)
      @instapic = json_feed["data"]
      render :action => "instapic"
    end
  end
  
  private
  
  def auth_confirm (json_input)
    if json_input["meta"]["code"] != 200
      redirect_to error_path
    end
  end
  
  def error_catch
    if params[:error] == "access_denied"
      redirect_to error_path
    end
  end
  
  def known_user
     if session[:current_access_local].nil?
       redirect_to root_path
     end
  end
  
  def update_activity
    active_user = User.find(session[:gramsend_user_id])
    active_user.last_activity = Time.now
    active_user.increment(:pageviews)
    active_user.save
  end
  
  def postcard_params
    params.require(:postcard).permit(:insta_id, :from_name, :from_address_one, :from_address_two, :from_city, :from_state, :from_zip, :to_name, :to_address_one, :to_address_two, :to_city, :to_state, :to_zip, :postcard_message)
  end
  
  def writeinsta (insta_id)
    feedurl = 'https://api.instagram.com/v1/media/' + insta_id + '?access_token=' + session[:current_access_local]
    instafeed = begin
      RestClient.get feedurl
    rescue => e
      e.response
    end
    json_feed = JSON.parse(instafeed)
    auth_confirm(json_feed)
    instapic = json_feed["data"]
    active_user = User.find(session[:gramsend_user_id])
    newcard = active_user.postcards.last
    
    newcard.insta_url = instapic["images"]["standard_resolution"]["url"]
    newcard.insta_postusername = view_context.cleanup(instapic["user"]["username"])
    unless instapic["caption"].nil?
      newcard.insta_caption = view_context.cleanup(instapic["caption"]["text"])
    end
    unless instapic["location"].nil?
      unless instapic["location"]["name"].nil?
      newcard.insta_location = view_context.cleanup(instapic["location"]["name"])
      end
    end
    newcard.insta_date = DateTime.strptime(instapic["created_time"],'%s').strftime("%B %-d, %Y")
    newcard.insta_likes_count = instapic["likes"]["count"]
    newcard.insta_comments_count = instapic["comments"]["count"]
    
    if instapic["comments"]["count"] > 0
      @commentstring = ""
      instapic["comments"]["data"].each do |comment|
        @commentstring = @commentstring + "@" + view_context.cleanup(comment["from"]["username"]) + ": " + view_context.cleanup(comment["text"]) + "<br> "
      end
      newcard.insta_comments = @commentstring
    end
    
    newcard.save
  end
  
  def sendlob(postcard)
    
    require 'lob'

    Lob.api_key = ENV['LOB_KEY']
    @lob = Lob.load
    
    lobfrontstring = lobfront(postcard.insta_url, postcard.insta_postusername, postcard.insta_caption, postcard.insta_location, postcard.insta_date, postcard.insta_likes_count, postcard.insta_comments_count, postcard.insta_comments)
    lobbackstring = lobback(postcard.insta_fromusername, postcard.postcard_message)

    newcard = begin
    @lob.postcards.create(
      description: "GramSend Postcard v1.1",
      to: {
        name: postcard.to_name,
        address_line1: postcard.to_address_one,
        address_line2: postcard.to_address_two,
        address_city: postcard.to_city,
        address_state: postcard.to_state,
        address_country: postcard.to_country,
        address_zip: postcard.to_zip
      },
      from: {
        name: postcard.from_name,
        address_line1: postcard.from_address_one,
        address_line2: postcard.from_address_two,
        address_city: postcard.from_city,
        address_state: postcard.from_state,
        address_country: postcard.from_country,
        address_zip: postcard.from_zip
      },
      front: lobfrontstring,
      back: lobbackstring)
    rescue
      postcard.update(error: 1)
    end
    
    if postcard.error == 0
      postcard.lob_id = newcard["id"]
      postcard.thumbnail_front_url = newcard["thumbnails"].first["medium"]
      postcard.thumbnail_back_url = newcard["thumbnails"].last["medium"]
      postcard.sent_date = Time.now()
      postcard.expected_delivery_date = newcard["expected_delivery_date"]
      postcard.save
    end
  end
  
  def lobfront(insta_url, insta_postusername, insta_caption, insta_location, insta_date, insta_likes_count, insta_comments_count, insta_comments)
    output = '<html>
    <head>
    <title>GramSend</title>
    <link href="http://maxcdn.bootstrapcdn.com/bootswatch/3.3.4/flatly/bootstrap.min.css" rel="stylesheet">
    <style>
    
      *, *:before, *:after {
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        box-sizing: border-box;
      }
    
      body {
        width: 6.25in;
        height: 4.25in;
        margin: 0;
        padding: 0;
        color: black;
      }
    
      #mainimage {
        position: absolute;
        width: 4.25in;
        height: 4.25in;
        left: 0in;
        top: 0in;
      }
      
      #borderstrip {
        position: absolute;
        width: 0.1in;
        height: 4.25in;
        left: 4.25in;
        top: 0in;
      }
      
      #details {
        position: absolute;
        width: 1.7125in;
        height: 4.25in;
        left: 4.35in;
        padding-top: 0.075in;
        padding-right: 0.05in;
        top: 0in;
        word-wrap: break-word;
        overflow-y: hidden;
        overflow-x: visible;
      }
    </style>
    </head>
    
    <body>
      <div id="mainimage">
        <img src="' + insta_url + '" id="mainimage">
      </div>
      
      <div id="borderstrip">
        <!-- border strip -->
      </div>
      
      <div id="details">
        <h6><strong><i class="glyphicon glyphicon-camera"></i> @' + ERB::Util.html_escape(insta_postusername) + '</strong></h6>'
        
        unless insta_caption.nil?
        output = output + '<strong><small>' + ERB::Util.html_escape(insta_caption) + '</small></strong><br>'
        end
        
        unless insta_location.nil?
        output = output + '<small><i class="glyphicon glyphicon-map-marker"></i> ' + ERB::Util.html_escape(insta_location) + '</small><br>'
        end
        
        output = output + '<small><i class="glyphicon glyphicon-calendar"></i> ' + insta_date.strftime("%B %-d, %Y") + '</small><br><br>
        <small><i class="glyphicon glyphicon-heart"></i> ' + insta_likes_count.to_s + ' likes</small><br>
        <small><i class="glyphicon glyphicon-comment"></i> ' + insta_comments_count.to_s + ' comments</small><br>'
        
        unless insta_comments.nil?
        output = output + '<small>' + mark_things(ERB::Util.html_escape(insta_comments)).gsub('&lt;br&gt;', '<br>') + '</small>'
        end
        
        output = output + '
      </div>
      
    </body>
    
    </html>'
    
    return output
  end
  
  def lobback(insta_fromusername, postcard_message)
    output = '<html>
    <head>
    <title>GramSend</title>
    <link href="http://maxcdn.bootstrapcdn.com/bootswatch/3.3.4/flatly/bootstrap.min.css" rel="stylesheet">
    <style>
      *, *:before, *:after {
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        box-sizing: border-box;
      }
    
      body {
        width: 6.25in;
        height: 4.25in;
        margin: 0;
        padding: 0;
        color: black;
      }
      
      #borderstrip {
        position: absolute;
        width: 0.1in;
        height: 4.25in;
        left: 2.5in;
        top: 0in;
      }
      
      #maintext {
        position: absolute;
        top: 0.2in;
        left: 0.2in;
        width: 2.1in;
        height: 3.85in;
        word-wrap: break-word;
        overflow-y: hidden;
        overflow-x: visible;
        padding: 5px;
        border: 3px solid;
        border-radius: 4px;
        border-color: #800000;
      }
      
      #rightbox {
        position: absolute;
        top: 0.2in;
        left: 2.75in;
        width: 3.25in;
        padding: 5px;
        word-wrap: break-word;
        overflow-y: hidden;
        overflow-x: visible;
        border: 3px solid;
        border-radius: 4px;
        border-color: #000066;
      }
      
    </style>
    </head>
    
    <body>
    <div id="maintext">
        <strong><small>From @' + ERB::Util.html_escape(insta_fromusername) + '</small></strong><br>'
      
        unless postcard_message.nil?
        output = output + mark_things(ERB::Util.html_escape(postcard_message))
        end
        
        output = output + '</div><div id="borderstrip">
          <!-- border strip -->
        </div>
        
        <div id="rightbox" align="center">
          <small>This Instagram postcard was sent via GramSend. Send one by going to:</small><br>
          <strong>www.GramSend.com</strong><br>
          <small><em>Copyright &copy; 2015 GramSend. GramSend is not affiliated with or endorsed by Instagram.</em></small>
        </div>
        
    </body>
    
    </html>'
    
    return output
  end
  
  def mark_things(str)
    str.split(' ').map do |word|
      if word =~ /^#|@/
        "<strong>#{word}</strong>"
      else
        word
      end
    end.join(' ')
  end
  
end