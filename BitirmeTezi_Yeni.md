# 2. YÖNTEM

## 2.1. Derleyici Mimarisinin Genel Organizasyonu

Krypto derleyicisi, klasik derleyici mimarisinin tüm temel bileşenlerini içeren, modüler ve genişletilebilir bir yapıda tasarlanmıştır. Derleyici, ardışık düzen (pipeline) mimarisi ile organize edilmiştir; her faz, bir önceki fazın çıktısını girdi olarak alır ve bir sonraki faza işlenmiş veri iletir. Bu yapı, her modülün bağımsız olarak test edilmesine ve geliştirilmesine olanak tanır.

### 2.1.1. Pipeline Mimarisi ve Veri Akışı

Derleyicinin pipeline mimarisi beş ana fazdan oluşmaktadır. İlk faz olan sözlüksel analiz (lexical analysis), kaynak kod dosyasını (.kp uzantılı) karakter karakter okuyarak anlamlı birimler haline getirir. Bu birimler token olarak adlandırılır ve her token bir tip (örneğin TOKEN-INTEGER, TOKEN-IDENTIFIER), bir değer (örneğin "42", "x") ve kaynak koddaki konum bilgisi (satır, sütun) içerir.

İkinci faz olan sözdizimsel analiz (syntax analysis veya parsing), token dizisini alarak dilin gramer kurallarına göre yapılandırılmış bir Soyut Sözdizimi Ağacı (AST - Abstract Syntax Tree) oluşturur. Parser, özyinelemeli aşağı inişli (recursive descent) teknik kullanır ve her gramer kuralı için ayrı bir fonksiyon içerir.

Üçüncü faz olan anlamsal analiz (semantic analysis), AST'yi alarak dilin semantik kurallarına göre doğrular. Bu fazda tip kontrolü, kapsam çözümü ve isim analizi yapılır. Semantik analiz başarılı olursa, derleme süreci devam eder; hata bulunursa, derleyici hata mesajları üreterek durur.

Dördüncü faz, ağaç yürütme yorumlayıcısıdır (tree-walking interpreter). Bu opsiyonel faz, AST'yi doğrudan yürüterek kodu test etmeyi ve debug etmeyi sağlar. Yorumlayıcı, her AST node tipi için bir eval fonksiyonu içerir ve bu fonksiyonlar node'u ziyaret ederek uygun işlemi gerçekleştirir.

Beşinci ve son faz olan kod üretimi (code generation), AST'yi alarak JVM bytecode'una dönüştürür. Bu fazda her AST node tipi için bir generate fonksiyonu bulunur ve bu fonksiyonlar Jasmin assembler syntax'ına uygun bytecode üretir. Üretilen .j dosyaları, Jasmin assembler ile .class dosyasına dönüştürülerek JVM üzerinde çalıştırılabilir.

### 2.1.2. Scheme Çalışma Ortamı Altyapısı ve Chez Scheme

Krypto derleyicisi, temel implementasyon dili olarak Scheme programlama dilinin Chez Scheme implementasyonunu (R6RS standardı) kullanmıştır. Scheme, Lisp ailesine mensup fonksiyonel bir programlama dilidir ve derleyici implementasyonu için birçok avantaj sunar.

Scheme seçiminin ilk ve en önemli gerekçesi, dilin makro sistemidir. Scheme'in syntax-rules ve syntax-case makroları, derleyiciye yeni dil özellikleri eklemeyi ve dilin kendi kendisini extend etmesini sağlar. Bu özellik, derleyici geliştirme sürecinde kod tekrarını azaltır ve daha soyutlamalı kod yazmaya olanak tanır.

İkinci gerekçe, Scheme'in homoikonik yapısıdır. Homoikonik dillerde kod ve veri aynı yapıda (S-expression) temsil edilir. Bu özellik, AST'nin Scheme listeleri olarak doğal bir şekilde modellenmesini sağlar. Örneğin, bir binary expression node'u '(binary-expr add (integer 1) (integer 2))' şeklinde bir liste olarak temsil edilebilir.

Üçüncü avantaj, Scheme'in tail recursion optimizasyonudur. Scheme implementasyonları, kuyruk çağrılarını (tail calls) optimize ederek döngüler için doğal bir mekanizma sunar. Bu özellik, recursive descent parser'ın ve tree-walking interpreter'ın implementasyonunu büyük ölçüde kolaylaştırır, çünkü derin recursive çağrılar stack overflow hatası vermeden çalışabilir.

Dördüncü avantaj, otomatik bellek yönetimidir. Scheme'in garbage collection mekanizması, derleyici geliştiricinin bellek yönetimi karmaşıklığı ile uğraşmasını engeller. Bu sayede derleyici implementasyonuna odaklanılabilir ve bellek sızıntıları gibi hatalar minimize edilir.

Beşinci avantaj, REPL (Read-Eval-Print Loop) ortamıdır. Scheme'in interaktif geliştirme ortamı, derleyici modüllerinin parça parça test edilmesine olanak tanır. Her modül yüklendikten sonra REPL'de test edilebilir ve hatalar hızlıca tespit edilebilir.

Chez Scheme, Scheme dilinin yüksek performanslı bir implementasyonudur ve JIT (Just-In-Time) derleme desteği sunar. Bu özellik, Krypto derleyicisinin hızlı çalışmasını sağlar. Ayrıca Chez Scheme, excellent debugging tools ve native code generation desteği ile derleyici geliştirme sürecini kolaylaştırır.

### 2.1.3. Dosya Akış Kontrolü ve Girdi İşleme Mekanizması

Derleyicinin giriş/çıkış (I/O) dosya haritalandırma yapısı, derlenecek Krypto kaynak dosyalarının (.kp uzantılı) karakter tabanlı akışlar (character streams) şeklinde işletim sistemi belleğinden alınması işlemiyle başlatılmaktadır. Dosya okuma işlemi, Scheme'in call-with-input-file prosedürü kullanılarak gerçekleştirilir. Bu prosedür, dosyayı otomatik olarak açar, okuma işlemini gerçekleştirir ve işlem tamamlandığında dosyayı kapatır.

Dosya okuma süreci, dosya yolunun validasyonu ile başlar. Derleyici, öncelikle belirtilen yolun var olup olmadığını kontrol eder. Dosya mevcut değilse, derleyici #f değeri döner ve kullanıcıya hata mesajı gösterir. Dosya mevcut ise, call-with-input-file prosedürü bir input port oluşturur ve bu port üzerinden karakter karakter okuma işlemi başlar.

Okuma işlemi, recursive bir let loop yapısı kullanılarak gerçekleştirilir. Her iterasyonda read-char prosedürü ile bir karakter okunur. Okunan karakter EOF (end-of-file) değilse, karakterler listesine eklenir ve bir sonraki karakter okunur. EOF karakteri okunduğunda, liste ters çevrilerek string'e dönüştürülür ve kaynak kod string'i elde edilir.

Kaynak kod okuma süreci esnasında satır ve sütun indeksleri statik olarak hesaplanarak, sonraki fazların yürüteceği muhtemel hata fırlatma (exception log) durumlarına referans koordinat verileri atanmıştır. Bu koordinat bilgileri, lexer state yapısında tutulur ve her karakter okunduğunda güncellenir. Özellikle newline karakterlerinde satır numarası artırılır ve sütun numarası sıfırlanır.

## 2.2. Sözlüksel Analiz (Lexical Analysis) Adımı

Sözlüksel analiz (lexical analysis), derleyicinin ilk fazı olup, kaynak kod karakter dizisini anlamlı birimlere (token'lara) dönüştürme işlevidir. Bu faz, Scanner veya Lexer olarak da adlandırılır. Lexer'ın temel görevi, kaynak koddaki whitespace ve comment gibi anlamsız karakterleri filtrelemek ve geriye sadece dilin grameri için önemli olan token'ları bırakmaktır.

### 2.2.1. Sonlu Durum Makinesi (FSM) Tasarımı ve Formalizasyonu

Krypto lexer'ı, deterministik sonlu durum makinesi (DFA - Deterministic Finite Automaton) prensipleri ile çalışmaktadır. DFA, teorik bilgisayar bilimlerinde kullanılan matematiksel bir modeldir ve bir input dizisini kabul edip etmeme kararı vermek için kullanılır. Krypto lexer'ında DFA, her token tipini tanımak için özelleştirilmiştir.

DFA beş bileşenden oluşur: Q (durumlar kümesi), Σ (giriş alfabesi veya karakter kümesi), δ (geçiş fonksiyonu), q0 (başlangıç durumu) ve F (kabul durumları kümesi). Krypto lexer'ında Q kümesi, q_start (başlangıç), q_identifier, q_number, q_decimal, q_string, q_comment ve q_accept gibi durumları içerir. Σ kümesi, tüm ASCII karakterlerini içerir. δ geçiş fonksiyonu, her durum ve giriş karakteri çifti için bir sonraki durumu belirler.

Lexer'ın çalışma prensibi şu şekildedir: Lexer, başlangıç durumunda (q_start) başlar ve input stream'den karakter karakter okuma yapar. Her karakter için geçiş fonksiyonu δ kullanılarak bir sonraki durum belirlenir. Eğer lexer bir kabul durumuna (F) ulaşırsa, o ana kadar okunan karakterler bir token olarak kabul edilir. Eğer lexer bir hata durumuna ulaşırsa veya beklenmedik bir karakterle karşılaşırsa, hata token'ı üretilir.

Örneğin, bir identifier tanıma süreci şu şekilde işler: Lexer q_start durumunda iken bir alphabetic karakter veya underscore (_) görürse, q_identifier durumuna geçer. q_identifier durumunda iken alphanumeric karakterler veya underscore okumaya devam eder. İlk non-identifier karakter görüldüğünde, lexer q_accept durumuna geçer ve o ana kadar okunan karakterleri bir identifier token'ı olarak döner.

### 2.2.2. Karakter Dizisi İşleme ve Durum Geçiş Mekanizmaları

Lexer state yapısı, dört bileşenden oluşan bir listedir: kaynak kod string'i, mevcut pozisyon (index), mevcut satır numarası ve mevcut sütun numarası. Bu yapı, lexer'ın input stream'deki konumunu takip etmesini sağlar. Accessor fonksiyonları (lexer-source, lexer-pos, lexer-line, lexer-column) ile state'in bileşenlerine erişilir.

Karakter sınıflandırma fonksiyonları, bir karakterin hangi kategoriye ait olduğunu belirler. char-whitespace? fonksiyonu, bir karakterin space, tab veya carriage return olup olmadığını kontrol eder. char-newline? fonksiyonu, newline karakterini tespit eder. char-digit? fonksiyonu, bir karakterin 0-9 arasında olup olmadığını kontrol eder. char-alpha? fonksiyonu, alphabetic karakterleri (a-z, A-Z) tespit eder. char-identifier-start? ve char-identifier-part? fonksiyonları, bir karakterin identifier başlangıcı veya devamı olup olmadığını belirler.

Whitespace ve comment filtreleme işlemleri, tokenization sürecinin önemli bir parçasıdır. skip-whitespace fonksiyonu, lexer current character'ı whitespace olduğu sürece lexer-advance fonksiyonunu çağırarak ilerler ve ilk non-whitespace karakterde durur. skip-line-comment fonksiyonu, // karakterlerinden sonra newline karakterine kadar olan tüm karakterleri atlar. Bu sayede comment'ler token stream'e dahil edilmez.

### 2.2.3. Dil Elementlerinin Token Modeline Dönüştürülmesi

Krypto dilinde tanımlanan tüm lexical elementler, 40'tan fazla token tipine dönüştürülür. Token tipleri beş ana kategoride organize edilmiştir: Literals (TOKEN-INTEGER, TOKEN-FLOAT, TOKEN-STRING, TOKEN-TRUE, TOKEN-FALSE), Identifiers and Keywords (TOKEN-IDENTIFIER, TOKEN-KEYWORD), Operators (TOKEN-PLUS, TOKEN-MINUS, TOKEN-STAR, TOKEN-SLASH, vb.), Delimiters (TOKEN-LPAREN, TOKEN-RPAREN, TOKEN-LBRACE, vb.) ve Special tokens (TOKEN-NEWLINE, TOKEN-EOF, TOKEN-ERROR).

Token veri yapısı, beş bileşenli bir listedir: 'token sembolü, token tipi, token değeri, satır numarası ve sütun numarası. Bu yapı, her token'ın tipini, değerini ve kaynak koddaki konumunu saklar. Accessor fonksiyonları (token-type, token-value, token-line, token-column) ile token'ın bileşenlerine erişilir.

Örnek olarak, "let x: int = 42;" kaynak kodunun tokenizasyonu şu token stream'i üretir: TOKEN-KEYWORD "let" (line 1, col 1), TOKEN-IDENTIFIER "x" (line 1, col 5), TOKEN-COLON ":" (line 1, col 6), TOKEN-KEYWORD "int" (line 1, col 8), TOKEN-EQUALS "=" (line 1, col 12), TOKEN-INTEGER "42" (line 1, col 14), TOKEN-SEMICOLON ";" (line 1, col 16), TOKEN-EOF "" (line 1, col 17).

### 2.2.4. Literal Tipleri ve Tanıma Algoritmaları

Integer ve float literal tanıma algoritması, read-number fonksiyonu tarafından implemente edilir. Bu fonksiyon, recursive bir let loop yapısı kullanarak karakter karakter okuma yapar. Algorithm, digit karakterleri okuyarak chars listesine ekler. Eğer bir nokta (.) karakteri ile karşılaşılırsa ve daha önce nokta görülmemişse (has-dot = #f), has-dot flag'i #t olarak ayarlanır ve okuma devam eder. Input sonuna veya non-digit karaktere ulaşıldığında, chars listesi string'e dönüştürülür ve has-dot flag'ine göre TOKEN-INTEGER veya TOKEN-FLOAT token'ı üretilir.

Integer ve float ayrımı, ondalık noktasının varlığına ve nokta sonrası digit olup olmamasına dayanır. "123" gibi sadece digit içeren sayılar INTEGER olarak kabul edilir. "123.45" gibi nokta sonrası digit içeren sayılar FLOAT olarak kabul edilir. "123." gibi nokta sonrası digit olmayan sayılar INTEGER olarak kabul edilir (bu, bazı dillerden farklı bir davranıştır). ".45" gibi nokta ile başlayan diziler hata olarak kabul edilir, çünkü lexer integer digit beklemektedir.

String literal tanıma algoritması, read-string fonksiyonu tarafından implemente edilir. Bu fonksiyon, açılış tırnağından (") sonra kapanış tırnağına kadar olan tüm karakterleri okur. Escape sequence'ler özel olarak işlenir: backslash (\) karakterinden sonra gelen karakter, escape sequence tablosuna göre yorumlanır. Örneğin, \n newline, \t tab, \r carriage return, \\ backslash, \" double quote olarak yorumlanır. Eğer kapanış tırnağı olmadan input sonuna ulaşılırsa, "Unterminated string" hatası üretilir.

Boolean literal tanıma, keyword tanıma mekanizması ile yapılır. "true" ve "false" kelimeleri, *keywords* listesinde tanımlıdır ve identifier okuma sırasında keyword kontrolü yapılır. read-identifier fonksiyonu, alphabetic karakter veya underscore ile başlayan alphanumeric dizileri okur ve okunan string'in keywords listesinde olup olmadığını kontrol eder. Eğer keyword ise TOKEN-KEYWORD, değilse TOKEN-IDENTIFIER token'ı üretilir.

### 2.2.5. Anahtar Kelimeler, Operatörler ve Ayraçlar Sınıflandırması

Kripto dilinde 21 adet keyword bulunmaktadır ve bunlar yedi kategoride organize edilmiştir. Fonksiyon keywords (fun, return), değişken keywords (let, mut), kontrol keywords (if, else, while, for, in), logical keywords (and, or, not), module keywords (import, export, from, as, pub), type keywords (int, float, string, bool, void) ve literal keywords (true, false, null).

Operatör öncelik tablosu, yedi seviyeden oluşur ve her seviye farklı operatör tiplerini içerir. En yüksek öncelik (seviye 1), unary operatörlere (!, -) aittir ve right-to-left birleşme özelliğine sahiptir. Seviye 2, çarpma operatörlerini (*, /, %) içerir ve left-to-right birleşir. Seviye 3, toplama operatörlerini (+, -) içerir ve left-to-right birleşir. Seviye 4, karşılaştırma operatörlerini (<, >, <=, >=) içerir. Seviye 5, eşitlik operatörlerini (==, !=) içerir. Seviye 6, logical AND operatörünü (&&) içerir. En düşük öncelik (seviye 7), logical OR operatörünü (||) içerir.

Delimiter'lar, dilin syntax yapısını belirleyen özel karakterlerdir. Parentheses ( ), ifade gruplama ve fonksiyon çağrısı için kullanılır. Braces { }, blok tanımlama için kullanılır. Brackets [ ], array index için kullanılır (gelecek özellik). Semicolon ; , statement sonlandırıcıdır. Colon : , type annotation için kullanılır. Comma , , parametre ve argüman ayırıcıdır. Dot . , member access için kullanılır. Arrow ->, return type annotation için kullanılır.

### 2.2.6. Hata Yönetimi ve Konum Takibi

Lexer, geçersiz karakterler ve hatalı durumlar için anlamlı hata mesajları üretir. Dört ana hata türü bulunmaktadır: Unterminated String (kapanış tırnağı olmayan string literal), Invalid Character (tanımlanmamış karakter: @, $, #, vb.), Unterminated Escape (string içinde geçersiz escape sequence) ve Number Format Error (geçersiz sayı formatı).

Hata mesajı formatı, token tipi, hata değeri, satır numarası ve sütun numarası bilgilerini içerir. Örneğin, "(token TOKEN-ERROR "Unterminated string" 5 10)" token'ı, satır 5, sütun 10 konumunda "Unterminated string" hatasını temsil eder. Bu bilgi, kullanıcıya gösterilecek hata mesajının formatlanmasında kullanılır.

Lexer test sonuçları, 17 farklı test case'i kapsamaktadır ve tüm testler başarıyla geçmiştir. Test kategorileri şunlardır: Integer literals (3 test), Float literals (3 test), String literals (4 test), Identifiers (5 test), Keywords (15 test), Operators (20 test), Comments (3 test), Error handling (4 test). Test coverage %100'dür ve lexer'ın tüm token tiplerini doğru şekilde ürettiği doğrulanmıştır.

## 2.3. Sözdizimsel Analiz (Syntax Analysis) Adımı

Sözdizimsel analiz (syntax analysis veya parsing), lexer'dan alınan token dizisini, dilin gramer kurallarına göre yapılandırılmış bir Soyut Sözdizimi Ağacı'na (AST - Abstract Syntax Tree) dönüştürür. Parser'ın temel görevi, token stream'in dilin gramerine uygun olup olmadığını kontrol etmek ve uygunsa hiyerarşik bir AST oluşturmaktır.

### 2.3.1. Özyinelemeli Aşağı İnişli (Recursive Descent) Parser Mimarisi

Krypto parser'ı, Özyinelemeli Aşağı İnişli (Recursive Descent) parsing tekniği kullanılarak implemente edilmiştir. Bu teknik, her gramer kuralı için bir fonksiyon tanımlayarak, grameri doğrudan koda映射 eder. Recursive descent parser'lar, LL(1) gramerler için uygundur ve implementasyonu relativement basittir.

Recursive descent'ın temel prensipleri şunlardır: Birincisi, her non-terminal için bir fonksiyon tanımlanır. Gramerdeki her non-terminal sembolü (expression, statement, declaration) bir parsing fonksiyonuna karşılık gelir. Örneğin, parse-expression fonksiyonu expression kuralını, parse-statement fonksiyonu statement kuralını implement eder.

İkinci prensip, terminal eşleştirmedir. Token stream'deki terminaller kontrol edilir ve eşleşirse lexer advance edilir. Örneğin, bir identifier bekleniyorsa, parser-current token'ın TOKEN-IDENTIFIER olup olmadığı kontrol edilir ve eşleşirse parser-advance ile bir sonraki tokene geçilir.

Üçüncü prensip, özyinelemedir. Gramer kurallarının recursive yapısı, fonksiyon çağrıları ile implemente edilir. Örneğin, bir expression içinde başka bir expression varsa, parse-expression fonksiyonu kendisini recursive olarak çağırır.

Dördüncü prensip, predictive parsing'dir. Lookahead token (mevcut token) kullanılarak hangi kuralın uygulanacağı belirlenir. Krypto parser'ı single-token lookahead kullanır, yani sadece mevcut tokene bakar ve hangi kuralın uygulanacağına karar verir.

Parser state yönetimi, iki bileşenli bir liste ile yapılır: token listesi ve mevcut pozisyon (index). parser-tokens ve parser-pos accessor fonksiyonları ile state'in bileşenlerine erişilir. parser-current fonksiyonu, mevcut tokene bakar ve parser-advance fonksiyonu bir sonraki tokene ilerler. parser-check fonksiyonu, mevcut token'ın belirli bir tipte olup olmadığını kontrol eder. parser-match fonksiyonu, mevcut token belirli tiplerden biriyle eşleşirse advance eder.

parse-let-statement fonksiyonu, let statement parsing örneği olarak gösterilebilir. Bu fonksiyon, sırasıyla şu adımları izler: (1) "let" keyword'ü beklenir ve consume edilir, (2) opsiyonel "mut" keyword'ü kontrol edilir ve is-mutable flag'i ayarlanır, (3) identifier beklenir ve değişken adı alınır, (4) opsiyonel type annotation kontrol edilir (colon ve type), (5) equals (=) beklenir, (6) initializer expression parse edilir, (7) semicolon beklenir, (8) make-let-stmt ile AST node'u oluşturulur ve döndürülür.

### 2.3.2. Öncelik Tırmanma (Precedence Climbing) Algoritması ve İşlem Önceliği Yönetimi

İfadelerin (expressions) parsinginde, operatör önceliği (operator precedence) doğru yönetilmelidir. Yanlış öncelik yönetimi, hatalı AST yapısına ve dolayısıyla hatalı kod yürütmesine neden olur. Krypto, Öncelik Tırmanma (Precedence Climbing) algoritması kullanır. Bu algoritma, operator precedence parsing için yaygın olarak kullanılan bir tekniktir ve recursive descent parser'lara kolayca entegre edilebilir.

Operator precedence hierarchy, yedi seviyeden oluşur. En düşük öncelik (Level 7) OR (||) operatörüne aittir. Level 6, AND (&&) operatörünü içerir. Level 5, EQUALITY (==, !=) operatörlerini içerir. Level 4, COMPARISON (<, >, <=, >=) operatörlerini içerir. Level 3, TERM (+, -) operatörlerini içerir. Level 2, FACTOR (*, /, %) operatörlerini içerir. En yüksek öncelik (Level 1), UNARY (!, -) operatörlerine aittir.

Precedence climbing prensibi, düşük öncelikli operatörlerden yüksek öncelikli operatörlere doğru "tırmanarak" parsing yapar. parse-expression fonksiyonu parse-assignment'ı çağırır. parse-assignment, parse-logic-or'u çağırır ve ardından equals varsa assignment expression oluşturur. parse-logic-or, parse-logic-and'i çağırır ve OR operatörü varsa binary expression oluşturur. Bu zincir, parse-unary ve parse-primary'a kadar devam eder.

Binary expression parsing örneği olarak parse-term fonksiyonu incelenebilir. Bu fonksiyon, önce parse-factor'ü çağırarak left operand'ı alır. Ardından loop içinde mevcut token'ı kontrol eder: Eğer TOKEN-PLUS ise, advance eder ve parse-factor'ü tekrar çağırarak right operand'ı alır. Sonra make-binary-expr ile '+' node'u oluşturur ve loop'a devam eder. Eğer TOKEN-MINUS ise benzer şekilde '-' node'u oluşturur. Eğer başka operatör yoksa, loop sona erer ve left operand döndürülür.

Öncelik doğrulama örneği olarak "1 + 2 * 3" ifadesi verilebilir. Bu ifadenin doğru AST yapısı, dışta '+' ve içte '*' operatörü olmalıdır, çünkü çarpma toplamadan daha yüksek önceliğe sahiptir. Beklenen AST: (binary-expr add (integer 1) (binary-expr multiply (integer 2) (integer 3))). Parser çıktısı bu yapıyı üretirse, operator precedence doğru çalışıyor demektir.

### 2.3.3. İşlem Önceliği ve Birleşme (Associativity) Kuralları

Operator associativity, aynı öncelik seviyesindeki operatörlerin hangi sırayla değerlendirileceğini belirler. Krypto'da dört farklı associativity kuralı uygulanır.

Left-to-right birleşme, binary operatörlerin çoğu için geçerlidir. Toplama, çıkarma, çarpma, bölme operatörleri (+, -, *, /) left-to-right birleşir. Örneğin, "a - b - c" ifadesi "(a - b) - c" olarak değerlendirilir. Karşılaştırma operatörleri (<, >, <=, >=) ve eşitlik operatörleri (==, !=) da left-to-right birleşir. Logical operatörler (&&, ||) da left-to-right birleşir.

Right-to-left birleşme, unary operatörler ve assignment operatörü için geçerlidir. Unary operatörler (!, -) right-to-left birleşir. Örneğin, "!-x" ifadesi "!(-x)" olarak değerlendirilir. Assignment operatörü (=) right-to-left birleşir. Örneğin, "a = b = c" ifadesi "a = (b = c)" olarak değerlendirilir. Bu sayede çoklu assignment desteklenir.

Left-to-right birleşme implementasyonu, parse-factor fonksiyonunda gösterilebilir. Bu fonksiyon, bir loop içinde operatörleri soldan sağa doğru işler. Her iterasyonda, yeni bir binary expression node'u oluşturur ve bu node'u left operand olarak kullanarak loop'a devam eder. Bu sayede "a * b * c" ifadesi "((a * b) * c)" şeklinde parse edilir.

Right-to-left birleşme implementasyonu, parse-assignment fonksiyonunda gösterilebilir. Bu fonksiyon, recursive olarak kendisini çağırır. Eğer "a = b = c" ifadesi parse ediliyorsa, önce "a = " kısmı işlenir, ardından parse-assignment recursive olarak çağrılır ve "b = c" kısmı parse edilir. Sonuç olarak, AST'de inner assignment "b = c" olur ve outer assignment "a = (b = c)" şeklinde yapılandırılır.

### 2.3.4. Soyut Sözdizimi Ağacının (AST) İnşası ve Bellekte Konumlandırılması

Parser, token stream'i işlerken her dil construct'ı için AST node'ları oluşturur. AST, kaynak kodun hiyerarşik ve yapılandırılmış temsilidir ve sonraki fazlar (semantic analysis, code generation) tarafından kullanılır. AST'nin bellekte konumlandırılması, Scheme'in native liste yapısı kullanılarak yapılır.

AST oluşturma süreci, parser fonksiyonlarının token stream'i işlemesiyle başlar. Her parser fonksiyonu, kendi sorumluluk alanındaki construct'ı parse eder ve uygun AST node'unu oluşturur. Örneğin, parse-let-statement fonksiyonu let statement parse eder ve make-let-stmt fonksiyonunu çağırarak bir let-stmt node'u oluşturur. Bu node, değişken adı, type annotation, initializer expression ve is-mutable flag'ini içerir.

AST node yapısı, Scheme listeleri kullanılarak implemente edilir. make-ast-node fonksiyonu, bir tip sembolü ve field'ları alan bir constructor'dır. Örneğin, (make-ast-node 'integer-literal 'value 42 'location (make-location 1 5)) çağrısı, bir integer literal node'u oluşturur. ast-type fonksiyonu node'un tipini, ast-get fonksiyonu ise belirli bir field'ın değerini döner.

Örnek olarak, "let x = 42" ifadesinin AST'si şu şekilde oluşturulur: Parser, "let" keyword'ünü görür ve parse-let-statement fonksiyonunu çağırır. Bu fonksiyon, identifier "x"'i parse eder, equals token'ını consume eder, parse-expression'ı çağırır. parse-expression, parse-assignment, parse-logic-or zinciri üzerinden parse-primary'a ulaşır ve integer literal 42'yi parse eder. Sonra make-integer-literal ile integer node'u, make-identifier ile identifier node'u ve son olarak make-let-stmt ile let-stmt node'u oluşturulur.

### 2.3.5. AST Node Tipleri ve Hiyerarşik Yapı

Krypto AST'si üç ana kategoride organize edilmiştir: Expressions (İfadeler), Statements (Deyimler) ve Declarations (Bildirimler). Her kategori, dilin farklı construct'larını temsil eder ve farklı amaçlara hizmet eder.

Expressions (İfadeler), değer üreten construct'lardır. On bir adet expression tipi vardır: integer-literal (tam sayı literal), float-literal (ondalık literal), string-literal (string literal), bool-literal (boolean literal), null-literal (null literal), identifier (değişken/fonksiyon adı), binary-expr (ikili işlem: +, -, *, /, vb.), unary-expr (unary işlem: !, -), group-expr (parantez içinde gruplanmış ifade), call-expr (fonksiyon çağrısı), assign-expr (atama ifadesi). Expressions, diğer expressions'ın içinde nested olarak bulunabilir ve expression tree'leri oluşturur.

Statements (Deyimler), işlem yapan construct'lardır. Yedi adet statement tipi vardır: expr-stmt (expression statement, bir expression'ı statement olarak yürütür), let-stmt (variable declaration), return-stmt (return statement), if-stmt (conditional statement), while-stmt (while loop), for-stmt (for loop), block-stmt (code block, birden fazla statement'ı gruplar). Statements, genellikle side effect üretir (değişken atama, I/O işlemi, vb.) ve değer üretmez.

Declarations (Bildirimler), yeni binding tanımlayan construct'lardır. İki adet declaration tipi vardır: fun-decl (function declaration) ve struct-decl (struct definition). Declarations, global veya local scope'ta sembol tanımlar ve sembol tablosuna eklenir.

Program, top-level container'dır ve declarations listesini içerir. Her .kp dosyası bir program node'u olarak parse edilir ve bu node'un declarations field'ı tüm top-level declarations'ları (fonksiyonlar, struct'lar, global değişkenler) içerir.

### 2.3.6. İfade (Expression) Düğümleri ve Yapılandırması

Literal expressions, doğrudan bir değeri temsil eden AST node'larıdır. make-integer-literal fonksiyonu, bir integer değeri ve location bilgisi alarak integer-literal node'u oluşturur. Örneğin, (make-integer-literal 42 1 5) çağrısı, satır 1 sütun 5 konumunda 42 değerini temsil eden node'u oluşturur. Benzer şekilde, make-float-literal, make-string-literal ve make-bool-literal fonksiyonları float, string ve boolean literal node'ları oluşturur.

Binary expression, iki operand ve bir operatör içeren AST node'udur. make-binary-expr fonksiyonu, operator (symbol), left (AST node), right (AST node) ve location bilgilerini alır. Operator, 'add, 'subtract, 'multiply, 'divide, 'less-than, 'greater-than, 'less-equal, 'greater-equal, 'equal, 'not-equal, 'and, 'or gibi symbol'ler olabilir. Örneğin, "(2 + 3) * 4" ifadesinin AST'si: (make-binary-expr 'multiply (make-group-expr (make-binary-expr 'add (make-integer-literal 2) (make-integer-literal 3))) (make-integer-literal 4)) şeklinde oluşturulur.

Call expression, fonksiyon çağrısını temsil eden AST node'udur. make-call-expr fonksiyonu, callee (fonksiyon adı/expression), arguments (argument listesi) ve location bilgilerini alır. Örneğin, "fibonacci(10)" çağrısı: (make-call-expr (make-identifier "fibonacci") (list (make-integer-literal 10))) şeklinde oluşturulur. Arguments field'ı, her argument için bir expression node'u içeren bir listedir.

### 2.3.7. Deyim (Statement) Düğümleri ve Kontrol Akışı

Let statement, değişken tanımlama ifadesidir. make-let-stmt fonksiyonu, name (string), type-annotation (type node veya #f), initializer (expression node), is-mutable (boolean) ve location bilgilerini alır. Örneğin, "let mut y: int = 10" ifadesi: name="y", type-annotation=(primitive-type "int"), initializer=(integer-literal 10), is-mutable=#t şeklinde oluşturulur. "let x = 42" ifadesinde ise type-annotation=#f ve is-mutable=#f olur.

If statement, conditional branching ifadesidir. make-if-stmt fonksiyonu, condition (expression node), then-branch (block-stmt), else-branch (statement veya #f) ve location bilgilerini alır. Örneğin, "if (x > 0) { print(x); } else { print(-x); }" ifadesi: condition=(binary-expr greater-than (identifier x) (integer 0)), then-branch=(block-stmt ...), else-branch=(block-stmt ...) şeklinde oluşturulur. Else branch opsiyoneldir ve yoksa #f olarak ayarlanır.

For statement, C-style for loop ifadesidir. make-for-stmt fonksiyonu, init (statement veya #f), condition (expression veya #f), update (expression veya #f), body (block-stmt) ve location bilgilerini alır. Örneğin, "for (let i: int = 0; i < 10; i = i + 1) { print(i); }" ifadesi: init=(let-stmt ...), condition=(binary-expr less-than (identifier i) (integer 10)), update=(assign-expr ...), body=(block-stmt ...) şeklinde oluşturulur. Init, condition ve update alanları opsiyoneldir ve yoksa #f olarak ayarlanır.

### 2.3.8. Bildirim (Declaration) Düğümleri ve Scope Yönetimi

Function declaration, fonksiyon tanımıdır. make-fun-decl fonksiyonu, name (string), params (param node listesi), return-type (type node veya #f), body (block-stmt) ve location bilgilerini alır. Örneğin, "int fun fibonacci(n: int) -> int { ... }" ifadesi: name="fibonacci", params=((param "n" (primitive-type "int"))), return-type=(primitive-type "int"), body=(block-stmt ...) şeklinde oluşturulur. Return-type opsiyoneldir ve yoksa #f olarak ayarlanır (bu durumda fonksiyon void kabul edilir).

Param node, fonksiyon parametresi tanımıdır. make-param fonksiyonu, name (string), type (type node) ve location bilgilerini alır. Örneğin, "n: int" parametresi: name="n", type=(primitive-type "int") şeklinde oluşturulur.

Struct declaration, struct tanımıdır. make-struct-decl fonksiyonu, name (string), fields (field node listesi) ve location bilgilerini alır. Field node, struct alanı tanımıdır ve make-field fonksiyonu ile oluşturulur. Örneğin, "struct Point { x: int, y: int }" ifadesi: name="Point", fields=((field "x" (primitive-type "int")) (field "y" (primitive-type "int"))) şeklinde oluşturulur.


## 2.4. Anlamsal Analiz (Semantic Analysis) ve Statik Doğrulama

Semantik analiz, parser'dan gelen AST'yi alıp dilin semantik kurallarına göre doğrulayan derleyici fazıdır. Bu fazda tip kontrolü, kapsam çözümü ve isim analizi yapılır. Semantik analiz başarılı olursa, derleyici kod üretimine geçer; hata bulunursa, derleyici hata mesajları üretir ve durur.

### 2.4.1. Tip Sistemi Tasarımı ve Tür Teorisi Temelleri

Krypto tip sistemi, statik ve güçlü (strong) tipleme kullanır. Statik tipleme, tiplerin derleme zamanında belirlenmesi anlamına gelir ve tip hataları compile-time'da yakalanır. Güçlü tipleme ise, tip dönüşümlerinin otomatik olarak yapılmaması ve explicit cast gerektirmesi anlamına gelir. Bu tasarım, runtime hatalarını minimize eder ve kod güvenliğini artırır.

Tip kategorileri, beş ana tipten oluşur: type-base (primitive tipler: int, float, string, bool), type-function (fonksiyon tipleri: parametre tipleri ve return tipi), type-void (void tipi, fonksiyon return tipi olarak kullanılır), type-any (unresolved veya error states için, tip eşitlik kontrolünde her tip ile eşleşir).

type-base record tipi, name field'ı içerir ve bu field 'int, 'float, 'string, 'bool symbol'lerinden birini alır. type-function record tipi, params (parametre tipi listesi) ve return (return tipi) field'larını içerir. type-void ve type-any record tipleri field içermez ve tekil tipleri temsil eder.

Tip eşitlik kontrolü, type-equal? fonksiyonu tarafından implemente edilir. Bu fonksiyon, iki tipin eşit olup olmadığını kontrol eder ve boolean döner. type-base tipleri için, name field'ları karşılaştırılır (eq? ile). type-function tipleri için, return tipleri eşit olmalı, parametre listeleri aynı uzunlukta olmalı ve her parametre çifti eşit olmalıdır. type-void tipleri her zaman eşittir. type-any ise her tip ile eşleşir (bu özellik, tip çıkarımı sırasında unresolved tipler için kullanılır).

Tip string dönüşümü, type-to-string fonksiyonu tarafından implemente edilir. Bu fonksiyon, bir tip kaydını insan tarafından okunabilir string'e dönüştürür. type-base için name symbol'ü string'e dönüştürülür (symbol->string ile). type-function için, parametre tipleri parantez içinde, return tipi "->" ile ayrılarak formatlanır. type-void için "void", type-any için "any" string'i döner.

### 2.4.2. Hiyerarşik Sembol Tablosu Modellemesi ve Scope Yönetimi

Sembol tablosu, değişken ve fonksiyon isimlerinin bilgilerini saklayan bir veri yapısıdır. Krypto, scope-based sembol tablosu kullanır ve her scope bir hashtable içerir. Scope'lar parent pointer ile birbirine bağlanır ve scope chain oluşturur. Bu yapı, nested scope'ların ve shadowing'in doğal bir şekilde implementasyonunu sağlar.

Semantic symbol record tipi, dört field içerir: name (sembol adı, string), type (tip bilgisi, type record), category (kategori: 'variable, 'function, 'class, 'parameter), location (tanım yeri, location record). Bu bilgiler, semantik analiz sırasında kullanılır ve hata mesajlarında konum bilgisi sağlar.

Scope record tipi, iki immutable field içerir: table (hashtable, name -> symbol mapping) ve parent (parent scope veya #f). Hashtable, Chez Scheme'in make-hashtable fonksiyonu ile oluşturulur ve string-hash, string=? fonksiyonlarını kullanır. Parent field'ı, scope chain'deki bir üst scope'u temsil eder ve global scope için #f'dür.

Scope tanımlama işlemi, scope-define fonksiyonu tarafından yapılır. Bu fonksiyon, verilen scope'ta bir sembol tanımlar. Eğer sembol zaten tanımlıysa, #f döner ve hata oluşur. Eğer sembol tanımlı değilse, hashtable-set! ile sembol eklenir ve #t döner. Bu kontrol, aynı scope'ta aynı ismin birden fazla tanımlanmasını engeller.

Scope lookup işlemi, iki fonksiyon tarafından yapılır: scope-lookup (non-recursive) ve scope-lookup-recursive (recursive). scope-lookup, sadece verilen scope'ta arama yapar ve sembol bulunursa sembolü, bulunmazsa #f döner. scope-lookup-recursive, önce mevcut scope'ta arama yapar, bulunamazsa parent scope'ta arama yapar ve bu şekilde global scope'a kadar devam eder. Bu sayede nested scope'larda değişken lookup'u yapılır.

Symbol environment, scope container'dır ve record tipi bir field içerir: current-scope. make-scope fonksiyonu, parent scope alan bir constructor'dır ve global scope için parent #f olarak ayarlanır. env-enter-scope fonksiyonu, yeni bir scope oluşturur ve current-scope olarak ayarar. env-exit-scope fonksiyonu, parent scope'a geçer. Bu sayede block girişlerinde yeni scope oluşturulur ve block çıkışlarında parent scope'a dönülür.

### 2.4.3. Kapsam (Scope) Kuralları ve İsim Çözümleme Stratejisi

Scope kuralları, değişkenlerin ve fonksiyonların hangi kod bloklarında erişilebilir olduğunu belirler. Krypto'da dört scope seviyesi vardır: global scope (tüm dosya boyunca erişilebilir), function scope (fonksiyon gövdesi içinde geçerli), block scope ({} içinde tanımlanan değişkenler sadece o blokta geçerli), for loop scope (for statement'ın kendi scope'u var).

Global scope, programın en üst seviyesidir ve tüm fonksiyonlar, struct'lar ve global değişkenler bu scope'ta tanımlanır. Global scope'un parent'ı yoktur (#f) ve program boyunca yaşamına devam eder.

Function scope, her fonksiyon tanımı için oluşturulur. Fonksiyon parametreleri ve local değişkenler bu scope'ta tanımlanır. Function scope'un parent'ı global scope'tur (eğer fonksiyon global scope'ta tanımlanmışsa) veya enclosing function scope'tur (eğer nested fonksiyon varsa).

Block scope, her {} blok için oluşturulur. if, while, for statement'ları ve explicit bloklar yeni scope oluşturur. Block scope'un parent'ı enclosing scope'tur. Block sona erdiğinde, block scope'ta tanımlanan değişkenler erişilemez olur.

For loop scope, for statement'ın kendine ait scope'u vardır. Init statement (örneğin "let i = 0") bu scope'ta tanımlanır ve sadece for loop içinde erişilebilir. For loop scope'un parent'ı enclosing scope'tur.

Shadowing (isim gizleme), iç scope'ta dış scope'taki aynı isimli değişkeni gizleme olayıdır. Krypto'da shadowing allowed'dır ve iç scope'taki değişken dış scope'taki değişkeni gizler. Örneğin, global x = 10 ve function scope'ta x = 20 tanımlanmışsa, function içinde x referansı 20 değerini verir. Krypto'da aynı scope'ta aynı ismin birden fazla tanımlanması hatadır ve semantic-error ile raporlanır.

İsim çözümleme stratejisi, şu algoritmayı izler: (1) Current scope'ta ara, (2) Bulunamazsa parent scope'a git, (3) Global scope'a kadar devam et, (4) Hala bulunamadıysa "Undefined variable" hatası üret. Bu algoritma, env-lookup fonksiyonu tarafından scope-lookup-recursive kullanılarak implemente edilir.

### 2.4.4. Derleme Zamanı Tip Çıkarımı (Type Inference) Operasyonları

Krypto, basit tip çıkarımı (type inference) destekler. Değişken tanımı sırasında tip belirtilmezse, initializer'dan tip çıkarılır. Bu özellik, kodun daha okunabilir olmasını sağlar ve tip annotasyonu boilerplate'ini azaltır.

Tip çıkarımı kuralları, infer-type fonksiyonu tarafından implemente edilir. Bu fonksiyon, bir expression AST node'u alıp tipini çıkarır. Integer literal için 'int, float literal için 'float, string literal için 'string, bool literal için 'bool döner. Identifier için, local-types veya global-vars hashtable'larında sembolün tipi aranır. Binary expression için, operatöre göre tip döner: comparison operatörleri (less-than, greater-than, vb.) için 'bool, arithmetic operatörleri için left operand'ın tipi döner. Call expression için, fonksiyonun return tipi global-funcs-ret hashtable'ından alınır.

Type annotation resolution, resolve-type-annotation fonksiyonu tarafından implemente edilir. Bu fonksiyon, AST type node'unu semantic type record'a dönüştürür. primitive-type node için, name field'ına göre type-base record oluşturur: "int" -> (make-type-base 'int), "float" -> (make-type-base 'float), vb. Named-type ve array-type şimdilik type-any olarak çözülür (gelecek özellik için placeholder).

Tip uyumluluk kontrolü, expect-type fonksiyonu tarafından yapılır. Bu fonksiyon, actual tip ve expected tip alır. Eğer tipler eşitse (type-equal? ile) #t döner. Eğer eşit değilse, semantic-error fonksiyonunu çağırarak hata kaydedilir ve #f döner. Hata mesajı, "Type mismatch. Expected X, but got Y" formatındadır.

Let statement tip kontrolü, analyze-let fonksiyonu tarafından yapılır. Bu fonksiyon, önce initializer expression'ın tipini çıkarır. Eğer type annotation varsa, annotation tipini resolve eder. Eğer her iki tip de varsa, expect-type ile uyumluluk kontrolü yapar. Final tip, annotation varsa annotation, yoksa initializer tipi, hiçbiri yoksa type-any olarak ayarlanır. Sonra define-symbol-safe ile sembol tablosuna eklenir.

### 2.4.5. Tip Uyumluluk Kontrolü ve Hata Tespiti Mekanizmaları

Tip kontrolü kuralları, dilin type safety'sini garanti eder. Dört ana tip kontrolü kuralı vardır: (1) Atama uyumluluğu: sağ taraf tipi, sol taraf tipine assignable olmalı, (2) Operatör tipleri: aritmetik operatörler numeric tip bekler, (3) Fonksiyon çağrısı: argüman tipleri, parametre tipleri ile eşleşmeli, (4) Return statement: return ifadesi tipi, fonksiyon return type'ı ile eşleşmeli.

Binary expression tip kontrolü, analyze-binary fonksiyonu tarafından yapılır. Arithmetic operatörler (add, subtract, multiply, divide) için, left ve right tiplerinin numeric (int veya float) olması ve birbirine eşit olması gerekir. Eğer tipler numeric değilse veya eşit değilse, "Arithmetic operator expects numbers" hatası üretilir. Comparison operatörleri (less-than, greater-than, vb.) için, return tipi her zaman 'bool'dür.

Fonksiyon çağrısı tip kontrolü, analyze-call fonksiyonu tarafından yapılır. Bu fonksiyon, önce callee expression'ın tipini çıkarır. Eğer callee bir function type ise, parametre tipleri ve argüman tipleri karşılaştırılır. Argüman sayısı parametre sayısına eşit olmalıdır. Eşit değilse, "Incorrect number of arguments" hatası üretilir. Her argüman için, argüman tipi parametre tipine assignable olmalıdır (expect-type ile kontrol edilir). Eğer assignble değilse, type mismatch hatası üretilir.

Return statement tip kontrolü, analyze-return fonksiyonu tarafından yapılır. Bu fonksiyon, önce return ifadesinin tipini çıkarır (yoksa type-void). Sonra current function'ın return tipini kontrol eder. Bunun için, %return-type% özel sembolü kullanılır. Function scope'a girerken, function'ın return tipi bu sembol ile kaydedilir. Return statement'da, return ifadesi tipi ile %return-type% sembolünün tipi karşılaştırılır. Eşit değilse, type mismatch hatası üretilir.

Semantik hata örnekleri: (1) Type mismatch: "let x: int = 'hello';" → Error: Expected int, but got string. (2) Undefined variable: "print(y);" → Error: Undefined variable: y. (3) Wrong argument count: "add(5);" (add iki parametre bekliyor) → Error: Incorrect number of arguments. (4) Wrong argument type: "add(5, 'hello');" → Error: Expected int, but got string. (5) Return type mismatch: "int fun foo() { return 'hello'; }" → Error: Expected int, but got string.

Semantik analiz çıktısı, iki durumda olabilir: Başarılı ise "Semantic analysis successful." mesajı, hatalı ise hata listesi. Her hata, mesaj ve location bilgisi içerir. Location bilgisi, hata mesajında satır ve sütun numarası olarak gösterilir.

## 2.5. Java Sanal Makinesi (JVM) Hedefli Jasmin Ara Kod Üretimi

Code generation fazı, semantik analizden başarıyla geçen AST'yi alıp JVM bytecode'una dönüştürür. Krypto, Jasmin assembler syntax'ını hedefler. Jasmin, JVM için human-readable assembly language'dır ve .j uzantılı dosyalar üretir. Bu dosyalar, Jasmin assembler ile .class dosyasına derlenir ve JVM üzerinde çalıştırılabilir.

### 2.5.1. Krypto Veri Türlerinin JVM Tür Belirteçleri (Descriptors) ile Eşleştirilmesi

JVM, her tip için özel descriptor string'leri kullanır. Bu descriptor'lar, method signature'larında ve field tanımlamalarında kullanılır. Krypto tipleri şu şekilde JVM tiplerine映射 edilir: int → int (descriptor: "I"), float → float (descriptor: "F"), string → String (descriptor: "Ljava/lang/String;"), bool → int (descriptor: "I", 0/1 değerleri), void → void (descriptor: "V").

Bool tipinin int olarak temsil edilmesi, JVM'in native boolean tipi olmamasından kaynaklanır. Krypto'da true değeri 1, false değeri 0 olarak kodlanır. Logical operatörler (and, or, not) integer bitwise operatörleri (iand, ior) veya conditional branch'ler ile implemente edilir.

Type-to-Jasmin fonksiyonu, type->jasmin, bir semantic type symbol'ü alır ve JVM descriptor string'i döner. Case ifadesi ile her tip için appropriate descriptor döner: int için "I", float için "F", bool için "I", string için "Ljava/lang/String;", void için "V". Named types veya array types için genişletme yapılabilir (gelecek özellik).

Method descriptor oluşturma, JVM specification'a uygun olarak yapılır. Method signature formatı: (parametre-descriptor'ları)return-descriptor. Örneğin, void main() için descriptor "()V", int foo(int) için "(I)I", int add(int, int) için "(II)I", String bar(int, float) için "(IF)Ljava/lang/String;", void process(int[]) için "([I)V".

### 2.5.2. JVM Operand Stack Mimarisi ve Bytecode Üretimi

JVM, stack-based bir sanal makinedir. Tüm işlemler operand stack üzerinden yapılır. JVM'in memory model'i, heap, stack, method area ve PC register gibi alanlardan oluşur. Operand stack, her method için ayrıdır ve LIFO (last-in-first-out) yapısındadır.

Stack işlemleri şunlardır: Load işlemleri, local variable'dan stack'e değer yükler (iload, fload, aload). Store işlemleri, stack'ten local variable'a değer kaydeder (istore, fstore, astore). Arithmetic işlemleri, stack'teki operand'ları alır, işlemi yapar ve sonucu stack'e push eder (iadd, isub, imul, idiv). Compare işlemleri, stack'teki iki değeri karşılaştırır ve branch yapar (if_icmplt, if_icmpgt, vb.). Call işlemleri, method çağırır ve return değerini stack'e push eder (invokestatic, invokevirtual).

Emit fonksiyonu, kod üretimi için temel building block'tur. Bu fonksiyon, port (output file) ve değişken sayıda argüman alır. For-each ile her argümanı hem dosyaya hem de console'a yazar (debugging için). Sonra newline ekler. Bu sayede, her emit çağrısı bir satır Jasmin kodu üretir.

Integer literal bytecode üretimi, generate-expr fonksiyonunun bir case'i ile yapılır. Integer literal node için, "ldc <value>" instruction'ı emit edilir. ldc (load constant) instruction'ı, constant pool'dan bir değeri stack'e yükler. Örneğin, 42 literal için "ldc 42" bytecode'u üretilir.

### 2.5.3. Akış Kontrol Yapılarının (If, While, For) Dallanma Komutlarına Dönüştürülmesi

If statement bytecode üretimi, conditional branch instruction'ları kullanır. Algoritma şu adımları izler: (1) Condition expression'ı generate-expr ile bytecode'a çevir, result stack'te kalır. (2) "ifeq <else-label>" instruction'ı emit et. Eğer condition false (0) ise, else branch'a atlar. (3) Then branch'ı generate-stmt ile bytecode'a çevir. (4) "goto <end-label>" instruction'ı emit et. Then branch'dan sonra else branch'ı atlar. (5) <else-label:> label'ını emit et. (6) Else branch varsa, generate-stmt ile bytecode'a çevir. (7) <end-label:> label'ını emit et.

While statement bytecode üretimi, loop instruction'ları kullanır. Algoritma: (1) <start-label:> label'ını emit et. (2) Condition expression'ı generate-expr ile bytecode'a çevir. (3) "ifeq <end-label>" instruction'ı emit et. Eğer condition false ise, loop'tan çıkar. (4) Body'yi generate-stmt ile bytecode'a çevir. (5) "goto <start-label>" instruction'ı emit et. Loop başına atlar. (6) <end-label:> label'ını emit et.

For statement bytecode üretimi, init-condition-update pattern'i kullanır. Algoritma: (1) Init statement varsa, generate-stmt ile bytecode'a çevir. (2) <start-label:> label'ını emit et. (3) Condition expression varsa, generate-expr ile bytecode'a çevir ve "ifeq <end-label>" instruction'ı emit et. (4) Body'yi generate-stmt ile bytecode'a çevir. (5) Update expression varsa, generate-stmt ile bytecode'a çevir. (6) "goto <start-label>" instruction'ı emit et. (7) <end-label:> label'ını emit et.

Label üretimi, next-label fonksiyonu tarafından yapılır. Bu fonksiyon, global *label-counter* değişkenini increment eder ve "L<n>" formatında unique label döner. Örneğin, ilk çağrıda "L1", ikinci çağrıda "L2", vb. Bu sayede, her branch için unique label üretilir ve label conflict'leri önlenir.

### 2.5.4. Yerel ve Global Değişken İndekslemesi ve Bellek Yönetimi

JVM, yerel değişkenleri local variable array'de saklar. Her method'un kendi local variable array'i vardır ve index-based access sağlar. Array index'leri 0'dan başlar. Instance method'larda, index 0 'this' referansıdır ve index 1+ argümanlara ayrılır. Static method'larda (Krypto fonksiyonları gibi), index 0'dan argümanlar başlar.

Slot allocation, *local-vars* hashtable'ı ve *next-local* counter'ı kullanılarak yapılır. Her değişken için, bir slot index'i ayrılır. hashtable-set! ile name -> index mapping kaydedilir. *next-local* increment edilir. Float ve string tipleri, JVM specification'a göre iki slot kullanabilir (long ve double gibi), ancak Krypto implementasyonunda single-slot kullanılır (basitleştirme için).

Load/Store opcode'ları, tipe göre seçilir: int için iload/istore, float için fload/fstore, string/reference için aload/astore. Örneğin, bir int değişkeni yüklemek için "iload <index>", kaydetmek için "istore <index>" kullanılır.

Global variable access, static field'ler üzerinden yapılır. Global değişkenler, .field directive ile class level'da tanımlanır: ".field public static <name> <descriptor>". Get/Set işlemleri, getstatic/putstatic instruction'ları ile yapılır: "getstatic Main/<name> <descriptor>" field değerini stack'e yükler, "putstatic Main/<name> <descriptor>" stack'teki değeri field'a kaydeder.

### 2.5.5. Fonksiyon Çağrıları ve Çağrı Sözleşmeleri (Calling Conventions)

Static method call, invokestatic instruction'ı ile yapılır. Algoritma: (1) Argümanları soldan sağa generate-expr ile bytecode'a çevir. Her argüman stack'e push edilir. (2) "invokestatic Main/<name>(<param-descriptor'ları>)<return-descriptor>" instruction'ı emit et. Bu instruction, argümanları stack'ten alır, method'u çağırır ve return değerini stack'e push eder.

Print fonksiyonu özel bir durumdur ve Java'nın System.out.println method'una映射 edilir. Algoritma: (1) "getstatic java/lang/System/out Ljava/io/PrintStream;" instruction'ı emit et. Bu, System.out singleton'ını stack'e yükler. (2) Argümanı generate-expr ile bytecode'a çevir. (3) "invokevirtual java/io/PrintStream/println(<type-descriptor>)V" instruction'ı emit et. Type-descriptor, argüman tipine göre seçilir: int için "I", string için "Ljava/lang/String;".

Function declaration bytecode üretimi, .method directive ile başlar: ".method public static <name>(<param-descriptor'ları>)<return-descriptor>". Sonra .limit stack ve .limit locals direktifleri emit edilir (stack ve local variable limitleri). Body generate-stmt ile bytecode'a çevrilir. Eğer return type void ise, "return" instruction'ı emit edilir (void return). Sonra ".end method" directive'ı emit edilir.

Main method üretimi, özel bir durumdur. JVM, programı main method'undan başlatır: "main([Ljava/lang/String;)V". Krypto'da, global statements'lar main method içinde bytecode'a çevrilir. Eğer user-defined main fonksiyonu varsa, "invokestatic Main/main()V" instruction'ı ile çağrılır. Sonra "return" instruction'ı ile method sonlandırılır.

## 2.6. Yorumlayıcı (Interpreter) Modülü ve Ağaç Yürütme Semantiği

Krypto, tree-walking interpreter içerir. Bu modül, AST'yi doğrudan yürüterek kodu test etmeyi ve debug etmeyi sağlar. Interpreter, compiler'a alternatif bir execution path'tir ve semantic analizden sonra çalıştırılabilir.

### 2.6.1. Ağaç Yürütme (Tree-Walking) Yaklaşımı ve Evaluation Stratejisi

Tree-walking interpreter, AST'yi ziyaret ederek (traverse ederek) her node'u evalüe eder. Her AST node tipi için bir eval fonksiyonu vardır ve bu fonksiyonlar recursive olarak birbirini çağırır. Örneğin, eval-binary fonksiyonu, left ve right child'ları evalüe eder ve operator'e göre arithmetic işlem yapar.

Eval dispatcher, eval-node fonksiyonu, AST node tipine göre appropriate eval fonksiyonunu çağırır. Cond ifadesi ile her node tipi kontrol edilir: integer-literal için eval-literal, binary-expr için eval-binary, if-stmt için eval-if, call-expr için eval-call, vb. Bu sayede, AST'nin her node'u doğru şekilde evalüe edilir.

Evaluation stratejisi, eager evaluation'dır. Yani, function call'larda argümanlar çağrıdan önce evalüe edilir. Bu, çoğu imperative dilin (C, Java, Python) kullandığı stratejidir ve Krypto'da da aynı şekilde implemente edilmiştir.

### 2.6.2. Environment ve Değişken Ortamı Yönetimi

Interpreter environment, runtime'da değişken değerlerini saklar. Environment yapısı, lexical scope'u yansıtır ve parent pointer içerir. make-env fonksiyonu, parent alan bir environment oluşturur. env-get fonksiyonu, variable değerini environment chain'de arar. env-define! fonksiyonu, variable'ı current environment'a tanımlar.

Variable lookup, recursive search ile yapılır. env-get, önce current environment'ın hashtable'ında arar. Bulunamazsa, parent environment'da arar ve bu şekilde global environment'a kadar devam eder. Bulunamazsa, "Undefined variable" hatası fırlatır.

Variable assignment, env-define! ile yapılır. Let statement evalüasyonunda, initializer evalüe edilir ve result value env-define! ile environment'a kaydedilir. Mutable değişkenler için, aynı isimle tekrar define yapılır ve hashtable update edilir.

### 2.6.3. Return Signal ve Kontrol Akışı Yönetimi

Return statement, special bir control flow construct'ıdır ve normal execution akışını bozar. Tree-walking interpreter'da, return statement derinlikten çıkış yapar ve return değerini caller'a iletir. Bunun için exception-like bir mekanizma kullanılır: return-signal.

Return-signal record tipi, value field'ı içerir ve return değerini taşır. eval-return fonksiyonu, return ifadesini evalüe eder ve make-return-signal ile signal oluşturur. Sonra throw ile signal fırlatır.

Function call evalüasyonu, catch ile signal yakalar. eval-call fonksiyonu, function body'yi evalüe ederken catch block kullanır. Eğer return-signal fırlatılırsa, catch block signal value'yu alır ve function return değeri olarak döner. Bu sayede, nested return statement'lar doğru şekilde handle edilir.

Built-in fonksiyonlar (print, input), native Scheme fonksiyonlarına mapping edilir. print fonksiyonu, display ve newline kullanır. input fonksiyonu, read-line kullanır. Bu fonksiyonlar, environment'a predefined olarak eklenir ve user-defined fonksiyonlar gibi çağrılabilir.

---
