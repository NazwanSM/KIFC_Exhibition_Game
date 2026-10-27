# Fire Prevention Challenge — konsep ikon maskot minimalis v3

- Dibuat: 27 Oktober 2026 melalui GPT Image bawaan, menggunakan skill imagegen dan panduan logo-brand.
- Permintaan: kurangi kesan render AI pada v2; arah minimalis, bagus, dan elegan dengan identitas maskot tetap dikenali.
- Aset: [fire-prevention-app-icon-v3.png](fire-prevention-app-icon-v3.png).
- Referensi: [maskot welcome](../../assets/images/mascot/manggala_agni_welcome.png).
- Pilihan desain: kepala dan topi saja, latar hijau tanpa suasana hutan, warna lebih tenang, bentuk bulu disederhanakan; seragam, glow, dan ornamen api dihilangkan.
- Dua tahap generasi: konsep dari maskot asli, lalu penyederhanaan bentuk dan tekstur. Hanya hasil akhir yang disalin ke repo; PNG tidak diolah ulang. Warna akhir adalah hasil raster generator, bukan bukti empat nilai warna eksak.
- Status: disetujui pemilik proyek pada 27 Oktober 2026 dan diterapkan ke launcher Android, favicon, serta ikon pemasangan web. Turunan dibuat dengan `tool/generate_app_icons.py`; [indeks hasil](app-icon-manifest.json). Versi sebelumnya tetap dipertahankan.

## Prompt konsep

```text
Use case: logo-brand.
Reference image role: identity reference ONLY for the existing orangutan ranger mascot. Redesign its head as a minimal, elegant app-logo mark. Preserve the recognizable orangutan face, gently smiling expression, cheek-fur silhouette and distinctive broad-brim ranger hat. Do not reproduce the reference's full-body illustration or detailed rendering.
Deliver ONE finished square app icon: a beautifully constructed flat graphic of the mascot's HEAD AND HAT ONLY, optically centered on one perfectly solid deep forest green background #193C30. Broad simple closed shapes and a few confident clean curves, balanced negative space, restrained mature editorial character branding. The hat brim's recognizable swoop is the signature silhouette; use a subtle ivory edge or band to separate the dark hat from the background. Face simplified to a warm muted ochre shape, minimal eyes and gentle curved smile; reddish cheek fur simplified to two or three broad shapes, not individual strands. Keep the mascot welcoming and recognizable, not a generic monkey, teddy bear or human.
Strictly limited flat ink palette: forest green #193C30, warm ivory #F3EBDD, muted ochre #D6A065, earthy terracotta #965939. No other hues. All fills completely uniform; crisp raster with vector-clean contours. No gradients, airbrushed shading, material textures, speckle, highlights, glossy 3D, lighting, golden glow, backlit halo, gold rim, excessive saturation or multitone eyes.
Composition: compact single unified mark using approximately 60 percent of canvas width, generous even clear space on all sides, complete hat comfortably inside the central safe area for circular Android masks. The symbol should remain attractive and readable at 48px.
No torso, uniform, hands, badges, flame ornament, shield, scenery, foliage background, frame, circle outline, words, letters, watermark, presentation board or mockup. Full-bleed square background with no pre-rounded corners. Minimal does not mean generic: deliberate asymmetric hat shape and recognizable orangutan facial proportions are essential.
```

## Prompt penyempurnaan

```text
Edit this app-logo concept with one focused refinement: turn it into genuinely FLAT, REDUCED, elegant brand artwork rather than a simplified illustration.
Keep the current orangutan identity, gentle smile, head tilt, distinctive ranger-hat silhouette, green background and centered square composition. Retain the same overall logo, do not add a new concept or extra objects.
Replace every shaded, textured or mottled region with completely UNIFORM solid color, like an SVG logo exported to PNG. Use exactly these FOUR solid inks, plus edge antialiasing only: deep forest #193C30, ivory #F3EBDD, muted ochre #D6A065, earthy terracotta #965939. The entire background must be one identical green from corner to corner. Skin must be one flat muted ochre with no shading, gradients, grain or lighting. Fur must be one flat terracotta.
Reduce the spiky detailed cheek fur to three broad smooth lobes per side and one understated chin curve. Simplify the eyes to clean friendly shapes with a single ivory inset each; remove tiny glints and redundant lower-lip decoration. Give contours a deliberate consistent visual weight, avoid thin dangling strokes. Keep the smiling expression welcoming and the orangutan recognizable. Maintain the hat's swooping brim and ivory band with clean confident curves. Modestly reduce the full mark to about 66 percent of canvas width so there is ample quiet space and adaptive circular masks preserve the hat.
No glow, shadow, soft edges, texture, pattern, paper grain, gradient, shine, 3D, outline halo, photorealism, lettering, borders, flame badge, forest scenery or mockup. Render just the production-looking minimal mark on a solid full-bleed square green background.
```
