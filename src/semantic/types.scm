; ============================================================================
; KRYPTO Programming Language - Type System
; ============================================================================

(library (semantic types)
  (export make-type-base
          make-type-function
          make-type-void
          make-type-any
          type-base?
          type-function?
          type-void?
          type-any?
          type-base-name
          type-function-params
          type-function-return
          type-equal?
          type-to-string)
  (import (chezscheme))

  ; ----------------------------------------------------------------------------
  ; Type Definitions
  ; ----------------------------------------------------------------------------

  (define-record-type type-base
    (fields name)) ; 'int, 'float, 'string, 'bool



  (define-record-type type-function
    (fields params ; List of types
            return)) ; Return type

  (define-record-type type-void
    (fields))

  (define-record-type type-any
    (fields)) ; Used for unresolved or error states to suppress cascading errors

  ; ----------------------------------------------------------------------------
  ; Type Helpers
  ; ----------------------------------------------------------------------------

  (define (type-equal? t1 t2)
    (cond
      ((and (type-base? t1) (type-base? t2))
       (eq? (type-base-name t1) (type-base-name t2)))

      ((and (type-function? t1) (type-function? t2))
       (and (type-equal? (type-function-return t1) (type-function-return t2))
            (= (length (type-function-params t1)) (length (type-function-params t2)))
            (for-all type-equal? (type-function-params t1) (type-function-params t2))))
      ((and (type-void? t1) (type-void? t2)) #t)
      ((or (type-any? t1) (type-any? t2)) #t) ; Any matches anything (loose)
      (else #f)))

  (define (type-to-string t)
    (cond
      ((type-base? t) (symbol->string (type-base-name t)))

      ((type-function? t) 
       (string-append "(" 
                      (apply string-append (map (lambda (x) (string-append (type-to-string x) " ")) 
                                                (type-function-params t)))
                      "-> " 
                      (type-to-string (type-function-return t)) 
                      ")"))
      ((type-void? t) "void")
      ((type-any? t) "any")
      (else "unknown")))
)
