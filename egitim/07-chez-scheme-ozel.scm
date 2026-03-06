;; ============================================================
;; CHEZ SCHEME'E ÖZGÜ ÖZELLİKLER
;; ============================================================
;; 
;; Chez Scheme, en hızlı Scheme uygulamalarından biri.
;; Cisco tarafından geliştirildi, 2016'da açık kaynak oldu.
;; 
;; Bu dosyada Chez'e özgü özellikleri göreceğiz.
;;
;; ============================================================


;; ============================================================
;; BÖLÜM 1: PERFORMANS
;; ============================================================
;;
;; Chez çok hızlı! Native kod üretiyor.

(display "--- PERFORMANS ---\n")

;; time makrosu ile ölçüm:
(display "Fibonacci(30) süresi:\n")
(define (fib n)
  (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))

(time (fib 30))
(newline)

;; optimize-level ile optimizasyon:
;; 0 = optimizasyon yok
;; 2 = normal (varsayılan)
;; 3 = maksimum
(display "Optimizasyon seviyesi: ")
(display (optimize-level))
(newline)


;; ============================================================
;; BÖLÜM 2: RECORDS (GELİŞMİŞ YAPILAR)
;; ============================================================

(display "\n--- RECORDS ---\n")

;; define-record-type ile yapı tanımla:
(define-record-type ogrenci
  (fields 
    (immutable isim)        ; değiştirilemez
    (mutable not))          ; değiştirilebilir
  (protocol
    (lambda (new)
      (lambda (isim)
        (new isim 0)))))    ; varsayılan not = 0

(define ali (make-ogrenci "Ali"))

(display "Öğrenci: ")
(display (ogrenci-isim ali))
(newline)

(display "Not (başlangıç): ")
(display (ogrenci-not ali))
(newline)

;; Notu değiştir:
(ogrenci-not-set! ali 85)
(display "Not (yeni): ")
(display (ogrenci-not ali))
(newline)


;; ============================================================
;; BÖLÜM 3: BOX (KUTULAR)
;; ============================================================
;;
;; Box = değiştirilebilir tek değer kutusu

(display "\n--- BOX ---\n")

(define sayac (box 0))

(display "Sayaç (başlangıç): ")
(display (unbox sayac))
(newline)

;; Değeri değiştir:
(set-box! sayac 10)
(display "Sayaç (sonra): ")
(display (unbox sayac))
(newline)

;; Artır:
(set-box! sayac (+ (unbox sayac) 1))
(display "Sayaç (+1): ")
(display (unbox sayac))
(newline)


;; ============================================================
;; BÖLÜM 4: HASH TABLOLAR
;; ============================================================

(display "\n--- HASH TABLOLAR ---\n")

;; eq? hash tablosu (semboller için):
(define ht (make-eq-hashtable))

(hashtable-set! ht 'isim "Ahmet")
(hashtable-set! ht 'yas 25)
(hashtable-set! ht 'sehir "İstanbul")

(display "İsim: ")
(display (hashtable-ref ht 'isim #f))
(newline)

(display "Yaş: ")
(display (hashtable-ref ht 'yas #f))
(newline)

(display "Anahtarlar: ")
(display (hashtable-keys ht))
(newline)

(display "Var mı 'yas? ")
(display (hashtable-contains? ht 'yas))
(newline)


;; ============================================================
;; BÖLÜM 5: PARAMETERS (DİNAMİK DEĞİŞKENLER)
;; ============================================================

(display "\n--- PARAMETERS ---\n")

;; Dinamik değişken tanımla:
(define mevcut-kullanici (make-parameter "misafir"))

(display "Kullanıcı: ")
(display (mevcut-kullanici))
(newline)

;; Geçici olarak değiştir:
(parameterize ([mevcut-kullanici "admin"])
  (display "İçeride kullanıcı: ")
  (display (mevcut-kullanici))
  (newline))

;; Eski haline döner:
(display "Dışarıda kullanıcı: ")
(display (mevcut-kullanici))
(newline)


;; ============================================================
;; BÖLÜM 6: GUARDIANS (FINALIZERS)
;; ============================================================

(display "\n--- GUARDIANS ---\n")

;; Bellek temizliği için guardian:
(define g (make-guardian))

;; Nesne kaydet:
(let ([x (list 1 2 3)])
  (g x)
  (display "Nesne kaydedildi\n"))

;; Garbage collection sonrası:
;; (collect) ; GC çalıştır
;; (g) ; temizlenen nesneleri al


;; ============================================================
;; BÖLÜM 7: FOREIGN FUNCTION INTERFACE (FFI)
;; ============================================================

(display "\n--- FFI (KISA ÖRNEK) ---\n")

;; C fonksiyonlarını çağırabilirsin:
;; (foreign-procedure "strlen" (string) int)
;;
;; Kütüphane yükle:
;; (load-shared-object "libc.so")
;;
;; Örnek (sadece gösterim):
;; (define c-strlen
;;   (foreign-procedure "strlen" (string) size_t))
;; (c-strlen "merhaba") ; -> 7

(display "FFI ile C kütüphaneleri çağrılabilir.\n")
(display "Örnek: (foreign-procedure \"strlen\" (string) int)\n")


;; ============================================================
;; BÖLÜM 8: THREAD (ÇOK İŞPARÇACIKLI)
;; ============================================================

(display "\n--- THREADS ---\n")

;; Thread oluştur:
(define t 
  (fork-thread 
    (lambda ()
      (display "Thread içinden merhaba!\n"))))

;; Thread bitene kadar bekle:
;; (thread-join t)

;; Mutex:
(define m (make-mutex))
(with-mutex m
  (display "Mutex korumalı bölge\n"))


;; ============================================================
;; BÖLÜM 9: SYNTAX-CASE (GELİŞMİŞ MAKRO)
;; ============================================================

(display "\n--- SYNTAX-CASE ---\n")

;; with-timer makrosu:
(define-syntax timed
  (syntax-rules ()
    [(timed expr)
     (time expr)]))

(display "2^20 hesaplama süresi:\n")
(timed (expt 2 20))
(newline)


;; ============================================================
;; BÖLÜM 10: DOSYA İŞLEMLERİ
;; ============================================================

(display "\n--- DOSYA İŞLEMLERİ ---\n")

;; Dosya var mı?
(display "Bu dosya var mı? ")
(display (file-exists? "07-chez-scheme-ozel.scm"))
(newline)

;; Dosya listesi:
(display "Klasördeki dosyalar: ")
(display (directory-list "."))
(newline)


;; ============================================================
;; BÖLÜM 11: MODÜL SİSTEMİ
;; ============================================================

(display "\n--- MODÜL SİSTEMİ ---\n")

;; library tanımlama:
;; (library (mylib utils)
;;   (export helper-function)
;;   (import (chezscheme))
;;   (define (helper-function x) ...))
;;
;; Kullanım:
;; (import (mylib utils))
;; (helper-function 5)

(display "Library sistemi ile modüler kod yazılır.\n")
(display "Örnek: (library (mylib utils) ...)\n")


;; ============================================================
;; ÖZET
;; ============================================================
;;
;; CHEZ SCHEME ÖZELLİKLERİ:
;;
;; PERFORMANS:
;; - time makrosu
;; - optimize-level
;; - Native kod üretimi
;;
;; VERİ YAPILARI:
;; - define-record-type (gelişmiş)
;; - box (mutable value)
;; - hashtable
;;
;; DİNAMİK DEĞİŞKENLER:
;; - make-parameter
;; - parameterize
;;
;; BELLEK:
;; - guardians (finalizers)
;; - collect (GC)
;;
;; FFI:
;; - foreign-procedure
;; - load-shared-object
;;
;; CONCURRENCY:
;; - fork-thread
;; - make-mutex
;;
;; DOSYA:
;; - file-exists?
;; - directory-list
;;
;; MODÜLLER:
;; - library
;; - import/export
;;
;; ============================================================

(display "\n============================================\n")
(display "Chez Scheme özellikleri eğitimi tamamlandı!\n")
(display "Çalıştır: chez --script 07-chez-scheme-ozel.scm\n")
(display "============================================\n")

