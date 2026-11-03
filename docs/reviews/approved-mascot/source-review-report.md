# PointIdle mengikuti pose dan viewport revisi pengguna

Basis utama adalah kondisi LIVE Blender pada Manggala_PRESENTING_REVIEW_revisi.blend, frame 1, termasuk perubahan yang belum disimpan. Pengguna mengonfirmasi cakupan hanya PointIdle. Pose tidak diambil ulang dari template presenting sebelumnya.

## Preservasi perubahan pengguna

Sebelum menyentuh timeline, semua matrix_basis dan evaluated pose matrices tulang, transform rig, serta View3D view/projection matrix disalin ke LIVE_USER_POSE_AND_VIEW.json. Screenshot kondisi yang diamati disimpan sebagai USER_VIEWPORT_CAPTURE.png. Save Copy membuat LIVE_USER_UNSAVED_BACKUP.blend tanpa mengganti filepath atau menimpa file pengguna. Pengerjaan berikutnya dilakukan pada sesi Blender background terpisah; scene desktop tidak diganti.

Live capture dan save-copy dilakukan melalui addon Blender MCP yang sudah aktif pada port 9876. Screenshot memakai Computer Use. Sumber ini kemudian dipakai secara eksplisit untuk membangun file review baru.

## Pose dan napas

Seluruh pose live menjadi basis frame pertama yang baru. Breathing/sway berasal dari action Idle yang sudah ada, ditambahkan relatif terhadap basis pengguna, bukan mereset karakter ke generic rest pose. Pose lokal lengan/jari dan neck dipertahankan. Orientasi dunia kepala dan kedua telapak dikompensasi terhadap gerak parent agar tidak kembali mengikuti arah idle lama. Posisi kepala/tangan tetap mengikuti rantai tulang dan napas sehingga tidak menjadi floating/frozen attachment.

Hasil 901 frame, 30 fps, 30 detik:

- Galat matrix pose frame pertama terhadap pose live maksimum sekitar 4,17e-7.
- Penyimpangan arah dunia kepala maksimum sekitar 0,000015 derajat.
- Penyimpangan arah telapak kiri/kanan maksimum sekitar 0,000029/0,000035 derajat.
- Pose dan mouth values pada akhir loop cocok dengan awal (galat nol).
- Kepala tetap bergerak kecil mengikuti torso: gerak vertikal sekitar 8 mm, dengan sway lateral dari Idle yang sudah tersedia. Arah menghadapnya tetap.
- Mulut tetap tersenyum tertutup. PointIdle_Mouth tidak diubah.

Action lama disimpan sebagai ARCHIVE_UserRevision_PointIdle. Lima skeletal actions lain (Idle/Talk/Wave/Happy/Feedback) dan enam mouth actions memiliki fingerprint keyframe/handles identik dengan backup pengguna.

## Kamera sesuai viewport

Viewport pengguna adalah User Perspective, bukan tampilan CAM-front. Karena itu, dibuat kamera baru CAM-UserApprovedView dengan inverse view matrix dan projection matrix yang dikalibrasi terhadap viewport yang benar.

- Aspect native viewport/render: 2100×1009 (sekitar 2,08127).
- Posisi kamera Blender Z-up: sekitar (-1,2023, -3,1376, 1,2734).
- Lens render: 25 mm, horizontal sensor 36 mm. Angka ini adalah hasil pencocokan projection matrix, bukan menyalin mentah angka lens viewport.
- Effective vertical field of view: sekitar 0,666112 radian.
- Galat projection matrix terhadap viewport: nol pada precision yang diperiksa.
- Galat proyeksi landmark head/hands/hips/feet kurang dari 0,001 pixel pada ukuran native.

APPROVED_CAMERA_SETUP.json menyimpan matrix, effective FOV, aspect, near/far dan coordinate convention. Kamera aktif dalam .blend adalah CAM-UserApprovedView; kamera yang sama ikut diseleksi dan diekspor ke GLB. Renderer game perlu memilih kamera ini atau menerapkan transform/FOV yang sama; tidak diasumsikan loader otomatis menggunakannya. Framing persis memerlukan aspect yang sama atau letterboxing.

Pencocokan ini berlaku untuk posisi, sudut dan framing kamera serta pose. Scene render memakai lighting studio yang sebelumnya ada; grid, bones dan garis helper editor tidak dirender. Ini bukan klaim pixel-identical dengan lighting Material Preview editor. Tidak ada repaint/PBR restyling untuk menutupi perbedaan lighting.

## Integritas dan export

Fingerprint dua mesh, vertices, topology, UV, normals, weights, shape key coordinates, packed images, materials, rest skeleton dan transform objek cocok dengan backup live. Tidak ada perubahan geometry, badge, logo atau struktur rig.

Seluruh 901 frame PointIdle diperiksa untuk clearance grid badge: signed front gap sekitar 0,419–1,458 mm, tanpa negative front gap pada grid. Ini bukan pembuktian seluruh face/accessory bebas collision pada segala pose.

GLB self-contained sekitar 7,03 MB memuat enam klip bernama tetap, masing-masing 30 detik, dua mesh, skeleton 66 tulang, morph targets, packed textures/logo asli serta satu kamera acuan. Exact bytes artwork JPEG logo dipertahankan.

Clean-scene reimport pada 30 fps lolos untuk tiga belas sampel nonperiodik per klip. Galat body surface maksimum kurang dari 3 mikrometer dan galat morph nol. Galat camera world matrix maksimum sekitar 1,71e-7; projection matrix reimport cocok tanpa selisih.

## Review dan batas

PointIdle_USER_POSE_VIEW_30s_preview.mp4 memperlihatkan 30 detik pada sudut yang diminta. Data Blender/GLB 30 fps; MP4 review 12 fps pada ukuran viewport asli, ditambah satu row padding agar tinggi video genap. Padding tidak meregangkan atau mengubah proyeksi isi render.

USER_APPROVED_POSE_CAMERA_REFERENCE.png adalah render pose live yang dipulihkan, sedangkan USER_MATCH_1.png adalah frame pertama animasi baru. first_frame_render_comparison.json membandingkan keduanya dengan kamera/lighting sama. Contact sheet sepanjang playback diperiksa agen; penilaian gerak real-time manusia tetap diperlukan untuk approval artistik.

Verdict: kandidat review yang mempertahankan pose tangan, arah kepala, dan kamera pengguna sambil tetap bernapas. Hanya PointIdle direvisi. File revisi pengguna dan versi sebelumnya tidak ditimpa. Flutter/Android tidak diuji atau dimodifikasi.

File utama: Manggala_USER_POSE_CAMERA_REVIEW.blend dan .glb di folder Review. Backup live dan snapshot tetap berada satu tingkat di atas folder Review.
