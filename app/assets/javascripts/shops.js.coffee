$("document").ready ->
  $(".shop_form").submit ->
    checked = $("#confirm_pin").is(":checked")
    unless checked
      alert "Confirm the location in the map"
      false
    else
      true