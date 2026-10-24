"""Small ADB review helper. Reads real UIAutomator nodes; no private app hooks.
Run review journeys from Python using AndroidReview; screenshots are emulator
captures, never evidence of physical TV reach or speaker comfort.
"""
from pathlib import Path
import json
import re
import subprocess
import time
import xml.etree.ElementTree as ET


class AndroidReview:
    package = "id.kifc.fire_prevention_challenge"

    def __init__(self, output, serial="emulator-5554", adb="D:/Android/Sdk/platform-tools/adb.exe"):
        self.output = Path(output)
        self.output.mkdir(parents=True, exist_ok=True)
        self.command = [adb, "-s", serial]
        self.events = json.loads((self.output / "events.json").read_text(encoding="utf-8")) if (self.output / "events.json").exists() else []
        self.nodes = []
        try:
            self.fast_hierarchy = "kifc-ui.jar" in self.adb("shell", "ls", "/data/local/tmp/kifc-ui.jar")
        except subprocess.CalledProcessError:
            self.fast_hierarchy = False

    def adb(self, *args, timeout=35):
        return subprocess.check_output(self.command + list(args), timeout=timeout).decode("utf-8", errors="replace")

    def record(self, action, **fields):
        self.events.append({"time": time.time(), "action": action, **fields})
        (self.output / "events.json").write_text(json.dumps(self.events, indent=2, ensure_ascii=False), encoding="utf-8")

    @staticmethod
    def label(node):
        return " ".join((node.get("text") or node.get("content-desc") or "").split())

    @staticmethod
    def center(node):
        x1, y1, x2, y2 = map(int, re.findall(r"\d+", node["bounds"]))
        return (x1 + x2) // 2, (y1 + y2) // 2

    def dump(self):
        for attempt in range(3):
            if self.fast_hierarchy:
                status = self.adb("shell", "uiautomator", "runtest", "/data/local/tmp/kifc-ui.jar",
                                  "/system/framework/android.test.runner.jar", "/system/framework/android.test.base.jar",
                                  "-c", "id.kifc.review.KifcDump")
                ready = "OK (1 test)" in status and "FAILURES" not in status and "aborted" not in status
                filename = "/data/local/tmp/local/tmp/kifc-fast.xml"
            else:
                status = self.adb("shell", "uiautomator", "dump", "--compressed", "/sdcard/kifc-review.xml")
                ready = "dumped to" in status
                filename = "/sdcard/kifc-review.xml"
            if ready:
                break
            if attempt == 2:
                raise RuntimeError("UIAutomator did not produce a fresh hierarchy: " + status)
            time.sleep(.3)
        xml = self.adb("shell", "cat", filename)
        self.nodes = [dict(n.attrib) for n in ET.fromstring(xml).iter("node")]
        return self.nodes

    def find(self, label, *, contains=False, clickable=False):
        matches = [n for n in self.nodes if
                   ((label in self.label(n)) if contains else (label == self.label(n)))
                   and (not clickable or n.get("clickable") == "true")
                   and n.get("enabled", "true") == "true"]
        if not matches:
            raise LookupError(f"Missing enabled UI node {label!r}; visible: {[self.label(n) for n in self.nodes if self.label(n)]}")
        return matches[0]

    def wait(self, label, *, contains=False, clickable=False, timeout=30):
        deadline = time.monotonic() + timeout
        while True:
            try:
                self.dump()
                return self.find(label, contains=contains, clickable=clickable)
            except (LookupError, RuntimeError):
                if time.monotonic() >= deadline:
                    raise
                time.sleep(.25)

    def tap(self, label, *, contains=False, clickable=False, refresh=True):
        if refresh:
            self.wait(label, contains=contains, clickable=clickable)
        node = self.find(label, contains=contains, clickable=clickable)
        x, y = self.center(node)
        self.adb("shell", "input", "tap", str(x), str(y))
        self.record("tap", label=label, x=x, y=y)
        time.sleep(.25)

    def tap_at(self, x, y):
        self.adb("shell", "input", "tap", str(x), str(y))
        self.record("tap-coordinate", x=x, y=y)
        time.sleep(.25)

    def drag(self, source, target):
        x1, y1 = self.center(source)
        x2, y2 = self.center(target)
        self.adb("shell", "input", "swipe", str(x1), str(y1), str(x2), str(y2), "700")
        self.record("drag", source=self.label(source), target=self.label(target), coordinates=[x1, y1, x2, y2])
        time.sleep(.3)

    def capture(self, name, *, hierarchy=False):
        if hierarchy:
            self.dump()
        time.sleep(.35)
        image = subprocess.check_output(self.command + ["exec-out", "screencap", "-p"], timeout=30)
        (self.output / (name + ".png")).write_bytes(image)
        if hierarchy:
            (self.output / (name + ".json")).write_text(json.dumps(self.nodes, indent=2, ensure_ascii=False), encoding="utf-8")
        self.record("capture", name=name, source="Android emulator; real APK")

    def log(self, name="app-logcat.txt"):
        pid = self.adb("shell", "pidof", self.package).strip()
        content = self.adb("logcat", "-d", "--pid=" + pid, timeout=45)
        (self.output / name).write_text(content, encoding="utf-8")
        return content
