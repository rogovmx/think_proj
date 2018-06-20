ready = ->
  $('#question').on 'click', '#edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    $('#question #edit-question-form').show()

 
$(document).on('turbolinks:load', ready)  # "вешаем" функцию ready на событие turbolinks:load


  $('.question-rating > a').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#errors').html('')
    $('#question-' + response.id + '-rating').html(response.rating)
  .bind 'ajax:error', (e, xhr, status, error) -> 
    button = '<button type="button" class="close" data-dismiss="alert">×</button>'
    response = $.parseJSON(xhr.responseText)
    $('#errors').html('<div class="alert fade in alert-danger">' + button + response + '</div>' )
