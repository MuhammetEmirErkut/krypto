; Basit Scheme örneği

; Merhaba dünya
(display "Merhaba Dünya!")
(newline)

; Toplama işlemi
(display "2 + 3 = ")
(display (+ 2 3))
(newline)

; Bir fonksiyon tanımlama
(define (kare x)
  (* x x))

(display "5'in karesi = ")
(display (kare 5))
(newline)

; Faktöriyel hesaplama (recursive)
(define (faktoriyel n)
  (if (<= n 1)
      1
      (* n (faktoriyel (- n 1)))))

(display "5! = ")
(display (faktoriyel 5))
(newline)


