;; ============================================================
;; RECURSİVE (ÖZYİNELEMELİ) FONKSİYONLAR
;; ============================================================
;; 
;; Recursion = Bir fonksiyonun kendini çağırması
;; 
;; Scheme'de döngü (loop) YOK!
;; Onun yerine recursion kullanılır.
;; Ama korkma, aslında çok basit.
;;
;; ============================================================


;; ============================================================
;; BÖLÜM 1: ÖNCE FONKSİYON TANIMLAMAYI ÖĞRENELİM
;; ============================================================
;;
;; define ile fonksiyon tanımlanır:
;; (define (fonksiyon-adı parametre1 parametre2 ...)
;;   gövde)

;; En basit fonksiyon - selamlama:
(define (selamla isim)
  (display "Merhaba ")
  (display isim)
  (display "!")
  (newline))

(selamla "Ahmet")
;; Çıktı: Merhaba Ahmet!

;; Toplama fonksiyonu:
(define (topla a b)
  (+ a b))

(display "3 + 5 = ")
(display (topla 3 5))
(newline)
;; Çıktı: 3 + 5 = 8

;; Kare alma:
(define (kare x)
  (* x x))

(display "5'in karesi = ")
(display (kare 5))
(newline)
;; Çıktı: 5'in karesi = 25


;; ============================================================
;; BÖLÜM 2: IF - KOŞUL YAPISI
;; ============================================================
;;
;; Recursion için koşul lazım (ne zaman duracağız?)
;;
;; (if koşul
;;     doğruysa-yap
;;     yanlışsa-yap)

(display "\n--- IF ÖRNEKLERİ ---\n")

(define (pozitif-mi? x)
  (if (> x 0)
      "Evet, pozitif"
      "Hayır, pozitif değil"))

(display (pozitif-mi? 5))
(newline)
;; Çıktı: Evet, pozitif

(display (pozitif-mi? -3))
(newline)
;; Çıktı: Hayır, pozitif değil

;; Mutlak değer:
(define (mutlak x)
  (if (< x 0)
      (- x)      ; negatifse, işareti değiştir
      x))        ; değilse, olduğu gibi

(display "|-5| = ")
(display (mutlak -5))
(newline)
;; Çıktı: |-5| = 5


;; ============================================================
;; BÖLÜM 3: İLK RECURSİVE FONKSİYON - SAYAÇ
;; ============================================================
;;
;; Recursion'ın 2 parçası var:
;; 1. BASE CASE (Temel durum) - durma noktası
;; 2. RECURSIVE CASE - kendini çağırma
;;
;; Örnek: 5'ten geriye say

(display "\n--- GERİ SAYIM ---\n")

(define (geri-say n)
  ;; BASE CASE: 0'a ulaştık mı?
  (if (<= n 0)
      (display "Bitti!\n")
      ;; RECURSIVE CASE: devam et
      (begin
        (display n)
        (display "... ")
        (geri-say (- n 1)))))   ; kendini n-1 ile çağır!

(geri-say 5)
;; Çıktı: 5... 4... 3... 2... 1... Bitti!

;; Ne oldu?
;; (geri-say 5) -> 5 yazdır, (geri-say 4) çağır
;; (geri-say 4) -> 4 yazdır, (geri-say 3) çağır
;; (geri-say 3) -> 3 yazdır, (geri-say 2) çağır
;; (geri-say 2) -> 2 yazdır, (geri-say 1) çağır
;; (geri-say 1) -> 1 yazdır, (geri-say 0) çağır
;; (geri-say 0) -> "Bitti!" yazdır, DUR!


;; ============================================================
;; BÖLÜM 4: FAKTÖRİYEL - KLASİK ÖRNEK
;; ============================================================
;;
;; n! = n * (n-1) * (n-2) * ... * 2 * 1
;; 5! = 5 * 4 * 3 * 2 * 1 = 120
;;
;; Matematiksel tanım:
;; 0! = 1 (base case)
;; n! = n * (n-1)! (recursive case)

(display "\n--- FAKTÖRİYEL ---\n")

(define (faktoriyel n)
  ;; BASE CASE
  (if (= n 0)
      1
      ;; RECURSIVE CASE
      (* n (faktoriyel (- n 1)))))

(display "0! = ")
(display (faktoriyel 0))
(newline)
;; Çıktı: 0! = 1

(display "5! = ")
(display (faktoriyel 5))
(newline)
;; Çıktı: 5! = 120

(display "10! = ")
(display (faktoriyel 10))
(newline)
;; Çıktı: 10! = 3628800

;; Adım adım:
;; (faktoriyel 5)
;; = (* 5 (faktoriyel 4))
;; = (* 5 (* 4 (faktoriyel 3)))
;; = (* 5 (* 4 (* 3 (faktoriyel 2))))
;; = (* 5 (* 4 (* 3 (* 2 (faktoriyel 1)))))
;; = (* 5 (* 4 (* 3 (* 2 (* 1 (faktoriyel 0))))))
;; = (* 5 (* 4 (* 3 (* 2 (* 1 1)))))
;; = (* 5 (* 4 (* 3 (* 2 1))))
;; = (* 5 (* 4 (* 3 2)))
;; = (* 5 (* 4 6))
;; = (* 5 24)
;; = 120


;; ============================================================
;; BÖLÜM 5: FİBONACCİ - BAŞKA KLASİK
;; ============================================================
;;
;; Fibonacci serisi: 0, 1, 1, 2, 3, 5, 8, 13, 21, ...
;; Her sayı önceki ikisinin toplamı.
;;
;; fib(0) = 0
;; fib(1) = 1
;; fib(n) = fib(n-1) + fib(n-2)

(display "\n--- FİBONACCİ ---\n")

(define (fib n)
  (if (< n 2)
      n                               ; base case: 0 veya 1
      (+ (fib (- n 1))                ; recursive case
         (fib (- n 2)))))

(display "İlk 10 Fibonacci sayısı: ")
(display (fib 0))
(display " ")
(display (fib 1))
(display " ")
(display (fib 2))
(display " ")
(display (fib 3))
(display " ")
(display (fib 4))
(display " ")
(display (fib 5))
(display " ")
(display (fib 6))
(display " ")
(display (fib 7))
(display " ")
(display (fib 8))
(display " ")
(display (fib 9))
(newline)
;; Çıktı: 0 1 1 2 3 5 8 13 21 34


;; ============================================================
;; BÖLÜM 6: LİSTELERLE RECURSİON
;; ============================================================
;;
;; Listeler için recursion çok doğal!
;; Base case: boş liste
;; Recursive case: (car liste) ile işlem yap, (cdr liste) ile devam et

(display "\n--- LİSTE UZUNLUĞU ---\n")

(define (uzunluk lst)
  (if (null? lst)
      0                               ; boş liste = 0 uzunluk
      (+ 1 (uzunluk (cdr lst)))))     ; 1 + geri kalanın uzunluğu

(display "Uzunluk '(a b c d): ")
(display (uzunluk '(a b c d)))
(newline)
;; Çıktı: Uzunluk '(a b c d): 4

(display "\n--- LİSTE TOPLAMI ---\n")

(define (liste-toplam lst)
  (if (null? lst)
      0                                    ; boş liste = 0
      (+ (car lst)                         ; ilk eleman
         (liste-toplam (cdr lst)))))       ; + geri kalanın toplamı

(display "Toplam '(1 2 3 4 5): ")
(display (liste-toplam '(1 2 3 4 5)))
(newline)
;; Çıktı: Toplam '(1 2 3 4 5): 15


;; ============================================================
;; BÖLÜM 7: TAIL RECURSİON (KUYRUK ÖZYINELEME)
;; ============================================================
;;
;; Normal recursion: önce derinlere git, sonra hesapla
;; Tail recursion: hesaplamayı taşıyarak git
;;
;; Tail recursion daha verimli! Scheme bunu optimize eder.
;; Stack overflow olmaz.

(display "\n--- TAIL RECURSİON ---\n")

;; Normal faktoriyel (tail recursion DEĞİL):
;; (faktoriyel 5) = (* 5 (faktoriyel 4)) = ...
;; Önce tüm çağrıları yığınla, sonra çarp

;; Tail recursive faktoriyel:
(define (faktoriyel-tail n)
  ;; Yardımcı fonksiyon - accumulator (biriktirici) ile
  (define (helper n acc)
    (if (= n 0)
        acc                              ; sonucu döndür
        (helper (- n 1) (* n acc))))     ; sonucu taşıyarak git
  (helper n 1))                          ; başlangıç acc = 1

(display "5! (tail) = ")
(display (faktoriyel-tail 5))
(newline)
;; Çıktı: 5! (tail) = 120

;; Fark:
;; Normal: (f 5) -> (f 4) -> (f 3) -> (f 2) -> (f 1) -> (f 0)
;;         sonra geri gel ve çarp, çarp, çarp...
;;
;; Tail:   (h 5 1) -> (h 4 5) -> (h 3 20) -> (h 2 60) -> (h 1 120) -> (h 0 120)
;;         sonuç zaten hazır: 120

;; Tail recursive toplam:
(define (liste-toplam-tail lst)
  (define (helper lst acc)
    (if (null? lst)
        acc
        (helper (cdr lst) (+ acc (car lst)))))
  (helper lst 0))

(display "Toplam (tail) '(1 2 3 4 5): ")
(display (liste-toplam-tail '(1 2 3 4 5)))
(newline)


;; ============================================================
;; BÖLÜM 8: DAHA FAZLA ÖRNEK
;; ============================================================

(display "\n--- EKSTRA ÖRNEKLER ---\n")

;; Listeyi tersine çevir:
(define (ters-cevir lst)
  (define (helper lst acc)
    (if (null? lst)
        acc
        (helper (cdr lst) (cons (car lst) acc))))
  (helper lst '()))

(display "Ters '(1 2 3 4): ")
(display (ters-cevir '(1 2 3 4)))
(newline)
;; Çıktı: (4 3 2 1)

;; Listede ara:
(define (icerir-mi? lst x)
  (cond
    [(null? lst) #f]                    ; bulunamadı
    [(equal? (car lst) x) #t]           ; bulundu!
    [else (icerir-mi? (cdr lst) x)]))   ; aramaya devam

(display "'(a b c d) içinde 'c var mı? ")
(display (icerir-mi? '(a b c d) 'c))
(newline)
;; Çıktı: #t

(display "'(a b c d) içinde 'x var mı? ")
(display (icerir-mi? '(a b c d) 'x))
(newline)
;; Çıktı: #f

;; n'inci elemanı al:
(define (n-inci lst n)
  (if (= n 0)
      (car lst)
      (n-inci (cdr lst) (- n 1))))

(display "'(a b c d e) listesinin 3. elemanı: ")
(display (n-inci '(a b c d e) 3))
(newline)
;; Çıktı: d (0'dan başladığına dikkat!)


;; ============================================================
;; BÖLÜM 9: COND - ÇOKLU KOŞUL
;; ============================================================
;;
;; if sadece 2 dal için.
;; cond birden fazla koşul için:
;;
;; (cond
;;   [koşul1 sonuç1]
;;   [koşul2 sonuç2]
;;   [else  varsayılan])

(display "\n--- COND ÖRNEĞİ ---\n")

(define (not-hesapla puan)
  (cond
    [(>= puan 90) "AA"]
    [(>= puan 80) "BA"]
    [(>= puan 70) "BB"]
    [(>= puan 60) "CB"]
    [(>= puan 50) "CC"]
    [else "FF"]))

(display "85 puan = ")
(display (not-hesapla 85))
(newline)
;; Çıktı: BA

(display "42 puan = ")
(display (not-hesapla 42))
(newline)
;; Çıktı: FF


;; ============================================================
;; ÖZET
;; ============================================================
;;
;; FONKSİYON TANIMLAMA:
;; (define (isim param...) gövde)
;;
;; KOŞUL:
;; (if koşul doğru yanlış)
;; (cond [k1 s1] [k2 s2] [else s])
;;
;; RECURSİON PRENSİBİ:
;; 1. BASE CASE - durma koşulu (boş liste, 0, vs.)
;; 2. RECURSIVE CASE - kendini çağır (daha küçük problem)
;;
;; LİSTELERDE RECURSİON:
;; - Base case: (null? lst)
;; - Recursive: (car lst) ile işle, (cdr lst) ile devam
;;
;; TAIL RECURSİON:
;; - Accumulator (biriktirici) kullan
;; - Sonucu parametre olarak taşı
;; - Daha verimli, stack overflow olmaz
;;
;; ============================================================

(display "\n============================================\n")
(display "Recursive fonksiyonlar eğitimi tamamlandı!\n")
(display "Çalıştır: chez --script 03-recursive-fonksiyonlar.scm\n")
(display "============================================\n")

