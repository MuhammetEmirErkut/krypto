; ============================================================================
; KRYPTO Programming Language - Parser Tests
; ============================================================================

; Load dependencies in correct order
(load "../src/lexer/lexer.scm")
(load "../src/parser/ast.scm")
(load "../src/parser/parser.scm")

; ----------------------------------------------------------------------------
; Test Helpers
; ----------------------------------------------------------------------------

(define *tests-passed* 0)
(define *tests-failed* 0)

(define (assert-true name condition)
  "Assert that condition is true"
  (if condition
      (begin
        (set! *tests-passed* (+ 1 *tests-passed*))
        (display "[PASS] ")
        (display name)
        (newline))
      (begin
        (set! *tests-failed* (+ 1 *tests-failed*))
        (display "[FAIL] ")
        (display name)
        (newline))))

(define (assert-equal name expected actual)
  "Assert that expected equals actual"
  (if (equal? expected actual)
      (begin
        (set! *tests-passed* (+ 1 *tests-passed*))
        (display "[PASS] ")
        (display name)
        (newline))
      (begin
        (set! *tests-failed* (+ 1 *tests-failed*))
        (display "[FAIL] ")
        (display name)
        (newline)
        (display "  Expected: ")
        (display expected)
        (newline)
        (display "  Actual:   ")
        (display actual)
        (newline))))

(define (print-summary)
  "Print test summary"
  (newline)
  (display "========================================")
  (newline)
  (display "Tests passed: ")
  (display *tests-passed*)
  (newline)
  (display "Tests failed: ")
  (display *tests-failed*)
  (newline)
  (display "========================================")
  (newline))

; ----------------------------------------------------------------------------
; Literal Tests
; ----------------------------------------------------------------------------

(define (test-integer-literal)
  "Test parsing integer literals"
  (let* ((ast (parse "42"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls))
         (expr (ast-get stmt 'expression)))
    (assert-true "integer literal parsed"
                 (integer-literal? expr))
    (assert-equal "integer value"
                  42
                  (ast-get expr 'value))))

(define (test-float-literal)
  "Test parsing float literals"
  (let* ((ast (parse "3.14"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls))
         (expr (ast-get stmt 'expression)))
    (assert-true "float literal parsed"
                 (float-literal? expr))
    (assert-equal "float value"
                  3.14
                  (ast-get expr 'value))))

(define (test-string-literal)
  "Test parsing string literals"
  (let* ((ast (parse "\"hello\""))
         (decls (ast-get ast 'declarations))
         (stmt (car decls))
         (expr (ast-get stmt 'expression)))
    (assert-true "string literal parsed"
                 (string-literal? expr))
    (assert-equal "string value"
                  "hello"
                  (ast-get expr 'value))))

(define (test-bool-literals)
  "Test parsing boolean literals"
  (let* ((ast1 (parse "true"))
         (decls1 (ast-get ast1 'declarations))
         (stmt1 (car decls1))
         (expr1 (ast-get stmt1 'expression))
         (ast2 (parse "false"))
         (decls2 (ast-get ast2 'declarations))
         (stmt2 (car decls2))
         (expr2 (ast-get stmt2 'expression)))
    (assert-true "true literal parsed"
                 (bool-literal? expr1))
    (assert-equal "true value"
                  #t
                  (ast-get expr1 'value))
    (assert-true "false literal parsed"
                 (bool-literal? expr2))
    (assert-equal "false value"
                  #f
                  (ast-get expr2 'value))))

; ----------------------------------------------------------------------------
; Expression Tests
; ----------------------------------------------------------------------------

(define (test-identifier)
  "Test parsing identifiers"
  (let* ((ast (parse "foo"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls))
         (expr (ast-get stmt 'expression)))
    (assert-true "identifier parsed"
                 (identifier? expr))
    (assert-equal "identifier name"
                  "foo"
                  (ast-get expr 'name))))

(define (test-binary-addition)
  "Test parsing binary addition"
  (let* ((ast (parse "1 + 2"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls))
         (expr (ast-get stmt 'expression)))
    (assert-true "binary expr parsed"
                 (binary-expr? expr))
    (assert-equal "operator is add"
                  'add
                  (ast-get expr 'operator))
    (assert-equal "left operand"
                  1
                  (ast-get (ast-get expr 'left) 'value))
    (assert-equal "right operand"
                  2
                  (ast-get (ast-get expr 'right) 'value))))

(define (test-binary-precedence)
  "Test operator precedence: 1 + 2 * 3 should parse as 1 + (2 * 3)"
  (let* ((ast (parse "1 + 2 * 3"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls))
         (expr (ast-get stmt 'expression)))
    ; expr should be (+ 1 (* 2 3))
    (assert-equal "outer operator is add"
                  'add
                  (ast-get expr 'operator))
    (assert-equal "left is 1"
                  1
                  (ast-get (ast-get expr 'left) 'value))
    (assert-equal "right is multiply expr"
                  'multiply
                  (ast-get (ast-get expr 'right) 'operator))))

(define (test-unary-negation)
  "Test parsing unary negation"
  (let* ((ast (parse "-42"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls))
         (expr (ast-get stmt 'expression)))
    (assert-true "unary expr parsed"
                 (unary-expr? expr))
    (assert-equal "operator is negate"
                  'negate
                  (ast-get expr 'operator))))

(define (test-grouped-expression)
  "Test parsing grouped expressions: (1 + 2) * 3"
  (let* ((ast (parse "(1 + 2) * 3"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls))
         (expr (ast-get stmt 'expression)))
    ; expr should be (* (group (+ 1 2)) 3)
    (assert-equal "outer operator is multiply"
                  'multiply
                  (ast-get expr 'operator))
    (assert-true "left is group expr"
                 (group-expr? (ast-get expr 'left)))))

(define (test-comparison)
  "Test parsing comparison expressions"
  (let* ((ast (parse "x < 10"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls))
         (expr (ast-get stmt 'expression)))
    (assert-true "binary expr parsed"
                 (binary-expr? expr))
    (assert-equal "operator is less-than"
                  'less-than
                  (ast-get expr 'operator))))

(define (test-function-call)
  "Test parsing function calls"
  (let* ((ast (parse "foo(1, 2, 3)"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls))
         (expr (ast-get stmt 'expression)))
    (assert-true "call expr parsed"
                 (call-expr? expr))
    (assert-equal "callee name"
                  "foo"
                  (ast-get (ast-get expr 'callee) 'name))
    (assert-equal "argument count"
                  3
                  (length (ast-get expr 'arguments)))))

; ----------------------------------------------------------------------------
; Statement Tests
; ----------------------------------------------------------------------------

(define (test-let-statement)
  "Test parsing let statements"
  (let* ((ast (parse "let x = 42"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls)))
    (assert-true "let stmt parsed"
                 (let-stmt? stmt))
    (assert-equal "variable name"
                  "x"
                  (ast-get stmt 'name))
    (assert-equal "not mutable"
                  #f
                  (ast-get stmt 'is-mutable))))

(define (test-let-mut-statement)
  "Test parsing mutable let statements"
  (let* ((ast (parse "let mut x = 42"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls)))
    (assert-true "let stmt parsed"
                 (let-stmt? stmt))
    (assert-equal "is mutable"
                  #t
                  (ast-get stmt 'is-mutable))))

(define (test-let-with-type)
  "Test parsing let with type annotation"
  (let* ((ast (parse "let x: int = 42"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls))
         (type-ann (ast-get stmt 'type-annotation)))
    (assert-true "has type annotation"
                 (not (eq? type-ann #f)))
    (assert-equal "type is int"
                  "int"
                  (ast-get type-ann 'name))))

(define (test-if-statement)
  "Test parsing if statements"
  (let* ((ast (parse "if (x > 0) { y }"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls)))
    (assert-true "if stmt parsed"
                 (if-stmt? stmt))
    (assert-true "has condition"
                 (binary-expr? (ast-get stmt 'condition)))
    (assert-true "has then branch"
                 (block-stmt? (ast-get stmt 'then-branch)))
    (assert-equal "no else branch"
                  #f
                  (ast-get stmt 'else-branch))))

(define (test-if-else-statement)
  "Test parsing if-else statements"
  (let* ((ast (parse "if (x > 0) { y } else { z }"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls)))
    (assert-true "if stmt parsed"
                 (if-stmt? stmt))
    (assert-true "has else branch"
                 (block-stmt? (ast-get stmt 'else-branch)))))

(define (test-while-statement)
  "Test parsing while statements"
  (let* ((ast (parse "while (x > 0) { x }"))
         (decls (ast-get ast 'declarations))
         (stmt (car decls)))
    (assert-true "while stmt parsed"
                 (while-stmt? stmt))
    (assert-true "has condition"
                 (binary-expr? (ast-get stmt 'condition)))
    (assert-true "has body"
                 (block-stmt? (ast-get stmt 'body)))))

; ----------------------------------------------------------------------------
; Function Declaration Tests
; ----------------------------------------------------------------------------

(define (test-simple-function)
  "Test parsing simple function declaration"
  (let* ((ast (parse "fun hello() { }"))
         (decls (ast-get ast 'declarations))
         (func (car decls)))
    (assert-true "function decl parsed"
                 (fun-decl? func))
    (assert-equal "function name"
                  "hello"
                  (ast-get func 'name))
    (assert-equal "no params"
                  0
                  (length (ast-get func 'params)))
    (assert-equal "no return type"
                  #f
                  (ast-get func 'return-type))))

(define (test-function-with-params)
  "Test parsing function with parameters"
  (let* ((ast (parse "fun add(a: int, b: int) { }"))
         (decls (ast-get ast 'declarations))
         (func (car decls))
         (params (ast-get func 'params)))
    (assert-equal "param count"
                  2
                  (length params))
    (assert-equal "first param name"
                  "a"
                  (ast-get (car params) 'name))
    (assert-equal "first param type"
                  "int"
                  (ast-get (ast-get (car params) 'type) 'name))))

(define (test-function-with-return-type)
  "Test parsing function with return type"
  (let* ((ast (parse "int fun answer() { return 42 }"))
         (decls (ast-get ast 'declarations))
         (func (car decls))
         (ret-type (ast-get func 'return-type)))
    (assert-true "has return type"
                 (not (eq? ret-type #f)))
    (assert-equal "return type is int"
                  "int"
                  (ast-get ret-type 'name))))

(define (test-fibonacci-function)
  "Test parsing fibonacci function"
  (let* ((source "int fun fib(n: int) {
                    if (n <= 1) {
                      return n
                    }
                    return fib(n - 1) + fib(n - 2)
                  }")
         (ast (parse source))
         (decls (ast-get ast 'declarations))
         (func (car decls)))
    (assert-true "function decl parsed"
                 (fun-decl? func))
    (assert-equal "function name"
                  "fib"
                  (ast-get func 'name))))

; ----------------------------------------------------------------------------
; Run All Tests
; ----------------------------------------------------------------------------

(define (run-all-tests)
  "Run all parser tests"
  (display "Running Parser Tests...")
  (newline)
  (display "========================================")
  (newline)
  (newline)
  
  (display "--- Literal Tests ---\n")
  (test-integer-literal)
  (test-float-literal)
  (test-string-literal)
  (test-bool-literals)
  
  (newline)
  (display "--- Expression Tests ---\n")
  (test-identifier)
  (test-binary-addition)
  (test-binary-precedence)
  (test-unary-negation)
  (test-grouped-expression)
  (test-comparison)
  (test-function-call)
  
  (newline)
  (display "--- Statement Tests ---\n")
  (test-let-statement)
  (test-let-mut-statement)
  (test-let-with-type)
  (test-if-statement)
  (test-if-else-statement)
  (test-while-statement)
  
  (newline)
  (display "--- Function Declaration Tests ---\n")
  (test-simple-function)
  (test-function-with-params)
  (test-function-with-return-type)
  (test-fibonacci-function)
  
  (print-summary))

; Run tests
(run-all-tests)

; ============================================================================
; End of test_parser.scm
; ============================================================================

