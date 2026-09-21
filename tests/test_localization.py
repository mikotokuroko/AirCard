import io
import json
import re
import unittest
from contextlib import redirect_stdout
from pathlib import Path
from unittest.mock import patch

import localization


class LocalizationTests(unittest.TestCase):
    def test_catalog_preserves_placeholders(self):
        catalog = json.loads((Path(__file__).resolve().parents[1] / 'Translations/zh-Hans.json').read_text())
        for source, translated in catalog.items():
            with self.subTest(source=source):
                self.assertEqual(sorted(re.findall(r'\{([A-Za-z_]+)\}', source)), sorted(re.findall(r'\{([A-Za-z_]+)\}', translated)))
                names = re.findall(r'\{([A-Za-z_]+)\}', source)
                for name in names:
                    source = source.replace('{' + name + '}', '测试_' + name)
                    translated = translated.replace('{' + name + '}', '测试_' + name)
                self.assertEqual(localization.translate(source, 'zh-Hans'), translated)
                self.assertEqual(localization.translate(source, 'en'), source)

    def test_cli_decorations_and_prompt_input(self):
        with patch.dict('os.environ', {'AIRCARD_LANGUAGE': 'zh-Hans'}):
            output = io.StringIO()
            with redirect_stdout(output):
                localization.print_localized('\n[1/5] Searching for connected device...')
            self.assertEqual(output.getvalue(), '\n[1/5] 正在查找已连接的设备…\n')
            self.assertEqual(localization._line('--- [1/3] Card: abc= ---'), '--- [1/3] 卡片：abc= ---')
            with patch('builtins.input', return_value='all') as read:
                self.assertEqual(localization.input_localized('Your choice [all]: '), 'all')
                read.assert_called_once_with('请选择 [all]： ')

    def test_payloads_and_unknown_errors_remain_intact(self):
        self.assertEqual(localization.translate("Loaded passcode theme '猫 {count}' (3 assets)", 'zh-Hans'), '已载入锁屏密码主题“猫 {count}”（3 个资源）')
        self.assertEqual(localization.translate('unknown error: /原始/path', 'zh-Hans'), 'unknown error: /原始/path')


if __name__ == '__main__':
    unittest.main()
