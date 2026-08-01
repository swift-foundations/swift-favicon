import URLRouting

extension Favicon.Route {
    // Matches/prints ONE path segment (the icon filename) — a `Path { }` component
    // parser (`Input == Substring`, matching `TranslatedString`'s W2-migration
    // pattern), not a router-level parser. `Path.Builder.Component` (public, inside
    // swift-url-routing) is what wraps a component's own error into
    // `RFC_3986.URI.Routing.Error` on the way out; that type's initializer is
    // `@usableFromInline internal` (`URI.RoutingError.swift:27`), so an external
    // consumer package cannot construct it directly — the original implementation's
    // router-level shape (operating on the full `URLRequestData`, throwing local
    // anonymous `ParseError` structs) could not be typed-throws-migrated as-is.
    // `Parser.Match.Error.literalMismatch` is the institute-wide vocabulary for
    // exactly this "matched against a fixed set of literals" failure shape.
    struct IconPathParser: Parser.Bidirectional {
        typealias Input = Substring
        typealias Buffer = Substring
        typealias Output = Favicon.Route.Format
        typealias Failure = Parser.Match.Error
    }
}

extension Favicon.Route.IconPathParser {
    func parse(_ input: inout Substring) throws(Failure) -> Favicon.Route.Format {
        switch input {
        case "icon.svg":
            input.removeFirst(input.count)
            return .svg
        case "icon-16x16.png":
            input.removeFirst(input.count)
            return .png(.`16`)
        case "icon-32x32.png":
            input.removeFirst(input.count)
            return .png(.`32`)
        case "icon-180x180.png":
            input.removeFirst(input.count)
            return .png(.`180`)
        case "icon-192x192.png":
            input.removeFirst(input.count)
            return .png(.`192`)
        case "icon-512x512.png":
            input.removeFirst(input.count)
            return .png(.`512`)
        default:
            throw .literalMismatch(expected: "recognized icon path", found: String(input))
        }
    }

    func print(_ output: Favicon.Route.Format, into input: inout Substring) throws(Failure) {
        let literal: String
        switch output {
        case .svg:
            literal = "icon.svg"
        case .png(let size):
            switch size {
            case .`16`:
                literal = "icon-16x16.png"
            case .`32`:
                literal = "icon-32x32.png"
            case .`180`:
                literal = "icon-180x180.png"
            case .`192`:
                literal = "icon-192x192.png"
            case .`512`:
                literal = "icon-512x512.png"
            }
        }
        input = Substring(literal) + input
    }

    borrowing func serialize(
        _ output: Favicon.Route.Format,
        into buffer: inout Substring
    ) throws(Failure) {
        // Forward-append dual of `print`'s prepend (byte-equal per the
        // coder-unification spike laws).
        var literal: Substring = ""
        try print(output, into: &literal)
        buffer += literal
    }
}
