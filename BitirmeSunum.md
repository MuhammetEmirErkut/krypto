
# Krypto Programlama Dili
## Tasarım ve Derleyici Uygulaması

**Hazırlayan:** Erkut
**Bölüm:** Bilgisayar Mühendisliği / Yazılım Mühendisliği

---

# Projenin Temel Amacı

* **Yeni Bir Dil:** Scheme tabanlı, öğrenmesi kolay, C/Java benzeri sözdizimi.
* **Uçtan Uca Derleyici:** Lexer, Parser ve Code Gen. aşamalarından oluşan tam mimari.
* **JVM Hedefi:** Jasmin üzerinden Java Bytecode (`.class`) üreterek JVM'de yerel performans.
* **Güvenlik:** Statik tip çıkarımı ve prosedürel yapı.

---

# Derleyici Akış Diyagramı (Pipeline)

```mermaid
graph LR
    A[Kaynak Kod<br>.kp] -->|Lexical Analysis| B(Lexer)
    B -->|Token Stream| C(Parser)
    C -->|AST| D(Jasmin Code Gen)
    D -->|.j dosyası| E(Assembler)
    E -->|Java Bytecode| F((JVM))
    
    style A fill:#f9f9f9,stroke:#333
    style B fill:#e1f5fe,stroke:#333
    style C fill:#e1f5fe,stroke:#333
    style D fill:#e1f5fe,stroke:#333
    style E fill:#fff9c4,stroke:#333
    style F fill:#c8e6c9,stroke:#333
```

---

# Sözlüksel Analiz (Lexer)

* **Sonlu Durum Makinesi (DFA)** karakterleri okur, anlamsız boşlukları temizler ve **Token**'lara ayırır.

```mermaid
stateDiagram-v2
    direction LR

    [*] --> q_start
    
    %% Tanımlayıcılar ve Anahtar Kelimeler
    q_start --> q_id : Harf veya _
    q_id --> q_id : Harf/Rakam
    q_id --> [*] : Kabul (ID / Keyword)
    
    %% Sayılar (Integer & Float)
    q_start --> q_num : Rakam
    q_num --> q_num : Rakam
    q_num --> [*] : Kabul (Integer)
    q_num --> q_dot : Nokta (.)
    q_dot --> q_float : Rakam
    q_float --> q_float : Rakam
    q_float --> [*] : Kabul (Float)
    
    %% Metinler (Strings)
    q_start --> q_str : Çift Tırnak
    q_str --> q_str : Karakterler
    q_str --> [*] : Kabul (String)
    
    %% Yorum Satırı ve Bölme
    q_start --> q_slash : / Sembolü
    q_slash --> [*] : Kabul (Bölme)
    q_slash --> q_comment : / Sembolü
    q_comment --> q_comment : Karakterler
    q_comment --> [*] : Yoksay
    
    %% Çoklu Karakterli Operatörler
    q_start --> q_op : Op Başlangıcı
    q_op --> [*] : Kabul (Tekli)
    q_op --> q_op_double : Op Devamı
    q_op_double --> [*] : Kabul (Çiftli)
    
    %% Mantıksal Operatörler
    q_start --> q_and : & Sembolü
    q_and --> q_and_and : & Sembolü
    q_and_and --> [*] : Kabul (AND)
    
    q_start --> q_or : | Sembolü
    q_or --> q_or_or : | Sembolü
    q_or_or --> [*] : Kabul (OR)

    %% Tek Karakterlik Ayraç ve Operatörler
    q_start --> q_single : Ayraçlar/Semboller
    q_single --> [*] : Kabul (Sembol)
```

**Örnek:** `let x = 42;` $\rightarrow$ `KEYWORD`, `IDENTIFIER`, `EQUALS`, `INTEGER`, `SEMICOLON`

---

# Sözdizimsel Analiz (Parser) - Gramer

* Token dizisinin **EBNF** gramerine uygunluğunu denetler.
* **Özyinelemeli Aşağı İnişli (Recursive Descent)** ayrıştırma kullanır.

**Örnek Gramer (Değişken Tanımlama):**
```ebnf
letStmt = "let" "mut"? IDENTIFIER ( ":" type )? "=" expression ";" ;
```

**Krypto Kodu:**
```krypto
let mut counter: int = 0;
```

---

# Sözdizimsel Analiz (Parser) - AST 

* Kodun hiyerarşik yapısı için **Soyut Sözdizimi Ağacı (AST)** inşa edilir.
* İşlem öncelikleri **Öncelik Tırmanma (Precedence Climbing)** ile çözülür.

**İfade:** `1 + 2 * 3`

**AST (Scheme Listesi):**
```scheme
(binary-expr add 
(integer 1) 
(binary-expr multiply (integer 2) (integer 3)))
```

---

# Jasmin Ara Kod Üretimi (Code Generation)

* AST düğümlerini okunabilir assembly dili olan **Jasmin (.j)** formatına çevirir.
* JVM **Stack (Yığın)** tabanlıdır; işlemler yığın (push/pop) üzerinden yürütülür.

**Krypto Kodu:**
```krypto
let x = 5 + 3;
```

**Jasmin Assembly:**
```jasmin
ldc 5
ldc 3
iadd
istore_0
```

---

# Java Bytecode ve JVM Yürütme

* Jasmin kodları assembler ile **Java Bytecode (`.class`)** formatına derlenir.
* Krypto programları JVM'de sanal bir `Main` sınıfı olarak çalışır.

**Çalışma Zamanı (Runtime):** 
* Metotlar JVM Stack üzerinde izole *Frame* olarak yürütülür.
* Referanslar Heap'te tutulur ve *Garbage Collector* ile otomatik temizlenir.

---

# Krypto IDE ve Geliştirme Ortamı

* **REPL Desteği:** Etkileşimli kod denemeleri (Read-Eval-Print Loop).
* **Modüler Tasarım:** Bağımsız ve izole test edilebilir derleyici aşamaları.
* **Hata Yönetimi:** Satır/sütun hassasiyetinde konum odaklı geri bildirim.

---

# Sonuç ve Değerlendirme

* **Hedeflere Ulaşıldı:** JVM hedefli, statik tip denetimli tam işlevsel derleyici tamamlandı.
* **Yüksek Performans:** Milisaniyelik derleme hızı ve JVM seviyesinde çalışma performansı.
* **Gelecek Potansiyeli:** Öğrenmesi kolay, akademik eğitime ve geliştirmeye uygun modern mimari.

**Teşekkür Ederim.**
