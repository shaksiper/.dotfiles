;; extends
(method_declaration returns:(_) @returns)

; (argument (_) @parameter.inner) @parameter.outer

;; Match the empty argument list (fallback case)
(argument_list) @parameter.empty

; New parameter Text Objects

; parameters
(parameter_list
  "," @parameter.outer
  .
  (_) @parameter.inner @parameter.outer)

(parameter_list
  .
  (_) @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)

(argument_list
  "," @parameter.outer
  .
  (_) @parameter.inner @parameter.outer)

(argument_list
  .
  (_) @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)

; ( (argument (_) @parameter.inner) ","? ) @parameter.outer

; ( ( (argument (_) @argument ) @argument ( "," )+) @argument.outer)

(expression_statement) @statement.outer

(local_declaration_statement) @statement.outer

(comment)+ @comments

(method_declaration) @function.outer

(method_declaration
 body: (_)
          @function.inner
          ; (#strip! @function.inner "^{" "}$")
          )

; (method_declaration) @function.outer
;
; (method_declaration
;   body: (block
;     "{" @_start
;     _*
;     "}" @_end)
;   (#make-range! "function.inner" @_start @_end))

; (method_declaration
;   body: (_
;     (_)* @function.prev
;     .
;     (_)* @function.next
;     )
;   (#make-range! "function.inner" @function.prev @function.next))
