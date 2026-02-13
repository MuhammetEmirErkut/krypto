; ============================================================================
; KRYPTO Programming Language - Interpreter Tests
; ============================================================================

; Load dependencies in correct order
(load "../src/lexer/lexer.scm")
(load "../src/parser/ast.scm")
(load "../src/parser/parser.scm")
(load "../src/semantic/types.scm")
(load "../src/semantic/symbol-table.scm")
(load "../src/semantic/analyzer.scm")
(load "../src/interpreter/environment.scm")
(load "../src/interpreter/interpreter.scm")

(import (chezscheme))
(import (semantic types))
(import (semantic symbol-table))

; ----------------------------------------------------------------------------
; Test Helpers
; ----------------------------------------------------------------------------

(define *tests-passed* 0)
(define *tests-failed* 0)

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

; Helper to run interpreter and capture print output
(define (run-and-capture source)
  "Parse, analyze, and interpret source, capturing stdout output"
  (let ((ast (parse source)))
    (if ast
        (begin
          (let ((output (with-output-to-string (lambda () (interpret ast)))))
            output))
        (error 'run-and-capture "Parse failed"))))

; Helper to evaluate a single expression
(define (eval-expr source)
  "Parse and evaluate a single expression, return its value"
  (let ((ast (parse source)))
    (if ast
        (let* ((decls (ast-get ast 'declarations))
               (stmt (car decls))
               (expr (ast-get stmt 'expression))
               (env (make-global-env)))
          (eval-node expr env))
        (error 'eval-expr "Parse failed"))))

; ----------------------------------------------------------------------------
; Literal Tests
; ----------------------------------------------------------------------------

(define (test-integer-eval)
  "Test evaluating integer literals"
  (assert-equal "integer literal 42" 42 (eval-expr "42"))
  (assert-equal "integer literal 0" 0 (eval-expr "0"))
  (assert-equal "integer literal 100" 100 (eval-expr "100")))

(define (test-float-eval)
  "Test evaluating float literals"
  (assert-equal "float literal 3.14" 3.14 (eval-expr "3.14"))
  (assert-equal "float literal 0.5" 0.5 (eval-expr "0.5")))

(define (test-string-eval)
  "Test evaluating string literals"
  (assert-equal "string literal" "hello" (eval-expr "\"hello\""))
  (assert-equal "empty string" "" (eval-expr "\"\"")))

(define (test-bool-eval)
  "Test evaluating boolean literals"
  (assert-equal "true literal" #t (eval-expr "true"))
  (assert-equal "false literal" #f (eval-expr "false")))

; ----------------------------------------------------------------------------
; Arithmetic Tests
; ----------------------------------------------------------------------------

(define (test-arithmetic)
  "Test arithmetic operations"
  (assert-equal "addition" 5 (eval-expr "2 + 3"))
  (assert-equal "subtraction" 7 (eval-expr "10 - 3"))
  (assert-equal "multiplication" 12 (eval-expr "3 * 4"))
  (assert-equal "division" 5 (eval-expr "10 / 2"))
  (assert-equal "complex expr" 14 (eval-expr "2 + 3 * 4"))
  (assert-equal "grouped expr" 20 (eval-expr "(2 + 3) * 4")))

(define (test-comparison)
  "Test comparison operations"
  (assert-equal "less than true" #t (eval-expr "1 < 2"))
  (assert-equal "less than false" #f (eval-expr "2 < 1"))
  (assert-equal "greater than" #t (eval-expr "5 > 3"))
  (assert-equal "equal" #t (eval-expr "5 == 5"))
  (assert-equal "not equal" #t (eval-expr "5 != 3"))
  (assert-equal "less equal" #t (eval-expr "5 <= 5"))
  (assert-equal "greater equal" #t (eval-expr "5 >= 3")))

(define (test-unary)
  "Test unary operations"
  (assert-equal "negate" -5 (eval-expr "-5"))
  (assert-equal "negate expression" -7 (eval-expr "-(3 + 4)")))

(define (test-string-concat)
  "Test string concatenation"
  (assert-equal "string concat" "helloworld" (eval-expr "\"hello\" + \"world\"")))

; ----------------------------------------------------------------------------
; Variable and Print Tests
; ----------------------------------------------------------------------------

(define (test-let-and-print)
  "Test let statement and print"
  (let ((output (run-and-capture "let x = 42\nprint(x)")))
    (assert-equal "let and print" "42\n" output)))

(define (test-variable-assignment)
  "Test variable assignment"
  (let ((output (run-and-capture "let x = 10\nx = 20\nprint(x)")))
    (assert-equal "variable assignment" "20\n" output)))

(define (test-multiple-variables)
  "Test multiple variables"
  (let ((output (run-and-capture "let a = 5\nlet b = 10\nlet c = a + b\nprint(c)")))
    (assert-equal "multiple variables" "15\n" output)))

; ----------------------------------------------------------------------------
; Control Flow Tests
; ----------------------------------------------------------------------------

(define (test-if-true)
  "Test if with true condition"
  (let ((output (run-and-capture "if (true) { print(\"yes\") }")))
    (assert-equal "if true" "yes\n" output)))

(define (test-if-false)
  "Test if with false condition"
  (let ((output (run-and-capture "if (false) { print(\"yes\") } else { print(\"no\") }")))
    (assert-equal "if false" "no\n" output)))

(define (test-if-comparison)
  "Test if with comparison"
  (let ((output (run-and-capture "let x = 10\nif (x > 5) { print(\"big\") } else { print(\"small\") }")))
    (assert-equal "if comparison" "big\n" output)))

(define (test-while-loop)
  "Test while loop"
  (let ((output (run-and-capture "let i = 0\nwhile (i < 3) { print(i)\ni = i + 1 }")))
    (assert-equal "while loop" "0\n1\n2\n" output)))

(define (test-for-loop)
  "Test for loop"
  (let ((output (run-and-capture "for (let i = 0; i < 3; i = i + 1) { print(i) }")))
    (assert-equal "for loop" "0\n1\n2\n" output)))

; ----------------------------------------------------------------------------
; Function Tests
; ----------------------------------------------------------------------------

(define (test-simple-function)
  "Test simple function declaration and call"
  (let ((output (run-and-capture "fun greet() { print(\"hello\") }\ngreet()")))
    (assert-equal "simple function call" "hello\n" output)))

(define (test-function-with-args)
  "Test function with arguments"
  (let ((output (run-and-capture "fun add(a: int, b: int) { print(a + b) }\nadd(3, 4)")))
    (assert-equal "function with args" "7\n" output)))

(define (test-function-return)
  "Test function with return"
  (let ((output (run-and-capture "int fun square(x: int) { return x * x }\nprint(square(5))")))
    (assert-equal "function return" "25\n" output)))

(define (test-recursive-function)
  "Test recursive function (factorial)"
  (let ((output (run-and-capture "int fun factorial(n: int) {\nif (n <= 1) { return 1 }\nreturn n * factorial(n - 1)\n}\nprint(factorial(5))")))
    (assert-equal "recursive factorial" "120\n" output)))

(define (test-fibonacci)
  "Test fibonacci function"
  (let ((output (run-and-capture "int fun fib(n: int) {\nif (n <= 1) { return n }\nreturn fib(n - 1) + fib(n - 2)\n}\nprint(fib(10))")))
    (assert-equal "fibonacci(10)" "55\n" output)))

; ----------------------------------------------------------------------------
; Run All Tests
; ----------------------------------------------------------------------------

(define (run-all-tests)
  "Run all interpreter tests"
  (display "Running Interpreter Tests...")
  (newline)
  (display "========================================")
  (newline)
  (newline)
  
  (display "--- Literal Tests ---\n")
  (test-integer-eval)
  (test-float-eval)
  (test-string-eval)
  (test-bool-eval)
  
  (newline)
  (display "--- Arithmetic Tests ---\n")
  (test-arithmetic)
  (test-comparison)
  (test-unary)
  (test-string-concat)
  
  (newline)
  (display "--- Variable Tests ---\n")
  (test-let-and-print)
  (test-variable-assignment)
  (test-multiple-variables)
  
  (newline)
  (display "--- Control Flow Tests ---\n")
  (test-if-true)
  (test-if-false)
  (test-if-comparison)
  (test-while-loop)
  (test-for-loop)
  
  (newline)
  (display "--- Function Tests ---\n")
  (test-simple-function)
  (test-function-with-args)
  (test-function-return)
  (test-recursive-function)
  (test-fibonacci)
  
  (print-summary))

; Run tests
(run-all-tests)

; ============================================================================
; End of test_interpreter.scm
; ============================================================================
