# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('select.select2').select2()
  $('select.select_geo_countries').select2({placeholder: 'Select a Country'})

  # Bootstrap style for select2 plugin
  $('div.select2-container').removeAttr('style')
  
  # Scroll sidebar
  if $('#form-sidebar').length > 0
    offset = $('#form-sidebar').offset()
    topPadding = 60

    $(window).scroll ->
      if $(window).scrollTop() > offset.top - topPadding && $(window).width() > 767
        $('#form-sidebar').css
          marginTop: $(window).scrollTop() - offset.top + topPadding
      else
        $('#form-sidebar').css
          marginTop: 0