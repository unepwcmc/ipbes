# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.IPBES ||= {}
window.IPBES.page ||= 1

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
    geo_scale: $('#assessment_geo_scale').select2('val')
    systems_assessed: $('#assessment_systems_assessed').select2('val')
    ecosystem_services_functions_assessed: $('#assessment_ecosystem_services_functions_assessed').select2('val')
    tools_and_approaches: $('#assessment_tools_and_approaches').select2('val')
    page: window.IPBES.page
    country_id: window.IPBES.countryId

  $('#loading-assessments').show()
  $('#assessment-search-results').hide()

  window.History.pushState(data, null, "?#{serialize(data)}")

  $.ajax
    url: '/assessments/search'
    type: 'POST'
    data: data
    dataType: 'script'

updateSectionStatus = (section) ->
  complete = true
  section.find('input[type=text], section textarea, section select, section input[type=radio], input[type=checkbox]').each () ->
    # Previous hidden input element with the value for the field key
    prev_hidden = $(this).closest('.control-group').prev('.control-group.hidden').find('input[type=hidden]')

    # Special case for conceptual_framework_other
    if prev_hidden.length > 0 && prev_hidden.val() == 'conceptual_framework_other'
      inputName = $('[value=conceptual_framework]').attr('name').replace('answer_type', 'text_value')
      complete = complete && ($("input[name='#{inputName}']:checked").val() != 'Other (please specify)' || $(this).val() != '')
    else if $(this).attr('type') == 'checkbox' || $(this).attr('type') == 'radio'
      inputName = $(this).attr('name')
      complete = complete && $("input[name='#{inputName}']:checked").val() != undefined
    else if !$(this).parent().hasClass('select2-search') && !$(this).parent().hasClass('select2-search-field') && !$(this).is(':hidden')
      complete = complete && ($(this).val() != '' && $(this).val() != null)

  className = (if complete then 'completed' else 'not_completed')
  $("#sidelink_#{section.attr('id')}").removeClass('completed not_completed').addClass(className)

# Adds a given array of points to the map
window.addMapMarkers = (points) ->
  window.IPBES.points = points
  MarkerIcon = L.Icon.extend
    shadowUrl: '/assets/marker-shadow.png'
    iconUrl: '/assets/marker.png'
    iconSize: new L.Point(25,41)
    iconAnchor: new L.Point(13,41)
    popupAnchor: new L.Point(1,-34)
    shadowSize: new L.Point(41,41)
  markerIcon = new MarkerIcon()

  window.mapMarkers = [] unless window.mapMarkers?

  for marker in window.mapMarkers
    window.map.removeLayer(marker)

  for country in points
    markerLocation = new L.LatLng(country.lat, country.lng)

    marker = new L.Marker(markerLocation, {icon: markerIcon})

    if country.assessment_count?
      # Only add events on index page (which sets assessment_count)
      marker.on('mouseover', (() ->
        # Closure the relevant variables
        name = country.name
        assessmentCount = country.assessment_count
        return (event) ->
          window.countryStats(name, assessmentCount, event)
      )())
      marker.on('mouseout', window.hideCountryStats)
      marker.on('click', (() ->
        # Closure the relevant variables
        id = country.id
        name = country.name
        return (event) ->
          window.filterByCountry(id, name)
      )())
    window.mapMarkers.push(marker)
    window.map.addLayer(marker)

# Shows the number of assessments for a country on hover
window.countryStats = (name, assessmentCount, event) ->
  hoverPosition = $(event.target._icon).offset()
  hoverPosition.top = hoverPosition.top - 25
  $('#country-hover').html("#{name}: #{assessmentCount} assessments").stop(true, true).
    offset(hoverPosition).animate({opacity:1}, 500)

window.hideCountryStats = (name, assessmentCount, event) ->
  $('#country-hover').stop(true, true).animate({opacity:0}, 500)

# Shows the number of assessments for a country on hover
window.filterByCountry = (id, name) ->
  setCountryFilter(id,name)
  getSearchResults()

# sets the country filter and shows its' state
window.setCountryFilter = (id, name) ->
  window.IPBES.countryId = id
  if id?
    unless name?
      for country in window.IPBES.points
        name = country.name if country.id == id
    $('#selected-country-strip span').text("Showing only assessments in #{name}")
    $('#selected-country-strip').fadeIn()

# Reset the countryId param and hide the filter strip
window.clearCountryFilter = () ->
  window.IPBES.countryId = ''
  $('#selected-country-strip').slideUp()


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
  $('#assessment_geo_scale, #assessment_systems_assessed, #assessment_ecosystem_services_functions_assessed, #assessment_tools_and_approaches').on('change', getSearchResults)
  $('#assessment-query').keyup (event) ->
    getSearchResults() if(event.keyCode == 13)

  $('section').delegate 'input[type=text], textarea, select, input[type=radio], input[type=checkbox]',  'change', () ->
    updateSectionStatus($(this).closest('section'))

  $('section').each () ->
    updateSectionStatus($(this))

  $('.download_csv').click () ->
    data =
      q: $('#assessment-query').val()
      attachments: "#{($('#search_attachements:checked').length > 0) && 't' || 'f'}"
      geo_scale: $('#assessment_geo_scale').select2('val')
      systems_assessed: $('#assessment_systems_assessed').select2('val')
      ecosystem_services_functions_assessed: $('#assessment_ecosystem_services_functions_assessed').select2('val')
      tools_and_approaches: $('#assessment_tools_and_approaches').select2('val')

    $(this).attr('href', $(this).attr('href').replace(/\?[^\?]*/, ''))
    $(this).attr('href', "#{$(this).attr('href')}?#{serialize(data)}")

  $('#clear_search').click (e) ->
    e.preventDefault()

    $('#assessment-query').val('')
    $('#search_attachements').removeAttr('checked')
    $('#assessment_geo_scale, #assessment_systems_assessed, #assessment_ecosystem_services_functions_assessed, #assessment_tools_and_approaches').select2('val', '')

    window.IPBES.page = 1
    clearCountryFilter()

    getSearchResults()

  $('#selected-country-strip a').click (e) ->
    e.preventDefault()

    clearCountryFilter()
    getSearchResults()

  $('#assessment-paginator').delegate('.previous', 'click', ->
    if window.IPBES.page > 1
      window.IPBES.page = window.IPBES.page - 1
      getSearchResults()
  )

  $('#assessment-paginator').delegate('.next', 'click',  ->
    window.IPBES.page = window.IPBES.page + 1
    getSearchResults()
  )

  # History JS
  History = window.History

  # Bind to StateChange Event
  History.Adapter.bind window, 'statechange', () -> # Note: We are using statechange instead of popstate
    State = History.getState() # Note: We are using History.getState() instead of event.state

    $('#assessment-query').val(State.data.q)
    $('#search_attachements').prop("checked", (State.data.attachments == 't'))
    $('#assessment_geo_scale').val(State.data.geo_scale)

    # Update search results
    $.ajax
      url: '/assessments/search'
      type: 'POST'
      data: State.data
      dataType: 'script'

  # Maps
  window.map = new L.Map('map')
   
  #tileLayerUrl = 'http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}.png'
  tileLayerUrl = 'http://{s}.tile.cloudmade.com/a72deb8a020e44779b62d002edc5346b/69907/256/{z}/{x}/{y}.png'
  tileLayer = new L.TileLayer(tileLayerUrl, {
    maxZoom: 18
  })

  map.addLayer(tileLayer).setView(new L.LatLng(0, 0), 1)

window.remove_fields = (link) ->
  $(link).prev('input[type=hidden]').val('1')
  $(link).closest('.fields').hide()

# Add a new field to the assessment form to allow multiple responses
window.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_#{association}", 'g')
  $(link).before(content.replace(regexp, new_id))
