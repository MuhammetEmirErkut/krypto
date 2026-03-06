; Krypto Projesi Adım Adım Turu (Türkçe)
; Çalıştırmak için: chez --script egitim/project_internals/interactive_tour.scm

(import (chezscheme))

; --- YARDIMCI GÖRSELLEŞTİRME FONKSİYONLARI ---

; Renkli başlık yazdırma (Terminal ANSI kodları kullanır)
(define (print-header title)
  (newline)
  (display "=== ") 
  (display title)
  (display " ===")
  (newline))

(define (print-step title desc)
  (newline)
  (display "[ADIM] ") 
  (display title)
  (newline)
  (display desc)
  (newline))

(define (wait-for-user)
  (display "\n(Devam etmek için Enter'a basın...)")
  (read-char))

; --- MODÜL YÜKLEME ---
(print-header "Krypto Modülleri Yükleniyor...")
; Lexer: Metni parçalar
(load "src/lexer/lexer.scm")
; AST: Ağaç yapısını tanımlar
(load "src/parser/ast.scm")
; Parser: Parçaları ağaca dönüştürür
(load "src/parser/parser.scm")
; Semantic: Tipleri kontrol eder
(load "src/semantic/types.scm")
(load "src/semantic/symbol-table.scm")
(load "src/semantic/analyzer.scm")
(import (semantic types))
(import (semantic symbol-table))
(display "Modüller başarıyla yüklendi.\n")

; Örnek kodumuz: Bir değişken tanımlama işlemi
(define sample-code "let x: int = 42;")

; --- ADIM 1: KAYNAK KOD ---
(print-step "1. Kaynak Kodun Okunması" 
            "Derleyicinin ilk gördüğü şey, programcının yazdığı düz metindir (String).")
(display "Girdi Kodu: ")
(display sample-code)
(newline)
; Burada 'sample-code' sadece bir string'dir. Bilgisayar için henüz bir anlamı yoktur.

(wait-for-user)

; --- ADIM 2: LEXER (KELİME ANALIZİ) ---
(print-step "2. Lexical Analysis (Tokenization - Kelime Analizi)" 
            "Mekanizma: src/lexer/lexer.scm -> 'tokenize' fonksiyonu çalışıyor.\nLexer, metni 'Token' adı verilen anlamlı parçalara ayırır.\nBoşlukları atar, sayıları ve kelimeleri kategorize eder.")

; 'tokenize' fonksiyonunu çağırıyoruz. Bu src/lexer/lexer.scm içindedir.
(define tokens (tokenize sample-code))

; Oluşan tokenları ekrana listeleyelim
(display "Oluşan Token Listesi:\n")
(for-each (lambda (t) 
            (display "  -> ") 
            (display t) 
            ; t şuna benzer: (token TOKEN-KEYWORD "let" 1 1)
            (newline)) 
          tokens)

; DETAYLI AÇIKLAMA:
; Lexer "let" kelimesini gördü ve bunun bir TOKEN-KEYWORD olduğunu anladı.
; "x" kelimesini gördü, bunun bir TOKEN-IDENTIFIER (isim) olduğunu anladı.
; "=" işaretini gördü, bunun TOKEN-EQUALS olduğunu anladı.
; "42" gördü, bunun TOKEN-INTEGER olduğunu anladı.

(wait-for-user)

; --- ADIM 3: PARSER (SÖZDİZİM ANALİZİ) ---
(print-step "3. Parsing (Abstract Syntax Tree - Soyut Sözdizim Ağacı)" 
            "Mekanizma: src/parser/parser.scm -> 'parse' fonksiyonu çalışıyor.\n(Ayrıca src/parser/ast.scm içindeki 'make-...' fonksiyonları ile ağaç düğümleri oluşturulur).\nParser, düz token listesini hiyerarşik bir ağaca (AST) dönüştürür.")

; 'parse' fonksiyonu src/parser/parser.scm içindedir.
; Recursive Descent (Özyinelemeli İniş) yöntemiyle çalışır.
(define ast (parse sample-code))

(display "Oluşan AST Yapısı:\n")
(ast-print ast) 
; AST Print çıktısı insan okuyabilir formatta ağacı gösterir.
; (program
;   (let-stmt x ...
;     (integer-literal 42)))
; Gibi bir yapı görmelisiniz.

(wait-for-user)

; --- ADIM 4: SEMANTİK ANALİZ (ANLAM ANALİZİ) ---
(print-step "4. Semantic Analysis & Type Checking (Anlam ve Tip Kontrolü)"
            "Mekanizma: src/semantic/analyzer.scm -> 'analyze' fonksiyonu çalışıyor.\n(Aynı zamanda src/semantic/symbol-table.scm üzerinden 'x' değişkeni belleğe kaydedilir).\nSözdizimi doğru olsa bile kod anlamsız olabilir. Analyzer, tipleri kontrol eder.")

; 'analyze' fonksiyonu src/semantic/analyzer.scm içindedir.
; Symbol Table (Sembol Tablosu) oluşturur ve her değişkenin tipini kaydeder.
(analyze ast)

; Eğer hata olsaydı (mesela 'let x: int = "yazı"') burada hata mesajı görürdük.
; Başarılı olduğu için Symbol Table'a 'x' değişkeni 'int' olarak kaydedildi.

(wait-for-user)

; --- ADIM 5: INTERPRETER (YORUMLAYICI) ---
(print-step "5. Interpreter (Ağaç Yorumlayıcı / Çalıştırıcı)"
            "Mekanizma: src/interpreter/interpreter.scm -> 'interpret' ve 'evaluate' fonksiyonları çalışıyor.\n(Ayrıca src/interpreter/environment.scm içindeki 'env-define' ile değerler RAM'de tutulur).\nHer şey kurallara uygunsa, interpreter AST ağacını gezer ve kodun sonucunu hesaplar.")

; Interpreter modüllerini yüklüyoruz
(load "src/interpreter/environment.scm")
(load "src/interpreter/interpreter.scm")

; Örnek kodu yorumlayıcıya veriyoruz
(display "Interpreter Çalışıyor...\n")
(display "Sonuç:\n")
(interpret ast)

(display "\n(Arka planda 'x' değişkeni için bellekte yer ayrıldı ve içine 42 değeri konuldu.)\n")

(print-header "Tur Tamamlandı!")
(display "Bu scripti düzenleyip 'sample-code' değişkenini değiştirerek farklı kodları deneyebilirsiniz!\nÖrneğin: (define sample-code \"print(10 + 5);\").\n")
