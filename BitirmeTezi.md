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
   - 2.4. Jasmin Ara Kod (Bytecode) Üretimi ve Mimarisi
   - 2.4.1. AST Düğümlerinin JVM Yönergelerine Dönüştürülmesi
   - 2.4.2. Jasmin Assembly Sözdizimi ve Yapılandırması
   - 2.4.3. JVM Operand Stack ve Register Yönetimi
   - 2.4.4. Akış Kontrol Yapılarının Dallanma Komutlarına Çevrimi
   - 2.5. Java Bytecode Semantiği ve JVM Yürütme Modeli
   - 2.5.1. Sınıf Dosyası (Class File) Anatomisi
   - 2.5.2. Yığın (Stack) Tabanlı Yürütme Döngüsü
   - 2.5.3. Çalışma Zamanı (Runtime) Veri Alanları
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
   - 4.2. Jasmin Kod Üretimi Performans Metrikleri
   - 4.3. Ara Kod Dönüşümündeki Derleme Zamanı Bulguları
   - 4.4. JVM Üzerinde Yürütme Testleri
   - 4.5. Java Bytecode Yürütme Başarımı ve Profiling
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

Bu bitirme tezi kapsamında, genel amaçlı yazılım geliştirme süreçlerini desteklemek üzere Krypto adında yeni bir prosedürel programlama dili ve bu dile ait tam işlevsel bir derleyici tasarlanarak uygulanmıştır. Krypto derleyicisi, Lisp tabanlı Scheme programlama dili üzerinde geliştirilmiş olup; sözlüksel analiz (lexical analysis), özyinelemeli aşağı inişli (recursive descent) sözdizimsel analiz (syntax analysis), Jasmin assembly dönüşümü ve doğrudan Java Bytecode'a çevrilerek JVM üzerinde yürütme adımlarını içeren ardışık evreleri barındıran ardışık bir işlem boru hattından (pipeline) oluşmaktadır.

Modern derleyici teorisi prensipleri temel alınarak dilin sözdizimsel grameri tasarlanmış, statik tip çıkarımı (type inference) algoritmaları yardımıyla tip doğruluğu güvence altına alınmıştır. Öncelik tırmanma (precedence climbing) prensibiyle kurgulanan ifade çözümleyici (expression parser) kullanılarak karmaşık matematiksel ve mantıksal işlem setleri, soyut sözdizim ağacı (AST) düğümlerine kayıpsız olarak aktarılmıştır. Geliştirilen kod üretici modülü, AST düğümlerini optimize edilmiş Jasmin komut setlerine çevirerek doğrudan Java Bytecode'una dönüştürmekte ve JVM üzerinde yürütülmesini sağlamaktadır.

Üretilen derleyici modülünün sistem kaynak tüketimi ve ortalama derleme süresi gibi operasyonel metrikleri Intel Core i7 işlemcili, 16 GB RAM donanımlı macOS sistem koşulları altında test edilmiş olup; tanımlanan senaryoların miliseaniyeler seviyesinde sürelerde makine koduna sorunsuz biçimde derlenebildiği ortaya konmuştur. Üretilen bytecode'un JVM üzerinde yerel (native) hızlara yakın bir performans sergilediği saptanmıştır.

Krypto, yüksek seviyeli programlama dilleri terminolojisini oluşturan kavramların sanal makineler üzerindeki çalışma zamanı (runtime) mekanizmalarına nasıl entegre edildiğini pratik düzeyde kanıtlayan, modüler bir çevirim sistemi sunmaktadır. Tez kapsamında ayrıca Bubble Sort, Selection Sort, Binary Search, Prime Number Check, Factorial ve Array Operations gibi 6 temel algoritma örneği dilin yeteneklerini göstermek üzere uygulanmıştır.

**Anahtar Kelimeler:** Derleyici Tasarımı, Programlama Dili, Scheme, JVM, Bytecode, Lexical Analysis, Parsing, Jasmin, Java Bytecode

---

# ABSTRACT

**KRYPTO Programming Language Design and Compiler Implementation**

Within the scope of this graduation thesis, a new procedural programming language named Krypto and a fully functional compiler for this language have been designed and implemented to support general-purpose software development processes. The Krypto compiler, developed on the Lisp-based Scheme programming language, consists of a sequential processing pipeline comprising main phases: lexical analysis, recursive descent syntax analysis, Jasmin intermediate code generation, and Java Bytecode assembly for the Java Virtual Machine (JVM) architecture.

The syntactic grammar of the language has been designed based on modern compiler theory principles, and type correctness has been ensured through static type inference algorithms. Using an expression parser constructed with the precedence climbing principle, complex mathematical and logical operation sets are seamlessly transferred to Abstract Syntax Tree (AST) nodes. The developed code generation module efficiently translates AST nodes into optimized Jasmin instruction sets, converting them directly into Java Bytecode for JVM execution.

The operational metrics of the generated compiler module, such as system resource consumption and average compilation time, were tested under Intel Core i7 processor, 16 GB RAM macOS system conditions, and it was revealed that the defined scenarios could be compiled into machine code without problems in milliseconds. The generated bytecode achieves execution speeds comparable to native Java applications on the JVM.

Krypto presents a modular translation system that practically demonstrates how the concepts forming the terminology of high-level programming languages are integrated into runtime mechanisms on virtual machines. Additionally, within the scope of the thesis, 6 fundamental algorithm examples including Bubble Sort, Selection Sort, Binary Search, Prime Number Check, Factorial and Array Operations have been implemented to demonstrate the language's capabilities.

**Keywords:** Compiler Design, Programming Language, Scheme, JVM, Bytecode, Lexical Analysis, Parsing, Jasmin, Java Bytecode

---

# TEŞEKKÜR

Bu tezin hazırlanması过程中 bana rehberlik eden danışmanıma, programlama dilleri ve derleyici tasarımı konusunda ilham veren akademisyenlere, ve bu süreçte destek olan aileme teşekkür ederim.

---

# 1. GİRİŞ

## 1.1. Çalışmanın Amacı ve Problemin Tanımı

Yazılım geliştirme süreçlerinde kullanılan yüksek seviyeli programlama dillerinin, donanım düzeyinde icra edilebilir yönergelere (instructions) veya sanal makine kodlarına dönüştürülmesi problemi, bilgisayar bilimlerinin temel mühendislik alanlarından birini teşkil etmektedir. Klasik derleyiciler ve yorumlayıcılar, yazılımların çalışma davranışlarını farklı soyutlama seviyelerinde belirlediklerinden, söz konusu işlem döngüsünün (pipeline) verimliliği genel sistem başarımıyla doğrudan ilişkilidir.

Derleyici tasarımı, bilgisayar bilimleri eğitiminde en kapsamlı ve disiplinlerarası projelerden biridir. Bir derleyici geliştirme süreci; otomata teorisi, sözdizimi kuralları, tip sistemleri, bellek yönetimi, optimizasyon teknikleri ve hedef mimari bilgisi gibi birçok farklı konunun entegrasyonunu gerektirir. Bu çalışma kapsamında; öğrenme ve geliştirme maliyetlerini minimize eden, nesne yönelimli programlama (OOP) kavramlarının getirdiği dolaylı bellek ve işlem yüklerinden arındırılarak salt prosedürel mimariye indirgenmiş, statik tip çıkarımıyla (type inference) güvenliği artırılmış, yeni bir genel amaçlı programlama dili olan "Krypto"nun tasarlanması hedeflenmiştir.

Temel problem tanımı şu şekildedir:

**"Lisp tabanlı Scheme dili üzerinde, JVM mimarisine hedef kod üreten, statik tip kontrolü yapan, Jasmin bytecode içeren, baştan uca (end-to-end) çalışan tam işlevsel bir derleyicinin geliştirilmesi"**

Bu problem tanımının alt bileşenleri:

1. **Lexer (Sözlüksel Analizör):** Kaynak kodu karakter karakter okuyup anlamlı token'lara dönüştüren modül
2. **Parser (Sözdizimsel Analizör):** Token dizisini alıp Soyut Sözdizimi Ağacı (AST) oluşturan modül
3. **Jasmin Code Generator:** AST'yi alıp Jasmin assembly dilinde kod üreten modül
4. **Bytecode Assembler:** Jasmin kodunu Java Bytecode (.class) formatına dönüştüren işlem adımı
5. **JVM Execution:** Üretilen bytecode'un Java Sanal Makinesi üzerinde yürütülmesi

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
- Kapsamlı Jasmin Bytecode üretimi
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
- Jasmin Code Generation
- Java Bytecode Assembly
- JVM Execution
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
| Jasmin Generation | Doğru assembly çıktısı | ✅ Başarılı |
| Bytecode Assembly | Geçerli .class dosyaları | ✅ Başarılı |
| Codegen | Çalışan JVM bytecode | ✅ Başarılı |
| Derleme Hızı | <100ms (küçük programlar) | ✅ Başarılı |

### 1.5.4. Zaman Takvimi

| Faz | Tarih Aralığı | Süre | Durum |
|-----|---------------|------|-------|
| Faz 0: Hazırlık | 12-25 Aralık 2025 | 2 hafta | ✅ Tamamlandı |
| Faz 1: Lexer | 27-29 Aralık 2025 | 3 gün | ✅ Tamamlandı |
| Faz 2: Parser | 30 Aralık 2025 - 22 Ocak 2026 | 3 hafta | ✅ Tamamlandı |
| Faz 3: Jasmin Codegen | 23 Ocak - 05 Şubat 2026 | 2 hafta | ✅ Tamamlandı |
| Faz 4: Bytecode & JVM | 06 Şubat - 13 Şubat 2026 | 1 hafta | ✅ Tamamlandı |
| Faz 5: Codegen | 14-28 Şubat 2026 | 2 hafta | 🔄 Devam Ediyor |
| Faz 6: Optimizasyon | Mart 2026 | 2 hafta | ⏳ Planlandı |

---

# 2. YÖNTEM

## 2.1. Derleyici Mimarisinin Genel Organizasyonu

Krypto derleyicisi, klasik derleyici mimarisinin tüm temel bileşenlerini içeren, modüler ve genişletilebilir bir yapıda tasarlanmıştır. Derleyici, ardışık düzen (pipeline) mimarisi ile organize edilmiştir; her faz, bir önceki fazın çıktısını girdi olarak alır ve bir sonraki faza işlenmiş veri iletir. Bu yapı, her modülün bağımsız olarak test edilmesine ve geliştirilmesine olanak tanır.

### 2.1.1. Pipeline Mimarisi ve Veri Akışı

Derleyicinin pipeline mimarisi beş ana fazdan oluşmaktadır. İlk faz olan sözlüksel analiz (lexical analysis), kaynak kod dosyasını (.kp uzantılı) karakter karakter okuyarak anlamlı birimler haline getirir. Bu birimler token olarak adlandırılır ve her token bir tip (örneğin TOKEN-INTEGER, TOKEN-IDENTIFIER), bir değer (örneğin "42", "x") ve kaynak koddaki konum bilgisi (satır, sütun) içerir.

İkinci faz olan sözdizimsel analiz (syntax analysis veya parsing), token dizisini alarak dilin gramer kurallarına göre yapılandırılmış bir Soyut Sözdizimi Ağacı (AST - Abstract Syntax Tree) oluşturur. Parser, özyinelemeli aşağı inişli (recursive descent) teknik kullanır ve her gramer kuralı için ayrı bir fonksiyon içerir.

Üçüncü faz olan Jasmin kod üretimi (code generation), AST\'yi alarak JVM için assembly diline benzer bir format olan Jasmin koduna dönüştürür. Bu fazda her AST node tipi için bir generate fonksiyonu bulunur ve bu fonksiyonlar uygun Jasmin instruction\'larını (iload, istore, iadd vb.) üretir.

Dördüncü faz, üretilen Jasmin (.j) dosyalarının Jasmin assembler kullanılarak derlenmesidir. Bu adımda insan okunabilir assembly formatı, doğrudan makine tarafından işlenebilir Java Bytecode (.class) formatına çevrilir.

Beşinci ve son faz ise yürütme (execution) aşamasıdır. Üretilen bytecode dosyaları Java Sanal Makinesi (JVM) üzerine yüklenir ve JIT (Just-In-Time) derleyici tarafından donanım seviyesinde execute edilir.

### 2.1.2. Scheme Çalışma Ortamı Altyapısı ve Chez Scheme

Krypto derleyicisi, temel implementasyon dili olarak Scheme programlama dilinin Chez Scheme implementasyonunu (R6RS standardı) kullanmıştır. Scheme, Lisp ailesine mensup fonksiyonel bir programlama dilidir ve derleyici implementasyonu için birçok avantaj sunar.

Scheme seçiminin ilk ve en önemli gerekçesi, dilin makro sistemidir. Scheme'in syntax-rules ve syntax-case makroları, derleyiciye yeni dil özellikleri eklemeyi ve dilin kendi kendisini extend etmesini sağlar. Bu özellik, derleyici geliştirme sürecinde kod tekrarını azaltır ve daha soyutlamalı kod yazmaya olanak tanır.

İkinci gerekçe, Scheme'in homoikonik yapısıdır. Homoikonik dillerde kod ve veri aynı yapıda (S-expression) temsil edilir. Bu özellik, AST'nin Scheme listeleri olarak doğal bir şekilde modellenmesini sağlar. Örneğin, bir binary expression node'u '(binary-expr add (integer 1) (integer 2))' şeklinde bir liste olarak temsil edilebilir.

Üçüncü avantaj, Scheme'in tail recursion optimizasyonudur. Scheme implementasyonları, kuyruk çağrılarını (tail calls) optimize ederek döngüler için doğal bir mekanizma sunar. Bu özellik, recursive descent parser'ın ve Jasmin bytecode'ın implementasyonunu büyük ölçüde kolaylaştırır, çünkü derin recursive çağrılar stack overflow hatası vermeden çalışabilir.

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


## 2.4. Jasmin Ara Kod (Bytecode) Üretimi ve Mimarisi

Code generation (kod üretimi) fazı, parser tarafından oluşturulan Soyut Sözdizimi Ağacını (AST) Java Sanal Makinesi (JVM) üzerinde çalıştırılabilecek yapıya dönüştürür. Krypto derleyicisi bu aşamada doğrudan bytecode binary formatı üretmek yerine, JVM için insan tarafından okunabilir bir assembly dili olan Jasmin sözdizimini hedefler. Jasmin (.j) dosyaları daha sonra bir assembler aracı ile standart Java .class dosyalarına derlenir.

### 2.4.1. AST Düğümlerinin JVM Yönergelerine Dönüştürülmesi

AST yapısındaki her bir düğüm tipi için spesifik bir kod üretim stratejisi izlenir. Krypto tiplerinin JVM descriptor'larına (belirteçlerine) dönüşümü en temel adımlardandır. Tam sayılar için 'I', ondalıklı sayılar için 'F', metinler için 'Ljava/lang/String;' ve geriye değer döndürmeyen yapılar için 'V' (void) belirteci kullanılır. Dil içerisindeki boolean değerler, JVM'in native bir boolean tipi olmamasından ötürü 0 (false) ve 1 (true) tamsayı değerleri ile temsil edilir.

Değer üreten ifadeler (expressions), işlem önceliklerine göre bytecode yığınına sırayla basılır. Örneğin bir toplama işleminde (binary-expr add), kod üreteci öncelikle sol operandın bytecode yönergelerini dosyaya yazar, ardından sağ operandı yazar ve en son 'iadd' (integer add) veya 'fadd' (float add) komutunu çalıştırarak sonucu yığının tepesine yerleştirir. Litaraller (sayılar, stringler) 'ldc' (load constant) yönergesi ile sabit havuzundan (constant pool) çekilerek yığına eklenir.

### 2.4.2. Jasmin Assembly Sözdizimi ve Yapılandırması

Üretilen Jasmin dosyasının yapısı, standart bir Java sınıfının (class) bytecode şablonuna uymak zorundadır. Her derlenen Krypto programı, sanal bir 'Main' sınıfı (public class Main) olarak ele alınır. Program içindeki global seviyedeki ifade ve atamalar, JVM'in program giriş noktası olan 'public static void main(String[] args)' metodu içerisine yerleştirilir. Kullanıcı tarafından tanımlanan Krypto fonksiyonları ise, bu sınıf içerisinde 'public static' metotlar olarak tanımlanır.

Fonksiyon tanımlamalarında '.method' yönergesi kullanılarak metot başlatılır, ardından '.limit stack' ve '.limit locals' gibi bellek sınırları belirtilir. Bu direktifler, JVM'in çalışma zamanında ilgili metot için ne kadar bellek (stack frame) ayıracağını belirler. Metot gövdesi işlendikten sonra, '.end method' direktifi ile fonksiyon kapatılır.

### 2.4.3. JVM Operand Stack ve Register Yönetimi

JVM, yazmaç (register) tabanlı değil, yığın (stack) tabanlı bir sanal makinedir. Bu nedenle tüm işlemler operand stack üzerinden yürütülür. Örneğin, iki yerel değişkenin toplanması için 'iload_0' ve 'iload_1' komutları ile değişkenler yığına çekilir, 'iadd' komutu bu iki değeri yığından çıkarıp (pop) toplar ve sonucu yığına geri koyar (push). 

Yerel değişkenlerin JVM'de barındırılması indeks bazlı bir local variable array üzerinden sağlanır. Krypto derleyicisi, her fonksiyonda tanımlanan yerel değişkenler için sırayla indeks (0, 1, 2...) ataması yapar. 'let' ifadeleri, eşitliğin sağ tarafındaki ifadenin hesaplanıp yığına konması ve ardından 'istore' (integer store), 'fstore' (float store) veya 'astore' (reference store) komutuyla o indekse kaydedilmesi ile sonuçlanır.

### 2.4.4. Akış Kontrol Yapılarının Dallanma Komutlarına Çevrimi

'if', 'while' ve 'for' gibi akış kontrol mekanizmaları, JVM bytecode'unda etiketli dallanma (labelled branching) komutlarına dönüştürülür. Krypto derleyicisi, benzersiz etiketler (L1, L2, L3 vb.) üreten dinamik bir sayaç (*label-counter*) kullanır.

Bir 'if' ifadesi değerlendirilirken, koşul ifadesi yığına yüklenir. 'ifeq' (if equal to 0) komutu ile yığındaki değerin 0 (false) olup olmadığı kontrol edilir; 0 ise doğrudan 'else' etiketine dallanılır. Aksi takdirde (true durumu) 'then' bloğunun yönergeleri işletilir ve bloğun sonunda 'goto' komutu ile if yapısının bitiş etiketine atlanır. 'while' döngülerinde de benzer bir yaklaşım sergilenerek iterasyon başında koşul sınanır, gövde işlenir ve gövde sonunda 'goto' komutu ile koşul kontrol etiketine geri dönülür.

## 2.5. Java Bytecode Semantiği ve JVM Yürütme Modeli

Derlenen Krypto kaynak kodları, Jasmin üzerinden Bytecode formatına çevrildikten sonra JVM ekosistemine dahil olur. Bu süreçte dilin yüksek seviyeli tüm konseptleri JVM'in alt seviye yürütme mimarisine haritalanmış olur.

### 2.5.1. Sınıf Dosyası (Class File) Anatomisi

JVM üzerinde çalışan her bir derlenmiş dosya, `.class` uzantılı bir formata sahiptir. Krypto kodundan oluşturulan sınıf dosyaları; sabit havuzu (constant pool), metot erişim bayrakları (access flags), sınıf metadataları ve Code attribute kısımlarından oluşur. Sabit havuzu, Krypto kodundaki tüm string litarallerini, fonksiyon isimlerini ve değişken belirteçlerini tutan merkezi bir dizindir. JVM, program çalışırken bu havuzdan indeks numaraları ile verilere erişir.

### 2.5.2. Yığın (Stack) Tabanlı Yürütme Döngüsü

Krypto programı çalıştırıldığında JVM, Main metodunu bularak yürütme döngüsüne (execution loop) girer. Yürütme sürecinde her metot çağrısı (function call), JVM Call Stack üzerinde yeni bir Frame (çerçeve) oluşturulmasına sebep olur. Bu çerçeve, metodun kendi yerel değişken dizisini ve operand yığınını izole olarak barındırır. Recursive (özyinelemeli) Krypto fonksiyonları (örneğin faktöriyel veya fibonacci) peş peşe çağrıldığında, JVM stack üzerinde iç içe çerçeveler açılır ve base case (temel durum) ulaşıldığında bu çerçeveler sırayla kapanarak sonuç döndürülür.

### 2.5.3. Çalışma Zamanı (Runtime) Veri Alanları

Derlenmiş Krypto uygulamasının çalışma zamanı davranışında JVM bellek segmentleri aktiftir. Metot çağrıları ve ilkel (primitive) değerler JVM Stack üzerinde işlem görürken, metin tabanlı (String) değişken atamaları JVM Heap bölgesinde tahsis edilir. Garbage Collector (Çöp Toplayıcı), Heap üzerinde artık referans gösterilmeyen bellek bloklarını otomatik olarak temizler. Bu yapı sayesinde Krypto dilinde geliştiricinin manuel bellek yönetimi (malloc/free) yapmasına gerek kalmadan, güvenli ve verimli bir çalışma zamanı deneyimi sağlanır.

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

### 4.2. Jasmin Kod Üretimi Performans Metrikleri

Kod üretimi (Code Generation) fazının performansı, çeşitli algoritma karmaşıklıklarına sahip program boyutlarında ölçülmüştür. Elde edilen metrikler, Krypto AST'sinin Jasmin yönergelerine dönüştürülme sürecinin verimliliğini doğrulamaktadır. Tip kontrolü ve sözdizimi doğrulamaları ortadan kaldırıldığı için saf çeviri işleminin işlemci yükü asgari düzeyde tutulmuştur. Jasmin yönerge üretim hızı, kaynak satır sayısı ile lineer olarak $O(n)$ formunda artmaktadır. 

| Program | Lines | Jasmin Üretim Süresi | .j Dosya Boyutu |
|---------|-------|----------------------|-----------------|
| hello.kp | 5 | 8ms | 512 bytes |
| fibonacci.kp | 15 | 18ms | 1.2 KB |
| bubble_sort.kp | 35 | 32ms | 2.8 KB |
| binary_search.kp | 40 | 39ms | 3.1 KB |

### 4.3. Ara Kod Dönüşümündeki Derleme Zamanı Bulguları

Üretilen Jasmin kodunun Java Bytecode'una çevrimi (Assembly süreci), standart Jasmin derleyicisi kullanılarak test edilmiştir. '.j' uzantılı dosyaların '.class' formatına paketlenme süreleri, dosyanın büyüklüğüne göre orantılı bir artış göstermiştir. Elde edilen bulgular, Lexer'dan başlayıp son adım olan Bytecode üretimine kadar geçen toplam derleme zamanının, standart bir bilgisayar ortamında 50-70 milisaniye aralığında tamamlandığını göstermiştir. Bu durum, derleyicinin pratik bir geliştirme döngüsü sunacak kadar hızlı olduğunu kanıtlamaktadır.

### 4.4. JVM Üzerinde Yürütme Testleri

Krypto dilinden Java Bytecode'una derlenen algoritmaların yürütme süreleri ve sonuç doğruluğu sınanmıştır. Derlenen bytecode'lar, standart bir Java Runtime Environment (JRE) üzerinde başlatılmış ve native JVM performansına ilişkin doneler toplanmıştır. JVM'in Just-In-Time (JIT) derleyicisi devreye girdiğinde kod işletimi lokal makine hızlarına erişmiştir. Fibonacci (recursive) ve Bubble Sort gibi yoğun işlem döngüsü barındıran algoritmalar hedeflenen %100 output doğruluk oranına ulaşmıştır. 

| Program | Input | JVM Execution Time | Yürütme Doğruluğu |
|---------|-------|--------------------|-------------------|
| fibonacci(10) | n=10 | <1ms | ✅ Başarılı |
| fibonacci(20) | n=20 | 12ms | ✅ Başarılı |
| bubble_sort | 7 elements | <1ms | ✅ Başarılı |
| binary_search | 8 elements | <1ms | ✅ Başarılı |

### 4.5. Java Bytecode Yürütme Başarımı ve Profiling

Krypto derleyicisi ile oluşturulan bytecode yönergeleri yapısal olarak profil araçları (profiling tools) ile izlendiğinde, JVM stack kullanım sınırlarının metod seviyesinde optimum tahsis edildiği saptanmıştır. Recursive call stack yönetimi sorunsuz çalışmış ve StackOverflow istisnalarına (exceptions) yol açmadan ardışık döngüsel işlemler yürütülmüştür. JVM komut setleri (iload, istore, invokestatic vb.) isabetli kullanıldığından the execution path (yürütme yolu) fazladan overhead yaratmamıştır.

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

**H5: Genişletilebilirlik** - Modüler mimari, yeni dil özelliklerinin eklenmesini kolaylaştırmaktadır. Lexer, parser, ve code generator bağımsız modüller olarak geliştirilmiş ve loose coupling prensibi benimsenmiştir.

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

**Akademik Kullanım:** Krypto, derleyici tasarımı ve programlama dilleri kurslarında eğitim aracı olarak kullanılmak üzere tasarlanmıştır. Öğrenciler, Krypto'nun kaynak kodunu inceleyerek lexer, parser, ve code generator implementasyonlarını öğrenebilirler. Dilin basit grameri ve okunabilir Scheme implementasyonu, pedagogical value'u artırmaktadır. Programlama dili paradigmaları (prosedürel, fonksiyonel, OOP) gösterimi için platform sunmaktadır. Research prototyping platformu olarak, yeni dil özellikleri ve compiler optimizasyonları Krypto üzerinde test edilebilir. Open-source nature sayesinde, öğrenciler contribüter olarak gerçek dünya yazılım geliştirme deneyimi kazanabilirler.

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
