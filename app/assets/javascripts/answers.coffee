ready = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data 'answerId'
    $('form#edit-answer-form-' + answer_id).show()

 
$(document).on('turbolinks:load', ready)  # "вешаем" функцию ready на событие turbolinks:load
