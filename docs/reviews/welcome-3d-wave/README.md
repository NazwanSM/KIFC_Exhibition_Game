# Welcome 3D Wave — uji prototipe

Build web Flutter dengan `--dart-define=WELCOME_3D_TEST=true`; tangkapan browser lokal, bukan foto perangkat. Gambar dibekukan pada sekitar 1,3 detik animasi Wave untuk melihat pose. Resolusi viewport: 411×731, 1080×1920, 2160×3840. Pengukuran viewport tidak memvalidasi keterjangkauan fisik.

Renderer memuat GLB lokal dan mendeteksi Wave; playback satu kali mencapai 3,6 detik. Visual masih kecil dan agak buram. Pengujian Android, Tizen, performa hardware dan kondisi offline menyeluruh belum dilakukan.

## Kamera depan

Kamera prototipe kini diatur eksplisit ke `0deg 90deg 105%`; runtime browser mengonfirmasi theta 0, phi pi/2, autoRotate false dan cameraControls false. Capture `front-411.png`, `front-1080.png`, `front-2160.png` memakai kamera ini. Kamera horizontal dan frontal; rotasi kepala animasi Wave belum dikunci. Track lokal mixamorig:Head memiliki 109 key dan perubahan sudut maksimal sekitar 13,64 derajat dari key pertama (bukan pengukuran yaw wajah dunia).
