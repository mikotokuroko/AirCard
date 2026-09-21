import Foundation

@main
struct LocalizationTests {
    static func main() throws {
        func check(_ input: String, _ expected: String) {
            let actual = AppLocalization.text(input, language: "zh-Hans")
            precondition(actual == expected, "\(input): expected \(expected), got \(actual)")
            precondition(AppLocalization.text(input, language: "en") == input)
        }
        check("Success!", "成功")
        check("OK", "好的")
        check("&", "&")
        check("Poster Slice (Puzzle)", "图片编辑")
        check("Your card will be detected immediately!", "即将检测卡片")
        check("Add Card Hashes Manually", "手动添加哈希值")
        check("Loaded passcode theme '猫🐱 {count}' (42 assets)", "已载入锁屏密码主题“猫🐱 {count}”（42 个资源）")
        check("[2/3] Writing 6 artwork files (fast batch)...", "[2/3] 正在写入 6 个图片文件（快速批量模式）…")
        check("Unknown diagnostic {raw}", "Unknown diagnostic {raw}")
        check("Failed to export theme: disk error\n/raw/path", "导出主题失败：disk error\n/raw/path")
        precondition(AppLocalization.logText("[12:34:56]   Writing cat.png (2/10)...", language: "zh-Hans") == "[12:34:56]   正在写入 cat.png（2/10）…")
        precondition(AppLocalization.logText("[12:34:56]   [err] No iPhone connected.", language: "zh-Hans") == "[12:34:56]   [错误] 未连接 iPhone。")
        // Check every catalog entry with distinct Unicode values, preserving ordering and placeholders.
        let data = try Data(contentsOf: URL(fileURLWithPath: "Translations/zh-Hans.json"))
        let catalog = try JSONDecoder().decode([String: String].self, from: data)
        let slots = try NSRegularExpression(pattern: #"\{([A-Za-z_]+)\}"#)
        for (source, target) in catalog {
            let names = slots.matches(in: source, range: NSRange(source.startIndex..., in: source)).map {
                (source as NSString).substring(with: $0.range(at: 1))
            }
            var input = source
            var expected = target
            for name in Set(names) {
                input = input.replacingOccurrences(of: "{\(name)}", with: "测试_\(name)")
                expected = expected.replacingOccurrences(of: "{\(name)}", with: "测试_\(name)")
            }
            check(input, expected)
        }
        print("Passed \(catalog.count) catalog entries and localization boundary checks.")
    }
}
