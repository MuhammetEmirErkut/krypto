; ============================================================================
; KRYPTO Programming Language - Lexer Module
; ============================================================================
;
; The lexer (tokenizer) converts source code into a stream of tokens.
; Each token represents a meaningful unit in the language:
;   - Keywords (if, else, fun, let, etc.)
;   - Identifiers (variable names, function names)
;   - Literals (numbers, strings, booleans)
;   - Operators (+, -, *, /, ==, etc.)
;   - Delimiters (parentheses, braces, semicolons)
;
; ============================================================================

; ----------------------------------------------------------------------------
; Token Types
; ----------------------------------------------------------------------------

(define *token-types*
  '(; Literals
    TOKEN-INTEGER
    TOKEN-FLOAT
    TOKEN-STRING
    TOKEN-TRUE
    TOKEN-FALSE
    
    ; Identifiers and Keywords
    TOKEN-IDENTIFIER
    TOKEN-KEYWORD
    
    ; Operators
    TOKEN-PLUS          ; +
    TOKEN-MINUS         ; -
    TOKEN-STAR          ; *
    TOKEN-SLASH         ; /
    TOKEN-PERCENT       ; %
    TOKEN-EQUALS        ; =
    TOKEN-DOUBLE-EQUALS ; ==
    TOKEN-NOT-EQUALS    ; !=
    TOKEN-LESS          ; <
    TOKEN-GREATER       ; >
    TOKEN-LESS-EQUALS   ; <=
    TOKEN-GREATER-EQUALS; >=
    TOKEN-AND           ; &&
    TOKEN-OR            ; ||
    TOKEN-NOT           ; !
    
    ; Delimiters
    TOKEN-LPAREN        ; (
    TOKEN-RPAREN        ; )
    TOKEN-LBRACE        ; {
    TOKEN-RBRACE        ; }
    TOKEN-LBRACKET      ; [
    TOKEN-RBRACKET      ; ]
    TOKEN-COMMA         ; ,
    TOKEN-DOT           ; .
    TOKEN-COLON         ; :
    TOKEN-SEMICOLON     ; ;
    TOKEN-ARROW         ; ->
    
    ; Special
    TOKEN-NEWLINE
    TOKEN-EOF
    TOKEN-ERROR))

; ----------------------------------------------------------------------------
; Keywords
; ----------------------------------------------------------------------------

(define *keywords*
  '("fun" "let" "mut" "if" "else" "while" "for" "in"
    "return" "true" "false" "null" "and" "or" "not"
    "class" "interface" "implements" "extends" "new" "this"
    "import" "export" "from" "as" "pub"
    "int" "float" "string" "bool" "void"))

(define (keyword? str)
  "Check if a string is a reserved keyword"
  (member str *keywords*))

; ----------------------------------------------------------------------------
; Character Classification
; ----------------------------------------------------------------------------

(define (char-whitespace? c)
  "Check if character is whitespace"
  (or (char=? c #\space)
      (char=? c #\tab)
      (char=? c #\return)))

(define (char-newline? c)
  "Check if character is a newline"
  (char=? c #\newline))

(define (char-digit? c)
  "Check if character is a digit"
  (and (char>=? c #\0)
       (char<=? c #\9)))

(define (char-alpha? c)
  "Check if character is alphabetic"
  (or (and (char>=? c #\a) (char<=? c #\z))
      (and (char>=? c #\A) (char<=? c #\Z))))

(define (char-alpha-numeric? c)
  "Check if character is alphanumeric"
  (or (char-alpha? c)
      (char-digit? c)))

(define (char-identifier-start? c)
  "Check if character can start an identifier"
  (or (char-alpha? c)
      (char=? c #\_)))

(define (char-identifier-part? c)
  "Check if character can be part of an identifier"
  (or (char-alpha-numeric? c)
      (char=? c #\_)))

; ----------------------------------------------------------------------------
; Token Construction
; ----------------------------------------------------------------------------

(define (make-token type value line column)
  "Create a new token with type, value, and position information"
  (list 'token type value line column))

(define (token-type tok)
  "Get the type of a token"
  (list-ref tok 1))

(define (token-value tok)
  "Get the value of a token"
  (list-ref tok 2))

(define (token-line tok)
  "Get the line number of a token"
  (list-ref tok 3))

(define (token-column tok)
  "Get the column number of a token"
  (list-ref tok 4))

; ----------------------------------------------------------------------------
; Lexer State
; ----------------------------------------------------------------------------

(define (make-lexer-state source)
  "Create initial lexer state from source string"
  (list source    ; source code
        0         ; current position
        1         ; current line
        1))       ; current column

(define (lexer-source state) (list-ref state 0))
(define (lexer-pos state) (list-ref state 1))
(define (lexer-line state) (list-ref state 2))
(define (lexer-column state) (list-ref state 3))

(define (lexer-at-end? state)
  "Check if lexer has reached end of input"
  (>= (lexer-pos state) (string-length (lexer-source state))))

(define (lexer-current-char state)
  "Get current character without advancing"
  (if (lexer-at-end? state)
      #f
      (string-ref (lexer-source state) (lexer-pos state))))

(define (lexer-peek-char state offset)
  "Peek at character at offset from current position"
  (let ((pos (+ (lexer-pos state) offset)))
    (if (>= pos (string-length (lexer-source state)))
        #f
        (string-ref (lexer-source state) pos))))

(define (lexer-advance state)
  "Advance lexer by one character, returning new state"
  (let ((char (lexer-current-char state)))
    (if (not char)
        state
        (list (lexer-source state)
              (+ 1 (lexer-pos state))
              (if (char-newline? char)
                  (+ 1 (lexer-line state))
                  (lexer-line state))
              (if (char-newline? char)
                  1
                  (+ 1 (lexer-column state)))))))

; ----------------------------------------------------------------------------
; Tokenization Functions
; ----------------------------------------------------------------------------

(define (skip-whitespace state)
  "Skip whitespace characters, returning new state"
  (if (lexer-at-end? state)
      state
      (let ((char (lexer-current-char state)))
        (if (and char (char-whitespace? char))
            (skip-whitespace (lexer-advance state))
            state))))

(define (skip-line-comment state)
  "Skip a line comment (// ...), returning new state"
  (if (lexer-at-end? state)
      state
      (let ((char (lexer-current-char state)))
        (if (and char (not (char-newline? char)))
            (skip-line-comment (lexer-advance state))
            state))))

(define (read-string state start-line start-col)
  "Read a string literal, returning (token . new-state)"
  (let ((state (lexer-advance state))) ; skip opening quote
    (let loop ((state state) (chars '()))
      (if (lexer-at-end? state)
          (cons (make-token 'TOKEN-ERROR "Unterminated string" start-line start-col)
                state)
          (let ((char (lexer-current-char state)))
            (cond
              ((char=? char #\")
               (cons (make-token 'TOKEN-STRING 
                                 (list->string (reverse chars))
                                 start-line start-col)
                     (lexer-advance state)))
              ((char=? char #\\)
               ; Handle escape sequences
               (let ((next-state (lexer-advance state)))
                 (if (lexer-at-end? next-state)
                     (cons (make-token 'TOKEN-ERROR "Unterminated escape" start-line start-col)
                           next-state)
                     (let ((escaped (lexer-current-char next-state)))
                       (loop (lexer-advance next-state)
                             (cons (case escaped
                                     ((#\n) #\newline)
                                     ((#\t) #\tab)
                                     ((#\r) #\return)
                                     ((#\\) #\\)
                                     ((#\") #\")
                                     (else escaped))
                                   chars))))))
              (else
               (loop (lexer-advance state) (cons char chars)))))))))

(define (read-number state start-line start-col)
  "Read a number literal (integer or float), returning (token . new-state)"
  (let loop ((state state) (chars '()) (has-dot #f))
    (if (lexer-at-end? state)
        (let ((num-str (list->string (reverse chars))))
          (cons (make-token (if has-dot 'TOKEN-FLOAT 'TOKEN-INTEGER)
                            num-str start-line start-col)
                state))
        (let ((char (lexer-current-char state)))
          (cond
            ((char-digit? char)
             (loop (lexer-advance state) (cons char chars) has-dot))
            ((and (char=? char #\.) (not has-dot))
             (let ((next (lexer-peek-char state 1)))
               (if (and next (char-digit? next))
                   (loop (lexer-advance state) (cons char chars) #t)
                   (let ((num-str (list->string (reverse chars))))
                     (cons (make-token 'TOKEN-INTEGER num-str start-line start-col)
                           state)))))
            (else
             (let ((num-str (list->string (reverse chars))))
               (cons (make-token (if has-dot 'TOKEN-FLOAT 'TOKEN-INTEGER)
                                 num-str start-line start-col)
                     state))))))))

(define (read-identifier state start-line start-col)
  "Read an identifier or keyword, returning (token . new-state)"
  (let loop ((state state) (chars '()))
    (if (lexer-at-end? state)
        (let ((id-str (list->string (reverse chars))))
          (cons (make-token (if (keyword? id-str) 'TOKEN-KEYWORD 'TOKEN-IDENTIFIER)
                            id-str start-line start-col)
                state))
        (let ((char (lexer-current-char state)))
          (if (char-identifier-part? char)
              (loop (lexer-advance state) (cons char chars))
              (let ((id-str (list->string (reverse chars))))
                (cons (make-token (if (keyword? id-str) 'TOKEN-KEYWORD 'TOKEN-IDENTIFIER)
                                  id-str start-line start-col)
                      state)))))))

; ----------------------------------------------------------------------------
; Main Tokenizer
; ----------------------------------------------------------------------------

(define (tokenize source)
  "Tokenize source code string into a list of tokens"
  (let loop ((state (make-lexer-state source))
             (tokens '()))
    (let ((state (skip-whitespace state)))
      (if (lexer-at-end? state)
          (reverse (cons (make-token 'TOKEN-EOF "" 
                                     (lexer-line state) 
                                     (lexer-column state))
                         tokens))
          (let* ((line (lexer-line state))
                 (col (lexer-column state))
                 (char (lexer-current-char state))
                 (result (scan-token state line col)))
            (if result
                (loop (cdr result) (cons (car result) tokens))
                (loop (lexer-advance state) tokens)))))))

(define (scan-token state line col)
  "Scan a single token, returning (token . new-state) or #f"
  (let ((char (lexer-current-char state)))
    (cond
      ; Newlines
      ((char-newline? char)
       (cons (make-token 'TOKEN-NEWLINE "\\n" line col)
             (lexer-advance state)))
      
      ; Single-character tokens
      ((char=? char #\()
       (cons (make-token 'TOKEN-LPAREN "(" line col)
             (lexer-advance state)))
      ((char=? char #\))
       (cons (make-token 'TOKEN-RPAREN ")" line col)
             (lexer-advance state)))
      ((char=? char #\{)
       (cons (make-token 'TOKEN-LBRACE "{" line col)
             (lexer-advance state)))
      ((char=? char #\})
       (cons (make-token 'TOKEN-RBRACE "}" line col)
             (lexer-advance state)))
      ((char=? char #\[)
       (cons (make-token 'TOKEN-LBRACKET "[" line col)
             (lexer-advance state)))
      ((char=? char #\])
       (cons (make-token 'TOKEN-RBRACKET "]" line col)
             (lexer-advance state)))
      ((char=? char #\,)
       (cons (make-token 'TOKEN-COMMA "," line col)
             (lexer-advance state)))
      ((char=? char #\.)
       (cons (make-token 'TOKEN-DOT "." line col)
             (lexer-advance state)))
      ((char=? char #\:)
       (cons (make-token 'TOKEN-COLON ":" line col)
             (lexer-advance state)))
      ((char=? char #\;)
       (cons (make-token 'TOKEN-SEMICOLON ";" line col)
             (lexer-advance state)))
      ((char=? char #\+)
       (cons (make-token 'TOKEN-PLUS "+" line col)
             (lexer-advance state)))
      ((char=? char #\*)
       (cons (make-token 'TOKEN-STAR "*" line col)
             (lexer-advance state)))
      ((char=? char #\%)
       (cons (make-token 'TOKEN-PERCENT "%" line col)
             (lexer-advance state)))
      
      ; Two-character tokens
      ((char=? char #\-)
       (let ((next (lexer-peek-char state 1)))
         (if (and next (char=? next #\>))
             (cons (make-token 'TOKEN-ARROW "->" line col)
                   (lexer-advance (lexer-advance state)))
             (cons (make-token 'TOKEN-MINUS "-" line col)
                   (lexer-advance state)))))
      
      ((char=? char #\=)
       (let ((next (lexer-peek-char state 1)))
         (if (and next (char=? next #\=))
             (cons (make-token 'TOKEN-DOUBLE-EQUALS "==" line col)
                   (lexer-advance (lexer-advance state)))
             (cons (make-token 'TOKEN-EQUALS "=" line col)
                   (lexer-advance state)))))
      
      ((char=? char #\!)
       (let ((next (lexer-peek-char state 1)))
         (if (and next (char=? next #\=))
             (cons (make-token 'TOKEN-NOT-EQUALS "!=" line col)
                   (lexer-advance (lexer-advance state)))
             (cons (make-token 'TOKEN-NOT "!" line col)
                   (lexer-advance state)))))
      
      ((char=? char #\<)
       (let ((next (lexer-peek-char state 1)))
         (if (and next (char=? next #\=))
             (cons (make-token 'TOKEN-LESS-EQUALS "<=" line col)
                   (lexer-advance (lexer-advance state)))
             (cons (make-token 'TOKEN-LESS "<" line col)
                   (lexer-advance state)))))
      
      ((char=? char #\>)
       (let ((next (lexer-peek-char state 1)))
         (if (and next (char=? next #\=))
             (cons (make-token 'TOKEN-GREATER-EQUALS ">=" line col)
                   (lexer-advance (lexer-advance state)))
             (cons (make-token 'TOKEN-GREATER ">" line col)
                   (lexer-advance state)))))
      
      ((char=? char #\&)
       (let ((next (lexer-peek-char state 1)))
         (if (and next (char=? next #\&))
             (cons (make-token 'TOKEN-AND "&&" line col)
                   (lexer-advance (lexer-advance state)))
             (cons (make-token 'TOKEN-ERROR "Unexpected '&'" line col)
                   (lexer-advance state)))))
      
      ((char=? char #\|)
       (let ((next (lexer-peek-char state 1)))
         (if (and next (char=? next #\|))
             (cons (make-token 'TOKEN-OR "||" line col)
                   (lexer-advance (lexer-advance state)))
             (cons (make-token 'TOKEN-ERROR "Unexpected '|'" line col)
                   (lexer-advance state)))))
      
      ; Comments
      ((char=? char #\/)
       (let ((next (lexer-peek-char state 1)))
         (if (and next (char=? next #\/))
             (let ((new-state (skip-line-comment (lexer-advance (lexer-advance state)))))
               (scan-token new-state (lexer-line new-state) (lexer-column new-state)))
             (cons (make-token 'TOKEN-SLASH "/" line col)
                   (lexer-advance state)))))
      
      ; String literals
      ((char=? char #\")
       (read-string state line col))
      
      ; Number literals
      ((char-digit? char)
       (read-number state line col))
      
      ; Identifiers and keywords
      ((char-identifier-start? char)
       (read-identifier state line col))
      
      ; Unknown character
      (else
       (cons (make-token 'TOKEN-ERROR (string char) line col)
             (lexer-advance state))))))

; ============================================================================
; End of lexer.scm
; ============================================================================

