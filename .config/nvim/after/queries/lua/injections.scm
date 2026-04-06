; extends

; HTML injection for .html(data) [=[HTML]=] pattern
; Structure: outer function_call -> inner function_call (with .html) -> string
(function_call
  name: (function_call
    name: (dot_index_expression
      field: (identifier) @_method))
  arguments: (arguments
    (string
      content: (string_content) @injection.content))
  (#eq? @_method "html")
  (#set! injection.language "html"))
