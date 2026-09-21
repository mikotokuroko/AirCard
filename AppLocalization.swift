import Foundation

/// Presentation-only localization. Backend messages and model identifiers stay in
/// English so switching languages cannot change device commands or scanner state.
enum AppLocalization {
    static let preferenceKey = "aircard.interfaceLanguage"
    static let defaultLanguage: String = {
        let preferred = Locale.preferredLanguages.first ?? "en"
        return preferred.hasPrefix("zh-Hans") || preferred.hasPrefix("zh-CN") || preferred.hasPrefix("zh-SG") ? "zh-Hans" : "en"
    }()

    private static let translations: [String: String] = {
        let candidates = [
            Bundle.main.resourceURL?.appendingPathComponent("Translations/zh-Hans.json"),
            URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                .appendingPathComponent("Translations/zh-Hans.json")
        ]
        for case let url? in candidates {
            if let data = try? Data(contentsOf: url),
               let catalog = try? JSONDecoder().decode([String: String].self, from: data) {
                return catalog
            }
        }
        return [:]
    }()

    private struct Template {
        let regex: NSRegularExpression
        let names: [String]
        let translation: String
    }

    private static let placeholder = try! NSRegularExpression(pattern: #"\{([A-Za-z_]+)\}"#)
    private static let templates: [Template] = translations.keys.sorted {
        // Prefer specific messages over generic "{tool} failed: {error}" patterns.
        $0.count == $1.count ? $0 < $1 : $0.count > $1.count
    }.compactMap { source in
        let matches = placeholder.matches(in: source, range: NSRange(source.startIndex..., in: source))
        guard !matches.isEmpty else { return nil }
        let ns = source as NSString
        var pattern = "^"
        var names: [String] = []
        var offset = 0
        for match in matches {
            pattern += NSRegularExpression.escapedPattern(for: ns.substring(with: NSRange(location: offset, length: match.range.location - offset)))
            pattern += "(.*?)"
            names.append(ns.substring(with: match.range(at: 1)))
            offset = NSMaxRange(match.range)
        }
        pattern += NSRegularExpression.escapedPattern(for: ns.substring(from: offset)) + "$"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else { return nil }
        return Template(regex: regex, names: names, translation: translations[source]!)
    }

    static func text(_ source: String, language: String) -> String {
        guard language == "zh-Hans" else { return source }
        if let translated = translations[source] { return translated }
        let range = NSRange(source.startIndex..., in: source)
        for template in templates {
            guard let match = template.regex.firstMatch(in: source, range: range), match.range == range else { continue }
            var values: [String: String] = [:]
            for (index, name) in template.names.enumerated() {
                values[name] = (source as NSString).substring(with: match.range(at: index + 1))
            }
            // Replace from the end: user values containing braces remain untouched.
            let result = NSMutableString(string: template.translation)
            let slots = placeholder.matches(in: template.translation, range: NSRange(location: 0, length: result.length))
            for slot in slots.reversed() {
                let name = (template.translation as NSString).substring(with: slot.range(at: 1))
                result.replaceCharacters(in: slot.range, with: values[name] ?? "{\(name)}")
            }
            return result as String
        }
        // Card progress is prefixed by the view model, outside the backend message.
        if let prefix = source.range(of: #"^\[\d+/\d+\] "#, options: .regularExpression) {
            return String(source[prefix]) + text(String(source[prefix.upperBound...]), language: language)
        }
        return source
    }

    static func logText(_ source: String, language: String) -> String {
        guard language == "zh-Hans" else { return source }
        var body = source
        var prefix = ""
        if let timestamp = body.range(of: #"^\[\d{2}:\d{2}:\d{2}\] "#, options: .regularExpression) {
            prefix = String(body[timestamp])
            body = String(body[timestamp.upperBound...])
        }
        let indentation = String(body.prefix(while: { $0 == " " }))
        body.removeFirst(indentation.count)
        if body.hasPrefix("[err] ") {
            return prefix + indentation + "[错误] " + text(String(body.dropFirst(6)), language: language)
        }
        if body.hasPrefix("ERROR: ") {
            return prefix + indentation + "错误：" + text(String(body.dropFirst(7)), language: language)
        }
        return prefix + indentation + text(body, language: language)
    }
}
