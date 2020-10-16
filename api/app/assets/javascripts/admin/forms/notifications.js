$(document).ready(function(){
  $( "#tabs" ).tabs();
  if (localStorage.getItem('activeTab') == 'individual') {
    setIndividualTab();
  }else {
    setSegmentTab();
  }

  $('#ui-id-1').on('click', function() {
    localStorage.setItem('activeTab', 'individual');
    setIndividualTab();
  });

  $('#ui-id-2').on('click', function() {
    localStorage.setItem('activeTab', 'segment');
    setSegmentTab();
  });

  function setIndividualTab() {
    $('#ui-id-2').parent().removeClass("ui-tabs-active ui-state-active");
    $('#ui-id-1').parent().addClass("ui-tabs-active ui-state-active");
    $('#tabs-2').hide();
    $('#tabs-1').show();
  }

  function setSegmentTab() {
    $('#ui-id-1').parent().removeClass("ui-tabs-active ui-state-active");
    $('#ui-id-2').parent().addClass("ui-tabs-active ui-state-active");
    $('#tabs-1').hide();
    $('#tabs-2').show();
  }
});
