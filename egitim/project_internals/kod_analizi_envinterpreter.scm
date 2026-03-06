; ============================================================================
; KRYPTO Programming Language - Interpreter Environment
; ============================================================================
; Bu dosya interpreter'ın runtime environment'ını yönetir.
; Yani:
; - Değişkenler nerede tutuluyor? (Hashtable içinde)
; - Scope zinciri nasıl çalışıyor? (Parent pointer ile)
; - Built-in fonksiyonlar nasıl temsil ediliyor? (Özel bir struct ile)
; - User-defined fonksiyonlar nasıl saklanıyor? (Closure ile)
; ============================================================================

; ----------------------------------------------------------------------------
; Runtime Environment (Çalışma Zamanı Ortamı)
; ----------------------------------------------------------------------------

;; Environment frame yapısı:
;; (env hashtable parent-env)
;; Bu yapı şunları içerir:
;; 1. 'env etiketi (bu bir env objesidir demek için)
;; 2. değişkenleri tutan hashtable (anahtar-değer çiftleri)
;; 3. parent environment (lexical scope için üst zincir)

(define (make-env parent)
  ; Yeni bir environment (ortam) oluşturur. Parent opsiyoneldir.
  "Create a new environment frame with optional parent"
  (list 'env                                      ; 1. Eleman: Tip etiketi olarak 'env sembolü.
        (make-hashtable string-hash string=?)     ; 2. Eleman: Değişkenleri saklamak için boş bir hashtable.
                                                  ;    Anahtarlar string tipindedir (string-hash).
                                                  ;    Karşılaştırma fonksiyonu string=? dir.
        parent))                                  ; 3. Eleman: Üst scope'u (parent) gösteren referans.
  ; Bu yapı, değişkenlerin kapsamını (scope) yönetmek için kullanılır.
  ; Lexical scoping (statik kapsam) bu parent zinciriyle sağlanır.

(define (env-table env)
  ; Verilen environment nesnesinden hashtable'ı (tabloyu) çekip alır.
  (cadr env))                                     ; Listenin ikinci elemanını (cadr -> car of cdr) döndürür.

(define (env-parent env)
  ; Verilen environment nesnesinden parent (üst) environment'ı çekip alır.
  (caddr env))                                    ; Listenin üçüncü elemanını (caddr -> car of cdr of cdr) döndürür.

(define (env-get env name)
  ; Environment zincirinde bir değişkeni arar. Bulursa değerini döner, yoksa hata verir.
  "Look up a variable in the environment chain. Returns value or raises error."
  (let ((table (env-table env)))                  ; Önce mevcut env'in tablosunu al.
    (if (hashtable-contains? table name)          ; Tabloda bu isimde bir değişken var mı?
        (hashtable-ref table name #f)             ; Varsa, değerini döndür (#f table ref'in varsayılanı).
        ; Eğer mevcut scope içinde yoksa:
        (let ((parent (env-parent env)))          ; Parent environment'ı (üst scope) al.
          (if parent                              ; Eğer bir parent varsa (yani en üst seviyede değilsek):
              (env-get parent name)               ; Recursive (özyinelemeli) olarak parent içinde ara.
              ; Eğer parent yoksa (global scope'taysak ve bulamadıysak):
              (error 'env-get                     ; Hata fırlat.
                     (string-append "Undefined variable: " name))))))) ; Hata mesajı: Tanımsız değişken.

(define (env-set! env name value)
  ; Var olan bir değişkenin değerini değiştirir. Değişken tanımlı değilse hata verir.
  "Set an existing variable in the environment chain. Raises error if not found."
  (let ((table (env-table env)))                  ; Mevcut env'in tablosunu al.
    (if (hashtable-contains? table name)          ; Tabloda bu değişken var mı?
        (hashtable-set! table name value)         ; Varsa, değerini güncelle (set!).
        ; Eğer mevcut scope'da yoksa:
        (let ((parent (env-parent env)))          ; Parent environment'ı al.
          (if parent                              ; Parent var mı?
              (env-set! parent name value)        ; Varsa, parent zincirinde yukarı doğru aramaya devam et.
              ; Parent yoksa ve zincir bittiyse:
              (error 'env-set!                    ; Hata fırlat.
                     (string-append "Undefined variable: " name))))))) ; Hata mesajı.

(define (env-define! env name value)
  ; Mevcut environment içine YENİ bir değişken tanımlar.
  "Define a new variable in the current environment frame."
  (hashtable-set! (env-table env) name value))    ; Tabloya anahtar-değer çiftini ekler.
  ; Bu fonksiyon zinciri takip etmez, sadece bulunulan scope'a yazar.
  ; 'let' veya fonksiyon parametreleri gibi gölgeleme (shadowing) durumları için kullanılır.

; ----------------------------------------------------------------------------
; Built-in Function Representation (Gömülü Fonksiyon Temsili)
; ----------------------------------------------------------------------------

;; Built-in fonksiyon yapısı:
;; (builtin name arity procedure)
;; Temsil edilen yapı:
;; 1. 'builtin etiketi
;; 2. Fonksiyon adı (debugging için)
;; 3. Arity (parametre sayısı)
;; 4. Procedure (gerçek Scheme lambda fonksiyonu)

(define (make-builtin name arity proc)
  ; Yeni bir built-in fonksiyon nesnesi oluşturur.
  (list 'builtin name arity proc))                ; 4 elemanlı liste döner.

(define (builtin? val)
  ; Verilen değerin bir built-in fonksiyon olup olmadığını kontrol eder.
  (and (pair? val) (eq? (car val) 'builtin)))     ; Liste mi ve ilk elemanı 'builtin mi?

(define (builtin-name val)
  ; Built-in fonksiyonun adını döndürür.
  (cadr val))                                     ; Listenin ikinci elemanı.

(define (builtin-arity val)
  ; Built-in fonksiyonun parametre sayısını döndürür.
  (caddr val))                                    ; Listenin üçüncü elemanı.

(define (builtin-proc val)
  ; Built-in fonksiyonun asıl işlevi olan Scheme closure'ını döndürür.
  (cadddr val))                                   ; Listenin dördüncü elemanı.

; ----------------------------------------------------------------------------
; User-defined Function Representation (Kullanıcı Tanımlı Fonksiyon Temsili)
; ----------------------------------------------------------------------------

;; Kullanıcı fonksiyonu yapısı:
;; (krypto-function name params body closure-env)
;; Bu yapı şunları içerir:
;; 1. 'krypto-function etiketi
;; 2. Fonksiyon adı
;; 3. Parametre listesi (AST node listesi veya string listesi)
;; 4. Fonksiyon gövdesi (AST node listesi - body)
;; 5. Closure environment (fonksiyonun tanımlandığı andaki environment)

(define (make-krypto-function name params body closure-env)
  ; Kullanıcı tanımlı bir fonksiyon nesnesi oluşturur.
  (list 'krypto-function name params body closure-env)) ; 5 elemanlı liste.
  ; closure-env → lexical scoping için kritiktir. Fonksiyon nerede tanımlandıysa o ortamı hatırlar.

(define (krypto-function? val)
  ; Verilen değerin bir Krypto fonksiyonu olup olmadığını kontrol eder.
  (and (pair? val) (eq? (car val) 'krypto-function))) ; Etiket kontrolü.

(define (krypto-function-name val)
  ; Fonksiyonun adını döndürür.
  (cadr val))

(define (krypto-function-params val)
  ; Fonksiyonun parametrelerini döndürür.
  (caddr val))

(define (krypto-function-body val)
  ; Fonksiyonun gövdesini (body) döndürür.
  (cadddr val))

(define (krypto-function-env val)
  ; Fonksiyonun closure environment'ını döndürür.
  (car (cddddr val)))                             ; Listenin beşinci elemanını alır.

; ----------------------------------------------------------------------------
; Return Signal (Dönüş Sinyali)
; ----------------------------------------------------------------------------
; Fonksiyonlardan 'return' ile çıkıldığında, bu özel sinyal yukarı fırlatılır.
; Normal değerlerden ayırt edilebilmesi için özel bir etiket kullanılır.

(define *return-tag* (list 'return-signal))       ; Unique (benzersiz) bir cons hücresi oluşturur.

(define (make-return-signal value)
  ; Return edilecek değeri paketleyen bir sinyal oluşturur.
  (cons *return-tag* value))                      ; (etag . value) çifti döner.

(define (return-signal? val)
  ; Verilen değerin bir return sinyali olup olmadığını kontrol eder.
  (and (pair? val) (eq? (car val) *return-tag*))) ; Etiket aynı mı? Pointer eşitliği (eq?) kullanılır.

(define (return-signal-value val)
  ; Return sinyalinin içindeki asıl değeri çıkarıp alır.
  (cdr val))                                      ; Paketlenmiş değeri döndürür.

; ----------------------------------------------------------------------------
; Krypto Null (Özel Null Değeri)
; ----------------------------------------------------------------------------
; Scheme'in kendi 'null (boş liste) değeri ile karışmaması için,
; Krypto diline özel bir null sabiti tanımlıyoruz.

(define *krypto-null* (list 'krypto-null))        ; Unique bir liste.

(define (krypto-null? val)
  ; Verilen değerin Krypto null olup olmadığını kontrol eder.
  (and (pair? val) (eq? (car val) 'krypto-null))) ; Etiket kontrolü.

; ----------------------------------------------------------------------------
; Global Environment (Global Çevre)
; ----------------------------------------------------------------------------

(define (make-global-env)
  ; Global environment'ı ve temel built-in fonksiyonları oluşturur.
  "Create the global environment with built-in functions"
  (let ((env (make-env #f)))                      ; Parent'ı #f (yok) olan bir env oluştur (en üst seviye).
    ; En üst environment, parent yok.

    ;; --- Built-in: print ---
    (env-define! env "print"                      ; "print" adında bir fonksiyon tanımla.
      (make-builtin "print" 1                     ; Arity: 1 parametre alır.
        (lambda (args)                            ; Çağrıldığında çalışacak kod.
          (let ((val (car args)))                 ; İlk argümanı al.
            (cond
              ((krypto-null? val) (display "null")); Eğer null ise "null" yaz.
              ((boolean? val)                     ; Eğer boolean ise:
               (display (if val "true" "false"))) ; "true" veya "false" yaz.
              (else (display val)))               ; Diğer durumlarda değeri olduğu gibi yaz.
            (newline)                             ; Alt satıra geç.
            *krypto-null*))))                     ; Fonksiyon null döndürür.
    ; print → ekrana yazdırır ve null döner.

    ;; --- Built-in: input ---
    (env-define! env "input"                      ; "input" adında bir fonksiyon tanımla.
      (make-builtin "input" 0                     ; Arity: 0 parametre alır.
        (lambda (args)                            ; Çağrıldığında çalışacak kod.
          (let loop ((chars '()))                 ; Karakterleri toplamak için loop kur.
            (let ((c (read-char)))                ; Bir karakter oku.
              (cond
                ((eof-object? c)                  ; Dosya sonu (EOF) geldi mi?
                 (if (null? chars)                ; Hiç karakter okumadıysak
                     ""                           ; Boş string dön.
                     (list->string (reverse chars)))); Veya okunanları string yap dön.
                ((char=? c #\newline)             ; Yeni satır karakteri mi?
                 (list->string (reverse chars)))  ; Okunanları string yap dön (input bitti).
                (else
                 (loop (cons c chars)))))))))     ; Diğer karakterler için listeye ekle ve devam et.
    ; input → stdin'den satır okur.

    env))                                         ; Oluşturulan environment'ı döndür.

; ============================================================================
; KRYPTO Programming Language - Interpreter (AST Walker)
; ============================================================================
; Bu dosya AST'yi yürüyerek (tree-walking) programı çalıştırır.
; Her node tipine göre dispatch (yönlendirme) yapar ve değer üretir.
; ============================================================================

; ----------------------------------------------------------------------------
; Main Entry Point (Ana Giriş Noktası)
; ----------------------------------------------------------------------------

(define (interpret ast)
  ; Programın çalıştırıldığı ana giriş noktası. AST'yi alır ve çalıştırır.
  ; AST: Abstract Syntax Tree (Soyut Sözdizimi Ağacı).

  (let ((env (make-global-env)))                  ; Global environment oluşturulur.
                                                  ; Built-in fonksiyonlar burada kayıtlıdır.

    ;; ------------------------------------------------------------
    ;; 1. PASS — Top-level fonksiyonları kaydet (Function Hoisting)
    ;; ------------------------------------------------------------
    ;; Amaç: Fonksiyonlar tanımlanmadan önce çağrılabilsin.
    ;; (Forward declaration desteği sağlanır).

    (let ((decls (ast-get ast 'declarations)))    ; AST'den deklarasyon listesini al.
      (for-each                                   ; Her bir deklarasyon için döngü:
        (lambda (decl)
          (when (fun-decl? decl)                  ; Eğer bu bir fonksiyon tanımı ise:
            (let* ((name (ast-get decl 'name))    ; Fonksiyon adını al.
                   (params
                     (map (lambda (p)
                            (ast-get p 'name))    ; Parametre isimlerini al.
                          (ast-get decl 'params))); (Parametre objelerinden isimleri çıkar).
                   (body (ast-get decl 'body))    ; Fonksiyon gövdesini (blok) al.
                   (func
                     (make-krypto-function        ; Krypto fonksiyon objesini oluştur.
                       name params body env)))    ; Closure env olarak global env verilir.
              (env-define! env name func))))      ; Bu fonksiyonu global scope'a kaydet.
        decls)

      ;; ------------------------------------------------------------
      ;; 2. PASS — Tüm deklarasyonları evaluate et (Çalıştır)
      ;; ------------------------------------------------------------
      (for-each                                   ; Deklarasyonları sırayla çalıştır.
        (lambda (decl)
          (eval-node decl env))                   ; Her bir node'u evaluate et.
        decls))

    ;; ------------------------------------------------------------
    ;; Eğer main fonksiyonu varsa otomatik çağır
    ;; ------------------------------------------------------------
    (let ((table (env-table env)))                ; Global değişken tablosu.
      (when (hashtable-contains? table "main")    ; "main" diye bir şey var mı?
        (let ((main-fn (hashtable-ref table "main" #f))) ; "main" değerini al.
          (when (krypto-function? main-fn)        ; Eğer bu bir fonksiyon ise:
            (call-function main-fn '() env))))))) ; "main" fonksiyonunu parametresiz çalıştır.

; ----------------------------------------------------------------------------
; Node Dispatcher (Düğüm Yönlendirici)
; ----------------------------------------------------------------------------

(define (eval-node node env)
  ; AST node tipine göre ilgili evaluator (değerlendirici) çağrılır.
  ; Bu fonksiyon interpreter'ın kalbidir.

  (if (not node)                                  ; Node yoksa (null pointer gibi):
      *krypto-null*                               ; Krypto null değeri dön.
      (cond

        ;; --------------------------------------------------------
        ;; Literals (Sabit Değerler)
        ;; --------------------------------------------------------

        ((integer-literal? node)                  ; Tam sayı sabiti mi?
         (ast-get node 'value))                   ; Değeri doğrudan döndür.

        ((float-literal? node)                    ; Ondalıklı sayı sabiti mi?
         (ast-get node 'value))                   ; Değeri doğrudan döndür.

        ((string-literal? node)                   ; Metin sabiti mi?
         (ast-get node 'value))                   ; Değeri doğrudan döndür.

        ((bool-literal? node)                     ; Mantıksal sabit mi?
         (ast-get node 'value))                   ; Değeri doğrudan döndür.

        ((null-literal? node)                     ; Null sabiti mi?
         *krypto-null*)                           ; Krypto null değerini döndür.

        ;; --------------------------------------------------------
        ;; Expressions (İfadeler)
        ;; --------------------------------------------------------

        ((identifier? node)                       ; Değişken adı (identifier) mı?
         (eval-identifier node env))              ; Değerini environment'tan bul.

        ((binary-expr? node)                      ; İkili işlem (binary: a + b) mi?
         (eval-binary node env))                  ; İşlemi yap.

        ((unary-expr? node)                       ; Tekli işlem (unary: !a, -a) mi?
         (eval-unary node env))                   ; İşlemi yap.

        ((group-expr? node)                       ; Gruplama (parantez içi ifade) mi?
         (eval-node (ast-get node 'expression) env))
         ; Parantez içindeki ifadeyi evaluate et ve sonucunu dön.

        ((call-expr? node)                        ; Fonksiyon çağrısı mı?
         (eval-call node env))                    ; Çağrıyı gerçekleştir.

        ((assign-expr? node)                      ; Atama işlemi (a = 5) mi?
         (eval-assign node env))                  ; Atamayı yap.

        ((member-expr? node)                      ; Üye erişimi (obj.field) mi?
         (eval-member node env))                  ; (Şu an placeholder - Henüz implemente değil).

        ((index-expr? node)                       ; Dizi erişimi (arr[i]) mi?
         (eval-index node env))                   ; (Şu an placeholder - Henüz implemente değil).

        ;; --------------------------------------------------------
        ;; Statements (Deyimler)
        ;; --------------------------------------------------------

        ((expr-stmt? node)                        ; İfade deyimi (expression statement) mi?
         (eval-expr-stmt node env))               ; İfadeyi çalıştır (yan etkileri için).

        ((let-stmt? node)                         ; Değişken tanımlama (let) mı?
         (eval-let node env))                     ; Değişkeni tanımla.

        ((if-stmt? node)                          ; Koşul deyimi (if) mi?
         (eval-if node env))                      ; Koşula göre dallan.

        ((while-stmt? node)                       ; Döngü (while) mi?
         (eval-while node env))                   ; Döngüyü çalıştır.

        ((for-stmt? node)                         ; For döngüsü mü?
         (eval-for node env))                     ; For döngüsünü çalıştır.

        ((return-stmt? node)                      ; Geri dönüş (return) mu?
         (eval-return node env))                  ; Fonksiyondan çıkış sinyali üret.

        ((block-stmt? node)                       ; Blok ({ ... }) mu?
         (eval-block node env))                   ; Bloğu yeni bir scope içinde çalıştır.

        ;; --------------------------------------------------------
        ;; Declarations (Tanımlamalar)
        ;; --------------------------------------------------------

        ((fun-decl? node)                         ; Fonksiyon tanımı mı?
         (eval-fun-decl node env))                ; Fonksiyonu işle (Pass 1'de yapıldığı için burası boş olabilir).

        ((class-decl? node)                       ; Sınıf (class) tanımı mı?
         (eval-class-decl node env))              ; Sınıfı tanımla.

        ((program? node)                          ; Programın kendisi mi?
         (eval-program node env))                 ; Programı çalıştır.

        (else                                     ; Bilinmeyen node tipi.
         *krypto-null*))))                        ; Güvenli çıkış için null dön.

; ----------------------------------------------------------------------------
; Identifier (Değişken Erişimi)
; ----------------------------------------------------------------------------

(define (eval-identifier node env)
  ; Değişken lookup (arama) işlemi.
  (env-get env (ast-get node 'name)))             ; Environment'tan ismi sorgula ve değeri döndür.

; ----------------------------------------------------------------------------
; Binary Expression (İkili İşlemler)
; ----------------------------------------------------------------------------

(define (eval-binary node env)
  ; İkili işlemleri (toplama, çıkarma, vb.) değerlendirir.

  (let ((op (ast-get node 'operator))             ; Operatörü al (örn: 'add, 'subtract).
        (left (eval-node (ast-get node 'left) env)); Sol tarafı evaluate et.
        (right (eval-node (ast-get node 'right) env))); Sağ tarafı evaluate et.

    (case op                                      ; Operatöre göre işlem seç:

      ((add)                                      ; Toplama (+) işlemi:
       ; Krypto'da + hem sayısal toplama hem de string birleştirme yapar.
       (cond
         ((and (number? left) (number? right))    ; İkisi de sayı ise:
          (+ left right))                         ; Sayısal toplama yap.
         ((and (string? left) (string? right))    ; İkisi de string ise:
          (string-append left right))             ; String birleştirme yap.
         (else                                    ; Uyumsuz tipler:
          (error 'eval-binary                     ; Hata ver.
                 "Cannot add these types"))))

      ((subtract)                                 ; Çıkarma (-) işlemi:
       (- left right))                            ; Sayısal çıkarma.

      ((multiply)                                 ; Çarpma (*) işlemi:
       (* left right))                            ; Sayısal çarpma.

      ((divide)                                   ; Bölme (/) işlemi:
       (if (zero? right)                          ; Bölen sıfır mı?
           (error 'eval-binary "Division by zero"); Sıfıra bölme hatası.
           (/ left right)))                       ; Sayısal bölme.

      ((equal)                                    ; Eşitlik (==) kontrolü:
       (krypto-equal? left right))                ; Özel eşitlik fonksiyonunu çağır.

      ((not-equal)                                ; Eşitsizlik (!=) kontrolü:
       (not (krypto-equal? left right)))          ; Eşit değilse true dön.

      ((and-op)                                   ; Mantıksal VE (&&) işlemi:
       ; Truthy mantığı kullanılır (nil/false dışındaki her şey true).
       (and (truthy? left)                        ; Sol taraf doğru mu?
            (truthy? right)))                     ; VE sağ taraf doğru mu?

      ((or-op)                                    ; Mantıksal VEYA (||) işlemi:
       (or (truthy? left)                         ; Sol taraf doğru mu?
           (truthy? right)))                      ; VEYA sağ taraf doğru mu?

      (else                                       ; Tanınmayan operatör:
       (error 'eval-binary                        ; Hata ver.
              "Unknown operator")))))

; ----------------------------------------------------------------------------
; Unary Expression (Tekli İşlemler)
; ----------------------------------------------------------------------------

(define (eval-unary node env)
  ; Tekli operatörleri değerlendirir (örn: -5, !true).

  (let ((op (ast-get node 'operator))             ; Operatörü al.
        (operand                                  ; İşlem yapılacak değeri al (evaluate et).
          (eval-node (ast-get node 'operand) env)))

    (case op                                      ; Operatöre göre işlem seç:
      ((negate) (- operand))                      ; Negatifleme (-) işlemi.
      ((not-op) (not (truthy? operand)))          ; Mantıksal değil (!) işlemi. Truthy kontrolü ile.
      (else
       (error 'eval-unary                         ; Bilinmeyen operatör hatası.
              "Unknown unary operator")))))

; ----------------------------------------------------------------------------
; Function Call (Fonksiyon Çağrısı)
; ----------------------------------------------------------------------------

(define (eval-call node env)
  ; Fonksiyon çağrılarını yönetir.

  (let* ((callee                                  ; Çağrılan şeyi evaluate et (fonksiyonun kendisi).
           (eval-node (ast-get node 'callee) env))
         (args                                    ; Argümanları listele ve her birini evaluate et.
           (map (lambda (a)
                  (eval-node a env))
                (ast-get node 'arguments))))

    (cond
      ((builtin? callee)                          ; Eğer built-in fonksiyon ise:
       ; built-in fonksiyonu direkt çalıştır.
       ((builtin-proc callee) args))              ; (proc args) şeklinde çağır.

      ((krypto-function? callee)                  ; Eğer kullanıcı tanımlı fonksiyon ise:
       ; user-defined fonksiyonu özel mekanizma ile çağır.
       (call-function callee args env))

      (else                                       ; Fonksiyon değilse:
       (error 'eval-call                          ; Hata ver.
              "Attempting to call a non-function")))))

; ----------------------------------------------------------------------------
; Assignment (Atama İşlemi)
; ----------------------------------------------------------------------------

(define (eval-assign node env)
  ; Değişken atamasını gerçekleştirir (örn: x = 10).

  (let ((value                                    ; Atanacak değeri hesapla (RHS).
          (eval-node (ast-get node 'value) env))
        (target                                   ; Atama yapılacak hedefi al (LHS).
          (ast-get node 'target)))

    (cond
      ((identifier? target)                       ; Hedef bir değişken adı mı?
       (env-set! env                              ; Environment'ta güncelle.
                 (ast-get target 'name)           ; Değişken adı.
                 value)                           ; Yeni değer.
       value)                                     ; Atama ifadesi atanan değeri döndürür.

      (else                                       ; Geçersiz atama hedefi (örn: 5 = x).
       (error 'eval-assign                        ; Hata ver.
              "Invalid assignment target")))))

; ----------------------------------------------------------------------------
; Return Statement (Geri Dönüş)
; ----------------------------------------------------------------------------

(define (eval-return node env)
  ; Fonksiyondan çıkışı sağlar.

  (let ((val (ast-get node 'value)))              ; Return değerini al.
    (make-return-signal                           ; Return sinyali paketle.
      (if val                                     ; Eğer bir ifade varsa:
          (eval-node val env)                     ; Evaluate et.
          *krypto-null*))))                       ; Yoksa (boş return), null döndür.

; ----------------------------------------------------------------------------
; Block Statement (Blok ve Scope)
; ----------------------------------------------------------------------------

(define (eval-block node env)
  ; Blok ({ ... }) çalıştırır. Yeni bir scope oluşturur.

  (let ((block-env
          (make-env env)))                        ; Yeni bir lexical scope oluştur (parent = mevcut env).

    (let loop ((stmts                             ; Blok içindeki statementları al.
                 (ast-get node 'statements)))

      (if (null? stmts)                           ; Statement kalmadıysa:
          *krypto-null*                           ; Null dön (boş blok).
          (let ((result                           ; Sıradaki statement'ı evaluate et.
                  (eval-node
                    (car stmts)
                    block-env)))                  ; Yeni oluşturulan block-env içinde çalıştır.
            (if (return-signal? result)           ; Eğer sonuç bir return sinyali ise:
                result                            ; Sinyali yukarı propagate et (return işlemi).
                (loop (cdr stmts))))))))          ; Değilse sonraki statement'a geç.

; ----------------------------------------------------------------------------
; Function Call Engine (Fonksiyon Çağrı Motoru)
; ----------------------------------------------------------------------------

(define (call-function func args caller-env)
  ; Kullanıcı tanımlı fonksiyonu çalıştırır.

  (let* ((params
           (krypto-function-params func))         ; Fonksiyonun parametre isimleri.
         (body
           (krypto-function-body func))           ; Fonksiyonun gövdesi.
         (closure-env
           (krypto-function-env func))            ; Closure environment (tanımlandığı yer).
         (call-env
           (make-env closure-env)))               ; **DİKKAT**: Yeni environment closure-env'den türer,
                                                  ; caller-env'den değil! (Lexical Scoping kuralı).

    ;; Parametre binding (Değişken bağlama)
    (let loop ((ps params)                        ; Parametre listesi.
               (as args))                         ; Argüman (değer) listesi.
      (cond
        ((and (null? ps) (null? as))              ; İkisi de bittiyse tamam.
         #t)
        ((null? ps)                               ; Parametre bitti ama argüman kaldıysa:
         (error 'call-function                    ; Hata: Çok fazla argüman.
                "Too many arguments"))
        ((null? as)                               ; Argüman bitti ama parametre kaldıysa:
         (error 'call-function                    ; Hata: Eksik argüman.
                "Too few arguments"))
        (else                                     ; Eşleşme var:
         (env-define! call-env                    ; Fonksiyon scope'una değişkeni tanımla.
                      (car ps)                    ; Parametre adı.
                      (car as))                   ; Gelen değer.
         (loop (cdr ps)                           ; Sonraki parametreye geç.
               (cdr as)))))

    ;; Body execute edilir (Fonksiyon gövdesini çalıştır)
    (let ((result
            (eval-node body call-env)))           ; Body'yi fonksiyon scope'unda çalıştır.

      (if (return-signal? result)                 ; Eğer return sinyali döndüyse:
          (return-signal-value result)            ; Sinyali aç ve asıl değeri döndür.
          *krypto-null*))))                       ; Return yoksa (fonksiyon sonuna kadar çalıştıysa) null dön.
