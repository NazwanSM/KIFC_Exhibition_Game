"""Export the owner-approved v3 PNG to Android/web icons without redesigning it.

Run from any directory: python tool/generate_app_icons.py
Requires Pillow (asset tooling only, not an application dependency).
"""

from hashlib import sha256
import json
from pathlib import Path
from statistics import median

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "design/branding/fire-prevention-app-icon-v3.png"
RES = ROOT / "android/app/src/main/res"
WEB = ROOT / "web"
source = Image.open(SOURCE).convert("RGB")
if source.width != source.height:
    raise ValueError("The approved source must be square; do not stretch or crop it")

# Match the generated artwork's actual edge color, rather than recoloring it.
edge = [source.getpixel((x, y)) for x in range(source.width)
        for y in (0, source.height - 1)]
edge += [source.getpixel((x, y)) for y in range(source.height)
         for x in (0, source.width - 1)]
background = tuple(round(median(pixel[i] for pixel in edge)) for i in range(3))
background_hex = "#%02X%02X%02X" % background
outputs = []


def save(image, path, role):
    path.parent.mkdir(parents=True, exist_ok=True)
    image.save(path, optimize=True)
    outputs.append({"path": path.relative_to(ROOT).as_posix(),
                    "pixels": list(image.size), "mode": image.mode,
                    "role": role, "sha256": sha256(path.read_bytes()).hexdigest()})


for density, factor in (("mdpi", 1), ("hdpi", 1.5), ("xhdpi", 2),
                        ("xxhdpi", 3), ("xxxhdpi", 4)):
    folder = RES / ("mipmap-" + density)
    size = round(48 * factor)
    save(source.resize((size, size), Image.Resampling.LANCZOS),
         folder / "ic_launcher.png", "Android legacy launcher")
    # Android uses a 108dp layer, with a normally visible central 72dp region.
    # Keep the entire approved square in that region; its own margins protect
    # the head/hat within the 66dp safe circle. No background removal/retouching.
    layer_size = round(108 * factor)
    artwork_size = round(72 * factor)
    layer = Image.new("RGBA", (layer_size, layer_size), (0, 0, 0, 0))
    inset = (layer_size - artwork_size) // 2
    layer.paste(source.resize((artwork_size, artwork_size), Image.Resampling.LANCZOS),
                (inset, inset))
    save(layer, folder / "ic_launcher_foreground.png", "Android adaptive foreground")

for size in (192, 512):
    save(source.resize((size, size), Image.Resampling.LANCZOS),
         WEB / "icons" / f"Icon-{size}.png", "Web installation icon")
    # Extra margin protects all identifying strokes within the PWA safe circle.
    maskable = Image.new("RGB", (size, size), background)
    content_size = round(size * .9)
    inset = (size - content_size) // 2
    maskable.paste(source.resize((content_size, content_size), Image.Resampling.LANCZOS),
                   (inset, inset))
    save(maskable, WEB / "icons" / f"Icon-maskable-{size}.png", "Web maskable icon")

save(source.resize((64, 64), Image.Resampling.LANCZOS),
     WEB / "favicon.png", "Browser favicon")
save(source.resize((180, 180), Image.Resampling.LANCZOS),
     WEB / "icons" / "apple-touch-icon.png", "Apple touch icon")

colors = RES / "values" / "icon_colors.xml"
colors.write_text('<?xml version="1.0" encoding="utf-8"?>\n'
                  '<resources>\n'
                  f'    <color name="ic_launcher_background">{background_hex}</color>\n'
                  '</resources>\n', encoding="utf-8")

manifest = {"source": SOURCE.relative_to(ROOT).as_posix(),
            "sourceSha256": sha256(SOURCE.read_bytes()).hexdigest(),
            "background": background_hex,
            "operations": "Proportional resizing and safe-area padding only; original PNG unchanged.",
            "outputs": outputs}
(ROOT / "design/branding/app-icon-manifest.json").write_text(
    json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"icons": len(outputs), "background": background_hex,
                  "sourceSha256": manifest["sourceSha256"]}, indent=2))
