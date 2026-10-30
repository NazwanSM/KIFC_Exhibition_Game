"""Offline APK journey through real Android input and UIAutomator.
Example: python tool/android_journey.py --lang id --output build/review-kifc-x03-latest/id-host
Requires an already installed current APK and a running portrait emulator.
"""
import argparse
import json
from pathlib import Path
import re
import sys
import time
from android_review import AndroidReview

STRINGS = {
    "start": ("Mulai Tantangan", "Start Challenge", "도전 시작"),
    "choose": ("Pilih tiga unsur api.", "Choose three elements.", "불의 세 요소를 골라 보세요."),
    "forest": ("Area hutan untuk meletakkan unsur api", "Forest area for dropping fire elements", "불의 요소를 놓는 숲 영역"),
    "water": ("Air", "Water", "물"),
    "spark": ("Percikan api", "Sparks", "불꽃"),
    "wood": ("Kayu kering", "Dry wood", "마른 나무"),
    "air": ("O₂ Oksigen dari udara", "O₂ Oxygen from air", "O₂ 공기 중 산소"),
    "reading": ("Lanjut", "Continue", "계속"),
    "heat": ("Panas", "Heat", "열"),
    "fuel": ("Bahan bakar", "Fuel", "연료"),
    "oxygen": ("Oksigen", "Oxygen", "산소"),
    "next": ("Lanjut", "Continue", "계속"),
    "definition": ("Tapi, Apa Itu Kebakaran Hutan?", "What Is a Forest Fire?", "산불이란 무엇일까요?"),
    "quiz": ("Mulai Kuis", "Start Quiz", "퀴즈 시작"),
    "wrongForest": ("A. Hutan mangrove", "A. Mangrove forest", "A. 맹그로브 숲"),
    "rightForest": ("B. Hutan rawa gambut", "B. Peat swamp forest", "B. 이탄습지 숲"),
    "human": ("Aktivitas manusia", "Human activity", "사람의 행동"),
    "natural": ("Faktor alam", "Natural factor", "자연 현상"),
    "card": ("Kartu", "Card", "카드"),
    "impacts": ("Kenali Dampaknya", "Explore the Impacts", "영향 알아보기"),
    "haze": ("Kabut asap", "Haze", "연무"),
    "ecosystem": ("Kerusakan ekosistem", "Ecosystem damage", "생태계 훼손"),
    "emissions": ("Emisi karbon tinggi", "High carbon emissions", "많은 탄소 배출"),
    "subsidence": ("Penurunan tinggi permukaan tanah atau subsidens", "Lower ground surface (subsidence)", "지표면 높이 감소 (지반 침하)"),
    "clean": ("Peningkatan kualitas udara", "Improved air quality", "대기 질 개선"),
    "result": ("Lihat Hasil Akhir", "See Overall Result", "전체 결과 보기"),
    "finish": ("Selesai", "Closing Message", "완료"),
    "again": ("Main Lagi", "Play Again", "다시 하기"),
    "sound": ("Pengaturan suara", "Sound settings", "소리 설정"),
    "on": ("Suara aktif", "Sound on", "소리 켜기"),
    "close": ("Tutup", "Close", "닫기"),
    "back": ("Kembali", "Back", "뒤로"),
}


def run(language, output, build_mode="debug"):
    index = ["id", "en", "ko"].index(language)
    label = lambda key: STRINGS[key][index]
    r = AndroidReview(output)
    r.adb("shell", "am", "force-stop", r.package)
    r.adb("logcat", "-c")
    r.adb("shell", "am", "start", "-n", r.package + "/.MainActivity")
    r.wait("Bahasa Indonesia", timeout=45)
    # Accessibility may appear before the cold-start window accepts input.
    time.sleep(1)
    r.tap(["Bahasa Indonesia", "English", "한국어"][index], clickable=True)
    r.wait(label("start"), clickable=True)
    r.capture("welcome")
    r.tap(label("start"), refresh=False, clickable=True)
    r.wait(label("water"))
    r.capture("assembly", hierarchy=True)
    panel = r.find(label("forest"))
    r.drag(r.find(label("water")), panel)
    r.capture("assembly-wrong", hierarchy=True)
    assert any("0/3" in r.label(n) for n in r.nodes), "Wrong drop must not count"
    for key in ["spark", "wood", "air"]:
        r.dump()
        r.drag(r.find(label(key)), panel)
    r.wait(["3/3 unsur", "3/3 elements", "요소 3/3"][index], contains=True)
    r.capture("assembly-complete", hierarchy=True)
    assert any("3/3" in r.label(n) for n in r.nodes)
    r.tap_at(540, 680)  # Completion accepts a deliberate next tap anywhere.
    r.wait(label("reading"), clickable=True)
    r.capture("fire-explanation")
    r.tap(label("reading"), refresh=False, clickable=True)
    r.wait(label("definition"))
    r.capture("reading-definition")
    r.tap(label("next"), refresh=False, clickable=True)
    r.wait(label("next"), clickable=True)
    r.capture("reading-cause")
    r.tap(label("next"), refresh=False, clickable=True)
    r.wait(label("quiz"), clickable=True)
    r.capture("reading-prevention")
    r.tap(label("quiz"), refresh=False, clickable=True)
    r.wait(label("wrongForest"), clickable=True)
    r.capture("peat-quiz")
    r.tap(label("wrongForest"), refresh=False, clickable=True)
    r.capture("peat-hint")
    r.tap(label("rightForest"), clickable=True)
    r.capture("peat-correct")
    r.tap_at(540, 680)
    for number, key in enumerate(["human", "human", "natural", "human"], 1):
        r.wait(label(key), clickable=True)
        r.capture("cause-question-" + str(number))
        r.tap(label(key), refresh=False, clickable=True)
        r.capture("cause-feedback-" + str(number))
        # Feedback now has a 15-second fallback. A separate visitor tap can
        # continue immediately; waiting 2.4s no longer advances the activity.
        r.tap_at(540, 680)
    r.wait(label("card") + " 1.", contains=True, clickable=True)
    r.capture("characteristics-closed")
    for number in range(1, 4):
        r.tap(label("card") + f" {number}.", contains=True, clickable=True)
        r.capture("characteristic-" + str(number))
    r.wait(label("impacts"), clickable=True)
    r.tap(label("impacts"), refresh=False, clickable=True)
    r.wait(label("haze"), clickable=True, timeout=45)
    # One hierarchy supplies the stable positions for the timed selection grid.
    choices = {key: r.find(label(key), clickable=True) for key in ["haze", "ecosystem", "emissions", "subsidence", "clean"]}
    r.capture("final-start")
    for key in ["haze", "clean"]:
        r.tap_at(*r.center(choices[key]))
    r.capture("final-neutral-mixed")
    # Toggle the decoy off, then choose the remaining three correct impacts.
    for key in ["clean", "ecosystem", "emissions", "subsidence"]:
        r.tap_at(*r.center(choices[key]))
    r.capture("final-four-selected")
    r.wait(label("result"), clickable=True, timeout=40)
    r.capture("final-review")
    r.tap(label("result"), refresh=False, clickable=True)
    r.wait(label("finish"), clickable=True)
    r.capture("score")
    score_labels = [r.label(n) for n in r.nodes]
    assert "8" in score_labels and any("/ 8" in s for s in score_labels), score_labels
    r.record("score-assertion", expected=8, maximum=8, labels=score_labels)
    r.tap(label("finish"), refresh=False, clickable=True)
    # Score and closing both expose Play Again; wait out the outgoing frame.
    time.sleep(.6)
    r.wait(label("again"), clickable=True)
    r.capture("closing")
    r.tap(label("again"), refresh=False, clickable=True)
    r.wait(label("water"))
    r.capture("replay-empty", hierarchy=True)
    assert any("0/3" in r.label(n) for n in r.nodes)
    log = r.log()
    cues = re.findall(r"effect=(\w+) state=playing", log)
    if build_mode == "debug":
        assert cues.count("finish") == 1, "Final cue must play once"
        assert cues.count("complete") == 1, "Assembly cue must play once"
        assert log.count("Offline sources ready; 9 fixed players") == 1, "Replay must reuse players"
    assert not re.search(r"AudioPlayerException|E flutter|FATAL EXCEPTION|Unhandled Exception", log), "Inspect app log"
    report = {"language": language, "passed": True, "score": 8, "maximum": 8,
              "buildMode": build_mode,
              "finishCues": cues.count("finish") if build_mode == "debug" else None,
              "sourcePreparations": 1 if build_mode == "debug" else None,
              "effectCounts": {cue: cues.count(cue) for cue in sorted(set(cues))} if build_mode == "debug" else None,
              "audioCueLogAssessed": build_mode == "debug",
              "source": "Real " + build_mode + " APK, API35 emulator,1080x1920,density420,host GPU"}
    (r.output / "result.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(json.dumps(report), flush=True)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lang", choices=["id", "en", "ko"], required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--build-mode", choices=["debug", "release"], default="debug",
                        help="Release omits debug cue counters; audio evidence must be recorded separately.")
    args = parser.parse_args()
    run(args.lang, args.output, args.build_mode)
