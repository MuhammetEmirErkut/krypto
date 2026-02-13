; ============================================================================
; KRYPTO Programming Language - Interpreter Environment
; ============================================================================
;
; Runtime environment for the interpreter.
; Manages variable bindings, scoping, and built-in functions.
;
; ============================================================================

; ----------------------------------------------------------------------------
; Runtime Environment
; ----------------------------------------------------------------------------

;; An environment frame: hashtable + parent pointer
(define (make-env parent)
  "Create a new environment frame with optional parent"
  (list 'env (make-hashtable string-hash string=?) parent))

(define (env-table env) (cadr env))
(define (env-parent env) (caddr env))

(define (env-get env name)
  "Look up a variable in the environment chain. Returns value or raises error."
  (let ((table (env-table env)))
    (if (hashtable-contains? table name)
        (hashtable-ref table name #f)
        (let ((parent (env-parent env)))
          (if parent
              (env-get parent name)
              (error 'env-get (string-append "Undefined variable: " name)))))))

(define (env-set! env name value)
  "Set an existing variable in the environment chain. Raises error if not found."
  (let ((table (env-table env)))
    (if (hashtable-contains? table name)
        (hashtable-set! table name value)
        (let ((parent (env-parent env)))
          (if parent
              (env-set! parent name value)
              (error 'env-set! (string-append "Undefined variable: " name)))))))

(define (env-define! env name value)
  "Define a new variable in the current environment frame."
  (hashtable-set! (env-table env) name value))

; ----------------------------------------------------------------------------
; Built-in Function Representation
; ----------------------------------------------------------------------------

;; Built-in functions are represented as:
;; (builtin name arity procedure)
(define (make-builtin name arity proc)
  (list 'builtin name arity proc))

(define (builtin? val)
  (and (pair? val) (eq? (car val) 'builtin)))

(define (builtin-name val) (cadr val))
(define (builtin-arity val) (caddr val))
(define (builtin-proc val) (cadddr val))

; ----------------------------------------------------------------------------
; User-defined Function Representation
; ----------------------------------------------------------------------------

;; User functions are represented as:
;; (krypto-function name params body closure-env)
(define (make-krypto-function name params body closure-env)
  (list 'krypto-function name params body closure-env))

(define (krypto-function? val)
  (and (pair? val) (eq? (car val) 'krypto-function)))

(define (krypto-function-name val) (cadr val))
(define (krypto-function-params val) (caddr val))
(define (krypto-function-body val) (cadddr val))
(define (krypto-function-env val) (car (cddddr val)))

; ----------------------------------------------------------------------------
; Return Signal
; ----------------------------------------------------------------------------

;; Return value is signaled using a tagged list.
;; The interpreter checks for this after each statement.
(define *return-tag* (list 'return-signal))

(define (make-return-signal value)
  (cons *return-tag* value))

(define (return-signal? val)
  (and (pair? val) (eq? (car val) *return-tag*)))

(define (return-signal-value val)
  (cdr val))

; ----------------------------------------------------------------------------
; Krypto Value Types
; ----------------------------------------------------------------------------

;; null representation
(define *krypto-null* (list 'krypto-null))

(define (krypto-null? val)
  (and (pair? val) (eq? (car val) 'krypto-null)))

; ----------------------------------------------------------------------------
; Global Environment with Built-ins
; ----------------------------------------------------------------------------

(define (make-global-env)
  "Create the global environment with built-in functions"
  (let ((env (make-env #f)))
    
    ;; print - prints a value followed by newline
    (env-define! env "print"
      (make-builtin "print" 1
        (lambda (args)
          (let ((val (car args)))
            (cond
              ((krypto-null? val) (display "null"))
              ((boolean? val) (display (if val "true" "false")))
              (else (display val)))
            (newline)
            *krypto-null*))))
    
    ;; input - reads a line from stdin
    (env-define! env "input"
      (make-builtin "input" 0
        (lambda (args)
          (let loop ((chars '()))
            (let ((c (read-char)))
              (cond
                ((eof-object? c)
                 (if (null? chars) "" (list->string (reverse chars))))
                ((char=? c #\newline)
                 (list->string (reverse chars)))
                (else
                 (loop (cons c chars)))))))))
    
    ;; toString - converts a value to string
    (env-define! env "toString"
      (make-builtin "toString" 1
        (lambda (args)
          (let ((val (car args)))
            (cond
              ((string? val) val)
              ((number? val) (number->string val))
              ((boolean? val) (if val "true" "false"))
              ((krypto-null? val) "null")
              (else (format #f "~a" val)))))))

    ;; len - returns the length of a string
    (env-define! env "len"
      (make-builtin "len" 1
        (lambda (args)
          (let ((val (car args)))
            (if (string? val)
                (string-length val)
                (error 'len "Expected string argument"))))))

    env))

; ============================================================================
; End of environment.scm
; ============================================================================
