ready = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data 'answerId'
    $('form#edit-answer-form-' + answer_id).show()

  $('.answer-rating > a').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#errors').html('')
    $('#answer-' + response.id + '-rating').html(response.rating)
  .bind 'ajax:error', (e, xhr, status, error) ->
    button = '<button type="button" class="close" data-dismiss="alert">×</button>'
    response = $.parseJSON(xhr.responseText)
    $('#errors').html('<div class="alert fade in alert-danger">' + button + response + '</div>' )
 
$(document).on('turbolinks:load', ready)  # "вешаем" функцию ready на событие turbolinks:load


