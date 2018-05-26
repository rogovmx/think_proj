ready = ->
  $('#question').on 'click', '#edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    $('#question #edit-question-form').show()

 
$(document).on('turbolinks:load', ready)  # "вешаем" функцию ready на событие turbolinks:load
