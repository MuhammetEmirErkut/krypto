; ============================================================================
; KRYPTO Programming Language - Jasmin Code Generator
; ============================================================================


; Global states and counters used during code generation
(define *global-vars* #f)         ; Hash table for storing global variables
(define *global-funcs-ret* #f)    ; Hash table for storing global function return types
(define *global-funcs-args* #f)   ; Hash table for storing global function argument types
(define *local-vars* #f)          ; Hash table mapping local variable names to JVM local indices
(define *local-types* #f)         ; Hash table mapping local variable names to their types
(define *next-local* 0)           ; Counter for tracking the next available JVM local variable index
(define *label-counter* 0)        ; Counter for generating unique jump labels

; Generates and returns a new unique jump label for JVM control flow (e.g., L1, L2)
(define (next-label)
  (set! *label-counter* (+ *label-counter* 1))
  (string-append "L" (number->string *label-counter*)))

; Emits (writes out) a line of Jasmin assembly code to both the output file (port) and standard output
(define (emit port . args)
  (for-each (lambda (arg) 
              (display arg port)  ; Write to file
              (display arg))      ; Write to console for debugging
            args)
  (newline port)
  (newline))

; Maps a compiler internal type symbol (int, float, etc.) to JVM jasmin type descriptor (I, F, etc.)
(define (type->jasmin t)
  (case t
    ((int) "I")         ; Integer
    ((float) "F")       ; Float
    ((bool) "I")        ; Boolean represented as Integer in JVM
    ((string) "Ljava/lang/String;") ; Java String class
    ((void) "V")))      ; Void return type

; Helper function to resolve the string name wrapper of a primitive type AST node into a proper type symbol
(define (ast-type->sym type-node)
  (if (not type-node) 'void
      (let ((t (ast-type type-node)))
        (if (eq? t 'primitive-type)
            (string->symbol (ast-get type-node 'name))
            'void))))

; Infers the resulting type of an expression by examining the AST node recursively
(define (infer-type expr)
  (if (not expr) 'void
      (cond
        ((integer-literal? expr) 'int)
        ((float-literal? expr) 'float)
        ((string-literal? expr) 'string)
        ((bool-literal? expr) 'bool)
        ((identifier? expr)
         (let ((name (ast-get expr 'name)))
           (or (hashtable-ref *local-types* name #f)
               (hashtable-ref *global-vars* name #f)
               'int)))
        ((binary-expr? expr)
         (let ((op (ast-get expr 'operator)))
           (case op
             ((less-than greater-than less-equal greater-equal equal not-equal) 'bool)
             (else (infer-type (ast-get expr 'left))))))
        ((unary-expr? expr)
         (infer-type (ast-get expr 'operand)))
        ((call-expr? expr)
         (let* ((callee (ast-get expr 'callee))
                (name (if (identifier? callee) (ast-get callee 'name) "")))
           (hashtable-ref *global-funcs-ret* name 'void)))
        ((assign-expr? expr)
         (infer-type (ast-get expr 'target)))
        (else 'void))))

; Generates the Jasmin bytecode logic for a given expression and pushes its result onto the operand stack
(define (generate-expr port expr)
  
  (cond
    ((integer-literal? expr)
     (emit port "    ldc " (ast-get expr 'value)))
    ((float-literal? expr)
     (emit port "    ldc " (ast-get expr 'value)))
    ((string-literal? expr)
     (emit port "    ldc \"" (ast-get expr 'value) "\""))
    ((bool-literal? expr)
     (emit port "    " (if (ast-get expr 'value) "iconst_1" "iconst_0")))
    
    ((identifier? expr)
     (let ((name (ast-get expr 'name)))
       (let ((idx (hashtable-ref *local-vars* name #f)))
         (if idx
             (let ((t (hashtable-ref *local-types* name 'int)))
               (case t
                 ((float) (emit port "    fload " idx))
                 ((string) (emit port "    aload " idx))
                 (else (emit port "    iload " idx))))
             (let ((t (hashtable-ref *global-vars* name 'int)))
               (emit port "    getstatic Main/" name " " (type->jasmin t)))))))
               
    ((unary-expr? expr)
     (let ((op (ast-get expr 'operator))
           (operand (ast-get expr 'operand)))
       (let ((t (infer-type operand)))
         (generate-expr port operand)
         (case op
           ((minus)
            (if (eq? t 'float) (emit port "    fneg") (emit port "    ineg")))
           ((not)
            ; logical NOT: if 0 then 1 else 0
            (let ((l-true (next-label))
                  (l-end (next-label)))
              (emit port "    ifeq " l-true)
              (emit port "    iconst_0")
              (emit port "    goto " l-end)
              (emit port l-true ":")
              (emit port "    iconst_1")
              (emit port l-end ":")))))))
    
    ((binary-expr? expr)
     (let* ((op (ast-get expr 'operator))
            (left (ast-get expr 'left))
            (right (ast-get expr 'right))
            (t (infer-type left)))
       (generate-expr port left)
       (generate-expr port right)
       (case op
         ((add)       (if (eq? t 'float) (emit port "    fadd") (emit port "    iadd")))
         ((subtract)  (if (eq? t 'float) (emit port "    fsub") (emit port "    isub")))
         ((multiply)  (if (eq? t 'float) (emit port "    fmul") (emit port "    imul")))
         ((divide)    (if (eq? t 'float) (emit port "    fdiv") (emit port "    idiv")))
         ((and)       (emit port "    iand"))
         ((or)        (emit port "    ior"))
         ((less-than greater-than less-equal greater-equal equal not-equal)
          (let ((l-true (next-label))
                (l-end (next-label)))
             (if (eq? t 'float)
                 (begin
                   (emit port "    fcmpg")
                   (emit port "    iconst_0")
                   (case op
                     ((less-than) (emit port "    if_icmplt " l-true))
                     ((greater-than) (emit port "    if_icmpgt " l-true))
                     ((less-equal) (emit port "    if_icmple " l-true))
                     ((greater-equal) (emit port "    if_icmpge " l-true))
                     ((equal) (emit port "    if_icmpeq " l-true))
                     ((not-equal) (emit port "    if_icmpne " l-true))))
                 (begin
                   (case op
                     ((less-than) (emit port "    if_icmplt " l-true))
                     ((greater-than) (emit port "    if_icmpgt " l-true))
                     ((less-equal) (emit port "    if_icmple " l-true))
                     ((greater-equal) (emit port "    if_icmpge " l-true))
                     ((equal) (emit port "    if_icmpeq " l-true))
                     ((not-equal) (emit port "    if_icmpne " l-true)))))
             (emit port "    iconst_0")
             (emit port "    goto " l-end)
             (emit port l-true ":")
             (emit port "    iconst_1")
             (emit port l-end ":"))))))
             
    ((call-expr? expr)
     (let* ((callee (ast-get expr 'callee))
            (name (if (identifier? callee) (ast-get callee 'name) #f)))
       (if (and name (string=? name "print"))
           (begin
             ; Print logic maps natively to Java's System.out.println
             (emit port "    getstatic java/lang/System/out Ljava/io/PrintStream;")
             (let* ((arg (car (ast-get expr 'arguments)))
                    (t (infer-type arg)))
               (generate-expr port arg) ; evaluate and push argument onto stack
               (let ((desc (if (eq? t 'string) "Ljava/lang/String;" (type->jasmin t))))
                 ; Call the println method using the appropriate type descriptor
                 (emit port "    invokevirtual java/io/PrintStream/println(" desc ")V"))))
           (if name
               (let ((ret-sym (hashtable-ref *global-funcs-ret* name #f)))
                 (if ret-sym
                     (begin
                       (for-each (lambda (arg) (generate-expr port arg)) (ast-get expr 'arguments))
                       (let* ((ret-t (type->jasmin ret-sym))
                              (arg-types (hashtable-ref *global-funcs-args* name '()))
                              (arg-desc (apply string-append (map type->jasmin arg-types))))
                         (emit port "    invokestatic Main/" name "(" arg-desc ")" ret-t)))
                     (begin
                       (display "  [Error] Function not found: " )(display name)(newline)
                       (emit port "    aconst_null"))))
               (begin
                 (display "  [Error] Invalid call structure." )(newline)
                 (emit port "    aconst_null"))))))
               
    ((assign-expr? expr)
     (let* ((target (ast-get expr 'target))
            (name (ast-get target 'name))
            (val (ast-get expr 'value))
            (t (infer-type val)))
       (generate-expr port val)
       (emit port "    dup")
       (let ((idx (hashtable-ref *local-vars* name #f)))
         (if idx
             (case t
               ((float) (emit port "    fstore " idx))
               ((string) (emit port "    astore " idx))
               (else (emit port "    istore " idx)))
             (begin
               (emit port "    putstatic Main/" name " " (type->jasmin t)))))))
    ))

; Generates Jasmin bytecode instructions for statement nodes (if, while, for, variable declarations)
(define (generate-stmt port stmt)
  
  (cond
    ((expr-stmt? stmt)
     (let* ((expr (ast-get stmt 'expression))
            (t (infer-type expr)))
       (generate-expr port expr)
       (if (and (not (eq? t 'void)))
           (emit port "    pop"))))
           
    ((let-stmt? stmt)
     (let* ((name (ast-get stmt 'name))
            (init (ast-get stmt 'initializer))
            (t (infer-type init)))
       (generate-expr port init)
       (let ((is-global (hashtable-contains? *global-vars* name)))
         (if is-global
             (emit port "    putstatic Main/" name " " (type->jasmin t))
             (let ((idx (hashtable-ref *local-vars* name #f)))
               (if (not idx)
                   (begin
                     (set! idx *next-local*)
                     (hashtable-set! *local-vars* name idx)
                     (set! *next-local* (+ *next-local* 1))))
               (hashtable-set! *local-types* name t)
               (case t
                 ((float) (emit port "    fstore " idx))
                 ((string) (emit port "    astore " idx))
                 (else (emit port "    istore " idx))))))))
                   
    ((if-stmt? stmt)
     (let ((cond-expr (ast-get stmt 'condition))
           (then-b (ast-get stmt 'then-branch))
           (else-b (ast-get stmt 'else-branch))
           (l-else (next-label))
           (l-end (next-label)))
       (generate-expr port cond-expr)
       (emit port "    ifeq " l-else)
       (generate-stmt port then-b)
       (emit port "    goto " l-end)
       (emit port l-else ":")
       (if else-b (generate-stmt port else-b))
       (emit port l-end ":")))
       
    ((while-stmt? stmt)
     (let ((cond-expr (ast-get stmt 'condition))
           (body (ast-get stmt 'body))
           (l-start (next-label))
           (l-end (next-label)))
       (emit port l-start ":")
       (generate-expr port cond-expr)
       (emit port "    ifeq " l-end)
       (generate-stmt port body)
       (emit port "    goto " l-start)
       (emit port l-end ":")))
       
    ((for-stmt? stmt)
     (let ((init (ast-get stmt 'init))
           (cond-expr (ast-get stmt 'condition))
           (update (ast-get stmt 'update))
           (body (ast-get stmt 'body))
           (l-start (next-label))
           (l-end (next-label)))
       (if init (generate-stmt port init))
       (emit port l-start ":")
       (if cond-expr
           (begin
             (generate-expr port cond-expr)
             (emit port "    ifeq " l-end)))
       (generate-stmt port body)
       (if update (generate-stmt port (make-expr-stmt update 0 0)))
       (emit port "    goto " l-start)
       (emit port l-end ":")))
       
    ((return-stmt? stmt)
     (let ((val (ast-get stmt 'value)))
       (if val
           (let ((t (infer-type val)))
             (generate-expr port val)
             (case t
               ((float) (emit port "    freturn"))
               ((string) (emit port "    areturn"))
               ((void) (emit port "    return"))
               (else (emit port "    ireturn"))))
           (emit port "    return"))))
           
    ((block-stmt? stmt)
     (for-each (lambda (s) (generate-stmt port s))
               (ast-get stmt 'statements)))
               
    (else (display "Unknown stmt: " port)(display (ast-type stmt) port)(newline port))))

; Generates the method block for a function declaration including parameter mappings and body statements
(define (generate-function port decl)
  (let ((name (ast-get decl 'name))
        (params (ast-get decl 'params))
        (ret-node (ast-get decl 'return-type))
        (body (ast-get decl 'body)))
    (let ((ret-t (ast-type->sym ret-node)))
      
      (set! *local-vars* (make-hashtable string-hash string=?))
      (set! *local-types* (make-hashtable string-hash string=?))
      (set! *next-local* 0)
      (let ((arg-desc ""))
        (for-each (lambda (p)
                    (let ((pname (ast-get p 'name))
                          (ptype (ast-type->sym (ast-get p 'type))))
                      (if pname
                          (begin
                            (hashtable-set! *local-vars* pname *next-local*)
                            (hashtable-set! *local-types* pname ptype)
                            (set! *next-local* (+ *next-local* 1))
                            (set! arg-desc (string-append arg-desc (type->jasmin ptype)))))))
                  params)
                  
        (emit port "")
        (emit port ".method public static " name "(" arg-desc ")" (type->jasmin ret-t))
        (emit port "    .limit stack 100")
        (emit port "    .limit locals 100")
        
        (if body (generate-stmt port body))
        
        (if (eq? ret-t 'void)
            (emit port "    return"))
            
        (emit port ".end method")))))

; The main entry point. Traverses the global AST tree and constructs the full .class file structure (Jasmin format)
(define (generate-program ast out-file)
  (let ((port (open-output-file out-file 'replace))) ; Open the output .j file
    (set! *label-counter* 0)
    (set! *global-vars* (make-hashtable string-hash string=?))
    (set! *global-funcs-ret* (make-hashtable string-hash string=?))
    (set! *global-funcs-args* (make-hashtable string-hash string=?))
    
    (let ((decls (ast-get ast 'declarations)))
      (for-each (lambda (decl)
                  (cond
                    ((let-stmt? decl)
                     (let ((name (ast-get decl 'name))
                           (init (ast-get decl 'initializer)))
                       (if name
                             (let ((t (infer-type init)))
                               (hashtable-set! *global-vars* name t)))))
                    ((fun-decl? decl)
                     (let ((name (ast-get decl 'name))
                           (params (ast-get decl 'params))
                           (ret (ast-get decl 'return-type)))
                       (if name
                           (begin 
                             (hashtable-set! *global-funcs-ret* name (ast-type->sym ret))
                             (hashtable-set! *global-funcs-args* name 
                                             (map (lambda (p) (ast-type->sym (ast-get p 'type))) params))))))))
                decls)
                
      (emit port ".class public Main")
      (emit port ".super java/lang/Object")
      (emit port "")
      
      (let-values (((keys values) (hashtable-entries *global-vars*)))
        (let ((len (vector-length keys)))
          (do ((i 0 (+ i 1)))
              ((= i len))
            (emit port ".field public static " (vector-ref keys i) " " (type->jasmin (vector-ref values i))))))
            
      (emit port "")
      (emit port ".method public <init>()V")
      (emit port "    aload_0")
      (emit port "    invokenonvirtual java/lang/Object/<init>()V")
      (emit port "    return")
      (emit port ".end method")
      
      (for-each (lambda (decl)
                  (if (fun-decl? decl)
                      (generate-function port decl)))
                decls)
                
      (emit port "")
      (emit port ".method public static main([Ljava/lang/String;)V")
      (emit port "    .limit stack 100")
      (emit port "    .limit locals 100")
      
      (set! *local-vars* (make-hashtable string-hash string=?))
      (set! *local-types* (make-hashtable string-hash string=?))
      (set! *next-local* 1)
      

                
      (for-each (lambda (decl)
                  (if (not (or (fun-decl? decl) (struct-decl? decl)))
                      (generate-stmt port decl)))
                decls)
                
      (let ((main-ret (hashtable-ref *global-funcs-ret* "main" #f)))
        (if main-ret
            (emit port "    invokestatic Main/main()V")))
                
      (emit port "    return")
      (emit port ".end method"))
    (close-output-port port)))
