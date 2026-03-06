; ============================================================================
; KRYPTO PROJESİ - DETAYLI KOD ANALİZİ: PARSER (src/parser/parser.scm)
; ============================================================================
;
; Bu dosya, Parser (Sözdizim Çözümleyici) modülünün önemli kısımlarının
; detaylı Türkçe açıklamalı halidir. Parser, token listesini alır ve
; hiyerarşik bir ağaca (AST) dönüştürür.
; ============================================================================

; ----------------------------------------------------------------------------
; BÖLÜM 1: RECURSIVE DESCENT (ÖZYİNELEMELİ İNİŞ) MANTIĞI
; ----------------------------------------------------------------------------
; Parser'ımızdaki her gramer kuralı bir fonksiyondur.
; parse-program -> parse-declaration -> parse-statement -> parse-expression
; şeklinde birbirlerini çağırırlar.

; parse-while-statement ÖRNEĞİ:
; "while (x < 10) { ... }" yapısını nasıl çözümleriz?

(define (parse-while-statement state)
  (let ((while-tok (parser-current state)))
    ; 1. ADIM: "while" kelimesini bekle ve tüket
    (let* ((result1 (expect-keyword state "while" "Expected 'while'"))
           (state1 (cdr result1))
           
           ; 2. ADIM: "(" karakterini bekle
           (result2 (expect state1 'TOKEN-LPAREN "Expected '(' after 'while'"))
           (state2 (cdr result2))
           
           ; 3. ADIM: Koşul ifadesini (expression) parse et.
           ; Burada kontrolü 'parse-expression' fonksiyonuna devrederiz.
           (cond-result (parse-expression state2))
           (condition (car cond-result)) ; Ortaya çıkan AST düğümü (örn: binary-expr)
           (state3 (cdr cond-result))    ; Kaldığımız yer
           
           ; 4. ADIM: ")" karakterini bekle
           (result3 (expect state3 'TOKEN-RPAREN "Expected ')' after condition"))
           (state4 (cdr result3))
           
           ; 5. ADIM: Döngü gövdesini (blok) parse et
           (body-result (parse-block state4))
           (body (car body-result))
           (state5 (cdr body-result)))
           
      ; SONUÇ: Tüm parçaları birleştirip bir 'while-stmt' düğümü oluştur
      (cons (make-while-stmt condition body
                             (token-line while-tok)
                             (token-column while-tok))
            state5))))

; ----------------------------------------------------------------------------
; BÖLÜM 2: EXPRESSION PARSING (İFADE ÇÖZÜMLEME)
; ----------------------------------------------------------------------------
; Matematiksel işlemler (3 + 4 * 5) karışık olabilir. Çarpma toplamadan önce yapılmalıdır.
; Bunu "Precedence Climbing" (Öncelik Tırmanışı) yöntemiyle çözeriz.
; Fonksiyonlar en düşük öncelikten en yükseğe doğru sıralanır.

; En düşük öncelik: Toplama (+) ve Çıkarma (-)
(define (parse-term state)
  ; Önce sol tarafı daha yüksek öncelikli fonksiyonla (parse-factor) çöz
  (let* ((left-result (parse-factor state))
         (left (car left-result))
         (state1 (cdr left-result)))
         
    ; Sonra döngüye gir: Eğer '+' veya '-' görüyorsan devam et
    (let loop ((left left) (state state1))
      (let ((tok (parser-current state)))
        (cond
          ; Eğer '+' gördüysek:
          ((parser-check state 'TOKEN-PLUS)
           (let* ((result (parser-advance state))
                  ; Sağ tarafı yine parse-factor ile çöz (öncelik koruması)
                  (right-result (parse-factor (cdr result)))
                  (right (car right-result)))
             ; Sol ve Sağ tarafı 'add' düğümü ile birleştir ve döngüye devam et
             ; Böylece 3 + 4 + 5 ifadesi (add (add 3 4) 5) olur.
             (loop (make-binary-expr 'add left right ...)
                   (cdr right-result))))
          
          ; Değilse elimizdeki sonucu döndür
          (else
           (cons left state)))))))

; Daha yüksek öncelik: Çarpma (*) ve Bölme (/)
(define (parse-factor state)
  ; Bu da kendi içinde daha yüksek öncelikli olan 'parse-unary'i çağırır.
  ; 'parse-unary' ise tekil işlemleri (-5, !true) ve parantezleri çözer.
  (let* ((left-result (parse-unary state))
        ... ; (Benzer mantık)
  ))

; ----------------------------------------------------------------------------
; BÖLÜM 3: HATA YÖNETİMİ (EXPECT)
; ----------------------------------------------------------------------------
; Parser'ın "beklediğim şey gelmezse patla" dediği yer.

(define (expect state type message)
  "Belirli bir token tipini bekler, gelmezse hata fırlatır."
  (if (parser-check state type)
      (parser-advance state) ; Doğruysa tüket ve ilerle
      (parse-error state message))) ; Yanlışsa hata ver (Program durur)
