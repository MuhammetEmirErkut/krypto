;; ============================================================
;; HIGHER-ORDER FONKSİYONLAR (ÜST DÜZEY FONKSİYONLAR)
;; ============================================================
;; 
;; Higher-order function = 
;;   - Fonksiyonu parametre olarak alan, VEYA
;;   - Fonksiyonu geri döndüren fonksiyon
;;
;; Scheme'de fonksiyonlar "first-class citizen" (birinci sınıf vatandaş).
;; Yani fonksiyonlar da değişken gibi taşınabilir, atanabilir, döndürülebilir!
;;
;; ============================================================


;; ============================================================
;; BÖLÜM 1: LAMBDA - ANONİM FONKSİYON
;; ============================================================
;;
;; lambda = isimsiz fonksiyon oluşturma
;;
;; (lambda (parametreler) gövde)
;;
;; define ile tanımladığımız fonksiyonlar aslında lambda'nın kısaltması!

(display "--- LAMBDA ÖRNEKLERİ ---\n")

;; Normal tanım:
(define (kare x)
  (* x x))

;; Aynısı lambda ile:
(define kare2
  (lambda (x)
    (* x x)))

(display "kare(5) = ")
(display (kare 5))
(newline)

(display "kare2(5) = ")
(display (kare2 5))
(newline)

;; Lambda'yı direkt kullanabilirsin:
(display "Direkt lambda: ")
(display ((lambda (x) (* x x)) 7))   ; 49
(newline)

;; Birden fazla parametre:
(display "İki parametreli: ")
(display ((lambda (a b) (+ a b)) 3 4))   ; 7
(newline)


;; ============================================================
;; BÖLÜM 2: FONKSİYONU PARAMETRE OLARAK VERME
;; ============================================================
;;
;; Bir fonksiyonu başka fonksiyona geçirebilirsin.
;; Bu çok güçlü bir özellik!

(display "\n--- FONKSİYON PARAMETRESİ ---\n")

;; Bir fonksiyonu iki kere uygula:
(define (iki-kere f x)
  (f (f x)))

(display "kare'yi iki kere uygula (5): ")
(display (iki-kere kare 5))   ; kare(kare(5)) = kare(25) = 625
(newline)

;; Bir sayıya 1 ekleyen fonksiyon:
(define (bir-ekle x) (+ x 1))

(display "bir-ekle'yi iki kere uygula (5): ")
(display (iki-kere bir-ekle 5))   ; 5+1+1 = 7
(newline)

;; Lambda ile de olur:
(display "Lambda ile iki kere (3 katını al): ")
(display (iki-kere (lambda (x) (* 3 x)) 2))   ; 2*3*3 = 18
(newline)


;; ============================================================
;; BÖLÜM 3: MAP - LİSTENİN HER ELEMANINA UYGULA
;; ============================================================
;;
;; map = bir fonksiyonu listenin her elemanına uygular
;; Sonuç: yeni bir liste
;;
;; (map fonksiyon liste)

(display "\n--- MAP ÖRNEKLERİ ---\n")

;; Her elemanın karesini al:
(display "Kareler: ")
(display (map kare '(1 2 3 4 5)))   ; (1 4 9 16 25)
(newline)

;; Her elemana 10 ekle:
(display "10 ekle: ")
(display (map (lambda (x) (+ x 10)) '(1 2 3 4 5)))   ; (11 12 13 14 15)
(newline)

;; Stringleri büyük harfe çevir:
(display "Büyük harf: ")
(display (map string-upcase '("ali" "veli" "deli")))
(newline)
;; Çıktı: ("ALI" "VELI" "DELI")

;; İki liste ile map:
(display "İki liste topla: ")
(display (map + '(1 2 3) '(10 20 30)))   ; (11 22 33)
(newline)

;; Çarpma:
(display "İki liste çarp: ")
(display (map * '(1 2 3) '(4 5 6)))   ; (4 10 18)
(newline)


;; ============================================================
;; BÖLÜM 4: FILTER - FİLTRELE
;; ============================================================
;;
;; filter = koşulu sağlayan elemanları seç
;; Fonksiyon #t döndürürse eleman kalır, #f döndürürse gider.
;;
;; (filter predicate liste)

(display "\n--- FILTER ÖRNEKLERİ ---\n")

;; Çift sayıları filtrele:
(define (cift-mi? x)
  (= (remainder x 2) 0))

(display "Çift sayılar: ")
(display (filter cift-mi? '(1 2 3 4 5 6 7 8 9 10)))
(newline)
;; Çıktı: (2 4 6 8 10)

;; Tek sayılar (lambda ile):
(display "Tek sayılar: ")
(display (filter (lambda (x) (not (cift-mi? x))) '(1 2 3 4 5 6 7 8 9 10)))
(newline)
;; Çıktı: (1 3 5 7 9)

;; 5'ten büyükler:
(display "5'ten büyükler: ")
(display (filter (lambda (x) (> x 5)) '(1 8 3 9 2 7 4 6)))
(newline)
;; Çıktı: (8 9 7 6)

;; Pozitif sayılar:
(display "Pozitifler: ")
(display (filter (lambda (x) (> x 0)) '(-3 5 -1 8 0 -2 4)))
(newline)
;; Çıktı: (5 8 4)

;; Boş olmayan stringler:
(display "Boş olmayanlar: ")
(display (filter (lambda (s) (> (string-length s) 0)) '("" "ali" "" "veli" "")))
(newline)
;; Çıktı: ("ali" "veli")


;; ============================================================
;; BÖLÜM 5: FOLD / REDUCE - İNDİRGE
;; ============================================================
;;
;; fold = listeyi tek bir değere indirir
;; Toplama, çarpma, birleştirme gibi işlemler için.
;;
;; fold-left: soldan sağa
;; fold-right: sağdan sola
;;
;; (fold-left fonksiyon başlangıç-değeri liste)

(display "\n--- FOLD ÖRNEKLERİ ---\n")

;; Toplam:
(display "Toplam: ")
(display (fold-left + 0 '(1 2 3 4 5)))   ; 0+1+2+3+4+5 = 15
(newline)

;; Çarpım:
(display "Çarpım: ")
(display (fold-left * 1 '(1 2 3 4 5)))   ; 1*1*2*3*4*5 = 120
(newline)

;; Maximum bulma:
(display "Maximum: ")
(display (fold-left max 0 '(3 7 2 9 1 5)))   ; 9
(newline)

;; Minimum bulma:
(display "Minimum: ")
(display (fold-left min 999 '(3 7 2 9 1 5)))   ; 1
(newline)

;; String birleştirme:
(display "Birleştir: ")
(display (fold-left string-append "" '("Merhaba" " " "Dünya" "!")))
(newline)
;; Çıktı: Merhaba Dünya!

;; Liste birleştirme:
(display "Liste birleştir: ")
(display (fold-left append '() '((1 2) (3 4) (5 6))))
(newline)
;; Çıktı: (1 2 3 4 5 6)

;; Eleman sayısı (kendi length'imiz):
(display "Eleman sayısı: ")
(display (fold-left (lambda (acc x) (+ acc 1)) 0 '(a b c d e)))
(newline)
;; Çıktı: 5


;; ============================================================
;; BÖLÜM 6: FONKSİYON DÖNDÜREN FONKSİYONLAR
;; ============================================================
;;
;; Bir fonksiyon başka bir fonksiyon döndürebilir.
;; Bu "closure" (kapanış) oluşturur.

(display "\n--- FONKSİYON DÖNDÜRME ---\n")

;; n ekleyen fonksiyon üret:
(define (ekleyici-yap n)
  (lambda (x) (+ x n)))

(define bes-ekle (ekleyici-yap 5))
(define on-ekle (ekleyici-yap 10))

(display "5 ekle(3) = ")
(display (bes-ekle 3))   ; 8
(newline)

(display "10 ekle(3) = ")
(display (on-ekle 3))    ; 13
(newline)

;; Çarpan fonksiyonu üret:
(define (carpici-yap n)
  (lambda (x) (* x n)))

(define ikiyle-carp (carpici-yap 2))
(define ucle-carp (carpici-yap 3))

(display "2 ile çarp(7) = ")
(display (ikiyle-carp 7))   ; 14
(newline)

(display "3 ile çarp(7) = ")
(display (ucle-carp 7))     ; 21
(newline)


;; ============================================================
;; BÖLÜM 7: COMPOSE - FONKSİYON BİRLEŞTİRME
;; ============================================================
;;
;; İki fonksiyonu birleştirip yeni fonksiyon yap.
;; compose(f, g)(x) = f(g(x))

(display "\n--- COMPOSE ÖRNEĞİ ---\n")

;; Kendi compose fonksiyonumuz:
(define (compose f g)
  (lambda (x) (f (g x))))

;; Önce kare al, sonra 1 ekle:
(define kare-sonra-bir-ekle (compose bir-ekle kare))

(display "kare sonra 1 ekle(5) = ")
(display (kare-sonra-bir-ekle 5))   ; kare(5)=25, 25+1=26
(newline)

;; Önce 1 ekle, sonra kare al:
(define bir-ekle-sonra-kare (compose kare bir-ekle))

(display "1 ekle sonra kare(5) = ")
(display (bir-ekle-sonra-kare 5))   ; 5+1=6, kare(6)=36
(newline)


;; ============================================================
;; BÖLÜM 8: APPLY - LİSTEYİ ARGÜMAN OLARAK VER
;; ============================================================
;;
;; apply = listedeki elemanları fonksiyona argüman olarak verir
;;
;; (apply + '(1 2 3)) = (+ 1 2 3) = 6

(display "\n--- APPLY ÖRNEKLERİ ---\n")

(display "apply + '(1 2 3 4 5) = ")
(display (apply + '(1 2 3 4 5)))   ; 15
(newline)

(display "apply * '(1 2 3 4 5) = ")
(display (apply * '(1 2 3 4 5)))   ; 120
(newline)

(display "apply max '(3 7 2 9 1) = ")
(display (apply max '(3 7 2 9 1)))   ; 9
(newline)

(display "apply list '(a b c) = ")
(display (apply list '(a b c)))   ; (a b c)
(newline)


;; ============================================================
;; BÖLÜM 9: PRATİK ÖRNEKLER
;; ============================================================

(display "\n--- PRATİK ÖRNEKLER ---\n")

;; 1. Listedeki sayıların karelerinin toplamı:
(define (kare-toplam lst)
  (fold-left + 0 (map kare lst)))

(display "Kare toplamı (1 2 3 4): ")
(display (kare-toplam '(1 2 3 4)))   ; 1+4+9+16 = 30
(newline)

;; 2. Çift sayıların toplamı:
(define (cift-toplam lst)
  (fold-left + 0 (filter cift-mi? lst)))

(display "Çift sayıların toplamı (1-10): ")
(display (cift-toplam '(1 2 3 4 5 6 7 8 9 10)))   ; 2+4+6+8+10 = 30
(newline)

;; 3. Listedeki tüm sayıları 2 ile çarp, sonra 5'ten büyükleri al:
(define (isle lst)
  (filter (lambda (x) (> x 5))
          (map (lambda (x) (* x 2)) lst)))

(display "2 ile çarp, >5 filtrele (1 2 3 4 5): ")
(display (isle '(1 2 3 4 5)))   ; (6 8 10)
(newline)

;; 4. Kelimelerin uzunluklarını bul:
(display "Kelime uzunlukları: ")
(display (map string-length '("ali" "veli" "ahmet")))
(newline)
;; Çıktı: (3 4 5)

;; 5. Sadece 3 harften uzun kelimeleri al:
(display "3'ten uzun kelimeler: ")
(display (filter (lambda (s) (> (string-length s) 3)) 
                 '("a" "bb" "ccc" "dddd" "eeeee")))
(newline)
;; Çıktı: ("dddd" "eeeee")


;; ============================================================
;; ÖZET
;; ============================================================
;;
;; LAMBDA:
;; (lambda (param...) gövde) - isimsiz fonksiyon
;;
;; MAP:
;; (map f lst) - her elemana f uygula
;; (map + '(1 2) '(3 4)) -> (4 6)
;;
;; FILTER:
;; (filter pred lst) - pred #t döndürenleri al
;; (filter even? '(1 2 3 4)) -> (2 4)
;;
;; FOLD:
;; (fold-left f init lst) - listeyi tek değere indir
;; (fold-left + 0 '(1 2 3)) -> 6
;;
;; APPLY:
;; (apply f lst) - listeyi argüman olarak ver
;; (apply + '(1 2 3)) -> 6
;;
;; FONKSİYON DÖNDÜRME:
;; (define (make-f n) (lambda (x) ...))
;; Closure oluşturur, n değerini hatırlar.
;;
;; COMPOSE:
;; İki fonksiyonu birleştir: (f ∘ g)(x) = f(g(x))
;;
;; ============================================================

(display "\n============================================\n")
(display "Higher-order fonksiyonlar eğitimi tamamlandı!\n")
(display "Çalıştır: chez --script 04-higher-order-fonksiyonlar.scm\n")
(display "============================================\n")

