; ============================================================================
; KRYPTO Programming Language - Semantic Analyzer
; ============================================================================
;
; This module performs semantic analysis on the AST.
; It responsibilities:
;   1. Build Symbol Table (Scopes)
;   2. Resolve Names (Variables, Functions, Classes)
;   3. Type Checking
;
; ============================================================================

; Note: This file is loaded by main.scm and assumes (semantic types) and (semantic symbol-table)
; are available or imported.
; It also assumes (parser ast) functions are available at top level.

; We need to import the libraries here if they aren't already imported?
; If loaded by main.scm which did (import ...), we are fine if main does imports BEFORE loading this?
; Or we can put (import ...) here.

(import (semantic symbol-table)
        (semantic types))

  ; ----------------------------------------------------------------------------
  ; Error Handling
  ; ----------------------------------------------------------------------------

  ; ----------------------------------------------------------------------------
  ; Error Handling & Globals
  ; ----------------------------------------------------------------------------

  (define *semantic-errors* '())
  (define *class-scopes* (make-hashtable string-hash string=?))

  (define (semantic-error message location)
    "Record a semantic error"
    (set! *semantic-errors* 
          (cons (list message location) *semantic-errors*)))

  (define (print-semantic-errors)
    (if (null? *semantic-errors*)
        (display "No semantic errors found.\n")
        (begin
          (display "Semantic Errors:\n")
          (for-each (lambda (err)
                      (let ((msg (car err))
                            (loc (cadr err)))
                        (display "  Line ")
                        (if loc (display (location-line loc)) (display "?"))
                        (display ": ")
                        (display msg)
                        (newline)))
                    (reverse *semantic-errors*)))))

  ; ----------------------------------------------------------------------------
  ; Helper Functions
  ; ----------------------------------------------------------------------------

  (define (resolve-type-annotation node env)
    "Convert an AST type node to a Semantic Type record"
    (if (not node)
        (make-type-any) ; No type annotation
        (let ((node-type (ast-type node)))
          (cond
            ((eq? node-type 'primitive-type)
             (let ((name (ast-get node 'name)))
               (if (member name '("int" "float" "bool" "string" "void"))
                   (case (string->symbol name)
                     ((int) (make-type-base 'int))
                     ((float) (make-type-base 'float))
                     ((bool) (make-type-base 'bool))
                     ((string) (make-type-base 'string))
                     ((void) (make-type-void))
                     (else (make-type-class name)))
                   (make-type-class name)))) ; Should not happen if parser validates keywords
            
            ((eq? node-type 'named-type)
             (make-type-class (ast-get node 'name)))
            
            ((eq? node-type 'array-type)
             ; For now treat array as class "Array" or similar, or add ArrayType
             ; Plan didn't insist on ArrayType yet, kept simple.
             ; Let's assume it's an 'any for now or add array support later.
             (make-type-any))
            
            (else (make-type-any))))))

  (define (expect-type actual expected loc)
    "Check if actual type matches expected type. Returns #t or #f."
    (if (type-equal? actual expected)
        #t
        (begin
          (semantic-error (string-append "Type mismatch. Expected " 
                                         (type-to-string expected) 
                                         ", but got " 
                                         (type-to-string actual)) 
                          loc)
          #f)))

  (define (define-symbol-safe env name type category loc)
    (let ((sym (make-semantic-symbol name type category loc)))
      (if (not (env-define env name sym))
          (semantic-error (string-append "Symbol already defined in this scope: " name) loc))))

  ; ----------------------------------------------------------------------------
  ; Analyzer Entry Point
  ; ----------------------------------------------------------------------------

  (define (analyze ast)
    "Main entry point for semantic analysis"
    (set! *semantic-errors* '())
    (set! *class-scopes* (make-hashtable string-hash string=?))
    (let ((env (make-symbol-environment)))
      ; Define built-ins types (as symbols in symbol table to be found?)
      ; Actually built-in types like 'int' are keywords often, but if they are treated as identifiers:
      ; For now, type annotations use 'primitive-type' AST, so we don't look them up in env.
      
      ; Define built-in functions
      (let ((print-type (make-type-function (list (make-type-any)) (make-type-void)))
            (input-type (make-type-function '() (make-type-base 'string))))
        (define-symbol-safe env "print" print-type 'function (make-location 0 0))
        (define-symbol-safe env "input" input-type 'function (make-location 0 0)))
      
      (analyze-node ast env)
      (if (null? *semantic-errors*)
          (begin (display "Semantic analysis successful.\n") #t)
          (begin (print-semantic-errors) #f))))

  ; ----------------------------------------------------------------------------
  ; AST Traversal
  ; ----------------------------------------------------------------------------

  (define (analyze-node node env)
    (if (not node) (make-type-void)
    (cond
      ((program? node) (analyze-program node env))
      ((class-decl? node) (analyze-class node env))
      ((interface-decl? node) (analyze-interface node env))
      ((fun-decl? node) (analyze-function node env))
      ((let-stmt? node) (analyze-let node env))
      ((block-stmt? node) (analyze-block node env))
      ((if-stmt? node) (analyze-if node env))
      ((while-stmt? node) (analyze-while node env))
      ((for-stmt? node) (analyze-for node env))
      ((return-stmt? node) (analyze-return node env))
      ((expr-stmt? node) (analyze-expr-stmt node env))
      ; Expressions
      ((assign-expr? node) (analyze-assignment node env))
      ((binary-expr? node) (analyze-binary node env))
      ((unary-expr? node) (analyze-unary node env))
      ((call-expr? node) (analyze-call node env))
      ((member-expr? node) (analyze-member node env))
      ((and (literal? node) (not (null-literal? node))) (analyze-literal node env))
      ((null-literal? node) (make-type-any))
      ((identifier? node) (analyze-identifier node env))
      (else (make-type-any))))) ; Fallback

  ; ----------------------------------------------------------------------------
  ; Declaration Handlers
  ; ----------------------------------------------------------------------------

  (define (analyze-program node env)
    (for-each (lambda (decl) (analyze-node decl env))
              (ast-get node 'declarations))
    (make-type-void))

  (define (analyze-class node env)
    (let ((name (ast-get node 'name))
          (loc (ast-get node 'location)))
      (define-symbol-safe env name (make-type-class name) 'class loc)
      (env-enter-scope env)
      ; Fields
      (for-each (lambda (field)
                  (let ((fname (ast-get field 'name))
                        (floc (ast-get field 'location))
                        (ftype (resolve-type-annotation (ast-get field 'type) env)))
                    (define-symbol-safe env fname ftype 'field floc)))
                (ast-get node 'fields))
      ; Methods
      (for-each (lambda (method) (analyze-node method env))
                (ast-get node 'methods))
      
      (hashtable-set! *class-scopes* name (env-current-scope env))
      (env-exit-scope env)
      (make-type-void)))

  (define (analyze-interface node env)
    (make-type-void)) ; TODO: Implement interfaces

  (define (analyze-function node env)
    (let* ((name (ast-get node 'name))
           (loc (ast-get node 'location))
           (params (ast-get node 'params))
           (ret-ast (ast-get node 'return-type))
           (ret-type (if ret-ast (resolve-type-annotation ret-ast env) (make-type-void))))
      
      ; 1. Resolve param types
      (let ((param-types (map (lambda (p) 
                                (resolve-type-annotation (ast-get p 'type) env)) 
                              params)))
        ; 2. Define function in CURRENT scope
        (let ((fun-type (make-type-function param-types ret-type)))
          (define-symbol-safe env name fun-type 'function loc))
        
        ; 3. Enter function scope
        (env-enter-scope env)
        
        ; 4. Define 'return' type for checking return statements (special symbol)
        (define-symbol-safe env "%return-type%" ret-type 'internal loc)
        
        ; 5. Define parameters in scope
        (for-each (lambda (p t)
                    (define-symbol-safe env (ast-get p 'name) t 'parameter (ast-get p 'location)))
                  params
                  param-types)
        
        ; 6. Analyze body
        (let ((body (ast-get node 'body)))
          (if body (analyze-node body env)))
        
        (env-exit-scope env)
        (make-type-void))))

(define (analyze-let node env)
    (let ((name (ast-get node 'name))
          (loc (ast-get node 'location))
          (init (ast-get node 'initializer))
          (mod-ast (ast-get node 'type-annotation)))
      
      (let ((declared-type (if mod-ast (resolve-type-annotation mod-ast env) #f))
            (init-type (if init (analyze-node init env) #f)))
        
        (let ((final-type 
               (cond
                 ((and declared-type init-type)
                  (expect-type init-type declared-type loc)
                  declared-type)
                 (declared-type declared-type)
                 (init-type init-type)
                 (else (make-type-any))))) ; Could not infer
          
          (define-symbol-safe env name final-type 'variable loc)
          (make-type-void)))))

  ; ----------------------------------------------------------------------------
  ; Statement Handlers
  ; ----------------------------------------------------------------------------

  (define (analyze-block node env)
    (env-enter-scope env)
    (for-each (lambda (stmt) (analyze-node stmt env))
              (ast-get node 'statements))
    (env-exit-scope env)
    (make-type-void))

  (define (analyze-if node env)
    (let ((cond-type (analyze-node (ast-get node 'condition) env)))
      (expect-type cond-type (make-type-base 'bool) (ast-get node 'location))
      (analyze-node (ast-get node 'then-branch) env)
      (let ((else-branch (ast-get node 'else-branch)))
        (if else-branch (analyze-node else-branch env)))
      (make-type-void)))

  (define (analyze-while node env)
    (let ((cond-type (analyze-node (ast-get node 'condition) env)))
      (expect-type cond-type (make-type-base 'bool) (ast-get node 'location))
      (analyze-node (ast-get node 'body) env)
      (make-type-void)))

  (define (analyze-for node env)
    (env-enter-scope env)
    (let ((init (ast-get node 'init)))
      (if init (analyze-node init env)))
    (let ((cond (ast-get node 'condition)))
      (if cond 
          (expect-type (analyze-node cond env) (make-type-base 'bool) (ast-get node 'location))))
    (let ((update (ast-get node 'update)))
      (if update (analyze-node update env)))
    (analyze-node (ast-get node 'body) env)
    (env-exit-scope env)
    (make-type-void))

  (define (analyze-return node env)
    (let ((val (ast-get node 'value))
          (loc (ast-get node 'location)))
      (let ((val-type (if val (analyze-node val env) (make-type-void))))
        ; Check against current function return type
        (let ((expected-sym (env-lookup env "%return-type%")))
          (if expected-sym
              (expect-type val-type (semantic-symbol-type expected-sym) loc)
              (semantic-error "Return statement outside of function" loc)))
        (make-type-void))))

  (define (analyze-expr-stmt node env)
    (analyze-node (ast-get node 'expression) env)
    (make-type-void))

  ; ----------------------------------------------------------------------------
  ; Expression Handlers
  ; ----------------------------------------------------------------------------
  
  ; Helper since assignment-expr? is defined in AST but was used here directly logic?
  ; Check AST defs. make-assign-expr -> 'assign-expr. 
  ; predicates: (define (assign-expr? node) (eq? (ast-type node) 'assign-expr))
  
  (define (analyze-assignment node env)
    (let ((target-node (ast-get node 'target)) 
          (val-node (ast-get node 'value))
          (loc (ast-get node 'location)))
      (let ((val-type (analyze-node val-node env))
            (target-type (analyze-node target-node env))) 
        (expect-type val-type target-type loc)
        target-type)))

  (define (analyze-identifier node env)
    (let ((name (ast-get node 'name))
          (loc (ast-get node 'location)))
      (let ((sym (env-lookup env name)))
        (if sym
            (semantic-symbol-type sym)
            (begin
              (semantic-error (string-append "Undefined variable: " name) loc)
              (make-type-any))))))

  (define (analyze-literal node env)
    (cond
      ((integer-literal? node) (make-type-base 'int))
      ((float-literal? node) (make-type-base 'float))
      ((string-literal? node) (make-type-base 'string))
      ((bool-literal? node) (make-type-base 'bool))
      (else (make-type-any))))

  (define (analyze-binary node env)
    (let ((left-type (analyze-node (ast-get node 'left) env))
          (right-type (analyze-node (ast-get node 'right) env))
          (op (ast-get node 'operator))
          (loc (ast-get node 'location)))
      
      ; Simple type rules for now
      (case op
        ((add subtract multiply divide) 
             ; Note: AST op names from parser might be 'add 'subtract etc?
             ; Let's check Parser/AST. 
             ; Parser: 'add, 'subtract... AST: make-binary-expr stores it. 
             ; So we match against symbols.
        (if (and (or (type-equal? left-type (make-type-base 'int)) 
                      (type-equal? left-type (make-type-base 'float)))
                  (type-equal? left-type right-type))
             left-type
             (begin
               (semantic-error "Arithmetic operator expects numbers" loc)
               (make-type-any))))
        ((less-than greater-than less-equal greater-equal equal not-equal)
         (make-type-base 'bool))
        (else (make-type-any)))))

  (define (analyze-unary node env)
    (let ((operand-type (analyze-node (ast-get node 'operand) env))
          (op (ast-get node 'operator)))
      operand-type))

  (define (analyze-member node env)
    (let* ((object-node (ast-get node 'object))
           (member-name (ast-get node 'member))
           (object-type (analyze-node object-node env))
           (loc (ast-get node 'location)))
      (if (type-class? object-type)
          (let* ((class-name (type-class-name object-type))
                 (class-scope (hashtable-ref *class-scopes* class-name #f)))
            (if class-scope
                (let ((sym (scope-lookup class-scope member-name)))
                  (if sym
                      (semantic-symbol-type sym)
                      (begin
                        (semantic-error (string-append "Undefined member '" member-name "' in class " class-name) loc)
                        (make-type-any))))
                (begin
                  (semantic-error (string-append "Unknown class: " class-name) loc)
                  (make-type-any))))
          (begin
            (if (not (type-any? object-type))
                (semantic-error "Member access requires an object" loc))
            (make-type-any)))))

  (define (analyze-call node env)
    (let ((callee-type (analyze-node (ast-get node 'callee) env))
          (args (ast-get node 'arguments))
          (loc (ast-get node 'location)))
      
      (cond
        ((type-function? callee-type)
         (let ((param-types (type-function-params callee-type))
               (arg-types (map (lambda (a) (analyze-node a env)) args)))
           ; Check arg count
           (if (= (length param-types) (length arg-types))
               (begin
                 (for-each (lambda (pt at arg-node)
                             (expect-type at pt (ast-get arg-node 'location)))
                           param-types arg-types args)
                 (type-function-return callee-type))
               (begin
                 (semantic-error "Incorrect number of arguments" loc)
                 (type-function-return callee-type)))))
                 
        ((type-class? callee-type)
         ; Class instantiation act as a call
         ; For Phase 5, we loosely check args and return the class instance
         (for-each (lambda (a) (analyze-node a env)) args)
         callee-type)
         
        (else
         (if (not (type-any? callee-type))
             (semantic-error "Calling a non-function or non-class" loc))
         (make-type-any)))))
