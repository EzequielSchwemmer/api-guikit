// Required dependencies:

//= require jquery.flexslider
//= require i18n/translations
//= require jquery-ui
//= require selectize

// This function removes the errors in the form when the input change.
// Not the best, but, could be worse.
$('input').change(function () {
  var node = this.parentNode;
  if (node.classList.contains('field_with_errors')) {
    node = node.parentNode;
  }
  var errors = node.querySelector('.field-unit__errors');
  if (errors) {
    while (errors.firstChild) {
      errors.removeChild(errors.firstChild);
    }
  }
});

$('.form-actions input').click(function () {
  $('.field-error').remove();
});

$(document).ready(function(){ 
  $('.flexslider').flexslider({
    slideshow: false
  });
  $('.selectize select').selectize();
});

$('#sidebar-action').click(function () {
  $('#sidebar').get(0).classList.toggle('sidebar__show');
  this.firstChild.classList.toggle('fa-chevron-left');
  this.firstChild.classList.toggle('fa-chevron-right');
  this.classList.toggle('sidebar__action__active');
});
