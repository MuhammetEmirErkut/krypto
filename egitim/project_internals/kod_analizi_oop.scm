; ============================================================================
; EĞİTİM DÖKÜMANI: KRYPTO'da Nesne Yönelimli Programlama (OOP) Nasıl Çalışır?
; ============================================================================
;
; Bu belge `examples/oop_demo.kp` dosyasındaki OOP (Sınıf ve Nesne) yapısının
; Lexer (Okuma) -> Parser (Ağaç Çıkarma) -> Semantic (Anlam) -> Interpreter (Çalıştırma)
; aşamalarından nasıl adım adım geçtiğini anlatır.
;
; Örnek Kodumuz:
; class Dog { 
;    name: string
;    int fun getAge() { return 3; }
; }
; let dog = Dog("Buddy");
; dog.getAge();
;

; ----------------------------------------------------------------------------
; ADIM 1: LEXER VE PARSER (SÖZDİZİMİ AYRIŞTIRICI)
; ----------------------------------------------------------------------------
; 1. Sen 'class Dog' yazdığında Lexer bunu TOKEN-KEYWORD("class") ve
;    TOKEN-IDENTIFIER("Dog") olarak parçalar.
;
; 2. Parser bu tokenleri okur ve (parser.scm içindeki `parse-class-declaration`)
;    bir AST (Soyut Sözdizimi Ağacı) Düğümü oluşturur.
;
; AST şu şekildedir:
; (class-decl 
;    name: "Dog"
;    fields: ( (field name: "name" type: string) )
;    methods: ( (fun-decl name: "getAge" body: ...) )
; )
; Bu aşamada kod çalışmaz, sadece programın taslağı (haritası) çıkartılmıştır.

; ----------------------------------------------------------------------------
; ADIM 2: SEMANTIC ANALYZER (ANLAMBİLİMSEL ANALİZ)
; ----------------------------------------------------------------------------
; Kod çalışmadan hemen önce koddaki mantık ve tip hataları aranır.
; (Bkz: analyzer.scm -> `analyze-class`)
;
; 1. Sınıf Kaydı: Semantic Analyzer "Dog" isimli bir class olduğunu
;    küresel (global) Sembol Tablosuna kaydeder.
;    Böylece kodun ilerisinde `Dog` denildiğinde bunun bir hata olmadığı bilinir.
;
; 2. Sınıf İçi Kapsam (Class Scope):
;    Her class için geçici bir "Oda" (Scope/Kapsam) oluşturulur.
;    "name" değişkeni ve "getAge" fonksiyonu bu odanın içine kaydedilir.
;    Buradaki çok önemli detay: Bu sınıf odasını (Kapsamını)
;    '*class-scopes*' adında özel bir global hafıza kutusuna kaydederiz ki,
;    biri '.getAge()' yazarsa içinde var mı diye kontrol edebilelim.

; ----------------------------------------------------------------------------
; ADIM 3: INTERPRETER (KODUN ÇALIŞTIRILMASI VE NESNENİN YARATILMASI)
; ----------------------------------------------------------------------------
; Ve geldik asıl can alıcı noktaya! 'Dog("Buddy")' çalıştırıldığında ne olur?
; (Bkz: interpreter.scm -> `instantiate-class`)
;
; Olaylar sırasıyla şöyle gerçekleşir:
;
; 1. BOŞ BİR KUTU (ENVIRONMENT) YARATILIR:
;    Sistem hafızada `instance-env` adında yepyeni ve tamamen bu
;    köpeğe (Buddy) özel bir Çevre/Kutu açar.
;
; 2. DEĞİŞKENLER KUTUYA DOLDURULUR:
;    Sınıfın `name: string` gibi "field"ları alınır ve Dog("Buddy") içine 
;    gönderdiğimiz argümanlarla ('Buddy') eşleştirilir.
;    Yani Buddy için yarattığımız özel `instance-env` kutusunun içine 
;    `name = "Buddy"` konur.
;
; 3. METODLARIN SİHRİ (CLOSURE):
;    Sıra geldi fonksiyonlara (methods). `getAge` veya `bark` fonksiyonları
;    alınır ve Krypto function (make-krypto-function) olarak oluşturulur.
;    ANCAK, bu fonksiyonların hafızası olarak Gidip Global ortam değil,
;    az önce oluşturduğumuz ve içinde `name="Buddy"` olan **O KUTU** (`instance-env`) verilir.
;
;    İşte Krypto'da 'this' veya 'self' yazmana gerek kalmadan fonksiyonların 
;    işlev görmesi bu mimari karardan gelir!
;
; 4. "DOG" DEĞİŞKENİNE NESNE ATANIR:
;    Bu işlemler bitince bir paket (Tuple/Liste) oluşturulur:
;    `('krypto-instance "Dog" instance-env)`
;    Bu paket bizim hafızadaki asıl Objeyi temsil eder ve "let dog = ..."
;    ile `dog` kelimesinin içine atılır.

; ----------------------------------------------------------------------------
; ADIM 4: NOKTA (.) İLE BİR FONKSİYONUN (METOD) ÇAĞIRILMASI
; ----------------------------------------------------------------------------
; Kodunda şu satıra geldik: `dog.getAge();`
; (Bkz: interpreter.scm -> `eval-member` ve `eval-call`)
; 
; 1. NOKTA (.) AYRIŞTIRMASI:
;    Interpreter bakar ki ortada Nokta (.) ile bitişik çağrılan bir `eval-member` var.
;    "Noktanın solunda ne var?" diye bakar: `dog`.
;    Gidip hafızadan `dog` kelimesini çıkarır ve yukarıda yarattığımız paketi bulur:
;    `('krypto-instance "Dog" instance-env)`. O süper, bu bir obje der.
;
; 2. BİLGİYİ BULMA:
;    Noktadan sonrası `getAge`. Gidip bu objenin kendi kutusunun (instance-env)
;    içine bakar. İçinde bu metodu bulur.
;
; 3. PARANTEZ () VE ÇALIŞTIRMA:
;    Fonksiyonun sonunda parantez `()` olduğu için bunu normal bir fonksiyon
;    gibi çalıştırır (eval-call).
;    
;    (Fonksiyon çalışırken kendi hafıza kutusuna -instance env- baktığı
;    için, kodun içindeki `age` veya `name` değişkenlerini hemen bulur
;    ve ekrana basar veya return eder).
;
; İşte bu yüzden Lexer'dan geçip nesne olarak vücut bulan sınıfın, 
; nokta ile içindeki bir bilginin çağırılıp hata vermeden tıkır tıkır
; çalışmasının arkasında yatan mucize budur!
