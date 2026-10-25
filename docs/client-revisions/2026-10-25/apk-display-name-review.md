# KIFC-X03 — nama aplikasi Android

Temuan pemeriksaan paket 25 Oktober 2026: launcher Android menampilkan nama internal `fire_prevention_challenge`. Label aplikasi kini `Fire Prevention Challenge`, sesuai judul web dan game. ID paket, ikon, urutan layar, isi, audio, timer dan skor tidak diubah.

Verifikasi terhadap APK hasil build, bukan hanya manifest sumber: `aapt dump badging` sebelum koreksi menampilkan label internal; sesudahnya menampilkan `application-label:'Fire Prevention Challenge'`. Build release berhasil, tanda tangan diverifikasi dan instalasi pembaruan pada emulator berhasil. Paket review memakai versionName `1.0.1`, versionCode `20261025`, minSdk24 dan targetSdk36. Kunci masih Android Debug; ini paket review, bukan paket distribusi produksi bertanda tangan pemilik.

53 hash aset offline cocok. APK 75.532.455 byte, SHA256 `e01e1367d5ec3e47fecddf870361ec764c6dc3ef440611087049130ac4ba4fba`. Bukti: `build/review-e2e-2026-10-25/apk-metadata-before.txt`, `apk-metadata-final.txt`, `apk-release-final.log`, `apk-signature-final.txt` dan `release-apk-verification.json`. Perjalanan menyeluruh paket final dilaporkan terpisah dalam review E2E.
