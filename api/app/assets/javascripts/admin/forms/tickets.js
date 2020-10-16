$(document).ready(function(){ 

  $('img.ticket').on('click', function() {
    $('.zoom-modal').css('display', 'block');
    $('.modal-image').attr({ 'src': this.src });
    $('.modal-image').attr({ 'data-zoom-image': this.src });
  });

  $('.close').on('click', function() {
    $('.zoom-modal').hide();
  });

  $(function() {
    $('.zoom-modal #nav input').on('click', function() {
      var scale  = parseInt($('.modal-image').css('font-size'),10);
        nScale = $(this).index()===0 ? scale+1 : scale-1;
      $('.modal-image').stop(true,true).animate({ fontSize: nScale }, {
        step: function(now,fx) {
          $(this).css('transform','scale('+parseFloat(now/10)+')');
        },
        duration: 100
      },'linear');
   });     
  });

  $(function() {
    $('.reject_ticket').on('click', function() {
      $('.status-input').val($('.reject-reason option:selected').val());
      $('.reason-message-input').val($('.reject-reason option:selected').text());
      $('.form.quick-review').submit();
    });
  });

  $(function() {
    $('.accept_ticket').on('click', function() {
      $('.reason-message-input').val($('.accept-reason').val());
      $('.form.quick-review').submit();
    });
  });
});
