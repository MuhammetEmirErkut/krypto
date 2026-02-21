; ============================================================================
; KRYPTO Programming Language
; Main Entry Point
; ============================================================================

(import (chezscheme))

; Load core modules
(load "src/lexer/lexer.scm")
(load "src/parser/ast.scm")
(load "src/parser/parser.scm")

; Load Semantic Analysis Modules
(load "src/semantic/types.scm")
(load "src/semantic/symbol-table.scm")
(load "src/semantic/analyzer.scm")

; Load Interpreter Modules
(load "src/interpreter/environment.scm")
(load "src/interpreter/interpreter.scm")

; Import Libraries
(import (semantic types))
(import (semantic symbol-table))

; ----------------------------------------------------------------------------
; Version Information
; ----------------------------------------------------------------------------

(define *krypto-version* "0.4.0")
(define *krypto-name* "Krypto")

; ----------------------------------------------------------------------------
; Main Entry Point
; ----------------------------------------------------------------------------

(define (krypto-repl)
  (display "Welcome to ") (display *krypto-name*) (display " v") (display *krypto-version*) (newline)
  (display "Commands: :quit to exit, :load <filename> to run a file") (newline) (newline)
  (repl-loop))

(define (repl-loop)
  (display "krypto> ")
  (let ((input (read-line)))
    (cond
      ((eof-object? input) (newline) (display "Goodbye!") (newline))
      ((string=? input ":quit") (display "Goodbye!") (newline))
      ((string=? input "") (repl-loop))
      ((and (> (string-length input) 6) 
            (string=? (substring input 0 6) ":load "))
       (let ((file-name (substring input 6 (string-length input))))
         (run-file file-name)
         (repl-loop)))
      (else (process-input input) (repl-loop)))))

(define (process-input input)
  (let ((tokens (tokenize input)))
    (let ((ast (parse input)))
      (display "Running Semantic Analysis...")(newline)
      (if (analyze ast)
          (begin
            (display "Running Interpreter...")(newline)
            (interpret ast))
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
                           (begin
                             (display "Running Interpreter...")(newline)
                             (interpret ast)
                             (display "Execution complete.")(newline))
                           (display "Semantic Analysis Failed.")))
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
         (if (null? chars) char (trim-whitespace (list->string (reverse chars)))))
        ((char=? char #\newline)
         (trim-whitespace (list->string (reverse chars))))
        (else
         (loop (cons char chars)))))))

(define (trim-whitespace str)
  (let* ((len (string-length str))
         (start (let loop ((i 0))
                  (if (and (< i len) (char-whitespace? (string-ref str i)))
                      (loop (+ i 1))
                      i)))
         (end (let loop ((i (- len 1)))
                (if (and (>= i start) (char-whitespace? (string-ref str i)))
                    (loop (- i 1))
                    (+ i 1)))))
    (if (>= start end)
        ""
        (substring str start end))))

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
