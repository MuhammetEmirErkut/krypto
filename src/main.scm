; ============================================================================
; KRYPTO Programming Language
; Main Entry Point
; ============================================================================

(import (chezscheme))

; Load core modules
(load "lexer/lexer.scm")
(load "parser/ast.scm")
(load "parser/parser.scm")

; Load Semantic Analysis Modules
(load "semantic/types.scm")
(load "semantic/symbol-table.scm")
(load "semantic/analyzer.scm")

; Import Libraries
(import (semantic types))
(import (semantic symbol-table))
; (import (semantic analyzer)) ; Loaded as script

; ----------------------------------------------------------------------------
; Version Information
; ----------------------------------------------------------------------------

(define *krypto-version* "0.3.0")
(define *krypto-name* "Krypto")

; ----------------------------------------------------------------------------
; Main Entry Point
; ----------------------------------------------------------------------------

(define (krypto-repl)
  (display "Welcome to ") (display *krypto-name*) (display " v") (display *krypto-version*) (newline)
  (display "Type :quit to exit") (newline) (newline)
  (repl-loop))

(define (repl-loop)
  (display "krypto> ")
  (let ((input (read-line)))
    (cond
      ((eof-object? input) (newline) (display "Goodbye!") (newline))
      ((string=? input ":quit") (display "Goodbye!") (newline))
      ((string=? input "") (repl-loop))
      (else (process-input input) (repl-loop)))))

(define (process-input input)
  (let ((tokens (tokenize input)))
    (let ((ast (parse input)))
      (display "Running Semantic Analysis...")(newline)
      (if (analyze ast)
          (display "Semantic Analysis Passed.")
          (display "Semantic Analysis Failed."))
      (newline))))

; ----------------------------------------------------------------------------
; File Processing
; ----------------------------------------------------------------------------

(define (run-file filename)
  (display "Running: ") (display filename) (newline)
  (let ((source (read-source-file filename)))
    (if source
        (begin 
           (let ((tokens (tokenize source)))
             (let ((ast (parse source)))
               (display "Parsing...")(newline)
               (if ast
                   (begin
                       (display "Running Semantic Analysis...")(newline)
                       (if (analyze ast)
                           (display "Success!")
                           (display "Failed."))
                       (newline))
                   (display "Parsing failed.")))))
        (begin
          (display "Error: Could not read file ") (display filename) (newline)))))

(define (read-source-file filename)
  (if (file-exists? filename)
      (call-with-input-file filename
        (lambda (port)
          (let loop ((chars '()))
            (let ((char (read-char port)))
              (if (eof-object? char)
                  (list->string (reverse chars))
                  (loop (cons char chars)))))))
      #f))

; ----------------------------------------------------------------------------
; Inputs
; ----------------------------------------------------------------------------

(define (read-line)
  (let loop ((chars '()))
    (let ((char (read-char)))
      (cond
        ((eof-object? char)
         (if (null? chars) char (list->string (reverse chars))))
        ((char=? char #\newline)
         (list->string (reverse chars)))
        (else
         (loop (cons char chars)))))))

; ----------------------------------------------------------------------------
; CLI
; ----------------------------------------------------------------------------

(define (main args)
  (if (null? (cdr args))
      (krypto-repl)
      (let ((arg (cadr args)))
        (if (equal? arg "repl")
            (krypto-repl)
            (run-file arg)))))

(main (command-line))
