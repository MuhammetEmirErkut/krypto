; ============================================================================
; KRYPTO Programming Language - Interpreter (AST Walker)
; ============================================================================
;
; Tree-walking interpreter that evaluates AST nodes.
; Supports:
;   - Literals, binary/unary expressions
;   - Variable declarations and assignments
;   - Control flow (if, while, for)
;   - Function declarations and calls
;   - Return statements
;   - Built-in functions
;
; ============================================================================

; Note: environment.scm, lexer.scm, ast.scm, parser.scm must be loaded before this file.

; ----------------------------------------------------------------------------
; Main Entry Point
; ----------------------------------------------------------------------------

(define (interpret ast)
  "Interpret a parsed AST (program node)"
  (let ((env (make-global-env)))
    ;; First pass: register all top-level function declarations
    (let ((decls (ast-get ast 'declarations)))
      (for-each (lambda (decl)
                  (when (fun-decl? decl)
                    (let* ((name (ast-get decl 'name))
                           (params (map (lambda (p) (ast-get p 'name))
                                        (ast-get decl 'params)))
                           (body (ast-get decl 'body))
                           (func (make-krypto-function name params body env)))
                      (env-define! env name func))))
                decls)
      ;; Second pass: evaluate all declarations/statements
      (for-each (lambda (decl)
                  (eval-node decl env))
                decls))
    ;; Check if there's a main function and call it
    (let ((table (env-table env)))
      (when (hashtable-contains? table "main")
        (let ((main-fn (hashtable-ref table "main" #f)))
          (when (krypto-function? main-fn)
            (call-function main-fn '() env)))))))

; ----------------------------------------------------------------------------
; Node Evaluator (Dispatcher)
; ----------------------------------------------------------------------------

(define (eval-node node env)
  "Evaluate an AST node and return its value"
  (if (not node) *krypto-null*
  (cond
    ; --- Expressions ---
    ((integer-literal? node)  (ast-get node 'value))
    ((float-literal? node)    (ast-get node 'value))
    ((string-literal? node)   (ast-get node 'value))
    ((bool-literal? node)     (ast-get node 'value))
    ((null-literal? node)     *krypto-null*)
    ((identifier? node)       (eval-identifier node env))
    ((binary-expr? node)      (eval-binary node env))
    ((unary-expr? node)       (eval-unary node env))
    ((group-expr? node)       (eval-node (ast-get node 'expression) env))
    ((call-expr? node)        (eval-call node env))
    ((assign-expr? node)      (eval-assign node env))
    ((member-expr? node)      (eval-member node env))
    ((index-expr? node)       (eval-index node env))
    
    ; --- Statements ---
    ((expr-stmt? node)        (eval-expr-stmt node env))
    ((let-stmt? node)         (eval-let node env))
    ((if-stmt? node)          (eval-if node env))
    ((while-stmt? node)       (eval-while node env))
    ((for-stmt? node)         (eval-for node env))
    ((return-stmt? node)      (eval-return node env))
    ((block-stmt? node)       (eval-block node env))
    
    ; --- Declarations ---
    ((fun-decl? node)         (eval-fun-decl node env))
    ((class-decl? node)       (eval-class-decl node env))
    ((program? node)          (eval-program node env))
    
    ; Fallback
    (else *krypto-null*))))

; ----------------------------------------------------------------------------
; Expression Evaluators
; ----------------------------------------------------------------------------

(define (eval-identifier node env)
  "Look up a variable in the environment"
  (env-get env (ast-get node 'name)))

(define (eval-binary node env)
  "Evaluate a binary expression"
  (let ((op (ast-get node 'operator))
        (left (eval-node (ast-get node 'left) env))
        (right (eval-node (ast-get node 'right) env)))
    (case op
      ((add)
       (cond
         ((and (number? left) (number? right)) (+ left right))
         ((and (string? left) (string? right)) (string-append left right))
         (else (error 'eval-binary "Cannot add these types"))))
      ((subtract)
       (if (and (number? left) (number? right))
           (- left right)
           (error 'eval-binary "Cannot subtract non-numbers")))
      ((multiply)
       (if (and (number? left) (number? right))
           (* left right)
           (error 'eval-binary "Cannot multiply non-numbers")))
      ((divide)
       (if (and (number? left) (number? right))
           (if (zero? right)
               (error 'eval-binary "Division by zero")
               (/ left right))
           (error 'eval-binary "Cannot divide non-numbers")))
      ((modulo)
       (if (and (number? left) (number? right))
           (mod left right)
           (error 'eval-binary "Cannot modulo non-numbers")))
      ((less-than)      (< left right))
      ((greater-than)   (> left right))
      ((less-equal)     (<= left right))
      ((greater-equal)  (>= left right))
      ((equal)          (krypto-equal? left right))
      ((not-equal)      (not (krypto-equal? left right)))
      ((and-op)         (and (truthy? left) (truthy? right)))
      ((or-op)          (or (truthy? left) (truthy? right)))
      (else (error 'eval-binary (string-append "Unknown operator: " (symbol->string op)))))))

(define (eval-unary node env)
  "Evaluate a unary expression"
  (let ((op (ast-get node 'operator))
        (operand (eval-node (ast-get node 'operand) env)))
    (case op
      ((negate) (- operand))
      ((not-op) (not (truthy? operand)))
      (else (error 'eval-unary (string-append "Unknown unary operator: " (symbol->string op)))))))

(define (eval-call node env)
  "Evaluate a function call"
  (let* ((callee (eval-node (ast-get node 'callee) env))
         (args (map (lambda (a) (eval-node a env))
                    (ast-get node 'arguments))))
    (cond
      ((builtin? callee)
       ((builtin-proc callee) args))
      ((krypto-function? callee)
       (call-function callee args env))
      ((and (list? callee) (eq? (car callee) 'krypto-class))
       (instantiate-class callee args env))
      (else
       (error 'eval-call "Attempting to call a non-function")))))

(define (eval-assign node env)
  "Evaluate an assignment expression"
  (let ((value (eval-node (ast-get node 'value) env))
        (target (ast-get node 'target)))
    (cond
      ((identifier? target)
       (env-set! env (ast-get target 'name) value)
       value)
      (else
       (error 'eval-assign "Invalid assignment target")))))

(define (eval-member node env)
  "Evaluate member access"
  (let* ((object (eval-node (ast-get node 'object) env))
         (member-name (ast-get node 'member)))
    (if (and (list? object) (eq? (car object) 'krypto-instance))
        (let* ((instance-env (caddr object))
               (val (env-get instance-env member-name))) ; Look up field or method
          val)
        (error 'eval-member "Member access on non-object"))))

(define (eval-index node env)
  "Evaluate index access (placeholder for future arrays)"
  *krypto-null*)

; ----------------------------------------------------------------------------
; Statement Evaluators
; ----------------------------------------------------------------------------

(define (eval-expr-stmt node env)
  "Evaluate an expression statement"
  (eval-node (ast-get node 'expression) env)
  *krypto-null*)

(define (eval-let node env)
  "Evaluate a let (variable declaration) statement"
  (let* ((name (ast-get node 'name))
         (init (ast-get node 'initializer))
         (value (if init (eval-node init env) *krypto-null*)))
    (env-define! env name value)
    *krypto-null*))

(define (eval-if node env)
  "Evaluate an if statement"
  (let ((condition (eval-node (ast-get node 'condition) env)))
    (if (truthy? condition)
        (eval-node (ast-get node 'then-branch) env)
        (let ((else-branch (ast-get node 'else-branch)))
          (if else-branch
              (eval-node else-branch env)
              *krypto-null*)))))

(define (eval-while node env)
  "Evaluate a while loop"
  (let loop ()
    (let ((condition (eval-node (ast-get node 'condition) env)))
      (when (truthy? condition)
        (let ((result (eval-node (ast-get node 'body) env)))
          (if (return-signal? result)
              result
              (loop))))))
  *krypto-null*)

(define (eval-for node env)
  "Evaluate a for loop"
  (let ((for-env (make-env env)))
    ;; Init
    (let ((init (ast-get node 'init)))
      (when init (eval-node init for-env)))
    ;; Loop
    (let loop ()
      (let ((cond-node (ast-get node 'condition)))
        (when (or (not cond-node) (truthy? (eval-node cond-node for-env)))
          (let ((result (eval-node (ast-get node 'body) for-env)))
            (if (return-signal? result)
                result
                (begin
                  (let ((update (ast-get node 'update)))
                    (when update (eval-node update for-env)))
                  (loop)))))))
    *krypto-null*))

(define (eval-return node env)
  "Evaluate a return statement - creates a return signal"
  (let ((val (ast-get node 'value)))
    (make-return-signal
      (if val (eval-node val env) *krypto-null*))))

(define (eval-block node env)
  "Evaluate a block statement with a new scope"
  (let ((block-env (make-env env)))
    (let loop ((stmts (ast-get node 'statements)))
      (if (null? stmts)
          *krypto-null*
          (let ((result (eval-node (car stmts) block-env)))
            (if (return-signal? result)
                result  ; Propagate return signal up
                (loop (cdr stmts))))))))

; ----------------------------------------------------------------------------
; Declaration Evaluators
; ----------------------------------------------------------------------------

(define (eval-fun-decl node env)
  "Evaluate a function declaration - register function in environment"
  (let* ((name (ast-get node 'name))
         (params (map (lambda (p) (ast-get p 'name))
                      (ast-get node 'params)))
         (body (ast-get node 'body))
         (func (make-krypto-function name params body env)))
    (env-define! env name func)
    *krypto-null*))

(define (eval-class-decl node env)
  "Evaluate a class declaration: capture AST node and closure environment"
  (let ((name (ast-get node 'name)))
    (env-define! env name (list 'krypto-class name node env))
    *krypto-null*))

(define (eval-program node env)
  "Evaluate a program node"
  (for-each (lambda (decl) (eval-node decl env))
            (ast-get node 'declarations))
  *krypto-null*)

; ----------------------------------------------------------------------------
; Function Calling and Instantiation
; ----------------------------------------------------------------------------

(define (instantiate-class class-def args caller-env)
  "Create a new instance of a class"
  (let* ((name (cadr class-def))
         (node (caddr class-def))
         (closure-env (cadddr class-def))
         (instance-env (make-env closure-env)) ; Instance scope
         (fields (ast-get node 'fields))
         (methods (ast-get node 'methods)))
    ;; Bind fields strictly by position (like a struct or tuple constructor)
    (let loop ((fs fields) (as args))
      (cond
        ((and (null? fs) (null? as)) #t)
        ((null? fs) (error 'instantiate-class "Too many arguments for constructor"))
        ((null? as) (error 'instantiate-class "Too few arguments for constructor"))
        (else
         (env-define! instance-env (ast-get (car fs) 'name) (car as))
         (loop (cdr fs) (cdr as)))))
         
    ;; Bind methods into instance scope so they capture fields
    (for-each (lambda (m)
                (let* ((m-name (ast-get m 'name))
                       (m-params (map (lambda (p) (ast-get p 'name)) (ast-get m 'params)))
                       (m-body (ast-get m 'body))
                       ;; Methods capture the instance-env!
                       (m-func (make-krypto-function m-name m-params m-body instance-env)))
                  (env-define! instance-env m-name m-func)))
              methods)
              
    ;; Return instance tuple
    (list 'krypto-instance name instance-env)))

(define (call-function func args caller-env)
  "Call a user-defined Krypto function"
  (let* ((params (krypto-function-params func))
         (body (krypto-function-body func))
         (closure-env (krypto-function-env func))
         (call-env (make-env closure-env)))
    ;; Bind parameters
    (let loop ((ps params) (as args))
      (cond
        ((and (null? ps) (null? as)) #t)  ; Done
        ((null? ps) (error 'call-function "Too many arguments"))
        ((null? as) (error 'call-function "Too few arguments"))
        (else
         (env-define! call-env (car ps) (car as))
         (loop (cdr ps) (cdr as)))))
    ;; Execute body
    (let ((result (eval-node body call-env)))
      (if (return-signal? result)
          (return-signal-value result)
          *krypto-null*))))

; ----------------------------------------------------------------------------
; Helper Functions
; ----------------------------------------------------------------------------

(define (truthy? val)
  "Determine if a value is truthy in Krypto"
  (cond
    ((boolean? val) val)
    ((krypto-null? val) #f)
    ((and (number? val) (= val 0)) #f)
    ((and (string? val) (string=? val "")) #f)
    (else #t)))

(define (krypto-equal? a b)
  "Check equality of two Krypto values"
  (cond
    ((and (number? a) (number? b)) (= a b))
    ((and (string? a) (string? b)) (string=? a b))
    ((and (boolean? a) (boolean? b)) (eq? a b))
    ((and (krypto-null? a) (krypto-null? b)) #t)
    (else #f)))

; ============================================================================
; End of interpreter.scm
; ============================================================================
