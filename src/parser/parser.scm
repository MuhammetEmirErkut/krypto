; ============================================================================
; KRYPTO Programming Language - Parser Module
; ============================================================================
;
; Recursive descent parser that converts token stream to AST.
;
; Grammar Overview:
;
;   program        → declaration* EOF
;   declaration    → funDecl | structDecl | statement
;   
;   funDecl        → type? "fun" IDENTIFIER "(" params? ")" ("->" type)? block
;   structDecl     → "struct" IDENTIFIER "{" field* "}"
;   field          → IDENTIFIER ":" type (";" | ",")?
;   
;   statement      → letStmt | ifStmt | whileStmt | forStmt | returnStmt | block | exprStmt
;   letStmt        → "let" "mut"? IDENTIFIER (":" type)? "=" expression ";"
;   returnStmt     → "return" expression? ";"
;   ifStmt         → "if" "(" expression ")" block ("else" (ifStmt | block))?
;   whileStmt      → "while" "(" expression ")" block
;   forStmt        → "for" "(" init? ";" condition? ";" update? ")" block
;   exprStmt       → expression ";"
;   block          → "{" declaration* "}"
;   
;   type           → primitiveType | namedType | arrayType
;   primitiveType  → "int" | "float" | "string" | "bool" | "void"
;   namedType      → IDENTIFIER
;   arrayType      → "[" type "]"
;   
;   expression     → assignment
;   assignment     → IDENTIFIER "=" assignment | logicOr
;   logicOr        → logicAnd (("or" | "||") logicAnd)*
;   logicAnd       → equality (("and" | "&&") equality)*
;   equality       → comparison (("==" | "!=") comparison)*
;   comparison     → term (("<" | ">" | "<=" | ">=") term)*
;   term           → factor (("+" | "-") factor)*
;   factor         → unary (("*" | "/" | "%") unary)*
;   unary          → ("!" | "-") unary | call
;   call           → primary (("(" arguments? ")") | ("." IDENTIFIER) | ("[" expression "]"))*
;   primary        → INTEGER | FLOAT | STRING | "true" | "false" | "null" | IDENTIFIER | "(" expression ")"
;
; ============================================================================

; Note: lexer.scm and ast.scm must be loaded before this file
; When running from project root:
;   (load "src/lexer/lexer.scm")
;   (load "src/parser/ast.scm")
;   (load "src/parser/parser.scm")

; ----------------------------------------------------------------------------
; Parser State
; ----------------------------------------------------------------------------

(define (filter-newlines tokens)
  "Remove newline tokens from token list"
  (filter (lambda (tok)
            (not (eq? (token-type tok) 'TOKEN-NEWLINE)))
          tokens))

(define (make-parser-state tokens)
  "Create initial parser state from token list (newlines filtered)"
  (list (filter-newlines tokens)  ; remaining tokens (no newlines)
        0))                        ; current position

(define (parser-tokens state) (list-ref state 0))
(define (parser-pos state) (list-ref state 1))

(define (parser-at-end? state)
  "Check if parser has reached end of tokens"
  (let ((tok (parser-current state)))
    (eq? (token-type tok) 'TOKEN-EOF)))

(define (parser-current state)
  "Get current token without advancing"
  (let ((tokens (parser-tokens state))
        (pos (parser-pos state)))
    (if (>= pos (length tokens))
        (list-ref tokens (- (length tokens) 1))  ; Return last token (EOF)
        (list-ref tokens pos))))

(define (parser-previous state)
  "Get the previous token"
  (let ((tokens (parser-tokens state))
        (pos (parser-pos state)))
    (if (<= pos 0)
        (car tokens)
        (list-ref tokens (- pos 1)))))

(define (parser-advance state)
  "Advance to next token and return new state with old token"
  (if (parser-at-end? state)
      (cons (parser-current state) state)
      (let ((current (parser-current state)))
        (cons current
              (list (parser-tokens state)
                    (+ (parser-pos state) 1))))))

(define (parser-check state type)
  "Check if current token is of given type"
  (if (parser-at-end? state)
      #f
      (eq? (token-type (parser-current state)) type)))

(define (parser-check-keyword state keyword)
  "Check if current token is a specific keyword"
  (let ((tok (parser-current state)))
    (and (eq? (token-type tok) 'TOKEN-KEYWORD)
         (string=? (token-value tok) keyword))))

(define (parser-match state . types)
  "If current token matches any type, advance and return (token . new-state)"
  (let loop ((ts types))
    (if (null? ts)
        #f
        (if (parser-check state (car ts))
            (parser-advance state)
            (loop (cdr ts))))))

(define (parser-match-keyword state keyword)
  "If current token is the given keyword, advance"
  (if (parser-check-keyword state keyword)
      (parser-advance state)
      #f))

; ----------------------------------------------------------------------------
; Error Handling
; ----------------------------------------------------------------------------

(define (parse-error state message)
  "Create a parse error"
  (let ((tok (parser-current state)))
    (error 'parse-error
           (format #f "Parse error at line ~a, column ~a: ~a (got ~a)"
                   (token-line tok)
                   (token-column tok)
                   message
                   (token-type tok)))))

(define (expect state type message)
  "Consume token of expected type or throw error"
  (if (parser-check state type)
      (parser-advance state)
      (parse-error state message)))

(define (expect-keyword state keyword message)
  "Consume expected keyword or throw error"
  (if (parser-check-keyword state keyword)
      (parser-advance state)
      (parse-error state message)))

; ----------------------------------------------------------------------------
; Type Parsing
; ----------------------------------------------------------------------------

(define (parse-type state)
  "Parse a type annotation"
  (let ((tok (parser-current state)))
    (cond
      ; Primitive types
      ((and (eq? (token-type tok) 'TOKEN-KEYWORD)
            (member (token-value tok) '("int" "float" "string" "bool" "void")))
       (let ((result (parser-advance state)))
         (cons (make-primitive-type (token-value tok)
                                    (token-line tok)
                                    (token-column tok))
               (cdr result))))
      
      ; Named types (identifiers)
      ((eq? (token-type tok) 'TOKEN-IDENTIFIER)
       (let ((result (parser-advance state)))
         (cons (make-named-type (token-value tok)
                                (token-line tok)
                                (token-column tok))
               (cdr result))))
      
      ; Array types: [type]
      ((parser-check state 'TOKEN-LBRACKET)
       (let* ((result1 (parser-advance state))
              (state1 (cdr result1))
              (elem-result (parse-type state1))
              (elem-type (car elem-result))
              (state2 (cdr elem-result))
              (result3 (expect state2 'TOKEN-RBRACKET "Expected ']' after array type")))
         (cons (make-array-type elem-type
                                (token-line tok)
                                (token-column tok))
               (cdr result3))))
      
      (else
       (parse-error state "Expected type")))))

; ----------------------------------------------------------------------------
; Expression Parsing (Precedence Climbing)
; ----------------------------------------------------------------------------

;; Primary expressions: literals, identifiers, grouped expressions

(define (parse-primary state)
  "Parse primary expression"
  (let ((tok (parser-current state)))
    (cond
      ; Integer literal
      ((parser-check state 'TOKEN-INTEGER)
       (let ((result (parser-advance state)))
         (cons (make-integer-literal (string->number (token-value tok))
                                     (token-line tok)
                                     (token-column tok))
               (cdr result))))
      
      ; Float literal
      ((parser-check state 'TOKEN-FLOAT)
       (let ((result (parser-advance state)))
         (cons (make-float-literal (string->number (token-value tok))
                                   (token-line tok)
                                   (token-column tok))
               (cdr result))))
      
      ; String literal
      ((parser-check state 'TOKEN-STRING)
       (let ((result (parser-advance state)))
         (cons (make-string-literal (token-value tok)
                                    (token-line tok)
                                    (token-column tok))
               (cdr result))))
      
      ; Boolean literals
      ((parser-check-keyword state "true")
       (let ((result (parser-advance state)))
         (cons (make-bool-literal #t
                                  (token-line tok)
                                  (token-column tok))
               (cdr result))))
      
      ((parser-check-keyword state "false")
       (let ((result (parser-advance state)))
         (cons (make-bool-literal #f
                                  (token-line tok)
                                  (token-column tok))
               (cdr result))))
      
      ; Null literal
      ((parser-check-keyword state "null")
       (let ((result (parser-advance state)))
         (cons (make-null-literal (token-line tok)
                                  (token-column tok))
               (cdr result))))
      
      ; Identifier
      ((parser-check state 'TOKEN-IDENTIFIER)
       (let ((result (parser-advance state)))
         (cons (make-identifier (token-value tok)
                                (token-line tok)
                                (token-column tok))
               (cdr result))))
      
      ; Grouped expression: (expression)
      ((parser-check state 'TOKEN-LPAREN)
       (let* ((result1 (parser-advance state))
              (state1 (cdr result1))
              (expr-result (parse-expression state1))
              (expr (car expr-result))
              (state2 (cdr expr-result))
              (result3 (expect state2 'TOKEN-RPAREN "Expected ')' after expression")))
         (cons (make-group-expr expr
                                (token-line tok)
                                (token-column tok))
               (cdr result3))))
      
      (else
       (parse-error state "Expected expression")))))

;; Call and member access

(define (parse-call state)
  "Parse function calls and member access"
  (let* ((primary-result (parse-primary state))
         (expr (car primary-result))
         (state1 (cdr primary-result)))
    (parse-call-suffix expr state1)))

(define (parse-call-suffix callee state)
  "Parse call suffixes: function calls, member access, indexing"
  (cond
    ; Function call: expr(args)
    ((parser-check state 'TOKEN-LPAREN)
     (let* ((result1 (parser-advance state))
            (lparen-tok (car result1))
            (state1 (cdr result1))
            (args-result (parse-arguments state1))
            (args (car args-result))
            (state2 (cdr args-result))
            (result3 (expect state2 'TOKEN-RPAREN "Expected ')' after arguments")))
       (parse-call-suffix
        (make-call-expr callee args
                        (token-line lparen-tok)
                        (token-column lparen-tok))
        (cdr result3))))
    
    ; Member access: expr.member
    ((parser-check state 'TOKEN-DOT)
     (let* ((result1 (parser-advance state))
            (dot-tok (car result1))
            (state1 (cdr result1))
            (result2 (expect state1 'TOKEN-IDENTIFIER "Expected property name after '.'")))
       (parse-call-suffix
        (make-member-expr callee
                          (token-value (car result2))
                          (token-line dot-tok)
                          (token-column dot-tok))
        (cdr result2))))
    
    ; Index access: expr[index]
    ((parser-check state 'TOKEN-LBRACKET)
     (let* ((result1 (parser-advance state))
            (bracket-tok (car result1))
            (state1 (cdr result1))
            (index-result (parse-expression state1))
            (index-expr (car index-result))
            (state2 (cdr index-result))
            (result3 (expect state2 'TOKEN-RBRACKET "Expected ']' after index")))
       (parse-call-suffix
        (make-index-expr callee index-expr
                         (token-line bracket-tok)
                         (token-column bracket-tok))
        (cdr result3))))
    
    ; No more suffixes
    (else
     (cons callee state))))

(define (parse-arguments state)
  "Parse function call arguments"
  (if (parser-check state 'TOKEN-RPAREN)
      (cons '() state)  ; Empty arguments
      (let loop ((args '()) (state state))
        (let* ((arg-result (parse-expression state))
               (arg (car arg-result))
               (state1 (cdr arg-result))
               (new-args (append args (list arg))))
          (if (parser-check state1 'TOKEN-COMMA)
              (let ((result (parser-advance state1)))
                (loop new-args (cdr result)))
              (cons new-args state1))))))

;; Unary expressions

(define (parse-unary state)
  "Parse unary expressions: !expr, -expr"
  (let ((tok (parser-current state)))
    (cond
      ; Logical not: !expr
      ((parser-check state 'TOKEN-NOT)
       (let* ((result1 (parser-advance state))
              (state1 (cdr result1))
              (operand-result (parse-unary state1))
              (operand (car operand-result))
              (state2 (cdr operand-result)))
         (cons (make-unary-expr 'not operand
                                (token-line tok)
                                (token-column tok))
               state2)))
      
      ; Negation: -expr
      ((parser-check state 'TOKEN-MINUS)
       (let* ((result1 (parser-advance state))
              (state1 (cdr result1))
              (operand-result (parse-unary state1))
              (operand (car operand-result))
              (state2 (cdr operand-result)))
         (cons (make-unary-expr 'negate operand
                                (token-line tok)
                                (token-column tok))
               state2)))
      
      (else
       (parse-call state)))))

;; Binary expressions (factor, term, comparison, equality, logic)

(define (parse-factor state)
  "Parse factor: unary (('*' | '/' | '%') unary)*"
  (let* ((left-result (parse-unary state))
         (left (car left-result))
         (state1 (cdr left-result)))
    (let loop ((left left) (state state1))
      (let ((tok (parser-current state)))
        (cond
          ((parser-check state 'TOKEN-STAR)
           (let* ((result (parser-advance state))
                  (right-result (parse-unary (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'multiply left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          ((parser-check state 'TOKEN-SLASH)
           (let* ((result (parser-advance state))
                  (right-result (parse-unary (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'divide left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          ((parser-check state 'TOKEN-PERCENT)
           (let* ((result (parser-advance state))
                  (right-result (parse-unary (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'modulo left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          (else
           (cons left state)))))))

(define (parse-term state)
  "Parse term: factor (('+' | '-') factor)*"
  (let* ((left-result (parse-factor state))
         (left (car left-result))
         (state1 (cdr left-result)))
    (let loop ((left left) (state state1))
      (let ((tok (parser-current state)))
        (cond
          ((parser-check state 'TOKEN-PLUS)
           (let* ((result (parser-advance state))
                  (right-result (parse-factor (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'add left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          ((parser-check state 'TOKEN-MINUS)
           (let* ((result (parser-advance state))
                  (right-result (parse-factor (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'subtract left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          (else
           (cons left state)))))))

(define (parse-comparison state)
  "Parse comparison: term (('<' | '>' | '<=' | '>=') term)*"
  (let* ((left-result (parse-term state))
         (left (car left-result))
         (state1 (cdr left-result)))
    (let loop ((left left) (state state1))
      (let ((tok (parser-current state)))
        (cond
          ((parser-check state 'TOKEN-LESS)
           (let* ((result (parser-advance state))
                  (right-result (parse-term (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'less-than left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          ((parser-check state 'TOKEN-GREATER)
           (let* ((result (parser-advance state))
                  (right-result (parse-term (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'greater-than left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          ((parser-check state 'TOKEN-LESS-EQUALS)
           (let* ((result (parser-advance state))
                  (right-result (parse-term (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'less-equal left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          ((parser-check state 'TOKEN-GREATER-EQUALS)
           (let* ((result (parser-advance state))
                  (right-result (parse-term (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'greater-equal left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          (else
           (cons left state)))))))

(define (parse-equality state)
  "Parse equality: comparison (('==' | '!=') comparison)*"
  (let* ((left-result (parse-comparison state))
         (left (car left-result))
         (state1 (cdr left-result)))
    (let loop ((left left) (state state1))
      (let ((tok (parser-current state)))
        (cond
          ((parser-check state 'TOKEN-DOUBLE-EQUALS)
           (let* ((result (parser-advance state))
                  (right-result (parse-comparison (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'equal left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          ((parser-check state 'TOKEN-NOT-EQUALS)
           (let* ((result (parser-advance state))
                  (right-result (parse-comparison (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'not-equal left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          (else
           (cons left state)))))))

(define (parse-logic-and state)
  "Parse logic and: equality ('and' equality)*"
  (let* ((left-result (parse-equality state))
         (left (car left-result))
         (state1 (cdr left-result)))
    (let loop ((left left) (state state1))
      (let ((tok (parser-current state)))
        (cond
          ((or (parser-check state 'TOKEN-AND)
               (parser-check-keyword state "and"))
           (let* ((result (parser-advance state))
                  (right-result (parse-equality (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'and left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          (else
           (cons left state)))))))

(define (parse-logic-or state)
  "Parse logic or: logic-and ('or' logic-and)*"
  (let* ((left-result (parse-logic-and state))
         (left (car left-result))
         (state1 (cdr left-result)))
    (let loop ((left left) (state state1))
      (let ((tok (parser-current state)))
        (cond
          ((or (parser-check state 'TOKEN-OR)
               (parser-check-keyword state "or"))
           (let* ((result (parser-advance state))
                  (right-result (parse-logic-and (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'or left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
          
          (else
           (cons left state)))))))

;; Assignment

(define (parse-assignment state)
  "Parse assignment: (IDENTIFIER '=')? logic-or"
  (let* ((expr-result (parse-logic-or state))
         (expr (car expr-result))
         (state1 (cdr expr-result)))
    ; Check if followed by '='
    (if (parser-check state1 'TOKEN-EQUALS)
        (if (identifier? expr)
            (let* ((result (parser-advance state1))
                   (eq-tok (car result))
                   (state2 (cdr result))
                   (value-result (parse-assignment state2))
                   (value (car value-result))
                   (state3 (cdr value-result)))
              (cons (make-assign-expr expr value
                                      (token-line eq-tok)
                                      (token-column eq-tok))
                    state3))
            (parse-error state1 "Invalid assignment target"))
        (cons expr state1))))

(define (parse-expression state)
  "Parse an expression"
  (parse-assignment state))

; ----------------------------------------------------------------------------
; Statement Parsing
; ----------------------------------------------------------------------------

(define (parse-block state)
  "Parse a block: '{' declaration* '}'"
  (let ((brace-tok (parser-current state)))
    (let* ((result1 (expect state 'TOKEN-LBRACE "Expected '{'"))
           (state1 (cdr result1)))
      (let loop ((stmts '()) (state state1))
        (if (or (parser-at-end? state)
                (parser-check state 'TOKEN-RBRACE))
            (let ((result (expect state 'TOKEN-RBRACE "Expected '}'")))
              (cons (make-block-stmt (reverse stmts)
                                     (token-line brace-tok)
                                     (token-column brace-tok))
                    (cdr result)))
            (let* ((decl-result (parse-declaration state))
                   (decl (car decl-result))
                   (state2 (cdr decl-result)))
              (loop (cons decl stmts) state2)))))))

(define (parse-let-statement state)
  "Parse let statement: 'let' 'mut'? IDENTIFIER (':' type)? '=' expression"
  (let ((let-tok (parser-current state)))
    (let* ((result1 (expect-keyword state "let" "Expected 'let'"))
           (state1 (cdr result1))
           ; Check for 'mut'
           (mut-check (parser-match-keyword state1 "mut"))
           (is-mutable (if mut-check #t #f))
           (state2 (if mut-check (cdr mut-check) state1))
           ; Get identifier
           (result2 (expect state2 'TOKEN-IDENTIFIER "Expected variable name"))
           (name-tok (car result2))
           (state3 (cdr result2)))
      ; Check for type annotation
      (let* ((type-check (parser-match state3 'TOKEN-COLON))
             (type-result (if type-check
                              (parse-type (cdr type-check))
                              (cons #f state3)))
             (type-ann (car type-result))
             (state4 (cdr type-result))
             ; Expect '='
             (result3 (expect state4 'TOKEN-EQUALS "Expected '=' after variable name"))
             (state5 (cdr result3))
             ; Parse initializer
             (init-result (parse-expression state5))
             (initializer (car init-result))
             (state6 (cdr init-result))
             ; Expect semicolon
             (result4 (expect state6 'TOKEN-SEMICOLON "Expected ';' after let statement"))
             (state7 (cdr result4)))
        (cons (make-let-stmt (token-value name-tok)
                             type-ann
                             initializer
                             is-mutable
                             (token-line let-tok)
                             (token-column let-tok))
              state7)))))

(define (parse-return-statement state)
  "Parse return statement: 'return' expression? ';'"
  (let ((ret-tok (parser-current state)))
    (let* ((result1 (expect-keyword state "return" "Expected 'return'"))
           (state1 (cdr result1)))
      ; Check if there's an expression or if we're at end of statement
      (if (or (parser-check state1 'TOKEN-RBRACE)
              (parser-check state1 'TOKEN-SEMICOLON))
          (let* ((state2 (if (parser-check state1 'TOKEN-SEMICOLON)
                             (cdr (parser-advance state1))
                             state1)))
            (cons (make-return-stmt #f
                                    (token-line ret-tok)
                                    (token-column ret-tok))
                  state2))
          (let* ((expr-result (parse-expression state1))
                 (expr (car expr-result))
                 (state2 (cdr expr-result))
                 (result2 (expect state2 'TOKEN-SEMICOLON "Expected ';' after return statement"))
                 (state3 (cdr result2)))
            (cons (make-return-stmt expr
                                    (token-line ret-tok)
                                    (token-column ret-tok))
                  state3))))))

(define (parse-if-statement state)
  "Parse if statement: 'if' '(' expression ')' block ('else' (ifStmt | block))?"
  (let ((if-tok (parser-current state)))
    (let* ((result1 (expect-keyword state "if" "Expected 'if'"))
           (state1 (cdr result1))
           ; Expect '('
           (result2 (expect state1 'TOKEN-LPAREN "Expected '(' after 'if'"))
           (state2 (cdr result2))
           ; Parse condition
           (cond-result (parse-expression state2))
           (condition (car cond-result))
           (state3 (cdr cond-result))
           ; Expect ')'
           (result3 (expect state3 'TOKEN-RPAREN "Expected ')' after condition"))
           (state4 (cdr result3))
           ; Parse then branch (block)
           (then-result (parse-block state4))
           (then-branch (car then-result))
           (state5 (cdr then-result)))
      ; Check for 'else'
      (if (parser-check-keyword state5 "else")
          (let* ((result4 (parser-advance state5))
                 (state6 (cdr result4)))
            ; Check for 'else if'
            (if (parser-check-keyword state6 "if")
                (let* ((else-result (parse-if-statement state6))
                       (else-branch (car else-result))
                       (state7 (cdr else-result)))
                  (cons (make-if-stmt condition then-branch else-branch
                                      (token-line if-tok)
                                      (token-column if-tok))
                        state7))
                ; else block
                (let* ((else-result (parse-block state6))
                       (else-branch (car else-result))
                       (state7 (cdr else-result)))
                  (cons (make-if-stmt condition then-branch else-branch
                                      (token-line if-tok)
                                      (token-column if-tok))
                        state7))))
          ; No else
          (cons (make-if-stmt condition then-branch #f
                              (token-line if-tok)
                              (token-column if-tok))
                state5)))))

(define (parse-while-statement state)
  "Parse while statement: 'while' '(' expression ')' block"
  (let ((while-tok (parser-current state)))
    (let* ((result1 (expect-keyword state "while" "Expected 'while'"))
           (state1 (cdr result1))
           ; Expect '('
           (result2 (expect state1 'TOKEN-LPAREN "Expected '(' after 'while'"))
           (state2 (cdr result2))
           ; Parse condition
           (cond-result (parse-expression state2))
           (condition (car cond-result))
           (state3 (cdr cond-result))
           ; Expect ')'
           (result3 (expect state3 'TOKEN-RPAREN "Expected ')' after condition"))
           (state4 (cdr result3))
           ; Parse body
           (body-result (parse-block state4))
           (body (car body-result))
           (state5 (cdr body-result)))
      (cons (make-while-stmt condition body
                             (token-line while-tok)
                             (token-column while-tok))
            state5))))

(define (parse-for-statement state)
  "Parse for statement: 'for' '(' init? ';' condition? ';' update? ')' block"
  (let ((for-tok (parser-current state)))
    (let* ((result1 (expect-keyword state "for" "Expected 'for'"))
           (state1 (cdr result1))
           ; Expect '('
           (result2 (expect state1 'TOKEN-LPAREN "Expected '(' after 'for'"))
           (state2 (cdr result2)))
      ; Parse init (optional - can be let statement or expression or empty)
      (let* ((init-result (if (parser-check state2 'TOKEN-SEMICOLON)
                              (cons #f state2)  ; No init
                              (if (parser-check-keyword state2 "let")
                                  (parse-let-statement state2)
                                  (parse-expression state2))))
             (init (car init-result))
             (state3 (cdr init-result))
             ; Expect ';' (if not already consumed by let)
             (state4 (if (and init (let-stmt? init))
                         state3
                         (cdr (expect state3 'TOKEN-SEMICOLON "Expected ';' after for init"))))
             ; Parse condition (optional)
             (cond-result (if (parser-check state4 'TOKEN-SEMICOLON)
                              (cons #f state4)  ; No condition (infinite loop)
                              (parse-expression state4)))
             (condition (car cond-result))
             (state5 (cdr cond-result))
             ; Expect ';'
             (result4 (expect state5 'TOKEN-SEMICOLON "Expected ';' after for condition"))
             (state6 (cdr result4))
             ; Parse update (optional)
             (update-result (if (parser-check state6 'TOKEN-RPAREN)
                                (cons #f state6)  ; No update
                                (parse-expression state6)))
             (update (car update-result))
             (state7 (cdr update-result))
             ; Expect ')'
             (result5 (expect state7 'TOKEN-RPAREN "Expected ')' after for clauses"))
             (state8 (cdr result5))
             ; Parse body
             (body-result (parse-block state8))
             (body (car body-result))
             (state9 (cdr body-result)))
        (cons (make-for-stmt init condition update body
                             (token-line for-tok)
                             (token-column for-tok))
              state9)))))


(define (parse-expression-statement state)
  "Parse expression statement"
  (let* ((expr-result (parse-expression state))
         (expr (car expr-result))
         (state1 (cdr expr-result))
         (tok (parser-current state))
         ; Expect semicolon
         (result (expect state1 'TOKEN-SEMICOLON "Expected ';' after expression"))
         (state2 (cdr result)))
    (cons (make-expr-stmt expr
                          (token-line tok)
                          (token-column tok))
          state2)))

(define (parse-statement state)
  "Parse a statement"
  (cond
    ((parser-check-keyword state "let")
     (parse-let-statement state))
    ((parser-check-keyword state "return")
     (parse-return-statement state))
    ((parser-check-keyword state "if")
     (parse-if-statement state))
    ((parser-check-keyword state "while")
     (parse-while-statement state))
    ((parser-check-keyword state "for")
     (parse-for-statement state))
    ((parser-check state 'TOKEN-LBRACE)
     (parse-block state))
    (else
     (parse-expression-statement state))))


; ----------------------------------------------------------------------------
; Declaration Parsing
; ----------------------------------------------------------------------------

(define (parse-parameters state)
  "Parse function parameters: (IDENTIFIER ':' type (',' IDENTIFIER ':' type)*)"
  (if (parser-check state 'TOKEN-RPAREN)
      (cons '() state)  ; Empty parameters
      (let loop ((params '()) (state state))
        (let* ((result1 (expect state 'TOKEN-IDENTIFIER "Expected parameter name"))
               (name-tok (car result1))
               (state1 (cdr result1))
               ; Expect ':'
               (result2 (expect state1 'TOKEN-COLON "Expected ':' after parameter name"))
               (state2 (cdr result2))
               ; Parse type
               (type-result (parse-type state2))
               (param-type (car type-result))
               (state3 (cdr type-result))
               ; Create parameter
               (param (make-param (token-value name-tok)
                                  param-type
                                  (token-line name-tok)
                                  (token-column name-tok)))
               (new-params (append params (list param))))
          (if (parser-check state3 'TOKEN-COMMA)
              (let ((result (parser-advance state3)))
                (loop new-params (cdr result)))
              (cons new-params state3))))))


(define (parse-struct-fields state)
  "Parse struct fields: '{' (IDENTIFIER ':' type (',' | ';')?)* '}'"
  (let ((brace-tok (parser-current state)))
    (let* ((result1 (expect state 'TOKEN-LBRACE "Expected '{' for struct fields"))
           (state1 (cdr result1)))
      (let loop ((fields '()) (state state1))
        (if (or (parser-at-end? state)
                (parser-check state 'TOKEN-RBRACE))
            (let ((result (expect state 'TOKEN-RBRACE "Expected '}' after struct fields")))
              (cons (reverse fields) (cdr result)))
            (let* ((result2 (expect state 'TOKEN-IDENTIFIER "Expected field name"))
                   (name-tok (car result2))
                   (state2 (cdr result2))
                   ; Expect ':'
                   (result3 (expect state2 'TOKEN-COLON "Expected ':' after field name"))
                   (state3 (cdr result3))
                   ; Parse type
                   (type-result (parse-type state3))
                   (field-type (car type-result))
                   (state4 (cdr type-result))
                   ; Create field
                   (field (make-field (token-value name-tok)
                                     field-type
                                     (token-line name-tok)
                                     (token-column name-tok)))
                   (new-fields (append fields (list field)))
                   ; Optional comma or semicolon
                   (state5 (if (or (parser-check state4 'TOKEN-COMMA)
                                   (parser-check state4 'TOKEN-SEMICOLON))
                               (cdr (parser-advance state4))
                               state4)))
              (loop new-fields state5)))))))

(define (parse-struct-declaration state)
  "Parse struct declaration: 'struct' IDENTIFIER '{' fields '}'"
  (let ((struct-tok (parser-current state)))
    (let* ((result1 (expect-keyword state "struct" "Expected 'struct'"))
           (state1 (cdr result1))
           ; Get struct name
           (result2 (expect state1 'TOKEN-IDENTIFIER "Expected struct name"))
           (name-tok (car result2))
           (state2 (cdr result2))
           ; Parse fields
           (fields-result (parse-struct-fields state2))
           (fields (car fields-result))
           (state3 (cdr fields-result)))
      (cons (make-struct-decl (token-value name-tok)
                              fields
                              (token-line struct-tok)
                              (token-column struct-tok))
            state3))))




(define (parse-function-declaration state return-type)
  "Parse function declaration: type? 'fun' IDENTIFIER '(' params? ')' block"
  (let ((fun-tok (parser-current state)))
    (let* ((result1 (expect-keyword state "fun" "Expected 'fun'"))
           (state1 (cdr result1))
           ; Get function name
           (result2 (expect state1 'TOKEN-IDENTIFIER "Expected function name"))
           (name-tok (car result2))
           (state2 (cdr result2))
           ; Expect '('
           (result3 (expect state2 'TOKEN-LPAREN "Expected '(' after function name"))
           (state3 (cdr result3))
           ; Parse parameters
           (params-result (parse-parameters state3))
           (params (car params-result))
           (state4 (cdr params-result))
           ; Expect ')'
           (result4 (expect state4 'TOKEN-RPAREN "Expected ')' after parameters"))
           (state5 (cdr result4))
           
           ; Check for return type arrow (->)
           (arrow-check (parser-check state5 'TOKEN-ARROW))
           (type-res (if arrow-check
                         (let* ((res (parser-advance state5))
                                (st (cdr res)))
                           (parse-type st))
                         (cons return-type state5)))
           (parsed-ret-type (car type-res))
           (state6 (cdr type-res))

           ; Parse body
           (body-result (parse-block state6))
           (body (car body-result))
           (state7 (cdr body-result)))
      (cons (make-fun-decl (token-value name-tok)
                           params
                           parsed-ret-type
                           body
                           (token-line fun-tok)
                           (token-column fun-tok))
            state7))))

(define (is-type-keyword? tok)
  "Check if token is a type keyword"
  (and (eq? (token-type tok) 'TOKEN-KEYWORD)
       (member (token-value tok) '("int" "float" "string" "bool" "void"))))

(define (parse-declaration state)
  "Parse a declaration (function, struct, or statement)"
  (let ((tok (parser-current state)))
    (cond
      ; Struct declaration
      ((parser-check-keyword state "struct")
       (parse-struct-declaration state))
      

      ; Type followed by 'fun' -> function with return type
      ((and (or (is-type-keyword? tok)
                (eq? (token-type tok) 'TOKEN-IDENTIFIER))
            (let ((next-tok (parser-current 
                             (cdr (parser-advance state)))))
              (parser-check-keyword (cdr (parser-advance state)) "fun")))
       (let* ((type-result (parse-type state))
              (return-type (car type-result))
              (state1 (cdr type-result)))
         (parse-function-declaration state1 return-type)))
      
      ; 'fun' keyword -> function without explicit return type (void)
      ((parser-check-keyword state "fun")
       (parse-function-declaration state #f))
      
      ; Otherwise, parse as statement
      (else
       (parse-statement state)))))

; ----------------------------------------------------------------------------
; Main Parse Function
; ----------------------------------------------------------------------------

(define (parse source)
  "Parse source code and return AST"
  (let* ((tokens (tokenize source))
         (state (make-parser-state tokens)))
    (let loop ((declarations '()) (state state))
      (if (parser-at-end? state)
          (make-program (reverse declarations))
          (let* ((decl-result (parse-declaration state))
                 (decl (car decl-result))
                 (new-state (cdr decl-result)))
            (loop (cons decl declarations) new-state))))))

(define (parse-file filename)
  "Parse a file and return AST"
  (let ((source (call-with-input-file filename
                  (lambda (port)
                    (get-string-all port)))))
    (parse source)))

; ============================================================================
; End of parser.scm
; ============================================================================

