function submitForm(id, action) {
  if (action != 'null') $(id).action = action;
  $(id).submit();
}


function roundNumber(num, dec) {
  result = Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
  return result;
}

function makeGrosze(price) {
  //if (price == 0) return 0.00;
  strNumber = "" + price;
  kwota = strNumber.split("\.");
  zlote = kwota[0];
  if (kwota[1] != undefined) {
    grosze = kwota[1];
    last = grosze.length;
    if (last == 1) grosze = grosze + "0";
  } else {
    grosze = "00";
    //grosze = "";
  }
  price = kwota[0] + "." + grosze;
  //price = kwota[0];

  return price;
}


function change_time() {
  $('#intro_tab' + actual_tab).hide();
  $('#tab' + actual_tab).removeClass('on');

  actual_tab++;
  if (actual_tab > 3) actual_tab = 1;

  $('#tab' + actual_tab).addClass('on');
  $('#intro_tab' + actual_tab).show();

  change_item = setTimeout('change_time()', 10000);
}
function reset_intro() {
  clearTimeout(change_item);
  change_item = setTimeout('change_time()', 10000);
}


var free_card = false;
//jQuery.noConflict();
$(document).ready(function($) {
  $('a.tip').qtip({
    position: {
      my: 'bottom center',
      at: 'top center'
    }
  });
  $('area').qtip({
    position: {
      my: 'left center',
      at: 'center'
    }
  });

  if ($('#new_candidate') != null) {
    $('ul.offer-card li').bind('click', function() {
      $('ul.offer-card li').each(function() {
        $(this).removeClass('active');
      });
//      li_id = 'o' + $(this).attr('id');
      li_id = $(this).attr('id');
      $('ul.offer-card li#' + li_id).addClass('active');
      if (li_id == 'opt_1') {
        $('#ads').slideDown('slow');
        $('#basic').slideDown('slow');
        $('#extended').slideUp('slow');
      } else {
        $('#basic').slideDown('slow');
        $('#extended').slideDown('slow');
        $('#ads').slideDown('slow');
//        $('#buttons').slideDown('slow');
      }
      $('.formtastic').valtastic();

      card_option = li_id.split('_');
      last_card_option = $('#candidate_card_option').val();
      $('#candidate_card_option').val(card_option[1]);
      if (last_card_option != card_option[1]) {
        set_candidate_amount(get_amount_offer(last_card_option) * (-1), false);
        set_candidate_amount(get_amount_offer(card_option[1]), false);
      }
    });

    $('ul.offer li a.fa').bind('click', function() {
      li_oid = 'a' + $(this).attr('id');
      if (!$('ul.offer li#' + li_oid).hasClass('active')) {
        $('ul.offer li#' + li_oid).addClass('active');
        $('ul.offer li#' + li_oid + ' a.cancel').toggle();
        set_candidate_ads(li_oid, true);
        return false;
      } else {
        return false;
      }
    });
    if ($('#candidate_is_main_ad').val() == 'true') {
      $('ul.offer li#ads_1').addClass('active');
      $('ul.offer li#ads_1 a.cancel').toggle();
      free_card = true;
    }
    if ($('#candidate_is_state_ad').val() == 'true') {
      $('ul.offer li#ads_2').addClass('active');
      $('ul.offer li#ads_2 a.cancel').toggle();
      free_card = true;
    }
    if ($('#candidate_is_district_ad').val() == 'true') {
      $('ul.offer li#ads_3').addClass('active');
      $('ul.offer li#ads_3 a.cancel').toggle();
      free_card = true;
    }
    $('ul.offer-card li#opt_' + $('#candidate_card_option').val()).addClass('active');
    if ($('#candidate_card_option').val() == 1) {
      $('#basic').slideDown('slow');
      $('#ads').slideDown('slow');
      $('.formtastic').valtastic();
    } else if ($('#candidate_card_option').val() > 1) {
      $('#basic').slideDown('slow');
      $('#extended').slideDown('slow');
      $('#ads').slideDown('slow');
      $('.formtastic').valtastic();
    }
    check_amount();
  }
});


function cancel_offer(o) {
  li_cid = 'a' + $(o).prev().attr('id');
  $('ul.offer li#' + li_cid).removeClass('active');
  set_candidate_ads(li_cid, false);
  $(o).toggle();
  return false;
}

function check_amount() {
  amount = $('#candidate_amount').val() * 1;
  new_amount = amount;
  old_amount = $('#candidate_old_amount').val() * 1;
  new_amount -= old_amount;
  $('#order_amount').html(makeGrosze(new_amount));
  amount_br = makeGrosze(roundNumber(new_amount * 1.23, 2));
  $('#order_amount_br').html(amount_br);

//  alert(old_amount + ' - ' + amount);
  if (amount > old_amount) {
    $('#payment_info').show();
  } else {
    $('#payment_info').hide();
  }
}


function set_candidate_ads(ad, flag) {
  if (ad == 'ads_1') {
    $('#candidate_is_main_ad').val(flag);
    amount = 1000;
  } else if (ad == 'ads_2') {
    $('#candidate_is_state_ad').val(flag);
    amount = 500;
  } else if (ad == 'ads_3') {
    $('#candidate_is_district_ad').val(flag);
    amount = 100;
  }
  if (flag == true) {
    set_candidate_amount(amount, true);
  } else {
    set_candidate_amount(amount * (-1), true);
  }
}

function get_amount_offer(card_option) {
  card_option = card_option * 1;
  if (free_card == true) {
    return 0;
  }
  switch (card_option) {
    case 2:
      amount = 30;
      break;
    case 3:
      amount = 50;
      break;
    default:
      amount = 0;
  }
  return amount;
}

function set_candidate_amount(amount, is_add) {
  actual_value = $('#candidate_amount').val() * 1;
  if (actual_value < 0) {
    actual_value = 0;
  }
  if (free_card == false && is_add == true) {
    actual_value = actual_value - get_amount_offer($('#candidate_card_option').val());
    free_card = true;
  }
  amount = (actual_value + amount);
  if (amount == 0 && free_card == true) {
    free_card = false;
    amount = get_amount_offer($('#candidate_card_option').val());
  }
  $('#candidate_amount').val(amount);
  check_amount();
}
function CD_T(id, e) {
  var n = new Date();
  CD_D(+n, id, e);
  setTimeout("if(typeof CD_T=='function'){CD_T('" + id + "'," + e + ")}", 1100 - n.getMilliseconds())
}
function CD_D(n, id, e) {
  var ms = e - n;
  if (ms <= 0) ms *= -1;
  var d = Math.floor(ms / 864E5);
  ms -= d * 864E5;
  var h = Math.floor(ms / 36E5);
  ms -= h * 36E5;
  var m = Math.floor(ms / 6E4);
  ms -= m * 6E4;
  var s = Math.floor(ms / 1E3);
  if (CD_OBJS[id]) {
    CD_OBJS[id].innerHTML = d + " " + (d == 1 ? " dzień " : "dni ") + CD_ZP(h) + " godz. " + CD_ZP(m) + " min. " + CD_ZP(s) + " sek."
  }
}
function CD_ZP(i) {
  return(i < 10 ? "0" + i : i)
}
function CD_Init() {
  var pref = "countdown";
  var objH = 1;
  if (document.getElementById || document.all) {
    for (var i = 1; objH; ++i) {
      var id = pref + i;
      objH = document.getElementById ? document.getElementById(id) : document.all[id];
      if (objH && (typeof objH.innerHTML) != 'undefined') {
        var s = objH.innerHTML;
        var dt = CD_Parse(s);
        if (!isNaN(dt)) {
          CD_OBJS[id] = objH;
          CD_T(id, dt.valueOf());
          if (objH.style) {
            objH.style.visibility = "visible"
          }
        } else {
          objH.innerHTML = s + "<a href=\"http://andrewu.co.uk/clj/countdown/\" title=\"Countdown Error:Invalid date format used,check documentation (see link)\">*</a>"
        }
      }
    }
  }
}
function CD_Parse(strDate) {
  var objReDte = /(\d{4})\-(\d{1,2})\-(\d{1,2})\s+(\d{1,2}):(\d{1,2}):(\d{0,2})\s+GMT([+\-])(\d{1,2}):?(\d{1,2})?/;
  if (strDate.match(objReDte)) {
    var d = new Date(0);
    d.setUTCFullYear(+RegExp.$1, +RegExp.$2 - 1, +RegExp.$3);
    d.setUTCHours(+RegExp.$4, +RegExp.$5, +RegExp.$6);
    var tzs = (RegExp.$7 == "-" ? -1 : 1);
    var tzh = +RegExp.$8;
    var tzm = +RegExp.$9;
    if (tzh) {
      d.setUTCHours(d.getUTCHours() - tzh * tzs)
    }
    if (tzm) {
      d.setUTCMinutes(d.getUTCMinutes() - tzm * tzs)
    }
    return d
  } else {
    return NaN
  }
}
var CD_OBJS = new Object();
//if(window.attachEvent){window.attachEvent('onload',CD_Init)}else if(window.addEventListener){window.addEventListener("load",CD_Init,false)}else {window.onload=CD_Init};

jQuery.getPos = function (e)
{
	var l = 0;
	var t  = 0;
	var w = jQuery.intval(jQuery.css(e,'width'));
	var h = jQuery.intval(jQuery.css(e,'height'));
	var wb = e.offsetWidth;
	var hb = e.offsetHeight;
	while (e.offsetParent){
		l += e.offsetLeft + (e.currentStyle?jQuery.intval(e.currentStyle.borderLeftWidth):0);
		t += e.offsetTop  + (e.currentStyle?jQuery.intval(e.currentStyle.borderTopWidth):0);
		e = e.offsetParent;
	}
	l += e.offsetLeft + (e.currentStyle?jQuery.intval(e.currentStyle.borderLeftWidth):0);
	t  += e.offsetTop  + (e.currentStyle?jQuery.intval(e.currentStyle.borderTopWidth):0);
	return {x:l, y:t, w:w, h:h, wb:wb, hb:hb};
};
jQuery.getClient = function(e)
{
	if (e) {
		w = e.clientWidth;
		h = e.clientHeight;
	} else {
		w = (window.innerWidth) ? window.innerWidth : (document.documentElement && document.documentElement.clientWidth) ? document.documentElement.clientWidth : document.body.offsetWidth;
		h = (window.innerHeight) ? window.innerHeight : (document.documentElement && document.documentElement.clientHeight) ? document.documentElement.clientHeight : document.body.offsetHeight;
	}
	return {w:w,h:h};
};
jQuery.getScroll = function (e)
{
	if (e) {
		t = e.scrollTop;
		l = e.scrollLeft;
		w = e.scrollWidth;
		h = e.scrollHeight;
	} else  {
		if (document.documentElement && document.documentElement.scrollTop) {
			t = document.documentElement.scrollTop;
			l = document.documentElement.scrollLeft;
			w = document.documentElement.scrollWidth;
			h = document.documentElement.scrollHeight;
		} else if (document.body) {
			t = document.body.scrollTop;
			l = document.body.scrollLeft;
			w = document.body.scrollWidth;
			h = document.body.scrollHeight;
		}
	}
	return { t: t, l: l, w: w, h: h };
};

jQuery.intval = function (v)
{
	v = parseInt(v);
	return isNaN(v) ? 0 : v;
};

jQuery.fn.ScrollTo = function(s) {
	o = jQuery.speed(s);
	return this.each(function(){
		new jQuery.fx.ScrollTo(this, o);
	});
};

jQuery.fx.ScrollTo = function (e, o)
{
	var z = this;
	z.o = o;
	z.e = e;
	z.p = jQuery.getPos(e);
	z.s = jQuery.getScroll();
	z.clear = function(){clearInterval(z.timer);z.timer=null};
	z.t=(new Date).getTime();
	z.step = function(){
		var t = (new Date).getTime();
		var p = (t - z.t) / z.o.duration;
		if (t >= z.o.duration+z.t) {
			z.clear();
			setTimeout(function(){z.scroll(z.p.y, z.p.x)},13);
		} else {
			st = ((-Math.cos(p*Math.PI)/2) + 0.5) * (z.p.y-z.s.t) + z.s.t;
			sl = ((-Math.cos(p*Math.PI)/2) + 0.5) * (z.p.x-z.s.l) + z.s.l;
			z.scroll(st, sl);
		}
	};
	z.scroll = function (t, l){window.scrollTo(l, t)};
	z.timer=setInterval(function(){z.step();},13);
};