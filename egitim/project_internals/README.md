# Krypto Projesi İç Yapı Dokümantasyonu

Bu klasör, Krypto derleyicisinin iç çalışma mantığını anlamanız için hazırlanmıştır. 

## 1. İnteraktif Tur
Projeyi genel hatlarıyla tanımak için **[İnteraktif Tur](./interactive_tour.scm)** scriptini çalıştırabilirsiniz. Bu script, kaynak kodun derlenme aşamalarını adım adım gösterir.

```bash
chez --script egitim/project_internals/interactive_tour.scm
```

## 2. Kod Analizi (Detaylı Türkçe Açıklamalı)

Orjinal kaynak kodun satır satır Türkçe açıklamalı kopyalarını buradan inceleyebilirsiniz:

*   **[Lexer Kod Analizi](./kod_analizi_lexer.scm)**
    *   `src/lexer/lexer.scm` dosyasının detaylı açıklaması (Token üretimi).
*   **[Parser Kod Analizi](./kod_analizi_parser.scm)**
    *   `src/parser/parser.scm` dosyasının detaylı açıklaması (AST oluşturma).
*   **[Semantik Analiz Kod İncelemesi](./kod_analizi_semantic.scm)**
    *   `src/semantic/analyzer.scm` dosyasının detaylı açıklaması (Tip kontrolü).

## Nasıl Deneyebilirim?

Öğrendiklerinizi pekiştirmek için `examples/` klasöründeki kodları inceleyebilir ve `tests/` klasöründeki test dosyalarındaki senaryolara bakabilirsiniz.
