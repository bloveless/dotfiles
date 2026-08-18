; extends

; Give @string.escape higher priority so it wins over @string
; when both capture the same region (escape sequences inside strings)
((escape_sequence) @string.escape
 (#set! priority 150))
