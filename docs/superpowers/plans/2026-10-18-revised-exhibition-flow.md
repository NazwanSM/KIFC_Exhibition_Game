# Revisi Alur Pameran KIFC — Rencana Implementasi

> **Untuk pekerja agen:** SUBSKILL WAJIB: gunakan `superpowers:subagent-driven-development` (direkomendasikan) atau `superpowers:executing-plans` untuk mengerjakan rencana ini per tugas. Langkah memakai kotak centang sebagai pelacak.

**Tujuan:** menyusun ulang empat babak agar tiga unsur api dimainkan terlebih dahulu, lalu diterangkan, dengan layar transisi yang tidak perlu dihilangkan.

**Arsitektur:** pertahankan `_ExhibitionGameState` sebagai pemilik kondisi sesi dan timer. Ringkas `_Page` serta rute `switch` untuk menghapus halaman intro yang berdiri sendiri; tambahkan dua halaman naratif kecil dengan callback eksplisit. Halaman aktivitas yang ada dipakai kembali dan hanya nomor babak serta tujuan perpindahannya yang berubah.

**Tech Stack:** Flutter, Dart 3, `flutter_test`.

**Spesifikasi:** `docs/superpowers/specs/2026-10-18-revised-exhibition-flow-design.md`

## Batasan global

- Aplikasi tetap empat babak, offline, dan ditujukan untuk TV touchscreen portrait tanpa suara.
- Babak 1 dan 2 bertukar posisi; segitiga api diterangkan setelah pemain menyusun tiga unsur.
- Bentuk visual tiga unsur belum diubah dalam rencana ini; perubahan dari segitiga ke kartu/daftar adalah REV-06.
- Karhutla memakai tiga kartu kerja ber-ID tetap: definisi, dampak, dan pencegahan. Naskah klien nantinya mengganti isi, bukan flow.
- Layar yang hanya menjadi pintu masuk ke aktivitas harus dihilangkan. Perpindahan setelah feedback yang dibutuhkan alur berjalan otomatis.
- Detail clue, kesempatan kedua, Korea, maskot final, dan aturan skor bukan bagian implementasi REV-02.
- Indonesia dan Inggris harus tetap muat tanpa scroll pada 360×640 dan 411×731.

## Fokus peninjauan

- Reset dari halaman baru mengosongkan indeks kartu, susunan unsur, jawaban, skor, dan timer.
- Tombol `Lanjut` hanya ada pada kartu naratif, bukan sebagai pengganti tombol masuk aktivitas.
- Perpindahan otomatis tidak boleh jalan dua kali ketika pemain menekan pilihan cepat atau kembali ketika feedback tampil.
- Tantangan akhir tetap menunggu pramuat aset sebelum timer 10 detik berjalan.
- Matriks Indonesia/Inggris pada dua ukuran portrait tetap bebas error dan scroll.

---

## Struktur file

| File | Tanggung jawab |
|---|---|
| `lib/features/game/exhibition_game.dart` | Enum halaman, kondisi alur, halaman naratif, callback, dan nomor babak. |
| `test/game_flow_test.dart` | Perjalanan penuh, kartu naratif, perpindahan otomatis, skor, dan timer. |
| `design/quick-specs/client-revision-tracker-2026-10-18.md` | Status dan bukti penyelesaian REV-02. |

### Task 1: Buat kontrak halaman baru dan reset sesi

**Files:**

- Modify: `lib/features/game/exhibition_game.dart:34-220`
- Modify: `lib/features/game/exhibition_game.dart:365-379`
- Test: `test/game_flow_test.dart`

**Interfaces:**

- Produces: `enum _Page { welcome, triangleBuild, triangleExplanation, breakTriangle, karhutlaCards, risk, causeQuiz, stopDecision, finalChallenge, score, closing }`.
- Produces: `int _karhutlaCardIndex` and `void _advanceKarhutlaCard()`.
- Consumes: `_restart()`, `_go(_Page)`, and existing score/timer state.

- [ ] **Step 1: Write the failing flow test.**

  Assert `Mulai Tantangan` opens `Susun tiga unsur api`, not the old karhutla hotspot. Restart after reaching a karhutla card and assert the next session begins at Babak 1.

- [ ] **Step 2: Run the test to verify it fails.**

  Run: `flutter test test/game_flow_test.dart --no-pub`

  Expected: FAIL because the current flow starts at `_Page.observe`.

- [ ] **Step 3: Implement the state contract.**

  Remove routes for `observe`, `triangleIntro`, `causeIntro`, and `stopIntro`; add the two new page states. Reset `_karhutlaCardIndex` in `_restart()`. Start and replay at `_Page.triangleBuild`. Do not change score or `_openFinal()`.

- [ ] **Step 4: Run the focused test.**

  Run: `flutter test test/game_flow_test.dart --no-pub`

  Expected: PASS once the replacement pages in Tasks 2–3 exist.

### Task 2: Susun Babak 1 dan kartu penjelasan segitiga api

**Files:**

- Modify: `lib/features/game/exhibition_game.dart:743-950`
- Test: `test/game_flow_test.dart`

**Interfaces:**

- Produces: `class _TriangleExplanation extends StatelessWidget` with `bool english`, `VoidCallback onContinue`, and `VoidCallback onBack`.
- Consumes: existing `_FireScene`, `_dropPiece`, `_resetTriangle`, and `Map<_FireSlot, _FirePiece> _triangle`.

- [ ] **Step 1: Write the failing Babak 1 test.**

  Complete three correct drops. Assert the result feedback is followed by a `Segitiga api` explanation card, then `Lanjut` opens `Kurangi satu unsur`. Assert all three pages show chapter 1.

- [ ] **Step 2: Run the test to verify it fails.**

  Run: `flutter test test/game_flow_test.dart --no-pub`

  Expected: FAIL because build is currently chapter 2 and advances directly to the demo.

- [ ] **Step 3: Implement the new ordering.**

  Update `_TriangleBuild` to Babak 1 and make completion route safely to `triangleExplanation`. Create `_TriangleExplanation` explaining that heat, fuel, and oxygen are called the fire triangle even when shown as a list. Its `Lanjut` opens `_BreakTriangle`. Make `_BreakTriangle` Babak 1 and route its continuation to `karhutlaCards`. Preserve the unscored three-element demo.

- [ ] **Step 4: Run the focused test.**

  Run: `flutter test test/game_flow_test.dart --no-pub`

  Expected: PASS for Indonesian and English, with the existing stable fire-panel size assertion.

- [ ] **Step 5: Commit.**

  `git add lib/features/game/exhibition_game.dart test/game_flow_test.dart`

  `git commit -m "feat: move fire elements to first chapter"`

### Task 3: Tambahkan kartu karhutla dan pindahkan soal risiko ke Babak 2

**Files:**

- Modify: `lib/features/game/exhibition_game.dart:506-685`
- Modify: `lib/features/game/exhibition_game.dart` near the narrative page classes
- Test: `test/game_flow_test.dart`

**Interfaces:**

- Produces: `class _NarrativeCard { const _NarrativeCard({required this.id, required this.title, required this.body}); ... }`.
- Produces: `class _KarhutlaCards extends StatelessWidget` with `int index`, `ValueChanged<int> onAdvance`, and `VoidCallback onComplete`.
- Consumes: `_karhutlaCardIndex`, `_RiskPage`, and `_RiskOption`.

- [ ] **Step 1: Write the failing narrative test.**

  Assert IDs `karhutla-definition`, `karhutla-impact`, and `karhutla-prevention` appear in sequence; each uses one `Lanjut`. The final card must open the three-condition risk question marked Babak 2.

- [ ] **Step 2: Run the test to verify it fails.**

  Run: `flutter test test/game_flow_test.dart --no-pub`

  Expected: FAIL because the hotspot page still exists.

- [ ] **Step 3: Implement narrative cards and risk handoff.**

  Replace `_ObservePage` with three short `_NarrativeCard` values. Give the rendered card its ID as `ValueKey<String>`. Update `_RiskPage` to chapter 2 and route its successful completion to `causeQuiz`. Preserve the current photos and choices.

- [ ] **Step 4: Run the focused test.**

  Run: `flutter test test/game_flow_test.dart --no-pub`

  Expected: PASS with no hotspot requirement or scroll.

- [ ] **Step 5: Commit.**

  `git add lib/features/game/exhibition_game.dart test/game_flow_test.dart`

  `git commit -m "feat: add karhutla narrative cards"`

### Task 4: Gabungkan masuknya Babak 3 dan Babak 4

**Files:**

- Modify: `lib/features/game/exhibition_game.dart:952-1333`
- Test: `test/game_flow_test.dart`

**Interfaces:**

- Produces: `Future<void> _advanceAfterFeedback(_Page nextPage)` that captures the active page token and cancels on reset/navigation.
- Consumes: `_CauseQuiz`, `_StopDecision`, `_advanceCause(bool)`, and `_openFinal()`.

- [ ] **Step 1: Write the failing consolidation test.**

  Assert Babak 3 opens on scenario one without `Lihat Situasinya`; the last scenario automatically hands off to Babak 4 without `Lihat Hasil Babak`; Babak 4 shows the spread scene and three choices without `Pilih Tindakan Aman`.

- [ ] **Step 2: Run the test to verify it fails.**

  Run: `flutter test test/game_flow_test.dart --no-pub`

  Expected: FAIL because `_CauseIntro`, the completion page, and `_StopIntro` are still present.

- [ ] **Step 3: Implement consolidated handoffs.**

  Remove `_CauseIntro` and `_StopIntro`. Merge the final cause explanation into the final scenario’s feedback, then call `_advanceAfterFeedback(_Page.stopDecision)`. Use `_StopDecision` as the first Babak 4 page with its existing spread scene and choices. The helper must ignore a delayed callback after a back/restart/page change.

- [ ] **Step 4: Run the focused test.**

  Run: `flutter test test/game_flow_test.dart --no-pub`

  Expected: PASS; the final timer still begins only after image precaching.

- [ ] **Step 5: Commit.**

  `git add lib/features/game/exhibition_game.dart test/game_flow_test.dart`

  `git commit -m "feat: streamline cause and prevention flow"`

### Task 5: Tuntaskan regresi dan tiket REV-02

**Files:**

- Modify: `test/game_flow_test.dart`
- Modify: `test/widget_test.dart` only if a welcome label changes
- Modify: `design/quick-specs/client-revision-tracker-2026-10-18.md`

**Interfaces:**

- Consumes: the new flow and the existing `ControlledStopwatch`.
- Produces: an updated `GameFlow.toDecision()` that follows the revised sequence and evidence that REV-02 is complete.

- [ ] **Step 1: Update the end-to-end matrix.**

  Exercise Indonesian and English at 360×640 and 411×731 through: Babak 1, three karhutla cards, risk, causes, prevention, final challenge, score, and reset. Assert legacy interstitial controls are absent.

- [ ] **Step 2: Run the test to verify behavior.**

  Run: `flutter test test/game_flow_test.dart --no-pub`

  Expected: PASS only when the new helper and all no-scroll assertions cover the revised flow.

- [ ] **Step 3: Mark the ticket complete with evidence.**

  Update the tracker only after the test matrix, lint, and visual review are all recorded.

- [ ] **Step 4: Run complete verification.**

  Run: `flutter analyze --no-pub`

  Expected: no issues.

  Run: `flutter test --no-pub`

  Expected: all tests pass.

- [ ] **Step 5: Commit.**

  `git add test/game_flow_test.dart test/widget_test.dart design/quick-specs/client-revision-tracker-2026-10-18.md`

  `git commit -m "test: cover revised exhibition flow"`

## Hasil peninjauan rencana

- Tugas 1–4 mencakup pertukaran babak, penjelasan segitiga api, tiga kartu karhutla, dan penggabungan layar transisi.
- Tugas 5 membuktikan flow baru, batas layout, skor, pramuat, timer, dan reset.
- REV-06, REV-04, REV-01, REV-03, REV-05, dan REV-09 tetap di luar ruang lingkup agar rencana ini dapat menghasilkan alur baru yang dapat diuji sendiri.

