# KIFC-02 — feedback penyelesaian tepat di bawah unsur

Tanggal: 23 Oktober 2026. Status: Ditinjau; menunggu ulasan pemilik dan uji fisik TV.

Setelah tiga unsur lengkap, balon penjelasan kini memakai lebar panel dan berjarak 12 logical px di bawahnya (4 px pada layar pendek). Maskot sukses diperbesar hingga 300 logical px, menyesuaikan ruang tersisa agar tidak menutupi teks; kedua tangan tetap utuh dan potongan tubuh mencapai dasar layar. Instruksi, ukuran panel/foto, penilaian dan waktu baca 14 detik tetap sama. Feedback saat memilih/salah tidak diubah.

Verifikasi: flutter analyze tanpa masalah; seluruh 151 tes lulus. Tes memastikan jarak penjelasan ke panel, tidak bertabrakan dengan maskot, lebar maskot minimal 50% viewport, dasar crop tepat di bawah layar, tiga bahasa serta alur permainan. Log: [suite](../../../build/kifc-02-raised-completion-suite.log), [analyze](../../../build/kifc-02-raised-completion-analyze.log).

## Bukti visual

Semua berikut adalah render UI Flutter dari widget test, bukan foto TV/emulator. Resolusi TV portrait 1080×1920 dan 2160×3840 mensimulasikan tampilan; jangkauan fisik TV 42 inci belum diuji. Empat keadaan × lima ukuran × tiga bahasa disimpan (60 PNG). Tabel ini menunjukkan keadaan selesai yang direvisi.

| Viewport | Indonesia | English | Korea |
| --- | --- | --- | --- |
| 360x640 | [id](../../../build/review-kifc-02-raised-completion/complete-id-360x640.png) | [en](../../../build/review-kifc-02-raised-completion/complete-en-360x640.png) | [ko](../../../build/review-kifc-02-raised-completion/complete-ko-360x640.png) |
| 411x731 | [id](../../../build/review-kifc-02-raised-completion/complete-id-411x731.png) | [en](../../../build/review-kifc-02-raised-completion/complete-en-411x731.png) | [ko](../../../build/review-kifc-02-raised-completion/complete-ko-411x731.png) |
| 720x1280 | [id](../../../build/review-kifc-02-raised-completion/complete-id-720x1280.png) | [en](../../../build/review-kifc-02-raised-completion/complete-en-720x1280.png) | [ko](../../../build/review-kifc-02-raised-completion/complete-ko-720x1280.png) |
| 1080x1920 | [id](../../../build/review-kifc-02-raised-completion/complete-id-1080x1920.png) | [en](../../../build/review-kifc-02-raised-completion/complete-en-1080x1920.png) | [ko](../../../build/review-kifc-02-raised-completion/complete-ko-1080x1920.png) |
| 2160x3840 | [id](../../../build/review-kifc-02-raised-completion/complete-id-2160x3840.png) | [en](../../../build/review-kifc-02-raised-completion/complete-en-2160x3840.png) | [ko](../../../build/review-kifc-02-raised-completion/complete-ko-2160x3840.png) |
