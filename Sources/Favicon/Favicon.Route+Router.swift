import URLRouting

extension Favicon.Route {
    public struct Router: ParserPrinter & Sendable {
        public init() {}
    }
}

extension Favicon.Route.Router {
    public var body: some URLRouting.Router<Favicon.Route> {
        OneOf {
            // /favicon.ico
            Route(.case(Favicon.Route.cases.favicon)) {
                Path { "favicon.ico" }
            }

            // /apple-touch-icon variants
            //
            // `.appleTouchIcon(size:)` is matched here against two SPECIFIC bound
            // values (.`180` and nil), not the case's payload generically — the
            // pointfree-CasePaths-era `.case(Route.appleTouchIcon(size: .180))`
            // call-as-function-with-a-literal-argument convenience for this isn't
            // vended by the `@Cases`/`Case.Path` engine (`Case.Path<Root, Value>` is
            // a whole-case embed/extract pair, keyed by depth, with no notion of a
            // fixed inner value). Hand-rolling the embed/extract pair via the
            // still-supported `.case(embed:extract:)` closure overload
            // (`Parser.Conversion.Case.swift`) preserves the exact original
            // semantics without changing `Favicon.Route`'s public case shape.
            OneOf {
                // /apple-touch-icon-180x180.png (sized variant)
                Route(
                    .case(
                        embed: { Favicon.Route.appleTouchIcon(size: .`180`) },
                        extract: { route in
                            if case .appleTouchIcon(size: .`180`) = route { () } else { nil }
                        }
                    )
                ) {
                    Path { "apple-touch-icon-180x180.png" }
                }

                // /apple-touch-icon.png (default)
                Route(
                    .case(
                        embed: { Favicon.Route.appleTouchIcon(size: nil) },
                        extract: { route in
                            if case .appleTouchIcon(size: nil) = route { () } else { nil }
                        }
                    )
                ) {
                    Path { "apple-touch-icon.png" }
                }
            }

            // /apple-touch-icon-precomposed.png
            Route(.case(Favicon.Route.cases.appleTouchIconPrecomposed)) {
                Path { "apple-touch-icon-precomposed.png" }
            }

            // Icon routes - use custom parser to handle both SVG and PNG
            Route(.case(Favicon.Route.cases.icon)) {
                Path { Favicon.Route.IconPathParser() }
            }
        }
    }
}
