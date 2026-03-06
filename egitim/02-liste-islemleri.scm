;; ============================================================
;; LİSTE İŞLEMLERİ - CAR, CDR, CONS ve DAHA FAZLASI
;; ============================================================
;; 
;; Scheme'de listeler HER ŞEYDİR.
;; Kod liste, veri liste, her şey liste!
;; Bu yüzden liste işlemlerini çok iyi bilmen lazım.
;;
;; ============================================================


;; ============================================================
;; BÖLÜM 1: LİSTENİN YAPISI - CONS CELLS (Hücreler)
;; ============================================================
;;
;; Bir liste aslında "cons cell" denilen hücrelerden oluşur.
;; Her hücrenin 2 parçası var:
;;
;;   +-------+-------+
;;   |  car  |  cdr  |
;;   +-------+-------+
;;
;; car = hücredeki değer (baş)
;; cdr = sonraki hücreye pointer (kuyruk)
;;
;; Liste (1 2 3) aslında şöyle görünür:
;;
;;   +---+---+    +---+---+    +---+---+
;;   | 1 | ●-|--->| 2 | ●-|--->| 3 | / |
;;   +---+---+    +---+---+    +---+---+
;;                              (/ = nil = boş liste)

;; Boş liste:
(display "Boş liste: ")
(display '())
(newline)
;; Çıktı: ()

;; Boş liste kontrolü:
(display "Boş mu? ")
(display (null? '()))   ; #t
(newline)

(display "Boş mu? ")
(display (null? '(1 2 3)))   ; #f
(newline)


;; ============================================================
;; BÖLÜM 2: CAR - İLK ELEMANI AL
;; ============================================================
;;
;; car = "Contents of Address Register" (tarihsel isim)
;; Ama sen şöyle hatırla: CAR = "C"ok önemli "A"nlamlı "R"akam :)
;; Ya da sadece: "listenin başı"

(display "\n--- CAR ÖRNEKLERİ ---\n")

;; Basit örnekler:
(display (car '(1 2 3)))        ; 1
(newline)

(display (car '(a b c)))        ; a
(newline)

(display (car '("ali" "veli"))) ; "ali"
(newline)

;; İç içe listede car:
(display (car '((1 2) (3 4))))  ; (1 2) - ilk eleman bir liste!
(newline)

;; Tek elemanlı liste:
(display (car '(42)))           ; 42
(newline)

;; DİKKAT: Boş listede car HATA verir!
;; (car '())  ; HATA!


;; ============================================================
;; BÖLÜM 3: CDR - GERİ KALANI AL
;; ============================================================
;;
;; cdr = "Contents of Decrement Register" (tarihsel isim)
;; Sen şöyle hatırla: CDR = "C"uda "D"evamı "R"est (geri kalan)
;; Ya da: "listenin kuyruğu"

(display "\n--- CDR ÖRNEKLERİ ---\n")

;; Basit örnekler:
(display (cdr '(1 2 3)))        ; (2 3)
(newline)

(display (cdr '(a b c d)))      ; (b c d)
(newline)

;; İki elemanlı listede:
(display (cdr '(1 2)))          ; (2) - TEK ELEMANLI LİSTE, 2 değil!
(newline)

;; Tek elemanlı listede:
(display (cdr '(42)))           ; () - boş liste!
(newline)

;; DİKKAT: Boş listede cdr HATA verir!
;; (cdr '())  ; HATA!


;; ============================================================
;; BÖLÜM 4: CAR ve CDR KOMBİNASYONLARI
;; ============================================================
;;
;; car ve cdr'yi zincirleme kullanabilirsin.
;; Kısa yollar var: cadr, caddr, caar, cadar, vs.
;;
;; cadr = (car (cdr x))  = 2. eleman
;; caddr = (car (cdr (cdr x))) = 3. eleman
;; caar = (car (car x)) = ilk elemanın ilk elemanı

(display "\n--- KOMBİNASYONLAR ---\n")

(define liste '(a b c d e))

;; 1. eleman:
(display "1. eleman: ")
(display (car liste))           ; a
(newline)

;; 2. eleman:
(display "2. eleman: ")
(display (cadr liste))          ; b  (car (cdr liste))
(newline)

;; 3. eleman:
(display "3. eleman: ")
(display (caddr liste))         ; c  (car (cdr (cdr liste)))
(newline)

;; 4. eleman:
(display "4. eleman: ")
(display (cadddr liste))        ; d
(newline)

;; İç içe liste örneği:
(define matrix '((1 2 3) (4 5 6) (7 8 9)))

(display "\nMatrix: ")
(display matrix)
(newline)

(display "İlk satır: ")
(display (car matrix))          ; (1 2 3)
(newline)

(display "İlk satırın 2. elemanı: ")
(display (cadar matrix))        ; 2  = (car (cdr (car matrix)))
(newline)

(display "2. satır: ")
(display (cadr matrix))         ; (4 5 6)
(newline)


;; ============================================================
;; BÖLÜM 5: CONS - YENİ HÜCRE OLUŞTUR
;; ============================================================
;;
;; cons = "construct" = inşa et
;; İki şeyi birleştirip yeni bir cons cell oluşturur.
;;
;; (cons a b) = a'yı başa koy, b'yi kuyruğa koy

(display "\n--- CONS ÖRNEKLERİ ---\n")

;; Listeye eleman ekleme:
(display (cons 1 '(2 3)))       ; (1 2 3)
(newline)

(display (cons 'a '(b c)))      ; (a b c)
(newline)

;; Boş listeye ekleme:
(display (cons 1 '()))          ; (1)
(newline)

;; Liste başına liste ekleme:
(display (cons '(1 2) '(3 4)))  ; ((1 2) 3 4)
(newline)

;; ÖNEMLİ: cons her zaman BAŞA ekler!
;; Sona eklemek için append kullan.


;; ============================================================
;; BÖLÜM 6: CONS ile PAIR (ÇİFT) OLUŞTURMA
;; ============================================================
;;
;; cons ile liste olmayan "pair" (çift) de oluşturabilirsin.
;; Eğer ikinci argüman liste değilse, "dotted pair" olur.

(display "\n--- PAIR (ÇİFT) ÖRNEKLERİ ---\n")

;; Dotted pair:
(display (cons 1 2))            ; (1 . 2)  - noktalı çift!
(newline)

(display (cons 'a 'b))          ; (a . b)
(newline)

;; Bu liste DEĞİL, çift!
;; Sözlük (dictionary) yapısı için kullanılır:
(define kisi (cons "isim" "Ahmet"))
(display "Kişi: ")
(display kisi)                  ; ("isim" . "Ahmet")
(newline)

(display "Anahtar: ")
(display (car kisi))            ; "isim"
(newline)

(display "Değer: ")
(display (cdr kisi))            ; "Ahmet"
(newline)


;; ============================================================
;; BÖLÜM 7: LIST - LİSTE OLUŞTUR
;; ============================================================
;;
;; list fonksiyonu birden fazla elemanı listeye çevirir.
;; cons'tan farkı: tüm argümanları alır, tek tek cons etmene gerek yok.

(display "\n--- LIST ÖRNEKLERİ ---\n")

(display (list 1 2 3))          ; (1 2 3)
(newline)

(display (list 'a 'b 'c))       ; (a b c)
(newline)

;; İfadeler de olabilir:
(display (list (+ 1 2) (* 3 4) (- 10 5)))   ; (3 12 5)
(newline)

;; Karışık türler:
(display (list 1 "iki" 'uc #t)) ; (1 "iki" uc #t)
(newline)


;; ============================================================
;; BÖLÜM 8: APPEND - LİSTELERİ BİRLEŞTİR
;; ============================================================
;;
;; append = listeleri uç uca ekle

(display "\n--- APPEND ÖRNEKLERİ ---\n")

(display (append '(1 2) '(3 4)))        ; (1 2 3 4)
(newline)

(display (append '(a b) '(c) '(d e)))   ; (a b c d e)
(newline)

;; Boş listeyle:
(display (append '() '(1 2 3)))         ; (1 2 3)
(newline)

;; cons vs append farkı:
(display "cons: ")
(display (cons '(1 2) '(3 4)))          ; ((1 2) 3 4) - liste içinde liste!
(newline)

(display "append: ")
(display (append '(1 2) '(3 4)))        ; (1 2 3 4) - düz liste
(newline)


;; ============================================================
;; BÖLÜM 9: LENGTH, REVERSE ve DİĞER YARDIMCILAR
;; ============================================================

(display "\n--- DİĞER FONKSİYONLAR ---\n")

;; LENGTH - listenin uzunluğu
(display "length: ")
(display (length '(a b c d)))           ; 4
(newline)

;; REVERSE - listeyi ters çevir
(display "reverse: ")
(display (reverse '(1 2 3 4)))          ; (4 3 2 1)
(newline)

;; LIST-REF - indexle eleman al (0'dan başlar)
(display "list-ref: ")
(display (list-ref '(a b c d) 2))       ; c (3. eleman, index 2)
(newline)

;; MEMBER - eleman listede var mı?
(display "member: ")
(display (member 'c '(a b c d)))        ; (b c d) - bulduğu yerden itibaren
(newline)

(display "member (yok): ")
(display (member 'x '(a b c d)))        ; #f
(newline)

;; LAST-PAIR - son çifti al
(display "last-pair: ")
(display (last-pair '(a b c d)))        ; (d)
(newline)


;; ============================================================
;; BÖLÜM 10: LİSTE KONTROL FONKSİYONLARI
;; ============================================================

(display "\n--- KONTROL FONKSİYONLARI ---\n")

;; pair? - cons cell mi?
(display "pair? '(1 2): ")
(display (pair? '(1 2)))                ; #t
(newline)

(display "pair? '(): ")
(display (pair? '()))                   ; #f - boş liste pair değil!
(newline)

(display "pair? 5: ")
(display (pair? 5))                     ; #f - atom pair değil
(newline)

;; list? - liste mi?
(display "list? '(1 2 3): ")
(display (list? '(1 2 3)))              ; #t
(newline)

(display "list? '(1 . 2): ")
(display (list? (cons 1 2)))            ; #f - dotted pair liste değil!
(newline)

;; null? - boş liste mi?
(display "null? '(): ")
(display (null? '()))                   ; #t
(newline)

(display "null? '(1): ")
(display (null? '(1)))                  ; #f
(newline)


;; ============================================================
;; ÖZET
;; ============================================================
;;
;; TEMEL İŞLEMLER:
;; - car : listenin ilk elemanı
;; - cdr : listenin geri kalanı (kuyruk)
;; - cons : başa eleman ekle / çift oluştur
;; - list : yeni liste oluştur
;; - append : listeleri birleştir
;;
;; YARDIMCI İŞLEMLER:
;; - length : uzunluk
;; - reverse : ters çevir
;; - list-ref : indexle eriş
;; - member : arama
;;
;; KONTROLLER:
;; - null? : boş mu?
;; - pair? : çift mi?
;; - list? : liste mi?
;;
;; KOMBİNASYONLAR:
;; - cadr = 2. eleman
;; - caddr = 3. eleman
;; - caar = ilk elemanın ilk elemanı
;;
;; ============================================================

(display "\n============================================\n")
(display "Liste işlemleri eğitimi tamamlandı!\n")
(display "Çalıştır: chez --script 02-liste-islemleri.scm\n")
(display "============================================\n")

