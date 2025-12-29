; ============================================================================
; KRYPTO Programming Language - Abstract Syntax Tree (AST) Module
; ============================================================================
;
; This module defines the AST node types for the Krypto language.
; The AST is the structured representation of source code after parsing.
;
; Node Categories:
;   1. Expressions - produce values
;   2. Statements - perform actions
;   3. Declarations - define new bindings
;
; ============================================================================

; ----------------------------------------------------------------------------
; AST Node Constructor Helper
; ----------------------------------------------------------------------------

(define (make-ast-node type . fields)
  "Create an AST node with the given type and fields.
   Fields are provided as a property list: (field1 val1 field2 val2 ...)"
  (cons type fields))

(define (ast-type node)
  "Get the type of an AST node"
  (car node))

(define (ast-get node field)
  "Get a field value from an AST node"
  (let loop ((fields (cdr node)))
    (cond
      ((null? fields) #f)
      ((null? (cdr fields)) #f)
      ((eq? (car fields) field) (cadr fields))
      (else (loop (cddr fields))))))

; ----------------------------------------------------------------------------
; Source Location
; ----------------------------------------------------------------------------

(define (make-location line column)
  "Create a source location for error reporting"
  (list 'location line column))

(define (location-line loc) (cadr loc))
(define (location-column loc) (caddr loc))

; ----------------------------------------------------------------------------
; EXPRESSIONS - Produce values
; ----------------------------------------------------------------------------

;; Literal expressions
;; (literal-expr type value location)

(define (make-integer-literal value line col)
  "Create an integer literal node"
  (make-ast-node 'integer-literal
                 'value value
                 'location (make-location line col)))

(define (make-float-literal value line col)
  "Create a float literal node"
  (make-ast-node 'float-literal
                 'value value
                 'location (make-location line col)))

(define (make-string-literal value line col)
  "Create a string literal node"
  (make-ast-node 'string-literal
                 'value value
                 'location (make-location line col)))

(define (make-bool-literal value line col)
  "Create a boolean literal node"
  (make-ast-node 'bool-literal
                 'value value
                 'location (make-location line col)))

(define (make-null-literal line col)
  "Create a null literal node"
  (make-ast-node 'null-literal
                 'location (make-location line col)))

;; Identifier expression
;; (identifier name location)

(define (make-identifier name line col)
  "Create an identifier node"
  (make-ast-node 'identifier
                 'name name
                 'location (make-location line col)))

;; Binary expression
;; (binary-expr operator left right location)

(define (make-binary-expr operator left right line col)
  "Create a binary expression node"
  (make-ast-node 'binary-expr
                 'operator operator
                 'left left
                 'right right
                 'location (make-location line col)))

;; Unary expression
;; (unary-expr operator operand location)

(define (make-unary-expr operator operand line col)
  "Create a unary expression node"
  (make-ast-node 'unary-expr
                 'operator operator
                 'operand operand
                 'location (make-location line col)))

;; Grouping expression (parenthesized)
;; (group-expr expression location)

(define (make-group-expr expression line col)
  "Create a grouping expression node"
  (make-ast-node 'group-expr
                 'expression expression
                 'location (make-location line col)))

;; Call expression
;; (call-expr callee arguments location)

(define (make-call-expr callee arguments line col)
  "Create a function call expression node"
  (make-ast-node 'call-expr
                 'callee callee
                 'arguments arguments
                 'location (make-location line col)))

;; Member access expression
;; (member-expr object member location)

(define (make-member-expr object member line col)
  "Create a member access expression node"
  (make-ast-node 'member-expr
                 'object object
                 'member member
                 'location (make-location line col)))

;; Index expression (array access)
;; (index-expr object index location)

(define (make-index-expr object index line col)
  "Create an index expression node"
  (make-ast-node 'index-expr
                 'object object
                 'index index
                 'location (make-location line col)))

;; Assignment expression
;; (assign-expr target value location)

(define (make-assign-expr target value line col)
  "Create an assignment expression node"
  (make-ast-node 'assign-expr
                 'target target
                 'value value
                 'location (make-location line col)))

; ----------------------------------------------------------------------------
; STATEMENTS - Perform actions
; ----------------------------------------------------------------------------

;; Expression statement
;; (expr-stmt expression location)

(define (make-expr-stmt expression line col)
  "Create an expression statement node"
  (make-ast-node 'expr-stmt
                 'expression expression
                 'location (make-location line col)))

;; Let statement (variable declaration)
;; (let-stmt name type-annotation initializer is-mutable location)

(define (make-let-stmt name type-annotation initializer is-mutable line col)
  "Create a variable declaration statement node"
  (make-ast-node 'let-stmt
                 'name name
                 'type-annotation type-annotation  ; can be #f
                 'initializer initializer
                 'is-mutable is-mutable
                 'location (make-location line col)))

;; Return statement
;; (return-stmt value location)

(define (make-return-stmt value line col)
  "Create a return statement node"
  (make-ast-node 'return-stmt
                 'value value  ; can be #f for void return
                 'location (make-location line col)))

;; If statement
;; (if-stmt condition then-branch else-branch location)

(define (make-if-stmt condition then-branch else-branch line col)
  "Create an if statement node"
  (make-ast-node 'if-stmt
                 'condition condition
                 'then-branch then-branch
                 'else-branch else-branch  ; can be #f
                 'location (make-location line col)))

;; While statement
;; (while-stmt condition body location)

(define (make-while-stmt condition body line col)
  "Create a while statement node"
  (make-ast-node 'while-stmt
                 'condition condition
                 'body body
                 'location (make-location line col)))

;; For statement
;; (for-stmt init condition update body location)

(define (make-for-stmt init condition update body line col)
  "Create a for statement node"
  (make-ast-node 'for-stmt
                 'init init            ; can be #f
                 'condition condition  ; can be #f (infinite loop)
                 'update update        ; can be #f
                 'body body
                 'location (make-location line col)))

;; Block statement
;; (block-stmt statements location)

(define (make-block-stmt statements line col)
  "Create a block statement node"
  (make-ast-node 'block-stmt
                 'statements statements
                 'location (make-location line col)))

; ----------------------------------------------------------------------------
; DECLARATIONS - Define new bindings
; ----------------------------------------------------------------------------

;; Parameter definition
;; (param name type location)

(define (make-param name type line col)
  "Create a function parameter node"
  (make-ast-node 'param
                 'name name
                 'type type
                 'location (make-location line col)))

;; Function declaration
;; (fun-decl name params return-type body location)

(define (make-fun-decl name params return-type body line col)
  "Create a function declaration node"
  (make-ast-node 'fun-decl
                 'name name
                 'params params          ; list of param nodes
                 'return-type return-type ; can be #f (void)
                 'body body              ; block-stmt
                 'location (make-location line col)))

;; Struct field
;; (field name type location)

(define (make-field name type line col)
  "Create a struct field node"
  (make-ast-node 'field
                 'name name
                 'type type
                 'location (make-location line col)))

;; Struct declaration
;; (struct-decl name fields location)

(define (make-struct-decl name fields line col)
  "Create a struct declaration node"
  (make-ast-node 'struct-decl
                 'name name
                 'fields fields  ; list of field nodes
                 'location (make-location line col)))

;; Trait declaration
;; (trait-decl name methods location)

(define (make-trait-decl name methods line col)
  "Create a trait declaration node"
  (make-ast-node 'trait-decl
                 'name name
                 'methods methods  ; list of method signatures
                 'location (make-location line col)))

;; Impl declaration
;; (impl-decl type-name trait-name methods location)

(define (make-impl-decl type-name trait-name methods line col)
  "Create an impl declaration node"
  (make-ast-node 'impl-decl
                 'type-name type-name
                 'trait-name trait-name  ; can be #f for inherent impl
                 'methods methods        ; list of fun-decl nodes
                 'location (make-location line col)))

; ----------------------------------------------------------------------------
; TYPE ANNOTATIONS
; ----------------------------------------------------------------------------

;; Primitive type
;; (primitive-type name location)

(define (make-primitive-type name line col)
  "Create a primitive type node (int, float, string, bool, void)"
  (make-ast-node 'primitive-type
                 'name name
                 'location (make-location line col)))

;; Named type (user-defined)
;; (named-type name location)

(define (make-named-type name line col)
  "Create a named type node (struct, trait)"
  (make-ast-node 'named-type
                 'name name
                 'location (make-location line col)))

;; Array type
;; (array-type element-type location)

(define (make-array-type element-type line col)
  "Create an array type node"
  (make-ast-node 'array-type
                 'element-type element-type
                 'location (make-location line col)))

; ----------------------------------------------------------------------------
; PROGRAM - Top-level container
; ----------------------------------------------------------------------------

(define (make-program declarations)
  "Create a program node containing all top-level declarations"
  (make-ast-node 'program
                 'declarations declarations))

; ----------------------------------------------------------------------------
; AST Predicates - Type checking for nodes
; ----------------------------------------------------------------------------

(define (integer-literal? node) (eq? (ast-type node) 'integer-literal))
(define (float-literal? node) (eq? (ast-type node) 'float-literal))
(define (string-literal? node) (eq? (ast-type node) 'string-literal))
(define (bool-literal? node) (eq? (ast-type node) 'bool-literal))
(define (null-literal? node) (eq? (ast-type node) 'null-literal))
(define (literal? node)
  (or (integer-literal? node)
      (float-literal? node)
      (string-literal? node)
      (bool-literal? node)
      (null-literal? node)))

(define (identifier? node) (eq? (ast-type node) 'identifier))
(define (binary-expr? node) (eq? (ast-type node) 'binary-expr))
(define (unary-expr? node) (eq? (ast-type node) 'unary-expr))
(define (group-expr? node) (eq? (ast-type node) 'group-expr))
(define (call-expr? node) (eq? (ast-type node) 'call-expr))
(define (member-expr? node) (eq? (ast-type node) 'member-expr))
(define (index-expr? node) (eq? (ast-type node) 'index-expr))
(define (assign-expr? node) (eq? (ast-type node) 'assign-expr))

(define (expr-stmt? node) (eq? (ast-type node) 'expr-stmt))
(define (let-stmt? node) (eq? (ast-type node) 'let-stmt))
(define (return-stmt? node) (eq? (ast-type node) 'return-stmt))
(define (if-stmt? node) (eq? (ast-type node) 'if-stmt))
(define (while-stmt? node) (eq? (ast-type node) 'while-stmt))
(define (for-stmt? node) (eq? (ast-type node) 'for-stmt))
(define (block-stmt? node) (eq? (ast-type node) 'block-stmt))

(define (fun-decl? node) (eq? (ast-type node) 'fun-decl))
(define (struct-decl? node) (eq? (ast-type node) 'struct-decl))
(define (trait-decl? node) (eq? (ast-type node) 'trait-decl))
(define (impl-decl? node) (eq? (ast-type node) 'impl-decl))

(define (program? node) (eq? (ast-type node) 'program))

; ----------------------------------------------------------------------------
; AST Pretty Printer (for debugging)
; ----------------------------------------------------------------------------

(define (ast-print node)
  "Pretty print an AST node"
  (ast-print-helper node 0))

(define (ast-print-helper node indent)
  "Helper function for pretty printing with indentation"
  (let ((indent-str (make-string (* indent 2) #\space)))
    (display indent-str)
    (cond
      ; Literals
      ((integer-literal? node)
       (display "(integer-literal ")
       (display (ast-get node 'value))
       (display ")\n"))
      
      ((float-literal? node)
       (display "(float-literal ")
       (display (ast-get node 'value))
       (display ")\n"))
      
      ((string-literal? node)
       (display "(string-literal \"")
       (display (ast-get node 'value))
       (display "\")\n"))
      
      ((bool-literal? node)
       (display "(bool-literal ")
       (display (ast-get node 'value))
       (display ")\n"))
      
      ((null-literal? node)
       (display "(null-literal)\n"))
      
      ; Identifier
      ((identifier? node)
       (display "(identifier ")
       (display (ast-get node 'name))
       (display ")\n"))
      
      ; Binary expression
      ((binary-expr? node)
       (display "(binary-expr ")
       (display (ast-get node 'operator))
       (display "\n")
       (ast-print-helper (ast-get node 'left) (+ indent 1))
       (ast-print-helper (ast-get node 'right) (+ indent 1))
       (display indent-str)
       (display ")\n"))
      
      ; Unary expression
      ((unary-expr? node)
       (display "(unary-expr ")
       (display (ast-get node 'operator))
       (display "\n")
       (ast-print-helper (ast-get node 'operand) (+ indent 1))
       (display indent-str)
       (display ")\n"))
      
      ; Call expression
      ((call-expr? node)
       (display "(call-expr\n")
       (ast-print-helper (ast-get node 'callee) (+ indent 1))
       (display indent-str)
       (display "  args:\n")
       (for-each (lambda (arg) (ast-print-helper arg (+ indent 2)))
                 (ast-get node 'arguments))
       (display indent-str)
       (display ")\n"))
      
      ; Block statement
      ((block-stmt? node)
       (display "(block-stmt\n")
       (for-each (lambda (stmt) (ast-print-helper stmt (+ indent 1)))
                 (ast-get node 'statements))
       (display indent-str)
       (display ")\n"))
      
      ; Function declaration
      ((fun-decl? node)
       (display "(fun-decl ")
       (display (ast-get node 'name))
       (display "\n")
       (display indent-str)
       (display "  params: ")
       (display (map (lambda (p) (ast-get p 'name)) (ast-get node 'params)))
       (display "\n")
       (display indent-str)
       (display "  return-type: ")
       (display (ast-get node 'return-type))
       (display "\n")
       (display indent-str)
       (display "  body:\n")
       (ast-print-helper (ast-get node 'body) (+ indent 2))
       (display indent-str)
       (display ")\n"))
      
      ; Program
      ((program? node)
       (display "(program\n")
       (for-each (lambda (decl) (ast-print-helper decl (+ indent 1)))
                 (ast-get node 'declarations))
       (display ")\n"))
      
      ; Default case
      (else
       (display "(")
       (display (ast-type node))
       (display " ...)\n")))))

; ============================================================================
; End of ast.scm
; ============================================================================

