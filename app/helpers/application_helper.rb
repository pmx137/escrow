#encoding: utf-8
require 'base64'
module ApplicationHelper
  def image_tag(source, options = {})
    options[:title] = h(options[:alt]).strip
    options[:alt] = options[:title]
    super(source, options)
  end

  def time_ago_in_words(date, text='dodano')
    content = super(date) +' '+ t(:ago)
    content = "<span class='time-ago'>#{text}: #{content}</span>" unless text.blank?
    raw(content)
  end

  def slice_string(string, start=0, stop=100, end_str='...')
    return string if string.length < stop

    string = string.slice(start, stop)
    if string[-1] == 32
      string.chop << end_str
    else
      string.slice(start, string.rindex(' ')) << end_str
    end
  end

  def png(image, options = {})
    options[:alt] = options[:title] || ''
    image_tag("#{image}.png", options)
  end

  def jpg(image, options = {})
    options[:alt] = options[:title] || ''
    image_tag("#{image}.jpg", options)
  end

  def gif(image, options = {})
    options[:alt] = options[:title] || ''
    image_tag("#{image}.gif", options)
  end

  def link_href (name, href, options={})
    options[:href] = href
    link_to name, {}, options
  end


  def how_many_days(date)
    secs = ((Time.now-date)/86400)
    secs.to_i
  end

  def time_to_end(date)

    if !date.blank? and date > Time.now
      distance_of_time_in_words date, Time.now
    else
      'czas minął'
    end
  end


  def colorbox selector, args={}
    content = "<script type='text/javascript'>"
    content << "$('#{selector}').colorbox({width:#{args[:width]||740},height:#{args[:height]||500},opacity:0.7,fixed:true,arrowKey:#{args[:arrowKey]||true},iframe:#{args[:iframe]||false},title:false,current:' Zaliczka {current} z {total}'});"
    content << '</script>'
    raw(content)
  end

  def number_to_currency(number, options = {})
    options.merge({:unit=> 'zł', :separator=> ',', :delimiter=> ' ', :format=> "%n %u"})
    super(number, options)
  end

  def set_price(price, clear=false)

    if price.to_f > 0
      price = number_to_currency(price, {:unit=> 'zł', :separator=> ',', :delimiter=> ' ', :format=> "%n %u"})
    else
      price = 'za darmo!'
    end
    return price if clear
    raw "<span class=\"price\">#{price}</span>"
  end

  def is_logged?
    return true if current_user
    false
  end

  def encode_request_uri
    Base64.encode64(request.request_uri)
  end

  def top_menu current_page=''

    pages = [
      [new_payment_path, 'Wpłać zaliczkę'],
      [ask_payment_path(1), 'Poproś o zaliczkę'],
      [mission_path, 'Misja'],
      is_logged? ? [pro_index_path, 'Moje konto'] : [login_path, 'Zaloguj się'],
      [contact_path, 'Kontakt']
    ]
    content = "<ul>"
    pages.each do |p|
      unless p.nil?
        content << '<li'
        content << " class='current'" if current_page == p[0].to_s
        content << " title='#{p[1]}'>" + link_to(p[1], p[0], :class=> p[0].gsub(/\//, ''))
        content << "</li>"
      end
    end
    content << '</ul>'

    raw content
  end

  def banks
      @banks = {
        'alior'=> 'https://aliorbank.pl/hades/do/Login',
        'allianz'=> 'https://www.getbank24.pl/',
        'bgz'=> 'https://www.ebgz.pl/detal-web/jbank/unlogged/choose/method.do',
        'bos'=> 'https://bosbank24.pl/twojekonto',
        'bphb'=> 'https://www.bph.pl/pi/do/Login?PBL_PBL_IS=Y',
        'bps'=> 'https://bps25.pl/',
        'bre'=> 'https://www.ibre.com.pl/mt/',
        'bsw'=> 'https://www.net-bank.com.pl/',
        'citibank'=> 'https://www.online.citibank.pl/PLGCB/JPS/portal/LocaleSwitch.do?locale=pl_PL',
        'deutsche'=> 'https://ebank.db-pbc.pl/',
        'dnb'=> 'https://www.serwisinternetowy.dnbnord.pl/',
        'e_bph'=> 'https://www.bph.pl/pi/do/Login?PBL_PBL_IS=Y',
        'e_inteligo'=> 'https://secure.inteligo.com.pl/web',
        'e_mbank'=> 'https://www.mbank.com.pl/',
        'e_multibank'=> 'https://moj.multibank.pl/',
        'e_wbk'=> 'https://www.centrum24.pl/centrum24-web/home',
        'fm'=> 'https://bank.fmbank24.pl/',
        'fortis'=> 'https://planet.bnpparibas.pl/hades/do/Login',
        'getin'=> 'https://bank.gb24.pl/',
        'ing'=> 'https://ssl.bsk.com.pl/bskonl/login.html',
        'invest'=> 'https://www.investkonto.pl/auth/login.html',
        'kb'=> 'https://www.kb24.pl/',
        'lukas'=> 'https://e-bank.credit-agricole.pl/',
        'meritum'=> 'https://www.meritumbank.pl/',
        'millebiz'=> 'https://www.bankmillennium.pl/firmy/Default.qz?LanguageID=pl-PL',
        'millennium'=> 'https://www.bankmillennium.pl/osobiste/Default.qz?LanguageID=pl-PL',
        'neobank'=> 'https://www.neobank.pl/ibanking/',
        'nordea'=> 'https://netbank.nordea.pl/pnb/login.do?ts=PL&language=pl',
        'pekao24'=> 'https://www.pekao24.pl/',
        'pekaobiz'=> 'https://www.pekaobiznes24.pl/do/login',
        'pko'=> 'https://www.ipko.pl',
        'pocztowy'=> 'https://www.pocztowy24.pl/',
        'polbank'=> 'https://www.polbank24.pl/netbanking/',
        'raiffeisen'=> 'https://www.r-bank.pl/',
        'sgb'=> 'https://bank.sgb24.pl/sgb',
        'skok'=> 'https://e-skok.pl/eSkokWeb/login.jsp',
        'toyota'=> 'https://konto.toyotabank.pl/',
        'vw'=> 'https://login.vwbankdirect.pl/',
      }
      content = '<ul class="banks">'
        @banks.sort.each do |v|
          content << '<li>'
          content << link_to(png('banks/'+v[0]), '', :href=> v[1], :target=> 'bank')
          content << '</li>'
        end
      content << '</ul>'
      raw(content)
  end

  def payment_state(state)
    states = {
      -1 => 'nieopłacony',
      0 => 'zaksięgowany',
      1 => 'w realizacji',
      2 => 'opłacony',
    }
    states[state] ||='brak'
  end
end