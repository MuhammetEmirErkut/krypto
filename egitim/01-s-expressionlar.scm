;; ============================================================
;; S-EXPRESSION'LAR NEDİR? - EN TEMEL ANLATIM
;; ============================================================
;; 
;; S-expression = "Symbolic Expression" = Sembolik İfade
;; Lisp ve Scheme'in temel yapı taşıdır.
;; 
;; KURAL ÇOK BASİT:
;; Her şey ya bir ATOM'dur, ya da bir LİSTE'dir.
;; 
;; ============================================================


;; ============================================================
;; BÖLÜM 1: ATOMLAR (En küçük parçalar)
;; ============================================================
;; 
;; Atom = Daha fazla parçalanamayan en küçük şey
;; Tıpkı kimyadaki atom gibi düşün.
;;
;; Atom örnekleri:
;;   - Sayılar: 5, 42, 3.14
;;   - Semboller: x, toplam, araba
;;   - Stringler: "merhaba"
;;   - Boolean: #t (true), #f (false)

;; Şimdi bunları görelim:

5           ; Bu bir atom (sayı)
42          ; Bu da bir atom (sayı)  
3.14        ; Bu da bir atom (ondalık sayı)

"merhaba"   ; Bu bir atom (string/metin)
"dünya"     ; Bu da bir atom (string)

#t          ; Bu bir atom (true = doğru)
#f          ; Bu bir atom (false = yanlış)

;; Sembolleri de tanımlayabiliriz:
(define x 10)       ; x sembolüne 10 değerini atadık
(display x)         ; Ekrana: 10
(newline)


;; ============================================================
;; BÖLÜM 2: LİSTELER (Parantez içindeki şeyler)
;; ============================================================
;;
;; Liste = Parantez içine yazılan şeyler
;; 
;; ALTIN KURAL: 
;; Parantez açtın mı, liste başladı demektir.
;; Parantez kapattın mı, liste bitti demektir.
;;
;; Liste şöyle yazılır: (eleman1 eleman2 eleman3 ...)

;; En basit liste örnekleri:
'(1 2 3)              ; 3 elemanlı bir liste: 1, 2, 3
'(a b c)              ; 3 elemanlı bir liste: a, b, c sembolleri
'("ali" "veli" "deli") ; 3 elemanlı bir liste: 3 tane string

;; NOT: Başındaki ' (tek tırnak) "bu listeyi çalıştırma, sadece veri olarak al" demek
;; Buna "quote" denir. Şimdilik sadece ' koy yeter.

;; Listeyi ekrana yazdıralım:
(display '(1 2 3))
(newline)
;; Çıktı: (1 2 3)

(display '(elma armut muz))
(newline)
;; Çıktı: (elma armut muz)


;; ============================================================
;; BÖLÜM 3: LİSTELER AYNI ZAMANDA KOD'DUR!
;; ============================================================
;;
;; İşte Lisp/Scheme'in sihri burada:
;; Liste hem VERİ hem de KOD olabilir!
;;
;; KURAL:
;; Eğer listenin başına ' koymazsan, Scheme onu ÇALIŞTIRMAYA çalışır.
;; İlk eleman = fonksiyon
;; Geri kalanlar = o fonksiyona verilen argümanlar

;; Örnek 1: Toplama
(+ 2 3)
;; Bu bir liste: (+ 2 3)
;; İlk eleman: + (toplama fonksiyonu)
;; Diğer elemanlar: 2 ve 3 (toplanacak sayılar)
;; Sonuç: 5

(display (+ 2 3))
(newline)
;; Çıktı: 5

;; Örnek 2: Çıkarma
(- 10 4)
;; İlk eleman: - (çıkarma fonksiyonu)
;; Sonuç: 6

(display (- 10 4))
(newline)
;; Çıktı: 6

;; Örnek 3: Çarpma
(* 3 4)
;; İlk eleman: * (çarpma fonksiyonu)
;; Sonuç: 12

(display (* 3 4))
(newline)
;; Çıktı: 12

;; Örnek 4: Bölme
(/ 20 5)
;; İlk eleman: / (bölme fonksiyonu)
;; Sonuç: 4

(display (/ 20 5))
(newline)
;; Çıktı: 4


;; ============================================================
;; BÖLÜM 4: İÇ İÇE LİSTELER (Nested Lists)
;; ============================================================
;;
;; Listeler iç içe olabilir!
;; Yani bir listenin içinde başka listeler olabilir.
;;
;; Matematikte nasıl parantez içinde parantez oluyorsa:
;; (2 + (3 * 4)) gibi...
;; Scheme'de de aynı mantık var.

;; Örnek: 2 + (3 * 4) = 2 + 12 = 14
(+ 2 (* 3 4))
;; Önce içteki liste çalışır: (* 3 4) = 12
;; Sonra dıştaki: (+ 2 12) = 14

(display (+ 2 (* 3 4)))
(newline)
;; Çıktı: 14

;; Daha karmaşık örnek: (10 - 5) * (6 + 2) = 5 * 8 = 40
(* (- 10 5) (+ 6 2))
;; Önce (- 10 5) = 5
;; Sonra (+ 6 2) = 8
;; En son (* 5 8) = 40

(display (* (- 10 5) (+ 6 2)))
(newline)
;; Çıktı: 40


;; ============================================================
;; BÖLÜM 5: VERİ OLARAK LİSTELER
;; ============================================================
;;
;; Bazen listeyi çalıştırmak istemeyiz.
;; Sadece veri olarak tutmak isteriz.
;; İşte o zaman ' (quote) kullanırız.

;; Quote olmadan:
;; (1 2 3)  ; HATA VERİR! Çünkü 1'i fonksiyon olarak çağırmaya çalışır!

;; Quote ile:
'(1 2 3)   ; Tamam, bu sadece bir veri listesi

;; Fark şu:
(display "Quote ile liste:")
(newline)
(display '(+ 2 3))   ; + 2 3 listesini yazdırır
(newline)
;; Çıktı: (+ 2 3)

(display "Quote olmadan (çalıştırılır):")
(newline)
(display (+ 2 3))    ; 5 sonucunu yazdırır
(newline)
;; Çıktı: 5


;; ============================================================
;; BÖLÜM 6: LİSTE İŞLEMLERİ
;; ============================================================
;;
;; Listelerle çalışmak için özel fonksiyonlar var:
;;
;; car  = listenin İLK elemanını al
;; cdr  = listenin GERİ KALANINI al (ilk hariç)
;; cons = başa bir eleman ekle
;; list = yeni liste oluştur

;; CAR: İlk elemanı al
(display "car örneği:")
(newline)
(display (car '(1 2 3)))   ; 1
(newline)

(display (car '(elma armut muz)))   ; elma
(newline)

;; CDR: Geri kalanı al
(display "cdr örneği:")
(newline)
(display (cdr '(1 2 3)))   ; (2 3)
(newline)

(display (cdr '(elma armut muz)))   ; (armut muz)
(newline)

;; CONS: Başa eleman ekle
(display "cons örneği:")
(newline)
(display (cons 0 '(1 2 3)))   ; (0 1 2 3)
(newline)

(display (cons 'kiraz '(elma armut)))   ; (kiraz elma armut)
(newline)

;; LIST: Yeni liste oluştur
(display "list örneği:")
(newline)
(display (list 1 2 3))   ; (1 2 3)
(newline)

(display (list 'a 'b 'c))   ; (a b c)
(newline)


;; ============================================================
;; BÖLÜM 7: ÖZET
;; ============================================================
;;
;; 1. S-expression = Atom veya Liste
;;
;; 2. Atom = sayı, string, sembol, boolean (bölünemez)
;;    Örnekler: 5, "merhaba", x, #t
;;
;; 3. Liste = parantez içindeki şeyler
;;    Örnek: (1 2 3), (+ 2 3), (elma armut)
;;
;; 4. ' (quote) = "çalıştırma, veri olarak al"
;;    '(1 2 3) = sadece liste verisi
;;    (+ 2 3) = hesapla, sonuç 5
;;
;; 5. Listede ilk eleman fonksiyon, diğerleri argüman
;;    (fonksiyon arg1 arg2 ...)
;;
;; 6. Listeler iç içe olabilir
;;    (+ 2 (* 3 4)) = 14
;;
;; 7. Temel liste işlemleri:
;;    car = ilk eleman
;;    cdr = geri kalan
;;    cons = başa ekle
;;    list = liste oluştur
;;
;; ============================================================

(display "")
(newline)
(display "============================================")
(newline)
(display "S-Expression eğitimi tamamlandı!")
(newline)
(display "Dosyayı çalıştırmak için: chez --script 01-s-expressionlar.scm")
(newline)
(display "============================================")
(newline)

