$ ->
  $(".code-editor").each ->
    editor = CodeMirror.fromTextArea(this,
      lineNumbers: true
      matchBrackets: true
      mode: "text/x-c++src"
    )
    $("input").live "click", ->
      editor.save()
