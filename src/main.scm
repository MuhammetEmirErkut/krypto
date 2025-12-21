; ============================================================================
; KRYPTO Programming Language
; Main Entry Point
; ============================================================================
;
; This is the main entry point for the Krypto programming language compiler
; and interpreter. It coordinates all phases of compilation:
;   1. Lexical analysis (tokenization)
;   2. Parsing (AST generation)
;   3. Semantic analysis (type checking)
;   4. Code generation / interpretation
;
; ============================================================================

; Load core modules
(load "lexer/lexer.scm")

; ----------------------------------------------------------------------------
; Version Information
; ----------------------------------------------------------------------------

(define *krypto-version* "0.1.0")
(define *krypto-name* "Krypto")

; ----------------------------------------------------------------------------
; Main Entry Point
; ----------------------------------------------------------------------------

(define (krypto-repl)
  "Start the Krypto REPL (Read-Eval-Print Loop)"
  (display "Welcome to ")
  (display *krypto-name*)
  (display " v")
  (display *krypto-version*)
  (newline)
  (display "Type :quit to exit")
  (newline)
  (newline)
  (repl-loop))

(define (repl-loop)
  "Main REPL loop - reads input, processes it, and prints results"
  (display "krypto> ")
  (let ((input (read-line)))
    (cond
      ((eof-object? input)
       (newline)
       (display "Goodbye!")
       (newline))
      ((string=? input ":quit")
       (display "Goodbye!")
       (newline))
      ((string=? input "")
       (repl-loop))
      (else
       (process-input input)
       (repl-loop)))))

(define (process-input input)
  "Process a line of input from the REPL"
  (let ((tokens (tokenize input)))
    (display "Tokens: ")
    (display tokens)
    (newline)))

; ----------------------------------------------------------------------------
; File Processing
; ----------------------------------------------------------------------------

(define (run-file filename)
  "Execute a Krypto source file"
  (display "Running: ")
  (display filename)
  (newline)
  (let ((source (read-source-file filename)))
    (if source
        (let ((tokens (tokenize source)))
          (display "Tokens: ")
          (display tokens)
          (newline))
        (begin
          (display "Error: Could not read file ")
          (display filename)
          (newline)))))

(define (read-source-file filename)
  "Read the contents of a source file"
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
; Read a line from standard input
; ----------------------------------------------------------------------------

(define (read-line)
  "Read a line from standard input"
  (let loop ((chars '()))
    (let ((char (read-char)))
      (cond
        ((eof-object? char)
         (if (null? chars)
             char
             (list->string (reverse chars))))
        ((char=? char #\newline)
         (list->string (reverse chars)))
        (else
         (loop (cons char chars)))))))

; ============================================================================
; End of main.scm
; ============================================================================

