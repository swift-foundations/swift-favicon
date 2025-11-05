import Foundation
import URLRouting

extension Favicon.Route {
    public struct Router: ParserPrinter & Sendable {
        public init() {}

        public var body: some URLRouting.Router<Favicon.Route> {
            OneOf {
                // /favicon.ico
                Route(.case(Favicon.Route.favicon)) {
                    Path { "favicon.ico" }
                }

                // /apple-touch-icon variants
                OneOf {
                    // /apple-touch-icon-180x180.png (sized variant)
                    Route(.case(Favicon.Route.appleTouchIcon(size: .`180`))) {
                        Path { "apple-touch-icon-180x180.png" }
                    }

                    // /apple-touch-icon.png (default)
                    Route(.case(Favicon.Route.appleTouchIcon(size: nil))) {
                        Path { "apple-touch-icon.png" }
                    }
                }

                // /apple-touch-icon-precomposed.png
                Route(.case(Favicon.Route.appleTouchIconPrecomposed)) {
                    Path { "apple-touch-icon-precomposed.png" }
                }

                // Icon routes - use custom parser to handle both SVG and PNG
                Route(.case(Favicon.Route.icon)) {
                    IconPathParser()
                }
            }
        }
    }

    struct IconPathParser: ParserPrinter {
        func parse(_ input: inout URLRequestData) throws -> Favicon.Route.Format {
            guard let first = input.path.first else {
                struct ParseError: Error {}
                throw ParseError()
            }

            switch first {
            case "icon.svg":
                input.path.removeFirst()
                return .svg
            case "icon-16x16.png":
                input.path.removeFirst()
                return .png(.`16`)
            case "icon-32x32.png":
                input.path.removeFirst()
                return .png(.`32`)
            case "icon-180x180.png":
                input.path.removeFirst()
                return .png(.`180`)
            case "icon-192x192.png":
                input.path.removeFirst()
                return .png(.`192`)
            case "icon-512x512.png":
                input.path.removeFirst()
                return .png(.`512`)
            default:
                struct ParseError: Error {}
                throw ParseError()
            }
        }

        func print(_ output: Favicon.Route.Format, into input: inout URLRequestData) throws {
            switch output {
            case .svg:
                input.path.append("icon.svg")
            case .png(let size):
                switch size {
                case .`16`:
                    input.path.append("icon-16x16.png")
                case .`32`:
                    input.path.append("icon-32x32.png")
                case .`180`:
                    input.path.append("icon-180x180.png")
                case .`192`:
                    input.path.append("icon-192x192.png")
                case .`512`:
                    input.path.append("icon-512x512.png")
                }
            }
        }
    }
}
