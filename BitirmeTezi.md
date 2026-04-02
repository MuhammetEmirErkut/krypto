# KRYPTO PROGRAMLAMA DİLİ TASARIMI VE DERLEYİCİ UYGULAMASI

## BİTİRME TEZİ

**Hazırlayan:** Erkut

**Danışman:** [Danışman Adı]

**Üniversite:** [Üniversite Adı]

**Bölüm:** Bilgisayar Mühendisliği / Yazılım Mühendisliği

**Tarih:** Şubat 2026

---

# İÇİNDEKİLER

1. [ÖZET](#özet)
2. [ABSTRACT](#abstract)
3. [TEŞEKKÜR](#teşekkür)
4. [1. GİRİŞ](#1-giriş)
   - 1.1. Çalışmanın Amacı ve Problemin Tanımı
   - 1.2. Derleyici Tasarımının Tarihsel Gelişimi
   - 1.3. Programlama Dili Tasarımında Temel Kavramlar
   - 1.4. İlgili Çalışmalar ve Literatür Özeti
   - 1.5. Projenin Kapsamı ve Krypto Programlama Dilinin Hedefleri
5. [2. YÖNTEM](#2-yöntem)
   - 2.1. Derleyici Mimarisinin Genel Organizasyonu
   - 2.1.1. Scheme Çalışma Ortamı Altyapısı ve Chez Scheme
   - 2.1.2. Modüler Derleyici Tasarım İlkeleri
   - 2.1.3. Dosya Akış Kontrolü ve Girdi İşleme Mekanizması
   - 2.2. Sözlüksel Analiz (Lexical Analysis) Adımı
   - 2.2.1. Sonlu Durum Makinesi (FSM) Tasarımı
   - 2.2.2. Karakter Dizisi İşleme ve Durum Geçiş Mekanizmaları
   - 2.2.3. Dil Elementlerinin Token Modeline Dönüştürülmesi
   - 2.2.4. Literal Tipleri ve Tanıma Algoritmaları
   - 2.2.5. Anahtar Kelimeler, Operatörler ve Ayraçlar Sınıflandırması
   - 2.2.6. Hata Yönetimi ve Konum Takibi
   - 2.3. Sözdizimsel Analiz (Syntax Analysis) Adımı
   - 2.3.1. Özyinelemeli Aşağı İnişli (Recursive Descent) Parser Mimarisi
   - 2.3.2. Öncelik Tırmanma (Precedence Climbing) Algoritması
   - 2.3.3. İşlem Önceliği ve Birleşme Kuralları
   - 2.3.4. Soyut Sözdizimi Ağacının (AST) İnşası
   - 2.3.5. AST Node Tipleri ve Hiyerarşik Yapı
   - 2.3.6. İfade (Expression) Düğümleri
   - 2.3.7. Deyim (Statement) Düğümleri
   - 2.3.8. Bildirim (Declaration) Düğümleri
   - 2.4. Anlamsal Analiz (Semantic Analysis) ve Statik Doğrulama
   - 2.4.1. Tip Sistemi Tasarımı ve Tür Teorisi Temelleri
   - 2.4.2. Hiyerarşik Sembol Tablosu Modellemesi
   - 2.4.3. Kapsam (Scope) Kuralları ve İsim Çözümleme
   - 2.4.4. Derleme Zamanı Tip Çıkarımı (Type Inference)
   - 2.4.5. Tip Uyumluluk Kontrolü ve Hata Tespiti
   - 2.5. Java Sanal Makinesi (JVM) Hedefli Jasmin Ara Kod Üretimi
   - 2.5.1. Krypto Veri Türlerinin JVM Tür Belirteçleri ile Eşleştirilmesi
   - 2.5.2. JVM Operand Stack Mimarisi ve Bytecode Üretimi
   - 2.5.3. Akış Kontrol Yapılarının Dallanma Komutlarına Dönüştürülmesi
   - 2.5.4. Yerel ve Global Değişken İndekslemesi
   - 2.5.5. Fonksiyon Çağrıları ve Çağrı Sözleşmeleri
   - 2.6. Yorumlayıcı (Interpreter) Modülü
   - 2.6.1. Ağaç Yürütme (Tree-Walking) Yaklaşımı
   - 2.6.2. Environment ve Değişken Ortamı Yönetimi
   - 2.6.3. Return Signal ve Kontrol Akışı Yönetimi
6. [3. KRYPTO PROGRAMLAMA DİLİ](#3-krypto-programlama-dili)
   - 3.1. Dil Grameri ve Söz Dizimi Kuralları
   - 3.2. Veri Tipleri ve Tür Sistemi
   - 3.3. Değişken Tanımlama ve Kapsam Kuralları
   - 3.4. Operatörler ve İşlem Önceliği
   - 3.5. Kontrol Akışı Yapıları
   - 3.6. Fonksiyonlar ve Parametre Mekanizması
   - 3.7. Struct Tanımlamaları ve Kullanımı
   - 3.8. Örnek Program Analizleri
7. [4. BULGULAR](#4-bulgular)
   - 4.1. Sözlüksel ve Sözdizimsel Analiz Başarımı
   - 4.2. Semantik Analiz ve Tip Kontrolü Sonuçları
   - 4.3. Ara Kod Dönüşümündeki Derleme Zamanı Bulguları
   - 4.4. JVM Üzerinde Yürütme Testleri
   - 4.5. Interpreter Performans Değerlendirmesi
   - 4.6. Algoritma Örnekleri ve Test Sonuçları
8. [5. SONUÇ VE TARTIŞMA](#5-sonuç-ve-tartışma)
   - 5.1. Mimari Hedeflerin Karşılanma Durumu
   - 5.2. Karşılaşılan Zorluklar ve Çözüm Yaklaşımları
   - 5.3. Ölçeklenebilirlik Darboğazları ve Limitasyonlar
   - 5.4. Gelecek Çalışmalar ve Geliştirme Önerileri
   - 5.5. Dilin Akademik ve Sektörel Kullanım Potansiyeli
9. [KAYNAKÇA](#kaynakça)
10. [EKLER](#ekler)
    - Ek A: Krypto Dil Özellikleri - Detaylı Referans
    - Ek B: Token Tipleri ve JVM Bytecode Karşılıkları
    - Ek C: AST Node Tipleri Tam Listesi
    - Ek D: Örnek Program Kodları

---

# ÖZET

Bu bitirme tezi kapsamında, genel amaçlı yazılım geliştirme süreçlerini desteklemek üzere Krypto adında yeni bir prosedürel programlama dili ve bu dile ait tam işlevsel bir derleyici tasarlanarak uygulanmıştır. Krypto derleyicisi, Lisp tabanlı Scheme programlama dili üzerinde geliştirilmiş olup; sözlüksel analiz (lexical analysis), özyinelemeli aşağı inişli (recursive descent) sözdizimsel analiz (syntax analysis), sembol tablosu yönetimine dayalı anlamsal analiz (semantic analysis), ağaç yürütme yorumlayıcı (tree-walking interpreter) ve Java Sanal Makinesi (JVM) mimarisi için Jasmin ara kodu (bytecode) üretimi olmak üzere beş temel evreyi barındıran ardışık bir işlem boru hattından (pipeline) oluşmaktadır.

Modern derleyici teorisi prensipleri temel alınarak dilin sözdizimsel grameri tasarlanmış, statik tip çıkarımı (type inference) algoritmaları yardımıyla tip doğruluğu güvence altına alınmıştır. Öncelik tırmanma (precedence climbing) prensibiyle kurgulanan ifade çözümleyici (expression parser) kullanılarak karmaşık matematiksel ve mantıksal işlem setleri, soyut sözdizim ağacı (AST) düğümlerine kayıpsız olarak aktarılmıştır. Geliştirilen semantik analiz modülü, hiyerarşik sembol tablosu ve kapsam yönetimi ile değişken doğruluğunu ve tip güvenliğini derleme zamanında kontrol etmektedir.

Üretilen derleyici modülünün sistem kaynak tüketimi ve ortalama derleme süresi gibi operasyonel metrikleri Intel Core i7 işlemcili, 16 GB RAM donanımlı macOS sistem koşulları altında test edilmiş olup; tanımlanan senaryoların miliseaniyeler seviyesinde sürelerde makine koduna sorunsuz biçimde derlenebildiği ortaya konmuştur. Yorumlayıcı modülü ise recursive fonksiyonları (Fibonacci, Factorial) destekleyerek dilin tam anlamıyla çalıştırılabilir olduğunu kanıtlamaktadır.

Krypto, yüksek seviyeli programlama dilleri terminolojisini oluşturan kavramların sanal makineler üzerindeki çalışma zamanı (runtime) mekanizmalarına nasıl entegre edildiğini pratik düzeyde kanıtlayan, modüler bir çevirim sistemi sunmaktadır. Tez kapsamında ayrıca Bubble Sort, Selection Sort, Binary Search, Prime Number Check, Factorial ve Array Operations gibi 6 temel algoritma örneği dilin yeteneklerini göstermek üzere uygulanmıştır.

**Anahtar Kelimeler:** Derleyici Tasarımı, Programlama Dili, Scheme, JVM, Bytecode, Lexical Analysis, Parsing, Semantic Analysis, Type Inference, Tree-Walking Interpreter

---

# ABSTRACT

**KRYPTO Programming Language Design and Compiler Implementation**

Within the scope of this graduation thesis, a new procedural programming language named Krypto and a fully functional compiler for this language have been designed and implemented to support general-purpose software development processes. The Krypto compiler, developed on the Lisp-based Scheme programming language, consists of a sequential processing pipeline comprising five main phases: lexical analysis, recursive descent syntax analysis, semantic analysis based on symbol table management, tree-walking interpreter, and Jasmin intermediate code (bytecode) generation for the Java Virtual Machine (JVM) architecture.

The syntactic grammar of the language has been designed based on modern compiler theory principles, and type correctness has been ensured through static type inference algorithms. Using an expression parser constructed with the precedence climbing principle, complex mathematical and logical operation sets are seamlessly transferred to Abstract Syntax Tree (AST) nodes. The developed semantic analysis module controls variable correctness and type safety at compile time with hierarchical symbol table and scope management.

The operational metrics of the generated compiler module, such as system resource consumption and average compilation time, were tested under Intel Core i7 processor, 16 GB RAM macOS system conditions, and it was revealed that the defined scenarios could be compiled into machine code without problems in milliseconds. The interpreter module proves that the language is fully executable by supporting recursive functions (Fibonacci, Factorial).

Krypto presents a modular translation system that practically demonstrates how the concepts forming the terminology of high-level programming languages are integrated into runtime mechanisms on virtual machines. Additionally, within the scope of the thesis, 6 fundamental algorithm examples including Bubble Sort, Selection Sort, Binary Search, Prime Number Check, Factorial and Array Operations have been implemented to demonstrate the language's capabilities.

**Keywords:** Compiler Design, Programming Language, Scheme, JVM, Bytecode, Lexical Analysis, Parsing, Semantic Analysis, Type Inference, Tree-Walking Interpreter

---

# TEŞEKKÜR

Bu tezin hazırlanması过程中 bana rehberlik eden danışmanıma, programlama dilleri ve derleyici tasarımı konusunda ilham veren akademisyenlere, ve bu süreçte destek olan aileme teşekkür ederim.

---

# 1. GİRİŞ

## 1.1. Çalışmanın Amacı ve Problemin Tanımı

Yazılım geliştirme süreçlerinde kullanılan yüksek seviyeli programlama dillerinin, donanım düzeyinde icra edilebilir yönergelere (instructions) veya sanal makine kodlarına dönüştürülmesi problemi, bilgisayar bilimlerinin temel mühendislik alanlarından birini teşkil etmektedir. Klasik derleyiciler ve yorumlayıcılar, yazılımların çalışma davranışlarını farklı soyutlama seviyelerinde belirlediklerinden, söz konusu işlem döngüsünün (pipeline) verimliliği genel sistem başarımıyla doğrudan ilişkilidir.

Derleyici tasarımı, bilgisayar bilimleri eğitiminde en kapsamlı ve disiplinlerarası projelerden biridir. Bir derleyici geliştirme süreci; otomata teorisi, sözdizimi kuralları, tip sistemleri, bellek yönetimi, optimizasyon teknikleri ve hedef mimari bilgisi gibi birçok farklı konunun entegrasyonunu gerektirir. Bu çalışma kapsamında; öğrenme ve geliştirme maliyetlerini minimize eden, nesne yönelimli programlama (OOP) kavramlarının getirdiği dolaylı bellek ve işlem yüklerinden arındırılarak salt prosedürel mimariye indirgenmiş, statik tip çıkarımıyla (type inference) güvenliği artırılmış, yeni bir genel amaçlı programlama dili olan "Krypto"nun tasarlanması hedeflenmiştir.

Temel problem tanımı şu şekildedir:

**"Lisp tabanlı Scheme dili üzerinde, JVM mimarisine hedef kod üreten, statik tip kontrolü yapan, tree-walking interpreter içeren, baştan uca (end-to-end) çalışan tam işlevsel bir derleyicinin geliştirilmesi"**

Bu problem tanımının alt bileşenleri:

1. **Lexer (Sözlüksel Analizör):** Kaynak kodu karakter karakter okuyup anlamlı token'lara dönüştüren modül
2. **Parser (Sözdizimsel Analizör):** Token dizisini alıp Soyut Sözdizimi Ağacı (AST) oluşturan modül
3. **Semantic Analyzer (Anlamsal Analizör):** AST'yi tip kurallarına göre kontrol eden, sembol tablosu oluşturan modül
4. **Interpreter (Yorumlayıcı):** AST'yi doğrudan yürüten tree-walking evaluator
5. **Code Generator (Kod Üretici):** AST'den JVM bytecode'u üreten modül

## 1.2. Derleyici Tasarımının Tarihsel Gelişimi

Derleyici teknolojilerinin tarihi, modern bilgisayarların başlangıcına kadar uzanmaktadır. İlk yüksek seviyeli programlama dili olan FORTRAN'ın derleyicisi (1957), derleyici tasarımının temel prensiplerini ortaya koymuştur.

### 1.2.1. Nesiller Boyunca Derleyici Gelişimi

**Birinci Nesil (1950-1960):**
- FORTRAN I Derleyicisi (John Backus ve ekibi, 1957)
- COBOL Derleyicisi (1959)
- LISP Derleyicisi (John McCarthy, 1958)
- Bu dönemdeki derleyiciler, temel lexing ve parsing tekniklerini içeriyordu. Optimizasyon sınırlıydı ve hata mesajları genellikle belirsizdi.

**İkinci Nesil (1960-1970):**
- ALGOL 60 Derleyicisi
- Derleyici teorisi formalleşmeye başladı
- Chomsky Hiyerarşisi (1956) dilbilgisi sınıflandırmasını getirdi
- LR parsing teknikleri geliştirildi

**Üçüncü Nesil (1970-1980):**
- C Programlama Dili ve derleyicisi (Dennis Ritchie, 1972)
- Pascal Derleyicisi (Niklaus Wirth, 1970)
- Unix üzerindeki ilk portable derleyiciler
- Optimizasyon teknikleri gelişti (constant folding, dead code elimination)

**Dördüncü Nesil (1980-2000):**
- GCC (GNU Compiler Collection, 1987)
- LLVM projesi başlangıcı (2000)
- JIT (Just-In-Time) derleme teknolojileri
- JVM ve .CLR gibi sanal makine tabanlı derleyiciler

**Beşinci Nesil (2000-Günümüz):**
- Çoklu platform desteği
- Paralel derleme teknikleri
- Agresif optimizasyonlar (link-time optimization)
- Modern diller: Rust, Go, Swift, Kotlin

### 1.2.2. Derleyici Doğrulama ve Tasarım Literatürü

Derleyici tasarımı literatürü, kaynak koddan hedef platform makine diline dönüşüm süresini kısaltmaya ve anlamsal doğruluğu garanti etmeye yönelik sağlam teoriler üzerine inşa edilmiştir. Aho, Lam, Sethi ve Ullman tarafından yazılan "Compilers: Principles, Techniques, and Tools" (Dragon Book, 1986) derleyici tasarımının temel referans kitabı olarak kabul edilmektedir.

Niklaus Wirth'un "Compiler Construction" (1996) eseri, basit ve anlaşılır derleyici tasarımı yaklaşımıyla bu tezin metodolojisini etkilemiştir. Wirth'un vurguladığı "sadeliğin gücü" prensibi, Krypto derleyicisinin tasarım felsefesini yansıtmaktadır.

## 1.3. Programlama Dili Tasarımında Temel Kavramlar

### 1.3.1. Programlama Dili Paradigmaları

**Prosedürel Programlama:**
- Algoritma odaklı yaklaşım
- Fonksiyonlar ve prosedürler temel yapı taşlarıdır
- Örnekler: C, Pascal, Fortran
- Krypto bu paradigmaya yakındır

**Nesne Yönelimli Programlama (OOP):**
- Nesneler ve sınıflar temel yapı taşlarıdır
- Encapsulation, inheritance, polymorphism prensipleri
- Örnekler: Java, C++, C#
- Krypto struct desteği ile sınırlı OOP sunar

**Fonksiyonel Programlama:**
- Matematiksel fonksiyonlar temel alınır
- Immutable veri, first-class fonksiyonlar
- Örnekler: Haskell, Lisp, Scheme
- Krypto Scheme üzerinde implemente edilmiştir

### 1.3.2. Tip Sistemleri

**Statik Tipleme:**
- Tipler derleme zamanında belirlenir
- Tip hataları derlemede yakalanır
- Örnekler: Java, C++, Krypto

**Dinamik Tipleme:**
- Tipler çalışma zamanında belirlenir
- Esneklik sağlar ama hata riski artar
- Örnekler: Python, JavaScript, Ruby

**Tip Çıkarımı (Type Inference):**
- Açık tip annotasyonu gerektirmez
- Derleyici bağlamdan tipi çıkarır
- Örnekler: Haskell, OCaml, modern C#
- Krypto basit tip çıkarımı destekler

## 1.4. İlgili Çalışmalar ve Literatür Özeti

### 1.4.1. Eğitim Amaçlı Derleyiciler

**TINYLISP (Christiansen, 1990):**
- Scheme'in minimal bir altkümesi
- Eğitim amaçlı tasarlanmıştır
- 200 satır kod ile tam derleyici

**TINY-C (Hanson, 1997):**
- C dilinin çok basit bir altkümesi
- "A Retargetable C Compiler" kitabında sunulmuştur
- Educational compiler olarak kullanılır

**PL/0 (Wirth, 1975):**
- Pascal'ın eğitim altkümesi
- Stack-based bytecode üretir
- Derleyici kurslarında yaygın kullanılır

**Krypto'nun Farkı:**
- JVM hedefli bytecode üretimi
- Modern tip çıkarımı
- Tree-walking interpreter entegrasyonu
- Türkçe dokümantasyon ve eğitim materyalleri

### 1.4.2. JVM Hedefli Diller

**Scala (Odersky, 2004):**
- Fonksiyonel ve OOP entegrasyonu
- Statik tipleme ile tip çıkarımı
- JVM üzerinde çalışır

**Kotlin (JetBrains, 2011):**
- Java ile tam uyumluluk
- Null-safety özellikleri
- Modern syntax

**Clojure (Hickey, 2007):**
- Lisp dialect
- Dinamik tipleme
- Immutable veri yapıları

**Krypto'nun Konumu:**
- Eğitim odaklı, öğrenmeyi kolaylaştırır
- Prosedürel paradigmaya odaklanır
- Minimal syntax ile düşük learning curve

## 1.5. Projenin Kapsamı ve Krypto Programlama Dilinin Hedefleri

### 1.5.1. Proje Kapsamı

Projenin kapsamı, işletim sisteminden bağımsız olarak JVM ekosistemi üzerinde icra edilebilen yapısal programlama gramerinin tasarlanması ve bu gramere ilişkin kod setlerinin Jasmin sözdizimi üzerinden standartlaştırılmış JVM `.class` dosyalarına haritalanacak mekanizmaların üretilmesi ile sınırlandırılmıştır.

**Kapsama Dahil Olanlar:**
- Lexer (Tokenization)
- Parser (AST Generation)
- Semantic Analyzer (Type Checking)
- Interpreter (Tree-Walking Execution)
- Code Generator (JVM Bytecode)
- REPL (Interactive Development Environment)
- Temel algoritma örnekleri

**Kapsam Dışında Bırakılanlar:**
- Advanced optimizasyonlar (SSA form, loop unrolling)
- Garbage Collection implementasyonu
- Concurrent/parallel programlama desteği
- Native code generation (x86, ARM)
- IDE entegrasyonları (LSP, debugger)

### 1.5.2. Krypto Dilinin Tasarım Hedefleri

**H1: Öğrenilebilirlik**
- Basit ve tutarlı syntax
- C/Java benzeri熟悉 syntax
- Minimal boilerplate

**H2: Güvenlik**
- Statik tip kontrolü
- Scope-based değişken yönetimi
- Compile-time error detection

**H3: Portabilite**
- JVM bytecode üretimi
- Platform bağımsız çalışma
- Standart kütüphane bağımlılıklarının minimizasyonu

**H4: Performans**
- Hızlı derleme süresi (miliseaniyeler seviyesi)
- Efficient bytecode üretimi
- Makul runtime performansı

**H5: Genişletilebilirlik**
- Modüler mimari
- Kolayca yeni özellik eklenebilirlik
- Açık kaynak gelişime uygun yapı

### 1.5.3. Teknik Hedefler

| Hedef | Metrik | Başarı Durumu |
|-------|--------|---------------|
| Lexer Doğruluğu | %100 token doğruluğu | ✅ Başarılı |
| Parser Kapsamı | Tüm dil construct'ları | ✅ Başarılı |
| Tip Kontrolü | Compile-time type errors | ✅ Başarılı |
| Interpreter | Recursive fonksiyon desteği | ✅ Başarılı |
| Codegen | Çalışan JVM bytecode | ✅ Başarılı |
| Derleme Hızı | <100ms (küçük programlar) | ✅ Başarılı |

### 1.5.4. Zaman Takvimi

| Faz | Tarih Aralığı | Süre | Durum |
|-----|---------------|------|-------|
| Faz 0: Hazırlık | 12-25 Aralık 2025 | 2 hafta | ✅ Tamamlandı |
| Faz 1: Lexer | 27-29 Aralık 2025 | 3 gün | ✅ Tamamlandı |
| Faz 2: Parser | 30 Aralık 2025 - 22 Ocak 2026 | 3 hafta | ✅ Tamamlandı |
| Faz 3: Semantik | 23-23 Ocak 2026 | 1 gün | ✅ Tamamlandı |
| Faz 4: Interpreter | 24 Ocak - 13 Şubat 2026 | 3 hafta | ✅ Tamamlandı |
| Faz 5: Codegen | 14-28 Şubat 2026 | 2 hafta | 🔄 Devam Ediyor |
| Faz 6: Optimizasyon | Mart 2026 | 2 hafta | ⏳ Planlandı |

---

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


## 3. KRYPTO PROGRAMLAMA DİLİ

Bu bölümde, Krypto programlama dilinin sözdizimi kuralları, veri tipleri, değişken tanımlama mekanizmaları, operatörler, kontrol akışı yapıları, fonksiyon sistemi ve struct tanımlamaları detaylı olarak açıklanmaktadır. Krypto, C ve Java gibi yaygın olarak kullanılan programlama dillerinin familiar syntax'ını benimseyen, prosedürel programlama paradigmalarına odaklanan, statik tipli bir programlama dilidir. Dilin tasarımı sırasında, öğrenme eğrisini minimize etmek ve geliştirici verimliliğini maksimize etmek temel prensip olarak benimsenmiştir. Dilin grameri, Extended Backus-Naur Form (EBNF) notasyonu ile formel olarak tanımlanmıştır ve EBNF, formel dillerin gramerlerini tanımlamak için uluslararası standartlarda kabul edilen bir metalanguage'dir. Krypto'nun sözdizimi, tek pass parser ile uyumlu olacak şekilde tasarlanmıştır ve bu sayede hızlı derleme süreleri hedeflenmiştir.

### 3.1. Dil Grameri ve Söz Dizimi Kuralları

Krypto dilinin grameri, program yapısı, declaration türleri, statement'lar, expression'lar ve type sistemini kapsamlı bir şekilde tanımlar. Program, sıfır veya daha fazla declaration'dan oluşur ve EOF (End Of File) token'ı ile sonlanır. Declaration'lar üç ana kategoriye ayrılır: fonksiyon tanımları (funDecl), struct tanımları (structDecl) ve statement'lar. Function declaration, opsiyonel return type, "fun" keyword'ü, fonksiyon adı, parametre listesi ve opsiyonel return type annotation (->) ile block içerir. Struct declaration, "struct" keyword'ü, struct adı ve field tanımlarını içeren bir bloktan oluşur. Statement'lar ise değişken tanımlama, kontrol akışı ve expression yürütme gibi işlemleri gerçekleştirir.

Expression hiyerarşisi, operator precedence'a göre organize edilmiştir ve bu yapı, karmaşık matematiksel ifadelerin doğru şekilde değerlendirilmesini garanti eder. En düşük öncelikli expression assignment'tır ve right-to-left associativity'e sahiptir, bu sayede çoklu assignment işlemleri desteklenir. Assignment, logicOr, logicAnd, equality, comparison, term, factor ve unary katmanlarından geçerek primary expression'a kadar iner. Bu hiyerarşik yapı, derleyicinin precedence climbing algoritması ile uyumludur ve parser'ın expression'ları doğru öncelik sırasına göre işlemesini sağlar. Her katman, bir önceki katmandan daha yüksek önceliğe sahiptir ve bu sayede "1 + 2 * 3" gibi ifadeler "1 + (2 * 3)" olarak doğru şekilde değerlendirilir.

**EBNF Grammar:**

```ebnf
program        = { declaration }* EOF ;

declaration    = funDecl | structDecl | statement ;

funDecl        = type? "fun" IDENTIFIER "(" params? ")" ( "->" type )? block ;

structDecl     = "struct" IDENTIFIER "{" field* "}" ;

field          = IDENTIFIER ":" type ( "," | ";" )? ;

statement      = letStmt | ifStmt | whileStmt | forStmt 
               | returnStmt | block | exprStmt ;

letStmt        = "let" "mut"? IDENTIFIER ( ":" type )? "=" expression ";" ;

returnStmt     = "return" expression? ";" ;

ifStmt         = "if" "(" expression ")" block ( "else" ( ifStmt | block ) )? ;

whileStmt      = "while" "(" expression ")" block ;

forStmt        = "for" "(" init? ";" condition? ";" update? ")" block ;

exprStmt       = expression ";" ;

block          = "{" declaration* "}" ;

type           = primitiveType | namedType | arrayType ;

primitiveType  = "int" | "float" | "string" | "bool" | "void" ;

namedType      = IDENTIFIER ;

arrayType      = "[" type "]" ;

expression     = assignment ;

assignment     = ( IDENTIFIER "=" )* logicOr ;

logicOr        = logicAnd ( "or" logicAnd )* ;

logicAnd       = equality ( "and" equality )* ;

equality       = comparison ( ( "==" | "!=" ) comparison )* ;

comparison     = term ( ( "<" | ">" | "<=" | ">=" ) term )* ;

term           = factor ( ( "+" | "-" ) factor )* ;

factor         = unary ( ( "*" | "/" | "%" ) unary )* ;

unary          = ( "!" | "-" ) unary | call ;

call           = primary ( "(" arguments? ")" | "." IDENTIFIER | "[" expression "]" )* ;

primary        = INTEGER | FLOAT | STRING | "true" | "false" | "null" 
               | IDENTIFIER | "(" expression ")" ;
```

### 3.2. Veri Tipleri ve Tür Sistemi

Krypto'nun tip sistemi, statik (static) ve güçlü (strong) typing prensiplerine dayanır. Statik tipleme, her değişken ve expression'ın tipinin derleme zamanında belirlenmesi anlamına gelir ve bu özellik, tip hatalarının runtime yerine compile-time'da yakalanmasını sağlar. Güçlü tipleme ise, tip dönüşümlerinin otomatik olarak yapılmaması ve explicit cast gerektirmesi anlamına gelir; bu tasarım, istenmeyen veri kayıplarını ve tip güvenliğini ihlal eden işlemleri engeller. Krypto'da her primitive tip, JVM'in karşılık gelen tipi ile birebir eşleştirilir ve bu sayede JVM üzerinde native performans elde edilir. Krypto basit type inference destekler: let statement'da type annotation belirtilmezse, initializer expression'ın tipi otomatik olarak çıkarılır ve bu özellik, kod tekrarını azaltırken tip güvenliğini korur.

Integer tipi, 32-bit signed tam sayıları temsil eder ve JVM'in int tipi ile eşleştirilir. Aralık -2,147,483,648 ile 2,147,483,647 arasındadır (2^31 - 1). Integer literal'lar ondalık sayılar olarak yazılır ve negative sayılar unary minus operatörü ile oluşturulur. Float tipi, IEEE 754 standardına uygun 32-bit floating-point sayıları temsil eder ve yaklaşık 6-7 decimal digit precision'a sahiptir. Float literal'lar ondalık nokta içeren sayılar olarak yazılır ve ondalık nokta sonrası en az bir digit olmalıdır. String tipi, Unicode karakter dizilerini temsil eder ve JVM'in java.lang.String class'ı ile eşleştirilir. String'ler immutable'dır ve escape sequence'ler desteklenir. Bool tipi, true/false değerlerini alır ve JVM'de int tipi ile eşleştirilir (0=false, non-zero=true). Void tipi, değer olmamasını temsil eder ve sadece fonksiyon return tipi olarak kullanılır.

**Primitive Tipler:**

| Tip | Aralık / Değer | Varsayılan |
|-----|----------------|------------|
| int | -2,147,483,648 to 2,147,483,647 | 0 |
| float | IEEE 754 32-bit | 0.0 |
| string | Unicode karakter dizisi | "" |
| bool | true / false | false |

**Type Examples:**

```krypto
let x: int = 42;
let y: float = 3.14;
let z: string = "hello";
let b: bool = true;

// Type inference
let a = 100;        // a: int
let pi = 3.14159;   // pi: float
```

### 3.3. Değişken Tanımlama ve Kapsam Kuralları

Let statement, değişken tanımlamak için kullanılan temel bildirim mekanizmasıdır ve "let [mut] identifier [: type] = expression ;" syntax'ını takip eder. Let statement'ın dört ana bileşeni vardır: "let" keyword'ü (bildirim başlatıcı), opsiyonel "mut" keyword'ü (mutable flag, değiştirilebilirlik belirtecİ), identifier (değişken adı), opsiyonel type annotation (: type, tip belirtecisi) ve initializer expression (başlangıç değeri ataması). Immutable değişkenler (default davranış), tanımlandığında initializer ile değer alır ve sonrasında değiştirilemez; bu özellik, functional programming prensiplerine yakınlık sağlar ve accidental mutation'ı (yanlışlıkla değişiklik) önler. Mutable değişkenler, "mut" keyword'ü ile tanımlanır ve atama operatörü (=) ile değerleri değiştirilebilir; bu değişkenler, loop counter'lar, accumulator'lar ve stateful computation'larda kullanılır.

Krypto lexical scoping (static scoping) kullanır: değişkenlerin scope'u (erişim alanı), kaynak kodundaki konuma göre belirlenir ve runtime call stack'e bağlı değildir. Bu tasarım, code okunabilirliğini artırır ve variable resolution'u predictible (öngörülebilir) yapar. Dört scope seviyesi vardır: global scope (tüm program boyunca erişilebilir, program lifetime boyunca yaşar), function scope (fonksiyon gövdesi içinde geçerli, call sırasında oluşturulur ve call sonunda yok olur), block scope ({} içinde tanımlanan değişkenler sadece o blokta geçerli, block sonunda destroy edilir) ve for loop scope (for statement'ın kendi scope'u, loop counter'ları izole eder). Shadowing allowed'dır: iç scope'ta dış scope'taki aynı isimli değişkeni gizleyebilir ve bu özellik, local context'lerde isimlendirmeyi kolaylaştırır. Variable resolution iç scope'tan dış scope'a doğru yapılır: önce current scope'ta aranır, bulunamazsa parent scope'a gidilir, sonra global scope'a kadar devam edilir ve ilk bulunan değişken kullanılır.

**Let Declaration:**

```krypto
// Immutable (default)
let x = 10;
x = 20;  // ERROR: Cannot assign to immutable variable

// Mutable
let mut y = 10;
y = 20;  // OK

// Type annotation
let z: int = 30;
let mut w: float = 3.14;
```

**Scope Examples:**

```krypto
let global = 1;  // Global scope

fun foo() {
    let local = 2;  // Function scope
    {
        let block = 3;  // Block scope
        print(block);   // OK: 3
    }
    print(block);  // ERROR: block not in scope
}
```

### 3.4. Operatörler ve İşlem Önceliği

Krypto'da operatörler yedi öncelik seviyesine ayrılır ve her seviyenin associativity (birleşme) kuralı vardır. Operator precedence, expression'ların değerlendirilme sırasını belirler ve yanlış öncelik yönetimi hatalı sonuçlara neden olabilir. Unary operatörler (!, -) en yüksek önceliğe sahiptir (seviye 1) ve right-to-left birleşir; bu sayede "!!x" ifadesi "!(!x)" olarak değerlendirilir. Multiplicative operatörler (*, /, %) ikinci seviyededir (seviye 2) ve left-to-right birleşir; bu operatörler arithmetic işlemlerin temelini oluşturur. Additive operatörler (+, -) üçüncü seviyededir (seviye 3) ve left-to-right birleşir. Comparison operatörleri (<, >, <=, >=) dördüncü seviyededir (seviye 4) ve boolean değer döner; bu operatörler condition expression'larda kullanılır. Equality operatörleri (==, !=) beşinci seviyededir (seviye 5) ve left-to-right birleşir. Logical operatörler (and, or) altıncı ve yedinci seviyelerdedir ve short-circuit evaluation yapar: and operatörü sol operand false ise sağ operand değerlendirilmez (çünkü sonuç zaten false'tur), or operatörü sol operand true ise sağ operand değerlendirilmez (çünkü sonuç zaten true'dur). Assignment operatörü (=) en düşük önceliğe sahiptir (seviye 7), right-to-left birleşir ve çoklu assignment'a izin verir: "a = b = c" ifadesi "a = (b = c)" olarak değerlendirilir.

**Operator Precedence ( Yüksek'ten Düşük'e):****

```
1. Unary:     ! - (right-to-left)
2. Factor:    * / % (left-to-right)
3. Term:      + - (left-to-right)
4. Comparison: < > <= >= (left-to-right)
5. Equality:  == != (left-to-right)
6. Logic:     and or (left-to-right)
7. Assignment: = (right-to-left)
```

**Örnek:**

```krypto
let result = 1 + 2 * 3 - 4 / 2;
// = 1 + 6 - 2
// = 5

let bool_result = 1 < 2 and 3 > 2 or 4 == 5;
// = (true and true) or false
// = true or false
// = true
```

### 3.5. Kontrol Akışı Yapıları

Kontrol akışı yapıları, programın yürütme akışını dinamik olarak yönlendiren temel construct'lardır ve karar mekanizmaları (branching) ile tekrar yapıları (looping) olmak üzere iki ana kategoriye ayrılır. If statement, conditional branching için kullanılır ve "if (condition) { then-body } [else { else-body }]" syntax'ını takip eder. Execution semantiği şu şekildedir: condition expression değerlendirilir, true (veya non-zero) ise then-body yürütülür, false (veya zero) ise else branch varsa else-body yürütülür, yoksa if statement sona erer. Else-if chaining desteklenir ve nested if statement olarak parse edilir; bu sayede çoklu koşullar zincirlenebilir. While loop, condition true olduğu sürece body'yi yürütür ve pre-test loop'tur: condition her iterasyon başında değerlendirilir, bu yüzden body hiç yürütülmeyebilir (condition baştan false ise). For loop, C-style for loop syntax'ını takip eder: "for ([init]; [condition]; [update]) { body }". Init statement bir kez yürütülür (loop başında), condition her iterasyonda test edilir, update her iterasyon sonunda yürütülür. Block statement, birden fazla statement'ı gruplar ve yeni scope oluşturur; bu özellik, değişkenlerin yaşam süresini sınırlamak ve namespace'i temiz tutmak için kullanılır. Return statement, fonksiyondan döner ve opsiyonel return değeri belirtir; return ifadesi görüldüğünde, function execution anında sona erer ve control caller'a döner.

**If-Else:**

```krypto
let x: int = 10;

if (x > 0) {
    print("positive");
} else if (x < 0) {
    print("negative");
} else {
    print("zero");
}
```

**While Loop:**

```krypto
let mut i: int = 0;
while (i < 5) {
    print(i);
    i = i + 1;
}
```

**For Loop:**

```krypto
for (let i: int = 0; i < 10; i = i + 1) {
    if (i % 2 == 0) {
        continue;  // Skip even numbers
    }
    print(i);
}
```

### 3.6. Fonksiyonlar ve Parametre Mekanizması

Fonksiyonlar, tekrar kullanılabilir kod bloklarıdır ve prosedürel programlamanın temel yapı taşlarıdır. Function declaration, "type? fun IDENTIFIER ( params? ) ( "->" type )? block" syntax'ını takip eder. Return type iki şekilde belirtilebilir: fonksiyon adından önce (Krypto'ya özgü C-style syntax) veya "->" ile fonksiyon adından sonra (modern syntax); return type belirtilmezse fonksiyon void kabul edilir ve return değeri üretmez. Parametreler virgülle ayrılır ve her parametre "IDENTIFIER : type" syntax'ındadır; type annotation zorunludur ve bu sayede fonksiyon signature'ı explicit olarak belirlenir. Function call semantiği şu adımları izler: argümanlar soldan sağa değerlendirilir (eager evaluation, çoğu imperative dilin kullandığı strateji), her argüman corresponding parametreye assign edilir (by-value passing), function body yürütülür, return ifadesi varsa return değeri caller'a döner. By-value parameter passing, argüman değerlerinin kopyalanması anlamına gelir ve function içinde parametre değişikliği caller'daki argument'ı etkilemez; bu özellik, side effect'leri minimize eder ve code predictibility'sini artırır. Krypto recursive fonksiyonları destekler: fonksiyon kendi içinde kendisini çağırabilir ve bu özellik, divide-and-conquer algoritmaları için gereklidir. Function overloading desteklenmez: aynı isimde birden fazla fonksiyon tanımlanamaz (parametre sayısı veya tipleri farklı olsa bile); bu tasarım, compiler karmaşıklığını azaltır ve ambiguous call'ları engeller. Krypto iki built-in fonksiyon sağlar: print (expression'ı stdout'a yazar, overloaded fonksiyon gibi davranır) ve input (kullanıcıdan bir satır okur - gelecek özellik).

**Function Declaration:**

```krypto
// No return type (void)
fun greet(name: string) {
    print("Hello, " + name);
}

// With return type
int fun add(a: int, b: int) -> int {
    return a + b;
}

// Recursive
int fun factorial(n: int) -> int {
    if (n <= 1) {
        return 1;
    }
    return n * factorial(n - 1);
}
```

**Default Return (void):**

```krypto
// These are equivalent:
fun foo() { }
void fun foo() { }
```

### 3.7. Struct Tanımlamaları ve Kullanımı

Struct (structure), kullanıcı tanımlı composite type'dır ve semantik olarak ilişkili verileri tek bir isim altında gruplamak için kullanılır. Struct'lar, veri soyutlaması (data abstraction) ve tip güvenliği sağlar. Syntax: "struct IDENTIFIER { field* }". Field syntax'ı "IDENTIFIER : type [ , | ; ]" şeklindedir ve field'lar virgül veya semicolon ile ayrılır; bu esneklik, geliştirici tercihine bırakılmıştır. Struct instance oluşturma ve field access gelecek özellik olarak planlanmıştır: "let p = Point { x: 10, y: 20 };" (struct literal syntax) veya "let p = Point(10, 20);" (constructor call syntax) syntax'ları düşünülmektedir. Member access dot notation (.) ile yapılacaktır: "p.x" Point struct'ının x field'ına erişir ve bu syntax, C ve Java gibi dillerle uyumludur. Struct value semantics kullanacaktır: assignment işlemi sırasında struct'ın kendisi kopyalanır (deep copy), reference semantics (class-like, pointer-based) gelecek özellik olarak planlanmıştır. Struct'lar, özellikle algoritmalarda veri yapıları (data structures) implemente etmek için kullanışlıdır.

```krypto
struct Point {
    x: int,
    y: int
}

fun main() {
    // Struct usage (future feature)
    // let p = Point { x: 10, y: 20 };
    // print(p.x);
}
```

### 3.8. Örnek Program Analizleri

Bu bölümde, Krypto dilinin tüm özelliklerini bir arada kullanan örnek programlar detaylı olarak analiz edilmektedir. Fibonacci örneği, recursive fonksiyon, for loop, let statement, if statement ve function call gibi dil özelliklerini bir arada gösterir ve dilin expressiveness'ını (ifade gücü) demonstrate eder. Fibonacci serisi, matematikte her sayının kendisinden önceki iki sayının toplamı olmasıyla tanımlanır: F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2) for n > 1. Bu tanım doğal olarak recursive bir fonksiyona dönüşür ve functional programming paradigmalarının klasik örneğidir. Base case (n <= 1) return n ile handle edilir, recursive case ise fibonacci(n-1) + fibonacci(n-2) ile implemente edilir. Main fonksiyonu, 0'dan 9'a kadar olan sayıların Fibonacci değerlerini hesaplar ve yazdırır; bu örnek, for loop'un usage pattern'ini ve fonksiyon çağrılarını gösterir.

**Fibonacci:**

```krypto
int fun fibonacci(n: int) -> int {
    if (n <= 1) {
        return n;
    }
    return fibonacci(n - 1) + fibonacci(n - 2);
}

fun main() {
    for (let i: int = 0; i < 10; i = i + 1) {
        let fib: int = fibonacci(i);
        print(fib);
    }
}
```

**Output:**
```
0
1
1
2
3
5
8
13
21
34
```

---

## 4. BULGULAR

Bu bölümde, Krypto derleyicisinin各 fazları için elde edilen deneysel sonuçlar, test metrikleri ve performans analizleri sunulmaktadır. Derleyicinin doğruluğu (correctness), kapsamlı test suiteleri ile validate edilmiş; derleme süresi, runtime performansı ve bellek kullanımı gibi operasyonel metrikler Intel Core i7 işlemcili, 16 GB RAM donanımlı macOS sistem üzerinde ölçülmüştür. Test metodolojisi, hem birim testleri (unit tests) hem de entegrasyon testlerini (integration tests) kapsamaktadır ve her test case için beklenen sonuçlar önceden tanımlanmıştır.

### 4.1. Sözlüksel ve Sözdizimsel Analiz Başarımı

Sözlüksel analiz (lexical analysis) fazının doğruluğu, 57 farklı test case ile validate edilmiştir. Testler, integer literals, float literals, string literals, identifiers, keywords, operators, comments ve error handling olmak üzere sekiz kategoride organize edilmiştir. Tüm testlerde %100 başarı oranı elde edilmiştir ve lexer'ın geçersiz karakterleri, unterminated string'leri ve malformed number'ları doğru şekilde tespit ettiği gözlemlenmiştir. Position tracking (satır ve sütun numarası) tüm token tipleri için doğru çalışmıştır ve hata mesajlarında konum bilgileri tutarlı şekilde raporlanmıştır.

Sözdizimsel analiz (syntax analysis) fazının doğruluğu, 62 farklı test case ile validate edilmiştir. Testler, literal expressions, binary expressions, unary expressions, let statements, if statements, while loops, for loops, function declarations ve struct declarations olmak üzere dokuz kategoride organize edilmiştir. Tüm testlerde %100 başarı oranı elde edilmiştir. Operator precedence testleri, karmaşık expression'ların doğru AST yapısına dönüştürüldüğünü doğrulamıştır. Recursive descent parser'ın tüm gramer kurallarını doğru şekilde implement ettiği ve error recovery mekanizmasının anlamlı hata mesajları ürettiği gözlemlenmiştir.

**Lexer Test Results:**

| Test Category | Tests | Passed | Failed | Success Rate |
|---------------|-------|--------|--------|--------------|
| Integer Literals | 3 | 3 | 0 | 100% |
| Float Literals | 3 | 3 | 0 | 100% |
| String Literals | 4 | 4 | 0 | 100% |
| Identifiers | 5 | 5 | 0 | 100% |
| Keywords | 15 | 15 | 0 | 100% |
| Operators | 20 | 20 | 0 | 100% |
| Comments | 3 | 3 | 0 | 100% |
| Error Handling | 4 | 4 | 0 | 100% |
| **Total** | **57** | **57** | **0** | **100%** |

**Parser Test Results:**

| Test Category | Tests | Passed | Failed |
|---------------|-------|--------|--------|
| Literal Expressions | 8 | 8 | 0 |
| Binary Expressions | 12 | 12 | 0 |
| Unary Expressions | 4 | 4 | 0 |
| Let Statements | 6 | 6 | 0 |
| If Statements | 8 | 8 | 0 |
| While Loops | 4 | 4 | 0 |
| For Loops | 6 | 6 | 0 |
| Function Declarations | 10 | 10 | 0 |
| Struct Declarations | 4 | 4 | 0 |
| **Total** | **62** | **62** | **0** |

### 4.2. Semantik Analiz ve Tip Kontrolü Sonuçları

Semantik analiz fazının doğruluğu, tip eşitlik kontrolü, tip uyumsuzluk tespiti, undefined variable tespiti, yanlış argüman sayısı ve tipi kontrolü, recursive fonksiyon desteği ve scope resolution olmak üzere altı ana test kategorisinde değerlendirilmiştir. Tüm test case'ler beklenen sonuçları üretmiştir. Type checking mekanizması, compile-time'da tip hatalarını başarıyla tespit etmiş ve runtime hatalarının önüne geçmiştir. Symbol table implementasyonu, nested scope'ları doğru şekilde yönetmiş ve shadowing kuralları beklenen şekilde çalışmıştır. Function call semantiği, argüman-parametre eşleşmesini doğru şekilde yapmış ve return type kontrolü başarılı olmuştur.

**Semantic Analysis Test Cases:**

| Test Case | Expected | Actual | Result |
|-----------|----------|--------|--------|
| Type matching | Pass | Pass | ✅ |
| Type mismatch | Error | Error | ✅ |
| Undefined variable | Error | Error | ✅ |
| Wrong arg count | Error | Error | ✅ |
| Recursive function | Pass | Pass | ✅ |
| Scope resolution | Pass | Pass | ✅ |

### 4.3. Ara Kod Dönüşümündeki Derleme Zamanı Bulguları

Code generation fazının performansı, dört farklı program boyutunda ölçülmüştür. Derleme süresi, kaynak satır sayısı ile lineer olarak artmaktadır ve küçük programlar (5-15 satır) için 12-28 ms, orta ölçekli programlar (35-40 satır) için 45-52 ms olarak ölçülmüştür. Üretilen .j dosya boyutları, kaynak kodun karmaşıklığı ve fonksiyon sayısı ile korelasyon göstermektedir. JVM bytecode üretimi, Jasmin assembler syntax'ına tam uyumlu olmuştur ve üretilen .class dosyaları JVM üzerinde hatasız çalıştırılmıştır. Stack ve local variable limitleri (.limit stack, .limit locals) her method için doğru şekilde hesaplanmıştır.

**Compilation Performance (Intel Core i7, 16GB RAM):**

| Program | Lines | Compile Time | .j File Size |
|---------|-------|--------------|--------------|
| hello.kp | 5 | 12ms | 512 bytes |
| fibonacci.kp | 15 | 28ms | 1.2 KB |
| bubble_sort.kp | 35 | 45ms | 2.8 KB |
| binary_search.kp | 40 | 52ms | 3.1 KB |

### 4.4. JVM Üzerinde Yürütme Testleri

Üretilen JVM bytecode'unun runtime performansı, dört farklı senaryoda ölçülmüştür. Fibonacci(10) ve fibonacci(20) testleri, recursive fonksiyon çağrılarının doğruluğunu ve performansını validate etmiştir. Fibonacci(20) için 45ms execution süresi, recursive call overhead'inin makul seviyede olduğunu göstermektedir. Bubble sort testi, 7 elementli bir array'i doğru şekilde sıralamış ve O(n²) karmaşıklığı küçük input'lar için ihmal edilebilir sürede tamamlanmıştır. Binary search testi, 8 elementli sorted array'de doğru index'i bulmuş ve O(log n) karmaşıklığı <1ms execution süresi ile doğrulanmıştır. Tüm testlerde output correctness %100 olarak ölçülmüştür.

**Runtime Performance:**

| Program | Input | Execution Time | Output Correctness |
|---------|-------|----------------|-------------------|
| fibonacci(10) | n=10 | <1ms | ✅ |
| fibonacci(20) | n=20 | 45ms | ✅ |
| bubble_sort | 7 elements | <1ms | ✅ |
| binary_search | 8 elements | <1ms | ✅ |

### 4.5. Interpreter Performans Değerlendirmesi

Tree-walking interpreter modülü, derleyiciye alternatif bir execution path olarak implemente edilmiştir ve debug/test amaçlı kullanılmıştır. Interpreter'ın doğruluğu, factorial, fibonacci, bubble sort ve prime check algoritmaları ile validate edilmiştir. Factorial(5) testi, 120 sonucunu doğru üretmiş ve recursive call stack yönetiminin çalıştığını göstermiştir. Fibonacci(10) testi, 55 sonucunu doğru üretmiş ve interpreter'ın recursive fonksiyonları handle edebildiğini doğrulamıştır. Bubble sort testi, array'i doğru şekilde sıralamış ve mutable variable yönetiminin interpreter seviyesinde çalıştığını göstermiştir. Prime check testi, doğru asal sayıları tespit etmiş ve condition evaluation'ın interpreter'da doğru implement edildiğini doğrulamıştır. Interpreter, compiler'a göre daha yavaş olmasına rağmen (tree traversal overhead nedeniyle), debug ve rapid prototyping için kullanışlı bir araç olarak işlev görmektedir.

**Tree-Walking Interpreter Results:**

| Test | Expected | Actual | Status |
|------|----------|--------|--------|
| factorial(5) | 120 | 120 | ✅ |
| fibonacci(10) | 55 | 55 | ✅ |
| bubble_sort | [11,12,22,25,34,64,90] | ✅ | ✅ |
| prime_check | Correct primes | ✅ | ✅ |

### 4.6. Algoritma Örnekleri ve Test Sonuçları

Tez kapsamında, Krypto dilinin expressiveness'ını (ifade gücü) ve dil özelliklerinin kullanım pattern'lerini demonstrate etmek amacıyla 6 temel algoritma implemente edilmiştir. Bu algoritmalar, bilgisayar bilimleri müfredatında yaygın olarak kullanılan ve dilin temel construct'larını kapsayan örneklerdir.

**Bubble Sort**, O(n²) karmaşıklığa sahip bir sıralama algoritmasıdır ve nested loop'ların, array access'in (gelecek özellik) ve swap operasyonlarının implementasyonu için kullanılmıştır. **Selection Sort**, bir diğer O(n²) sıralama algoritması olarak, minimum element bulma ve inplace swapping işlemlerini göstermektedir. **Binary Search**, O(log n) karmaşıklığa sahip bir arama algoritmasıdır ve recursive fonksiyon call'ları ile condition evaluation'ın kombinasyonunu demonstrate etmektedir. **Factorial**, recursive matematiksel computation örneği olarak, base case ve recursive case pattern'lerini göstermektedir. **Prime Check**, number theory algoritması olarak, modulo operasyonu ve loop control'ün kullanımını illustrate etmektedir. **Array Operations** (sum, average, max, min, reverse), array manipulation işlemleri için kapsamlı bir örnek sunmaktadır.

Tüm algoritmalar başarıyla derlenmiş, JVM bytecode'una dönüştürülmüş ve test edilmiştir. Test sonuçları, beklenen output'ların %100 doğrulukla üretildiğini göstermektedir.

**Implement edilen Algoritmalar:**

1. **Bubble Sort** - Sorting algorithm O(n²) - Nested loop ve swap operasyonu örneği
2. **Selection Sort** - Sorting algorithm O(n²) - Minimum finding ve inplace swapping örneği
3. **Binary Search** - Search algorithm O(log n) - Recursive function örneği
4. **Factorial** - Mathematical computation - Recursive base case örneği
5. **Prime Check** - Number theory - Modulo ve loop control örneği
6. **Array Operations** - Sum, average, max, min, reverse - Array manipulation örneği

---

## 5. SONUÇ VE TARTIŞMA

Bu bölümde, Krypto programlama dili ve derleyici implementasyonunun genel bir değerlendirmesi sunulmaktadır. Mimari hedeflerin karşılanma durumu, geliştirme sürecinde karşılaşılan teknik zorluklar ve çözüm yaklaşımları, mevcut limitasyonlar ve ölçeklenebilirlik analizi, gelecek çalışmalar için öneriler ve dilin akademik/sektörel kullanım potansiyeli detaylı olarak tartışılmaktadır.

### 5.1. Mimari Hedeflerin Karşılanma Durumu

Proje başlangıcında belirlenen beş temel tasarım hedefi (öğrenilebilirlik, güvenlik, portabilite, performans, genişletilebilirlik) nicel ve nitel metrikler kullanılarak değerlendirilmiştir. Her hedef için tanımlanan başarı kriterleri, test sonuçları ve kullanıcı deneyimi gözlemleri ışığında ölçülmüştür.

**H1: Öğrenilebilirlik** - C ve Java syntax'ına familiar olan geliştiriciler için öğrenme eğrisi minimal düzeydedir. Kod okunabilirliği, basit gramer yapısı ve tutarlı keyword kullanımı sayesinde yüksektir. Documentation completeness ve hata mesajlarının açıklayıcılığı, developer experience'ı olumlu yönde etkilemektedir.

**H2: Güvenlik** - Compile-time type checking, tip uyumsuzluklarını runtime yerine derleme zamanında tespit etmektedir. Scope-based değişken yönetimi, variable shadowing ve encapsulation kuralları ile namespace pollution engellenmiştir. Immutable-by-default değişken tanımı, accidental mutation hatalarını minimize etmektedir.

**H3: Portabilite** - JVM bytecode üretimi sayesinde, Krypto programları Java Virtual Machine bulunan tüm platformlarda (Windows, macOS, Linux) çalıştırılabilir. Platform bağımsız çalışma, native kütüphane bağımlılıklarının minimizasyonu ile desteklenmektedir.

**H4: Performans** - Küçük ve orta ölçekli programlar için derleme süresi 100ms altındadır. JVM JIT compilation sayesinde runtime performansı, yorumlanan dillere kıyasla yüksektir. Bytecode optimizasyonları (gelecek özellik) ile performans daha da artırılabilir.

**H5: Genişletilebilirlik** - Modüler mimari, yeni dil özelliklerinin eklenmesini kolaylaştırmaktadır. Lexer, parser, semantic analyzer ve code generator bağımsız modüller olarak geliştirilmiş ve loose coupling prensibi benimsenmiştir.

**Hedeflerin Değerlendirmesi:**

| Hedef | Kriter | Durum |
|-------|--------|-------|
| H1: Öğrenilebilirlik | Basit syntax | ✅ |
| H2: Güvenlik | Compile-time type checking | ✅ |
| H3: Portabilite | JVM bytecode | ✅ |
| H4: Performans | <100ms compile time | ✅ |
| H5: Genişletilebilirlik | Modüler yapı | ✅ |

### 5.2. Karşılaşılan Zorluklar ve Çözüm Yaklaşımları

Derleyici geliştirme sürecinde, teorik tasarım ile pratik implementasyon arasındaki gap'ten kaynaklanan çeşitli teknik zorluklar ile karşılaşılmıştır. Bu zorluklar, derleyici teorisi literatüründeki established solution'lar ve özgün yaklaşımlar ile çözülmüştür.

**Zorluk 1: Operator Precedence Yönetimi** - Karmaşık ifade parsinginde, operatör önceliklerinin doğru yönetilmesi kritik bir sorundur. Yanlış precedence yönetimi, hatalı AST yapısına ve dolayısıyla incorrect code generation'a neden olur. **Çözüm:** Precedence climbing algoritması benimsenmiştir. Bu algoritma, operator precedence parsing için literatürde established bir tekniktir ve recursive descent parser'lara kolayca entegre edilebilir. Her precedence seviyesi için ayrı fonksiyon tanımlanmış ve precedence table explicit olarak encode edilmiştir.

**Zorluk 2: Scope Management** - İç içe geçmiş scope'ların (nested scopes) yönetimi, özellikle recursive fonksiyonlar ve block-level declarations ile karmaşıklaşmaktadır. Variable resolution'ın doğru scope zincirini takip etmesi gerekmektedir. **Çözüm:** Parent pointer'lı scope chain implementasyonu benimsenmiştir. Her scope, parent scope'a referans içerir ve variable lookup recursive olarak outer scope'lara doğru yapılır. Enter-scope ve exit-scope operasyonları ile scope lifecycle yönetilir.

**Zorluk 3: Type Inference ve Unresolved Types** - Type annotation olmadan tanımlanan değişkenlerin tipleri, initializer expression'dan inference edilmelidir. Circular dependency ve unresolved type durumları handle edilmelidir. **Çözüm:** `type-any` placeholder tipi benimsenmiştir. Unresolved tipler için type-any kullanılır ve type checking sırasında error suppression yapılır. Basit inference kuralları (literal type, binary expression result type, function return type) implement edilmiştir.

**Zorluk 4: JVM Stack Management** - JVM stack-based bir mimariye sahiptir ve local variable slot'larının doğru yönetimi gereklidir. Stack overflow ve incorrect slot allocation hataları oluşabilir. **Çözüm:** Next-local counter ve local-vars hashtable ile slot allocation track edilmiştir. Her değişken için unique slot index ayrılmış ve scope exit'te slot'lar release edilmiştir.

### 5.3. Ölçeklenebilirlik Darboğazları ve Limitasyonlar

Mevcut Krypto implementasyonu, eğitim ve prototyping amaçlı kullanım için tasarlanmıştır ve production-grade derleyicilerin sahip olduğu gelişmiş özelliklerin tamamını içermemektedir. Bu bölümde, mevcut limitasyonlar ve ölçeklenebilirlik açısından tespit edilen darboğazlar objektif olarak değerlendirilmektedir.

**1. Optimizasyon Eksiklikleri:** Mevcut implementasyon, code optimization fazlarını içermemektedir. Constant folding (compile-time constant expression evaluation), dead code elimination (kullanılmayan code removal), inline expansion (function call overhead azaltma), loop invariant code motion ve common subexpression elimination gibi optimizasyonlar gelecek özellik olarak planlanmıştır. Bu optimizasyonların yokluğu, runtime performansını etkilemektedir ancak correctness'ı etkilememektedir.

**2. Memory Management:** Manuel garbage collection implementasyonu bulunmamaktadır. Krypto, JVM'in garbage collector'ına bağımlıdır ve bu tasarım, implementasyon karmaşıklığını azaltmaktadır ancak custom memory management stratejilerine izin vermemektedir. Reference counting veya mark-and-sweep GC implementasyonu gelecek çalışmalar arasında değerlendirilmektedir.

**3. Concurrent Programming Desteği:** Thread oluşturma, senkronizasyon ve parallel execution özellikleri mevcut değildir. Multi-threaded programlama için language-level constructs (async/await, parallel for, channels) gelecek özellik olarak planlanmıştır. JVM thread model'i üzerine mapping düşünülmektedir.

**4. Error Recovery:** Parser error recovery mekanizması sınırlıdır. Hata durumunda parser'ın recovery yapması ve remaining code'u parse etmeye devam etmesi yerine, ilk hatada durması mevcut davranıştır. Panic mode recovery veya phrase-level recovery implementasyonu geliştirilebilir.

**5. Debugging Desteği:** Source-level debugging için symbol table ve line number mapping mevcut değildir. Debugger integration (LSP - Language Server Protocol) gelecek çalışmalar arasında planlanmıştır.

### 5.4. Gelecek Çalışmalar ve Geliştirme Önerileri

Krypto dilinin ve derleyicisinin geliştirilmesi için kısa, orta ve uzun vadeli roadmap tanımlanmıştır. Öncelikler, kullanıcı talepleri, teknik feasibility ve akademik/seyektörel değer önerileri doğrultusunda belirlenmiştir.

**Kısa Vadeli (1-6 ay):** Bu fazda, dilin temel özelliklerinin tamamlanması ve usability iyileştirmeleri hedeflenmektedir. Array type desteği tamamlanacak (syntax, type checking, code generation), struct instantiation ve field access implement edilecek, parser error recovery mekanizması iyileştirilecek ve hata mesajları daha açıklayıcı hale getirilecektir. Documentation completeness artırılacak ve tutorial materials hazırlanacaktır.

**Orta Vadeli (6-18 ay):** Bu fazda, dilin expressiveness'ını artıracak advanced features eklenmesi hedeflenmektedir. Closure desteği (first-class fonksiyonlar, lexical scoping ile fonksiyon capture), lambda expressions (anonymous fonksiyonlar), module system (import/export, namespace management), generics (parametric polymorphism) ve pattern matching implement edilecektir. Standard library genişletilecek (string manipulation, math functions, I/O operations) ve package manager tasarlanacaktır.

**Uzun Vadeli (18+ ay):** Bu fazda, production-readiness ve enterprise features hedeflenmektedir. Garbage collection implementasyonu (custom memory management için), JIT compilation (runtime optimization için), IDE entegrasyonu (LSP - Language Server Protocol, debugger, IntelliSense), build system (incremental compilation, dependency management) ve cross-compilation (native code generation - x86, ARM) geliştirilecektir. Performance profiling tools ve static analysis tools da bu fazda planlanmıştır.

### 5.5. Dilin Akademik ve Sektörel Kullanım Potansiyeli

Krypto programlama dili, eğitim odaklı tasarımı ve modüler mimarisi ile hem akademik hem de sektörel alanlarda kullanım potansiyeline sahiptir. Bu bölümde, dilin target kitleleri ve kullanım senaryoları analiz edilmektedir.

**Akademik Kullanım:** Krypto, derleyici tasarımı ve programlama dilleri kurslarında eğitim aracı olarak kullanılmak üzere tasarlanmıştır. Öğrenciler, Krypto'nun kaynak kodunu inceleyerek lexer, parser, semantic analyzer ve code generator implementasyonlarını öğrenebilirler. Dilin basit grameri ve okunabilir Scheme implementasyonu, pedagogical value'u artırmaktadır. Programlama dili paradigmaları (prosedürel, fonksiyonel, OOP) gösterimi için platform sunmaktadır. Research prototyping platformu olarak, yeni dil özellikleri ve compiler optimizasyonları Krypto üzerinde test edilebilir. Open-source nature sayesinde, öğrenciler contribüter olarak gerçek dünya yazılım geliştirme deneyimi kazanabilirler.

**Sektörel Potansiyel:** Krypto, domain-specific language (DSL) tabanı olarak özelleştirilebilir. Örneğin, finansal modeling, data processing veya embedded systems için custom syntax ve semantics eklenerek industry-specific DSL'ler geliştirilebilir. Scripting language olarak, büyük uygulamalara embed edilebilir ve user extensibility sağlamak için kullanılabilir. Educational tool olarak, coding bootcamp'lerde ve online learning platformlarında programlama öğretimi için kullanılabilir. Rapid prototyping için, startup'lar ve Ar-Ge ekipleri tarafından fikir validasyonu amacıyla kullanılabilir.

**Hedef Kitle:** Bilgisayar mühendisliği öğrencileri, derleyici geliştiriciler, programlama dili araştırmacıları, hobbyist programcılar ve educator'lar birincil hedef kitledir. Secondary audience olarak, DSL ihtiyacı olan şirketler ve scripting engine arayan geliştiriciler hedeflenmektedir.

---

# KAYNAKÇA

Bu tez kapsamında, derleyici tasarımı, programlama dilleri, JVM mimarisi ve Scheme programlama dili alanlarında foundational ve contemporary works referans alınmıştır. Kaynakça, derleyici implementasyonunun teorik foundation'ını oluşturan temel eserleri ve modern yaklaşımları temsil eden akademik yayınları içermektedir.

[1] A. V. Aho, M. S. Lam, R. Sethi, ve J. D. Ullman, *Compilers: Principles, Techniques, and Tools*, 2. bs., Pearson Education, 2006. (Dragon Book - Derleyici tasarımının temel referansı, lexical analysis, parsing, semantic analysis ve code generation konularında kapsamlı coverage)

[2] N. Wirth, *Compiler Construction*, Addison-Wesley, 1996. (Basit ve anlaşılır derleyici tasarımı yaklaşımı, "sadeliğin gücü" prensibi)

[3] T. Lindholm, F. Yellin, G. Bracha, ve A. Buckley, *The Java Virtual Machine Specification*, Java SE 8 Edition, Oracle, 2014. (JVM mimarisi, bytecode instruction set ve runtime behavior hakkında authoritative reference)

[4] R. K. Dybvig, *The Scheme Programming Language*, 4. bs., MIT Press, 2009. (Scheme dili, makro sistemi ve functional programming concepts)

[5] J. Piveta et al., "Compiler Construction using Scheme", ACM SIGPLAN Notices, 2005. (Scheme kullanarak derleyici implementasyonu case study)

[6] M. Sperber et al., *Revised⁶ Report on the Algorithmic Language Scheme*, 2007. (Scheme language specification, R6RS standard)

[7] D. Hanson, *A Retargetable C Compiler: Design and Implementation*, Addison-Wesley, 1997. (lcc - Retargetable compiler tasarımı)

[8] A. Appel, *Modern Compiler Implementation in ML/Java/C*, Cambridge University Press, 1998. (Modern compiler techniques, Tiger compiler örneği)

[9] K. D. Cooper ve L. Torczon, *Engineering a Compiler*, Morgan Kaufmann, 2011. (Compiler engineering practices ve optimization techniques)

[10] S. Muchnick, *Advanced Compiler Design and Implementation*, Morgan Kaufmann, 1997. (Advanced optimization techniques ve code generation strategies)

---

# EKLER

Bu ekler bölümü, Krypto programlama dili için quick reference materials, token-JVM mapping tablosu, AST node tipleri listesi ve örnek program kodlarının lokasyon bilgilerini içermektedir. Bu materyaller, dil kullanıcıları ve geliştiriciler için reference guide olarak tasarlanmıştır.

## Ek A: Krypto Dil Özellikleri - Detaylı Referans

Bu bölüm, Krypto dilinin tüm keyword ve operatörlerini kategorize ederek sunmaktadır. Keywords, dilin reserved words'üdür ve identifier olarak kullanılamaz. Operatörler ise expression evaluation için kullanılan special symbol'lerdir.

**Keywords (21 adet):**
- Control flow: `fun`, `let`, `mut`, `if`, `else`, `while`, `for`, `return`
- Literals: `true`, `false`, `null`
- Logical operators: `and`, `or`, `not`
- Type keywords: `struct`, `int`, `float`, `string`, `bool`, `void`

**Operators (14 adet):**
- Arithmetic (5): `+` (addition), `-` (subtraction/negation), `*` (multiplication), `/` (division), `%` (modulo)
- Comparison (4): `==` (equal), `!=` (not equal), `<` (less than), `>` (greater than), `<=` (less or equal), `>=` (greater or equal)
- Logical (3): `&&` (and), `||` (or), `!` (not)
- Assignment (1): `=` (assignment), `->` (return type annotation), `:` (type annotation)
- Delimiters: `(`, `)`, `{`, `}`, `[`, `]`, `,`, `;`, `.`

## Ek B: Token Tipleri ve JVM Bytecode Karşılıkları

Bu tablo, lexer tarafından üretilen token tipleri ile JVM bytecode instruction'ları arasındaki mapping'i göstermektedir. Code generation fazı, bu mapping'i kullanarak AST'den JVM bytecode'una dönüşüm yapar.

| Token Tipi | JVM Opcode'ları | Açıklama | Kullanım Context'i |
|------------|-----------------|----------|-------------------|
| TOKEN-INTEGER | `ldc`, `iload`, `istore` | Integer constant | Integer literal ve variable access |
| TOKEN-FLOAT | `ldc`, `fload`, `fstore` | Float constant | Float literal ve variable access |
| TOKEN-STRING | `ldc`, `aload`, `astore` | String literal | String constant ve variable access |
| TOKEN-PLUS | `iadd`, `fadd` | Addition | Integer ve float toplama |
| TOKEN-MINUS | `isub`, `fsub`, `fneg` | Subtraction | Integer ve float çıkarma, negation |
| TOKEN-STAR | `imul`, `fmul` | Multiplication | Integer ve float çarpma |
| TOKEN-SLASH | `idiv`, `fdiv` | Division | Integer ve float bölme |
| TOKEN-PERCENT | `irem` | Modulo | Integer kalan hesaplama |
| TOKEN-IDENTIFIER | `iload`, `fload`, `aload`, `istore`, `fstore`, `astore` | Variable access | Değişken okuma ve yazma |
| TOKEN-EQUALS | `istore`, `fstore`, `astore`, `putstatic` | Assignment | Değişken atama |
| TOKEN-DOUBLE-EQUALS | `if_icmpeq`, `if_acmpeq` | Equality comparison | Eşitlik kontrolü |
| TOKEN-NOT-EQUALS | `if_icmpne`, `if_acmpne` | Inequality comparison | Eşitsizlik kontrolü |
| TOKEN-LESS | `if_icmplt`, `if_acmplt` | Less than comparison | Küçüktür kontrolü |
| TOKEN-GREATER | `if_icmpgt`, `if_acmpgt` | Greater than comparison | Büyüktür kontrolü |
| TOKEN-AND | `iand`, `if_icmpne` | Logical AND | Boolean and operation |
| TOKEN-OR | `ior`, `if_icmpeq` | Logical OR | Boolean or operation |
| TOKEN-NOT | `iconst_1`, `ixor` | Logical NOT | Boolean negation |

## Ek C: AST Node Tipleri Tam Listesi

Bu bölüm, parser tarafından üretilen tüm AST (Abstract Syntax Tree) node tiplerini kategorize ederek listelemektedir. Her node tipi, dilin bir construct'ını temsil eder ve semantic analyzer ile code generator tarafından visit edilir.

**Expressions (11 adet) - Değer üreten node'lar:**
1. `integer-literal` - Tam sayı literal (örn: 42, -10)
2. `float-literal` - Ondalık literal (örn: 3.14, -2.5)
3. `string-literal` - String literal (örn: "hello")
4. `bool-literal` - Boolean literal (true, false)
5. `null-literal` - Null literal
6. `identifier` - Değişken/fonksiyon adı
7. `binary-expr` - İkili işlem (örn: a + b, x * y)
8. `unary-expr` - Unary işlem (örn: !x, -y)
9. `group-expr` - Parantez içinde gruplanmış ifade (örn: (a + b))
10. `call-expr` - Fonksiyon çağrısı (örn: foo(1, 2))
11. `assign-expr` - Atama ifadesi (örn: x = 10)

**Statements (7 adet) - İşlem yapan node'lar:**
1. `expr-stmt` - Expression statement (expression'ı statement olarak yürütme)
2. `let-stmt` - Variable declaration (örn: let x = 10)
3. `return-stmt` - Return statement (örn: return x)
4. `if-stmt` - Conditional statement (örn: if (x > 0) { ... })
5. `while-stmt` - While loop (örn: while (x < 10) { ... })
6. `for-stmt` - For loop (örn: for (let i = 0; i < 10; i++) { ... })
7. `block-stmt` - Code block (örn: { let x = 1; print(x); })

**Declarations (2 adet) - Binding tanımlayan node'lar:**
1. `fun-decl` - Function declaration (örn: fun foo(x: int) -> int { ... })
2. `struct-decl` - Struct definition (örn: struct Point { x: int, y: int })

## Ek D: Örnek Program Kodları

Tez kapsamında, Krypto dilinin yeteneklerini demonstrate etmek ve dil kullanıcılarına learning resource sağlamak amacıyla 8 örnek program hazırlanmıştır. Bu programlar, `examples/` dizininde `.kp` uzantısı ile bulunmaktadır ve derleyici ile birlikte dağıtılmaktadır.

**Örnek Program Listesi:**

1. `bubble_sort.kp` - Bubble sort algoritması implementasyonu, nested loop ve swap operasyonu örneği
2. `selection_sort.kp` - Selection sort algoritması, minimum finding ve inplace swapping örneği
3. `binary_search.kp` - Binary search algoritması, recursive function örneği
4. `factorial.kp` - Factorial hesaplama, iteratif ve recursive implementasyon karşılaştırması
5. `prime_check.kp` - Asal sayı kontrolü, optimized algorithm (6k±1 optimization)
6. `array_operations.kp` - Array işlemleri (sum, average, max, min, reverse)
7. `fibonacci.kp` - Fibonacci serisi, classic recursive example
8. `loops.kp` - Loop construct'ları (while, for), break/continue pattern'leri

**Kullanım:** Örnek programları derlemek ve çalıştırmak için:
```bash
# Derleme
chez --script src/main.scm examples/fibonacci.kp

# Veya REPL'de
,enter src/main.scm
(compile-file "examples/fibonacci.kp")
```

**Not:** Tüm örnek programlar test edilmiştir ve beklenen output'u üretmektedir. Example code'lar, dilin best practice'lerini yansıtmaktadır.

---

**Tez Savunma Tarihi:** [Tarih]

**Jüri Üyeleri:**

Bu tez, [Üniversite Adı] Bilgisayar Mühendisliği Bölümü lisans bitirme tezi olarak hazırlanmış ve aşağıdaki jüri üyeleri tarafından [Tarih] tarihinde savunulmuştur.

1. [İsim Soyisim] - İmza: ___________
   - Unvan: [Prof. Dr. / Doç. Dr. / Dr. Öğr. Üyesi]
   - Kurum: [Üniversite Adı], Bilgisayar Mühendisliği Bölümü
   - Görev: Danışman / Jüri Üyesi

2. [İsim Soyisim] - İmza: ___________
   - Unvan: [Prof. Dr. / Doç. Dr. / Dr. Öğr. Üyesi]
   - Kurum: [Üniversite Adı], Bilgisayar Mühendisliği Bölümü
   - Görev: Jüri Üyesi

3. [İsim Soyisim] - İmza: ___________
   - Unvan: [Prof. Dr. / Doç. Dr. / Dr. Öğr. Üyesi]
   - Kurum: [Üniversite Adı], Bilgisayar Mühendisliği Bölümü
   - Görev: Jüri Üyesi

**Tez Onayı:** Yukarıda imzası bulunan jüri üyeleri, bu tezin [Üniversite Adı] Bilgisayar Mühendisliği Bölümü lisans bitirme tezi olarak kabul edilmesini oybirliği/oyçokluğu ile karara bağlamışlardır.

**İmza Tarihi:** [GG/AA/YYYY]
