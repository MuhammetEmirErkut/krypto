; ============================================================================
; KRYPTO Programming Language - Symbol Table Module
; ============================================================================
;
; This module handles symbol management for semantic analysis.
; It defines:
;   - Symbols (variables, functions, classes)
;   - Scopes (mapping names to symbols)
;   - Environment (stack of scopes)
;
; ============================================================================

(library (semantic symbol-table)
  (export make-semantic-symbol
          semantic-symbol-name
          semantic-symbol-type
          semantic-symbol-category
          semantic-symbol-location
          make-scope
          scope-define
          scope-lookup
          scope-parent
          make-symbol-environment
          env-enter-scope
          env-exit-scope
          env-current-scope
          env-define
          env-lookup
          env-lookup-local)
  (import (chezscheme))

  ; ----------------------------------------------------------------------------
  ; Symbol Definition
  ; ----------------------------------------------------------------------------

  (define-record-type semantic-symbol
    (fields name
            type      ; e.g., 'int, 'string, or struct/class name
            category  ; 'variable, 'function, 'class, 'interface, 'parameter
            location)) ; (line column)

  ; ----------------------------------------------------------------------------
  ; Scope Definition
  ; ----------------------------------------------------------------------------

  ;; A scope is a hashtable + a pointer to the parent scope
  (define-record-type scope
    (fields (immutable table)   ; Hashtable name -> symbol
            (immutable parent)) ; Parent scope or #f
    (protocol
      (lambda (new)
        (lambda (parent)
          (new (make-hashtable string-hash string=?) parent)))))

  (define (scope-define scope name symbol)
    "Define a symbol in the given scope. Returns #t if successful, #f if already defined."
    (if (hashtable-contains? (scope-table scope) name)
        #f
        (begin
          (hashtable-set! (scope-table scope) name symbol)
          #t)))

  (define (scope-lookup scope name)
    "Look up a symbol in the given scope (not recursive)."
    (hashtable-ref (scope-table scope) name #f))

  (define (scope-lookup-recursive scope name)
    "Look up a symbol in the scope chain."
    (let ((sym (scope-lookup scope name)))
      (if sym
          sym
          (let ((parent (scope-parent scope)))
            (if parent
                (scope-lookup-recursive parent name)
                #f)))))

  ; ----------------------------------------------------------------------------
  ; Environment Definition
  ; ----------------------------------------------------------------------------

  ;; An environment is a container for the current scope state
  (define-record-type symbol-environment
    (fields (mutable current-scope))
    (protocol
      (lambda (new)
        (lambda ()
          (new (make-scope #f)))))) ; Global scope has no parent

  (define (env-enter-scope env)
    "Push a new scope onto the environment"
    (let ((new-scope (make-scope (symbol-environment-current-scope env))))
      (symbol-environment-current-scope-set! env new-scope)))

  (define (env-exit-scope env)
    "Pop the current scope from the environment"
    (let ((parent (scope-parent (symbol-environment-current-scope env))))
      (if parent
          (symbol-environment-current-scope-set! env parent)
          (error 'env-exit-scope "Cannot exit global scope"))))

  (define (env-current-scope env)
    (symbol-environment-current-scope env))

  (define (env-define env name sym)
    "Define a symbol in the current scope"
    (scope-define (symbol-environment-current-scope env) name sym))

  (define (env-lookup env name)
    "Look up a symbol in the environment (recursive)"
    (scope-lookup-recursive (symbol-environment-current-scope env) name))

  (define (env-lookup-local env name)
    "Look up a symbol in the current scope only"
    (scope-lookup (symbol-environment-current-scope env) name))
)
