;; ============================================================
;; MAKROLAR (MACROS) - İLERİ SEVİYE
;; ============================================================
;; 
;; Makro = Kod yazan kod!
;; 
;; Fonksiyonlardan farkı:
;; - Fonksiyon: çalışma zamanında (runtime) çalışır
;; - Makro: derleme zamanında (compile time) çalışır
;;
;; Makro, kodu dönüştürür. Yeni syntax oluşturabilirsin!
;;
;; ============================================================


;; ============================================================
;; BÖLÜM 1: NEDEN MAKRO?
;; ============================================================
;;
;; Örnek: "unless" yapısı istiyoruz.
;; (unless koşul ...) = koşul YANLIŞ ise çalıştır
;;
;; Bunu fonksiyon olarak YAPAMAZSIN!
;; Çünkü fonksiyonlarda tüm argümanlar önce değerlendirilir.
;; Ama biz koşul doğruysa gövdeyi çalıştırmak İSTEMİYORUZ.
;;
;; Makrolar "lazy evaluation" sağlar.

(display "--- NEDEN MAKRO? ---\n")

;; Fonksiyon olarak unless (YANLIŞ YÖNTEM):
(define (unless-fonksiyon kosul sonuc)
  (if (not kosul)
      sonuc
      'bos))

;; Bu ÇALIŞMAZ düzgün:
;; (unless-fonksiyon #t (display "Bu yazılmamalı!"))
;; Ama (display ...) zaten çalışır çünkü önce argümanlar değerlendiriliyor!

;; Makro ile doğru çözüm (aşağıda göreceğiz)


;; ============================================================
;; BÖLÜM 2: SYNTAX-RULES - BASİT MAKRO TANIMLAMA
;; ============================================================
;;
;; define-syntax ve syntax-rules ile makro tanımlanır.
;;
;; (define-syntax isim
;;   (syntax-rules (anahtar-kelimeler)
;;     [pattern template]
;;     [pattern template]
;;     ...))

(display "\n--- ILK MAKRO: UNLESS ---\n")

;; unless makrosu:
(define-syntax unless
  (syntax-rules ()
    [(unless kosul govde ...)
     (if (not kosul)
         (begin govde ...)
         (void))]))

;; Şimdi kullanalım:
(unless #f
  (display "Koşul yanlış, bu yazılır!")
  (newline))
;; Çıktı: Koşul yanlış, bu yazılır!

(unless #t
  (display "Koşul doğru, bu YAZILMAZ!")
  (newline))
;; Çıktı: (hiçbir şey)

;; Ne oldu?
;; (unless #f (display ...))
;; dönüştürüldü ->
;; (if (not #f) (begin (display ...)) (void))


;; ============================================================
;; BÖLÜM 3: WHEN MAKROSU
;; ============================================================
;;
;; when = if'in sadece "doğru" dalı olan hali

(display "\n--- WHEN MAKROSU ---\n")

(define-syntax when
  (syntax-rules ()
    [(when kosul govde ...)
     (if kosul
         (begin govde ...)
         (void))]))

(when (> 5 3)
  (display "5 büyüktür 3!")
  (newline))
;; Çıktı: 5 büyüktür 3!

(when (< 5 3)
  (display "Bu yazılmaz")
  (newline))
;; Çıktı: (hiçbir şey)


;; ============================================================
;; BÖLÜM 4: SWAP! - DEĞİŞKEN DEĞİŞTİRME
;; ============================================================
;;
;; İki değişkenin değerini değiştir.
;; Bu fonksiyon olarak YAPILAMAZ (değişkenlere referans lazım).

(display "\n--- SWAP! MAKROSU ---\n")

(define-syntax swap!
  (syntax-rules ()
    [(swap! a b)
     (let ([temp a])
       (set! a b)
       (set! b temp))]))

(define x 10)
(define y 20)

(display "Önce: x=")
(display x)
(display ", y=")
(display y)
(newline)

(swap! x y)

(display "Sonra: x=")
(display x)
(display ", y=")
(display y)
(newline)
;; Çıktı: Önce: x=10, y=20
;;        Sonra: x=20, y=10


;; ============================================================
;; BÖLÜM 5: FOR DÖNGÜSÜ MAKROSU
;; ============================================================
;;
;; Scheme'de normal for döngüsü yok.
;; Ama makro ile yapabiliriz!

(display "\n--- FOR DÖNGÜSÜ ---\n")

(define-syntax for
  (syntax-rules (from to)
    [(for var from baslangic to bitis govde ...)
     (let loop ([var baslangic])
       (when (<= var bitis)
         govde ...
         (loop (+ var 1))))]))

(display "1'den 5'e kadar sayılar:\n")
(for i from 1 to 5
  (display i)
  (display " "))
(newline)
;; Çıktı: 1 2 3 4 5


;; ============================================================
;; BÖLÜM 6: WHILE DÖNGÜSÜ
;; ============================================================

(display "\n--- WHILE DÖNGÜSÜ ---\n")

(define-syntax while
  (syntax-rules ()
    [(while kosul govde ...)
     (let loop ()
       (when kosul
         govde ...
         (loop)))]))

(define sayac 5)
(display "Geri sayım: ")
(while (> sayac 0)
  (display sayac)
  (display " ")
  (set! sayac (- sayac 1)))
(newline)
;; Çıktı: Geri sayım: 5 4 3 2 1


;; ============================================================
;; BÖLÜM 7: PATTERN MATCHING İLE MAKRO
;; ============================================================
;;
;; Birden fazla pattern tanımlayabilirsin.
;; İlk eşleşen kullanılır.

(display "\n--- ÇOKLU PATTERN ---\n")

;; my-if: 2 veya 3 argümanlı olabilir
(define-syntax my-if
  (syntax-rules ()
    ;; 3 argümanlı (if-then-else)
    [(my-if kosul dogru yanlis)
     (if kosul dogru yanlis)]
    ;; 2 argümanlı (sadece if-then)
    [(my-if kosul dogru)
     (if kosul dogru (void))]))

(display "my-if #t 'evet 'hayır: ")
(display (my-if #t 'evet 'hayir))
(newline)

(display "my-if #t 'evet: ")
(display (my-if #t 'sadece-dogru))
(newline)


;; ============================================================
;; BÖLÜM 8: LET* BENZERİ MAKRO
;; ============================================================
;;
;; Sıralı let tanımlamaları

(display "\n--- MY-LET* ---\n")

(define-syntax my-let*
  (syntax-rules ()
    ;; Boş binding listesi
    [(my-let* () govde ...)
     (begin govde ...)]
    ;; Bir veya daha fazla binding
    [(my-let* ([var val] rest ...) govde ...)
     (let ([var val])
       (my-let* (rest ...) govde ...))]))

(my-let* ([a 1]
          [b (+ a 1)]
          [c (+ b 1)])
  (display "a=")
  (display a)
  (display ", b=")
  (display b)
  (display ", c=")
  (display c)
  (newline))
;; Çıktı: a=1, b=2, c=3


;; ============================================================
;; BÖLÜM 9: DEBUG MAKROSU
;; ============================================================
;;
;; Değişkenin hem adını hem değerini yazdır.
;; Fonksiyon olarak YAPILAMAZ (isim bilgisini kaybedersin).

(display "\n--- DEBUG MAKROSU ---\n")

(define-syntax debug
  (syntax-rules ()
    [(debug expr)
     (begin
       (display 'expr)
       (display " = ")
       (display expr)
       (newline))]))

(define sonuc (* 7 8))
(debug sonuc)
;; Çıktı: sonuc = 56

(debug (+ 2 3))
;; Çıktı: (+ 2 3) = 5

(debug (* (+ 1 2) (+ 3 4)))
;; Çıktı: (* (+ 1 2) (+ 3 4)) = 21


;; ============================================================
;; BÖLÜM 10: ASSERT MAKROSU
;; ============================================================
;;
;; Test için kullanışlı.

(display "\n--- ASSERT MAKROSU ---\n")

(define-syntax assert
  (syntax-rules ()
    [(assert kosul)
     (unless kosul
       (error 'assert "Assertion failed:" 'kosul))]))

(assert (= (+ 2 2) 4))   ; OK, sessizce geçer
(display "2+2=4 assertion geçti!\n")

(assert (> 5 3))         ; OK
(display "5>3 assertion geçti!\n")

;; Bu hata verir (yorum satırı):
;; (assert (= 1 2))   ; HATA: Assertion failed: (= 1 2)


;; ============================================================
;; BÖLÜM 11: SYNTAX-CASE - DAHA GÜÇLÜ MAKROLAR
;; ============================================================
;;
;; syntax-case daha güçlü ama daha karmaşık.
;; Değişken oluşturma, karmaşık dönüşümler için kullanılır.
;; Chez Scheme'de kullanılabilir.

(display "\n--- SYNTAX-CASE ÖRNEĞİ ---\n")

;; with-timer: kodun ne kadar sürdüğünü ölç
(define-syntax with-timer
  (lambda (stx)
    (syntax-case stx ()
      [(with-timer govde ...)
       #'(let ([baslangic (current-time)])
           (let ([sonuc (begin govde ...)])
             (let ([bitis (current-time)])
               (display "Süre: ")
               (display (time-difference bitis baslangic))
               (newline)
               sonuc)))])))

;; Not: Chez Scheme'de bu basit bir timer örneğidir


;; ============================================================
;; BÖLÜM 12: MAKRO YAZARKEN DİKKAT
;; ============================================================
;;
;; 1. HYGIENE (Hijyen):
;;    Scheme makroları "hygienic" - yani değişken çakışması olmaz.
;;    Makrodaki temp değişkeni, dışarıdaki temp ile çakışmaz.
;;
;; 2. ÇOKLU DEĞERLENDİRME:
;;    Dikkat! Argüman birden fazla kullanılırsa, birden fazla değerlendirilir.
;;
;; 3. SIRA:
;;    Makrolar derleme zamanında genişletilir.
;;    Makro tanımı, kullanımdan önce olmalı.

(display "\n--- HYGIENE ÖRNEĞİ ---\n")

;; Bu makro "temp" kullanıyor:
(define-syntax guvenli-swap
  (syntax-rules ()
    [(guvenli-swap a b)
     (let ([temp a])
       (set! a b)
       (set! b temp))]))

;; Dışarıda da "temp" var ama sorun olmaz:
(define temp 999)
(define p 1)
(define q 2)

(guvenli-swap p q)

(display "p=")
(display p)
(display ", q=")
(display q)
(display ", temp=")
(display temp)
(newline)
;; Çıktı: p=2, q=1, temp=999
;; temp etkilenmedi! Hygiene sayesinde.


;; ============================================================
;; ÖZET
;; ============================================================
;;
;; MAKRO NEDİR:
;; - Kod yazan kod
;; - Derleme zamanında çalışır
;; - Yeni syntax oluşturur
;;
;; SYNTAX-RULES:
;; (define-syntax isim
;;   (syntax-rules (keywords)
;;     [pattern template]))
;;
;; PATTERN SEMBOLLERI:
;; - ... : sıfır veya daha fazla tekrar
;; - _ : herhangi bir şey (joker)
;;
;; ÖRNEK MAKROLAR:
;; - when/unless : tek dallı koşul
;; - swap! : değişken değiştirme
;; - for/while : döngüler
;; - debug : hata ayıklama
;; - assert : test
;;
;; AVANTAJLAR:
;; - Lazy evaluation
;; - Yeni syntax
;; - Derleme zamanı optimizasyon
;;
;; DİKKAT:
;; - Hygiene: değişken çakışması olmaz
;; - Çoklu değerlendirme riski
;; - Debugging zor olabilir
;;
;; ============================================================

(display "\n============================================\n")
(display "Makrolar eğitimi tamamlandı!\n")
(display "Çalıştır: chez --script 05-makrolar.scm\n")
(display "============================================\n")

