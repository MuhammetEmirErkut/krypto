# 📚 Öğrenmem Gerekenler

## 1. Scheme/Lisp Temelleri
- [ ] S-expressions (s-ifadeleri)
- [ ] Liste işlemleri (car, cdr, cons)
- [ ] Recursive fonksiyonlar
- [ ] Higher-order fonksiyonlar (map, filter, fold)
- [ ] Makrolar (macros) - ileri seviye
- [ ] Pattern matching
- [ ] Chez Scheme'e özgü özellikler

### Kaynaklar:
- "The Little Schemer" kitabı
- "Structure and Interpretation of Computer Programs" (SICP)
- Chez Scheme User's Guide

---

## 2. Derleyici/Yorumlayıcı Teorisi

### 2.1 Lexical Analysis (Sözcüksel Analiz)
- [ ] Finite automata (sonlu otomatlar)
- [ ] Regular expressions (düzenli ifadeler)
- [ ] Token kavramı
- [ ] Lexer generator'lar (lex, flex) - konsept olarak

### 2.2 Parsing (Sözdizimsel Analiz)
- [ ] Context-free grammars (CFG)
- [ ] BNF / EBNF notasyonu
- [ ] Recursive descent parsing
- [ ] Operator precedence parsing (Pratt parsing)
- [ ] LL ve LR parser'lar - konsept olarak
- [ ] Abstract Syntax Tree (AST)

### 2.3 Semantic Analysis (Anlamsal Analiz)
- [ ] Symbol tables
- [ ] Scope ve binding
- [ ] Type systems temelleri
- [ ] Type checking vs type inference
- [ ] Static vs dynamic typing

### 2.4 Code Generation (Kod Üretimi)
- [ ] Intermediate representations (IR)
- [ ] Three-address code
- [ ] SSA (Static Single Assignment) formu
- [ ] Register allocation - temel
- [ ] Stack machines vs register machines

### Kaynaklar:
- "Crafting Interpreters" by Robert Nystrom (ÜCRETSİZ - craftinginterpreters.com)
- "Writing An Interpreter In Go" by Thorsten Ball
- "Engineering a Compiler" by Cooper & Torczon
- "Compilers: Principles, Techniques, and Tools" (Dragon Book)

---

## 3. Tip Sistemleri (Type Systems)

- [ ] Statik vs dinamik tipleme
- [ ] Tip çıkarımı (Hindley-Milner)
- [ ] Generics / Parametric polymorphism
- [ ] Algebraic Data Types (ADT)
- [ ] Sum types ve product types
- [ ] Option/Maybe types
- [ ] Type variance (covariance, contravariance)

### Kaynaklar:
- "Types and Programming Languages" by Benjamin Pierce

---

## 4. Veri Yapıları ve Algoritmalar

- [ ] Hash tables (symbol table için)
- [ ] Trees (AST için)
- [ ] Graphs (control flow analysis için)
- [ ] Stack (parser için)
- [ ] Recursive algorithms

---

## 5. Programlama Dili Tasarımı

- [ ] Syntax tasarım prensipleri
- [ ] Semantik tasarım
- [ ] Ergonomi ve kullanılabilirlik
- [ ] Error messages tasarımı
- [ ] Mevcut dillerin analizi:
  - [ ] Rust (ownership, safety)
  - [ ] Go (simplicity)
  - [ ] Swift (modern syntax)
  - [ ] Kotlin (pragmatic)
  - [ ] TypeScript (gradual typing)

### Kaynaklar:
- Programlama dillerinin tasarım dökümanları
- Language design blog yazıları
- "A History of Programming Languages" makaleleri

---

## 6. Bellek Yönetimi

- [ ] Stack vs heap
- [ ] Garbage collection temelleri
  - [ ] Mark and sweep
  - [ ] Reference counting
  - [ ] Generational GC
- [ ] Ownership ve borrowing (Rust tarzı)
- [ ] RAII pattern

---

## 7. Fonksiyonel Programlama Kavramları

- [ ] Pure functions
- [ ] Immutability
- [ ] Closures ve lexical scoping
- [ ] Currying ve partial application
- [ ] Monads - temel (error handling için)
- [ ] Lazy evaluation

---

## 8. Pratik Beceriler

- [ ] Test-driven development (TDD)
- [ ] REPL-driven development
- [ ] Debugging techniques
- [ ] Git version control
- [ ] Documentation writing

---

## 📖 Önerilen Okuma Sırası

### Başlangıç (İlk 2-4 Hafta):
1. ⭐ **Crafting Interpreters** - Part I ve II (tree-walk interpreter)
2. The Little Schemer (Scheme öğrenmek için)
3. Chez Scheme User's Guide (referans)

### Orta Seviye (1-2 Ay):
4. Crafting Interpreters - Part III (bytecode VM)
5. Writing An Interpreter In Go (farklı perspektif)
6. Types and Programming Languages - ilk bölümler

### İleri Seviye (Gerektiğinde):
7. Engineering a Compiler
8. Dragon Book - seçilmiş bölümler
9. SICP

---

## 🎯 Öncelik Sıralaması

| Konu | Öncelik | Ne Zaman |
|------|---------|----------|
| Scheme temelleri | 🔴 Kritik | Hemen |
| Lexer yazımı | 🔴 Kritik | Faz 1 |
| Parser yazımı | 🔴 Kritik | Faz 2 |
| AST tasarımı | 🔴 Kritik | Faz 2 |
| Type checking | 🟡 Önemli | Faz 3 |
| Interpreter | 🟡 Önemli | Faz 4 |
| Garbage collection | 🟢 Sonra | Faz 5+ |
| Code generation | 🟢 Sonra | Faz 6 |
| Optimizasyon | 🔵 Opsiyonel | Faz 6+ |

---

## 📝 Notlar

- Her konuyu öğrenirken küçük pratik projeler yap
- Konseptleri kendi dilin bağlamında düşün
- Anlamadığın yerleri not al ve tekrar dön
- Diğer dillerin kaynak kodlarını incele (özellikle küçük diller)

