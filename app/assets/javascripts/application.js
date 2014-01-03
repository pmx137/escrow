// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
// require_tree .

//= require jquery.min
//= require colorbox
//= require jquery.valtastic
//= require cufon-yui
//= require rails
//= require fonts/myriad.cufonfonts

//= require_self
function is_url(sUrl) {
  var e = /(^(http|www\.))/ig; // /((http|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+\.[^#?\s]+)(#[\w\-]+)?/;
  return sUrl.match(e);
}

$(document).ready(function() {
  $('a.disabled').bind('click', function(){
    return false;
  });
  $('a.disabled img').attr('title', 'opcja niedostępna');

  if ($('.formtastic').length) {
    $('.formtastic').valtastic();
  }
  if ($('#new_paymen').length) {
    $('#payment_amount').bind('click', function(){
      $(this).select();
    });
  $('#payment_title').bind('blur', function() {
    if (is_url($(this).val())) {
      $('#payment_service_url_input').removeClass('hidden');
      $.ajax({
        url: '/pobierz',
        data: 'url='+encodeURI($(this).val()),
        beforeSend: function() {
          $('#payment_service_url').addClass('busy-right');
        },
        success: function(res) {
          $('#payment_service_url').val(res);
          $('#payment_service_url').removeClass('busy-right');
        }
      });
    } else {
      $('#payment_service_url_input').addClass('hidden');
    }
  });
  }
});