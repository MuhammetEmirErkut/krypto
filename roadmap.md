# 🗺️ Programlama Dili Geliştirme Yol Haritası

## Faz 0: Hazırlık (1-2 Hafta)
- [x] Scheme/Lisp temellerini öğren
- [x] Dilin syntax tasarımını kağıt üzerinde belirle
- [x] Temel veri tiplerini tanımla (int, float, string, bool)
- [x] Anahtar kelimeleri (keywords) listele
- [x] Basit örnek programlar yaz (hedef syntax ile)

## Faz 1: Lexer / Tokenizer (2-3 Hafta)
- [x] Token tiplerini tanımla
- [x] Karakter okuyucu (character reader) yaz
- [x] Sayı tanıma (integer, float)
- [x] String tanıma (escape karakterleri dahil)
- [x] Identifier ve keyword tanıma
- [x] Operatör tanıma
- [x] Yorum satırı işleme
- [x] Hata raporlama (satır/sütun bilgisi)
- [ ] Lexer testleri yaz

## Faz 2: Parser / AST (3-4 Hafta)
- [x] AST node tiplerini tanımla
- [x] Recursive descent parser yaz
- [x] İfade parsing (expression parsing)
- [x] Operatör önceliği (precedence) uygula
- [x] Statement parsing
- [x] Fonksiyon tanımı parsing
- [x] Kontrol yapıları (if, while, for)
- [ ] Hata kurtarma (error recovery)
- [ ] Parser testleri yaz
- [x] Pretty-printer yaz (debug için)

## Faz 3: Semantik Analiz (3-4 Hafta)
- [x] Symbol table tasarımı
- [x] Scope analizi (lexical scoping)
- [x] İsim çözümleme (name resolution)
- [x] Tip sistemi tasarımı
- [x] Tip kontrolü (type checking)
- [x] Tip çıkarımı (type inference) - basit
- [x] Hata mesajları iyileştirme
- [x] Semantik analiz testleri

## Faz 4: Interpreter (İlk Çalışan Versiyon) (2-3 Hafta)
- [x] AST yorumlayıcı (tree-walking interpreter)
- [x] Değişken ve scope yönetimi
- [x] Fonksiyon çağrıları
- [x] Built-in fonksiyonlar (print, input, vb.)
- [ ] Basit standart kütüphane
- [x] REPL (Read-Eval-Print Loop)
- [x] Interpreter testleri

## Faz 5: Gelişmiş Özellikler (4-6 Hafta)
- [x] Closure desteği
- [ ] Dizi/liste veri tipi
- [ ] Dictionary/map veri tipi
- [ ] Pattern matching(atlanabilir)
- [ ] Error handling mekanizması
- [ ] Modül sistemi
- [ ] Import/export

## Faz 6: Optimizasyon ve Kod Üretimi (Opsiyonel) (6+ Hafta)
- [ ] Intermediate Representation (IR) tasarımı
- [ ] Basit optimizasyonlar
- [ ] Bytecode derleyici
- [ ] Virtual Machine (VM)
- [ ] Veya: LLVM backend

## Faz 7: Ekosistem (Sürekli)
- [ ] Kapsamlı dokümantasyon
- [ ] Örnek projeler
- [ ] Syntax highlighting (VS Code eklentisi)
- [ ] Paket yöneticisi (uzun vadeli)

---

## 📊 Tahmini Süre

| Faz | Süre | Zorluk |
|-----|------|--------|
| Hazırlık | 1-2 hafta | ⭐ |
| Lexer | 2-3 hafta | ⭐⭐ |
| Parser | 3-4 hafta | ⭐⭐⭐ |
| Semantik | 3-4 hafta | ⭐⭐⭐⭐ |
| Interpreter | 2-3 hafta | ⭐⭐⭐ |
| Gelişmiş | 4-6 hafta | ⭐⭐⭐⭐ |
| Kod Üretimi | 6+ hafta | ⭐⭐⭐⭐⭐ |

**Toplam (temel çalışan dil): ~3-4 ay**
**Toplam (tam özellikli): ~6-12 ay**

---

## 🎯 Milestone'lar

### M1: "Hello World" ✨
- Lexer string ve print fonksiyonu tanıyor
- Parser basit ifadeyi çözümleyebiliyor
- Interpreter ekrana yazı basabiliyor

### M2: Hesap Makinesi 🧮
- Aritmetik operatörler çalışıyor
- Değişken tanımlama ve kullanma
- Basit ifadeler değerlendiriliyor

### M3: Fonksiyonlar 📦
- Fonksiyon tanımlama ve çağırma
- Parametreler ve return değeri
- Recursive fonksiyonlar (fibonacci!)

### M4: Kontrol Akışı 🔀
- if/else çalışıyor
- while/for döngüleri
- Karşılaştırma operatörleri

### M5: Gerçek Programlar 🚀
- Tüm temel özellikler tamamlandı
- Basit algoritmalar yazılabiliyor
- Dosya okuma/yazma

---

## 💡 İpuçları

1. **Küçük adımlarla ilerle** - Her özelliği ayrı ayrı test et
2. **Sık sık test yaz** - Regression'ları yakala
3. **Basit başla** - İlk önce çalışan minimal versiyon
4. **Hata mesajlarına önem ver** - Kullanıcı deneyimi kritik
5. **Dokümante et** - Kararlarını ve nedenlerini yaz

