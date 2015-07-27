
class SendTimes
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def find_train(train_id)
    @train = Train.find(train_id)
  end

  def perform(train_id)
    find_train(train_id)

    if central_time_zone?

      train_info = parse_arrivals(lines[@train.line][@train.stop], @train.stop, @train.line)

      user_phone

      send_message(train_info, user_phone)

      set_time_save
    else
      set_time_save
    end
  end

  def parse_arrivals(stop_name, stop_id, train_line)
    route = routes[train_line]

    train_text = start_text(train_line, stop_name)

    url = api_hit(route, stop_id)

    xml_data = Net::HTTP.get_response(URI.parse(url)).body


    cta_response(xml_data, train_text)


    text_body = begin_text_body(train_text, stop_name)

    return text_body
  end

  def api_hit(stop_id, route)
    url = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{ENV['CTA_KEY']}&stpid=#{stop_id}&rt=#{route}"
  end

  def start_text(train_line, stop_name)
    train_times = "Your train times for #{train_line} Line - #{stop_name} are:" + "\n\n"
  end

  def cta_response(xml_data, train_text)
    doc = Nokogiri::XML(xml_data)

    doc.xpath('//eta').each do |arrival|
      time = arrival.at_xpath('arrT').content
      direction = arrival.at_xpath('destNm').content
      time = time.to_time.strftime("%I:%M %p")
      train_text += direction + ": " + time + "\n"
    end

    return train_text
  end

  def user_phone
    phone = User.find(@train.user_id).phone
  end

  def set_time_save
    @train.time += (60*60*24)
    @train.save!
    SendTimes.perform_at(@train.time, @train.id)
  end

  def central_time_zone?
    @train.days.include?(Time.now.in_time_zone('Central Time (US & Canada)').wday.to_s)
  end


  def begin_text_body(train_times, stop_name)
    if train_times == "Your train times for #{train_times} Line - #{stop_name} are:" + "\n\n"
      train_times = "No scheduled arrivals for #{train_times} Line - #{stop_name}." + "\n"
    end
    return train_times
  end

  def send_message(train_info, phone)
    client = create_client
    message = client.account.messages.create(
      :body => "#{train_info}\nSent by working title.",
      :to => "+1#{phone}",
    :from => ENV['FROM'])
  end

  def create_client
    account_sid = ENV['TWSID']
    auth_token = ENV['TOKEN']

    return Twilio::REST::Client.new(account_sid, auth_token)
  end
  def routes
    routes = {}

    routes["Red"] = "red"
    routes["Blue"] = "blue"
    routes["Green"] = "g"
    routes["Brown"] = "brn"
    routes["Purple"] = "p"
    routes["PurpleExp"] = "p"
    routes["Yellow"] = "y"
    routes["Pink"] = "pink"
    routes["Orange"] = "org"

    return routes
  end

  def lines
    lines = {}

    lines["Red"] = {}
    lines["Blue"] = {}
    lines["Green"] = {}
    lines["Brown"] = {}
    lines["Purple"] = {}
    lines["PurpleExp"] = {}
    lines["Yellow"] = {}
    lines["Pink"] = {}
    lines["Orange"] = {}

    lines["Red"]["30173"] = "Howard (Terminal arrival)"
    lines["Red"]["30174"] = "Howard (95th-Bound)"
    lines["Red"]["30228"] = "Jarvis (95th-bound)"
    lines["Red"]["30227"] = "Jarvis (Howard-bound)"
    lines["Red"]["30021"] = "Morse (95th-bound)"
    lines["Red"]["30020"] = "Morse (Howard-bound)"
    lines["Red"]["30252"] = "Loyola (95th-bound)"
    lines["Red"]["30251"] = "Loyola (Howard-bound)"
    lines["Red"]["30148"] = "Granville (95th-bound)"
    lines["Red"]["30147"] = "Granville (Howard-bound)"
    lines["Red"]["30170"] = "Thorndale (95th-bound)"
    lines["Red"]["30169"] = "Thorndale (Howard-bound)"
    lines["Red"]["30268"] = "Bryn Mawr (95th-bound)"
    lines["Red"]["30267"] = "Bryn Mawr (Howard-bound)"
    lines["Red"]["30067"] = "Berwyn (95th-bound)"
    lines["Red"]["30066"] = "Berwyn (Howard-bound)"
    lines["Red"]["30230"] = "Argyle (95th-bound)"
    lines["Red"]["30229"] = "Argyle (Howard-bound)"
    lines["Red"]["30150"] = "Lawrence (95th-bound)"
    lines["Red"]["30149"] = "Lawrence (Howard-bound)"
    lines["Red"]["30106"] = "Wilson (95th-bound)"
    lines["Red"]["30105"] = "Wilson (Howard-bound)"
    lines["Red"]["30017"] = "Sheridan (95th-bound)"
    lines["Red"]["30016"] = "Sheridan (Howard-bound)"
    lines["Red"]["30274"] = "Addison (95th-bound)"
    lines["Red"]["30273"] = "Addison (Howard-bound)"
    lines["Red"]["30256"] = "Belmont (95th-bound)"
    lines["Red"]["30255"] = "Belmont (Howard-bound)"
    lines["Red"]["30234"] = "Fullerton (95th-bound)"
    lines["Red"]["30233"] = "Fullerton (Howard-bound)"
    lines["Red"]["30126"] = "North/Clybourn (95th-bound)"
    lines["Red"]["30125"] = "North/Clybourn (Howard-bound)"
    lines["Red"]["30122"] = "Clark/Division (95th-bound)"
    lines["Red"]["30121"] = "Clark/Division (Howard-bound)"
    lines["Red"]["30280"] = "Chicago/State (95th-bound)"
    lines["Red"]["30279"] = "Chicago/State (Howard-bound)"
    lines["Red"]["30065"] = "Grand/State (95th-bound)"
    lines["Red"]["30064"] = "Grand/State (Howard-bound)"
    lines["Red"]["30290"] = "Lake/State (95th-bound)"
    lines["Red"]["30289"] = "Lake/State (Howard-bound)"
    lines["Red"]["30212"] = "Monroe/State (95th-bound)"
    lines["Red"]["30211"] = "Monroe/State (Howard-bound)"
    lines["Red"]["30110"] = "Jackson/State (95th-bound)"
    lines["Red"]["30109"] = "Jackson/State (Howard-bound)"
    lines["Red"]["30286"] = "Harrison (95th-bound)"
    lines["Red"]["30285"] = "Harrison (Howard-bound)"
    lines["Red"]["30269"] = "Roosevelt/State (Howard-bound)"
    lines["Red"]["30270"] = "Roosevelt/State (Howard-bound)"
    lines["Red"]["30194"] = "Cermak-Chinatown (95th-bound)"
    lines["Red"]["30193"] = "Cermak-Chinatown (Howard-bound)"
    lines["Red"]["30037"] = "Sox-35th (95th-bound)"
    lines["Red"]["30036"] = "Sox-35th (Howard-bound)"
    lines["Red"]["30238"] = "47th-Dan Ryan (95th-bound)"
    lines["Red"]["30237"] = "47th-Dan Ryan (Howard-bound)"
    lines["Red"]["30224"] = "Garfield-Dan Ryan (95th-bound)"
    lines["Red"]["30223"] = "Garfield-Dan Ryan (Howard-bound)"
    lines["Red"]["30178"] = "63rd-Dan Ryan (95th-bound)"
    lines["Red"]["30177"] = "63rd-Dan Ryan (Howard-bound)"
    lines["Red"]["30192"] = "69th (95th-bound)"
    lines["Red"]["30191"] = "69th (Howard-bound)"
    lines["Red"]["30047"] = "79th (95th-bound)"
    lines["Red"]["30046"] = "79th (Howard-bound)"
    lines["Red"]["30276"] = "87th (95th-bound)"
    lines["Red"]["30275"] = "87th (Howard-bound)"
    lines["Red"]["30089"] = "95th/Dan Ryan (95th-bound)"
    lines["Red"]["30088"] = "95th/Dan Ryan (Howard-bound)"

    lines["Blue"]["30172"] = "O'Hare Airport (Forest Pk-bound)"
    lines["Blue"]["30171"] = "O'Hare Airport (Terminal Arrival)"
    lines["Blue"]["30160"] = "Rosemont (Forest Pk-bound)"
    lines["Blue"]["30159"] = "Rosemont (O'Hare-bound)"
    lines["Blue"]["30045"] = "Cumberland (Forest Pk-bound)"
    lines["Blue"]["30044"] = "Cumberland (O'Hare-bound)"
    lines["Blue"]["30146"] = "Harlem (O'Hare Branch) (Forest Pk-bound)"
    lines["Blue"]["30145"] = "Harlem (O'Hare Branch) (O'Hare-bound)"
    lines["Blue"]["30248"] = "Jefferson Park (Forest Pk-bound)"
    lines["Blue"]["30247"] = "Jefferson Park (O'Hare-bound)"
    lines["Blue"]["30260"] = "Montrose (Forest Pk-bound)"
    lines["Blue"]["30259"] = "Montrose (O'Hare-bound)"
    lines["Blue"]["30108"] = "Irving Park (O'Hare Branch) (Forest Pk-bound)"
    lines["Blue"]["30107"] = "Irving Park (O'Hare Branch) (O'Hare-bound)"
    lines["Blue"]["30240"] = "Addison (O'Hare Branch) (Forest Pk-bound)"
    lines["Blue"]["30239"] = "Addison (O'Hare Branch) (O'Hare-bound)"
    lines["Blue"]["30013"] = "Belmont (O'Hare Branch) (Forest Pk-bound)"
    lines["Blue"]["30012"] = "Belmont (O'Hare Branch) (O'Hare-bound)"
    lines["Blue"]["30198"] = "Logan Square (Forest Pk-bound)"
    lines["Blue"]["30197"] = "Logan Square (O'Hare-bound)"
    lines["Blue"]["30112"] = "California/Milwaukee (Forest Pk-bound)"
    lines["Blue"]["30111"] = "California/Milwaukee (O'Hare-bound)"
    lines["Blue"]["30130"] = "Western/Milwaukee (Forest Pk-bound)"
    lines["Blue"]["30129"] = "Western/Milwaukee (O'Hare-bound)"
    lines["Blue"]["30116"] = "Damen/Milwaukee (Forest Pk-bound)"
    lines["Blue"]["30115"] = "Damen/Milwaukee (O'Hare-bound)"
    lines["Blue"]["30063"] = "Division/Milwaukee (Forest Pk-bound)"
    lines["Blue"]["30062"] = "Division/Milwaukee (O'Hare-bound)"
    lines["Blue"]["30272"] = "Chicago/Milwaukee (Forest Pk-bound)"
    lines["Blue"]["30271"] = "Chicago/Milwaukee (O'Hare-bound)"
    lines["Blue"]["30096"] = "Grand/Milwaukee (Forest Pk-bound)"
    lines["Blue"]["30095"] = "Grand/Milwaukee (O'Hare-bound)"
    lines["Blue"]["30374"] = "Clark/Lake (Forest Pk-bound)"
    lines["Blue"]["30375"] = "Clark/Lake (O'Hare-bound)"
    lines["Blue"]["30073"] = "Washington/Dearborn (Forest Pk-bound)"
    lines["Blue"]["30072"] = "Washington/Dearborn (O'Hare-bound)"
    lines["Blue"]["30154"] = "Monroe/Dearborn (Forest Pk-bound)"
    lines["Blue"]["30153"] = "Monroe/Dearborn (O'Hare-bound)"
    lines["Blue"]["30015"] = "Jackson/Dearborn (Forest Pk-bound)"
    lines["Blue"]["30014"] = "Jackson/Dearborn (O'Hare-bound)"
    lines["Blue"]["30262"] = "LaSalle (Forest Pk-bound)"
    lines["Blue"]["30261"] = "LaSalle (O'Hare-bound)"
    lines["Blue"]["30085"] = "Clinton (Forest Pk-bound)"
    lines["Blue"]["30084"] = "Clinton (O'Hare-bound)"
    lines["Blue"]["30069"] = "UIC-Halsted (Forest Pk-bound)"
    lines["Blue"]["30068"] = "UIC-Halsted (O'Hare-bound)"
    lines["Blue"]["30093"] = "Racine (Forest Pk-bound)"
    lines["Blue"]["30092"] = "Racine (O'Hare-bound)"
    lines["Blue"]["30158"] = "Illinois Medical District (Forest Pk-bound)"
    lines["Blue"]["30157"] = "Illinois Medical District (O'Hare-bound)"
    lines["Blue"]["30043"] = "Western (Forest Pk-bound)"
    lines["Blue"]["30042"] = "Western (O'Hare-bound)"
    lines["Blue"]["30049"] = "Kedzie-Homan (Forest Pk-bound)"
    lines["Blue"]["30048"] = "Kedzie-Homan (O'Hare-bound)"
    lines["Blue"]["30180"] = "Pulaski (Forest Pk-bound)"
    lines["Blue"]["30179"] = "Pulaski (O'Hare-bound)"
    lines["Blue"]["30188"] = "Cicero (Forest Pk-bound)"
    lines["Blue"]["30187"] = "Cicero (O'Hare-bound)"
    lines["Blue"]["30002"] = "Austin (Forest Pk-bound)"
    lines["Blue"]["30001"] = "Austin (O'Hare-bound)"
    lines["Blue"]["30035"] = "Oak Park (Forest Pk-bound)"
    lines["Blue"]["30034"] = "Oak Park (O'Hare-bound)"
    lines["Blue"]["30190"] = "Harlem (Forest Pk-bound)"
    lines["Blue"]["30189"] = "Harlem (O'Hare-bound)"
    lines["Blue"]["30076"] = "Forest Park (O'Hare-bound)"
    lines["Blue"]["30077"] = "Forest Park (Terminal Arrival)"

    lines["Green"]["30004"] = "Harlem (Terminal arrival)"
    lines["Green"]["30003"] = "Harlem (63rd-bound)"
    lines["Green"]["30263"] = "Oak Park (63rd-bound)"
    lines["Green"]["30264"] = "Oak Park (Harlem-bound)"
    lines["Green"]["30119"] = "Ridgeland (63rd-bound)"
    lines["Green"]["30120"] = "Ridgeland (Harlem-bound)"
    lines["Green"]["30243"] = "Austin (63rd-bound)"
    lines["Green"]["30244"] = "Austin (Harlem-bound)"
    lines["Green"]["30054"] = "Central (63rd-bound)"
    lines["Green"]["30055"] = "Central (Harlem-bound)"
    lines["Green"]["30135"] = "Laramie (63rd-bound)"
    lines["Green"]["30136"] = "Laramie (Harlem-bound)"
    lines["Green"]["30094"] = "Cicero (63rd-bound)"
    lines["Green"]["30009"] = "Cicero (Harlem-bound)"
    lines["Green"]["30005"] = "Pulaski (63rd-bound)"
    lines["Green"]["30006"] = "Pulaski (Harlem-bound)"
    lines["Green"]["30291"] = "Conservatory (63rd-bound)"
    lines["Green"]["30292"] = "Conservatory (Harlem-bound)"
    lines["Green"]["30207"] = "Kedzie (63rd-bound)"
    lines["Green"]["30208"] = "Kedzie (Harlem-bound)"
    lines["Green"]["30265"] = "California (63rd-bound)"
    lines["Green"]["30266"] = "California (Harlem-bound)"
    lines["Green"]["30032"] = "Ashland (Harlem-54th/Cermak-bound)"
    lines["Green"]["30033"] = "Ashland (Loop-63rd-bound)"
    lines["Green"]["30296"] = "Morgan (Harlem-54th/Cermak-bound)"
    lines["Green"]["30295"] = "Morgan (Loop-63rd-bound)"
    lines["Green"]["30222"] = "Clinton (Harlem-54th/Cermak-bound)"
    lines["Green"]["30221"] = "Clinton (Loop-63rd-bound)"
    lines["Green"]["30074"] = "Clark/Lake (Inner Loop)"
    lines["Green"]["30075"] = "Clark/Lake (Outer Loop)"
    lines["Green"]["30050"] = "State/Lake (Inner Loop)"
    lines["Green"]["30051"] = "State/Lake (Outer Loop)"
    lines["Green"]["30039"] = "Randolph/Wabash (Inner Loop)"
    lines["Green"]["30038"] = "Randolph/Wabash (Outer Loop)"
    lines["Green"]["30124"] = "Madison/Wabash (Inner Loop)"
    lines["Green"]["30123"] = "Madison/Wabash (Outer Loop)"
    lines["Green"]["30132"] = "Adams/Wabash (Inner Loop)"
    lines["Green"]["30131"] = "Adams/Wabash (Outer Loop)"
    lines["Green"]["30080"] = "Roosevelt/Wabash (Loop-Harlem-bound)"
    lines["Green"]["30081"] = "Roosevelt/Wabash (Midway-63rd-bound)"
    lines["Green"]["30214"] = "35-Bronzeville-IIT (63rd-bound)"
    lines["Green"]["30213"] = "35-Bronzeville-IIT (Harlem-bound)"
    lines["Green"]["30059"] = "Indiana (63rd-bound)"
    lines["Green"]["30058"] = "Indiana (Harlem-bound)"
    lines["Green"]["30246"] = "43rd (63rd-bound)"
    lines["Green"]["30245"] = "43rd (Harlem-bound)"
    lines["Green"]["30210"] = "47th (63rd-bound) Elevated (63rd-bound)"
    lines["Green"]["30209"] = "47th (SB) Elevated (Harlem-bound)"
    lines["Green"]["30025"] = "51st (63rd-bound)"
    lines["Green"]["30024"] = "51st (Harlem-bound)"
    lines["Green"]["30100"] = "Garfield (63rd-bound)"
    lines["Green"]["30099"] = "Garfield (Harlem-bound)"
    lines["Green"]["30184"] = "Halsted/63rd (Ashland-bound)"
    lines["Green"]["30183"] = "Halsted/63rd (Harlem-bound)"
    lines["Green"]["30056"] = "Ashland/63rd (Harlem-bound)"
    lines["Green"]["30057"] = "Ashland/63rd (Terminal arrival)"
    lines["Green"]["30217"] = "King Drive (Cottage Grove-bound)"
    lines["Green"]["30218"] = "King Drive (Harlem-bound)"
    lines["Green"]["30139"] = "Cottage Grove (Terminal arrival)"
    lines["Green"]["30140"] = "East 63rd-Cottage Grove (Harlem-bound)"

    lines["Brown"]["30250"] = "Kimball (Loop-bound)"
    lines["Brown"]["30249"] = "Kimball (Terminal arrival)"
    lines["Brown"]["30225"] = "Kedzie (Kimball-bound)"
    lines["Brown"]["30226"] = "Kedzie (Loop-bound)"
    lines["Brown"]["30167"] = "Francisco (Kimball-bound)"
    lines["Brown"]["30168"] = "Francisco (Loop-bound)"
    lines["Brown"]["30195"] = "Rockwell (Kimball-bound)"
    lines["Brown"]["30196"] = "Rockwell (Loop-bound)"
    lines["Brown"]["30283"] = "Western (Kimball-bound)"
    lines["Brown"]["30284"] = "Western (Loop-bound)"
    lines["Brown"]["30018"] = "Damen (Kimball-bound)"
    lines["Brown"]["30019"] = "Damen (Loop-bound)"
    lines["Brown"]["30287"] = "Montrose (Kimball-bound)"
    lines["Brown"]["30288"] = "Montrose (Loop-bound)"
    lines["Brown"]["30281"] = "Irving Park (Kimball-bound)"
    lines["Brown"]["30282"] = "Irving Park (Loop-bound)"
    lines["Brown"]["30277"] = "Addison (Kimball-bound)"
    lines["Brown"]["30278"] = "Addison (Loop-bound)"
    lines["Brown"]["30253"] = "Paulina (Kimball-bound)"
    lines["Brown"]["30254"] = "Paulina (Loop-bound)"
    lines["Brown"]["30070"] = "Southport (Kimball-bound)"
    lines["Brown"]["30071"] = "Southport (Loop-bound)"
    lines["Brown"]["30257"] = "Belmont (Kimball-Linden-bound)"
    lines["Brown"]["30258"] = "Belmont (Loop-bound)"
    lines["Brown"]["30231"] = "Wellington (Kimball-Linden-bound)"
    lines["Brown"]["30232"] = "Wellington (Loop-bound)"
    lines["Brown"]["30103"] = "Diversey (Kimball-Linden-bound)"
    lines["Brown"]["30104"] = "Diversey (Loop-bound)"
    lines["Brown"]["30235"] = "Fullerton (Kimball-Linden-bound)"
    lines["Brown"]["30236"] = "Fullerton (Loop-bound)"
    lines["Brown"]["30127"] = "Armitage (Kimball-Linden-bound)"
    lines["Brown"]["30128"] = "Armitage (Loop-bound)"
    lines["Brown"]["30155"] = "Sedgwick (Kimball-Linden-bound)"
    lines["Brown"]["30156"] = "Sedgwick (Loop-bound)"
    lines["Brown"]["30137"] = "Chicago/Franklin (Kimball-Linden-bound)"
    lines["Brown"]["30138"] = "Chicago/Franklin (Loop-bound)"
    lines["Brown"]["30090"] = "Merchandise Mart (Kimball-Linden-bound)"
    lines["Brown"]["30091"] = "Merchandise Mart (Loop-bound)"
    lines["Brown"]["30142"] = "Washington/Wells (Outer Loop)"
    lines["Brown"]["30008"] = "Quincy/Wells (Outer Loop)"
    lines["Brown"]["30030"] = "LaSalle/Van Buren (Outer Loop)"
    lines["Brown"]["30165"] = "Library (Outer Loop)"
    lines["Brown"]["30131"] = "Adams/Wabash (Outer Loop)"
    lines["Brown"]["30123"] = "Madison/Wabash (Outer Loop)"
    lines["Brown"]["30038"] = "Randolph/Wabash (Outer Loop)"
    lines["Brown"]["30051"] = "State/Lake (Outer Loop)"
    lines["Brown"]["30075"] = "Clark/Lake (Outer Loop)"

    lines["Purple"]["30204"] = "Linden (Howard-Loop-bound)"
    lines["Purple"]["30203"] = "Linden (Linden-bound)"
    lines["Purple"]["30242"] = "Central-Evanston (Howard-Loop-bound)"
    lines["Purple"]["30241"] = "Central-Evanston (Linden-bound)"
    lines["Purple"]["30079"] = "Noyes (Howard-Loop-bound)"
    lines["Purple"]["30078"] = "Noyes (Linden-bound)"
    lines["Purple"]["30102"] = "Foster (Howard-Loop-bound)"
    lines["Purple"]["30101"] = "Foster (Linden-bound)"
    lines["Purple"]["30011"] = "Davis (Howard-Loop-bound)"
    lines["Purple"]["30010"] = "Davis (Linden-bound)"
    lines["Purple"]["30134"] = "Dempster (Howard-Loop-bound)"
    lines["Purple"]["30133"] = "Dempster (Linden-bound)"
    lines["Purple"]["30053"] = "Main (Howard-Loop-bound)"
    lines["Purple"]["30052"] = "Main (Linden-bound)"
    lines["Purple"]["30164"] = "South Blvd (Howard-Loop-bound)"
    lines["Purple"]["30163"] = "South Blvd (Linden-bound)"
    lines["Purple"]["30175"] = "Howard (NB) (Linden, Skokie-bound)"
    lines["Purple"]["30176"] = "Howard (Terminal arrival)"

    lines["PurpleExp"]["30204"] = "Linden (Howard-Loop-bound)"
    lines["PurpleExp"]["30203"] = "Linden (Linden-bound)"
    lines["PurpleExp"]["30242"] = "Central-Evanston (Howard-Loop-bound)"
    lines["PurpleExp"]["30241"] = "Central-Evanston (Linden-bound)"
    lines["PurpleExp"]["30079"] = "Noyes (Howard-Loop-bound)"
    lines["PurpleExp"]["30078"] = "Noyes (Linden-bound)"
    lines["PurpleExp"]["30102"] = "Foster (Howard-Loop-bound)"
    lines["PurpleExp"]["30101"] = "Foster (Linden-bound)"
    lines["PurpleExp"]["30011"] = "Davis (Howard-Loop-bound)"
    lines["PurpleExp"]["30010"] = "Davis (Linden-bound)"
    lines["PurpleExp"]["30134"] = "Dempster (Howard-Loop-bound)"
    lines["PurpleExp"]["30133"] = "Dempster (Linden-bound)"
    lines["PurpleExp"]["30053"] = "Main (Howard-Loop-bound)"
    lines["PurpleExp"]["30052"] = "Main (Linden-bound)"
    lines["PurpleExp"]["30164"] = "South Blvd (Howard-Loop-bound)"
    lines["PurpleExp"]["30163"] = "South Blvd (Linden-bound)"
    lines["PurpleExp"]["30175"] = "Howard (NB) (Linden, Skokie-bound)"
    lines["PurpleExp"]["30176"] = "Howard (Terminal arrival)"
    lines["PurpleExp"]["30257"] = "Belmont (Kimball-Linden-bound)"
    lines["PurpleExp"]["30258"] = "Belmont (Loop-bound)"
    lines["PurpleExp"]["30231"] = "Wellington (Kimball-Linden-bound)"
    lines["PurpleExp"]["30232"] = "Wellington (Loop-bound)"
    lines["PurpleExp"]["30103"] = "Diversey (Kimball-Linden-bound)"
    lines["PurpleExp"]["30104"] = "Diversey (Loop-bound)"
    lines["PurpleExp"]["30235"] = "Fullerton (Kimball-Linden-bound)"
    lines["PurpleExp"]["30236"] = "Fullerton (Loop-bound)"
    lines["PurpleExp"]["30127"] = "Armitage (Kimball-Linden-bound)"
    lines["PurpleExp"]["30128"] = "Armitage (Loop-bound)"
    lines["PurpleExp"]["30155"] = "Sedgwick (Kimball-Linden-bound)"
    lines["PurpleExp"]["30156"] = "Sedgwick (Loop-bound)"
    lines["PurpleExp"]["30137"] = "Chicago/Franklin (Kimball-Linden-bound)"
    lines["PurpleExp"]["30138"] = "Chicago/Franklin (Loop-bound)"
    lines["PurpleExp"]["30090"] = "Merchandise Mart (Kimball-Linden-bound)"
    lines["PurpleExp"]["30091"] = "Merchandise Mart (Loop-bound)"
    lines["PurpleExp"]["30074"] = "Clark/Lake (Inner Loop)"
    lines["PurpleExp"]["30050"] = "State/Lake (Inner Loop)"
    lines["PurpleExp"]["30039"] = "Randolph/Wabash (Inner Loop)"
    lines["PurpleExp"]["30124"] = "Madison/Wabash (Inner Loop)"
    lines["PurpleExp"]["30132"] = "Adams/Wabash (Inner Loop)"
    lines["PurpleExp"]["30166"] = "Library (Inner Loop)"
    lines["PurpleExp"]["30031"] = "LaSalle/Van Buren (Inner Loop)"
    lines["PurpleExp"]["30007"] = "Quincy/Wells (Inner Loop)"
    lines["PurpleExp"]["30141"] = "Washington/Wells (Inner Loop)"

    lines["Yellow"]["30026"] = "Skokie (Arrival)"
    lines["Yellow"]["30027"] = "Skokie (Howard-bound)"
    lines["Yellow"]["30297"] = "Oakton (Dempster-Skokie-bound)"
    lines["Yellow"]["30298"] = "Oakton (Howard-bound)"
    lines["Yellow"]["30175"] = "Howard (NB) (Linden, Skokie-bound)"
    lines["Yellow"]["30176"] = "Howard (Terminal arrival)"

    lines["Pink"]["30113"] =    "54th/Cermak (Loop-bound)"
    lines["Pink"]["30114"] =    "54th/Cermak (Terminal arrival)"
    lines["Pink"]["30083"] =    "Cicero (54th/Cermak-bound)"
    lines["Pink"]["30082"] =    "Cicero (Loop-bound)"
    lines["Pink"]["30118"] =    "Kostner (54th/Cermak-bound)"
    lines["Pink"]["30117"] =    "Kostner (Loop-bound)"
    lines["Pink"]["30029"] =    "Pulaski (54th/Cermak-bound)"
    lines["Pink"]["30028"] =    "Pulaski (Loop-bound)"
    lines["Pink"]["30152"] =    "Central Park (54th/Cermak-bound)"
    lines["Pink"]["30151"] =    "Central Park (Loop-bound)"
    lines["Pink"]["30202"] =    "Kedzie (54th/Cermak-bound)"
    lines["Pink"]["30201"] =    "Kedzie (Loop-bound)"
    lines["Pink"]["30087"] =    "California (54th/Cermak-bound)"
    lines["Pink"]["30086"] =    "California (Loop-bound)"
    lines["Pink"]["30144"] =    "Western (54th/Cermak-bound)"
    lines["Pink"]["30143"] =    "Western (Loop-bound)"
    lines["Pink"]["30041"] =    "Damen (54th/Cermak-bound)"
    lines["Pink"]["30040"] =    "Damen (Loop-bound)"
    lines["Pink"]["30162"] =    "18th (54th/Cermak-bound)"
    lines["Pink"]["30161"] =    "18th (Loop-bound)"
    lines["Pink"]["30200"] =    "Polk (54th/Cermak-bound)"
    lines["Pink"]["30199"] =    "Polk (Loop-bound)"
    lines["Pink"]["30032"] =    "Ashland (Harlem-54th/Cermak-bound)"
    lines["Pink"]["30033"] =    "Ashland (Loop-63rd-bound)"
    lines["Pink"]["30296"] =    "Morgan (Harlem-54th/Cermak-bound)"
    lines["Pink"]["30295"] =    "Morgan (Loop-63rd-bound)"
    lines["Pink"]["30222"] =    "Clinton (Harlem-54th/Cermak-bound)"
    lines["Pink"]["30221"] =    "Clinton (Loop-63rd-bound)"
    lines["Pink"]["30074"] =    "Clark/Lake (Inner Loop)"
    lines["Pink"]["30050"] =    "State/Lake (Inner Loop)"
    lines["Pink"]["30039"] =    "Randolph/Wabash (Inner Loop)"
    lines["Pink"]["30124"] =    "Madison/Wabash (Inner Loop)"
    lines["Pink"]["30132"] =    "Adams/Wabash (Inner Loop)"
    lines["Pink"]["30166"] =    "Library (Inner Loop)"
    lines["Pink"]["30031"] =    "LaSalle/Van Buren (Inner Loop)"
    lines["Pink"]["30007"] =    "Quincy/Wells (Inner Loop)"
    lines["Pink"]["30141"] =    "Washington/Wells (Inner Loop)"

    lines["Orange"]["30182"] = "Midway (Arrival)"
    lines["Orange"]["30181"] = "Midway (Loop-bound)"
    lines["Orange"]["30185"] = "Pulaski (Loop-bound)"
    lines["Orange"]["30186"] = "Pulaski (Midway-bound)"
    lines["Orange"]["30219"] = "Kedzie (Loop-bound)"
    lines["Orange"]["30220"] = "Kedzie (Midway-bound)"
    lines["Orange"]["30060"] = "Western (Loop-bound)"
    lines["Orange"]["30061"] = "Western (Midway-bound)"
    lines["Orange"]["30022"] = "35th/Archer (Loop-bound)"
    lines["Orange"]["30023"] = "35th/Archer (Midway-bound)"
    lines["Orange"]["30205"] = "Ashland (Loop-bound)"
    lines["Orange"]["30206"] = "Ashland (Midway-bound)"
    lines["Orange"]["30215"] = "Halsted (Loop-bound)"
    lines["Orange"]["30216"] = "Halsted (Midway-bound)"
    lines["Orange"]["30080"] = "Roosevelt/Wabash (Loop-Harlem-bound)"
    lines["Orange"]["30081"] = "Roosevelt/Wabash (Midway-63rd-bound)"
    lines["Orange"]["30166"] = "Library (Inner Loop)"
    lines["Orange"]["30031"] = "LaSalle/Van Buren (Inner Loop)"
    lines["Orange"]["30007"] = "Quincy/Wells (Inner Loop)"
    lines["Orange"]["30141"] = "Washington/Wells (Inner Loop)"
    lines["Orange"]["30074"] = "Clark/Lake (Inner Loop)"
    lines["Orange"]["30050"] = "State/Lake (Inner Loop)"
    lines["Orange"]["30039"] = "Randolph/Wabash (Inner Loop)"
    lines["Orange"]["30124"] = "Madison/Wabash (Inner Loop)"
    lines["Orange"]["30132"] = "Adams/Wabash (Inner Loop)"

    return lines
  end

end
