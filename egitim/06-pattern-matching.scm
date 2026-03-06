;; ============================================================
;; PATTERN MATCHING (DESEN EŞLEŞTİRME)
;; ============================================================
;; 
;; Pattern matching = Veri yapısına bakarak karar verme
;; 
;; Çok güçlü bir özellik!
;; if/cond'dan daha okunabilir ve güvenli.
;;
;; Chez Scheme'de: match makrosu (ayrıca yüklenebilir)
;; Scheme standartında: Basit yöntemler
;;
;; ============================================================


;; ============================================================
;; BÖLÜM 1: NEDEN PATTERN MATCHING?
;; ============================================================
;;
;; Diyelim ki farklı türde verileri işlemek istiyorsun.
;; Normal yöntem: if/cond ile kontrol
;; Pattern matching: Yapıya bakarak otomatik eşleştir

(display "--- NEDEN PATTERN MATCHING? ---\n")

;; Örnek: Şekil alanı hesaplama
;; Şekiller: (circle radius) veya (rectangle width height)

;; COND ile (eski usul):
(define (alan-cond sekil)
  (cond
    [(and (list? sekil) 
          (= (length sekil) 2)
          (eq? (car sekil) 'circle))
     (* 3.14159 (cadr sekil) (cadr sekil))]
    [(and (list? sekil)
          (= (length sekil) 3)
          (eq? (car sekil) 'rectangle))
     (* (cadr sekil) (caddr sekil))]
    [else (error 'alan "Bilinmeyen şekil")]))

(display "Daire(5) alanı: ")
(display (alan-cond '(circle 5)))
(newline)
;; Çıktı: ~78.5

(display "Dikdörtgen(4,6) alanı: ")
(display (alan-cond '(rectangle 4 6)))
(newline)
;; Çıktı: 24

;; Çok karmaşık! Pattern matching ile çok daha temiz olur.


;; ============================================================
;; BÖLÜM 2: BASIT MATCH MAKROSU
;; ============================================================
;;
;; Chez Scheme'de yerleşik match yok ama kendimiz yazabiliriz.
;; Ya da basit case/cond kullanırız.
;;
;; Önce basit bir match benzeri yapı oluşturalım:

(display "\n--- BASİT MATCH ---\n")

;; record-case benzeri bir yapı:
(define-syntax match-simple
  (syntax-rules (else)
    ;; Sadece else varsa
    [(match-simple expr
       [else sonuc ...])
     (begin sonuc ...)]
    ;; Pattern ve devamı
    [(match-simple expr
       [(tag params ...) govde ...]
       rest ...)
     (if (and (pair? expr) (eq? (car expr) 'tag))
         (apply (lambda (params ...) govde ...) (cdr expr))
         (match-simple expr rest ...))]))

;; Kullanım:
;; (match-simple '(circle 5)
;;   [(circle r) (* 3.14 r r)]
;;   [(rectangle w h) (* w h)]
;;   [else 'bilinmiyor])


;; ============================================================
;; BÖLÜM 3: CASE İLE PATTERN MATCHING
;; ============================================================
;;
;; Scheme'in yerleşik case'i sembolleri eşleştirir:

(display "\n--- CASE ÖRNEĞİ ---\n")

(define (gun-turu gun)
  (case gun
    [(pazartesi sali carsamba persembe cuma) 'hafta-ici]
    [(cumartesi pazar) 'hafta-sonu]
    [else 'bilinmiyor]))

(display "Pazartesi: ")
(display (gun-turu 'pazartesi))
(newline)
;; Çıktı: hafta-ici

(display "Cumartesi: ")
(display (gun-turu 'cumartesi))
(newline)
;; Çıktı: hafta-sonu


;; ============================================================
;; BÖLÜM 4: LİSTE DESTRUCTURİNG
;; ============================================================
;;
;; Listeyi parçalarına ayırma (destructuring)
;; let ile yapılabilir:

(display "\n--- DESTRUCTURING ---\n")

;; Bir noktayı (x y) olarak temsil edelim
(define nokta '(3 4))

;; Parçalarına ayır:
(define (nokta-uzaklik p)
  (let ([x (car p)]
        [y (cadr p)])
    (sqrt (+ (* x x) (* y y)))))

(display "Nokta (3,4) uzaklığı: ")
(display (nokta-uzaklik nokta))
(newline)
;; Çıktı: 5.0

;; Daha şık: let-values ile (birden fazla değer döndürme)
(define (nokta-parcala p)
  (values (car p) (cadr p)))

(define (nokta-uzaklik2 p)
  (let-values ([(x y) (nokta-parcala p)])
    (sqrt (+ (* x x) (* y y)))))

(display "Nokta (3,4) uzaklığı v2: ")
(display (nokta-uzaklik2 '(3 4)))
(newline)


;; ============================================================
;; BÖLÜM 5: RECURSIVE PATTERN MATCHING
;; ============================================================
;;
;; Listeler üzerinde recursive pattern matching

(display "\n--- RECURSİVE MATCHING ---\n")

;; Liste yapısına göre işlem yap:
(define (liste-isle lst)
  (cond
    ;; Boş liste
    [(null? lst) 
     (display "Boş liste\n")]
    ;; Tek elemanlı liste
    [(null? (cdr lst))
     (display "Tek elemanlı: ")
     (display (car lst))
     (newline)]
    ;; İki elemanlı liste
    [(null? (cddr lst))
     (display "İki elemanlı: ")
     (display (car lst))
     (display " ve ")
     (display (cadr lst))
     (newline)]
    ;; Daha uzun liste
    [else
     (display "Uzun liste, ilk eleman: ")
     (display (car lst))
     (display ", geri kalan: ")
     (display (cdr lst))
     (newline)]))

(liste-isle '())
(liste-isle '(a))
(liste-isle '(a b))
(liste-isle '(a b c d e))


;; ============================================================
;; BÖLÜM 6: AĞAÇ YAPILARI
;; ============================================================
;;
;; Pattern matching ağaç yapıları için çok kullanışlı.

(display "\n--- AĞAÇ ÖRNEĞİ ---\n")

;; Binary tree: ya (leaf değer) ya da (node sol sağ)

(define (yaprak? x)
  (and (pair? x) (eq? (car x) 'leaf)))

(define (dugum? x)
  (and (pair? x) (eq? (car x) 'node)))

(define (yaprak-deger x) (cadr x))
(define (dugum-sol x) (cadr x))
(define (dugum-sag x) (caddr x))

;; Ağaçtaki tüm yaprakların toplamı:
(define (agac-toplam agac)
  (cond
    [(yaprak? agac) 
     (yaprak-deger agac)]
    [(dugum? agac) 
     (+ (agac-toplam (dugum-sol agac))
        (agac-toplam (dugum-sag agac)))]
    [else (error 'agac-toplam "Geçersiz ağaç")]))

;; Örnek ağaç:
;;        node
;;       /    \
;;     node   leaf(5)
;;    /    \
;; leaf(1) leaf(2)

(define ornek-agac
  '(node 
    (node (leaf 1) (leaf 2))
    (leaf 5)))

(display "Ağaç toplamı: ")
(display (agac-toplam ornek-agac))
(newline)
;; Çıktı: 8 (1+2+5)


;; ============================================================
;; BÖLÜM 7: İFADE DEĞERLENDİRİCİ
;; ============================================================
;;
;; Basit bir matematik ifade değerlendiricisi.
;; Pattern matching mükemmel uyum sağlar!

(display "\n--- İFADE DEĞERLENDİRİCİ ---\n")

;; İfadeler:
;; - (num n) : sayı
;; - (add e1 e2) : toplama
;; - (mul e1 e2) : çarpma
;; - (sub e1 e2) : çıkarma

(define (ifade-tipi expr) (car expr))

(define (degerlendir expr)
  (case (ifade-tipi expr)
    [(num) (cadr expr)]
    [(add) (+ (degerlendir (cadr expr))
              (degerlendir (caddr expr)))]
    [(sub) (- (degerlendir (cadr expr))
              (degerlendir (caddr expr)))]
    [(mul) (* (degerlendir (cadr expr))
              (degerlendir (caddr expr)))]
    [else (error 'degerlendir "Bilinmeyen ifade tipi")]))

;; Test: (3 + 4) * (10 - 5) = 7 * 5 = 35
(define test-ifade
  '(mul 
    (add (num 3) (num 4))
    (sub (num 10) (num 5))))

(display "İfade: (3 + 4) * (10 - 5)\n")
(display "Sonuç: ")
(display (degerlendir test-ifade))
(newline)
;; Çıktı: 35


;; ============================================================
;; BÖLÜM 8: GUARD'LAR (KOŞULLU PATTERN)
;; ============================================================
;;
;; Bazen pattern'e ek koşul eklemek isteriz.

(display "\n--- GUARD ÖRNEKLERİ ---\n")

;; Sayının türünü belirle (cond ile guard):
(define (sayi-turu n)
  (cond
    [(not (number? n)) 'sayi-degil]
    [(< n 0) 'negatif]
    [(= n 0) 'sifir]
    [(< n 10) 'tek-hane]
    [(< n 100) 'iki-hane]
    [else 'buyuk-sayi]))

(display "5 -> ")
(display (sayi-turu 5))
(newline)

(display "-3 -> ")
(display (sayi-turu -3))
(newline)

(display "42 -> ")
(display (sayi-turu 42))
(newline)

(display "999 -> ")
(display (sayi-turu 999))
(newline)


;; ============================================================
;; BÖLÜM 9: RECORDS (YAPILAR)
;; ============================================================
;;
;; Chez Scheme'de define-record-type ile yapı tanımlayabiliriz.
;; Bu da pattern matching benzeri kullanım sağlar.

(display "\n--- RECORDS (YAPILAR) ---\n")

;; Kişi yapısı tanımla:
(define-record-type kisi
  (fields isim yas sehir))

;; Yeni kişi oluştur:
(define ahmet (make-kisi "Ahmet" 25 "İstanbul"))
(define ayse (make-kisi "Ayşe" 30 "Ankara"))

;; Alanlara eriş:
(display "İsim: ")
(display (kisi-isim ahmet))
(newline)

(display "Yaş: ")
(display (kisi-yas ahmet))
(newline)

(display "Şehir: ")
(display (kisi-sehir ahmet))
(newline)

;; Kişi mi kontrol:
(display "ahmet kişi mi? ")
(display (kisi? ahmet))
(newline)

(display "'test kişi mi? ")
(display (kisi? 'test))
(newline)


;; ============================================================
;; BÖLÜM 10: VARİANT TİPLERİ
;; ============================================================
;;
;; Farklı türleri tek bir tip altında toplayabiliriz.
;; Örnek: Maybe tipi (değer var veya yok)

(display "\n--- VARIANT TİPLERİ ---\n")

;; Maybe: (just değer) veya (nothing)
(define (just x) (list 'just x))
(define nothing '(nothing))

(define (just? x) (and (pair? x) (eq? (car x) 'just)))
(define (nothing? x) (equal? x '(nothing)))
(define (just-value x) (cadr x))

;; Güvenli bölme (0'a bölme kontrolü):
(define (guvenli-bol a b)
  (if (= b 0)
      nothing
      (just (/ a b))))

(define (maybe-goster m)
  (cond
    [(nothing? m) (display "Değer yok")]
    [(just? m) (begin (display "Değer: ")
                      (display (just-value m)))]
    [else (display "Geçersiz maybe")]))

(display "10 / 2 = ")
(maybe-goster (guvenli-bol 10 2))
(newline)

(display "10 / 0 = ")
(maybe-goster (guvenli-bol 10 0))
(newline)


;; ============================================================
;; BÖLÜM 11: MATCH KÜTÜPHANESI (BONUS)
;; ============================================================
;;
;; Bazı Scheme uygulamalarında match kütüphanesi var.
;; İşte kullanımı nasıl olurdu:
;;
;; (match expr
;;   [pattern1 result1]
;;   [pattern2 result2]
;;   ...)
;;
;; Pattern'ler:
;; - sabit: 5, "hello", 'symbol
;; - değişken: x, y (herhangi bir değeri yakalar)
;; - liste: (a b c), (head . tail)
;; - guard: (? predicate pattern)
;;
;; Örnek:
;; (match '(1 2 3)
;;   [(a b c) (+ a b c)]   ; -> 6
;;   [(h . t) h]           ; ilk elemanı döndür
;;   [else 'bos])

;; Not: Chez Scheme'de yerleşik match yok,
;; ama chez-match gibi kütüphaneler var.


;; ============================================================
;; ÖZET
;; ============================================================
;;
;; PATTERN MATCHING NEDİR:
;; - Veri yapısına bakarak karar verme
;; - if/cond'dan daha okunabilir
;; - Hata yapmayı zorlaştırır
;;
;; SCHEME'DE YÖNTEMLER:
;; 1. case - sembol eşleştirme
;; 2. cond + destructuring - manuel parçalama
;; 3. define-record-type - yapı tanımlama
;; 4. match kütüphanesi (varsa)
;;
;; KULLANIM ALANLARI:
;; - Farklı veri türlerini işleme
;; - Ağaç yapıları (AST, DOM, vs.)
;; - İfade değerlendiriciler
;; - Variant/sum types
;;
;; AVANTAJLAR:
;; - Okunabilirlik
;; - Güvenlik (eksik case uyarısı)
;; - Otomatik destructuring
;;
;; ============================================================

(display "\n============================================\n")
(display "Pattern Matching eğitimi tamamlandı!\n")
(display "Çalıştır: chez --script 06-pattern-matching.scm\n")
(display "============================================\n")

