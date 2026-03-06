# Krypto: `ornek.kp` Derleme Sürecinin Detaylı Çalışma İzi (Execution Trace)

Bu rapor, `ornek.kp` programının derlenme aşamasında **kesin olarak çalışan kod bloklarını**, IDE entegrasyonundan başlayarak derleyici mimarisindeki ardışık akışı adım adım listeler.

## 0. IDE Üzerinden Başlatma (Entry Point: "Run" Butonu)
Krypto Studio IDE'sinde (Python) sağ üstteki `▶ Run` butonuna basıldığında `ide.py` içindeki çalışma hattı (*pipeline*) eşzamanlı bir thread olarak tetiklenir.

**İlgili Açık Kaynak Kodu: (`ide.py`)**
IDE, mevcut açık belgeyi diske kaydeder ve sırasıyla Chez Scheme derleyicisini, Java assembler'ı ve JVM Runtime'ı çağırır: 

```python
    def pipeline_worker(self):
        target_file = self.extract_file_for_compilation() # 1. Dosya kaydedilir
        self.log_console("Starting Application Pipeline...", clear=True)

        build_dir = os.path.join(self.project_dir, "build")
        os.makedirs(build_dir, exist_ok=True)

        # 2. Scheme Derleyicisini Çağır:
        cmd_compile = f"chez --script src/main.scm build {target_file}"
        code = self.run_command_in_console(cmd_compile, "Step 1/3: Compiling to Jasmin Assembly (chez)")
        
        # Üretilen JVM kodunu taşı
        src_j = os.path.join(self.project_dir, "Main.j")
        dst_j = os.path.join(build_dir, "Main.j")
        if os.path.exists(src_j):
            shutil.move(src_j, dst_j)

        # 3. Java Jasmin Assembler'ı Çağır:
        jasmin_path = os.path.join(self.project_dir, "toolchain", "jasmin.jar")
        cmd_assemble = f"java -jar {jasmin_path} -d {build_dir} {dst_j}"
        code = self.run_command_in_console(cmd_assemble, "Step 2/3: Assembling to JVM Bytecode (jasmin)")
        
        # 4. Java Bytecode (Main.class) Dosyasını JVM'de Çalıştır:
        cmd_run = f"java -cp {build_dir} Main"
        code = self.run_command_in_console(cmd_run, "Step 3/3: Executing on JVM (java Main)")
```
Buradaki kritik komut olan `chez --script src/main.scm build ornek.kp` ile akış Python'dan çıkıp Krypto Derleyicisine, yani Lisp dünyasına devredilir.

`src/main.scm` kodunda `build-file` fonksiyonu tetiklenir ve kaynak kod sırasıyla lexer, parser ve semantic analize sokulur:
```scheme
(define (build-file filename)
  ...
  (let ((source (read-source-file filename)))
    (if source ...
           (let ((tokens (tokenize source))) ; -> Lexer tetikleniyor
             (let ((ast (parse source)))     ; -> Parser tetikleniyor
               ...
               (if (analyze ast)             ; -> Semantic tetiği!
                   (begin
                     (generate-program ast "Main.j") ; -> Jasmin Code Gen
                     ... )))))))
```

---

## 1. Kaynak Kodumuz (`examplos/ornek.kp`)
```krypto
int fun topla_ve_kare_al(a: int, b: int) {
    let toplam: int = a + b;
    return toplam * toplam;
}

fun main() {
    let sonuc: int = topla_ve_kare_al(3, 4);
    print(sonuc);
}
```

---

## 2. Lexer (Sözcük Analizi) Aşaması

İlk olarak `src/lexer/lexer.scm` içindeki `(tokenize source)` fonksiyonu çağrılır. Kod baştan sona karakter karakter okunur.

### 2.1 Boşlukların Atlanması ve Ana Döngü
Karakterleri okurken boşluklar `skip-whitespace` fonksiyonu ile atlanır:
```scheme
(define (skip-whitespace state)
  "Skip whitespace characters, returning new state"
  (if (lexer-at-end? state)
      state
      (let ((char (lexer-current-char state)))
        (if (and char (char-whitespace? char))
            (skip-whitespace (lexer-advance state))
            state))))
```

### 2.2 Anahtar Kelimeler ve Değişken İsimleri (`int`, `fun`, `topla_ve_kare_al`, `let`)
Karakter bir harf ile başlıyorsa (`char-identifier-start?`) sistem `read-identifier` fonksiyonunu çağırır. `int` ve `fun` okunduğunda tablodan bunların keyword olduğu, `topla_ve_kare_al`'ın ise identifier olduğu anlaşılır:
```scheme
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
```

### 2.3 Sayıların Okunması (`3` ve `4`)
`topla_ve_kare_al(3, 4)` satırına gelindiğinde, karakterler `3` ve `4` rakam olduğundan `read-number` tetiklenir:
```scheme
(define (read-number state start-line start-col)
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
            ... (noktalı sayı kontrolleri) ...
            (else
             (let ((num-str (list->string (reverse chars))))
               (cons (make-token (if has-dot 'TOKEN-FLOAT 'TOKEN-INTEGER)
                                 num-str start-line start-col)
                     state))))))))
```

### 2.4 Operatörler ve Noktalama İşaretleri
`scan-token` ana fonksiyonunda karakter eşleştirmesi yapılır. `(`, `)`, `{`, `+`, `*`, `:` gibi karakterler yakalanır ve tekli tokenlar oluşturulur.
```scheme
(define (scan-token state line col)
  (let ((char (lexer-current-char state)))
    (cond
      ((char=? char #\() (cons (make-token 'TOKEN-LPAREN "(" line col) (lexer-advance state)))
      ((char=? char #\+) (cons (make-token 'TOKEN-PLUS "+" line col) (lexer-advance state)))
      ((char=? char #\*) (cons (make-token 'TOKEN-STAR "*" line col) (lexer-advance state)))
      ...
```

---

## 3. Parser (Sentaks Analizi ve AST Üretimi)

Parser (`src/parser/parser.scm`), okunan linear token dizisini hiyerarşik AST yapısına dönüştürür. 

### 3.1 Gelişmiş Atama İfadeleri (`let toplam: int = a + b;`)
Parser `let` kelimesini gördüğünde doğrudan `parse-let-statement` fonksiyonunu çağırır. Değişken adını bekler, varsa tip deklarasyonunu (iki nokta üst üste `: int`) okur ve eşittir (`=`) işaretinden sonra sağ taraftaki ifadeyi (`parse-expression` ile) çözer.

```scheme
(define (parse-let-statement state)
  (let ((let-tok (parser-current state)))
    (let* ((result1 (expect-keyword state "let" "Expected 'let'"))
           (state1 (cdr result1))
           ...
           (result2 (expect state2 'TOKEN-IDENTIFIER "Expected variable name"))
           (name-tok (car result2)) ...
           (type-result (if type-check (parse-type (cdr type-check)) ...))
           ...
           (result3 (expect state4 'TOKEN-EQUALS "Expected '=' after variable name"))
           (init-result (parse-expression state5)) ; Sağ tarafı çözümle (a + b)
           (initializer (car init-result)) ...)
        (cons (make-let-stmt (token-value name-tok)
                             type-ann
                             initializer
                             is-mutable
                             ...)
              state7))))
```

### 3.2 İfadelerin İşlenmesi (Matematik: `a + b` ve `toplam * toplam`)
Matematiksel işlemlerde Krypto, öncelik tırmanması (precedence climbing) algoritması kullanır. Çarpma öncelikli olduğu için `parse-factor`, toplama ise `parse-term` içerisinde işlenir.

**Toplama (`a + b`) İçin Çalışan Kod:**
```scheme
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
                  (right-result (parse-factor (cdr result))) ; b değişkenini alır
                  (right (car right-result)))
             (loop (make-binary-expr 'add left right ; add AST node üretilir
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
             ...
```

**Çarpma (`toplam * toplam`) İçin Çalışan Kod:**
```scheme
(define (parse-factor state)
  "Parse factor: unary (('*' | '/' | '%') unary)*"
  (let* ((left-result (parse-unary state))
...
          ((parser-check state 'TOKEN-STAR)
           (let* ((result (parser-advance state))
                  (right-result (parse-unary (cdr result)))
                  (right (car right-result)))
             (loop (make-binary-expr 'multiply left right
                                     (token-line tok)
                                     (token-column tok))
                   (cdr right-result))))
...
```

---

## 4. Semantik Analiz (Tip Denetimi ve Scope'lar)

AST oluştuktan sonra `src/semantic/analyzer.scm` mantıksal doğruluk testi yapar. Değişkenlerin tipleri kontrol edilir.

### 4.1 Fonksiyon Çözümleme (`analyze-function`)
`topla_ve_kare_al` fonksiyonunun analizi tetiklendiğinde parametreler sembol tablosuna kaydedilir ve iç kapsam (scope) açılır:
```scheme
(define (analyze-function node env)
    (let* ((name (ast-get node 'name)) ...
           (params (ast-get node 'params))
           (ret-type (if ret-ast (resolve-type-annotation ret-ast env) (make-type-void))))
        ... 
        (let ((fun-type (make-type-function param-types ret-type)))
          (define-symbol-safe env name fun-type 'function loc)) ; globale fonksiyon kaydedilir
        
        (env-enter-scope env) ; yeni fonksiyon kapsamı açılır
        
        (define-symbol-safe env "%return-type%" ret-type 'internal loc)
        (for-each (lambda (p t)
                    (define-symbol-safe env (ast-get p 'name) t 'parameter ...))
                  params param-types) ; 'a' ve 'b' parametre olarak kaydedilir
        ...
        (env-exit-scope env)
```

### 4.2 Atamaların Tip Kontrolü (`analyze-let`)
`let toplam: int = a + b;` satırına gelindiğinde sağdaki işlemin sol taraftaki `int` deklarasyonuyla aynı olup olmadığı teyit edilir:
```scheme
(define (analyze-let node env)
    (let ((name (ast-get node 'name)) ...
          (declared-type (if mod-ast (resolve-type-annotation mod-ast env) #f))
          (init-type (if init (analyze-node init env) #f))) ; (a+b) ifadesi int döner
        
        (let ((final-type 
               (cond
                 ((and declared-type init-type)
                  (expect-type init-type declared-type loc) ; İkisi de 'int' olduğu için sorun çıkmaz
                  declared-type))))
          
          (define-symbol-safe env name final-type 'variable loc) ; "toplam" sembol tablosuna eklenir
          (make-type-void))))
```

---

## 5. Jasmin Kodu Üretimi (Code Generation)

Java bytecode assembly'sine dönüşüm `src/codegen/jasmin.scm` içerisindedir. Stack mimarisi doğrultusunda işlemler LIFO (Last-In-First-Out) prensibiyle bytecodelara dökülür.

### 5.1 Yerel Değişkenlerin Yönetimi (`let` çevirisi)
`let sonuc: int = topla_ve_kare_al(3, 4);` kısmı derlenirken lokal indeks atanır ve değer saklanır (`istore`).
```scheme
    ((let-stmt? stmt)
     (let* ((name (ast-get stmt 'name))
            (init (ast-get stmt 'initializer))
            (t (infer-type init)))
       (generate-expr port init) ; Fonksiyon çağrısı bytecode'unu üret (3 ve 4 ile invoke)
       ...
       (let ((idx (hashtable-ref *local-vars* name #f)))
         (if (not idx)
             (begin
               (set! idx *next-local*) ; Yeni bir index al (JVM locals için)
               (hashtable-set! *local-vars* name idx)
               (set! *next-local* (+ *next-local* 1))))
         (case t
           ((float) (emit port "    fstore " idx))
           (else (emit port "    istore " idx))))))) ; int olduğu için istore 0 komutu üretilir.
```

### 5.2 Matematiksel İfadelerin Çevirisi (`a+b` ve `toplam*toplam`)
AST'deki binary-expr yapıları post-order şeklinde çözülerek JVM komutlarına (iadd, imul) çevrilir:
```scheme
    ((binary-expr? expr)
     (let* ((op (ast-get expr 'operator))
            (left (ast-get expr 'left))
            (right (ast-get expr 'right))
            (t (infer-type left)))
       (generate-expr port left)  ; Sol değeri hesaba kat (stack'e at) -> iload 0
       (generate-expr port right) ; Sağ değeri hesaba kat (stack'e at) -> iload 1
       (case op
         ((add)       (if (eq? t 'float) (emit port "    fadd") (emit port "    iadd"))) ; int olduğu için iadd
         ((multiply)  (if (eq? t 'float) (emit port "    fmul") (emit port "    imul"))) ; int olduğu için imul
         ...)))
```

### 5.3 Fonksiyon Çağrıları (Call Expressions)
`topla_ve_kare_al(3, 4)` ve `print(sonuc)` çağrıldığında sistem `invokestatic` veya Java yerleşik sınıf metotları için `invokevirtual` kullanır. `print`, Krypto için native System.out.println çağrısına çevrilir:
```scheme
    ((call-expr? expr)
     (let* ((callee (ast-get expr 'callee))
            (name (if (identifier? callee) (ast-get callee 'name) #f)))
       (if (and name (string=? name "print"))
           (begin
             (emit port "    getstatic java/lang/System/out Ljava/io/PrintStream;")
             (let* ((arg (car (ast-get expr 'arguments)))
                    (t (infer-type arg)))
               (generate-expr port arg) ; 'sonuc' değerini stack'e koy -> iload 0
               (let ((desc (if (eq? t 'string) "Ljava/lang/String;" (type->jasmin t))))
                 (emit port "    invokevirtual java/io/PrintStream/println(" desc ")V")))) ; JVM print çağrısı
           (if name ... (invoke-static işlemlerine girer) ... ))))
```

---

## Sonuç: 
Yukarıda işleyen scheme metotları silsilesi sonucunda aşağıdaki spesifik JVM kodları (`Main_ornek.j`) başarıyla inşa edilir ve JVM (`java`) üzerinden çalıştırıldırılarak ekrana `49` sonucu verdirilir.

```jasmin
.method public static topla_ve_kare_al(II)I
    .limit stack 100
    .limit locals 100
    iload 0    ; (generate-expr: identifier 'a')
    iload 1    ; (generate-expr: identifier 'b')
    iadd       ; (generate-expr: binary-expr operator addition)
    istore 2   ; (generate-stmt: let-stmt 'toplam')
    iload 2    ; (generate-expr: identifier 'toplam')
    iload 2    ; (generate-expr: identifier 'toplam')
    imul       ; (generate-expr: binary-expr operator multiply)
    ireturn    ; (generate-stmt: return-stmt)
.end method
```
Bu detaylı akış, projenizi modüler tutarak aşama aşama veri bütünlüğünün S-Expression dillerinde nasıl korunduğunun en önemli göstergesidir.
