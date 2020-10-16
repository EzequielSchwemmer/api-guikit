$('form').submit(function () {
  setTimeout(function () {
    var child = $('#payments'); 
    child.remove();
    // For a horrible reason, our webpacker doesn't support interpolated strings.
    $('#notices').html('<a class="form-refresher" href="/admin/pending_payments">' + I18n.t("admin.messages.payment.exported") + '</a>');
  });
});
