$ ->
  preview = (markup) ->
    html = converter.makeHtml(markup)
    $("#task_description_preview").html html
  converter = new Showdown.converter()
  $("#task_description").bind "input", ->
    preview $(this).val()

  preview $("#task_description").val()
