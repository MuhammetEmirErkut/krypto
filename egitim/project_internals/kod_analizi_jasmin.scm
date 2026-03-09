; ============================================================================
; KRYPTO PROJESİ - DETAYLI KOD ANALİZİ: JASMIN CODEGEN (src/codegen/jasmin.scm)
; ============================================================================
;
; Bu dosya, Krypto dilinin Bytecode Üretici (Code Generator) modülünün
; 'Annotated' (Notlandırılmış) versiyonudur.
; Parser ve Semantic Analyzer'dan geçen Soyut Sözdizim Ağacı (AST),
; bu aşamada Jasmin assembly formatında JVM komutlarına dönüştürülür.
;
; ============================================================================

; ----------------------------------------------------------------------------
; BÖLÜM 1: GLOBAL STATE VE YARDIMCI FONKSİYONLAR
; ----------------------------------------------------------------------------
; Bytecode üretirken, JVM'nin değişkenleri (local variables) nasıl sakladığını
; bilmemiz gerekir. Java/JVM'de yerel değişkenler sayılarla tutulur (0, 1, 2...).

; Global referansları saklamak için hash tabloları
(define *global-vars* #f)         ; Global değişkenlerin tiplerini saklar
(define *global-funcs-ret* #f)    ; Fonksiyonların dönüş tiplerini saklar
(define *global-funcs-args* #f)   ; Fonksiyonların aldığı parametre tiplerini saklar

; Yerel scope referansları (Her fonksiyon için sıfırlanır)
(define *local-vars* #f)          ; "a" -> 0, "b" -> 1 gibi isim/indeks eşlemesi
(define *local-types* #f)         ; Değişkenin tipini tutar ("toplam" -> 'int)
(define *next-local* 0)           ; Sırada verilecek boş local indeks numarası
(define *label-counter* 0)        ; If/While döngüleri için jump etiket sayacı (L1, L2 vb.)

; Yeni bir atlama (goto) etiketi üretir: L1, L2, L3...
(define (next-label)
  (set! *label-counter* (+ *label-counter* 1))
  (string-append "L" (number->string *label-counter*)))

; Üretilen Jasmin kodunu dosyaya (.j) yazan temel fonksiyon
(define (emit port . args)
  (for-each (lambda (arg) 
              (display arg port)  ; Dosyaya yazdırır
              (display arg))      ; Konsola yazdırır (Debug amaçlı)
            args)
  (newline port)
  (newline))

; Krypto içindeki veri tiplerini JVM içindeki karakter kısaltmalarına çevirir
; JVM'de bytecodelar tiplere göre değişir (iadd, fadd vb.)
(define (type->jasmin t)
  (case t
    ((int) "I")         ; Integer
    ((float) "F")       ; Float
    ((bool) "I")        ; JVM, Boolean değerleri Integer (0 ve 1) olarak tutar
    ((string) "Ljava/lang/String;") ; Referans tipi olduğu için sınıfın tam yolu
    ((void) "V")))      ; Hiçbir şey dönmeyen fonksiyonlar (Void)

; Güvenlik kontrolü ile AST üzerinden tip ismini alır
(define (ast-type->sym type-node)
  (if (not type-node) 'void
      (let ((t (ast-type type-node)))
        (if (eq? t 'primitive-type)
            (string->symbol (ast-get type-node 'name))
            'void))))

; ----------------------------------------------------------------------------
; BÖLÜM 2: TİP ÇIKARIMI (TYPE INFERENCE)
; ----------------------------------------------------------------------------
; Bu fonksiyon sembolik işlemlerin sonucunun hangi tip çıkacağını tahmin eder.
; Neden? Çünkü JVM'de tam sayı toplarken 'iadd', ondalıklı sayı toplarken 'fadd' demeliyiz.

(define (infer-type expr)
  (if (not expr) 'void
      (cond
        ((integer-literal? expr) 'int) ; 3 -> int
        ((float-literal? expr) 'float) ; 3.14 -> float
        ((string-literal? expr) 'string)
        ((bool-literal? expr) 'bool)
        ((identifier? expr)
         (let ((name (ast-get expr 'name)))
           ; Değişken adını tablolarda ara, localde yoksa globale bak
           (or (hashtable-ref *local-types* name #f)
               (hashtable-ref *global-vars* name #f)
               'int)))
        ((binary-expr? expr)
         ; Karşılaştırma işlemleri her zaman boolean döner (<, >, !=)
         (let ((op (ast-get expr 'operator)))
           (case op
             ((less-than greater-than less-equal greater-equal equal not-equal) 'bool)
             (else (infer-type (ast-get expr 'left)))))) ; Toplama çarpma ise sol tarafın tipi çıkar
        ((unary-expr? expr) (infer-type (ast-get expr 'operand)))
        ((call-expr? expr)
         ; Fonksiyon çağrısının sonucu o fonksiyonun tablodaki dönüt (return) değeridir
         (let* ((callee (ast-get expr 'callee))
                (name (if (identifier? callee) (ast-get callee 'name) "")))
           (hashtable-ref *global-funcs-ret* name 'void)))
        ((assign-expr? expr) (infer-type (ast-get expr 'target)))
        (else 'void))))

; ----------------------------------------------------------------------------
; BÖLÜM 3: İFADELERİN KOD ÜRETİMİ (GENERATE EXPR)
; ----------------------------------------------------------------------------
; JVM stack (yığın) mimarisine sahiptir. 'generate-expr' bir ifadeyi hesaplatıp, 
; sonucunu stack'in en tepesine koymak (push) için gerekli komutları üretir.

(define (generate-expr port expr)
  (cond
    ; Sabitleri Stack'e koy: ldc (load constant)
    ((integer-literal? expr)
     (emit port "    ldc " (ast-get expr 'value)))
    ((float-literal? expr)
     (emit port "    ldc " (ast-get expr 'value)))
    ((string-literal? expr)
     (emit port "    ldc \"" (ast-get expr 'value) "\""))
    ((bool-literal? expr)
     (emit port "    " (if (ast-get expr 'value) "iconst_1" "iconst_0"))) ; stack = 1 veya 0
    
    ; Değişken Çağırma (Identifier) -> Değeri yükleyip (load) stack'e at
    ((identifier? expr)
     (let ((name (ast-get expr 'name)))
       (let ((idx (hashtable-ref *local-vars* name #f)))
         (if idx
             ; Değişken LOCAL ise: Tipi neyse uygun `load` komutunu yaz (iload, fload)
             (let ((t (hashtable-ref *local-types* name 'int)))
               (case t
                 ((float) (emit port "    fload " idx))
                 ((string) (emit port "    aload " idx)) ; 'a' -> address/reference
                 (else (emit port "    iload " idx))))
             ; Değişken GLOBAL ise: Class içindeki global field'ı getir
             (let ((t (hashtable-ref *global-vars* name 'int)))
               (emit port "    getstatic Main/" name " " (type->jasmin t)))))))
               
    ; İkili Matematik İşlemleri (Binary Expr)
    ((binary-expr? expr)
     (let* ((op (ast-get expr 'operator))
            (left (ast-get expr 'left))
            (right (ast-get expr 'right))
            (t (infer-type left))) ; Sol değerin tipini bul, (float mu int mi?)
            
       ; 1. Sol değeri hesaba yatır ve stack'e fırlat   
       (generate-expr port left)
       
       ; 2. Sağ değeri hesaba yatır ve stack'e fırlat
       (generate-expr port right)
       
       ; 3. JVM stack'in üstündeki iki sayıyı alıp tiplere göre operatörü çalıştırır
       (case op
         ((add)       (if (eq? t 'float) (emit port "    fadd") (emit port "    iadd")))
         ((multiply)  (if (eq? t 'float) (emit port "    fmul") (emit port "    imul")))
         ((divide)    (if (eq? t 'float) (emit port "    fdiv") (emit port "    idiv")))
         ((and)       (emit port "    iand"))
         
         ; Karşılaştırma işlemleri JVM'de direkt komut olarak değil 'if' atlamaları ile yapılır
         ((less-than greater-than equal)
          (let ((l-true (next-label))
                (l-end (next-label)))
             ;; Örn: 'if_icmplt L1' (Küçükse L1'e zıpla) komutları üretilir.
             (if (eq? t 'float) (begin ... (emit port "    fcmpg") ... )
                 (begin
                   (case op
                     ((less-than) (emit port "    if_icmplt " l-true))
                     ((great-than) (emit port "    if_icmpgt " l-true)) ...)))
             ; Şart sağlanmıyorsa 0 döndürüp bitiriyoruz
             (emit port "    iconst_0") 
             (emit port "    goto " l-end)
             (emit port l-true ":")
             ; Zıpladıysa şart doğrudur, stack'e 1 iteriz
             (emit port "    iconst_1") 
             (emit port l-end ":"))))))
             
    ; Fonksiyon Çağrıları (Call Expressions)
    ((call-expr? expr)
     (let* ((callee (ast-get expr 'callee))
            (name (if (identifier? callee) (ast-get callee 'name) #f)))
       (if (and name (string=? name "print"))
           ; Krypto'nun 'print' komutu aslen Java'nın 'System.out.println' komutuyla maplenir.
           (begin
             (emit port "    getstatic java/lang/System/out Ljava/io/PrintStream;")
             (let* ((arg (car (ast-get expr 'arguments)))
                    (t (infer-type arg)))
               (generate-expr port arg) ; Stack'e yazdırmak istenen argümanı doldur
               (let ((desc (if (eq? t 'string) "Ljava/lang/String;" (type->jasmin t))))
                 (emit port "    invokevirtual java/io/PrintStream/println(" desc ")V"))))
           
           ; Özel Fonksiyon Çağrısıysa (invokestatic metodu oluştur)
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
                       (emit port "    aconst_null"))))...)))

; ----------------------------------------------------------------------------
; BÖLÜM 4: STATEMENT (YAPISAL DÜĞÜM) ÜRETİMİ (GENERATE STMT)
; ----------------------------------------------------------------------------
; Değişken Atamaları (let), Kontrol Blokları (If/While) gibi stack'i modifiye etmeyen 
; ancak bellek (local vars) değiştiren yapısal durumlara bakar.

(define (generate-stmt port stmt)
  (cond
    ; Let İfadesi: (let x: int = 5)
    ((let-stmt? stmt)
     (let* ((name (ast-get stmt 'name))
            (init (ast-get stmt 'initializer))
            (t (infer-type init)))
       (generate-expr port init) ; Sağ taraftaki 5'i (veya a+b'yi) stack'e yaz
       
       (let ((is-global (hashtable-contains? *global-vars* name)))
         (if is-global
             (emit port "    putstatic Main/" name " " (type->jasmin t)) ; Global ise Class'ta sakla
             (let ((idx (hashtable-ref *local-vars* name #f)))
               (if (not idx) ; O isimde bir indeks atılmamış ise ver. (Yeni indeks kaydı a=0, b=1 vs.)
                   (begin
                     (set! idx *next-local*)
                     (hashtable-set! *local-vars* name idx)
                     (set! *next-local* (+ *next-local* 1))))
               (hashtable-set! *local-types* name t)
               ; Tipine göre stack'ten çek ve memory 'istore' ile lokale kaydet
               (case t
                 ((float) (emit port "    fstore " idx))
                 ((string) (emit port "    astore " idx))
                 (else (emit port "    istore " idx))))))))
                 
    ; If Koşulu: if (x == 5) ...
    ((if-stmt? stmt)
     (let ((cond-expr (ast-get stmt 'condition))
           (then-b (ast-get stmt 'then-branch))
           (else-b (ast-get stmt 'else-branch))
           (l-else (next-label)) ; Else kısmının adresi etiketi L1
           (l-end (next-label))) ; Son çıkış adresi etiketi L2
           
       (generate-expr port cond-expr) ; Şartı stack'e atar (1 veya 0)
       (emit port "    ifeq " l-else) ; Stack 1 değilse (yani 0'sa == equal_false), koşul bitimine zıpla (l-else)
       (generate-stmt port then-b)    ; Kodlar normal çalışır
       (emit port "    goto " l-end)  ; then kısmı biterse, tümünden zıplaıp çık
       (emit port l-else ":")         ; ELSE ETİKETİ: 
       (if else-b (generate-stmt port else-b))
       (emit port l-end ":")))        ; ÇIKIŞ ETİKETİ
       
    ; Return İfadesi: return 42; 
    ((return-stmt? stmt)
     (let ((val (ast-get stmt 'value)))
       (if val
           (let ((t (infer-type val)))
             (generate-expr port val) ; Dönüş değerini stack'in tepesine at
             (case t
               ((float) (emit port "    freturn"))
               ((string) (emit port "    areturn"))
               ((void) (emit port "    return"))
               (else (emit port "    ireturn")))) ; Pop-Return
           (emit port "    return"))))
...))

; ----------------------------------------------------------------------------
; BÖLÜM 5: FONKSİYON VE PROGRAM ÇIKTISI (MAIN ROUTINE)
; ----------------------------------------------------------------------------

; Metot Üreticisi
(define (generate-function port decl)
  (let ((name (ast-get decl 'name))
        (params (ast-get decl 'params))
        (ret-node (ast-get decl 'return-type))
        (body (ast-get decl 'body)))
    (let ((ret-t (ast-type->sym ret-node)))
      
      ; HER YENİ FONKSİYON, KENDİ SCOPE'UNA SAHİPTİR - Local sayacı 0'lanır
      (set! *local-vars* (make-hashtable string-hash string=?))
      (set! *local-types* (make-hashtable string-hash string=?))
      (set! *next-local* 0)
      
      (let ((arg-desc ""))
        ; Parametreleri sırayla tabloya 0, 1, 2 şeklinde geçiririz
        (for-each (lambda (p) ...) params)
                  
        (emit port "")  ; Bytecode Başlığı
        (emit port ".method public static " name "(" arg-desc ")" (type->jasmin ret-t))
        (emit port "    .limit stack 100")
        (emit port "    .limit locals 100")
        
        (if body (generate-stmt port body)) ; Gövdeyi bytecode'da derle işlemi
        
        (if (eq? ret-t 'void)
            (emit port "    return"))
            
        (emit port ".end method")))))

; Ana Çalıştırma Çatısı - Java Sınıfını Başlatır
(define (generate-program ast out-file)
  (let ((port (open-output-file out-file 'replace)))
    ; Header ve Import kısımları
    (emit port ".class public Main")
    (emit port ".super java/lang/Object")
    ...
    ; Java class default boş constructor (.init) yaratımı
    (emit port ".method public <init>()V")
    ...
    ; Diğer fonksiyon bloklarını işle
    (for-each (lambda (decl)
                (if (fun-decl? decl)
                    (generate-function port decl)))
              decls)
              
    ; Klasik 'public static void main(String[] args)' fonksiyonunu oluşturur
    (emit port "")
    (emit port ".method public static main([Ljava/lang/String;)V")
    (emit port "    .limit stack 100")
    (emit port "    .limit locals 100")
    ...
    
    (close-output-port port)))
