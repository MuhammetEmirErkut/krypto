; ============================================================================
; KRYPTO PROJESİ - DETAYLI KOD ANALİZİ: LEXER (src/lexer/lexer.scm)
; ============================================================================
;
; Bu dosya, Krypto dilinin Lexer (Kelimelere Ayırıcı) modülünün
; 'Annotated' (Notlandırılmış) versiyonudur.
; Orjinal kodun aynısıdır, fakat her bloğun üzerinde ne işe yaradığı Türkçe
; ve detaylı olarak anlatılmıştır.
;
; ============================================================================

; ----------------------------------------------------------------------------
; BÖLÜM 1: TOKEN TİPLERİ
; ----------------------------------------------------------------------------
; Token tipleri sembol (symbol) olarak tanımlanmıştır.
; Scheme'de 'quote (yani ') işareti sembol oluşturur.
; Bu liste, dildeki tüm geçerli yapı taşlarını tanımlar.

(define *token-types*
  '(; Literaller: Kod içindeki sabit değerler
    TOKEN-INTEGER  ; Tamsayılar (ör: 42)
    TOKEN-FLOAT    ; Ondalıklı sayılar (ör: 3.14)
    TOKEN-STRING   ; Yazılar (ör: "merhaba")
    
    ; Tanımlayıcılar
    TOKEN-IDENTIFIER ; Değişken ve fonksiyon isimleri (ör: x, topla)
    TOKEN-KEYWORD    ; Dilin rezerve kelimeleri (ör: if, let)
    
    ; Operatörler
    TOKEN-PLUS          ; +
    TOKEN-DOUBLE-EQUALS ; == (Eşitlik kontrolü)
    TOKEN-EQUALS        ; = (Atama)
    
    ; ... (Diğer tipler orjinal dosyadaki gibidir)
    ))

; ----------------------------------------------------------------------------
; BÖLÜM 2: STATE (DURUM) YÖNETİMİ
; ----------------------------------------------------------------------------
; Lexer, kaynak kod üzerinde ilerlerken nerede olduğunu bilmelidir.
; Fonksiyonel programlamada değişken değeri değiştirmek yerine,
; yeni bir durum (state) listesi döndürürüz.

(define (make-lexer-state source)
  "Başlangıç durumunu oluşturur."
  (list source    ; 0. eleman: Kaynak kodun tamamı (string)
        0         ; 1. eleman: Şu anki karakter indeksi (cursor)
        1         ; 2. eleman: Satır sayısı
        1))       ; 3. eleman: Sütun sayısı

; Bu yardımcı fonksiyonlar, state listesinden veriyi okur.
(define (lexer-source state) (list-ref state 0))
(define (lexer-pos state) (list-ref state 1))

; lexer-advance fonksiyonu, imleci bir ileri taşır.
; DİKKAT: Eski state'i değiştirmez, YENİ bir state listesi oluşturup döndürür.
(define (lexer-advance state)
  (let ((char (lexer-current-char state)))
    (if (not char)
        state ; Eğer dosya bittiyse aynı yerde kal
        (list (lexer-source state)
              (+ 1 (lexer-pos state))  ; Pozisyonu 1 artır
              ; Eğer yeni satıra geçildiyse satır sayısını artır
              (if (char-newline? char) (+ 1 (lexer-line state)) (lexer-line state))
              ; Sütun sayısını güncelle
              (if (char-newline? char) 1 (+ 1 (lexer-column state)))))))

; ----------------------------------------------------------------------------
; BÖLÜM 3: KARAKTER OKUMA MANTIĞI
; ----------------------------------------------------------------------------

; Bu fonksiyon (scan-token), o anki karaktere bakıp hangi token olduğuna karar verir.
; Bir nevi büyük bir switch-case yapısıdır.

(define (scan-token state line col)
  (let ((char (lexer-current-char state)))
    (cond
      ; Eğer karakter '(' ise hemen TOKEN-LPAREN üret ve 1 ilerle
      ((char=? char #\()
       (cons (make-token 'TOKEN-LPAREN "(" line col)
             (lexer-advance state)))
             
      ; Eğer karakter '=' ise, bir sonrakine de bakmamız lazım.
      ; Çünkü '=' (atama) olabileceği gibi '==' (eşitlik) de olabilir.
      ((char=? char #\=)
       (let ((next (lexer-peek-char state 1))) ; 1 karakter sonrasına bak
         (if (and next (char=? next #\=))
             ; Eşitlik (==) durumu:
             (cons (make-token 'TOKEN-DOUBLE-EQUALS "==" line col)
                   (lexer-advance (lexer-advance state))) ; 2 kere ilerle
             ; Atama (=) durumu:
             (cons (make-token 'TOKEN-EQUALS "=" line col)
                   (lexer-advance state)))))
                   
      ; Eğer karakter bir rakam ise (0-9), sayı okuma fonksiyonuna git
      ((char-digit? char)
       (read-number state line col))
       
      ; Eğer karakter harf ise, kelime okuma fonksiyonuna git
      ((char-identifier-start? char)
       (read-identifier state line col))
      
      ; Bilinmeyen karakter
      (else
       (cons (make-token 'TOKEN-ERROR (string char) line col)
             (lexer-advance state))))))

; ----------------------------------------------------------------------------
; BÖLÜM 4: ANA DÖNGÜ (TOKENIZE)
; ----------------------------------------------------------------------------
; Burası işlemin başladığı yerdir.
; Dosya sonuna gelene kadar sürekli döngü kurar ve tokenları bir listede toplar.

(define (tokenize source)
  (let loop ((state (make-lexer-state source))
             (tokens '())) ; Boş token listesi ile başla
             
    (let ((state (skip-whitespace state))) ; Önce boşlukları atla
      (if (lexer-at-end? state)
          ; Eğer dosya bittiyse, listeyi ters çevir ve EOF ekle
          (reverse (cons (make-token 'TOKEN-EOF "" ...) tokens))
          
          ; Dosya bitmediyse bir sonraki tokenı oku
          (let* ((result (scan-token state ...)))
             ; scan-token bize (token . new-state) çifti döner
             ; cdr result -> yeni state
             ; car result -> okunan token
             (loop (cdr result) (cons (car result) tokens)))))))

