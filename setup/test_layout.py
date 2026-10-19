"""Screen geometry and portable background tests, without modifying live apps."""
import contextlib
import io
from pathlib import Path
import re
import tempfile
import unittest

import configure
from desktop_layout import fit_top_gap

try:
    import tomllib
except ImportError:
    tomllib = None


@unittest.skipIf(tomllib is None, "TOML validation requires Python 3.11+")
class LayoutTests(unittest.TestCase):
    config = "[gaps]\nouter.top = 60 # legacy double-counted notch\n"
    bar = "bar=(\n  height=39\n  y_offset=10\n)\n"

    def test_notch_is_not_counted_twice(self):
        result = fit_top_gap(self.config, self.bar, [{"name": "Built-in Retina Display", "top": 32}])
        rules = tomllib.loads(result)["gaps"]["outer"]["top"]
        self.assertEqual(rules[-1], 59)  # Non-notched fallback.
        pattern, gap = next(iter(rules[0]["monitor"].items()))
        self.assertTrue(re.fullmatch(pattern, "Built-in Retina Display"))
        self.assertEqual(gap, 27)  # 32 reserved + 27 = bar bottom 49 + clearance 10.
        self.assertEqual(result, fit_top_gap(result, self.bar, [{"name": "Built-in Retina Display", "top": 32}]))

    def test_regular_monitor_uses_full_bar_clearance(self):
        result = fit_top_gap(self.config, self.bar, [{"name": "External Monitor", "top": 0}])
        self.assertEqual(tomllib.loads(result)["gaps"]["outer"]["top"], 59)

    def test_monitor_names_are_escaped_as_literal_patterns(self):
        name = 'Built-in [Panel] "A"'
        result = fit_top_gap(self.config, self.bar, [{"name": name, "top": 32}])
        rules = tomllib.loads(result)["gaps"]["outer"]["top"]
        pattern = next(iter(rules[0]["monitor"]))
        self.assertTrue(re.fullmatch(pattern, name))

    def test_warp_background_is_relative_jpeg_and_exists_after_deployment(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            with contextlib.redirect_stdout(io.StringIO()):
                configure.deploy(home, phase="warp")
            theme = (home / ".warp/themes/custom/custom.yaml").read_text()
            match = re.search(r"^\s+path:\s*(\S+)\s*$", theme, re.M)
            self.assertIsNotNone(match)
            path = Path(match[1])
            self.assertFalse(path.is_absolute())
            self.assertNotIn("~", str(path))
            image = home / ".warp/themes" / path
            self.assertEqual(image.suffix, ".jpg")
            self.assertEqual(image.read_bytes()[:3], b"\xff\xd8\xff")


if __name__ == "__main__":
    unittest.main()
