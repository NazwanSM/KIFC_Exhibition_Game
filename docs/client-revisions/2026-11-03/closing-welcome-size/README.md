# Closing mascot matches welcome — 3 November 2026

Owner requested the final closing mascot use the same size as welcome.

The opening and closing host now both use 230 logical pixels on compact layouts and 275 on regular layouts, with width equal to 62% of height. Closing retains its farewell animation and right-hand position. Tightened closing spacing lets the larger host fit without shrinking text or controls.

Validation: existing closing-layout suite, five portrait sizes × Indonesian/English/Korean, no overflow. [Test output](tests.txt). These are Flutter widget renders using the static mascot fallback; native Android and TV playback are not retested by this layout change.

| Viewport | Indonesian | English | Korean |
| --- | --- | --- | --- |
| 360×640 | [closing](closing-indonesian-360x640.png) | [closing](closing-english-360x640.png) | [closing](closing-korean-360x640.png) |
| 411×731 | [closing](closing-indonesian-411x731.png) | [closing](closing-english-411x731.png) | [closing](closing-korean-411x731.png) |
| 720×1280 | [closing](closing-indonesian-720x1280.png) | [closing](closing-english-720x1280.png) | [closing](closing-korean-720x1280.png) |
| 1080×1920 | [closing](closing-indonesian-1080x1920.png) | [closing](closing-english-1080x1920.png) | [closing](closing-korean-1080x1920.png) |
| 2160×3840 | [closing](closing-indonesian-2160x3840.png) | [closing](closing-english-2160x3840.png) | [closing](closing-korean-2160x3840.png) |
