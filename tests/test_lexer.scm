; ============================================================================
; KRYPTO Programming Language - Lexer Tests
; ============================================================================

(load "../src/lexer/lexer.scm")

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
; Tests
; ----------------------------------------------------------------------------

(define (test-empty-input)
  "Test tokenizing empty input"
  (let ((tokens (tokenize "")))
    (assert-equal "empty input produces EOF token"
                  'TOKEN-EOF
                  (token-type (car tokens)))))

(define (test-integer-literal)
  "Test tokenizing integer literals"
  (let ((tokens (tokenize "42")))
    (assert-equal "integer token type"
                  'TOKEN-INTEGER
                  (token-type (car tokens)))
    (assert-equal "integer token value"
                  "42"
                  (token-value (car tokens)))))

(define (test-float-literal)
  "Test tokenizing float literals"
  (let ((tokens (tokenize "3.14")))
    (assert-equal "float token type"
                  'TOKEN-FLOAT
                  (token-type (car tokens)))
    (assert-equal "float token value"
                  "3.14"
                  (token-value (car tokens)))))

(define (test-string-literal)
  "Test tokenizing string literals"
  (let ((tokens (tokenize "\"hello world\"")))
    (assert-equal "string token type"
                  'TOKEN-STRING
                  (token-type (car tokens)))
    (assert-equal "string token value"
                  "hello world"
                  (token-value (car tokens)))))

(define (test-identifiers)
  "Test tokenizing identifiers"
  (let ((tokens (tokenize "foo bar_baz x1")))
    (assert-equal "first identifier"
                  'TOKEN-IDENTIFIER
                  (token-type (car tokens)))
    (assert-equal "identifier value"
                  "foo"
                  (token-value (car tokens)))))

(define (test-keywords)
  "Test tokenizing keywords"
  (let ((tokens (tokenize "fun let if else")))
    (assert-equal "fun is keyword"
                  'TOKEN-KEYWORD
                  (token-type (car tokens)))
    (assert-equal "fun value"
                  "fun"
                  (token-value (car tokens)))))

(define (test-operators)
  "Test tokenizing operators"
  (let ((tokens (tokenize "+ - * / == != < > <= >=")))
    (assert-equal "plus operator"
                  'TOKEN-PLUS
                  (token-type (car tokens)))))

(define (test-simple-expression)
  "Test tokenizing a simple expression"
  (let ((tokens (tokenize "x + 42")))
    (assert-equal "identifier x"
                  'TOKEN-IDENTIFIER
                  (token-type (car tokens)))
    (assert-equal "plus operator"
                  'TOKEN-PLUS
                  (token-type (cadr tokens)))
    (assert-equal "integer 42"
                  'TOKEN-INTEGER
                  (token-type (caddr tokens)))))

(define (test-function-definition)
  "Test tokenizing a function definition"
  (let ((tokens (tokenize "fun add(a, b) { return a + b }")))
    (assert-equal "fun keyword"
                  'TOKEN-KEYWORD
                  (token-type (car tokens)))
    (assert-equal "function name"
                  'TOKEN-IDENTIFIER
                  (token-type (cadr tokens)))))

; ----------------------------------------------------------------------------
; Run All Tests
; ----------------------------------------------------------------------------

(define (run-all-tests)
  "Run all lexer tests"
  (display "Running Lexer Tests...")
  (newline)
  (display "========================================")
  (newline)
  (newline)
  
  (test-empty-input)
  (test-integer-literal)
  (test-float-literal)
  (test-string-literal)
  (test-identifiers)
  (test-keywords)
  (test-operators)
  (test-simple-expression)
  (test-function-definition)
  
  (print-summary))

; Run tests
(run-all-tests)

; ============================================================================
; End of test_lexer.scm
; ============================================================================

