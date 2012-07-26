# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

serialize = (obj) ->
  str = []
  for key, value of obj
    str.push(encodeURIComponent(key) + "=" + encodeURIComponent(value)) if value != ''
  str.join("&")

# Get search results for current params
getSearchResults = () ->
  data =
    q: $('#assessment-query').val()
    attachments: "#{($('#search_attachements:checked').length > 0) && 't' || 'f'}"
    geo_scale: $('#assessment_geo_scale').val()

  $('#loading-assessments').show()
  $('#assessment-search-results').hide()

  window.History.pushState(data, null, "?#{serialize(data)}")

  $.ajax
    url: '/assessments/search'
    type: 'POST'
    data: data
    success: renderSearchResults

# Render the HTML returned from the search
renderSearchResults = (data) ->
  $('#loading-assessments').hide()
  $('#assessment-search-results').html(data).show()

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

  # Search assessments
  $('#search-assessments-btn').on('click', getSearchResults)
  $('#assessment_geo_scale').on('change', getSearchResults)
  $('#assessment-query').keyup (event) ->
    getSearchResults() if(event.keyCode == 13)

  # History JS
  History = window.History
#  unless History.enabled
#    # History.js is disabled for this browser.
#    # This is because we can optionally choose to support HTML4 browsers or not.
#    return false

  # Bind to StateChange Event
  History.Adapter.bind window, 'statechange', () -> # Note: We are using statechange instead of popstate
    State = History.getState() # Note: We are using History.getState() instead of event.state
    History.log(State.data, State.title, State.url)

  $(window).bind 'hashchange', () ->
    hash = location.hash.split('?')
    params = hash[1].split('&')
    for param in params
      data = param.split('=')
      switch data[0]
        when 'q' then $('#assessment-query').val(data[1])
        when 'attachments' then $('#search_attachements:checked').prop("checked", (data[1] == 't'))
        when 'geo_scale' then $('#assessment_geo_scale').val(data[1])
    getSearchResults()

window.remove_fields = (link) ->
  $(link).prev('input[type=hidden]').val('1')
  $(link).closest('.fields').hide()

# Add a new field to the assessment form to allow multiple responses
window.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_#{association}", 'g')
  $(link).before(content.replace(regexp, new_id))
