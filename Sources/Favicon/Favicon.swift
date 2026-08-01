import Dependencies
import Foundation
@preconcurrency import URLRouting

public struct Favicon: Sendable {
    public let router: AnyParserPrinter<RFC_3986.URI.Request.Data, Favicon.Route>
    public let icons: IconSet
    public let configuration: Configuration

    public init(
        router: AnyParserPrinter<RFC_3986.URI.Request.Data, Favicon.Route> =
            Route.Router().eraseToAnyParserPrinter(),
        icons: IconSet,
        configuration: Configuration = .init()
    ) {
        self.router = router
        self.icons = icons
        self.configuration = configuration
    }
}

// MARK: - Serving

extension Favicon {
    /// Returns the data for a given favicon route
    public func data(for route: Route) -> Data? {
        switch route {
        case .favicon:
            return icons.ico

        case .appleTouchIcon(let size):
            switch size {
            case .some(.`180`):
                return icons.appleTouchIcon180 ?? icons.appleTouchIcon
            case .none:
                return icons.appleTouchIcon
            default:
                return icons.appleTouchIcon
            }

        case .appleTouchIconPrecomposed:
            return icons.appleTouchIconPrecomposed

        case .icon(let format):
            switch format {
            case .png(let size):
                switch size {
                case .`16`: return icons.png16
                case .`32`: return icons.png32
                case .`180`: return icons.png180
                case .`192`: return icons.png192
                case .`512`: return icons.png512
                }
            case .svg:
                return icons.svg
            }
        }
    }

    /// Returns the content type for a given route
    public func contentType(for route: Route) -> String {
        switch route {
        case .favicon:
            return "image/x-icon"
        case .icon(let format):
            switch format {
            case .png: return "image/png"
            case .svg: return "image/svg+xml"
            }
        case .appleTouchIcon, .appleTouchIconPrecomposed:
            return "image/png"
        }
    }

    /// Fast path for checking if SVG data exists
    public var hasSVG: Bool {
        icons.svg != nil
    }

    /// Direct access to SVG data for common case
    public var svgData: Data? {
        icons.svg
    }
}

// MARK: - Dependency

extension Dependency.Values {
    public var favicon: Favicon {
        get { self[Favicon.self] }
        set { self[Favicon.self] = newValue }
    }
}

extension Favicon: Dependency.Key.Test {
    public static var testValue: Favicon {
        Favicon(
            router: Route.Router().eraseToAnyParserPrinter(),
            icons: IconSet()
        )
    }
}
