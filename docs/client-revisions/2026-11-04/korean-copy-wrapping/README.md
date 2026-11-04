# Korean client copy corrections — 4 November 2026

Implemented from the owner's two annotated client screenshots. Source commit: `0a6424312b20879d9dcf45e8493e391918c5a481`.

- Chapter 1 instruction: `불의 세 요소를 고르세요.` → **`산불의 세 가지 요소를 고르세요.`** Both Indonesian/English translation keys use the corrected Korean instruction.
- Welcome: the existing word `원인을` was breaking before its particle `을`. Korean welcome prose now wraps at spaces, keeping each word intact. Display-only Unicode word joiners prevent internal line breaks; translations, narration scripts and accessibility labels retain the original plain text. Indonesian/English rendering and other Korean screens retain their existing wrapping behavior.
- No other Korean wording was rewritten. These changes implement the supplied client annotations; they do not claim a new native-speaker review of all game text.

## Verification

- [Welcome/localization](welcome-tests.txt): 21 tests passed. The existing five-viewport/three-language welcome matrix now checks that `원인을` occupies one line and the accessibility label is the unchanged plain greeting. It also captures the actual assembly screen after the welcome transition has finished.
- [Assembly](assembly-tests.txt): 15 tests passed, five portrait sizes × three languages, including layout and gameplay. [Analysis](analyze.txt): no issues. [Release web build](web-build.txt): succeeded, ID `korean_copy_wrap_20261104`.
- Screenshots are actual Flutter widget renders with static mascot fallbacks, not live browser or physical TV captures. All three languages are saved in `welcome/` as `{id,en,ko}-{width}x{height}.png` and `assembly-{id,en,ko}-{width}x{height}.png`; adjacent JSON files record capture dimensions. No physical TV or Android testing was performed for this text revision.

| Viewport | Korean welcome | Korean Chapter 1 |
| --- | --- | --- |
| 360×640 | [welcome](welcome/ko-360x640.png) | [assembly](welcome/assembly-ko-360x640.png) |
| 411×731 | [welcome](welcome/ko-411x731.png) | [assembly](welcome/assembly-ko-411x731.png) |
| 720×1280 | [welcome](welcome/ko-720x1280.png) | [assembly](welcome/assembly-ko-720x1280.png) |
| 1080×1920 | [welcome](welcome/ko-1080x1920.png) | [assembly](welcome/assembly-ko-1080x1920.png) |
| 2160×3840 | [welcome](welcome/ko-2160x3840.png) | [assembly](welcome/assembly-ko-2160x3840.png) |

Main October revision closure counts remain unchanged pending owner/client review.
