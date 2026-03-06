; ============================================================================
; KRYPTO PROJESİ - DETAYLI KOD ANALİZİ: SEMANTİK ANALİZ (src/semantic/analyzer.scm)
; ============================================================================
;
; Bu dosya, Semantik Analiz modülünün en önemli fonksiyonlarını açıklar.
; Parser grameri kontrol ederken, bu modül "anlamı" ve "tipleri" kontrol eder.
; ============================================================================

; ----------------------------------------------------------------------------
; BÖLÜM 1: TİP KONTROLÜ (TYPE CHECKING)
; ----------------------------------------------------------------------------
; Semantik analizin kalbi burasıdır. Beklenen tip ile gelen tip uyuşuyor mu?

(define (expect-type actual expected loc)
  "Gerçek tip (actual) ile beklenen tipin (expected) aynı olup olmadığını kontrol eder."
  ; type-equal? fonksiyonu (semantic/types.scm içinde) iki tip yapısını karşılaştırır.
  (if (type-equal? actual expected)
      #t ; Tipler aynıysa sorun yok, devam et.
      
      ; Tipler farklıysa hata kaydı oluştur:
      (begin
        (semantic-error (string-append "Type mismatch. Expected " 
                                       (type-to-string expected) 
                                       ", but got " 
                                       (type-to-string actual)) 
                        loc)
        #f)))

; ----------------------------------------------------------------------------
; BÖLÜM 2: DEĞİŞKEN TANIMLAMA (LET ANALYSIS)
; ----------------------------------------------------------------------------
; "let x: int = 5;" satırı nasıl analiz edilir?

(define (analyze-let node env)
  (let ((name (ast-get node 'name))
        (loc (ast-get node 'location))
        (init (ast-get node 'initializer))     ; "= 5" kısmı
        (mod-ast (ast-get node 'type-annotation))) ; ": int" kısmı
    
    ; 1. ADIM: Kullanıcının belirlediği tipi çözümle (varsa)
    (let ((declared-type (if mod-ast (resolve-type-annotation mod-ast env) #f))
          ; 2. ADIM: Başlangıç değerinin tipini bul (recursion)
          (init-type (if init (analyze-node init env) #f)))
      
      ; 3. ADIM: Nihai tipi belirle
      (let ((final-type 
             (cond
               ; Hem tip belirtilmiş hem değer verilmişse KONTROL ET
               ((and declared-type init-type)
                (expect-type init-type declared-type loc) ; <-- BURADA KONTROL YAPILIYOR
                declared-type)
                
               ; Sadece tip belirtilmişse onu kullan
               (declared-type declared-type)
               
               ; Tip belirtilmemiş ama değer verilmişse TİP ÇIKARIMI (INFERENCE) YAP
               (init-type init-type)
               
               ; İkisi de yoksa hata/bilinmeyen tip
               (else (make-type-any))))) 
        
        ; 4. ADIM: Değişkeni sembol tablosuna kaydet
        (define-symbol-safe env name final-type 'variable loc)
        (make-type-void)))))

; ----------------------------------------------------------------------------
; BÖLÜM 3: FONKSİYON ÇAĞRISI (CALL ANALYSIS)
; ----------------------------------------------------------------------------
; "topla(3, 5)" çağrısı nasıl kontrol edilir?

(define (analyze-call node env)
  (let ((callee-type (analyze-node (ast-get node 'callee) env)) ; fonksiyonun kendi tipi
        (args (ast-get node 'arguments)))
    
    ; Önce çağrılan şeyin bir fonksiyon olup olmadığına bak
    (if (type-function? callee-type)
        (let ((param-types (type-function-params callee-type)) ; Beklenen parametre tipleri
              (arg-types (map (lambda (a) (analyze-node a env)) args))) ; Verilen argümanların tipleri
          
          ; Argüman sayısı tutuyor mu?
          (if (= (length param-types) (length arg-types))
              (begin
                ; Her bir argümanı, beklenen parametre tipiyle karşılaştır
                (for-each (lambda (pt at arg-node)
                            (expect-type at pt (ast-get arg-node 'location)))
                          param-types arg-types args)
                ; Sonuç olarak fonksiyonun dönüş tipini ver
                (type-function-return callee-type))
              
              ; Argüman sayısı yanlışsa hata ver
              (begin
                (semantic-error "Incorrect number of arguments" ...)
                ...)))
        ...)))
