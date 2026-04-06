; extends

; Lua injection for {{ }} in HTML text nodes
((text) @injection.content
  (#lua-match? @injection.content "{{.-}}")
  (#set! injection.language "lua")
  (#set! injection.include-children))
