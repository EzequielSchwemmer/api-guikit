$(document).ready(function(){
  if ($('tr.nested-fields').length > 0) {
    for (var i = 0; i < $('tr.nested-fields').length; i++) {
      item = $($('tr.nested-fields')[i]);
      var modal = $(item.children()[0]).children()[1];
      var modalContent = $($(modal).children()[0]);
      setModals(item);
      addCodeValueToButton(modalContent, 'load');
    }
  }

  $(document).on('cocoon:after-insert', function(e, item) {
    setModals(item);
  });

  $(document).on('click', '.add-product-btn', function (e) {
    e.preventDefault();
  });

  $(document).on('click', '.modal-product-button', function (e) {
    e.preventDefault();
    var modalContent = $($(this)[0]).parent();
    addCodeValueToButton(modalContent, 'click', $(this));
  });

  function setModals(item){
    var modal = $(item.children()[0]).children()[1];
    var modalContent = $($(modal).children()[0]);

    if ($(item.children()[1].firstChild.classList).length == 1) {
      var uniqueIdentifier = $(item.children()[1].firstChild.firstElementChild).attr("name");
    } else {
      var uniqueIdentifier = $(item.children()[1].firstChild).attr("name");
    }

    if (modalContent.children()[8].tagName == 'INPUT') {
      var modalButton = modalContent.children()[16];
    }else{
      var modalButton = modalContent.children()[15];
    }

    $(modal).attr('id', uniqueIdentifier);
    $(modalButton).attr('id', uniqueIdentifier);
    $(modalContent).attr('id', uniqueIdentifier);

    var addProductButton = $($(item.children()[0]).children()[0]);
    addProductButton.attr('data-target', uniqueIdentifier);

    $('.products-autocomplete').on("focus", function(){
      $(this).autocomplete({
        source: function (request, response) {
          $.ajax({
            url: "/api/v1/products/index",
            data: 'term='+request.term,
            dataType: "json",
            type: "GET",
            contentType: "application/json; charset=utf-8",
            dataFilter: function (data) { return data; },
            success: function (data) {
              response($.map(data, function (item) {
                return {
                  label: item.code,
                  name: item.name,
                  category: item.category,
                  code: item.code,
                  provider: item.provider,
                  value:item.code
                }
              }))
            }
          });
        },
        select: function (event, ui) {
          if ($(this).parent()[0].classList[0] == "field_with_errors") {
            console.log("error detected")
            var name_input = $(this).parent().siblings()[7];
            var category_input = $(this).parent().siblings()[10];
            var provider_input = $(this).parent().siblings()[13];
          }else{
            var name_input = $(this).siblings()[6];
            var category_input = $(this).siblings()[9];
            var provider_input = $(this).siblings()[12];
          }
          $(name_input).val(ui.item.name);
          $(category_input).val(ui.item.category);
          $(provider_input).val(ui.item.provider);
        }
      })

      $(this).autocomplete("option", "appendTo", ".modal-window#" + $(modalContent).attr('id'));
    });
  }

  function addCodeValueToButton(modalContent, action, context = null){
    var eanCodeInput = modalContent.children()[4];
    if (eanCodeInput.tagName == 'DIV'){
      var eanCodeInput = modalContent.children()[4].firstChild;
    }
    if (action == 'click'){
      var addProductButton = $("button[data-target='" + context.attr('id') + "']");
    }else{
      var addProductButton = $($(item.children()[0]).children()[0]);
    }
    var truncatedEanCode = jQuery.trim($(eanCodeInput).val()).substring(0, 10) + "...";
    addProductButton.html(jQuery.trim($(eanCodeInput).val()) == "" ? 'Agregar' : truncatedEanCode);
  }
});
