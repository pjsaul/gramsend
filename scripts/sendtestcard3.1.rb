$:.unshift File.expand_path("../lib", File.dirname(__FILE__))
require 'lob'

# initialize Lob object
# live live_d745e3c0b5ea0e014341387bd9ade2bb6a9
# test test_860745db739fc493e10f393a1475fdb9803
Lob.api_key = 'test_860745db739fc493e10f393a1475fdb9803'
@lob = Lob.load

newcard = @lob.postcards.create(
  name: "GramSend New Model Test",
  to: {
    name: "Peter Saul",
    address_line1: "2918 N Sheffield Ave Apt 3N",
    city: "fakeblah",
    state: "zz",
    country: "US",
    zip: 1234
  },
  from: {
    name: "GramSend",
    address_line1: "2918 N Sheffield Ave Apt 3N",
    city: "Chicago",
    state: "IL",
    country: "US",
    zip: 60657
  },
  full_bleed: 1,
  template: 1,
  front: '
<html>
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
    height: 4.05in;
    left: 4.35in;
    padding-top: 0.05in;
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
    <h5><strong>@Cubs</strong></h5>
    <strong><small>Thank you @rockies for honoring Ernie Banks before todays opener. #MrCub</small></strong><br>
    <small><i class="glyphicon glyphicon-map-marker"></i> Denver, Colorado</small><br>
    <small><i class="glyphicon glyphicon-calendar"></i> April 9, 2015</small><br><br>
    <small><i class="glyphicon glyphicon-heart"></i> 138 likes</small><br>
    <small><i class="glyphicon glyphicon-comment"></i> 62 comments</small><br>
    ' + insta_comments + '
  </div>
  
</body>

</html>
',
  back: '
<html>
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
    <strong><small>From @pdizzle123abc</small></strong><br>
      Hey man,<br>
      I hope life is treating you well in Chicago. I think it will be a great season for the Cubs.  See you at Wrigley!<br>
      -Peter
    </div>
    
    <div id="borderstrip">
      <!-- border strip -->
    </div>
    
    <div id="rightbox" align="center">
      <small>This Instagram postcard was sent via GramSend. Send one by going to:</small><br>
      <strong>www.GramSend.com</strong><br>
      <small><em>Copyright &copy; 2015 GramSend. GramSend is not affiliated with or endorsed by Instagram.</em></small>
    </div>
    
</body>

</html>
'
)

puts JSON.pretty_generate(newcard)